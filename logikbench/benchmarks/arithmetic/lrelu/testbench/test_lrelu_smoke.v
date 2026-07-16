//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for lrelu (leaky ReLU, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_lrelu_smoke;
   localparam DW=16, ASHIFT=7;
   reg	      clk=0;
   reg signed [DW-1:0] in;
   wire signed [DW-1:0]	out;
   integer		t, errors;
   reg signed [DW-1:0]	exp;

   always #5 clk=~clk;

   lrelu #(.DW(DW), .ASHIFT(ASHIFT)) dut (.in(in), .out(out));

   task check;
      input signed [DW-1:0] iv;
      begin
         @(posedge clk);
         in <= iv;
         @(posedge clk); #1;
         exp = (in >= 0) ? in : (in >>> ASHIFT);
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL: in=%0d got %0d exp %0d", in, out, exp);
         end
      end
   endtask

   initial begin
      errors=0; in=0;
      // directed: positive, negative, zero, extremes
      check(1000);
      check(-1000);
      check(0);
      check(-1);
      check(32767);
      check(-32768);
      // random
      for (t=0; t<100; t=t+1)
        check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_lrelu_smoke.vcd");
      $dumpvars(0, test_lrelu_smoke);
   end
`endif

endmodule
