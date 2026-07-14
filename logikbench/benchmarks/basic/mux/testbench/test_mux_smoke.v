//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for mux (binary-select N:1 mux, self-checking).
// Loads each input slice with a known value, then sweeps the binary select and
// checks the output equals the selected slice.
// TESTED: DW=8/N=16, all selects. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_mux_smoke;
   localparam DW = 8, N = 16, SW = $clog2(N);
   reg	      clk = 0;
   reg [SW-1:0]	sel;
   reg [N*DW-1:0] data;
   wire [DW-1:0]  out;
   always #5 clk = ~clk;

   mux #(.DW(DW), .N(N)) dut (.sel(sel), .data(data), .out(out));

   integer          k, errors;
   reg [DW-1:0]	    slice [0:N-1];

   initial begin
      errors = 0; sel = 0; data = 0;
      for (k = 0; k < N; k = k + 1) begin
         slice[k] = $random;
         data[k*DW +: DW] = slice[k];
      end
      for (k = 0; k < N; k = k + 1) begin
         @(posedge clk); sel <= k[SW-1:0];
         @(posedge clk); #1;
         if (out !== slice[k]) begin
            errors = errors + 1;
            $display("FAIL sel=%0d: got %h exp %h", k, out, slice[k]);
         end
      end
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_mux_smoke.vcd");
      $dumpvars(0, test_mux_smoke);
   end
`endif

endmodule
