//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module macc #(parameter	DW = 16,
              parameter	OW = 40
              )
   (
    input		       clk,
    input		       clear,
    input		       en,
    input signed [DW-1:0]      a_re,
    input signed [DW-1:0]      a_im,
    input signed [DW-1:0]      b_re,
    input signed [DW-1:0]      b_im,
    output reg signed [OW-1:0] out_re,
    output reg signed [OW-1:0] out_im
    );

   // Complex multiply-accumulate

   wire signed [2*DW-1:0] prod_re;
   wire signed [2*DW-1:0] prod_im;

   assign prod_re = (a_re * b_re) - (a_im * b_im);
   assign prod_im = (a_re * b_im) + (a_im * b_re);

   always @(posedge clk) begin
      if (clear) begin
         out_re <= 0;
         out_im <= 0;
      end
      else if (en) begin
         out_re <= out_re + prod_re;
         out_im <= out_im + prod_im;
      end
   end

endmodule
