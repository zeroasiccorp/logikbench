//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module avgn #(parameter	N = 8,
              parameter	DW = 16
              )
   (
    //Inputs
    input [N*DW-1:0] a,	 // concatenated input vector
    //Outputs
    output [DW-1:0]  out // floor(mean) of the N elements (unsigned)
    );

   localparam SW = DW + $clog2(N);

   wire [SW-1:0] acc [0:N-1];
   genvar	 i;

   // N-input average (e.g. average pooling): sum the N elements,
   // then divide by constant N.

   assign acc[0] = a[0 +: DW];

   generate
      for (i = 1; i < N; i = i + 1) begin : g_sum
         assign acc[i] = acc[i-1] + a[i*DW +: DW];
      end
   endgenerate

   assign out = acc[N-1] / N;

endmodule
