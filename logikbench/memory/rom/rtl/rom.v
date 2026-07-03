//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################

module rom #(parameter DW = 16,
             parameter AW = 8
             )
   (
    input               clk,  // clock
    input               en,   // memory enable
    input [AW-1:0]      addr, // addr
    output reg [DW-1:0] dout  // data output
    );

   reg [DW-1:0] mem [(2**AW)-1:0];

   // ROM initialization. Non-trivial content (a squares table) so the memory
   // is not optimized away to a pass-through and infers a real ROM/BRAM.
   integer      i;
   initial
     begin
        for (i = 0; i < 2**AW; i = i + 1)
          mem[i] = i * i;
     end

   always @(posedge clk)
      if (en)
        dout <= mem[addr];

endmodule
