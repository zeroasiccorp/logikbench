//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module mulsu #(parameter DW = 16,
               parameter OW = 32
               )
   (
    //Inputs
    input signed [DW-1:0]  a, // signed multiplier
    input [DW-1:0]	   b, // unsigned multiplicand
    //Outputs
    output signed [OW-1:0] c  // a * b (signed x unsigned product)
    );

   assign c = a * $signed({1'b0, b});

endmodule
