//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hammdec: parameterized Hsiao SEC-DED decoder.
//
// Decodes the DW+PW-bit codeword produced by hammenc: corrects any single-bit
// error and detects (without correcting) any double-bit error.
//
// Codeword on 'in' (systematic, identical to hammenc's 'out'):
//   in[DW-1:0]      : data bits
//   in[DW+PW-1:DW]  : PW check bits
//
// Codeword algorithm (Hsiao SEC-DED parity-check matrix H = [ M | I_PW ]):
//   - Check-bit columns are the PW unit vectors (the identity block).
//   - Data bit k owns column M_k = hcol(k): the k-th distinct ODD-weight PW-bit
//     vector of weight >= 3, taken lightest first (weight-3 columns, then
//     weight-5, ...). hcol MUST match hammenc; the roundtrip test guards this.
//
//   The syndrome is the XOR of the columns of all flipped bits, recomputed as
//   syndrome = received_check XOR (XOR of hcol(k) over set data bits). Because
//   every column is odd weight:
//     syndrome == 0                        : no error
//     syndrome == hcol(k) (odd wt >= 3)    : single data error, corrected
//     syndrome is a unit vector (weight 1) : single check-bit error, data clean
//     syndrome != 0 and even weight        : double error, detected not fixed
//   A single data error is therefore corrected exactly when the syndrome equals
//   that bit's column; nothing else can match an odd-weight-(>=3) column.
//
// PIPELINE = 1 registers the input (one cycle of latency); PIPELINE = 0 is a
// pure combinational decoder (clk/nreset unused).
//
module hammdec #(parameter DW = 64,      // information (data) bits
                 parameter PW = 8,       // Hsiao check bits
                 parameter PIPELINE = 1) // 1 = registered, 0 = combinational
   (
    input	      clk,     // clock (used when PIPELINE=1)
    input	      nreset,  // async active-low reset (PIPELINE=1)
    input [DW+PW-1:0] in,      // received codeword {check, data}
    output [DW-1:0]   out,     // corrected data
    output [PW-1:0]   syndrome // error syndrome (0 = clean)
    );

   // local wires
   integer          k, i, b, w, cnt;
   reg [DW+PW-1:0]  in_r;
   wire [DW+PW-1:0] cw;
   wire [DW-1:0]    data = cw[DW-1:0];
   wire [PW-1:0]    rchk = cw[DW+PW-1:DW];   // received check bits
   reg [PW-1:0]	    syn;
   reg [DW-1:0]	    corr;
   reg [PW-1:0]     col [0:DW-1];        // Hsiao column per data bit
   integer          pcnt [0:(1<<PW)-1];  // popcount of each PW-bit pattern

   //#########################################################################
   // Input register (always present); PIPELINE selects whether it is used
   //#########################################################################

   always @(posedge clk or negedge nreset)
     if (!nreset)
       in_r <= 'b0;
     else
       in_r <= in;

   assign cw = PIPELINE ? in_r : in;

   //#########################################################################
   // Hsiao data columns (must match hammenc): col[idx] is the (idx+1)-th
   // odd-weight, weight>=3 PW-bit vector, enumerated lightest weight first.
   // Built once (not searched per data bit) so elaboration stays cheap; the
   // table is constant and folds away at synthesis.
   //#########################################################################

   always @* begin
      // popcount of every PW-bit pattern
      for (i = 0; i < (1 << PW); i = i + 1) begin
         pcnt[i] = 0;
         for (b = 0; b < PW; b = b + 1)
           pcnt[i] = pcnt[i] + i[b];
      end
      // odd-weight (>=3) columns, lightest weight first
      cnt = 0;
      for (w = 3; w <= PW; w = w + 2)
        for (i = 0; i < (1 << PW); i = i + 1)
          if (pcnt[i] == w && cnt < DW) begin
             col[cnt] = i[PW-1:0];
             cnt = cnt + 1;
          end
      // syndrome: received check XOR check recomputed from data
      syn = rchk;
      for (k = 0; k < DW; k = k + 1)
        if (data[k])
          syn = syn ^ col[k];
      // a single data error makes syndrome == that bit's (odd-weight) column;
      // double errors give even-weight syndromes that match no data column
      for (k = 0; k < DW; k = k + 1)
        corr[k] = data[k] ^ (syn == col[k]);
   end

   assign out      = corr;
   assign syndrome = syn;

endmodule
