//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for multconst (constant-coefficient multiply, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_multconst_smoke;
   localparam DW=16, OW=2*DW;
   localparam signed [DW-1:0] CONST = 12345;
   reg			 clk=0;
   reg signed [DW-1:0]	 a;
   wire signed [OW-1:0]	 out;
   integer		 t, errors, exp;

   always #5 clk=~clk;

   multconst #(.DW(DW), .CONST(CONST), .OW(OW)) dut (.a(a), .out(out));

   task check;
      input signed [DW-1:0] av;
      begin
	 @(posedge clk);
	 a <= av;
	 @(posedge clk); #1;
	 exp = a * CONST;   // native signed integer reference
	 if ($signed(out) !== exp) begin
	    errors = errors + 1;
	    $display("FAIL: a=%0d got %0d exp %0d", a, $signed(out), exp);
	 end
      end
   endtask

   initial begin
      errors=0; a=0;
      check(0);
      check(1);
      check(-1);
      check(32767);
      check(-32768);
      for (t=0; t<100; t=t+1) check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
