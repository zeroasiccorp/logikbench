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
module hammenc
  #(parameter DW       = 64,   // information (data) bits
    parameter PW       = 8,    // Hsiao check bits
    parameter PIPELINE = 1)    // 1 = register input, 0 = combinational
   (input              clk,      // clock (used when PIPELINE=1)
    input              nreset,   // async active-low reset (PIPELINE=1)
    input  [DW-1:0]    in,       // data
    output [DW+PW-1:0] out       // codeword {check, data}
    );

   //#########################################################################
   // Input register (always present); PIPELINE selects whether it is used
   //#########################################################################
   reg  [DW-1:0] in_r;
   wire [DW-1:0] data;

   always @(posedge clk or negedge nreset)
     if (!nreset)
       in_r <= {DW{1'b0}};
     else
       in_r <= in;

   assign data = PIPELINE ? in_r : in;

   //#########################################################################
   // Hsiao data column for data bit 'idx' (must match hammdec): the (idx+1)-th
   // odd-weight, weight>=3 PW-bit vector, enumerated lightest weight first.
   //#########################################################################
   function [PW-1:0] hcol;
      input integer idx;
      integer w, i, b, pc, cnt;
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
   // Check-bit generation: check[i] = XOR of columns of all set data bits
   //#########################################################################
   integer       k;
   reg  [PW-1:0] chk;
   always @* begin
      chk = {PW{1'b0}};
      for (k = 0; k < DW; k = k + 1)
        if (data[k])
          chk = chk ^ hcol(k);
   end

   assign out = {chk, data};

endmodule
