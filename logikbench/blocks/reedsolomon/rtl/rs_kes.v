//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Reed-Solomon key-equation solver: Berlekamp-Massey over GF(2^10).
//
// Given the 2t=30 syndromes, finds the error-locator polynomial Lambda(x)
// (Lambda[0]=1, degree L). One BM iteration per clock for 2t cycles. Each
// iteration computes the discrepancy delta (a dot product of Lambda with the
// syndrome history), then conditionally updates Lambda and the auxiliary B.
// Uses rs_gfmul (constant/variable) and one rs_gfinv; the discrepancy inverse
// is only applied on a length-change step (matches the reference model exactly).
//
// Mirrors the software reference berlekamp():
//   delta = S[r-1] ^ sum_{j=1..L} Lam[j]*S[r-1-j]
//   Bshift = x*B
//   if delta != 0:  Lam' = Lam ^ delta*Bshift
//                   if 2L < r:  B' = Lam * delta^-1 ; L' = r - L
//
//#############################################################################

module rs_kes
  #(parameter M = 10,
    parameter TWOT = 30,
    parameter NLAM = 16) // Lambda/B coeff count (degree <= t = 15)
   (
    input		clk,
    input		rst,
    input		start,	 // pulse with syndromes valid
    input [TWOT*M-1:0]	s_flat,	 // S[i] at s_flat[i*M +: M]
    output reg		done,	 // pulse when Lambda is ready
    output reg [4:0]	L_out,	 // error-locator degree
    output [NLAM*M-1:0]	lam_flat // Lambda[j] at lam_flat[j*M +: M]
    );

   localparam S_IDLE = 1'b0, S_RUN = 1'b1;

   reg	      state;
   reg [5:0]  r;                     // iteration index 1..2t
   reg [4:0]  L;
   reg [M-1:0] S   [0:TWOT-1];
   reg [M-1:0] Lam [0:NLAM-1];
   reg [M-1:0] B   [0:NLAM-1];

   genvar      j;
   generate
      for (j = 0; j < NLAM; j = j + 1) begin : g_lam
         assign lam_flat[j*M +: M] = Lam[j];
      end
   endgenerate

   // ---- combinational per-iteration datapath ----
   // syndrome select: Ssel(j) = S[r-1-j] when r-1 >= j, else 0
   wire [M-1:0] ssel [0:NLAM-1];
   wire [M-1:0]	td   [0:NLAM-1];       // term_d[j] = Lam[j]*Ssel(j)
   wire [M-1:0]	bsh  [0:NLAM-1];       // Bshift[j] = x*B
   wire [M-1:0]	tup  [0:NLAM-1];       // delta*Bshift[j]
   wire [M-1:0]	nbup [0:NLAM-1];       // Lam[j]*di
   generate
      for (j = 0; j < NLAM; j = j + 1) begin : g_dp
         assign ssel[j] = ((r-1) >= j) ? S[r-1-j] : {M{1'b0}};
         rs_gfmul u_td (.a(Lam[j]), .b(ssel[j]), .product(td[j]));
         if (j == 0)
           assign bsh[j] = {M{1'b0}};
         else
           assign bsh[j] = B[j-1];
      end
   endgenerate

   // discrepancy = XOR of all term_d[j]
   reg [M-1:0] delta;
   integer     t;
   always @* begin
      delta = {M{1'b0}};
      for (t = 0; t < NLAM; t = t + 1) delta = delta ^ td[t];
   end

   wire [M-1:0] di;
   rs_gfinv u_inv (.a(delta), .inv(di));

   wire dnz  = (delta != {M{1'b0}});
   wire	cond = dnz && ((L << 1) < r);   // length-change step

   generate
      for (j = 0; j < NLAM; j = j + 1) begin : g_up
         rs_gfmul u_tup  (.a(delta),  .b(bsh[j]), .product(tup[j]));
         rs_gfmul u_nbup (.a(Lam[j]), .b(di),     .product(nbup[j]));
      end
   endgenerate

   integer k;
   always @(posedge clk) begin
      if (rst) begin
         state <= S_IDLE; done <= 1'b0; L <= 0; L_out <= 0; r <= 1;
         for (k = 0; k < NLAM; k = k + 1) begin
            Lam[k] <= {M{1'b0}}; B[k] <= {M{1'b0}};
         end
      end
      else begin
         done <= 1'b0;
         case (state)
           S_IDLE: begin
              if (start) begin
                 for (k = 0; k < TWOT; k = k + 1) S[k] <= s_flat[k*M +: M];
                 Lam[0] <= {{(M-1){1'b0}}, 1'b1};   // Lam = 1
                 B[0]   <= {{(M-1){1'b0}}, 1'b1};   // B = 1
                 for (k = 1; k < NLAM; k = k + 1) begin
                    Lam[k] <= {M{1'b0}}; B[k] <= {M{1'b0}};
                 end
                 L <= 0; r <= 1; state <= S_RUN;
              end
           end
           S_RUN: begin
              // Lambda update
              for (k = 0; k < NLAM; k = k + 1)
                Lam[k] <= dnz ? (Lam[k] ^ tup[k]) : Lam[k];
              // B update: cond -> Lam*di, else shift
              for (k = 0; k < NLAM; k = k + 1)
                B[k] <= cond ? nbup[k] : bsh[k];
              if (cond) L <= r - L;
              if (r == TWOT) begin
                 state <= S_IDLE; done <= 1'b1;
                 L_out <= cond ? (r - L) : L;
              end
              r <= r + 1'b1;
           end
         endcase
      end
   end

endmodule
