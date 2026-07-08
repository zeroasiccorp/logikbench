//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module clamp #(parameter DW = 16
               )
   (
    //Inputs
    input signed [DW-1:0]  a,  // value to clamp
    input signed [DW-1:0]  lo, // lower bound (inclusive)
    input signed [DW-1:0]  hi, // upper bound (inclusive)
    //Outputs
    output signed [DW-1:0] out // a clamped to [lo, hi]
    );

   // Saturate/clip a signed value into the inclusive range [lo, hi].
   assign out = (a < lo) ? lo :
                (a > hi) ? hi : a;

endmodule
