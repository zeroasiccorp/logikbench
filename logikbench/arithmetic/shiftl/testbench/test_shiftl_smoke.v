//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for shiftl (logical left shift, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_shiftl_smoke;
   localparam DW=8, SW=$clog2(DW);
   reg	      clk=0; reg [DW-1:0] a; reg [SW-1:0] b; wire [DW-1:0] out;
   always #5 clk=~clk;
   shiftl #(.DW(DW)) dut (.a(a),.b(b),.out(out));
   integer t,errors; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av; input [SW-1:0] bv; begin
      @(posedge clk); a<=av; b<=bv;
      @(posedge clk); #1;
      exp = (av << bv);
      if(out!==exp) begin errors=errors+1;
         $display("FAIL a=%h b=%0d: got %h exp %h",av,bv,out,exp); end
   end endtask
   initial begin errors=0; a=0; b=0;
      chk(8'h01,3'd7); chk(8'hff,3'd1); chk(8'h81,3'd4);
      for(t=0;t<30;t=t+1) chk($random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
