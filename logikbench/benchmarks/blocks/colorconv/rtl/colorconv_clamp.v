//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// Saturate a signed intermediate result to the unsigned pixel range
// [0, 2^DW - 1].
//#############################################################################
module colorconv_clamp
  #(parameter DW = 8,
    parameter IW = 24)          // width of the incoming signed value
   (
    input  signed [IW-1:0] val,
    output [DW-1:0]        pixel
    );

   localparam signed [IW-1:0] MAXV = (1 << DW) - 1;

   assign pixel = (val < 0)    ? {DW{1'b0}} :
                  (val > MAXV) ? {DW{1'b1}} :
                                 val[DW-1:0];

endmodule
