//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for crossbar (self-checking). Each output selects one input
// word via a one-hot select; the output must equal the selected input word.
//
//#############################################################################
`timescale 1ns/1ps
module test_crossbar_smoke;
   localparam DW = 16, N = 4;
   reg	      clk=0;
   reg [N*DW-1:0] din;
   reg [N*N-1:0]  sel;
   wire [N*DW-1:0] dout;
   integer	   trial, o, k, src, errors;
   reg [N*DW-1:0]  din_r, exp;
   reg [N*N-1:0]   sel_r;
   reg [31:0]	   r;

   always #5 clk=~clk;

   crossbar #(.DW(DW), .N(N)) dut (.din(din), .sel(sel), .dout(dout));

   initial begin
      errors=0; din=0; sel=0;
      for (trial=0; trial<200; trial=trial+1) begin
         // random input words
         for (k=0; k<N*DW; k=k+16) begin r=$random; din_r[k +: 16] = r[15:0]; end
         // random one-hot select per output and the expected output
         sel_r = {(N*N){1'b0}};
         exp   = {(N*DW){1'b0}};
         for (o=0; o<N; o=o+1) begin
            r = $random; src = r % N;
            sel_r[o*N + src] = 1'b1;
            exp[o*DW +: DW] = din_r[src*DW +: DW];
         end
         @(posedge clk); din <= din_r; sel <= sel_r;
         @(posedge clk); #1;
         if (dout !== exp) begin
            errors = errors + 1;
            if (errors<=8) $display("FAIL: dout=%h exp=%h", dout, exp);
         end
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
