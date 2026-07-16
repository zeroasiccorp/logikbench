//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muladd (unsigned multiply-add, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_muladd_smoke;
   localparam DW=8, OW=16;
   reg	      clk=0; reg [DW-1:0] a,b; reg [OW-1:0] c; wire [OW-1:0] out;
   always #5 clk=~clk;
   muladd #(.DW(DW),.OW(OW)) dut (.a(a),.b(b),.c(c),.out(out));
   integer t,errors; reg [OW-1:0] exp;
   task chk; input [DW-1:0] av,bv; input [OW-1:0] cv; begin
      @(posedge clk); a<=av; b<=bv; c<=cv;
      @(posedge clk); #1;
      exp = av*bv + cv;
      if (out !== exp) begin errors=errors+1;
         $display("FAIL a=%h b=%h c=%h: got %h exp %h",av,bv,cv,out,exp); end
   end endtask
   initial begin errors=0; a=0; b=0; c=0;
      chk(8'h10,8'h10,16'h0001); chk(8'hff,8'hff,16'hffff);
      for (t=0;t<30;t=t+1) chk($random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_muladd_smoke.vcd");
      $dumpvars(0, test_muladd_smoke);
   end
`endif

endmodule
