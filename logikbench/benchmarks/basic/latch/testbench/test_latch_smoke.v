//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for latch (transparent D latch, self-checking). Mirrors the
// latch behavior in a reference and checks transparency (en=1) and hold (en=0).
//
//#############################################################################
`timescale 1ns/1ps
module test_latch_smoke;
   localparam DW=8;
   reg		 clk=0, en;
   reg [DW-1:0]	 d;
   wire [DW-1:0] q;
   reg [DW-1:0]	 refq;
   integer	 t, errors;

   always #5 clk=~clk;

   latch #(.DW(DW)) dut (.en(en), .d(d), .q(q));

   always @(*) if (en) refq = d;   // reference latch

   always @(posedge clk) begin
      #1;
      if (q !== refq) begin
	 errors = errors + 1;
	 $display("FAIL t=%0d: q=%h ref=%h en=%b", t, q, refq, en);
      end
   end

   initial begin
      errors=0; en=1'b1; d=0; refq=0;
      @(posedge clk);
      for (t=0; t<40; t=t+1) begin
	 d  <= $random;
	 en <= $random;   // mix of transparent and hold
	 @(posedge clk);
      end
      #2;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
