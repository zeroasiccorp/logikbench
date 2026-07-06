//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Single-port RAM, write-first (read-through) read-during-write. On a write
// (en & we) the new data 'din' also appears on 'dout' the same cycle; on a
// read (en & ~we) 'dout' returns mem[addr]. Behavioral so the tool infers the
// write-first BRAM read-during-write mode.

module ramspwf #(parameter DW = 16,
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

   always @(posedge clk) begin
      if (en) begin
         if (we) begin
            mem[addr] <= din;
            dout <= din;
         end
         else begin
            dout <= mem[addr];
         end
      end
   end
endmodule
