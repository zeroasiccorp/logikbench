//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// 8x8 Sum-of-Absolute-Differences (SAD) block matcher (motion estimation).
//
// Two NxN pixel blocks are presented in parallel as packed buses (pixel k at
// bits [k*PW +: PW], raster order). All N*N absolute differences |a-b| are
// computed in parallel (one subtract/compare/select each, generated) and summed
// in an adder-tree reduction to the SAD. Registered I/O (valid_in -> valid_out,
// 1-cycle latency). No multiply (0 DSP), no memory (0 BRAM).
//
// Same clk/rst/valid/pixel-width conventions as the streaming 3x3 filters so it
// drops in at the tail of an image-processing pipeline as a measurement block
// (it is a reduction, not a same-size stream filter).
//
//#############################################################################

module sad8x8
  #(parameter N = 8,
    parameter PW = 8,
    parameter NP = N*N,
    parameter SADW = 14) // clog2(N*N*(2^PW-1)+1): 64*255=16320 -> 14
   (
    input		  clk,
    input		  rst,
    input		  valid_in,
    input [NP*PW-1:0]	  curblk, // current block, pixel k at [k*PW +: PW]
    input [NP*PW-1:0]	  refblk, // reference block, same packing
    output reg		  valid_out,
    output reg [SADW-1:0] sad
    );

   // per-pixel absolute differences (generated, one per pixel pair)
   wire [PW-1:0] ad [0:NP-1];
   genvar	 i;
   generate
      for (i = 0; i < NP; i = i + 1) begin : g_ad
         wire [PW-1:0] a = curblk[i*PW +: PW];
         wire [PW-1:0] b = refblk[i*PW +: PW];
         assign ad[i] = (a >= b) ? (a - b) : (b - a);
      end
   endgenerate

   // adder-tree reduction (fixed sum of NP terms)
   reg [SADW-1:0] acc;
   integer	  k;
   always @* begin
      acc = {SADW{1'b0}};
      for (k = 0; k < NP; k = k + 1)
        acc = acc + {{(SADW-PW){1'b0}}, ad[k]};
   end

   always @(posedge clk) begin
      if (rst) begin
         valid_out <= 1'b0; sad <= {SADW{1'b0}};
      end else begin
         valid_out <= valid_in;
         sad       <= acc;
      end
   end

endmodule
