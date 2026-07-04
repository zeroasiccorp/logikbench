//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Complex digital mixer (down-conversion multiplier).
//
// Mixes a real bandpass input x by the NCO's complex exponential to shift the
// band of interest down to DC:
//
//   I = x * cos(phase)
//   Q = x * (-sin(phase))
//
// Two signed DW x SW multiplies. Each product is Q(.,30) (two Q1.15 operands),
// rounded back to a Q1.15 IQW-bit working sample with convergent-free
// round-half-up and symmetric saturation.
//
// Data format: x is Q1.15 (DW bits), cos/sin are Q1.15 (SW bits), I/Q are
// Q1.15 (IQW bits).
//
//#############################################################################

module ddc_mixer
  #(parameter DW = 16, // real input width (Q1.15)
    parameter SW = 16, // nco sample width (Q1.15)
    parameter IQW = 16 // i/q working width (Q1.15)
    )
   (
    input			clk,
    input			rst, // synchronous, active high
    input			en,
    input signed [DW-1:0]	x,   // real bandpass input
    input signed [SW-1:0]	cosin,
    input signed [SW-1:0]	sinin,
    output reg signed [IQW-1:0]	iout,
    output reg signed [IQW-1:0]	qout
    );

   // Full-precision products (Q2.30 in DW+SW bits) and rounded Q1.15 results.
   localparam PW = DW + SW;             // product width
   localparam SH = SW - 1;             // fractional bits to drop (15)

   wire signed [PW-1:0]	p_i = x * cosin;
   wire signed [PW-1:0]	p_q = x * (-sinin);

   // round-half-up: add 1/2 LSB before the arithmetic right shift
   wire signed [PW-1:0]	r_i = p_i + (1 <<< (SH-1));
   wire signed [PW-1:0]	r_q = p_q + (1 <<< (SH-1));
   wire signed [PW-1:0]	s_i = r_i >>> SH;
   wire signed [PW-1:0]	s_q = r_q >>> SH;

   // symmetric saturation to IQW bits
   localparam signed [PW-1:0] MAXP =  (1 <<< (IQW-1)) - 1;
   localparam signed [PW-1:0] MINP = -(1 <<< (IQW-1));

   wire signed [IQW-1:0]      sat_i = (s_i > MAXP) ? MAXP[IQW-1:0] :
                              (s_i < MINP) ? MINP[IQW-1:0] : s_i[IQW-1:0];
   wire signed [IQW-1:0]      sat_q = (s_q > MAXP) ? MAXP[IQW-1:0] :
                              (s_q < MINP) ? MINP[IQW-1:0] : s_q[IQW-1:0];

   always @(posedge clk) begin
      if (rst) begin
         iout <= {IQW{1'b0}};
         qout <= {IQW{1'b0}};
      end
      else if (en) begin
         iout <= sat_i;
         qout <= sat_q;
      end
   end

endmodule
