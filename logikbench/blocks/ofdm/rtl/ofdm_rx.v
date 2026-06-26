//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// OFDM receiver: streamed time samples (CP first) -> CP removal -> FFT
// (reuses fft) -> 1/N rescale -> QAM demap -> bits. Consumes N+CP samples per
// symbol (in_valid/in_last); mod selects the constellation. See ofdm.v.
//
//#############################################################################

module ofdm_rx
  #(parameter DW = 16,
    parameter N = 64,
    parameter CP = 16)
   (
    input		  clk,
    input		  rst,
    input		  in_valid, // time-sample stream valid
    input		  in_last,  // last sample of the symbol
    input signed [DW-1:0] in_r,
    input signed [DW-1:0] in_i,
    input [1:0]		  mod,
    output reg		  out_valid,
    output reg [6*N-1:0]  out_bits
    );

   localparam LOG2N = 6;
   localparam LAT   = 70;                       // fft latency (N=64), measured
   localparam signed [DW-1:0] AMP = 16'sd2048;  // base PAM level
   localparam		      S_IDLE = 0, S_COLLECT = 1, S_RX = 2, S_OUT = 3;
   localparam		      SCW = $clog2(N+CP);

   function [LOG2N-1:0] bitrev;
      input [LOG2N-1:0] x;
      integer		b;
      begin
         for (b = 0; b < LOG2N; b = b + 1) bitrev[b] = x[LOG2N-1-b];
      end
   endfunction

   function [2:0] pam_demap;
      input signed [DW-1:0] lvl;
      input [1:0]	    modsel;
      integer		    B, idx, lim;
      reg [2:0]		    bin, g;
      begin
         B   = modsel + 1;
         lim = (1<<B) - 1;
         idx = (lvl + ((1<<B)*AMP)) >>> 12;
         if (idx < 0)   idx = 0;
         if (idx > lim) idx = lim;
         bin  = idx[2:0];
         g[2] = bin[2];
         g[1] = bin[1] ^ bin[2];
         g[0] = bin[0] ^ bin[1];
         pam_demap = g & lim[2:0];
      end
   endfunction

   reg signed [DW-1:0]  rr [0:N-1];   // received time samples (CP removed)
   reg signed [DW-1:0]	ri [0:N-1];
   reg signed [DW-1:0]	xr [0:N-1];   // recovered freq bins
   reg signed [DW-1:0]	xi [0:N-1];
   reg [1:0]		mod_r;
   reg [2:0]		state;
   reg [9:0]		cnt;
   integer		i;

   wire			fft_rst;
   reg			rxiv;
   reg signed [DW-1:0]	rxir, rxii;
   wire			rxov;
   wire signed [DW-1:0]	rxor, rxoi;
   wire [LOG2N-1:0]	m;

   assign fft_rst = rst | (state == S_IDLE) | (state == S_COLLECT);
   assign m = cnt - LAT;

   fft #(.DW(DW), .N(N)) u_fft
     (.clk      (clk),
      .rst      (fft_rst),
      .in_valid (rxiv),
      .in_real  (rxir),
      .in_imag  (rxii),
      .out_valid(rxov),
      .out_real (rxor),
      .out_imag (rxoi));

   always @(posedge clk) begin
      if (rst) begin
         state     <= S_IDLE;
         cnt       <= 0;
         out_valid <= 1'b0;
         rxiv      <= 1'b0;
      end
      else begin
         out_valid <= 1'b0;
         case (state)
           S_IDLE: begin
              rxiv <= 1'b0;
              cnt  <= 0;
              if (in_valid) begin
                 mod_r <= mod;
                 state <= S_COLLECT;
                 // first sample is CP[0]; just consume (dropped)
                 cnt   <= 1;
              end
           end
           S_COLLECT: begin
              if (in_valid) begin
                 if (cnt >= CP) begin
                    rr[cnt-CP] <= in_r;
                    ri[cnt-CP] <= in_i;
                 end
                 if (in_last) begin
                    cnt   <= 0;
                    state <= S_RX;
                 end
                 else cnt <= cnt + 1'b1;
              end
           end
           S_RX: begin
              rxiv <= 1'b1;
              rxir <= (cnt < N) ? rr[cnt[LOG2N-1:0]] : 16'sd0;
              rxii <= (cnt < N) ? ri[cnt[LOG2N-1:0]] : 16'sd0;
              if (cnt >= LAT) begin
                 xr[bitrev(m)] <= rxor;
                 xi[bitrev(m)] <= rxoi;
              end
              if (cnt == LAT + N - 1) begin
                 rxiv  <= 1'b0;
                 state <= S_OUT;
              end
              else cnt <= cnt + 1'b1;
           end
           S_OUT: begin
              for (i = 0; i < N; i = i + 1) begin
                 out_bits[i*6   +: 3] <= pam_demap(xr[i] <<< LOG2N, mod_r);
                 out_bits[i*6+3 +: 3] <= pam_demap(xi[i] <<< LOG2N, mod_r);
              end
              out_valid <= 1'b1;
              state     <= S_IDLE;
           end
         endcase
      end
   end

endmodule
