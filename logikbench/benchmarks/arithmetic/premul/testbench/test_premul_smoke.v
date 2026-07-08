//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for premul (pre-adder multiply (a+d)*b, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_premul_smoke;
   localparam DW=6, OW=2*DW+1;
   reg        clk=0;
   reg signed [DW-1:0] a, d, b;
   wire signed [OW-1:0]	out;
   integer		t, errors;
   integer		sa, sd, sb, exp;

   always #5 clk=~clk;

   premul #(.DW(DW), .OW(OW)) dut (.a(a), .d(d), .b(b), .out(out));

   task chk;
      begin
         @(posedge clk);
         a <= $random;
         d <= $random;
         b <= $random;
         @(posedge clk); #1;
         sa = a;  // signed reg into integer sign-extends
         sd = d;
         sb = b;
         exp = (sa + sd) * sb;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL: a=%0d d=%0d b=%0d got %0d exp %0d",
                     a, d, b, $signed(out), exp);
         end
      end
   endtask

   initial begin
      errors=0; a=0; d=0; b=0;
      for (t=0; t<50; t=t+1) chk;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
