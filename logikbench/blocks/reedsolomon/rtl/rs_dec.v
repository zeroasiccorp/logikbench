//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Reed-Solomon RS(544,514) DECODER (KP4, GF(2^10), t=15).
//
// Pipeline: receive the 544-symbol codeword (buffered) while computing the 30
// syndromes; if nonzero, run Berlekamp-Massey (rs_kes) for Lambda, form the
// error evaluator Omega = S*Lambda mod x^2t and the derivative Lambda', then a
// single-pass Chien search + Forney evaluation streams the buffered codeword
// out, XORing the error magnitude at each root location. If the root count does
// not equal deg(Lambda) the codeword is flagged uncorrectable.
//
// Mirrors the validated software reference (rsref.py).
//
//#############################################################################

module rs_dec
  #(parameter M = 10,
    parameter N = 544,
    parameter TWOT = 30,
    parameter NLAM = 16,
    parameter PW = 11) // clog2(N)
   (
    input	       clk,
    input	       rst,
    input	       in_valid,
    input [M-1:0]      in_sym,
    output reg	       out_valid,
    output reg [M-1:0] out_sym,
    output reg	       out_last,
    output reg	       uncorrectable
    );

   // Chien constants: K[j]=alpha^(-(N-1)*j), AJ[j]=alpha^j
   localparam [NLAM*M-1:0] KCON = {
				   10'd534,10'd745,10'd86, 10'd417,10'd90, 10'd369,10'd902,10'd536,
				   10'd486,10'd215,10'd95, 10'd301,10'd671,10'd112,10'd78, 10'd1};
   localparam [NLAM*M-1:0] AJCON = {
				    10'd288,10'd144,10'd72, 10'd36, 10'd18, 10'd9,  10'd512,10'd256,
				    10'd128,10'd64, 10'd32, 10'd16, 10'd8,  10'd4,  10'd2,  10'd1};
   localparam [M-1:0]	   AINV  = 10'd516;    // alpha^-1
   localparam [M-1:0]	   XINIT = 10'd1003;   // alpha^(N-1)

   localparam		   ST_LOAD=3'd0, ST_SYN=3'd1, ST_BM=3'd2, ST_OMEGA=3'd3,
			   ST_PREP=3'd4, ST_OUT=3'd5;

   reg [2:0]		   state;
   reg [PW-1:0]		   cnt;
   reg			   noerr;

   // codeword shift-register buffer: oldest symbol at sr[N-1]
   reg [M-1:0]		   sr [0:N-1];
   wire			   shifting = (state == ST_LOAD && in_valid) || (state == ST_OUT);

   integer		   k;
   always @(posedge clk) begin
      if (shifting) begin
         for (k = N-1; k > 0; k = k - 1) sr[k] <= sr[k-1];
         sr[0] <= (state == ST_LOAD) ? in_sym : {M{1'b0}};
      end
   end

   // ---- syndrome unit ----
   wire             syn_sop = (state == ST_LOAD) && in_valid && (cnt == 0);
   wire		    syn_last = (state == ST_LOAD) && in_valid && (cnt == N-1);
   wire		    s_valid, s_nz;
   wire [TWOT*M-1:0] s_flat;
   rs_syndrome u_syn
     (.clk(clk), .rst(rst), .in_valid(state==ST_LOAD && in_valid),
      .in_sop(syn_sop), .in_last(syn_last), .in_sym(in_sym),
      .s_valid(s_valid), .s_nz(s_nz), .s_flat(s_flat));

   reg [TWOT*M-1:0] S_reg;
   wire [M-1:0]	    Sr [0:TWOT-1];
   genvar	    gi;
   generate
      for (gi = 0; gi < TWOT; gi = gi + 1) begin : g_sr
         assign Sr[gi] = S_reg[gi*M +: M];
      end
   endgenerate

   // ---- Berlekamp-Massey ----
   reg              bm_start;
   wire		    bm_done;
   wire [4:0]	    bm_L;
   wire [NLAM*M-1:0] lam_flat;
   rs_kes u_kes
     (.clk(clk), .rst(rst), .start(bm_start), .s_flat(S_reg),
      .done(bm_done), .L_out(bm_L), .lam_flat(lam_flat));

   reg [NLAM*M-1:0] Lam_reg;
   reg [4:0]	    L_reg;
   wire [M-1:0]	    Lam [0:NLAM-1];
   generate
      for (gi = 0; gi < NLAM; gi = gi + 1) begin : g_lr
         assign Lam[gi] = Lam_reg[gi*M +: M];
      end
   endgenerate

   // ---- Lambda derivative (combinational, no mults): lamp[2k]=Lam[2k+1] ----
   wire [M-1:0] lamp [0:NLAM-1];
   generate
      for (gi = 0; gi < NLAM; gi = gi + 1) begin : g_lamp
         if (gi == NLAM-1)
           assign lamp[gi] = {M{1'b0}};
         else
           assign lamp[gi] = (gi[0] == 1'b0) ? Lam[gi+1] : {M{1'b0}};
      end
   endgenerate

   // ---- Omega = S*Lambda mod x^2t, computed sequentially (16 shared mults) ----
   // one coefficient om[ocnt] = XOR_{j<=ocnt} Lam[j]*S[ocnt-j] per cycle
   reg  [M-1:0] om_reg [0:NLAM-1];
   wire [M-1:0]	om     [0:NLAM-1];
   reg [3:0]	ocnt;
   wire [M-1:0]	omul [0:NLAM-1];
   generate
      for (gi = 0; gi < NLAM; gi = gi + 1) begin : g_omul
         wire [M-1:0] sselo = (gi <= ocnt) ? Sr[ocnt-gi] : {M{1'b0}};
         rs_gfmul u_omul (.a(Lam[gi]), .b(sselo), .product(omul[gi]));
         assign om[gi] = om_reg[gi];
      end
   endgenerate
   reg [M-1:0] omsum;
   integer     eo;
   always @* begin
      omsum = {M{1'b0}};
      for (eo = 0; eo < NLAM; eo = eo + 1) omsum = omsum ^ omul[eo];
   end

   // ---- Chien/Forney accumulators ----
   reg [M-1:0] cL [0:NLAM-1];
   reg [M-1:0] cO [0:NLAM-1];
   reg [M-1:0] cLp [0:NLAM-1];
   reg [M-1:0] Xreg;
   reg [4:0]   rootcnt;

   // per-position evaluations
   reg [M-1:0] lamval, omval, lampval;
   integer     e;
   always @* begin
      lamval = {M{1'b0}}; omval = {M{1'b0}}; lampval = {M{1'b0}};
      for (e = 0; e < NLAM; e = e + 1) begin
         lamval  = lamval  ^ cL[e];
         omval   = omval   ^ cO[e];
         lampval = lampval ^ cLp[e];
      end
   end
   wire [M-1:0] lampinv;
   rs_gfinv u_li (.a(lampval), .inv(lampinv));
   wire [M-1:0] xom, mag;
   rs_gfmul u_xom (.a(Xreg), .b(omval),   .product(xom));
   rs_gfmul u_mag (.a(xom),  .b(lampinv), .product(mag));
   wire root = (lamval == {M{1'b0}}) && !noerr;
   wire [M-1:0]	corr = root ? mag : {M{1'b0}};

   // accumulator step multipliers
   wire [M-1:0]	cLn [0:NLAM-1];
   wire [M-1:0]	cOn [0:NLAM-1];
   wire [M-1:0]	cLpn [0:NLAM-1];
   generate
      for (gi = 0; gi < NLAM; gi = gi + 1) begin : g_step
         rs_gfmul u_sl (.a(cL[gi]),  .b(AJCON[gi*M +: M]), .product(cLn[gi]));
         rs_gfmul u_so (.a(cO[gi]),  .b(AJCON[gi*M +: M]), .product(cOn[gi]));
         rs_gfmul u_sp (.a(cLp[gi]), .b(AJCON[gi*M +: M]), .product(cLpn[gi]));
      end
   endgenerate
   wire [M-1:0] Xn;
   rs_gfmul u_xn (.a(Xreg), .b(AINV), .product(Xn));

   // Chien accumulator initial values: coeff * K[j]
   wire [M-1:0] iL [0:NLAM-1];
   wire [M-1:0]	iO [0:NLAM-1];
   wire [M-1:0]	iLp [0:NLAM-1];
   generate
      for (gi = 0; gi < NLAM; gi = gi + 1) begin : g_init
         rs_gfmul u_il  (.a(Lam[gi]),  .b(KCON[gi*M +: M]), .product(iL[gi]));
         rs_gfmul u_io  (.a(om[gi]),   .b(KCON[gi*M +: M]), .product(iO[gi]));
         rs_gfmul u_ilp (.a(lamp[gi]), .b(KCON[gi*M +: M]), .product(iLp[gi]));
      end
   endgenerate

   // ---- FSM ----
   always @(posedge clk) begin
      if (rst) begin
         state <= ST_LOAD; cnt <= 0; noerr <= 1'b0; bm_start <= 1'b0;
         out_valid <= 1'b0; out_sym <= {M{1'b0}}; out_last <= 1'b0;
         uncorrectable <= 1'b0; rootcnt <= 0;
      end
      else begin
         out_valid <= 1'b0; out_last <= 1'b0; bm_start <= 1'b0;
         case (state)
           ST_LOAD: begin
              if (in_valid) begin
                 if (cnt == N-1) begin cnt <= 0; state <= ST_SYN; end
                 else cnt <= cnt + 1'b1;
              end
           end
           ST_SYN: begin
              if (s_valid) begin
                 S_reg <= s_flat;
                 if (!s_nz) begin
                    noerr <= 1'b1; state <= ST_PREP;
                 end else begin
                    noerr <= 1'b0; bm_start <= 1'b1; state <= ST_BM;
                 end
              end
           end
           ST_BM: begin
              if (bm_done) begin
                 Lam_reg <= lam_flat; L_reg <= bm_L;
                 ocnt <= 0; state <= ST_OMEGA;
              end
           end
           ST_OMEGA: begin
              om_reg[ocnt] <= omsum;
              if (ocnt == NLAM-1) state <= ST_PREP;
              else ocnt <= ocnt + 1'b1;
           end
           ST_PREP: begin
              // init Chien accumulators (om/lamp are combinational now)
              for (k = 0; k < NLAM; k = k + 1) begin
                 cL[k]  <= iL[k];
                 cO[k]  <= iO[k];
                 cLp[k] <= iLp[k];
              end
              Xreg <= XINIT; rootcnt <= 0; cnt <= 0; state <= ST_OUT;
           end
           ST_OUT: begin
              out_sym   <= sr[N-1] ^ corr;
              out_valid <= 1'b1;
              if (root) rootcnt <= rootcnt + 1'b1;
              for (k = 0; k < NLAM; k = k + 1) begin
                 cL[k] <= cLn[k]; cO[k] <= cOn[k]; cLp[k] <= cLpn[k];
              end
              Xreg <= Xn;
              if (cnt == N-1) begin
                 out_last <= 1'b1;
                 uncorrectable <= noerr ? 1'b0 :
                                  ((rootcnt + (root?1'b1:1'b0)) != L_reg);
                 state <= ST_LOAD; cnt <= 0;
              end else
                cnt <= cnt + 1'b1;
           end
         endcase
      end
   end

endmodule
