//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module bnor #(parameter DW = 64
              )
   (
    input [DW-1:0] in,
    output         out
    );

   assign out = ~|in;

endmodule
