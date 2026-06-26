//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for add (carry adder, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_add_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] a,b; reg cin; wire cout; wire [DW-1:0] sum;
   always #5 clk=~clk;
   add #(.DW(DW)) dut (.a(a),.b(b),.cin(cin),.cout(cout),.sum(sum));
   integer t,errors; reg [DW:0] exp;
   task chk; input [DW-1:0] av,bv; input cv; begin
      @(posedge clk); a<=av; b<=bv; cin<=cv;
      @(posedge clk); #1;
      exp = av + bv + cv;
      if ({cout,sum} !== exp) begin errors=errors+1;
         $display("FAIL a=%h b=%h cin=%b: got %h exp %h",av,bv,cv,{cout,sum},exp);
      end
   end endtask
   initial begin errors=0; a=0; b=0; cin=0;
      chk(8'h00,8'h00,1'b0); chk(8'hff,8'hff,1'b1); chk(8'hff,8'h01,1'b0);
      for (t=0;t<30;t=t+1) chk($random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
