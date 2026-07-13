//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * qr_array: one Givens-rotation update across two matrix rows.
 *
 * The boundary cell derives the rotation 'sigma' from the pivot column PIVOT of
 * the two rows (row_j = pivot row, row_i = row being annihilated). An internal
 * cell then applies that rotation to every column. Columns k < PIVOT are already
 * settled (row_i is zero there from earlier steps) and pass through unchanged;
 * columns k >= PIVOT take the rotated result, driving row_i[PIVOT] to zero.
 *
 * This is the Gentleman-Kung triangular QR mapped so that one array pass
 * annihilates one sub-diagonal element while updating the trailing columns in
 * parallel; the top-level FSM sequences the passes over all (pivot, row) pairs.
 ******************************************************************************/
module qr_array
  #(parameter N   = 4,
    parameter IW  = 32,
    parameter M   = 16,
    parameter IDW = 2)          // ceil(log2(N)) index width
  (
   input [N*IW-1:0]  row_j_in,
   input [N*IW-1:0]  row_i_in,
   input [IDW-1:0]   pivot,
   output [N*IW-1:0] row_j_out,
   output [N*IW-1:0] row_i_out
   );

   // pivot-column pair (variable indexed part-select)
   wire signed [IW-1:0] px = row_j_in[pivot*IW +: IW];
   wire signed [IW-1:0] py = row_i_in[pivot*IW +: IW];

   wire [M-1:0] sigma;
   qr_boundary #(.IW(IW), .M(M)) u_bnd (.x(px), .y(py), .sigma(sigma));

   genvar k;
   generate
      for (k = 0; k < N; k = k + 1) begin: col
         wire signed [IW-1:0] aj = row_j_in[k*IW +: IW];
         wire signed [IW-1:0] ai = row_i_in[k*IW +: IW];
         wire signed [IW-1:0] rj;
         wire signed [IW-1:0] ri;

         qr_internal #(.IW(IW), .M(M)) u_int
           (.sigma(sigma), .aj(aj), .ai(ai), .oj(rj), .oi(ri));

         // columns before the pivot are untouched; pivot and beyond rotate
         assign row_j_out[k*IW +: IW] = (k < pivot) ? aj : rj;
         assign row_i_out[k*IW +: IW] = (k < pivot) ? ai : ri;
      end
   endgenerate

endmodule
