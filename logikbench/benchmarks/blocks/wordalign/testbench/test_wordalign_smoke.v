//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for wordalign (self-checking). Feeds words carrying the comma
// at a fixed bit phase P; checks the block stays unlocked with no comma, then
// locks to offset P and presents the comma at the low bits of the aligned
// output word.
//
//#############################################################################
`timescale 1ns/1ps
module test_wordalign_smoke;
   localparam W=40, PW=10, P=7;
   localparam [PW-1:0] COMMA = 10'b0011111010;
   localparam OW = $clog2(W);

   reg		 clk=0, nreset;
   reg [W-1:0]	 din;
   wire [W-1:0]	 dout;
   wire		 locked;
   wire [OW-1:0] offset;
   integer	 t, errors;
   reg [W-1:0]	 cword;

   always #5 clk=~clk;

   wordalign #(.DW(W), .PW(PW), .COMMA(COMMA)) dut
     (.clk(clk), .nreset(nreset), .din(din),
      .dout(dout), .locked(locked), .offset(offset));

   initial begin
      errors=0; din={W{1'b0}}; nreset=0;
      cword = {W{1'b0}}; cword[P +: PW] = COMMA;
      @(posedge clk); @(posedge clk); #2 nreset=1;

      // no comma yet: must stay unlocked
      repeat (5) @(posedge clk);
      #1;
      if (locked !== 1'b0) begin
	 errors=errors+1; $display("FAIL: locked with no comma");
      end

      // feed comma-bearing words
      for (t=0;t<20;t=t+1) begin
	 @(posedge clk); din <= cword;
      end
      #1;
      if (locked !== 1'b1) begin
	 errors=errors+1; $display("FAIL: did not lock");
      end
      if (offset !== P[OW-1:0]) begin
	 errors=errors+1; $display("FAIL: offset=%0d exp %0d", offset, P);
      end

      // once locked, the comma must be aligned to the low bits every cycle
      for (t=0;t<10;t=t+1) begin
	 @(posedge clk); #1;
	 if (dout[PW-1:0] !== COMMA) begin
	    errors=errors+1;
	    if (errors<=8) $display("FAIL: dout low=%b exp %b", dout[PW-1:0], COMMA);
	 end
      end

      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_wordalign_smoke.vcd");
      $dumpvars(0, test_wordalign_smoke);
   end
`endif

endmodule
