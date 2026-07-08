//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for linkmap (self-checking). The framer output (lane_out) is
// looped back into the deframer input (lane_in); the recovered samples must
// match the input, delayed by the 2-cycle framer+deframer latency. Also checks
// the framing actually permutes (lane_out != smp_in for a nontrivial input).
//
//#############################################################################
`timescale 1ns/1ps
module test_linkmap_smoke;
   localparam M=4, S=4, N=16, L=4, SMPW=M*S*N;
   reg		    clk=0, nreset;
   reg [SMPW-1:0]   smp_in;
   wire [SMPW-1:0]  lane_out;
   wire [SMPW-1:0]  smp_out;
   reg [SMPW-1:0]   d1, d2;
   integer	    t, errors, w;
   reg [31:0]	    r;

   always #5 clk=~clk;

   // framer output looped back into the deframer input
   linkmap #(.M(M), .S(S), .N(N), .L(L)) dut
     (.clk(clk), .nreset(nreset), .smp_in(smp_in),
      .lane_out(lane_out), .lane_in(lane_out), .smp_out(smp_out));

   // 2-cycle input delay to align with smp_out
   always @(posedge clk or negedge nreset)
     if (!nreset) begin d1<=0; d2<=0; end
     else begin d1<=smp_in; d2<=d1; end

   initial begin
      errors=0; smp_in=0; nreset=0;
      @(posedge clk); @(posedge clk); #2 nreset=1;
      for (t=0; t<300; t=t+1) begin
	 @(posedge clk);
	 for (w=0; w<SMPW; w=w+32) begin r=$random; smp_in[w +: 32] <= r; end
	 #1;
	 if (t > 3) begin
	    if (smp_out !== d2) begin
	       errors=errors+1;
	       if (errors<=8) $display("FAIL: smp_out=%h exp %h", smp_out, d2);
	    end
	    // framing must reorder bits (not identity) for nonzero input
	    if ((lane_out === d1) && (d1 !== {SMPW{1'b0}})) begin
	       errors=errors+1;
	       if (errors<=8) $display("FAIL: framer is identity");
	    end
	 end
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
