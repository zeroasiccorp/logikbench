//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Carry-select adder (structural).
//
// DW is split into DW/BS blocks of BS bits. The first block is a ripple
// adder on cin. Every other block computes two ripple sums, one for a
// carry in of 0 and one for 1, and a mux picks one with the carry out of
// the block below. The block carries form a chain of DW/BS-1 muxes.
// DW must be a power of two (8, 16, 32, 64, 128 are benchmarked) and BS
// must divide DW.
//
//#############################################################################
module addcarrysel #(parameter DW = 16,
		     parameter BS = 4 // block size
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

   localparam NB = DW / BS;	// number of blocks

   wire [DW-1:0] p;		// bit propagate
   wire [DW-1:0] g;		// bit generate
   wire [DW-1:0] s0;		// block sums for a carry in of 0
   wire [DW-1:0] s1;		// block sums for a carry in of 1
   wire [DW+NB-1:0] c0;		// ripple carries for a carry in of 0
   wire [DW+NB-1:0] c1;		// ripple carries for a carry in of 1
   wire [NB:0]      bc;		// selected carry into block k

   genvar           k, i;

   assign p[DW-1:0] = a[DW-1:0] ^ b[DW-1:0];
   assign g[DW-1:0] = a[DW-1:0] & b[DW-1:0];
   assign bc[0]	    = cin;

   // block k uses carries c0/c1[k*(BS+1) +: BS+1]
   generate
      for (k = 0; k < NB; k = k + 1) begin : g_block
	 if (k == 0) begin : g_first
	    // first block: a single ripple adder on cin
	    assign c0[0] = cin;
	    for (i = 0; i < BS; i = i + 1) begin : g_bit
	       assign c0[i+1] = g[i] | (p[i] & c0[i]);
	    end
	    assign sum[BS-1:0] = p[BS-1:0] ^ c0[BS-1:0];
	    assign bc[1]       = c0[BS];
	    assign c1[BS:0]    = {(BS+1){1'b0}};
	    assign s0[BS-1:0]  = {BS{1'b0}};
	    assign s1[BS-1:0]  = {BS{1'b0}};
	 end
	 else begin : g_select
	    assign c0[k*(BS+1)] = 1'b0;
	    assign c1[k*(BS+1)] = 1'b1;
	    for (i = 0; i < BS; i = i + 1) begin : g_bit
	       assign c0[k*(BS+1)+i+1] = g[k*BS+i] |
					 (p[k*BS+i] & c0[k*(BS+1)+i]);
	       assign c1[k*(BS+1)+i+1] = g[k*BS+i] |
					 (p[k*BS+i] & c1[k*(BS+1)+i]);
	       assign s0[k*BS+i] = p[k*BS+i] ^ c0[k*(BS+1)+i];
	       assign s1[k*BS+i] = p[k*BS+i] ^ c1[k*(BS+1)+i];
	    end
	    assign sum[k*BS+:BS] = bc[k] ? s1[k*BS+:BS] : s0[k*BS+:BS];
	    assign bc[k+1]	 = bc[k] ? c1[k*(BS+1)+BS] :
				   c0[k*(BS+1)+BS];
	 end
      end
   endgenerate

   assign cout = bc[NB];

endmodule
