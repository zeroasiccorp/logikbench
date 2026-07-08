//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module popcount #(parameter DW = 16
                  )
   (
    //Inputs
    input [DW-1:0]	  a,
    //Outputs
    output [$clog2(DW):0] out // number of set bits (population count), 0..DW
    );


   localparam OW = $clog2(DW) + 1;

   wire [OW-1:0] acc [0:DW];
   genvar        i;

   // Population count
   // Leaving optimization work to synthesis!

   assign acc[0] = {OW{1'b0}};

   generate
      for (i = 0; i < DW; i = i + 1) begin : g_pop
         assign acc[i+1] = acc[i] + a[i];
      end
   endgenerate

   assign out = acc[DW];

endmodule
