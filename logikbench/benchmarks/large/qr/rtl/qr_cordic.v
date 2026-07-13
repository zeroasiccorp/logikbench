//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * qr_cordic: unrolled circular-mode CORDIC engine (combinational).
 *
 * Two modes select how the per-iteration rotation direction is chosen:
 *   vectoring = 1 : drive yin toward 0 (choose d = -sign(y) each step) and
 *                   record the direction bits in sigma_out. xout is then the
 *                   CORDIC-gain-scaled magnitude, yout ~ 0.
 *   vectoring = 0 : replay a recorded direction sequence sigma_in, i.e. rotate
 *                   (xin,yin) by the same angle a prior vectoring pass found.
 *
 * Both modes apply the same M micro-rotations, so a vectoring pass on a pivot
 * pair and rotation passes on the other column pairs form one Givens rotation.
 * The output carries the CORDIC gain K = prod sqrt(1+2^-2i); callers divide it
 * out (see qr_internal). Datapath is signed and assumes a first-quadrant pivot
 * (x >= 0), which holds for the diagonally dominant, positive-diagonal inputs
 * this block targets.
 ******************************************************************************/
module qr_cordic
  #(parameter IW = 32,          // datapath width (signed)
    parameter M  = 16)          // number of CORDIC micro-rotations
  (
   input  wire                vectoring,     // 1 = compute angle, 0 = apply it
   input  wire signed [IW-1:0] xin,
   input  wire signed [IW-1:0] yin,
   input  wire        [M-1:0]  sigma_in,      // applied when !vectoring
   output wire signed [IW-1:0] xout,
   output wire signed [IW-1:0] yout,
   output wire        [M-1:0]  sigma_out      // recorded when vectoring
   );

   integer i;
   reg signed [IW-1:0] x [0:M];
   reg signed [IW-1:0] y [0:M];
   reg        [M-1:0]  sig;
   reg                 dpos;                  // 1 if this step rotates by +angle

   always @* begin
      x[0] = xin;
      y[0] = yin;
      sig  = {M{1'b0}};
      for (i = 0; i < M; i = i + 1) begin
         if (vectoring)
           // reduce |y|: rotate by -angle when y >= 0, by +angle when y < 0
           dpos = y[i][IW-1];                 // sign bit: 1 = negative -> +angle
         else
           dpos = sigma_in[i];
         sig[i] = dpos;
         if (dpos) begin
            x[i+1] = x[i] - (y[i] >>> i);
            y[i+1] = y[i] + (x[i] >>> i);
         end
         else begin
            x[i+1] = x[i] + (y[i] >>> i);
            y[i+1] = y[i] - (x[i] >>> i);
         end
      end
   end

   assign xout      = x[M];
   assign yout      = y[M];
   assign sigma_out = sig;

endmodule
