//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * qr_boundary: diagonal (boundary) cell of the systolic QR array.
 *
 * Runs the CORDIC in vectoring mode on the pivot pair (the diagonal element x
 * and the sub-diagonal element y to be annihilated), producing the rotation
 * direction sequence 'sigma'. That angle is passed east to the internal cells,
 * which apply the same rotation to the rest of the two rows.
 ******************************************************************************/
module qr_boundary
  #(parameter IW = 32,
    parameter M  = 16)
  (
   input  wire signed [IW-1:0] x,        // pivot diagonal element
   input  wire signed [IW-1:0] y,        // element to annihilate
   output wire        [M-1:0]  sigma     // rotation angle (direction bits)
   );

   qr_cordic #(.IW(IW), .M(M)) u_vec
     (.vectoring (1'b1),
      .xin       (x),
      .yin       (y),
      .sigma_in  ({M{1'b0}}),
      .xout      (),
      .yout      (),
      .sigma_out (sigma));

endmodule
