//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_tx: transmit side of the chiplet link.
 *
 * A DW-bit word is serialized across NLANES parallel wires, SER = DW/NLANES
 * bits per lane per frame (a frame is SER cycles). Lane l carries word bits
 * [l*SER +: SER], phase 0 first. During the training phase every lane emits a
 * one-hot marker (a single '1' at frame phase 0, zeros elsewhere) so the
 * receiver can find each lane's frame boundary and deskew. In the data phase
 * the lanes carry payload; a new word is captured at each frame boundary when
 * din_valid, otherwise idle zeros are sent.
 *
 * Requires SER >= 2 (DW >= 2*NLANES) so the marker is unambiguous.
 ******************************************************************************/
module chiplink_tx
  #(parameter DW = 32,
    parameter NLANES = 8)
  (
   input               clk,
   input               reset_n,
   input               train,     // 1 = send training markers
   input [DW-1:0]      din,       // word to send (data phase)
   input               din_valid,
   output              din_ready, // accepts a word at the frame boundary
   output [NLANES-1:0] lane       // one bit per lane per cycle
   );

   localparam SER = DW / NLANES;
   localparam PW  = (SER < 2) ? 1 : $clog2(SER);

   reg [PW-1:0]  tphase;   // frame phase, 0..SER-1
   reg [DW-1:0]  cur;      // word being shifted out this frame

   wire lastp = (tphase == (SER-1));

   // accept the next word at the end of the current frame (data phase only)
   assign din_ready = (~train) & lastp;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         tphase <= {PW{1'b0}};
         cur    <= {DW{1'b0}};
      end
      else begin
         tphase <= lastp ? {PW{1'b0}} : (tphase + 1'b1);
         // load the next frame's word at the frame boundary
         if (lastp)
           cur <= train ? {DW{1'b0}} : (din_valid ? din : {DW{1'b0}});
      end
   end

   // drive each lane: training marker, or the payload bit for this phase
   genvar g;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: lane_drv
         assign lane[g] = train ? (tphase == {PW{1'b0}})
                                 : cur[g*SER + tphase];
      end
   endgenerate

endmodule
