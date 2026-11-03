//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Han-Carlson parallel prefix adder (structural).
//
// A first level pairs each odd bit with the even bit below it, a
// Kogge-Stone network then runs on the odd bits only, and a last level
// combines each even bit with the odd bit below it. log2(DW)+1 prefix
// levels, (DW/2)*log2(DW) prefix nodes, fanout 2.
// DW must be a power of two (8, 16, 32, 64, 128 are benchmarked).
//
//#############################################################################
module addhancarlson #(parameter DW = 16
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

   localparam NL = $clog2(DW);	// Kogge-Stone levels
   localparam NT = NL + 1;	// total prefix levels

   // group generate/propagate: level t, bit i at [t*DW+i]
   wire [DW*(NT+1)-1:0] gg;
   wire [DW*(NT+1)-1:0] pp;
   wire [DW-1:0]        p;

   genvar               t, i;

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

   // Level 1: odd bit i combines with bit i-1.
   // Level t = 2..NL: odd bit i > 2^(t-1) combines with bit i-2^(t-1).
   // Level NL+1: even bit i >= 2 combines with bit i-1.
   generate
      for (t = 1; t <= NT; t = t + 1) begin : g_level
	 for (i = 0; i < DW; i = i + 1) begin : g_bit
	    if (((t == 1) && ((i % 2) == 1)) ||
		((t > 1) && (t <= NL) && ((i % 2) == 1) &&
		 (i > (1 << (t - 1)))) ||
		((t == NT) && ((i % 2) == 0) && (i >= 2))
		) begin : g_node
	       assign gg[t*DW+i] = gg[(t-1)*DW+i] |
				   (pp[(t-1)*DW+i] &
				    gg[(t-1)*DW+i-
				       (((t == 1) || (t == NT)) ?
					1 : (1 << (t - 1)))]);
	       assign pp[t*DW+i] = pp[(t-1)*DW+i] &
				   pp[(t-1)*DW+i-
				      (((t == 1) || (t == NT)) ?
				       1 : (1 << (t - 1)))];
	    end
	    else begin : g_wire
	       assign gg[t*DW+i] = gg[(t-1)*DW+i];
	       assign pp[t*DW+i] = pp[(t-1)*DW+i];
	    end
	 end
      end
   endgenerate

   //#######################################
   // Sum
   //#######################################

   assign sum[0]       = p[0] ^ cin;
   assign sum[DW-1:1]  = p[DW-1:1] ^ gg[NT*DW+:DW-1];
   assign cout	       = gg[NT*DW+DW-1];

endmodule
