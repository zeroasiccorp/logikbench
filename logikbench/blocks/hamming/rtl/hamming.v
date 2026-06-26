//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Hsiao SEC-DED codec (full example): instantiates hamming_enc and hamming_dec
// and wires the encoder's DW+PW-bit codeword into the decoder through an
// error-injection XOR (err_mask), so the round-trip test can exercise
// single-error correction and double-error detection. With err_mask = 0 the
// decoded data equals the input data and the syndrome is zero.
//
// Data path:
//   hamming_enc(in) -> codeword; rxword = codeword ^ err_mask;
//   hamming_dec(rxword) -> out (corrected data), syndrome.
//
//#############################################################################

module hamming
  #(parameter DW = 64,	    // information (data) bits
    parameter PW = 8,	    // Hsiao check bits
    parameter PIPELINE = 1) // 1 = registered, 0 = combinational
   (
    input	      clk,	// clock
    input	      nreset,	// async active-low reset
    input [DW-1:0]    in,	// data in
    input [DW+PW-1:0] err_mask,	// bit-flips applied to the codeword
    output [DW-1:0]   out,	// corrected data
    output [PW-1:0]   syndrome	// error syndrome (0 = clean)
    );

   wire [DW+PW-1:0] codeword;
   wire [DW+PW-1:0] rxword;

   hamming_enc #(.DW(DW), .PW(PW), .PIPELINE(PIPELINE)) u_enc
     (.clk    (clk),
      .nreset (nreset),
      .in     (in),
      .out    (codeword));

   assign rxword = codeword ^ err_mask;

   hamming_dec #(.DW(DW), .PW(PW), .PIPELINE(PIPELINE)) u_dec
     (.clk      (clk),
      .nreset   (nreset),
      .in       (rxword),
      .out      (out),
      .syndrome (syndrome));

endmodule
