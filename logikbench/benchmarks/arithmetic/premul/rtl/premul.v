//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module premul #(parameter DW = 16,
                parameter OW = 2*DW+1
                )
   (
    //Inputs
    input signed [DW-1:0]  a,  // pre-adder input a
    input signed [DW-1:0]  d,  // pre-adder input d
    input signed [DW-1:0]  b,  // multiplicand (shared coefficient)
    //Outputs
    output signed [OW-1:0] out // (a + d) * b
    );

   assign out = (a + d) * b;

endmodule
