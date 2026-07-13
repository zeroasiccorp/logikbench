//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_tx: transmit endpoint (tx_clk domain), source-synchronous SDR.
 *
 * Forwards tx_clk to the far die (tx_fwclk) and drives one bit per lane per
 * forwarded-clock cycle (single data rate). A DW word is serialized across
 * NLANES lanes over SER = DW/NLANES cycles: lane l carries word bits
 * [l*SER +: SER], sent phase 0..SER-1. After reset the link runs a fixed
 * training phase (NTRAIN frames) driving a frame-phase-0 marker on every lane
 * so the receiver can lock per-lane deskew; then it switches to data.
 ******************************************************************************/
module chiplink_tx
  #(parameter NLANES = 8,
    parameter DW = 32)
  (
   input                   tx_clk,
   input                   tx_rst_n,
   input      [DW-1:0]     tx_din,
   input                   tx_din_valid,
   output                  tx_din_ready,
   output                  tx_fwclk,
   output     [NLANES-1:0] tx_data
   );

   localparam SER    = DW / NLANES;                  // bits/lane/word
   localparam PW     = (SER < 2) ? 1 : $clog2(SER);
   localparam NTRAIN = 16;                           // training frames

   reg [PW-1:0] tphase;
   reg [DW-1:0] cur;
   reg          training;
   reg [4:0]    frame_cnt;

   wire lastp = (tphase == (SER-1));

   // forward the transmit clock to the receiver
   assign tx_fwclk = tx_clk;

   // accept a new word at each data-phase frame boundary
   assign tx_din_ready = ~training & lastp;

   always @(posedge tx_clk or negedge tx_rst_n) begin
      if (!tx_rst_n) begin
         tphase    <= {PW{1'b0}};
         cur       <= {DW{1'b0}};
         training  <= 1'b1;
         frame_cnt <= 5'd0;
      end
      else begin
         tphase <= lastp ? {PW{1'b0}} : (tphase + 1'b1);
         if (lastp) begin
            if (training) begin
               frame_cnt <= frame_cnt + 5'd1;
               if (frame_cnt == (NTRAIN-1))
                 training <= 1'b0;
            end
            else begin
               cur <= tx_din_valid ? tx_din : {DW{1'b0}};
            end
         end
      end
   end

   // lane driver: training marker (phase-0 pulse) or the payload bit
   genvar g;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: ld
         assign tx_data[g] = training ? (tphase == {PW{1'b0}})
                                      : cur[g*SER + tphase];
      end
   endgenerate

endmodule
