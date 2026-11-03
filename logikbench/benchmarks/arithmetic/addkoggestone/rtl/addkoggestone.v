//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Kogge-Stone parallel prefix adder (structural).
//
// Every bit combines with the bit 2^(l-1) below it at level l, giving
// log2(DW) prefix levels, fanout 2, and DW*log2(DW)-DW+1 prefix nodes.
// DW must be a power of two (8, 16, 32, 64, 128 are benchmarked).
//
//#############################################################################
module addkoggestone #(parameter DW = 16
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

   generate
      for (l = 1; l <= NL; l = l + 1) begin : g_level
	 for (i = 0; i < DW; i = i + 1) begin : g_bit
	    if (i >= (1 << (l - 1))) begin : g_node
	       assign gg[l*DW+i] = gg[(l-1)*DW+i] |
				   (pp[(l-1)*DW+i] &
				    gg[(l-1)*DW+i-(1<<(l-1))]);
	       assign pp[l*DW+i] = pp[(l-1)*DW+i] &
				   pp[(l-1)*DW+i-(1<<(l-1))];
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
