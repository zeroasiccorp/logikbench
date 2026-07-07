//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module gelu #(parameter	DW = 16, // total width
              parameter	QW = 8	 // fractional bits, Q(DW-QW).QW, QW>=5
              )
   (
    //Inputs
    input signed [DW-1:0]  x,
    //Outputs
    output signed [DW-1:0] out // GELU(x)
    );

   // GELU(x) ~= x * sigmoid(1.702*x) (the sigmoid approximation of GELU). The
   // sigmoid uses the PLAN piecewise-linear approximation (power-of-two slopes,
   // shift-and-add segments), evaluated on |1.702*x| and mirrored. Two
   // multiplies: 1.702*x and x*sigmoid.
   localparam signed [DW:0] ONE = (1 <<< QW);           // 1.0
   localparam signed [DW:0] B1  = (1 <<< QW);           // 1.0
   localparam signed [DW:0] B2  = (19 <<< QW) >>> 3;    // 2.375
   localparam signed [DW:0] B3  = (5 <<< QW);           // 5.0
   localparam signed [DW:0] O0  = (1 <<< QW) >>> 1;     // 0.5
   localparam signed [DW:0] O1  = (5 <<< QW) >>> 3;     // 0.625
   localparam signed [DW:0] O2  = (27 <<< QW) >>> 5;    // 0.84375
   localparam signed [DW:0] K   = (1702 * (1 <<< QW) + 500) / 1000;   // 1.702

   wire signed [2*DW:0]	    sarg;
   wire signed [2*DW:0]	    xabs;
   wire signed [2*DW:0]	    y;
   wire signed [2*DW:0]	    sig;
   wire signed [2*DW:0]	    prod;

   assign sarg = (x * K) >>> QW;                // 1.702*x
   assign xabs = sarg[2*DW] ? -sarg : sarg;

   assign y = (xabs >= B3) ? ONE :
              (xabs >= B2) ? ((xabs >>> 5) + O2) :
              (xabs >= B1) ? ((xabs >>> 3) + O1) :
              ((xabs >>> 2) + O0);

   assign sig  = sarg[2*DW] ? (ONE - y) : y;    // sigmoid(1.702*x)
   assign prod = (x * sig) >>> QW;              // x * sigmoid(1.702*x)
   assign out  = prod[DW-1:0];

endmodule
