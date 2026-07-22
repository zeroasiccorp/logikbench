//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module muladds #(parameter DW = 16,
                 parameter OW = 2 * DW
                 )
   (
    //Inputs
    input signed [DW-1:0]  a,  // a input (multiplier)
    input signed [DW-1:0]  b,  // b input (multiplicand)
    input signed [OW-1:0]  c,  // c input (add input)
    //Outputs
    output signed [OW-1:0] out // a * b + c
    );

   assign out = a * b + c;

endmodule
