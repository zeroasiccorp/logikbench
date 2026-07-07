//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for fmadd16 (bf16 fused multiply-add, self-checking). The
// golden model computes a*b+c in Verilog 'real' and compares against the RTL
// result decoded to real, allowing 1 ulp and modeling flush-to-zero (FTZ).
// Compile with the fmadd32 block RTL (fmadd16 instantiates fmadd32).
//
//#############################################################################
`timescale 1ns/1ps
module test_fmadd16_smoke;
   localparam EXP=8, MANT=7;
   localparam W=EXP+MANT+1, BIAS=(1<<(EXP-1))-1;

   reg [W-1:0]	 a, b, c;
   wire [W-1:0]	 r;
   integer	 t, errors;
   real		 gold, got, ulp, diff, absg;
   reg [W-1:0]	 va, vb, vc;
   reg [EXP-1:0] er;
   reg		 clk=0;

   always #5 clk=~clk;

   fmadd16 dut (.a(a), .b(b), .c(c), .r(r));

   function real f2r(input [W-1:0] x);
      integer e, s, k; real m; reg [MANT-1:0] f;
      begin
	 s = x[W-1]; e = x[W-2 -: EXP]; f = x[MANT-1:0];
	 if (e==0) f2r = 0.0;
	 else begin
	    m = 1.0;
	    for (k=0;k<MANT;k=k+1) if (f[k]) m = m + (2.0**(k-MANT));
	    f2r = m * (2.0**(e-BIAS));
	    if (s) f2r = -f2r;
	 end
      end
   endfunction

   task mkrand(output [W-1:0] x);
      integer e, k; reg sgn; reg [MANT-1:0] f; reg [EXP-1:0] ereg;
      begin
	 sgn = $random;
	 e   = BIAS + ($random % 3);      // BIAS-2 .. BIAS+2
	 for (k=0;k<MANT;k=k+1) f[k]=$random;
	 ereg = e;
	 x = {sgn, ereg, f};
      end
   endtask

   initial begin
      errors=0; a=0; b=0; c=0;
      for (t=0;t<2000;t=t+1) begin
	 mkrand(va); mkrand(vb); mkrand(vc);
	 @(posedge clk); a<=va; b<=vb; c<=vc;
	 @(posedge clk); #1;
	 gold = f2r(a)*f2r(b) + f2r(c);
	 got  = f2r(r);
	 er   = r[W-2 -: EXP];
	 ulp  = (er==0) ? (2.0**(1-BIAS-MANT)) : (2.0**(er-BIAS-MANT));
	 diff = got-gold; if (diff<0.0) diff=-diff;
	 absg = gold<0.0 ? -gold : gold;
	 if ((absg < (2.0**(1-BIAS))) && (got==0.0)) diff = 0.0;  // FTZ
	 if (diff > ulp*1.0) begin
	    errors=errors+1;
	    if (errors<=8)
	      $display("FAIL a=%h b=%h c=%h r=%h got=%f gold=%f", a,b,c,r,got,gold);
	 end
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
