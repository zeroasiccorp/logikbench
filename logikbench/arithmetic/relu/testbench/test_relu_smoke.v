//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for relu (signed ReLU, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_relu_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] in; wire [DW-1:0] out;
   always #5 clk=~clk;
   relu #(.DW(DW)) dut (.in(in),.out(out));
   integer t,errors; reg signed [DW-1:0] si,exp;
   task chk; input [DW-1:0] iv; begin
      @(posedge clk); in<=iv;
      @(posedge clk); #1;
      si=iv; exp = (si>0)? si : {DW{1'b0}};
      if(out!==exp) begin errors=errors+1;
         $display("FAIL in=%h: got %h exp %h",iv,out,exp); end
   end endtask
   initial begin errors=0; in=0;
      chk(8'h00); chk(8'h80); chk(8'hff); chk(8'h7f);
      for(t=0;t<30;t=t+1) chk($random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
