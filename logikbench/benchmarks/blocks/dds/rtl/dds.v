//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * dds: direct digital synthesizer / numerically-controlled oscillator.
 *
 * A PW-bit phase accumulator is driven by the frequency control word (fcw);
 * its top AW bits address a quarter-wave sine ROM (dds_lut) that reconstructs
 * a full-period signed sine and, a quarter period ahead, cosine. Output
 * frequency is fout = fclk * fcw / 2^PW. Outputs are registered.
 ******************************************************************************/
module dds
  #(parameter PW = 24,   // phase accumulator width
    parameter AW = 10,   // sine ROM phase address bits (top bits of phase)
    parameter OW = 12)   // signed output sample width
  (
   input  wire                 clk,
   input  wire                 reset_n,
   input  wire                 en,
   input  wire [PW-1:0]        fcw,
   output reg  signed [OW-1:0] sine,
   output reg  signed [OW-1:0] cosine,
   output reg                  out_valid
   );

   wire [PW-1:0]        phase;
   wire signed [OW-1:0] s;
   wire signed [OW-1:0] c;

   dds_phase_acc #(.PW(PW)) u_acc
     (.clk(clk), .reset_n(reset_n), .en(en), .fcw(fcw), .phase(phase));

   // the top AW bits of the accumulator address the sine ROM
   dds_lut #(.AW(AW), .OW(OW)) u_lut
     (.phase(phase[PW-1:PW-AW]), .sine(s), .cosine(c));

   always @(posedge clk) begin
      if (!reset_n) begin
         sine      <= {OW{1'b0}};
         cosine    <= {OW{1'b0}};
         out_valid <= 1'b0;
      end
      else begin
         sine      <= s;
         cosine    <= c;
         out_valid <= en;
      end
   end

endmodule
