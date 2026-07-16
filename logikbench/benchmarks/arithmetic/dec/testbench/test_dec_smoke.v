//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for dec (decrement, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_dec_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] a; wire [DW-1:0] out;
   always #5 clk=~clk;
   dec #(.DW(DW)) dut (.a(a),.out(out));
   integer t,errors; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av; begin
      @(posedge clk); a<=av;
      @(posedge clk); #1;
      exp = av - 1;
      if (out !== exp) begin errors=errors+1;
         $display("FAIL a=%h: got %h exp %h",av,out,exp); end
   end endtask
   initial begin errors=0; a=0;
      chk(8'h00); chk(8'hff); chk(8'h7f);
      for (t=0;t<30;t=t+1) chk($random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_dec_smoke.vcd");
      $dumpvars(0, test_dec_smoke);
   end
`endif

endmodule
