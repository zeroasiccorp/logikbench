//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for dffasync (flip-flop with async reset, self-checking).
// Checks q follows d by one cycle, and that nreset (asynchronous, active low)
// clears q immediately (between clock edges) without waiting for a clock.
// TESTED: DW=8, data capture + asynchronous reset. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_dffasync_smoke;
   localparam DW = 8;
   reg	      clk = 0, nreset;
   reg [DW-1:0]	d;
   wire [DW-1:0] q;
   always #5 clk = ~clk;

   dffasync #(.DW(DW)) dut (.clk(clk), .nreset(nreset), .d(d), .q(q));

   integer        t, errors;
   reg [DW-1:0]	  newd;

   initial begin
      errors = 0; nreset = 0; d = 8'hA5;
      #3;   // async reset holds q=0 with no clock edge
      if (q !== {DW{1'b0}}) begin
         errors = errors + 1; $display("FAIL: async reset q=%h", q);
      end

      nreset <= 1;
      for (t = 0; t < 24; t = t + 1) begin
         newd = $random;
         d <= newd;
         @(posedge clk); #1;
         if (q !== newd) begin
            errors = errors + 1;
            $display("FAIL t=%0d: q=%h exp %h", t, q, newd);
         end
      end

      // assert async reset between edges -> q clears immediately
      @(negedge clk); nreset = 0; #1;
      if (q !== {DW{1'b0}}) begin
         errors = errors + 1; $display("FAIL: async clear q=%h", q);
      end
      nreset <= 1;

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_dffasync_smoke.vcd");
      $dumpvars(0, test_dffasync_smoke);
   end
`endif

endmodule
