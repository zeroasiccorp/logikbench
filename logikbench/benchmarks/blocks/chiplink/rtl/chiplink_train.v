//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_train: per-lane deskew / alignment FSM.
 *
 * During training the lane carries a one-hot marker (a single '1' at frame
 * phase 0). Because each lane is skewed independently, the marker arrives at
 * the receiver at some phase 'a' of the free-running receive counter rphase.
 * This block latches that phase on the first marker and computes a per-lane
 * delay = (SER - a) mod SER, so that applying that delay lines the marker (and
 * therefore every payload bit) back up to rphase 0. 'locked' asserts once the
 * marker has been seen and holds through the data phase.
 ******************************************************************************/
module chiplink_train
  #(parameter SER = 4,
    parameter PW  = 2)
  (
   input  clk,
   input  reset_n,
   input  train,      // 1 = training phase
   input  lane_bit,   // this lane's received bit
   input  [PW-1:0] rphase,     // receiver frame phase
   output reg           locked,     // 1 once this lane is aligned
   output reg  [PW-1:0] delay       // per-lane deskew (cycles)
   );

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         locked <= 1'b0;
         delay  <= {PW{1'b0}};
      end
      else if (train && !locked && lane_bit) begin
         // marker seen at phase rphase -> delay to bring it to phase 0
         delay  <= (rphase == {PW{1'b0}}) ? {PW{1'b0}}
                                          : (SER - rphase);
         locked <= 1'b1;
      end
      // once locked (and in the data phase) delay/locked hold
   end

endmodule
