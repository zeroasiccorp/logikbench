//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for absdiff (unsigned |a-b|, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_absdiff_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] a,b; wire [DW-1:0] out;
   always #5 clk=~clk;
   absdiff #(.DW(DW)) dut (.a(a),.b(b),.out(out));
   integer t,errors; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av,bv; begin
      @(posedge clk); a<=av; b<=bv;
      @(posedge clk); #1;
      exp = (av>bv)?(av-bv):(bv-av);
      if (out !== exp) begin errors=errors+1;
         $display("FAIL a=%h b=%h: got %h exp %h",av,bv,out,exp); end
   end endtask
   initial begin errors=0; a=0; b=0;
      chk(8'h10,8'h03); chk(8'h03,8'h10); chk(8'h05,8'h05);
      for (t=0;t<30;t=t+1) chk($random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_absdiff_smoke.vcd");
      $dumpvars(0, test_absdiff_smoke);
   end
`endif

endmodule
