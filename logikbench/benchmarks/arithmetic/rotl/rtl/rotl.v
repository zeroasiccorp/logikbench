//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module rotl #(parameter DW = 16
              )
   (
    //Inputs
    input [DW-1:0]	   a,  // data
    input [$clog2(DW)-1:0] b,  // rotate amount
    //Outputs
    output [DW-1:0]	   out // a rotated left by b (barrel rotate)
    );

   // Rotate left: bits shifted off the top re-enter at the bottom.
   assign out[DW-1:0] = (a << b) | (a >> (DW - b));

endmodule
