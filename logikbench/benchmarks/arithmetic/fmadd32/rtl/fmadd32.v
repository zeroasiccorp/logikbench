//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// fmadd32: single-precision (fp32) fused multiply-add top wrapper. It is a
// thin, parametrized shell around the common 'fmadd' datapath, hard-wired to
// the fp32 field layout by its default parameters (EXP=8, MANT=23). The
// reduced-precision tops (fmadd16, fmadd8) instantiate this module with
// overridden parameters, so the arithmetic lives in one place.
//
//#############################################################################
module fmadd32 #(parameter EXP = 8,  // exponent field width  (fp32)
                 parameter MANT = 23 // mantissa field width   (fp32)
                 )
   (
    input [EXP+MANT:0]	a, // multiplicand
    input [EXP+MANT:0]	b, // multiplier
    input [EXP+MANT:0]	c, // addend
    output [EXP+MANT:0]	r  // round(a*b + c), fused
    );

   fmadd #(.EXP(EXP), .MANT(MANT)) u_fmadd (.a(a), .b(b), .c(c), .r(r));

endmodule

//#############################################################################
// Common fused multiply-add datapath (parametrized by EXP/MANT).
//
// Computes r = round(a*b + c) as a single fused operation: the a*b product is
// kept full width and added to c before a single round-to-nearest-even. The
// format is IEEE-754-like with round-to-nearest-even, but simplified for a
// synthesis benchmark: subnormals are flushed to zero (FTZ) on input and
// output, and the sticky handling in far-apart subtraction is approximate
// (accurate to ~1 ulp), so it is not a fully IEEE-754-compliant unit.
//#############################################################################
module fmadd #(parameter EXP = 8, // exponent field width
               parameter MANT = 7 // mantissa (fraction) field width
               )
   (
    input [EXP+MANT:0]	    a, // multiplicand   (format: 1|EXP|MANT)
    input [EXP+MANT:0]	    b, // multiplier
    input [EXP+MANT:0]	    c, // addend
    output reg [EXP+MANT:0] r  // round(a*b + c), fused
    );

   // Local parameters
   localparam W     = EXP + MANT + 1;    // total width
   localparam MW    = MANT + 1;          // significand width (implicit 1)
   localparam PW    = 2*MW;              // product significand width
   localparam EXTRA = PW + 2;            // low guard bits kept on alignment
   localparam ACCW  = PW + EXTRA + 2;    // accumulator width (~2*PW)
   localparam BIAS  = (1 << (EXP-1)) - 1;

   // Field decode. Subnormals are flushed to zero (FTZ): exp==0 means zero.
   wire	      sa = a[W-1];
   wire	      sb = b[W-1];
   wire	      sc = c[W-1];
   wire [EXP-1:0] ea = a[W-2 -: EXP];
   wire [EXP-1:0] eb = b[W-2 -: EXP];
   wire [EXP-1:0] ec = c[W-2 -: EXP];
   wire [MANT-1:0] fa = a[MANT-1:0];
   wire [MANT-1:0] fb = b[MANT-1:0];
   wire [MANT-1:0] fc = c[MANT-1:0];

   wire		   a_zero = (ea == {EXP{1'b0}});
   wire		   b_zero = (eb == {EXP{1'b0}});
   wire		   c_zero = (ec == {EXP{1'b0}});
   wire		   a_emax = (ea == {EXP{1'b1}});
   wire		   b_emax = (eb == {EXP{1'b1}});
   wire		   c_emax = (ec == {EXP{1'b1}});
   wire		   a_inf = a_emax & (fa == {MANT{1'b0}});
   wire		   b_inf = b_emax & (fb == {MANT{1'b0}});
   wire		   c_inf = c_emax & (fc == {MANT{1'b0}});
   wire		   a_nan = a_emax & (fa != {MANT{1'b0}});
   wire		   b_nan = b_emax & (fb != {MANT{1'b0}});
   wire		   c_nan = c_emax & (fc != {MANT{1'b0}});

   // significands (implicit 1 for normals, 0 for zero/FTZ operands)
   wire [MW-1:0]   siga = a_zero ? {MW{1'b0}} : {1'b1, fa};
   wire [MW-1:0]   sigb = b_zero ? {MW{1'b0}} : {1'b1, fb};
   wire [MW-1:0]   sigc = c_zero ? {MW{1'b0}} : {1'b1, fc};

   wire		   sp = sa ^ sb;               // product sign
   wire		   prod_inf = a_inf | b_inf;

   // Special-value results (override the arithmetic datapath below).
   wire		   inf_x_zero = (a_inf & b_zero) | (b_inf & a_zero);
   wire		   p_is_inf = prod_inf & ~inf_x_zero;
   wire		   inf_m_inf = p_is_inf & c_inf & (sp != sc);
   wire		   res_nan = a_nan | b_nan | c_nan | inf_x_zero | inf_m_inf;
   wire		   res_inf = ~res_nan & (p_is_inf | c_inf);
   wire		   res_isign = p_is_inf ? sp : sc;

   // Datapath variables
   reg [PW-1:0]	   prod;              // A*B
   reg [ACCW-1:0]  op_p, op_c, ssum, norm;
   reg		   pst, cst, salign;   // alignment sticky bits
   reg [MW-1:0]	   mant_full;
   reg [MW:0]	   mrnd;
   reg [MANT-1:0]  fracout;
   reg [EXP-1:0]   ebreg;
   reg		   roundb, stickyb, sbit;
   reg [W-1:0]	   tmpres;

   integer	   p_lsb, c_lsb, maxlsb, common;
   integer	   ps, cs, rs, msb, shl, k, eres, ebias;

   always @(*) begin
      prod = siga * sigb;

      // LSB (unit) exponent of each term, unbiased
      p_lsb = ea + eb - 2*BIAS - 2*MANT;
      c_lsb = ec - BIAS - MANT;
      maxlsb = (p_lsb >= c_lsb) ? p_lsb : c_lsb;
      common = maxlsb - EXTRA;

      // net alignment shifts (>=0 shift left, <0 shift right with sticky)
      ps = EXTRA - (maxlsb - p_lsb);
      cs = EXTRA - (maxlsb - c_lsb);

      // align product term
      pst = 1'b0;
      if (ps >= 0) begin
         op_p = {{(ACCW-PW){1'b0}}, prod} << ps;
      end
      else begin
         rs = -ps;
         if (rs >= PW) begin
            op_p = {ACCW{1'b0}};
            pst  = |prod;
         end
         else begin
            op_p = {{(ACCW-PW){1'b0}}, prod} >> rs;
            pst  = |(prod & ~({PW{1'b1}} << rs));
         end
      end

      // align addend term
      cst = 1'b0;
      if (cs >= 0) begin
         op_c = {{(ACCW-MW){1'b0}}, sigc} << cs;
      end
      else begin
         rs = -cs;
         if (rs >= MW) begin
            op_c = {ACCW{1'b0}};
            cst  = |sigc;
         end
         else begin
            op_c = {{(ACCW-MW){1'b0}}, sigc} >> rs;
            cst  = |(sigc & ~({MW{1'b1}} << rs));
         end
      end

      salign = pst | cst;

      // effective add or subtract (magnitude), pick result sign
      if (sp == sc) begin
         ssum = op_p + op_c;
         sbit = sp;
      end
      else if (op_p >= op_c) begin
         ssum = op_p - op_c;
         sbit = sp;
      end
      else begin
         ssum = op_c - op_p;
         sbit = sc;
      end

      // normalize + round
      if (ssum == {ACCW{1'b0}}) begin
         tmpres = {W{1'b0}};   // exact zero -> +0
      end
      else begin
         msb = 0;
         for (k = 0; k < ACCW; k = k + 1)
           if (ssum[k]) msb = k;
         eres = msb + common;

         shl  = (ACCW-1) - msb;
         norm = ssum << shl;              // leading 1 now at bit ACCW-1

         mant_full = norm[ACCW-1 -: MW];
         roundb    = norm[ACCW-1-MW];
         stickyb   = (|norm[ACCW-1-MW-1 : 0]) | salign;

         // round to nearest even
         mrnd = {1'b0, mant_full} + (roundb & (stickyb | mant_full[0]));
         if (mrnd[MW]) begin              // significand overflow -> 2.0
            eres    = eres + 1;
            fracout = mrnd[MANT:1];
         end
         else begin
            fracout = mrnd[MANT-1:0];
         end

         ebias = eres + BIAS;
         if (ebias >= ((1 << EXP) - 1))
           tmpres = {sbit, {EXP{1'b1}}, {MANT{1'b0}}};   // overflow -> Inf
         else if (ebias <= 0)
           tmpres = {sbit, {(W-1){1'b0}}};               // underflow -> FTZ 0
         else begin
            ebreg  = ebias[EXP-1:0];
            tmpres = {sbit, ebreg, fracout};
         end
      end

      // final special-value selection
      if (res_nan)
        r = {1'b0, {EXP{1'b1}}, 1'b1, {(MANT-1){1'b0}}};
      else if (res_inf)
        r = {res_isign, {EXP{1'b1}}, {MANT{1'b0}}};
      else
        r = tmpres;
   end

endmodule
