//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Sklansky (divide-and-conquer) parallel prefix adder (structural).
//
// At level l, every bit in the upper half of each 2^l-bit block combines
// with the top bit of the lower half. log2(DW) prefix levels,
// (DW/2)*log2(DW) prefix nodes, fanout up to DW/2+1 at the last level.
// DW must be a power of two (8, 16, 32, 64, 128 are benchmarked).
//
//#############################################################################
module addsklansky #(parameter DW = 16
		     )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    input           cin,
    //Outputs
    output          cout,
    output [DW-1:0] sum
    );

   localparam NL = $clog2(DW); // prefix levels

   // group generate/propagate: level l, bit i at [l*DW+i]
   wire [DW*(NL+1)-1:0] gg;
   wire [DW*(NL+1)-1:0] pp;
   wire [DW-1:0]        p;

   genvar               l, i;

   //#######################################
   // Bit generate/propagate (level 0)
   //#######################################

   // cin is folded into bit 0, so G[i:0] is the carry into bit i+1
   assign p[DW-1:0]   = a[DW-1:0] ^ b[DW-1:0];
   assign gg[DW-1:1]  = a[DW-1:1] & b[DW-1:1];
   assign gg[0]	      = (a[0] & b[0]) | (p[0] & cin);
   assign pp[DW-1:1]  = p[DW-1:1];
   assign pp[0]	      = 1'b0;

   //#######################################
   // Prefix network
   //#######################################

   // node i at level l (upper half of its block) combines with
   // j = (i rounded down to a multiple of 2^(l-1)) - 1
   generate
      for (l = 1; l <= NL; l = l + 1) begin : g_level
	 for (i = 0; i < DW; i = i + 1) begin : g_bit
	    if (((i >> (l - 1)) & 1) == 1) begin : g_node
	       assign gg[l*DW+i] = gg[(l-1)*DW+i] |
				   (pp[(l-1)*DW+i] &
				    gg[(l-1)*DW+((i>>(l-1))<<(l-1))-1]);
	       assign pp[l*DW+i] = pp[(l-1)*DW+i] &
				   pp[(l-1)*DW+((i>>(l-1))<<(l-1))-1];
	    end
	    else begin : g_wire
	       assign gg[l*DW+i] = gg[(l-1)*DW+i];
	       assign pp[l*DW+i] = pp[(l-1)*DW+i];
	    end
	 end
      end
   endgenerate

   //#######################################
   // Sum
   //#######################################

   assign sum[0]       = p[0] ^ cin;
   assign sum[DW-1:1]  = p[DW-1:1] ^ gg[NL*DW+:DW-1];
   assign cout	       = gg[NL*DW+DW-1];

endmodule
