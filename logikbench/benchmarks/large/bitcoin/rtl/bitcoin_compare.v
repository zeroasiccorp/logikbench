//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * bitcoin_compare: proof-of-work target check.
 *
 * Bitcoin interprets the SHA256d output as a little-endian 256-bit integer and
 * accepts the block when that value is <= the difficulty target. The SHA-256
 * core emits the digest most-significant word first, so the bytes are reversed
 * before the unsigned comparison.
 ******************************************************************************/
module bitcoin_compare
  (
   input  wire [255:0] hash,     // raw SHA256d digest (big-endian words)
   input  wire [255:0] target,   // difficulty target
   output wire         below     // 1 when hash (little-endian) <= target
   );

   wire [255:0] le;              // byte-reversed hash (little-endian value)
   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin: rev
         assign le[i*8 +: 8] = hash[(31 - i)*8 +: 8];
      end
   endgenerate

   assign below = (le <= target);

endmodule
