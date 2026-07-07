//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module requant #(parameter IW = 32, // accumulator (input) width
                 parameter MW = 16, // scale (fixed-point multiplier) width
                 parameter SHW = 6, // shift-amount width
                 parameter OW = 8   // output width (saturated)
                 )
   (
    //Inputs
    input signed [IW-1:0]  acc,	  // wide accumulator, e.g. int32
    input signed [MW-1:0]  scale, // fixed-point multiplier
    input [SHW-1:0]	   shift, // arithmetic right-shift amount
    //Outputs
    output signed [OW-1:0] out	  // rounded, saturated result (e.g. int8)
    );

   // Requantize a wide accumulator down to a narrow output:
   //   out = saturate( round( (acc * scale) >> shift ) )
   // Rounding is round-half-away-from-zero (the TFLite/gemmlowp convention)
   // on the discarded low bits.

   localparam PW  = IW + MW;                      // full product width
   localparam [PW-1:0] ONE = 1;                   // 1 in product width
   localparam signed [PW-1:0] OMAX = (1 <<< (OW-1)) - 1;   // +max, e.g. +127
   localparam signed [PW-1:0] OMIN = -(1 <<< (OW-1));     // -min, e.g. -128

   wire signed [PW-1:0]	      prod;
   wire [PW-1:0]	      mask;
   wire [PW-1:0]	      half;
   wire [PW-1:0]	      frac;
   wire signed [PW-1:0]	      trunc;
   wire			      gt, eq, roundup;
   wire signed [PW-1:0]	      rounded;

   assign prod  = acc * scale;

   // discarded low 'shift' bits and the halfway value 2^(shift-1)
   assign mask  = (ONE <<< shift) - 1;
   assign half  = (ONE <<< (shift - 1));
   assign frac  = prod & mask;          // non-negative remainder mod 2^shift
   assign trunc = prod >>> shift;       // floor toward -inf (arithmetic)

   // round to nearest; on an exact tie round away from zero (positive
   // products round up, negative products keep the toward-minus-inf floor)
   assign gt      = (frac > half);
   assign eq      = (frac == half);
   assign roundup = (shift != 0) & (gt | (eq & ~prod[PW-1]));
   assign rounded = trunc + roundup;

   // symmetric saturation into the OW-bit signed output
   assign out = (rounded > OMAX) ? OMAX[OW-1:0] :
                (rounded < OMIN) ? OMIN[OW-1:0] :
                rounded[OW-1:0];

endmodule
