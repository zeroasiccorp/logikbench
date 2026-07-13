//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink: a chiplet die-to-die (D2D) link, in the style of AIB / BoW
 * (Bunch of Wires) -- a source-synchronous parallel interface.
 *
 * A DW-bit word is serialized across NLANES parallel wires (SER = DW/NLANES
 * bits per lane per frame) by the TX, carried over the wires with independent
 * per-lane skew, and recovered by the RX, which deskews each lane and realigns
 * the word using a training pattern. This is a synthesizable model of the
 * link logic (framing, training, per-lane deskew, word alignment); it does not
 * model the analog/DDR PHY. TX and RX are wired lane-to-lane here so the block
 * is self-contained and testable, with a per-lane skew input that delays each
 * lane between TX and RX for verification.
 *
 * The TX trains (sends alignment markers) until the RX reports 'aligned', then
 * switches to carrying data. Requires DW to be a multiple of NLANES and
 * SER >= 2. Per-lane skew must be < SER cycles (intra-frame deskew).
 ******************************************************************************/
module chiplink
  #(parameter NLANES = 8,
    parameter DW = 32)
  (
   input  clk,
   input  reset_n,
   // TX-side word input
   input  [DW-1:0]     din,
   input  din_valid,
   output din_ready,
   // RX-side word output
   output [DW-1:0]     dout,
   output dout_valid,
   // link status
   output aligned,
   // per-lane skew (3 bits/lane), applied on the wires between TX and RX
   input  [NLANES*3-1:0] lane_skew
   );

   wire [NLANES-1:0] tx_lane;   // TX serial output per lane
   wire [NLANES-1:0] rx_lane;   // lane bits after skew insertion
   wire              train = ~aligned;

   chiplink_tx #(.DW(DW), .NLANES(NLANES)) u_tx
     (.clk       (clk),
      .reset_n   (reset_n),
      .train     (train),
      .din       (din),
      .din_valid (din_valid),
      .din_ready (din_ready),
      .lane      (tx_lane));

   // per-lane skew: delay lane g by lane_skew[g] cycles (0..7); models the
   // independent flight-time mismatch a real D2D link's deskew must absorb.
   genvar g;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: skew
         reg  [7:0] sreg;
         wire [2:0] d = lane_skew[g*3 +: 3];
         always @(posedge clk or negedge reset_n) begin
            if (!reset_n)
              sreg <= 8'b0;
            else
              sreg <= {sreg[6:0], tx_lane[g]};
         end
         assign rx_lane[g] = (d == 3'd0) ? tx_lane[g] : sreg[d-3'd1];
      end
   endgenerate

   chiplink_rx #(.DW(DW), .NLANES(NLANES)) u_rx
     (.clk        (clk),
      .reset_n    (reset_n),
      .train      (train),
      .lane       (rx_lane),
      .dout       (dout),
      .dout_valid (dout_valid),
      .aligned    (aligned));

endmodule
