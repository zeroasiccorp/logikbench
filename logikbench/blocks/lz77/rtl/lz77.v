//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LZ77 (LZSS) codec (full example): instantiates the hash-based lz77_enc and
// lz77_dec and wires the encoder token stream into the decoder (valid/ready),
// so the decompressed bytes equal the input bytes. Bytes in (in_valid/in_ready,
// in_last), reconstructed bytes out (out_valid).
//
//#############################################################################

module lz77
  #(parameter WIN = 32768,
    parameter WW = 64,
    parameter NWAY = 4,
    parameter HASHBITS = 12,
    parameter MINMATCH = 4,
    parameter LENW = 7,
    parameter AW = 15,
    parameter PW = 16,
    parameter WAW = 8)
   (
    input	 clk,
    input	 rst,
    input	 in_valid,
    input [7:0]	 in_byte,
    input	 in_last,
    output	 in_ready,
    output	 out_valid,
    output [7:0] out_byte
    );

   wire            t_valid, t_match, t_ready;
   wire [7:0]	   t_lit;
   wire [LENW-1:0] t_len;
   wire [AW-1:0]   t_dist;

   lz77_enc #(.WIN(WIN), .WW(WW), .NWAY(NWAY), .HASHBITS(HASHBITS),
              .MINMATCH(MINMATCH), .LENW(LENW), .AW(AW), .PW(PW), .WAW(WAW))
   u_enc
     (.clk(clk), .rst(rst), .in_valid(in_valid), .in_byte(in_byte),
      .in_last(in_last), .in_ready(in_ready),
      .out_valid(t_valid), .out_match(t_match), .out_lit(t_lit),
      .out_len(t_len), .out_dist(t_dist), .out_ready(t_ready));

   lz77_dec #(.WIN(WIN), .LENW(LENW), .AW(AW), .PW(PW))
   u_dec
     (.clk(clk), .rst(rst), .in_valid(t_valid), .in_match(t_match),
      .in_lit(t_lit), .in_len(t_len), .in_dist(t_dist), .in_ready(t_ready),
      .out_valid(out_valid), .out_byte(out_byte));

endmodule
