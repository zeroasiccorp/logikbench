//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for sine (sine ROM lookup, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_sine_smoke;
   localparam DW=8;
`include "sine_table256.vh"
   reg clk=0, nreset; reg [DW-1:0] a; wire [DW-1:0] out;
   always #5 clk=~clk;
   sine #(.DW(DW)) dut (.clk(clk),.nreset(nreset),.a(a),.out(out));
   integer k,errors; reg [DW-1:0] exp;
   initial begin
      errors=0; nreset=1; a=0;
      @(posedge clk); #1;
      if (out!==0) begin errors=errors+1; $display("FAIL reset: out=%h",out); end
      nreset<=0;
      for (k=0;k<256;k=k+1) begin
         a<=k[DW-1:0];
         @(posedge clk); #1;
         exp = SINETABLE_256[k*DW +: DW];
         if (out!==exp) begin errors=errors+1;
            if (errors<6) $display("FAIL a=%0d: got %h exp %h",k,out,exp); end
      end
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish;
   end
endmodule
