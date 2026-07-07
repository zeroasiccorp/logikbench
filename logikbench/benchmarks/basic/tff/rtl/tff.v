//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module tff #(parameter DW = 64
             )
   (
    input		clk,
    input		nreset,	// async reset, active low
    input		t,	// toggle enable
    output reg [DW-1:0]	q
    );

   always @(posedge clk or negedge nreset)
     if (!nreset)
       q <= {DW{1'b0}};
     else if (t)
       q <= ~q;

endmodule
