//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Content-addressable memory (CAM): binary exact-match associative store.
// A write port loads entry 'waddr' with key 'wdata' and valid bit 'wvalid'.
// The search port compares 'sdata' against every valid entry in parallel (one
// generated comparator per entry) and returns 'match' (any hit) plus
// 'match_addr' (lowest matching index). Outputs are registered. Maps to
// flip-flops + comparators + a priority encoder, not a dense RAM.

module cam #(parameter DW = 32,	// key width
             parameter AW = 5	// address width; DEPTH = 2**AW entries
             )
   (
    input		clk,
    // write port (load an entry)
    input		we,	   // write enable
    input [AW-1:0]	waddr,	   // entry to write
    input [DW-1:0]	wdata,	   // key to store
    input		wvalid,	   // valid bit to store
    // search port
    input [DW-1:0]	sdata,	   // key to search for
    output reg		match,	   // 1 if any valid entry matches (registered)
    output reg [AW-1:0]	match_addr // lowest matching index (registered)
    );

   localparam DEPTH = (1 << AW);

   reg [DW-1:0]	key [0:DEPTH-1];
   reg [DEPTH-1:0] valid;
   wire [DEPTH-1:0] match_vec;
   integer	    j;
   reg [AW-1:0]	    enc;
   genvar	    i;

   // write port
   always @(posedge clk)
     if (we) begin
        key[waddr]   <= wdata;
        valid[waddr] <= wvalid;
     end

   // per-entry comparators: one combinational unit per entry (generate)
   generate
      for (i = 0; i < DEPTH; i = i + 1) begin : g_cmp
         assign match_vec[i] = valid[i] & (key[i] == sdata);
      end
   endgenerate

   // priority-encode the match vector (lowest index wins) -- reduction
   always @* begin
      enc = {AW{1'b0}};
      for (j = DEPTH - 1; j >= 0; j = j - 1)
        if (match_vec[j])
          enc = j[AW-1:0];
   end

   // registered outputs
   always @(posedge clk) begin
      match      <= |match_vec;
      match_addr <= enc;
   end
endmodule
