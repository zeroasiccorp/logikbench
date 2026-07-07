//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module addtree #(parameter N = 64, // number of inputs (power of 2)
                 parameter DW = 16 // width of each input
                 )
   (
    input [N*DW-1:0]		a,  // concatenated input vector (N words)
    output [DW + $clog2(N)-1:0]	out // sum of all N inputs
    );

   // Local parameters
   localparam L  = $clog2(N);   // number of tree levels
   localparam OW = DW + L;      // output / max node width

   // Balanced binary reduction tree
   wire [OW-1:0] node [1:2*N-1];

   genvar	 i;
   generate
      // leaves: zero-extend each input word to the max node width
      for (i = 0; i < N; i = i + 1) begin : g_leaf
         assign node[N+i] = {{(OW-DW){1'b0}}, a[i*DW +: DW]};
      end
      // internal nodes: one adder per node (balanced tree)
      for (i = 1; i < N; i = i + 1) begin : g_add
         assign node[i] = node[2*i] + node[2*i+1];
      end
   endgenerate

   assign out = node[1];

endmodule
