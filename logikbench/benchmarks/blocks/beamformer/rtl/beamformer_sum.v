//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// Beamformer summation: sign-extend and add the NCHAN channel products into
// one focused output sample, registered at the output (1-cycle latency).
//#############################################################################
module beamformer_sum
  #(parameter PW    = 24,                    // per-channel product width
    parameter NCHAN = 8,                     // number of channels
    parameter OW    = PW + $clog2(NCHAN))    // output width (sum headroom)
   (
    input                     clk,
    input                     reset_n,
    input                     in_valid,
    input      [NCHAN*PW-1:0] prods,
    output reg                out_valid,
    output reg signed [OW-1:0] beam
    );

   integer i;
   reg signed [OW-1:0] acc;

   always @* begin
      acc = {OW{1'b0}};
      for (i = 0; i < NCHAN; i = i + 1)
        acc = acc + $signed(prods[i*PW +: PW]);
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         beam      <= {OW{1'b0}};
         out_valid <= 1'b0;
      end
      else begin
         beam      <= acc;
         out_valid <= in_valid;
      end
   end

endmodule
