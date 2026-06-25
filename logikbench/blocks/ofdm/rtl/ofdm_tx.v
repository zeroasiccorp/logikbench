//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// OFDM transmitter: bits -> QAM map -> IFFT (reuses fft) -> cyclic prefix,
// streaming out N+CP time-domain complex samples (CP first). One symbol per
// in_valid. mod: 0=QPSK, 1=16-QAM, 2=64-QAM. See ofdm.v / README for details.
//
//#############################################################################

module ofdm_tx
  #(parameter DW = 16,
    parameter N = 64,
    parameter CP = 16)
   (
    input		       clk,
    input		       rst,
    input		       in_valid,
    input [1:0]		       mod,
    input [6*N-1:0]	       in_bits,
    output reg		       out_valid, // time-sample stream valid
    output reg		       out_last,  // last sample of the symbol
    output reg signed [DW-1:0] out_r,
    output reg signed [DW-1:0] out_i
    );

   localparam LOG2N = 6;
   localparam LAT   = 70;                       // fft latency (N=64), measured
   localparam signed [DW-1:0] AMP = 16'sd2048;  // base PAM level
   localparam		      S_IDLE = 0, S_TX = 1, S_CP = 2, S_STREAM = 3;
   localparam		      SCW = $clog2(N+CP);

   function [LOG2N-1:0] bitrev;
      input [LOG2N-1:0] x;
      integer		b;
      begin
         for (b = 0; b < LOG2N; b = b + 1) bitrev[b] = x[LOG2N-1-b];
      end
   endfunction

   function signed [DW-1:0] pam_map;
      input [2:0] g3;
      input [1:0] modsel;
      integer	  B, idx;
      reg [2:0]	  g, bin;
      begin
         B = modsel + 1;
         g = g3 & ((1<<B)-1);
         bin[2] = g[2];
         bin[1] = g[1] ^ bin[2];
         bin[0] = g[0] ^ bin[1];
         idx = bin & ((1<<B)-1);
         pam_map = (2*idx - ((1<<B)-1)) * AMP;
      end
   endfunction

   reg signed [DW-1:0]  fr [0:N-1];
   reg signed [DW-1:0]	fi [0:N-1];
   reg signed [DW-1:0]	tr [0:N-1];
   reg signed [DW-1:0]	ti [0:N-1];
   reg signed [DW-1:0]	sym [0:N+CP-1];
   reg signed [DW-1:0]	symi [0:N+CP-1];
   reg [2:0]		state;
   reg [9:0]		cnt;
   integer		i;

   wire			fft_rst;
   reg			txiv;
   reg signed [DW-1:0]	txir, txii;
   wire			txov;
   wire signed [DW-1:0]	txor, txoi;
   wire [LOG2N-1:0]	m;

   assign fft_rst = rst | (state == S_IDLE);
   assign m = cnt - LAT;

   fft #(.DW(DW), .N(N)) u_ifft
     (.clk      (clk),
      .rst      (fft_rst),
      .in_valid (txiv),
      .in_real  (txir),
      .in_imag  (txii),
      .out_valid(txov),
      .out_real (txor),
      .out_imag (txoi));

   always @(posedge clk) begin
      if (rst) begin
         state     <= S_IDLE;
         cnt       <= 0;
         out_valid <= 1'b0;
         out_last  <= 1'b0;
         txiv      <= 1'b0;
      end
      else begin
         out_valid <= 1'b0;
         out_last  <= 1'b0;
         case (state)
           S_IDLE: begin
              txiv <= 1'b0;
              cnt  <= 0;
              if (in_valid) begin
                 for (i = 0; i < N; i = i + 1) begin
                    fr[i] <= pam_map(in_bits[i*6   +: 3], mod);
                    fi[i] <= pam_map(in_bits[i*6+3 +: 3], mod);
                 end
                 state <= S_TX;
              end
           end
           S_TX: begin
              txiv <= 1'b1;
              txir <= (cnt < N) ? fr[cnt[LOG2N-1:0]]  : 16'sd0;
              txii <= (cnt < N) ? -fi[cnt[LOG2N-1:0]] : 16'sd0;
              if (cnt >= LAT) begin
                 tr[bitrev(m)] <=  txor;
                 ti[bitrev(m)] <= -txoi;
              end
              if (cnt == LAT + N - 1) begin
                 txiv  <= 1'b0;
                 state <= S_CP;
              end
              else cnt <= cnt + 1'b1;
           end
           S_CP: begin
              for (i = 0; i < CP; i = i + 1) begin
                 sym[i]  <= tr[N-CP+i];
                 symi[i] <= ti[N-CP+i];
              end
              for (i = 0; i < N; i = i + 1) begin
                 sym[CP+i]  <= tr[i];
                 symi[CP+i] <= ti[i];
              end
              cnt   <= 0;
              state <= S_STREAM;
           end
           S_STREAM: begin
              out_valid <= 1'b1;
              out_r     <= sym[cnt[SCW-1:0]];
              out_i     <= symi[cnt[SCW-1:0]];
              out_last  <= (cnt == N + CP - 1);
              if (cnt == N + CP - 1) begin
                 cnt   <= 0;
                 state <= S_IDLE;
              end
              else cnt <= cnt + 1'b1;
           end
         endcase
      end
   end

endmodule
