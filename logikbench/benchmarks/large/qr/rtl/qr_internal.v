//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * qr_internal: off-diagonal (internal) cell of the systolic QR array.
 *
 * Applies the Givens rotation 'sigma' (from the boundary cell) to a column
 * pair (aj from the pivot row, ai from the row being annihilated) using the
 * CORDIC in rotation mode, then divides out the CORDIC gain K so the rotation
 * is a true (norm-preserving) orthogonal transform. KINV = round(2^15 / K) for
 * the M = 16 configuration; adjust if M changes.
 ******************************************************************************/
module qr_internal
  #(parameter IW = 32,
    parameter M  = 16)
  (
   input  wire        [M-1:0]  sigma,
   input  wire signed [IW-1:0] aj,      // pivot-row element
   input  wire signed [IW-1:0] ai,      // annihilated-row element
   output wire signed [IW-1:0] oj,
   output wire signed [IW-1:0] oi
   );

   // CORDIC gain compensation: 1/K in Q15 (K = prod sqrt(1+2^-2i), M = 16)
   localparam signed [16:0] KINV = 17'sd19898;

   wire signed [IW-1:0] xr, yr;

   qr_cordic #(.IW(IW), .M(M)) u_rot
     (.vectoring (1'b0),
      .xin       (aj),
      .yin       (ai),
      .sigma_in  (sigma),
      .xout      (xr),
      .yout      (yr),
      .sigma_out ());

   wire signed [IW+16:0] pj = xr * KINV;
   wire signed [IW+16:0] pi = yr * KINV;

   assign oj = pj >>> 15;
   assign oi = pi >>> 15;

endmodule
