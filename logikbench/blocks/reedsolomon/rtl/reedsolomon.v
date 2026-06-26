//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Reed-Solomon RS(544,514) codec (KP4 FEC, GF(2^10), t=15): a self-checking
// loopback that instantiates the systematic encoder and the full decoder
// (syndrome -> Berlekamp-Massey -> Chien -> Forney -> correct). The encoder
// codeword stream is XORed with err_in (per-symbol error injection) before the
// decoder, so with <= t injected symbol errors the recovered data equals the
// input, and > t errors raise uncorrectable.
//
//#############################################################################

module reedsolomon
  #(parameter M = 10,
    parameter K = 514,
    parameter N = 544,
    parameter TWOT = 30,
    parameter NLAM = 16,
    parameter PW = 11)
   (
    input	   clk,
    input	   rst,
    input	   in_valid,
    input [M-1:0]  in_sym,
    input	   in_last,
    input [M-1:0]  err_in, // XORed into the codeword stream
    output	   in_ready,
    output	   out_valid,
    output [M-1:0] out_sym,
    output	   out_last,
    output	   uncorrectable
    );

   wire           cw_valid, cw_last;
   wire [M-1:0]	  cw_sym;

   rs_enc #(.M(M), .K(K), .TWOT(TWOT), .CW(PW)) u_enc
     (.clk(clk), .rst(rst), .in_valid(in_valid), .in_sym(in_sym),
      .in_last(in_last), .in_ready(in_ready),
      .out_valid(cw_valid), .out_sym(cw_sym), .out_last(cw_last));

   wire [M-1:0] rx_sym = cw_sym ^ err_in;

   rs_dec #(.M(M), .N(N), .TWOT(TWOT), .NLAM(NLAM), .PW(PW)) u_dec
     (.clk(clk), .rst(rst), .in_valid(cw_valid), .in_sym(rx_sym),
      .out_valid(out_valid), .out_sym(out_sym), .out_last(out_last),
      .uncorrectable(uncorrectable));

endmodule
