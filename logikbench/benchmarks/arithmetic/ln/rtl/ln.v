//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module ln #(parameter DW = 16, // total width
            parameter QW = 8   // fractional bits, Q(DW-QW).QW (QW=8 tuned)
            )
   (
    //Inputs
    input signed [DW-1:0]  x,  // operand, must be > 0
    //Outputs
    output signed [DW-1:0] out // ln(x)  (0 for x <= 0)
    );

   // ln(x) = log2(x) * ln2. log2(x) is split into an integer part and a
   // mantissa: find the leading one at position p, so x = 2^(p-QW) * m with
   // m in [1,2); then log2(x) = (p-QW) + log2(m). log2(m) is a cubic polynomial
   // in u = m-1. Finally multiply by ln2. Normalize + polynomial is the
   // standard hardware/math-library method for log. Constants are Q8.8.
   localparam signed [DW:0] A1  = 369;  // 1/ln2   (log2(1+u) poly coeffs)
   localparam signed [DW:0] A2  = -166;
   localparam signed [DW:0] A3  = 52;
   localparam signed [DW:0] LN2 = 177;  // ln2 in Q8.8

   wire [DW-1:0]	    ux;   // magnitude (valid for x > 0)
   reg [$clog2(DW):0]	    p;   // leading-one position
   integer		    i;
   wire signed [DW:0]	    e;    // exponent = p - QW
   wire [DW-1:0]	    mant; // mantissa in [2^QW, 2^(QW+1))
   wire [QW-1:0]	    u;    // mantissa fraction (m - 1)
   wire signed [QW:0]	    us;
   wire signed [DW+3:0]	    q2, q1, q0, lg;       // log2(m) polynomial
   wire signed [2*DW-1:0]   l2;   // log2(x) in Q8.8
   wire signed [2*DW-1:0]   lnv;  // ln(x)   in Q8.8

   assign ux = x;

   // leading-one detector (highest set bit), same pattern as the log2 block
   always @(*) begin
      p = 0;
      for (i = 0; i < DW; i = i + 1)
        if (ux[i])
          p = i[$clog2(DW):0];
   end

   assign e     = $signed({1'b0, p}) - QW;
   assign mant  = (p >= QW) ? (ux >> (p - QW)) : (ux << (QW - p));
   assign u     = mant[QW-1:0];
   assign us    = {1'b0, u};

   // log2(1+u) by Horner: lg = u*(A1 + u*(A2 + u*A3))  (Q8.8, in [0,1))
   assign q2 = A3;
   assign q1 = ((q2 * us) >>> QW) + A2;
   assign q0 = ((q1 * us) >>> QW) + A1;
   assign lg = (q0 * us) >>> QW;

   assign l2  = (e <<< QW) + lg;        // log2(x)
   assign lnv = (l2 * LN2) >>> QW;      // ln(x) = log2(x) * ln2

   assign out = (x <= 0) ? {DW{1'b0}} : lnv[DW-1:0];

endmodule
