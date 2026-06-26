//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// 4-byte multiplicative (Knuth/Fibonacci) hash for the LZ77 match finder.
// h = (data * 2654435761) mod 2^32, then take the top HASHBITS bits. The
// constant multiply folds to a fixed multiplier; no function, combinational.
//
//#############################################################################

module lz77_hash
  #(parameter HASHBITS = 14)
   (
    input [31:0]	  data,
    output [HASHBITS-1:0] hash
    );

   wire [31:0] prod = data * 32'd2654435761;   // mod 2^32 (low 32 bits)
   assign hash = prod[31 -: HASHBITS];

endmodule
