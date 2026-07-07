//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for tmr (per-bit 2-of-3 majority voter, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_tmr_smoke;
   localparam DW=8;
   reg		 clk=0;
   reg [DW-1:0]	 a, b, c;
   wire [DW-1:0] out;
   reg [DW-1:0]	 exp;
   integer	 t, k, errors;

   always #5 clk=~clk;

   tmr #(.DW(DW)) dut (.a(a), .b(b), .c(c), .out(out));

   task chk;
      begin
	 @(posedge clk);
	 a <= $random; b <= $random; c <= $random;
	 @(posedge clk); #1;
	 // independent per-bit majority reference
	 for (k=0; k<DW; k=k+1)
	   exp[k] = (a[k] + b[k] + c[k]) >= 2;
	 if (out !== exp) begin
	    errors = errors + 1;
	    $display("FAIL: a=%h b=%h c=%h out=%h exp=%h", a, b, c, out, exp);
	 end
      end
   endtask

   initial begin
      errors=0; a=0; b=0; c=0;
      for (t=0; t<60; t=t+1) chk;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
