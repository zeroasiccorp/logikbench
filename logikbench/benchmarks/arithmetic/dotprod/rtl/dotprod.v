//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module dotprod #(parameter N = 8,
                 parameter DW = 16
                 )
   (
    input [N*DW-1:0]               a,  // concatenated input vector a
    input [N*DW-1:0]               b,  // concatenated input vector b
    output [2*DW + $clog2(N) -1:0] out // Sum of products (full precision)
    );

   // Internal variables
   integer i;
   // 2*DW holds each DWxDW product without truncation; +clog2(N) for the sum
   reg [2*DW + $clog2(N) -1:0] sum;

   // Unpack elements and compute dot product
   always @(*) begin
      sum = 0;
      for (i = 0; i < N; i = i + 1) begin
         sum = sum + (a[i*DW +: DW] * b[i*DW +: DW]);
      end
   end

   assign out = sum;

endmodule
