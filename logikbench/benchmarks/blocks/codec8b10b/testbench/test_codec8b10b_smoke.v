//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for codec8b10b (self-checking). The encoder output is looped
// back to the decoder; the decoded byte/k are checked against the input
// (delayed by the 2-cycle enc+dec latency). Independently, the encoded stream
// is checked for the 8b/10b invariants: 4-6 ones per symbol, running disparity
// bounded to +/-1, and run length <= 5. Drives all 256 data symbols (in both
// disparity states) plus K.28.5 commas and random traffic.
//
//#############################################################################
`timescale 1ns/1ps
module test_codec8b10b_smoke;
   localparam N = 1040;
   reg		 clk=0, nreset;
   reg		 enc_k;
   reg [7:0]	 enc_din;
   wire [9:0]	 enc_dout;
   wire [7:0]	 dec_dout;
   wire		 dec_k, dec_err;

   reg [7:0]	 sd [0:N-1];
   reg		 sk [0:N-1];
   reg [7:0]	 ed1, ed2;
   reg		 ek1, ek2;
   integer	 idx, cyc, errors, i, ones, runlen, rdm, bit_i;
   reg		 curb, lastb;
   reg [31:0]	 rnd;

   always #5 clk=~clk;

   // encoder output looped back into the decoder input
   codec8b10b dut (.clk(clk), .nreset(nreset),
		   .enc_k(enc_k), .enc_din(enc_din), .enc_dout(enc_dout),
		   .dec_din(enc_dout), .dec_dout(dec_dout),
		   .dec_k(dec_k), .dec_err(dec_err));

   // stimulus driver + input delay line (2 cycles, matching enc+dec latency)
   always @(posedge clk or negedge nreset)
     if (!nreset) begin
	idx <= 0; enc_din <= 8'b0; enc_k <= 1'b0;
	ed1 <= 0; ed2 <= 0; ek1 <= 0; ek2 <= 0;
     end
     else begin
	enc_din <= sd[idx];
	enc_k	<= sk[idx];
	if (idx < N-1) idx <= idx + 1;
	ed1 <= enc_din; ed2 <= ed1;
	ek1 <= enc_k;   ek2 <= ek1;
     end

   // checker: round-trip + encoded-stream invariants
   always @(posedge clk) begin
      #1;
      if (nreset) begin
	 cyc = cyc + 1;
	 // round-trip: dec output corresponds to enc_din from 2 cycles ago
	 if (cyc > 4) begin
	    if (dec_err !== 1'b0) begin
	       errors=errors+1;
	       if (errors<=8) $display("FAIL: dec_err at cyc %0d", cyc);
	    end
	    if (ek2) begin
	       if ((dec_k !== 1'b1) || (dec_dout !== 8'hBC)) begin
		  errors=errors+1;
		  if (errors<=8) $display("FAIL comma: k=%b d=%h", dec_k, dec_dout);
	       end
	    end
	    else if ((dec_k !== 1'b0) || (dec_dout !== ed2)) begin
	       errors=errors+1;
	       if (errors<=8)
		 $display("FAIL data: got %h k=%b exp %h", dec_dout, dec_k, ed2);
	    end
	 end
	 // encoded-stream invariants (enc_dout valid after 1 cycle)
	 if (cyc > 1) begin
	    ones = enc_dout[9]+enc_dout[8]+enc_dout[7]+enc_dout[6]+enc_dout[5]
		 + enc_dout[4]+enc_dout[3]+enc_dout[2]+enc_dout[1]+enc_dout[0];
	    if ((ones < 4) || (ones > 6)) begin
	       errors=errors+1;
	       if (errors<=8) $display("FAIL ones=%0d code=%b", ones, enc_dout);
	    end
	    // running disparity must stay within +/-1
	    if ((rdm==0) && (ones==4)) begin
	       errors=errors+1;
	       if (errors<=8) $display("FAIL RD underflow code=%b", enc_dout);
	    end
	    if ((rdm==1) && (ones==6)) begin
	       errors=errors+1;
	       if (errors<=8) $display("FAIL RD overflow code=%b", enc_dout);
	    end
	    if (ones==6) rdm=1; else if (ones==4) rdm=0;
	    // run length <= 5 across the serial stream (a..j, then next a..)
	    for (bit_i=9; bit_i>=0; bit_i=bit_i-1) begin
	       curb = enc_dout[bit_i];
	       if (curb===lastb) runlen=runlen+1; else runlen=1;
	       lastb=curb;
	       if (runlen>5) begin
		  errors=errors+1;
		  if (errors<=8) $display("FAIL runlen>5 code=%b", enc_dout);
	       end
	    end
	 end
      end
   end

   initial begin
      errors=0; cyc=0; rdm=0; runlen=0; lastb=1'bx;
      // 0..255 data, then a comma, then 0..255 again (exercises both RD),
      // a comma, then random data/comma
      for (i=0;i<256;i=i+1) begin sd[i]=i; sk[i]=0; end
      sd[256]=8'hBC; sk[256]=1;
      for (i=0;i<256;i=i+1) begin sd[257+i]=i; sk[257+i]=0; end
      sd[513]=8'hBC; sk[513]=1;
      for (i=514;i<N;i=i+1) begin
	 rnd=$random; sd[i]=rnd[7:0];
	 rnd=$random; sk[i]=(rnd[3:0]==4'h0); // ~6% commas
      end
      nreset=0;
      @(posedge clk); @(posedge clk); #2 nreset=1;
      // run until stimulus consumed + drained
      repeat (N+16) @(posedge clk);
      #2;
      if (errors==0) $display("PASSED (%0d cycles checked)", cyc);
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
