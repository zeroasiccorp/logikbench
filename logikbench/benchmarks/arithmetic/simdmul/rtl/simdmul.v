//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module simdmul #(parameter DW = 8,
                 parameter N = 8
                 )
   (
    //Inputs
    input [N*DW-1:0]	a,  // N packed signed operands
    input [N*DW-1:0]	b,  // N packed signed operands
    //Outputs
    output [N*2*DW-1:0]	out // N packed signed products (2*DW each)
    );

   genvar i;
   generate
      for (i = 0; i < N; i = i + 1) begin : g_lane
         assign out[i*2*DW +: 2*DW] = $signed(a[i*DW +: DW]) *
                                      $signed(b[i*DW +: DW]);
      end
   endgenerate

endmodule
