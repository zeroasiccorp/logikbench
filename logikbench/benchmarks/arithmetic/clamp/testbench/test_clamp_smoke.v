//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for clamp (signed clip to [lo, hi], self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_clamp_smoke;
   localparam DW=8;
   reg	      clk=0;
   reg signed [DW-1:0] a, lo, hi;
   wire signed [DW-1:0]	out;
   integer		t, errors;
   reg signed [DW-1:0]	exp;

   always #5 clk=~clk;

   clamp #(.DW(DW)) dut (.a(a), .lo(lo), .hi(hi), .out(out));

   task check;
      input signed [DW-1:0] av;
      input signed [DW-1:0] lv;
      input signed [DW-1:0] hv;
      begin
         @(posedge clk);
         a  <= av;
         lo <= (lv <= hv) ? lv : hv;    // keep lo <= hi
         hi <= (lv <= hv) ? hv : lv;
         @(posedge clk); #1;
         exp = a;
         if (a < lo)      exp = lo;
         else if (a > hi) exp = hi;
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL: a=%0d lo=%0d hi=%0d got %0d exp %0d",
                     a, lo, hi, out, exp);
         end
      end
   endtask

   initial begin
      errors=0; a=0; lo=0; hi=0;
      // directed: below, above, in-range, and boundary
      check(-100, -10, 10);     // below -> -10
      check( 100, -10, 10);     // above -> 10
      check(   5, -10, 10);     // in range -> 5
      check( -10, -10, 10);     // == lo -> -10
      check(  10, -10, 10);     // == hi -> 10
      // random
      for (t=0; t<80; t=t+1)
        check($random, $random, $random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
