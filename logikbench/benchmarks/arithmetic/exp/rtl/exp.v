//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module exp #(parameter DW = 16,	// total width
             parameter QW = 8	// fractional bits, Q(DW-QW).QW (QW=8 tuned)
             )
   (
    //Inputs
    input signed [DW-1:0]  x,
    //Outputs
    output signed [DW-1:0] out // e^x, saturated to the output range
    );

   // exp(x) = 2^(x*log2e) = 2^k * 2^f, with k = floor(x*log2e) and f the
   // fractional part in [0,1). The integer part k is a shift; 2^f is a cubic
   // polynomial (Taylor of 2^f). Range reduction + polynomial is the standard
   // hardware/math-library method for exp. Result is saturated to the signed
   // output range (and flushes to 0 when it underflows). Constants are Q8.8.
   localparam signed [DW-1:0] MAXV = (1 <<< (DW-1)) - 1;   // +max
   localparam		      KHI  = DW - QW - 1;        // k >= KHI  -> saturate high (e.g. 7)
   localparam		      KLO  = -(QW + 1);          // k <= KLO  -> underflow to 0 (e.g. -9)
   localparam signed [DW:0]   LOG2E = 369; // log2(e)  in Q8.8
   localparam [DW:0]	      C1   = 177;  // ln2      (2^f Taylor coeffs)
   localparam [DW:0]	      C2   = 61;   // ln2^2/2
   localparam [DW:0]	      C3   = 14;   // ln2^3/6
   localparam [DW:0]	      ONEQ = (1 <<< QW);  // 1.0

   wire signed [2*DW-1:0]     m;     // x*log2e, Q8.8
   wire signed [DW-1:0]	      kk;    // integer part floor(x*log2e)
   wire [QW-1:0]	      frac; // fractional part
   wire [DW+3:0]	      p2, p1, p0, pv;   // 2^frac polynomial (positive)
   wire signed [2*DW:0]	      shifted;

   assign m     = (x * LOG2E) >>> QW;
   assign kk    = m >>> QW;
   assign frac  = m[QW-1:0];

   // 2^frac by Horner: pv = ((C3*f + C2)*f + C1)*f + 1  (Q8.8, in [1,2))
   assign p2 = C3;
   assign p1 = ((p2 * frac) >> QW) + C2;
   assign p0 = ((p1 * frac) >> QW) + C1;
   assign pv = ((p0 * frac) >> QW) + ONEQ;

   // 2^k scaling: left shift for k>=0, right shift for k<0
   assign shifted = (kk >= 0) ? ($signed({1'b0, pv}) <<< kk)
     : ($signed({1'b0, pv}) >>> (-kk));

   assign out = (kk >= KHI)      ? MAXV :
                (kk <= KLO)      ? {DW{1'b0}} :
                (shifted > MAXV) ? MAXV :
                shifted[DW-1:0];

endmodule
