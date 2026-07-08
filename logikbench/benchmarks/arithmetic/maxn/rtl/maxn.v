//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module maxn #(parameter	N = 8,
              parameter	DW = 16
              )
   (
    //Inputs
    input [N*DW-1:0] a,	 // concatenated input vector
    //Outputs
    output [DW-1:0]  out // maximum element (unsigned)
    );


   wire [DW-1:0] acc [0:N-1];
   genvar	 i;

   // One comparator/select per element, chained via generate;
   // acc[i] is the running maximum of elements 0..i.

   assign acc[0] = a[0 +: DW];

   generate
      for (i = 1; i < N; i = i + 1) begin : g_max
         assign acc[i] = (a[i*DW +: DW] > acc[i-1]) ? a[i*DW +: DW]
                         : acc[i-1];
      end
   endgenerate

   assign out = acc[N-1];

endmodule
