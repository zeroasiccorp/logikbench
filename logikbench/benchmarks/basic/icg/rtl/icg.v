//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module icg #(parameter DW = 64
             )
   (
    input		clk,
    input		en, // clock enable
    input [DW-1:0]	d,
    output reg [DW-1:0]	q
    );

   wire eclk;

   // lambdalub clock gate
   la_clkicgand u_icg (.clk  (clk),
                       .te   (1'b0),
                       .en   (en),
                       .eclk (eclk));


   // flop
   always @ (posedge eclk)
     q <= d;

endmodule
