//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module cos #(parameter DW = 16,	// total width
             parameter QW = 8,	// fractional bits, Q(DW-QW).QW (QW=8 tuned)
             parameter N = 12	// CORDIC iterations
             )
   (
    //Inputs
    input signed [DW-1:0]  z,  // angle in radians, [-pi/2, pi/2]
    //Outputs
    output signed [DW-1:0] out // cos(z)
    );

   // CORDIC rotation-mode cosine. One shift-add rotation stage per iteration,
   // unrolled with generate (no multiplier, no table lookup). x is pre-scaled
   // by 1/K so the CORDIC gain K cancels and x -> cos(z) (y -> sin(z), unused).
   // Convergence needs |z| <= ~1.7433 rad; the documented domain is
   // [-pi/2, pi/2]. Constants are Q8.8: INVK = 1/1.64676 and atan(2^-i).
   localparam EW = DW + 2;                       // internal width (guard bits)
   localparam signed [EW-1:0] INVK = 155;        // 0.60725 in Q8.8

   // atan(2^-i)*2^QW for i = 0..N-1, packed with i=0 in the low EW bits.
   // Values: 201,119,63,32,16,8,4,2,1,0,0,0 (below ~0.5 LSB they are 0).
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

   assign xw[0] = INVK;
   assign yw[0] = {EW{1'b0}};
   assign zw[0] = z;

   generate
      for (i = 0; i < N; i = i + 1) begin : g_rot
         wire                    dir = ~zw[i][EW-1];    // z >= 0
         wire signed [EW-1:0]    xsh = xw[i] >>> i;
         wire signed [EW-1:0]	 ysh = yw[i] >>> i;
         wire signed [EW-1:0]	 atv = $signed(ATAN[i*EW +: EW]);
         assign xw[i+1] = dir ? (xw[i] - ysh) : (xw[i] + ysh);
         assign yw[i+1] = dir ? (yw[i] + xsh) : (yw[i] - xsh);
         assign zw[i+1] = dir ? (zw[i] - atv) : (zw[i] + atv);
      end
   endgenerate

   assign out = xw[N][DW-1:0];

endmodule
