//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for jesd204b (self-checking). The transmit lanes are looped
// back to the receive lanes with a per-lane skew (0,1,2,3 cycles) to exercise
// deskew. It drives random samples (respecting tx_ready), waits for the link to
// bring up (CGS -> sync), and scoreboards the recovered samples in order across
// the full frame + scramble + 8b/10b + align + deskew + descramble + deframe
// round trip.
//
//#############################################################################
`timescale 1ns/1ps
module test_jesd204b_smoke;
   localparam L=4, M=2, N=16, SMPW=M*N, NP=300;
   reg		    clk=0, nreset;
   reg [SMPW-1:0]   tx_samples;
   reg		    tx_valid;
   wire		    tx_ready;
   wire [L*10-1:0]  tx_lanes;
   reg [L*10-1:0]   rx_lanes;
   wire [SMPW-1:0]  rx_samples;
   wire		    rx_valid, synced, rx_err;

   reg [SMPW-1:0]   expq [0:NP+63];
   integer	    qh, qt, sent, errors;
   reg [31:0]	    r0, r1;
   reg [9:0]	    l1a, l2a, l2b, l3a, l3b, l3c;

   always #5 clk=~clk;

   jesd204b #(.L(L), .M(M), .N(N)) dut
     (.clk(clk), .nreset(nreset),
      .tx_samples(tx_samples), .tx_valid(tx_valid), .tx_ready(tx_ready),
      .tx_lanes(tx_lanes), .rx_lanes(rx_lanes),
      .rx_samples(rx_samples), .rx_valid(rx_valid), .synced(synced),
      .rx_err(rx_err));

   // loopback with per-lane skew: lane l delayed by l cycles
   always @(posedge clk or negedge nreset)
     if (!nreset) begin
	l1a<=0; l2a<=0; l2b<=0; l3a<=0; l3b<=0; l3c<=0;
     end
     else begin
	l1a <= tx_lanes[19:10];
	l2a <= tx_lanes[29:20]; l2b <= l2a;
	l3a <= tx_lanes[39:30]; l3b <= l3a; l3c <= l3b;
     end
   always @(*) rx_lanes = {l3c, l2b, l1a, tx_lanes[9:0]};

   // producer: hold sample until accepted, then record and generate next
   always @(posedge clk or negedge nreset)
     if (!nreset) begin
	r0=$random; r1=$random;
	tx_samples <= {r1[15:0], r0[15:0]}; tx_valid <= 1'b1;
	sent <= 0; qt <= 0;
     end
     else if (tx_valid & tx_ready) begin
	expq[qt] <= tx_samples; qt <= qt + 1;
	if (sent == NP+31) tx_valid <= 1'b0;
	sent <= sent + 1;
	r0=$random; r1=$random;
	tx_samples <= {r1[15:0], r0[15:0]};
     end

   // consumer: check recovered samples in order
   always @(posedge clk) begin
      #1;
      if (nreset & rx_valid) begin
	 if (rx_err !== 1'b0) begin
	    errors=errors+1; if (errors<=8) $display("FAIL: rx_err");
	 end
	 if (qh >= qt) begin
	    errors=errors+1; if (errors<=8) $display("FAIL: extra rx");
	 end
	 else begin
	    if (rx_samples !== expq[qh]) begin
	       errors=errors+1;
	       if (errors<=8)
		 $display("FAIL: got %h exp %h", rx_samples, expq[qh]);
	    end
	    qh <= qh + 1;
	 end
      end
   end

   initial begin
      errors=0; qh=0; nreset=0;
      @(posedge clk); @(posedge clk); #2 nreset=1;
      wait (synced);
      $display("link synced");
      wait (sent == NP+32);
      repeat (300) @(posedge clk);   // drain
      #2;
      if ((errors==0) && (qh>=NP))
	$display("PASSED (%0d samples)", qh);
      else
	$display("FAILED (%0d errors, %0d/%0d recovered)", errors, qh, NP);
      $finish;
   end
endmodule
