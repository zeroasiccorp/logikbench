//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muxpri (priority mux, self-checking).
// The lowest-index set select bit wins; hit = OR(sel). Loads input slices and
// checks out/hit against a priority reference over directed and random selects.
// TESTED: DW=8/N=4, directed + random selects. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_muxpri_smoke;
   localparam DW = 8, N = 4;
   reg	      clk = 0;
   reg [N-1:0] sel;
   reg [N*DW-1:0] data;
   wire [DW-1:0]  out;
   wire		  hit;
   always #5 clk = ~clk;

   muxpri #(.DW(DW), .N(N)) dut
     (.sel(sel), .data(data), .out(out), .hit(hit));

   integer          k, t, errors;
   reg [DW-1:0]	    slice [0:N-1];
   reg [DW-1:0]	    eout;
   reg		    ehit;

   task chk;
      input [N-1:0] s;
      integer	    m;
      begin
         eout = {DW{1'b0}}; ehit = 1'b0;
         for (m = 0; m < N; m = m + 1)
           if (s[m] && !ehit) begin eout = slice[m]; ehit = 1'b1; end
         @(posedge clk); sel <= s;
         @(posedge clk); #1;
         if (out !== eout || hit !== ehit) begin
            errors = errors + 1;
            $display("FAIL sel=%b: got out=%h hit=%b exp out=%h hit=%b",
                     s, out, hit, eout, ehit);
         end
      end
   endtask

   initial begin
      errors = 0; sel = 0; data = 0;
      for (k = 0; k < N; k = k + 1) begin
         slice[k] = $random;
         data[k*DW +: DW] = slice[k];
      end
      for (k = 0; k < (1<<N); k = k + 1) chk(k[N-1:0]);   // all 16 patterns
      for (t = 0; t < 8; t = t + 1) chk($random);
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_muxpri_smoke.vcd");
      $dumpvars(0, test_muxpri_smoke);
   end
`endif

endmodule
