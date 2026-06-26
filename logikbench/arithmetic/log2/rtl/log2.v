//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module log2 #(parameter DW = 16
	      )
   (
    input [DW-1:0]	      a,
    output reg [$clog2(DW):0] out
    );

   integer i;
   always @(*) begin
      out = 0;
      for (i = 0; i < DW; i = i + 1) begin
         if (a[i])
           out = i;
      end
   end

endmodule
