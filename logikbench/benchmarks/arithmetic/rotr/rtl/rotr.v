//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module rotr #(parameter DW = 16
              )
   (
    //Inputs
    input [DW-1:0]	   a,  // data
    input [$clog2(DW)-1:0] b,  // rotate amount
    //Outputs
    output [DW-1:0]	   out // a rotated right by b (barrel rotate)
    );

   // Rotate right: bits shifted off the bottom re-enter at the top.
   assign out[DW-1:0] = (a >> b) | (a << (DW - b));

endmodule
