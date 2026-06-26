//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// GF(2^10) multiplicative inverse via a power chain: a^-1 = a^(2^10-2) = a^1022.
// 1022 = 2+4+8+...+512, so a^1022 = prod_{k=1..9} a^(2^k). The a^(2^k) terms are
// successive squares (each a GF multiply by itself); they are combined by a
// product chain. All combinational, built from rs_gfmul instances (no ROM, no
// function). inv(0) is defined as 0.
//
//#############################################################################

module rs_gfinv
  (
   input [9:0]	a,
   output [9:0]	inv
   );

   // q[k] = a^(2^k), k = 1..9  (q[1]=a^2, q[2]=a^4, ... q[9]=a^512)
   wire [9:0] q [1:9];
   rs_gfmul u_sq1 (.a(a),    .b(a),    .product(q[1]));
   genvar k;
   generate
      for (k = 2; k <= 9; k = k + 1) begin : g_sq
         rs_gfmul u_sq (.a(q[k-1]), .b(q[k-1]), .product(q[k]));
      end
   endgenerate

   // product chain: p[k] = q[1]*...*q[k]; inv = p[9]
   wire [9:0] p [1:9];
   assign p[1] = q[1];
   generate
      for (k = 2; k <= 9; k = k + 1) begin : g_pr
         rs_gfmul u_pr (.a(p[k-1]), .b(q[k]), .product(p[k]));
      end
   endgenerate

   assign inv = p[9];

endmodule
