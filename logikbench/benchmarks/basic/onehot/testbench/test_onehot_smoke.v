//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for onehot (binary-to-one-hot decoder, self-checking).
// For every binary input value k, checks the output is exactly 1<<k.
// TESTED: DW=8 (3-bit input), all 8 codes. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_onehot_smoke;
   localparam DW = 8, SW = $clog2(DW);
   reg	      clk = 0;
   reg [SW-1:0]	in;
   wire [DW-1:0] out;
   always #5 clk = ~clk;

   onehot #(.DW(DW)) dut (.in(in), .out(out));

   integer        k, errors;
   reg [DW-1:0]	  exp;

   initial begin
      errors = 0; in = 0;
      for (k = 0; k < DW; k = k + 1) begin
         @(posedge clk); in <= k[SW-1:0];
         @(posedge clk); #1;
         exp = {{(DW-1){1'b0}}, 1'b1} << k;
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL in=%0d: got %h exp %h", k, out, exp);
         end
      end
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_onehot_smoke.vcd");
      $dumpvars(0, test_onehot_smoke);
   end
`endif

endmodule
