//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module inc #(parameter DW = 16

	     )
   (
    //Inputs
    input [DW-1:0]  a,
    output [DW-1:0] out
    );

   assign out = a + 1'b1;

endmodule
