//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// fmadd16: bfloat16 (bf16) fused multiply-add. It reuses the fmadd32 datapath
// wrapper, overriding its parameters to the bf16 field layout (1 sign, 8
// exponent, 7 mantissa bits). See the fmadd32 block for the shared arithmetic.
//
//#############################################################################
module fmadd16
  (
   input [15:0]	 a, // multiplicand (bf16)
   input [15:0]	 b, // multiplier
   input [15:0]	 c, // addend
   output [15:0] r  // round(a*b + c), fused
   );

   fmadd32 #(.EXP(8), .MANT(7)) u_fmadd32 (.a(a), .b(b), .c(c), .r(r));

endmodule
