//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: chiplink source-synchronous D2D link (self-check).
 * Drives tx_clk and rx_clk at different frequencies (10 ns / 14 ns, async) to
 * exercise the clock-domain crossing. The link is closed EXTERNALLY here: the
 * forwarded clock feeds the RX capture clock, and each lane is delayed by a
 * distinct whole-cycle skew before reaching the RX (what the per-lane deskew
 * must absorb). After training the RX reports rx_aligned; the TB then streams
 * K known words on tx_clk and checks the same K words emerge in order on
 * rx_dout in the rx_clk domain, having crossed the async FIFO.
 * TESTED: forwarded-clock capture, per-lane whole-UI deskew, training lock,
 *         word alignment, async FIFO CDC, end-to-end word round-trip.
 * NOT TESTED: analog PHY (drivers/termination/DLL/sub-UI deskew), DDR, lane
 *         repair, inter-frame (> one frame) skew.
 ******************************************************************************/
`timescale 1ns/1ps
module test_chiplink_smoke;

   localparam integer NLANES = 8;
   localparam integer DW     = 32;
   localparam integer K      = 8;     // data words to stream

   reg              tx_clk = 1'b0;
   reg              rx_clk = 1'b0;
   reg              tx_rst_n, rx_rst_n;
   always #5 tx_clk = ~tx_clk;        // 10 ns
   always #7 rx_clk = ~rx_clk;        // 14 ns (async to tx_clk)

   // DUT link + control
   reg  [DW-1:0]      tx_din;
   reg                tx_din_valid;
   wire               tx_din_ready;
   wire               tx_fwclk;
   wire [NLANES-1:0]  tx_data;
   wire               rx_fwclk;
   reg  [NLANES-1:0]  rx_data;
   wire [DW-1:0]      rx_dout;
   wire               rx_dout_valid;
   wire               rx_aligned;

   chiplink #(.NLANES(NLANES), .DW(DW)) dut
     (.tx_clk(tx_clk), .tx_rst_n(tx_rst_n),
      .tx_din(tx_din), .tx_din_valid(tx_din_valid), .tx_din_ready(tx_din_ready),
      .tx_fwclk(tx_fwclk), .tx_data(tx_data),
      .rx_clk(rx_clk), .rx_rst_n(rx_rst_n), .rx_fwclk(rx_fwclk),
      .rx_data(rx_data), .rx_dout(rx_dout), .rx_dout_valid(rx_dout_valid),
      .rx_aligned(rx_aligned));

   // ---- external link: forwarded clock + per-lane whole-cycle skew ----
   assign rx_fwclk = tx_fwclk;

   reg [2:0] skewv [0:NLANES-1];      // per-lane skew, all < SER (=4)
   reg [7:0] skq   [0:NLANES-1];      // per-lane delay line (on tx_fwclk)
   integer   j;
   always @(posedge tx_fwclk)
     for (j = 0; j < NLANES; j = j + 1)
       skq[j] <= {skq[j][6:0], tx_data[j]};
   always @* begin
      for (j = 0; j < NLANES; j = j + 1)
        rx_data[j] = (skewv[j] == 3'd0) ? tx_data[j] : skq[j][skewv[j]-1];
   end

   // ---- stimulus / capture ----
   reg  [DW-1:0] words [0:K-1];
   integer       kf;                  // next word to send (tx domain)
   reg           feeding;
   reg  [DW-1:0] rcv [0:255];
   integer       rc;                  // received count (rx domain)

   always @* tx_din = (kf < K) ? words[kf] : {DW{1'b0}};
   always @* tx_din_valid = feeding && (kf < K);

   always @(posedge tx_clk or negedge tx_rst_n) begin
      if (!tx_rst_n)
        kf <= 0;
      else if (feeding && tx_din_ready && (kf < K))
        kf <= kf + 1;
   end

   always @(posedge rx_clk or negedge rx_rst_n) begin
      if (!rx_rst_n)
        rc <= 0;
      else if (rx_dout_valid && (rc < 256)) begin
         rcv[rc] <= rx_dout;
         rc <= rc + 1;
      end
   end

   integer s, t, found, mm;
   initial begin
      // init
      tx_rst_n = 1'b0; rx_rst_n = 1'b0;
      tx_din = {DW{1'b0}}; tx_din_valid = 1'b0; feeding = 1'b0;
      skewv[0]=3'd0; skewv[1]=3'd1; skewv[2]=3'd2; skewv[3]=3'd3;
      skewv[4]=3'd3; skewv[5]=3'd2; skewv[6]=3'd1; skewv[7]=3'd0;
      for (j = 0; j < NLANES; j = j + 1) skq[j] = 8'b0;
      for (t = 0; t < K; t = t + 1)
        words[t] = 32'hBEEF0000 + (t+1)*32'h01010101 + 32'h1;

      // release resets on their own clocks
      repeat (4) @(posedge tx_clk); tx_rst_n <= 1'b1;
      repeat (4) @(posedge rx_clk); rx_rst_n <= 1'b1;

      // wait for the link to train and align
      wait (rx_aligned);
      repeat (4) @(posedge tx_clk);

      // stream the K known words
      feeding <= 1'b1;
      wait (kf == K);
      feeding <= 1'b0;

      // let the words drain through the CDC FIFO into the rx domain
      repeat (300) @(posedge rx_clk);

      // scan the received stream for the K words, contiguous and in order
      found = 0;
      for (s = 0; (s + K) <= rc; s = s + 1) begin
         mm = 0;
         for (t = 0; t < K; t = t + 1)
           if (rcv[s+t] !== words[t]) mm = 1;
         if (mm == 0) found = 1;
      end

      if (found)
        $display("PASSED");
      else begin
         $display("FAILED: streamed words not found in rx output (rc=%0d)", rc);
         for (t = 0; t < K; t = t + 1) $display("  word[%0d]=0x%08x", t, words[t]);
      end
      $finish;
   end

   // watchdog
   initial begin
      #500000;
      $display("FAILED: timeout (aligned=%0b, kf=%0d, rc=%0d)", rx_aligned, kf, rc);
      $finish;
   end

endmodule
