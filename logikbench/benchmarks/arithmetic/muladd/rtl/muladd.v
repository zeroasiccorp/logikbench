//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module muladd #(parameter DW = 16,
                parameter OW = 2 * DW
	        )
   (
    //Inputs
    input [DW-1:0]  a,  // a input (multiplier)
    input [DW-1:0]  b,  // b input (multiplicand)
    input [OW-1:0]  c,  // c input (add input)
    //Outputs
    output [OW-1:0] out // a * b + c
    );

   assign out = a * b + c;

endmodule
