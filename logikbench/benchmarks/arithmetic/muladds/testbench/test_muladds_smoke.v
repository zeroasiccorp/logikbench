//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muladds (signed multiply-add, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_muladds_smoke;
   localparam DW=8, OW=20;
   reg			 clk=0;
   reg signed [DW-1:0]	 a, b;
   reg signed [OW-1:0]	 c;
   wire signed [OW-1:0]	 out;
   integer		 t, errors, exp;

   always #5 clk=~clk;

   muladds #(.DW(DW), .OW(OW)) dut (.a(a), .b(b), .c(c), .out(out));

   task check;
      input signed [DW-1:0] av;
      input signed [DW-1:0] bv;
      input signed [OW-1:0] cv;
      begin
	 @(posedge clk);
	 a <= av; b <= bv; c <= cv;
	 @(posedge clk); #1;
	 exp = a * b + c;   // native signed integer reference
	 if ($signed(out) !== exp) begin
	    errors = errors + 1;
	    $display("FAIL: a=%0d b=%0d c=%0d got %0d exp %0d",
		     a, b, c, $signed(out), exp);
	 end
      end
   endtask

   integer va, vb, vc;
   initial begin
      errors=0; a=0; b=0; c=0;
      // directed: sign combinations
      check(50, 40, 100);
      check(-50, 40, 100);
      check(50, -40, -100);
      check(-128, -128, 0);
      check(127, 127, -32768);
      // random
      for (t=0; t<100; t=t+1) begin
	 va = $random; vb = $random; vc = $random;
	 check(va[DW-1:0], vb[DW-1:0], vc[OW-1:0]);
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
