//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_train: per-lane training lock (rx_fwclk domain).
 *
 * During training the transmitter drives a one-cycle marker on every lane at
 * frame phase 0 (once per SER-cycle frame). This lane sees that marker delayed
 * by its own wire skew, so it lands at some receive frame phase. The lane
 * locks on the first marker and reports the phase (capphase) at which it was
 * captured; the receiver turns the per-lane capphase values (referenced to
 * lane 0) into whole-UI deskew depths and a common frame boundary.
 ******************************************************************************/
module chiplink_train
  #(parameter SER = 4,
    parameter PW  = 2)
  (
   input           fwclk,
   input           rst_n,
   input           train,        // 1 during the training phase
   input           lane_bit,     // this lane's captured bit (history bit 0)
   input  [PW-1:0] rphase,       // free-running receive frame phase
   output reg          locked,
   output reg [PW-1:0] capphase   // receive frame phase at which the marker hit
   );

   always @(posedge fwclk or negedge rst_n) begin
      if (!rst_n) begin
         locked   <= 1'b0;
         capphase <= {PW{1'b0}};
      end
      else if (train && !locked && lane_bit) begin
         capphase <= rphase;
         locked   <= 1'b1;
      end
   end

endmodule
