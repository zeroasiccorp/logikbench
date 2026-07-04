//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for round (round half to even, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_round_smoke;
   localparam DW=8, FW=4;
   reg	      clk=0; reg [DW-1:0] a; wire [DW-1:0] out;
   always #5 clk=~clk;
   round #(.DW(DW),.FW(FW)) dut (.a(a),.out(out));
   integer t,errors,fl,fr,half,ru; reg signed [DW-1:0] sa; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av; begin
      @(posedge clk); a<=av;
      @(posedge clk); #1;
      sa=av; fl = sa >>> FW; fr = sa - (fl <<< FW); half = 1 <<< (FW-1);
      ru = (fr>half)?1:(fr<half)?0:(fl&1);
      exp = (fl+ru);
      if(out!==exp) begin errors=errors+1;
         $display("FAIL a=%h: got %h exp %h",av,out,exp); end
   end endtask
   initial begin errors=0; a=0;
      chk(8'h08); chk(8'h18); chk(8'hf8); chk(8'h00);
      for(t=0;t<30;t=t+1) chk($random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
