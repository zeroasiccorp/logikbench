//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module clz #(parameter DW = 16
             )
   (
    //Inputs
    input [DW-1:0]	  a,
    //Outputs
    output [$clog2(DW):0] out // count of leading (MSB-side) zeros, 0..DW
    );


   localparam OW = $clog2(DW) + 1;

   wire [OW-1:0] cnt [0:DW];
   wire		 fnd [0:DW];
   genvar	 i;


   // Count leading zeros via a generate chain scanning from the MSB: each stage
   // tracks whether a set bit has been seen (fnd) and the running zero count
   // (cnt).

   assign cnt[0] = {OW{1'b0}};
   assign fnd[0] = 1'b0;

   generate
      for (i = 0; i < DW; i = i + 1) begin : g_clz
         wire abit = a[DW-1-i];              // scan MSB down
         assign fnd[i+1] = fnd[i] | abit;
         assign cnt[i+1] = cnt[i] + (~fnd[i] & ~abit);
      end
   endgenerate

   assign out = cnt[DW];

endmodule
