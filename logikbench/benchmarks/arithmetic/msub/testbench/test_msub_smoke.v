//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for msub (multiply-subtract, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_msub_smoke;
   localparam DW=6, OW=16;
   reg	      clk=0;
   reg [DW-1:0]	a, b;
   reg [OW-1:0]	c;
   wire [OW-1:0] out;
   integer	 t, errors;
   reg [OW-1:0]	 exp;

   always #5 clk=~clk;

   msub #(.DW(DW), .OW(OW)) dut (.a(a), .b(b), .c(c), .out(out));

   task chk;
      begin
         @(posedge clk);
         a <= $random;
         b <= $random;
         c <= $random;
         @(posedge clk); #1;
         exp = (a * b) - c;
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL: a=%h b=%h c=%h got %h exp %h", a, b, c, out, exp);
         end
      end
   endtask

   initial begin
      errors=0; a=0; b=0; c=0;
      for (t=0; t<50; t=t+1) chk;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
