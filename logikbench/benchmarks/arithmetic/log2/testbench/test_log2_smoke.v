//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for log2 (integer log2 (highest set bit), self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_log2_smoke;
   localparam DW=8, OW=$clog2(DW)+1;
   reg	      clk=0; reg [DW-1:0] a; wire [OW-1:0] out;
   always #5 clk=~clk;
   log2 #(.DW(DW)) dut (.a(a),.out(out));
   integer t,i,errors; reg [OW-1:0] exp;
   task chk; input [DW-1:0] av; begin
      @(posedge clk); a<=av;
      @(posedge clk); #1;
      exp=0; for(i=0;i<DW;i=i+1) if(av[i]) exp=i[OW-1:0];
      if(out!==exp) begin errors=errors+1;
         $display("FAIL a=%h: got %0d exp %0d",av,out,exp); end
   end endtask
   initial begin errors=0; a=0;
      chk(8'h01); chk(8'h80); chk(8'h0a); chk(8'hff); chk(8'h05);
      for(t=0;t<30;t=t+1) chk($random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_log2_smoke.vcd");
      $dumpvars(0, test_log2_smoke);
   end
`endif

endmodule
