//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// OFDM loopback modem (802.11a/g style): full transmit + receive example.
// Instantiates ofdm_tx and ofdm_rx and connects the TX time-sample stream
// directly to the RX (ideal internal loopback channel), so the recovered bits
// equal the input bits. mod: 0=QPSK, 1=16-QAM, 2=64-QAM. The transform engine
// is the logikbench fft block, instantiated inside each of ofdm_tx/ofdm_rx.
//
//#############################################################################

module ofdm
  #(parameter DW = 16,
    parameter N = 64,
    parameter CP = 16)
   (
    input	     clk,
    input	     rst,
    input	     in_valid,
    input [1:0]	     mod,
    input [6*N-1:0]  in_bits,
    output	     out_valid,
    output [6*N-1:0] out_bits
    );

   wire                 tx_valid;
   wire			tx_last;
   wire signed [DW-1:0]	tx_r;
   wire signed [DW-1:0]	tx_i;

   ofdm_tx #(.DW(DW), .N(N), .CP(CP)) u_tx
     (.clk      (clk),
      .rst      (rst),
      .in_valid (in_valid),
      .mod      (mod),
      .in_bits  (in_bits),
      .out_valid(tx_valid),
      .out_last (tx_last),
      .out_r    (tx_r),
      .out_i    (tx_i));

   ofdm_rx #(.DW(DW), .N(N), .CP(CP)) u_rx
     (.clk      (clk),
      .rst      (rst),
      .in_valid (tx_valid),
      .in_last  (tx_last),
      .in_r     (tx_r),
      .in_i     (tx_i),
      .mod      (mod),
      .out_valid(out_valid),
      .out_bits (out_bits));

endmodule
