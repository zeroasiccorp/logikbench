//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module sub #(parameter DW = 16
	     )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    //Outputs
    output [DW-1:0] out
    );

   assign {cout, out[DW-1:0]} = a[DW-1:0] - b[DW-1:0];

endmodule
