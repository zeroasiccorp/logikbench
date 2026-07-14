//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muxhot (one-hot select mux, self-checking).
// The output is the OR of the selected input slices. Checks each single-hot
// select (out = that input), sel=0 (out=0), and random multi-hot selects
// against an OR reference.
// TESTED: DW=8/N=16, single-hot + zero + random multi-hot. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_muxhot_smoke;
   localparam DW = 8, N = 16;
   reg	      clk = 0;
   reg [N-1:0] sel;
   reg [N*DW-1:0] in;
   wire [DW-1:0]  out;
   always #5 clk = ~clk;

   muxhot #(.DW(DW), .N(N)) dut (.sel(sel), .in(in), .out(out));

   integer          k, j, t, errors;
   reg [DW-1:0]	    slice [0:N-1];
   reg [DW-1:0]	    exp;

   task chk;
      input [N-1:0] s;
      integer	    m;
      begin
         exp = {DW{1'b0}};
         for (m = 0; m < N; m = m + 1)
           if (s[m]) exp = exp | slice[m];
         @(posedge clk); sel <= s;
         @(posedge clk); #1;
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL sel=%h: got %h exp %h", s, out, exp);
         end
      end
   endtask

   initial begin
      errors = 0; sel = 0; in = 0;
      for (k = 0; k < N; k = k + 1) begin
         slice[k] = $random;
         in[k*DW +: DW] = slice[k];
      end
      chk({N{1'b0}});                       // none -> 0
      for (k = 0; k < N; k = k + 1)
        chk({{(N-1){1'b0}}, 1'b1} << k);    // single-hot -> that input
      for (t = 0; t < 12; t = t + 1)
        chk($random);                        // random multi-hot -> OR
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_muxhot_smoke.vcd");
      $dumpvars(0, test_muxhot_smoke);
   end
`endif

endmodule
