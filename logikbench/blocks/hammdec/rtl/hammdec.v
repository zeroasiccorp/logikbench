//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hammdec: parameterized extended-Hamming (SEC-DED) decoder.
//
// Corrects any single-bit error and detects (without correcting) any double-bit
// error, using an extended Hamming code: PW-1 Hamming parity bits plus one
// overall parity bit over a DW-bit data word.
//
// Codeword on 'in' (systematic form):
//   in[DW-1:0]     : data bits
//   in[DW+PW-2:DW] : PW-1 Hamming parity bits
//   in[DW+PW-1]    : overall (double-error-detect) parity bit
//
// How it works, columns and the syndrome:
//   Every codeword bit owns a unique M-bit "column" (M = PW-1), which is its
//   address in the Hamming parity-check matrix. The syndrome is the XOR of the
//   columns of all flipped bits, so for a single-bit error the syndrome equals
//   that bit's column and therefore points straight at the bit in error.
//
//   Parity bits take the power-of-2 columns (1, 2, 4, 8, ...), each a single-bit
//   pattern. Data bits take all remaining nonzero columns (3, 5, 6, 7, ...); see
//   the hcol function. Because the two sets are disjoint every bit has a unique
//   signature, so the decoder can distinguish a data-bit error (which it fixes)
//   from a parity-bit error (data already clean) from no error.
//
//   The decoder recomputes the syndrome from the received word and reports it on
//   'syndrome' = {overall parity check, M-bit Hamming syndrome}:
//     syndrome == 0                       : no error
//     syndrome != 0, overall parity set   : single-bit error, corrected on 'out'
//     syndrome != 0, overall parity clear : double-bit error, detected not fixed
//
// PIPELINE = 1 registers the input (one cycle of latency); PIPELINE = 0 is a
// pure combinational decoder (clk/nreset unused).
//
module hammdec
  #(parameter DW       = 64,   // information (data) bits
    parameter PW       = 8,    // parity bits (PW-1 Hamming + 1 overall)
    parameter PIPELINE = 1)    // 1 = register input, 0 = combinational
   (input              clk,      // clock (used when PIPELINE=1)
    input              nreset,   // async active-low reset (PIPELINE=1)
    input  [DW+PW-1:0] in,       // received codeword {overall, hamming, data}
    output [DW-1:0]    out,      // corrected data
    output [PW-1:0]    syndrome  // error syndrome {overall, hamming}
    );

   localparam M = PW - 1;        // number of Hamming parity bits

   integer    k;
   reg  [M-1:0]  hsyn;
   reg           allp;
   reg  [DW-1:0] corr;
   reg [DW+PW-1:0] in_r;
   wire [DW+PW-1:0] cw;

   wire [DW-1:0]    data = cw[DW-1:0];
   wire [M-1:0]     hpar = cw[DW+M-1:DW];   // received Hamming parity
   wire             opar = cw[DW+PW-1];     // received overall parity

   //#########################################################################
   // Input register (always present); PIPELINE selects whether it is used
   //#########################################################################

   always @(posedge clk or negedge nreset)
     if (!nreset)
       in_r <= {(DW+PW){1'b0}};
     else
       in_r <= in;

   assign cw = PIPELINE ? in_r : in;

   //#########################################################################
   // Hamming column for data bit 'idx': the (idx+1)-th nonzero, non-power-of-2
   // M-bit value. Power-of-2 columns are reserved for the parity bits, so data
   // and parity never share a syndrome signature.
   //#########################################################################
   function [M-1:0] hcol;
      input integer idx;
      integer i, cnt;
      begin
         cnt  = -1;
         hcol = {M{1'b0}};
         for (i = 1; i < (1 << M); i = i + 1)
           if (i & (i-1)) begin            // not a power of two
              cnt = cnt + 1;
              if (cnt == idx)
                hcol = i[M-1:0];
           end
      end
   endfunction

   //#########################################################################
   // Syndrome + single-error correction
   //#########################################################################

   always @* begin
      // Hamming syndrome: received parity XOR parity recomputed from data
      hsyn = hpar;
      for (k = 0; k < DW; k = k + 1)
        if (data[k])
          hsyn = hsyn ^ hcol(k);
      // overall parity check across the whole codeword
      allp = opar ^ (^data) ^ (^hpar);
      // flip the data bit whose column matches the syndrome (single error only)
      for (k = 0; k < DW; k = k + 1)
        corr[k] = data[k] ^ (allp & (hsyn == hcol(k)));
   end

   assign out      = corr;
   assign syndrome = {allp, hsyn};

endmodule
