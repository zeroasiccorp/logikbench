//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module hswish #(parameter DW = 16, // total width
                parameter QW = 8   // fractional bits, Q(DW-QW).QW
                )
   (
    //Inputs
    input signed [DW-1:0]  x,
    //Outputs
    output signed [DW-1:0] out // hardswish(x) = x * relu6(x+3) / 6
    );

   // Hard-swish: out = x * clamp(x+3, 0, 6) / 6, evaluated by region.
   //   x <= -3 : 0
   //   x >=  3 : x     (relu6(x+3) saturates to 6)
   //   else    : x*(x+3)/6
   // Fixed-point Q(DW-QW).QW; THREE/SIX are the constants 3.0 and 6.0. The
   // divide-by-SIX is a compile-time constant divide (maps to mult+shift).
   localparam signed [DW:0] THREE = 3 <<< QW;
   localparam signed [DW:0] SIX  = 6 <<< QW;

   wire signed [2*DW:0]	    prod;
   wire signed [2*DW:0]	    mid;

   assign prod = x * (x + THREE);       // x*(x+3), wide
   assign mid  = prod / SIX;            // x*(x+3)/6

   assign out = (x <= -THREE) ? {DW{1'b0}} :
                (x >=  THREE) ? x :
                mid[DW-1:0];

endmodule
