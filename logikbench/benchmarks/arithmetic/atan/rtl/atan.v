//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module atan #(parameter	DW = 16, // total width
              parameter	QW = 8,	 // fractional bits, Q(DW-QW).QW (QW=8 tuned)
              parameter	N = 12	 // CORDIC iterations
              )
   (
    //Inputs
    input signed [DW-1:0]  t,  // operand, Q(DW-QW).QW
    //Outputs
    output signed [DW-1:0] out // atan(t) in radians, (-pi/2, pi/2)
    );

   // CORDIC vectoring-mode arctangent. The vector (1, t) is rotated onto the
   // x-axis; the accumulated angle z converges to atan(t). Because z accumulates
   // the rotation angles, the result is independent of the CORDIC gain, so no
   // 1/K pre-scale is needed. Unrolled: one shift-add stage per iteration.
   localparam EW = DW + 2;                       // internal width (guard bits)
   localparam signed [EW-1:0] ONE = (1 <<< QW);  // 1.0 seed for x

   // atan(2^-i)*2^QW for i = 0..N-1, packed with i=0 in the low EW bits.
   localparam [N*EW-1:0]      ATAN = {
				      {EW{1'b0}}, {EW{1'b0}}, {EW{1'b0}},    // i=11,10,9
				      {{(EW-1){1'b0}}, 1'b1},                // i=8  : 1
				      {{(EW-2){1'b0}}, 2'd2},                // i=7  : 2
				      {{(EW-3){1'b0}}, 3'd4},                // i=6  : 4
				      {{(EW-4){1'b0}}, 4'd8},                // i=5  : 8
				      {{(EW-5){1'b0}}, 5'd16},               // i=4  : 16
				      {{(EW-6){1'b0}}, 6'd32},               // i=3  : 32
				      {{(EW-6){1'b0}}, 6'd63},               // i=2  : 63
				      {{(EW-7){1'b0}}, 7'd119},              // i=1  : 119
				      {{(EW-8){1'b0}}, 8'd201}               // i=0  : 201
				      };

   wire signed [EW-1:0]	      xw [0:N];
   wire signed [EW-1:0]	      yw [0:N];
   wire signed [EW-1:0]	      zw [0:N];
   genvar		      i;

   assign xw[0] = ONE;
   assign yw[0] = t;
   assign zw[0] = {EW{1'b0}};

   generate
      for (i = 0; i < N; i = i + 1) begin : g_vec
         wire                    negy = yw[i][EW-1];    // y < 0
         wire signed [EW-1:0]    xsh = xw[i] >>> i;
         wire signed [EW-1:0]	 ysh = yw[i] >>> i;
         wire signed [EW-1:0]	 atv = $signed(ATAN[i*EW +: EW]);
         assign xw[i+1] = negy ? (xw[i] - ysh) : (xw[i] + ysh);
         assign yw[i+1] = negy ? (yw[i] + xsh) : (yw[i] - xsh);
         assign zw[i+1] = negy ? (zw[i] - atv) : (zw[i] + atv);
      end
   endgenerate

   assign out = zw[N][DW-1:0];

endmodule
