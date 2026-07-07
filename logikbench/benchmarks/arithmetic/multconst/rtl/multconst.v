//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module multconst #(parameter		     DW = 16,
                   parameter signed [DW-1:0] CONST = 12345,
                   parameter		     OW = 2*DW
                   )
   (
    //Inputs
    input signed [DW-1:0]  a,
    //Outputs
    output signed [OW-1:0] out // a * CONST
    );

   assign out = a * CONST;

endmodule
