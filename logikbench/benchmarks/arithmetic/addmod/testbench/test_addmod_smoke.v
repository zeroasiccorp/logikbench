//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for addmod (modular adder, self-checking). Inputs are kept
// reduced (a,b < m), as the single conditional-subtract form assumes.
//
//#############################################################################
`timescale 1ns/1ps
module test_addmod_smoke;
   localparam WIDTH=16;
   reg			 clk=0;
   reg [WIDTH-1:0]	 a, b, m;
   wire [WIDTH-1:0]	 result;
   integer		 t, errors;
   reg [WIDTH:0]	 s2;
   reg [WIDTH-1:0]	 exp;
   reg [WIDTH-1:0]	 mr, ar, br;
   reg [31:0]		 r;

   always #5 clk=~clk;

   addmod #(.DW(WIDTH)) dut (.a(a), .b(b), .m(m), .result(result));

   task check;
      input [WIDTH-1:0] mv, av, bv;
      begin
	 @(posedge clk);
	 m <= mv; a <= av; b <= bv;
	 @(posedge clk); #1;
	 s2  = av + bv;		// WIDTH+1 bits, no overflow (av,bv < mv)
	 exp = s2 % mv;
	 if (result !== exp) begin
	    errors = errors + 1;
	    $display("FAIL: (%0d+%0d) mod %0d got %0d exp %0d",
		     av, bv, mv, result, exp);
	 end
      end
   endtask

   initial begin
      errors=0; a=0; b=0; m=1;
      check(100, 30, 40);	// 70  (no wrap)
      check(100, 60, 70);	// 30  (wrap once)
      check(100, 40, 60);	// 0   (sum == m)
      check(1,   0,  0);	// 0   (degenerate modulus)
      for (t=0; t<200; t=t+1) begin
	 r = $random; mr = r[WIDTH-1:0]; if (mr==0) mr = 1;
	 r = $random; ar = r[WIDTH-1:0] % mr;
	 r = $random; br = r[WIDTH-1:0] % mr;
	 check(mr, ar, br);
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_addmod_smoke.vcd");
      $dumpvars(0, test_addmod_smoke);
   end
`endif

endmodule
