//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module tanh #(parameter	DW = 16, // total width
              parameter	QW = 8	 // fractional bits, Q(DW-QW).QW, QW>=5
              )
   (
    //Inputs
    input signed [DW-1:0]  x,
    //Outputs
    output signed [DW-1:0] out // tanh(x) in [-1,1]
    );

   // tanh(x) = 2*sigmoid(2x) - 1. The sigmoid uses the PLAN piecewise-linear
   // approximation (Amin/Curtis/Hayes-Gill 1997): power-of-two slopes so each
   // segment is an arithmetic shift plus a constant, evaluated on |2x| and
   // mirrored (sigmoid(-u) = 1 - sigmoid(u)).
   localparam signed [DW:0] ONE = (1 <<< QW);           // 1.0
   localparam signed [DW:0] B1  = (1 <<< QW);           // 1.0
   localparam signed [DW:0] B2  = (19 <<< QW) >>> 3;    // 2.375
   localparam signed [DW:0] B3  = (5 <<< QW);           // 5.0
   localparam signed [DW:0] O0  = (1 <<< QW) >>> 1;     // 0.5
   localparam signed [DW:0] O1  = (5 <<< QW) >>> 3;     // 0.625
   localparam signed [DW:0] O2  = (27 <<< QW) >>> 5;    // 0.84375

   wire signed [DW+1:0]	    x2;
   wire signed [DW+1:0]	    xabs;
   wire signed [DW+1:0]	    y;
   wire signed [DW+1:0]	    sig;

   assign x2   = x <<< 1;                       // 2x
   assign xabs = x2[DW+1] ? -x2 : x2;

   assign y = (xabs >= B3) ? ONE :
              (xabs >= B2) ? ((xabs >>> 5) + O2) :
              (xabs >= B1) ? ((xabs >>> 3) + O1) :
              ((xabs >>> 2) + O0);

   assign sig = x2[DW+1] ? (ONE - y) : y;       // sigmoid(2x) in [0,1]
   assign out = (sig <<< 1) - ONE;              // 2*sigmoid(2x) - 1

endmodule
