//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * qr: fixed-point QR decomposition (A = Q*R) by CORDIC Givens rotations.
 *
 * A is loaded in parallel as a flattened N*N word matrix (row-major, signed
 * DW-bit); 'start' begins the triangularization and 'done' pulses when the
 * flattened upper-triangular R is valid on r_out. Internally the matrix is
 * carried at IW-bit precision with F fractional bits (the CORDIC needs
 * fractional headroom to converge on integer-scale inputs).
 *
 * A small FSM sequences one Givens rotation per cycle over the sub-diagonal
 * (pivot, row) pairs; each cycle feeds the two affected rows through the
 * combinational qr_array (boundary + internal CORDIC cells), which annihilates
 * one sub-diagonal element and updates the trailing columns in parallel. After
 * the last pair the working matrix is upper-triangular R.
 *
 * The CORDIC datapath assumes first-quadrant pivots (positive diagonal), which
 * holds for the well-conditioned, diagonally dominant matrices this benchmark
 * targets.
 ******************************************************************************/
module qr
  #(parameter N  = 16,           // matrix dimension (N x N)
    parameter DW = 16)          // signed I/O word width
  (
   input               clk,
   input               reset_n,
   input               start,
   input [N*N*DW-1:0]  a_in, // row-major, signed
   output reg          done,
   output [N*N*DW-1:0] r_out // row-major upper-triangular R
   );

   localparam IW  = DW + 16;    // internal width (guard + fractional)
   localparam M   = 16;         // CORDIC micro-rotations
   localparam F   = 8;          // fractional bits for CORDIC precision
   localparam IDW = 8;          // pivot/row index width (ample for N up to 256)

   // working matrix, row-major, IW-bit signed
   reg signed [IW-1:0] W [0:N*N-1];

   reg [IDW:0] jr;              // pivot row / column
   reg [IDW:0] ir;              // row being annihilated

   localparam IDLE = 2'd0,
              RUN  = 2'd1,
              DONE = 2'd2;
   reg [1:0] state;

   integer k;

   // gather the two active rows for the combinational array
   reg  [N*IW-1:0] row_j_flat;
   reg  [N*IW-1:0] row_i_flat;
   always @* begin
      row_j_flat = {(N*IW){1'b0}};
      row_i_flat = {(N*IW){1'b0}};
      for (k = 0; k < N; k = k + 1) begin
         row_j_flat[k*IW +: IW] = W[jr*N + k];
         row_i_flat[k*IW +: IW] = W[ir*N + k];
      end
   end

   wire [N*IW-1:0] row_j_upd;
   wire [N*IW-1:0] row_i_upd;

   qr_array #(.N(N), .IW(IW), .M(M), .IDW(IDW)) u_array
     (.row_j_in  (row_j_flat),
      .row_i_in  (row_i_flat),
      .pivot     (jr[IDW-1:0]),
      .row_j_out (row_j_upd),
      .row_i_out (row_i_upd));

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state <= IDLE;
         done  <= 1'b0;
         jr    <= {(IDW+1){1'b0}};
         ir    <= {(IDW+1){1'b0}};
      end
      else begin
         done <= 1'b0;
         case (state)
           IDLE:
             if (start) begin
                // load A, sign-extended and shifted into the fractional domain
                for (k = 0; k < N*N; k = k + 1)
                  W[k] <= $signed(a_in[k*DW +: DW]) <<< F;
                jr    <= {(IDW+1){1'b0}};
                ir    <= {{(IDW){1'b0}}, 1'b1};   // i = 1
                state <= RUN;
             end

           RUN: begin
              // commit this Givens rotation
              for (k = 0; k < N; k = k + 1) begin
                 W[jr*N + k] <= row_j_upd[k*IW +: IW];
                 W[ir*N + k] <= row_i_upd[k*IW +: IW];
              end
              // advance over (pivot, row) pairs
              if (ir == (N-1)) begin
                 if (jr == (N-2)) begin
                    state <= DONE;
                    done  <= 1'b1;
                 end
                 else begin
                    jr <= jr + 1'b1;
                    ir <= jr + 2'd2;
                 end
              end
              else
                ir <= ir + 1'b1;
           end

           DONE:
             if (start) state <= IDLE;   // accept a new job

           default: state <= IDLE;
         endcase
      end
   end

   // drain R: shift out of the fractional domain, low DW bits, row-major
   genvar g;
   generate
      for (g = 0; g < N*N; g = g + 1) begin: outmap
         assign r_out[g*DW +: DW] = W[g] >>> F;
      end
   endgenerate

endmodule
