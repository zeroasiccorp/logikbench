//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for mulreg (signed registered multiplier, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_mulreg_smoke;
   localparam DW=8, OW=16;
   reg	      clk=0; reg signed [DW-1:0] a,b; wire signed [OW-1:0] out;
   always #5 clk=~clk;
   mulreg #(.DW(DW),.OW(OW)) dut (.clk(clk),.a(a),.b(b),.out(out));
   // signed reference with identical 2-stage timing
   reg signed [DW-1:0] mar,mbr; reg signed [OW-1:0] mout;
   always @(posedge clk) begin mar<=a; mbr<=b; mout<=mar*mbr; end
   integer t,errors; reg cken;
   always @(posedge clk)
     if (cken && out!==mout) begin errors=errors+1;
        $display("FAIL: got %h exp %h",out,mout); end
   initial begin errors=0; cken=0; a=0; b=0;
      repeat(3) @(posedge clk); cken<=1;
      for(t=0;t<30;t=t+1) begin a<=$random; b<=$random; @(posedge clk); end
      @(posedge clk); @(posedge clk);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
