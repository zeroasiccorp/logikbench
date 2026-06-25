//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Digital Down Converter (DDC).
//
// Real bandpass input -> NCO mixes to complex baseband -> CIC decimate ->
// compensation FIR -> I/Q output at the decimated rate.
//
//   x[n] --+--> (* cos)  --> I --> CIC(R) --> FIR --> iout  (decimated rate)
//          |     NCO
//          +--> (*-sin)  --> Q --> CIC(R) --> FIR --> qout  (decimated rate)
//
// The mixer shifts the band centered at f_nco = ftw*Fs/2^PAW down to DC. The
// CIC decimates by R (Hogenauer, multiplierless), and the per-lane FIR removes
// the CIC droop. The I and Q lanes are instantiated per-lane via a generate
// loop over a packed 2-lane bus.
//
// Data format: Q1.15 throughout. x is DW bits, I/Q outputs are OUTW bits.
//
// Streaming: in_valid asserted on every input sample; out_valid strobes once
// per R inputs (the decimated rate). No ready/backpressure (see README).
//
//#############################################################################

module ddc
  #(parameter               DW = 16,    // real input width (Q1.15)
    parameter               OUTW = 16,  // i/q output width (Q1.15)
    parameter               IQW = 16,   // internal working width (Q1.15)
    parameter               PAW = 24,   // nco phase accumulator width
    parameter               AW = 8,     // sine rom address width (log2 NSIN, NSIN=256)
    parameter               SW = 16,    // nco sample width (Q1.15)
    parameter               STAGES = 4, // cic integrator/comb stages
    parameter               R = 8,      // cic decimation factor
    parameter               M = 1,      // cic differential delay
    parameter               CW = 16,    // fir coefficient width (Q1.15)
    parameter               NTAP = 15,  // fir taps
    parameter [NTAP*CW-1:0] H = {{(NTAP/2){{CW{1'b0}}}},
                            {1'b0, {(CW-1){1'b1}}},
                            {(NTAP/2){{CW{1'b0}}}}}
    )
   (
    input                    clk,
    input                    rst,     // synchronous, active high
    input                    in_valid,
    input [PAW-1:0]          ftw,     // nco frequency tuning word
    input signed [DW-1:0]    in_data, // real bandpass input
    output                   out_valid,
    output signed [OUTW-1:0] iout,
    output signed [OUTW-1:0] qout
    );

   // NCO outputs and mixer (complex baseband) outputs.
   wire signed [SW-1:0]  cosw;
   wire signed [SW-1:0]	 sinw;
   wire signed [IQW-1:0] mix_i;
   wire signed [IQW-1:0] mix_q;
   reg			 mix_valid;

   // Per-lane packed buses (lane 0 = I, lane 1 = Q).
   wire signed [IQW-1:0] lane_in  [0:1];
   wire signed [OUTW-1:0] lane_out [0:1];
   wire			  lane_ov  [0:1];

   //----------------------------------------------------------------------
   // NCO: advance phase on every valid input sample.
   //----------------------------------------------------------------------
   ddc_nco #(.PAW(PAW), .AW(AW), .SW(SW))
   u_nco (.clk(clk), .rst(rst), .en(in_valid), .ftw(ftw),
          .cosout(cosw), .sinout(sinw));

   //----------------------------------------------------------------------
   // Mixer: I = x*cos, Q = -x*sin.
   //----------------------------------------------------------------------
   ddc_mixer #(.DW(DW), .SW(SW), .IQW(IQW))
   u_mix (.clk(clk), .rst(rst), .en(in_valid),
          .x(in_data), .cosin(cosw), .sinin(sinw),
          .iout(mix_i), .qout(mix_q));

   // mixer output valid is in_valid delayed by the nco+mixer registers (2)
   reg mix_valid_d;
   always @(posedge clk) begin
      if (rst) begin
         mix_valid_d <= 1'b0;
         mix_valid   <= 1'b0;
      end
      else begin
         mix_valid_d <= in_valid;
         mix_valid   <= mix_valid_d;
      end
   end

   assign lane_in[0] = mix_i;
   assign lane_in[1] = mix_q;

   //----------------------------------------------------------------------
   // Per-lane CIC decimator + compensation FIR.
   //----------------------------------------------------------------------
   genvar gl;
   generate
      for (gl = 0; gl < 2; gl = gl + 1) begin : g_lane
         wire               cic_ov;
         wire signed [IQW-1:0] cic_o;
         ddc_cic #(.IQW(IQW), .STAGES(STAGES), .R(R), .M(M))
         u_cic (.clk(clk), .rst(rst),
                .in_valid(mix_valid), .in_data(lane_in[gl]),
                .out_valid(cic_ov),  .out_data(cic_o));
         ddc_fir #(.IQW(IQW), .OUTW(OUTW), .CW(CW), .NTAP(NTAP), .H(H))
         u_fir (.clk(clk), .rst(rst),
                .in_valid(cic_ov), .in_data(cic_o),
                .out_valid(lane_ov[gl]), .out_data(lane_out[gl]));
      end
   endgenerate

   assign iout      = lane_out[0];
   assign qout      = lane_out[1];
   assign out_valid = lane_ov[0];

endmodule
