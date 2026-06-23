//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module absdiffs #(parameter DW = 16
	         )
   (
    //Inputs
    input signed [DW-1:0] a,
    input signed [DW-1:0] b,
    //Outputs
    output [DW-1:0]       out
    );

   wire [DW-1:0] diff;

   assign diff = a - b;
   assign out = (diff < 0) ? -diff : diff;

endmodule
