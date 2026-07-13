//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// Fixed-point 3-term multiply-add for one color-conversion output channel:
//   result = ((k0*x0 + k1*x1 + k2*x2 + round) >>> SHIFT) + offset
// Coefficients are signed Q(.SHIFT) values; the caller supplies the set for the
// selected conversion. 'round' (half an LSB) gives round-to-nearest.
//#############################################################################
module colorconv_matrix
  #(parameter DW    = 8,      // pixel component width
    parameter CW    = 12,     // signed coefficient width
    parameter SHIFT = 8)      // fractional bits (coefficients scaled by 2^SHIFT)
   (
    input  signed [DW:0]      x0,
    input  signed [DW:0]      x1,
    input  signed [DW:0]      x2,
    input  signed [CW-1:0]    k0,
    input  signed [CW-1:0]    k1,
    input  signed [CW-1:0]    k2,
    input  signed [DW+1:0]    offset,
    output signed [DW+CW+3:0] result
    );

   localparam ACCW = DW + CW + 4;
   localparam signed [ACCW-1:0] RND = (1 << (SHIFT - 1));

   wire signed [ACCW-1:0] acc;

   assign acc    = (k0 * x0) + (k1 * x1) + (k2 * x2) + RND;
   assign result = (acc >>> SHIFT) + offset;

endmodule
