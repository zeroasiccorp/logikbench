//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module sigmoid #(parameter DW = 16, // total width
                 parameter QW = 8   // fractional bits, Q(DW-QW).QW, QW>=5
                 )
   (
    //Inputs
    input signed [DW-1:0]  x,
    //Outputs
    output signed [DW-1:0] out // sigmoid(x) in [0,1]
    );

   // PLAN piecewise-linear sigmoid (Amin, Curtis, Hayes-Gill, 1997). The slopes
   // are powers of two (1/4, 1/8, 1/32), so each segment is an arithmetic shift
   // plus a constant offset -- no multiplier. Evaluated on |x| and mirrored,
   // since sigmoid(-x) = 1 - sigmoid(x).
   //   |x| >= 5.0            : 1.0
   //   2.375 <= |x| < 5.0    : |x|/32 + 0.84375
   //   1.0   <= |x| < 2.375  : |x|/8  + 0.625
   //   0.0   <= |x| < 1.0    : |x|/4  + 0.5
   localparam signed [DW:0] ONE = (1 <<< QW);           // 1.0
   localparam signed [DW:0] B1  = (1 <<< QW);           // 1.0
   localparam signed [DW:0] B2  = (19 <<< QW) >>> 3;    // 2.375
   localparam signed [DW:0] B3  = (5 <<< QW);           // 5.0
   localparam signed [DW:0] O0  = (1 <<< QW) >>> 1;     // 0.5
   localparam signed [DW:0] O1  = (5 <<< QW) >>> 3;     // 0.625
   localparam signed [DW:0] O2  = (27 <<< QW) >>> 5;    // 0.84375

   wire signed [DW:0]	    xabs;
   wire signed [DW:0]	    y;

   assign xabs = x[DW-1] ? -x : x;

   assign y = (xabs >= B3) ? ONE :
              (xabs >= B2) ? ((xabs >>> 5) + O2) :
              (xabs >= B1) ? ((xabs >>> 3) + O1) :
              ((xabs >>> 2) + O0);

   assign out = x[DW-1] ? (ONE - y) : y;

endmodule
