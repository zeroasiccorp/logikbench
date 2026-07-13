//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: chiplink D2D link (self-check). Applies a different per-lane skew
 * to each of the NLANES wires, runs the training phase, waits for 'aligned',
 * then streams a sequence of distinct known words through the link and checks
 * that the receive side reconstructs the same words, in order (found as a
 * contiguous run in the received stream, to absorb the fixed link latency).
 * Prints PASSED or FAILED.
 * TESTED: training -> aligned handshake, per-lane deskew, word realignment,
 *         and data round-trip under independent per-lane skew.
 * NOT TESTED: large NLANES, skew >= SER (whole-frame slip), lane repair.
 ******************************************************************************/
`timescale 1ns/1ps
module test_chiplink_smoke;

   localparam NLANES = 8;
   localparam DW     = 32;
   localparam K      = 8;    // number of data words to send/check

   reg              clk = 1'b0;
   reg              reset_n;
   reg              send_en;
   reg  [DW-1:0]    din;
   reg              din_valid;
   wire             din_ready;
   wire [DW-1:0]    dout;
   wire             dout_valid;
   wire             aligned;
   reg  [NLANES*3-1:0] lane_skew;

   always #5 clk = ~clk;

   chiplink #(.NLANES(NLANES), .DW(DW)) dut
     (.clk(clk), .reset_n(reset_n),
      .din(din), .din_valid(din_valid), .din_ready(din_ready),
      .dout(dout), .dout_valid(dout_valid), .aligned(aligned),
      .lane_skew(lane_skew));

   // distinct, nonzero test words
   function [DW-1:0] genword;
      input [7:0] k;
      begin
         genword = (32'h11111111 * (k + 8'd1)) ^ 32'hA5A55A5A;
      end
   endfunction

   // send index; drive din combinationally, advance on din_ready
   reg [7:0] si;
   always @* begin
      if (send_en && (si < K)) begin
         din       = genword(si);
         din_valid = 1'b1;
      end
      else begin
         din       = {DW{1'b0}};
         din_valid = 1'b0;
      end
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
        si <= 8'd0;
      else if (send_en && din_ready && (si < K))
        si <= si + 8'd1;
   end

   // capture the received word stream
   reg [DW-1:0] rcv [0:255];
   reg [8:0]    ri;
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
        ri <= 9'd0;
      else if (dout_valid && (ri < 9'd256)) begin
         rcv[ri] <= dout;
         ri <= ri + 9'd1;
      end
   end

   integer o, k;
   reg found, match;

   initial begin
      // independent per-lane skew (all < SER=4): lanes 0..7 = 0,1,2,3,3,2,1,0
      lane_skew = 24'b000_001_010_011_011_010_001_000;
      send_en   = 1'b0;
      reset_n   = 1'b0;
      repeat (6) @(posedge clk);
      reset_n <= 1'b1;
      @(posedge clk);

      // wait for the link to train and align
      while (!aligned)
        @(posedge clk);

      // stream K known words, then let the pipeline drain
      send_en <= 1'b1;
      wait (si == K);
      repeat (8 * (DW/NLANES) + 40) @(posedge clk);
      send_en <= 1'b0;

      // the K sent words must appear as a contiguous run in the receive stream
      found = 1'b0;
      for (o = 0; (o + K) <= ri && !found; o = o + 1) begin
         match = 1'b1;
         for (k = 0; k < K; k = k + 1)
           if (rcv[o + k] !== genword(k[7:0]))
             match = 1'b0;
         if (match)
           found = 1'b1;
      end

      if (aligned && found)
        $display("PASSED");
      else begin
         $display("FAILED: alignment or data mismatch (aligned=%0b found=%0b, %0d words rcvd)",
                  aligned, found, ri);
      end
      $finish;
   end

   // watchdog
   initial begin
      #100000;
      $display("FAILED: timeout, alignment or data mismatch");
      $finish;
   end

endmodule
