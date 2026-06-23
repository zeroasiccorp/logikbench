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
   integer          k;
   reg [DW+PW-1:0]  in_r;
   wire [DW+PW-1:0] cw;
   wire [DW-1:0]    data = cw[DW-1:0];
   wire [PW-1:0]    rchk = cw[DW+PW-1:DW];   // received check bits
   reg [PW-1:0]	    syn;
   reg [DW-1:0]	    corr;

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
   // Hsiao data column for data bit 'idx' (must match hammenc): the (idx+1)-th
   // odd-weight, weight>=3 PW-bit vector, enumerated lightest weight first.
   //#########################################################################

   function [PW-1:0] hcol;
      input integer idx;
      integer	    w, i, b, pc, cnt;
      begin
         cnt  = -1;
         hcol = {PW{1'b0}};
         for (w = 3; w <= PW; w = w + 2)            // odd weights >= 3
           for (i = 0; i < (1 << PW); i = i + 1) begin
              pc = 0;
              for (b = 0; b < PW; b = b + 1)
                pc = pc + i[b];
              if (pc == w) begin
                 cnt = cnt + 1;
                 if (cnt == idx)
                   hcol = i[PW-1:0];
              end
           end
      end
   endfunction

   //#########################################################################
   // Syndrome + single-error correction
   //#########################################################################

   always @* begin
      // syndrome: received check XOR check recomputed from data
      syn = rchk;
      for (k = 0; k < DW; k = k + 1)
        if (data[k])
          syn = syn ^ hcol(k);
      // a single data error makes syndrome == that bit's (odd-weight) column;
      // double errors give even-weight syndromes that match no data column
      for (k = 0; k < DW; k = k + 1)
        corr[k] = data[k] ^ (syn == hcol(k));
   end

   assign out      = corr;
   assign syndrome = syn;

endmodule
