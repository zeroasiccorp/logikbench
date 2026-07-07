//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module lrelu #(parameter DW = 16,
               parameter ASHIFT = 7 // negative slope = 2^-ASHIFT
               )
   (
    //Inputs
    input signed [DW-1:0]  in,
    //Outputs
    output signed [DW-1:0] out
    );

   // Leaky ReLU: pass positives through, scale negatives by 2^-ASHIFT with an
   // arithmetic right shift (a hardware-friendly power-of-two leak slope).
   assign out = (in >= 0) ? in : (in >>> ASHIFT);

endmodule
