//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Static canonical Huffman codec (full example): instantiates huffman_enc and
// huffman_dec and wires the encoder's compressed byte stream straight into the
// decoder (valid/ready handshake), so the decoded symbols equal the input
// symbols. Symbols stream in (in_valid/in_ready, in_last), recovered symbols
// stream out (out_valid).
//
//#############################################################################

module huffman
  (
   input	clk,
   input	rst,
   input	in_valid,
   input [7:0]	in_sym,
   input	in_last,
   output	in_ready,
   output	out_valid,
   output [7:0]	out_sym
   );

   wire       enc_valid;
   wire	      enc_last;
   wire	      enc_ready;
   wire [7:0] enc_byte;

   huffman_enc u_enc
     (.clk      (clk),
      .rst      (rst),
      .in_valid (in_valid),
      .in_sym   (in_sym),
      .in_last  (in_last),
      .in_ready (in_ready),
      .out_valid(enc_valid),
      .out_byte (enc_byte),
      .out_last (enc_last),
      .out_ready(enc_ready));

   huffman_dec u_dec
     (.clk      (clk),
      .rst      (rst),
      .in_valid (enc_valid),
      .in_byte  (enc_byte),
      .in_ready (enc_ready),
      .out_valid(out_valid),
      .out_sym  (out_sym));

endmodule
