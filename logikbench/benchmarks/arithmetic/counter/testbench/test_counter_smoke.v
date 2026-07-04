//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for counter (up counter, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_counter_smoke;
   localparam DW=8;
   reg	      clk=0, clear, en; wire [DW-1:0] count;
   always #5 clk=~clk;
   counter #(.DW(DW)) dut (.clk(clk),.clear(clear),.en(en),.count(count));
   reg [DW-1:0] mc; integer t,errors; reg cken;
   always @(posedge clk) begin
      if (clear) mc<=0; else if (en) mc<=mc+1;
   end
   always @(posedge clk)
     if (cken && count!==mc) begin errors=errors+1;
        $display("FAIL: count=%h exp %h",count,mc); end
   initial begin errors=0; cken=0; clear=1; en=0;
      @(posedge clk); clear<=0; mc=0; cken<=1;
      for(t=0;t<60;t=t+1) begin en<=$random; clear<=($random%8==0); @(posedge clk); end
      @(posedge clk);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
