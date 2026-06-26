//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for mac (unsigned MAC, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_mac_smoke;
   localparam DW=8, OW=20;
   reg	      clk=0, clear, en; reg [DW-1:0] a,b; wire [OW-1:0] c;
   always #5 clk=~clk;
   mac #(.DW(DW),.OW(OW)) dut (.clk(clk),.clear(clear),.en(en),.a(a),.b(b),.c(c));
   reg [OW-1:0] mcc; integer t,errors; reg cken;
   always @(posedge clk) begin
      if (clear) mcc<=0; else if (en) mcc<=mcc + a*b;
   end
   always @(posedge clk)
     if (cken && c!==mcc) begin errors=errors+1;
        $display("FAIL: c=%h exp %h",c,mcc); end
   initial begin errors=0; cken=0; clear=1; en=0; a=0; b=0;
      @(posedge clk); clear<=0; mcc=0; cken<=1;
      for(t=0;t<60;t=t+1) begin
         a<=$random; b<=$random; en<=$random; clear<=($random%16==0);
         @(posedge clk);
      end
      @(posedge clk);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
