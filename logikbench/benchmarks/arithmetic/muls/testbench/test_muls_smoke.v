//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muls (signed multiplier, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_muls_smoke;
   localparam DW=8, OW=16;
   reg	      clk=0; reg [DW-1:0] a,b; wire [OW-1:0] c;
   always #5 clk=~clk;
   muls #(.DW(DW),.OW(OW)) dut (.a(a),.b(b),.c(c));
   integer t,errors; reg signed [DW-1:0] sa,sb; reg signed [OW-1:0] exp;
   task chk; input [DW-1:0] av,bv; begin
      @(posedge clk); a<=av; b<=bv;
      @(posedge clk); #1;
      sa=av; sb=bv; exp=sa*sb;
      if(c!==exp) begin errors=errors+1;
         $display("FAIL a=%h b=%h: got %h exp %h",av,bv,c,exp); end
   end endtask
   initial begin errors=0; a=0; b=0;
      chk(8'hff,8'hff); chk(8'h80,8'h02); chk(8'h7f,8'h7f); chk(8'hff,8'h01);
      for(t=0;t<30;t=t+1) chk($random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_muls_smoke.vcd");
      $dumpvars(0, test_muls_smoke);
   end
`endif

endmodule
