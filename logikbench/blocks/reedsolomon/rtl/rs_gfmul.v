//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// GF(2^10) multiplier, field polynomial p(x) = x^10 + x^3 + 1 (0x409).
// Flat combinational XOR network (no generate, no functions): the carryless
// partial products pp[k] then the fixed reduction mod p(x). A constant operand
// folds to a constant multiplier.
//
//#############################################################################

module rs_gfmul
  (
   input [9:0]	a,
   input [9:0]	b,
   output [9:0]	product
   );

   wire [18:0] pp;

   assign pp[0] = (a[0]&b[0]);
   assign pp[1] = (a[0]&b[1]) ^ (a[1]&b[0]);
   assign pp[2] = (a[0]&b[2]) ^ (a[1]&b[1]) ^ (a[2]&b[0]);
   assign pp[3] = (a[0]&b[3]) ^ (a[1]&b[2]) ^ (a[2]&b[1]) ^ (a[3]&b[0]);
   assign pp[4] = (a[0]&b[4]) ^ (a[1]&b[3]) ^ (a[2]&b[2]) ^ (a[3]&b[1]) ^ (a[4]&b[0]);
   assign pp[5] = (a[0]&b[5]) ^ (a[1]&b[4]) ^ (a[2]&b[3]) ^ (a[3]&b[2]) ^ (a[4]&b[1]) ^ (a[5]&b[0]);
   assign pp[6] = (a[0]&b[6]) ^ (a[1]&b[5]) ^ (a[2]&b[4]) ^ (a[3]&b[3]) ^ (a[4]&b[2]) ^ (a[5]&b[1]) ^ (a[6]&b[0]);
   assign pp[7] = (a[0]&b[7]) ^ (a[1]&b[6]) ^ (a[2]&b[5]) ^ (a[3]&b[4]) ^ (a[4]&b[3]) ^ (a[5]&b[2]) ^ (a[6]&b[1]) ^ (a[7]&b[0]);
   assign pp[8] = (a[0]&b[8]) ^ (a[1]&b[7]) ^ (a[2]&b[6]) ^ (a[3]&b[5]) ^ (a[4]&b[4]) ^ (a[5]&b[3]) ^ (a[6]&b[2]) ^ (a[7]&b[1]) ^ (a[8]&b[0]);
   assign pp[9] = (a[0]&b[9]) ^ (a[1]&b[8]) ^ (a[2]&b[7]) ^ (a[3]&b[6]) ^ (a[4]&b[5]) ^ (a[5]&b[4]) ^ (a[6]&b[3]) ^ (a[7]&b[2]) ^ (a[8]&b[1]) ^ (a[9]&b[0]);
   assign pp[10] = (a[1]&b[9]) ^ (a[2]&b[8]) ^ (a[3]&b[7]) ^ (a[4]&b[6]) ^ (a[5]&b[5]) ^ (a[6]&b[4]) ^ (a[7]&b[3]) ^ (a[8]&b[2]) ^ (a[9]&b[1]);
   assign pp[11] = (a[2]&b[9]) ^ (a[3]&b[8]) ^ (a[4]&b[7]) ^ (a[5]&b[6]) ^ (a[6]&b[5]) ^ (a[7]&b[4]) ^ (a[8]&b[3]) ^ (a[9]&b[2]);
   assign pp[12] = (a[3]&b[9]) ^ (a[4]&b[8]) ^ (a[5]&b[7]) ^ (a[6]&b[6]) ^ (a[7]&b[5]) ^ (a[8]&b[4]) ^ (a[9]&b[3]);
   assign pp[13] = (a[4]&b[9]) ^ (a[5]&b[8]) ^ (a[6]&b[7]) ^ (a[7]&b[6]) ^ (a[8]&b[5]) ^ (a[9]&b[4]);
   assign pp[14] = (a[5]&b[9]) ^ (a[6]&b[8]) ^ (a[7]&b[7]) ^ (a[8]&b[6]) ^ (a[9]&b[5]);
   assign pp[15] = (a[6]&b[9]) ^ (a[7]&b[8]) ^ (a[8]&b[7]) ^ (a[9]&b[6]);
   assign pp[16] = (a[7]&b[9]) ^ (a[8]&b[8]) ^ (a[9]&b[7]);
   assign pp[17] = (a[8]&b[9]) ^ (a[9]&b[8]);
   assign pp[18] = (a[9]&b[9]);

   assign product[0] = pp[0] ^ pp[10] ^ pp[17];
   assign product[1] = pp[1] ^ pp[11] ^ pp[18];
   assign product[2] = pp[2] ^ pp[12];
   assign product[3] = pp[3] ^ pp[10] ^ pp[13] ^ pp[17];
   assign product[4] = pp[4] ^ pp[11] ^ pp[14] ^ pp[18];
   assign product[5] = pp[5] ^ pp[12] ^ pp[15];
   assign product[6] = pp[6] ^ pp[13] ^ pp[16];
   assign product[7] = pp[7] ^ pp[14] ^ pp[17];
   assign product[8] = pp[8] ^ pp[15] ^ pp[18];
   assign product[9] = pp[9] ^ pp[16];

endmodule
