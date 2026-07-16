//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for absdiffs (signed absolute difference, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_absdiffs_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] a,b; wire [DW-1:0] out;
   always #5 clk=~clk;
   absdiffs #(.DW(DW)) dut (.a(a),.b(b),.out(out));
   integer t,errors,d; reg signed [DW-1:0] sa,sb; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av,bv; begin
      @(posedge clk); a<=av; b<=bv;
      @(posedge clk); #1;
      sa=av; sb=bv; d=sa-sb; if(d<0) d=-d; exp=d[DW-1:0];
      if(out!==exp) begin errors=errors+1;
         $display("FAIL a=%h b=%h: got %h exp %h",av,bv,out,exp); end
   end endtask
   initial begin errors=0; a=0; b=0;
      chk(8'h05,8'h03); chk(8'h03,8'h05); chk(8'h80,8'h7f); chk(8'hff,8'h01);
      for(t=0;t<30;t=t+1) chk($random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_absdiffs_smoke.vcd");
      $dumpvars(0, test_absdiffs_smoke);
   end
`endif

endmodule
