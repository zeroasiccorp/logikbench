//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for dffsync (flip-flop with synchronous reset, self-check).
// Clocks random data through and checks q follows d by one cycle; checks that
// reset (synchronous, active high) forces q to 0 on the next edge.
// TESTED: DW=8, data capture + synchronous reset. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_dffsync_smoke;
   localparam DW = 8;
   reg	      clk = 0, reset;
   reg [DW-1:0]	d;
   wire [DW-1:0] q;
   always #5 clk = ~clk;

   dffsync #(.DW(DW)) dut (.clk(clk), .reset(reset), .d(d), .q(q));

   integer        t, errors;
   reg [DW-1:0]	  newd;

   initial begin
      errors = 0; reset = 1; d = 0;
      @(posedge clk); #1;
      if (q !== {DW{1'b0}}) begin
         errors = errors + 1; $display("FAIL: reset q=%h", q);
      end
      reset <= 0;
      // q should capture the d presented at each edge
      for (t = 0; t < 24; t = t + 1) begin
         newd = $random;
         d <= newd;
         @(posedge clk); #1;
         if (q !== newd) begin
            errors = errors + 1;
            $display("FAIL t=%0d: q=%h exp %h", t, q, newd);
         end
      end
      // synchronous reset takes effect on the next edge
      reset <= 1; @(posedge clk); #1;
      if (q !== {DW{1'b0}}) begin
         errors = errors + 1; $display("FAIL sync reset: q=%h", q);
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
