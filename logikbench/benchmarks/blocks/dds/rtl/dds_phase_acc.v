//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * dds_phase_acc: DDS phase accumulator.
 *
 * Adds the frequency control word (fcw) to the phase each enabled cycle. The
 * output frequency is fout = fclk * fcw / 2^PW. Synchronous, active-low reset
 * clears the phase.
 ******************************************************************************/
module dds_phase_acc
  #(parameter PW = 24)   // phase accumulator width
  (
   input  wire          clk,
   input  wire          reset_n,
   input  wire          en,
   input  wire [PW-1:0] fcw,
   output reg  [PW-1:0] phase
   );

   always @(posedge clk) begin
      if (!reset_n)
        phase <= {PW{1'b0}};
      else if (en)
        phase <= phase + fcw;
   end

endmodule
