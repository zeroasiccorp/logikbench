//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for gearbox66 (self-checking). Drives random 64-bit payloads
// (respecting tx_ready), records them in a FIFO scoreboard, and checks the
// loopback-recovered payloads/headers in order across the scramble + gearbox +
// gearbox + descramble round trip. Verifies no header errors.
//
//#############################################################################
`timescale 1ns/1ps
module test_gearbox66_smoke;
   localparam NP = 400;
   reg		 clk=0, nreset;
   reg		 tx_valid;
   reg [63:0]	 tx_data;
   reg		 tx_ctrl;
   wire		 tx_ready;
   wire [63:0]	 rx_data;
   wire		 rx_ctrl, rx_valid, rx_herr;

   reg [63:0]	 expd [0:NP+15];
   reg		 expc [0:NP+15];
   integer	 qh, qt, sent, errors;
   reg [31:0]	 r0, r1;

   always #5 clk=~clk;

   gearbox66 dut (.clk(clk), .nreset(nreset),
		  .tx_valid(tx_valid), .tx_data(tx_data), .tx_ctrl(tx_ctrl),
		  .tx_ready(tx_ready),
		  .rx_data(rx_data), .rx_ctrl(rx_ctrl), .rx_valid(rx_valid),
		  .rx_herr(rx_herr));

   // producer: hold payload until accepted, then record and generate next
   always @(posedge clk or negedge nreset)
     if (!nreset) begin
	r0=$random; r1=$random;
	tx_data <= {r1, r0}; tx_ctrl <= r0[0]; tx_valid <= 1'b1;
	sent <= 0; qt <= 0;
     end
     else if (tx_valid & tx_ready) begin
	expd[qt] <= tx_data; expc[qt] <= tx_ctrl; qt <= qt + 1;
	if (sent == NP+7) tx_valid <= 1'b0;   // extra flush payloads
	sent <= sent + 1;
	r0=$random; r1=$random;
	tx_data <= {r1, r0}; tx_ctrl <= r0[0];
     end

   // consumer: check recovered payloads in order
   always @(posedge clk) begin
      #1;
      if (nreset & rx_valid) begin
	 if (rx_herr !== 1'b0) begin
	    errors=errors+1; if (errors<=8) $display("FAIL: header err");
	 end
	 if (qh >= qt) begin
	    errors=errors+1; if (errors<=8) $display("FAIL: extra rx");
	 end
	 else begin
	    if ((rx_data !== expd[qh]) || (rx_ctrl !== expc[qh])) begin
	       errors=errors+1;
	       if (errors<=8)
		 $display("FAIL: got %h/%b exp %h/%b", rx_data, rx_ctrl,
			  expd[qh], expc[qh]);
	    end
	    qh <= qh + 1;
	 end
      end
   end

   initial begin
      errors=0; qh=0; nreset=0;
      @(posedge clk); @(posedge clk); #2 nreset=1;
      wait (sent == NP+8);
      repeat (200) @(posedge clk);   // drain
      #2;
      if ((errors==0) && (qh>=NP))
	$display("PASSED (%0d payloads)", qh);
      else
	$display("FAILED (%0d errors, %0d/%0d recovered)", errors, qh, NP);
      $finish;
   end
endmodule
