//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module latch #(parameter DW = 64
               )
   (
    input	    en,	// level-sensitive enable (transparent when high)
    input [DW-1:0]  d,
    output [DW-1:0] q
    );

   // instance of lambdalib vectorized latch
   la_vlatq #(.W(DW)) u_lat (.d  (d),
                             .clk (en),
                             .q  (q));

endmodule
