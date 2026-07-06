//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Single-port writable RAM preloaded with initial contents. The initial block
// loads a non-trivial squares table so the array infers an INITIALIZED RAM
// (writable, unlike a ROM) rather than being optimized away. Synchronous
// read-first read/write.

module raminit #(parameter DW = 16,
                 parameter AW = 10
                 )
   (
    input		clk,  // clock
    input		en,   // memory enable
    input		we,   // write enable
    input [AW-1:0]	addr, // addr
    input [DW-1:0]	din,  // data input
    output reg [DW-1:0]	dout  // data output
    );

   reg [DW-1:0] mem [(2**AW)-1:0];

   // Preload with a squares table (non-trivial so it is not optimized away).
   integer	i;
   initial
     begin
        for (i = 0; i < 2**AW; i = i + 1)
          mem[i] = i * i;
     end

   always @(posedge clk) begin
      if (en) begin
         if (we)
           mem[addr] <= din;
         dout <= mem[addr];
      end
   end
endmodule
