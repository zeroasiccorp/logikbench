//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// beamformer: parametrized N-channel delay-and-sum receive beamformer (phased
// array / ultrasound). Each of NCHAN channels applies a programmable, RAM-based
// delay (focus/steering) to its incoming sample and an apodization weight; all
// channels are summed into one focused output sample. Delays and weights are
// held inputs (configured per beam); samples stream in on in_valid, one focused
// beam sample streams out on out_valid. Total latency is 3 cycles.
//
// Interface widths: sample_in, delay, weight are the NCHAN per-channel values
// packed low-index-first. AW = clog2(DEPTH) is the delay/address width.
//#############################################################################
module beamformer
  #(parameter NCHAN = 8,                   // number of channels
    parameter DW    = 12,                  // sample width (signed)
    parameter WW    = 12,                  // weight width (signed)
    parameter DEPTH = 64,                  // per-channel delay buffer depth
    parameter AW    = $clog2(DEPTH),       // delay / address width
    parameter PW    = DW + WW,             // per-channel product width
    parameter OW    = PW + $clog2(NCHAN))  // output beam width
   (
    input                     clk,
    input                     reset_n,
    input                     in_valid,
    input  [NCHAN*DW-1:0]     sample_in,   // per-channel samples
    input  [NCHAN*AW-1:0]     delay,       // per-channel delays
    input  [NCHAN*WW-1:0]     weight,      // per-channel apodization weights
    output                    out_valid,
    output signed [OW-1:0]    beam         // focused output sample
    );

   wire [NCHAN*PW-1:0] prods;
   wire [NCHAN-1:0]    ch_valid;

   genvar g;
   generate
      for (g = 0; g < NCHAN; g = g + 1) begin: lane
         beamformer_channel #(.DW(DW), .WW(WW), .DEPTH(DEPTH), .AW(AW)) u_ch
           (.clk       (clk),
            .reset_n   (reset_n),
            .in_valid  (in_valid),
            .sample_in (sample_in[g*DW +: DW]),
            .delay     (delay[g*AW +: AW]),
            .weight    (weight[g*WW +: WW]),
            .out_valid (ch_valid[g]),
            .prod      (prods[g*PW +: PW]));
      end
   endgenerate

   // all channels share the same latency, so any channel's valid is aligned
   beamformer_sum #(.PW(PW), .NCHAN(NCHAN), .OW(OW)) u_sum
     (.clk       (clk),
      .reset_n   (reset_n),
      .in_valid  (ch_valid[0]),
      .prods     (prods),
      .out_valid (out_valid),
      .beam      (beam));

endmodule
