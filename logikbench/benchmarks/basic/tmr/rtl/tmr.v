//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module tmr #(parameter DW = 64
             )
   (
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    input [DW-1:0]  c,
    output [DW-1:0] out	// per-bit 2-of-3 majority vote
    );

   assign out = (a & b) | (a & c) | (b & c);

endmodule
