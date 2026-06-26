//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for addsub (adder/subtractor, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_addsub_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] a,b; reg sel; wire [DW-1:0] z;
   always #5 clk=~clk;
   addsub #(.DW(DW)) dut (.a(a),.b(b),.sel(sel),.z(z));
   integer t,errors; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av,bv; input sv; begin
      @(posedge clk); a<=av; b<=bv; sel<=sv;
      @(posedge clk); #1;
      exp = sv ? (av+bv) : (av-bv);
      if (z !== exp) begin errors=errors+1;
         $display("FAIL a=%h b=%h sel=%b: got %h exp %h",av,bv,sv,z,exp); end
   end endtask
   initial begin errors=0; a=0; b=0; sel=0;
      chk(8'h10,8'h03,1'b1); chk(8'h10,8'h03,1'b0); chk(8'h03,8'h10,1'b0);
      for (t=0;t<30;t=t+1) chk($random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
