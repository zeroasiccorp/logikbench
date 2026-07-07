//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for icg (gated-clock register, self-checking). The gated
// clock makes the register behave like a clock-enabled flop; the reference is
// an enabled flop.
//
//#############################################################################
`timescale 1ns/1ps
module test_icg_smoke;
   localparam DW=8;
   reg		 clk=0, en;
   reg [DW-1:0]	 d;
   wire [DW-1:0] q;
   reg [DW-1:0]	 refq;
   reg		 started;
   integer	 i, errors;

   always #5 clk=~clk;

   icg #(.DW(DW)) dut (.clk(clk), .en(en), .d(d), .q(q));

   // reference: enabled flop (gated clock == clock enable functionally)
   always @(posedge clk)
     if (en)
       refq <= d;

   always @(posedge clk) begin
      #1;
      if (started && q !== refq) begin
	 errors = errors + 1;
	 $display("FAIL i=%0d: q=%h ref=%h en=%b", i, q, refq, en);
      end
   end

   initial begin
      errors=0; started=0; en=0; d=0; refq=0;
      // prime both to a known value
      en=1; d=0; @(posedge clk); #2 started=1;
      for (i=0; i<40; i=i+1) begin
	 d  <= $random;
	 en <= $random;
	 @(posedge clk);
      end
      #2;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
