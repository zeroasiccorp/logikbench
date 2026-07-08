//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module argmax #(parameter N = 8,
                parameter DW = 16
                )
   (
    //Inputs
    input [N*DW-1:0]       a,  // concatenated input vector
    //Outputs
    output [$clog2(N)-1:0] out // index of the maximum element
    );


   localparam IW = $clog2(N);

   wire [DW-1:0] av [0:N-1];   // running maximum value
   wire [IW-1:0] ai [0:N-1];   // running argmax index
   genvar	 i;


   // Index of the maximum of N unsigned elements
   // On a tie the lowest index wins.

   assign av[0] = a[0 +: DW];
   assign ai[0] = {IW{1'b0}};

   generate
      for (i = 1; i < N; i = i + 1) begin : g_argmax
         wire sel = (a[i*DW +: DW] > av[i-1]);
         assign av[i] = sel ? a[i*DW +: DW] : av[i-1];
         assign ai[i] = sel ? i[IW-1:0]     : ai[i-1];
      end
   endgenerate

   assign out = ai[N-1];

endmodule
