//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module macs #(parameter	DW = 8,
              parameter	ACCW = 32
              )
   (
    input			 clk,
    input			 clear,
    input			 en,
    input signed [DW-1:0]	 a, // signed operand (activation)
    input signed [DW-1:0]	 b, // signed operand (weight)
    output reg signed [ACCW-1:0] c  // signed accumulator
    );

   always @(posedge clk) begin
      if (clear)
        c <= 0;
      else if (en)
        c <= c + a * b;
   end

endmodule
