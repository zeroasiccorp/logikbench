//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hammenc: parameterized Hsiao SEC-DED encoder.
//
// Produces the DW+PW-bit codeword that hammdec decodes: PW check bits over a
// DW-bit data word, single-error-correcting / double-error-detecting.
//
// Codeword on 'out' (systematic, identical to hammdec's 'in'):
//   out[DW-1:0]      : data bits
//   out[DW+PW-1:DW]  : PW check bits
//
// Codeword algorithm (Hsiao SEC-DED parity-check matrix H = [ M | I_PW ]):
//   - The check-bit columns are the PW unit vectors (weight 1), so the check
//     bits form the identity block and sit in out[DW+PW-1:DW].
//   - Data bit k is assigned column M_k = hcol(k): the k-th distinct ODD-weight
//     PW-bit vector of weight >= 3, taken lightest first (all weight-3 columns,
//     then weight-5, ...). Minimum, balanced weight gives shallow parity trees.
//   - Check bit i = XOR of every data bit whose column has bit i set, i.e.
//     check[i] = XOR_k ( data[k] & hcol(k)[i] ), which forces H * codeword = 0.
//
//   Because every column is odd weight, any single-bit error produces an
//   odd-weight (nonzero) syndrome and any double-bit error an even-weight
//   nonzero syndrome, so the decoder can correct singles and detect doubles
//   (see hammdec). PW must satisfy: count of odd-weight, weight>=3 PW-bit
//   columns >= DW (e.g. DW=64 needs PW=8: 56 weight-3 + 8 weight-5).
//
// PIPELINE = 1 registers the input (one cycle of latency); PIPELINE = 0 is a
// pure combinational encoder (clk/nreset unused).
//
module hammenc #(parameter DW = 64,      // information (data) bits
                 parameter PW = 8,       // Hsiao check bits
                 parameter PIPELINE = 1) // 1 = registered, 0 = combinational
   (
    input              clk,    // clock (used when PIPELINE=1)
    input              nreset, // async active-low reset (PIPELINE=1)
    input [DW-1:0]     in,     // data
    output [DW+PW-1:0] out     // codeword {check, data}
    );

   // local wires
   integer       k, i, b, w, cnt;
   reg [DW-1:0]	 in_r;
   wire [DW-1:0] data;
   reg [PW-1:0]	 chk;
   reg [PW-1:0]  col [0:DW-1];        // Hsiao column per data bit
   integer       pcnt [0:(1<<PW)-1];  // popcount of each PW-bit pattern

   //#########################################################################
   // Input register (always present); PIPELINE selects whether it is used
   //#########################################################################

   always @(posedge clk or negedge nreset)
     if (!nreset)
       in_r <= 'b0;
     else
       in_r <= in;

   assign data = PIPELINE ? in_r : in;

   //#########################################################################
   // Hsiao data columns (must match hammdec): col[idx] is the (idx+1)-th
   // odd-weight, weight>=3 PW-bit vector, enumerated lightest weight first.
   // The table is built once (not searched per data bit) so elaboration stays
   // cheap; it is constant and folds away at synthesis. Then check[i] = XOR of
   // the columns of all set data bits.
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
      // check bits
      chk = {PW{1'b0}};
      for (k = 0; k < DW; k = k + 1)
        if (data[k])
          chk = chk ^ col[k];
   end

   assign out = {chk, data};

endmodule
