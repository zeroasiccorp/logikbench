//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for tff (toggle flip-flop, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_tff_smoke;
   localparam DW=8;
   reg		 clk=0, nreset, t_en;
   wire [DW-1:0] q;
   reg [DW-1:0]	 refq;
   reg		 started;
   integer	 i, errors;

   always #5 clk=~clk;

   tff #(.DW(DW)) dut (.clk(clk), .nreset(nreset), .t(t_en), .q(q));

   always @(posedge clk or negedge nreset)
     if (!nreset)	refq <= {DW{1'b0}};
     else if (t_en)	refq <= ~refq;

   always @(posedge clk) begin
      #1;
      if (started && q !== refq) begin
	 errors = errors + 1;
	 $display("FAIL i=%0d: q=%h ref=%h", i, q, refq);
      end
   end

   initial begin
      errors=0; started=0; nreset=0; t_en=0;
      @(posedge clk); #2 started=1; nreset<=1;
      for (i=0; i<40; i=i+1) begin
	 t_en <= $random;
	 @(posedge clk);
      end
      #2;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_tff_smoke.vcd");
      $dumpvars(0, test_tff_smoke);
   end
`endif

endmodule
