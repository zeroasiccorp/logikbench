//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Ripple-carry adder (structural).
//
// A chain of DW full adders: the carry into bit i+1 is
// g[i] | (p[i] & c[i]). DW carry stages in series. Reference point for
// the parallel prefix adders: a synthesized prefix adder that ends up
// as deep as this one has lost its prefix structure.
// DW must be a power of two (8, 16, 32, 64, 128 are benchmarked).
//
//#############################################################################
module addripple #(parameter DW = 16
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

   wire [DW-1:0]    p;	// bit propagate
   wire [DW-1:0]    g;	// bit generate
   wire [DW:0]      c;	// carry into bit i

   genvar           i;

   assign p[DW-1:0] = a[DW-1:0] ^ b[DW-1:0];
   assign g[DW-1:0] = a[DW-1:0] & b[DW-1:0];
   assign c[0]	    = cin;

   generate
      for (i = 0; i < DW; i = i + 1) begin : g_bit
	 assign c[i+1] = g[i] | (p[i] & c[i]);
      end
   endgenerate

   assign sum[DW-1:0] = p[DW-1:0] ^ c[DW-1:0];
   assign cout	      = c[DW];

endmodule
