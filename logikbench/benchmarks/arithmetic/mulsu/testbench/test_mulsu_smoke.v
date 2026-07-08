//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for mulsu (signed x unsigned multiply, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_mulsu_smoke;
   localparam DW=8, OW=16;
   reg	      clk=0;
   reg signed [DW-1:0] a;
   reg [DW-1:0]	       b;
   wire signed [OW-1:0]	c;
   integer		t, errors;
   integer		sa, ub, exp;

   always #5 clk=~clk;

   mulsu #(.DW(DW), .OW(OW)) dut (.a(a), .b(b), .c(c));

   task chk;
      begin
         @(posedge clk);
         a <= $random;
         b <= $random;
         @(posedge clk); #1;
         sa = a;   // signed reg into integer sign-extends
         ub = b;   // unsigned reg into integer stays non-negative
         exp = sa * ub;
         if ($signed(c) !== exp) begin
            errors = errors + 1;
            $display("FAIL: a=%0d b=%0d got %0d exp %0d",
                     a, b, $signed(c), exp);
         end
      end
   endtask

   initial begin
      errors=0; a=0; b=0;
      for (t=0; t<50; t=t+1) chk;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
