//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for cmp (magnitude comparator, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_cmp_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] a,b; wire aeqb,agtb,altb;
   always #5 clk=~clk;
   cmp #(.DW(DW)) dut (.a(a),.b(b),.aeqb(aeqb),.agtb(agtb),.altb(altb));
   integer t,errors;
   task chk; input [DW-1:0] av,bv; begin
      @(posedge clk); a<=av; b<=bv;
      @(posedge clk); #1;
      if (aeqb!==(av==bv) || agtb!==(av>bv) || altb!==(av<bv)) begin
         errors=errors+1;
         $display("FAIL a=%h b=%h: eq=%b gt=%b lt=%b",av,bv,aeqb,agtb,altb); end
   end endtask
   initial begin errors=0; a=0; b=0;
      chk(8'h05,8'h05); chk(8'h10,8'h03); chk(8'h03,8'h10);
      for (t=0;t<30;t=t+1) chk($random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
