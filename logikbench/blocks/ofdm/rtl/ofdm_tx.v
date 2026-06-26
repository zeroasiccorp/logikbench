//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
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

   reg signed [DW-1:0]	      fr [0:N-1];
   reg signed [DW-1:0]	      fi [0:N-1];
   reg signed [DW-1:0]	      tr [0:N-1];
   reg signed [DW-1:0]	      ti [0:N-1];
   reg signed [DW-1:0]	      sym [0:N+CP-1];
   reg signed [DW-1:0]	      symi [0:N+CP-1];
   reg [2:0]		      state;
   reg [9:0]		      cnt;
   integer		      i;

   wire			      fft_rst;
   reg			      txiv;
   reg signed [DW-1:0]	      txir, txii;
   wire			      txov;
   wire signed [DW-1:0]	      txor, txoi;
   wire [LOG2N-1:0]	      m;

   // Per-axis PAM mapping (replaces the pam_map function): one combinational
   // unit per subcarrier built with generate. The gray-coded group is masked
   // by B=mod+1 bits (mask = 1,3,7 for QPSK/16-QAM/64-QAM), gray-decoded to a
   // level index, then mapped to the signed PAM level (2*idx - mask) * AMP.
   wire [2:0]		      pmask = (4'd1 << (mod + 2'd1)) - 4'd1;
   wire signed [DW-1:0]	      pam_r [0:N-1];
   wire signed [DW-1:0]	      pam_i [0:N-1];
   // bit-reversed fft output index (replaces the bitrev function)
   wire [LOG2N-1:0]	      m_rev;

   assign fft_rst = rst | (state == S_IDLE);
   assign m = cnt - LAT;

   genvar gp, gb;
   generate
      for (gb = 0; gb < LOG2N; gb = gb + 1) begin : g_brev
	 assign m_rev[gb] = m[LOG2N-1-gb];
      end
      for (gp = 0; gp < N; gp = gp + 1) begin : g_pam
	 // real axis: mask -> gray-to-binary -> index -> signed PAM level
	 wire [2:0]	   gr = in_bits[gp*6   +: 3] & pmask;
	 wire [2:0]	   br;
	 assign br[2] = gr[2];
	 assign br[1] = gr[1] ^ br[2];
	 assign br[0] = gr[0] ^ br[1];
	 wire [2:0]	   ir = br & pmask;
	 wire signed [5:0] lr = $signed({3'b0, ir}) * 6'sd2 - $signed({3'b0, pmask});
	 assign pam_r[gp] = lr * AMP;
	 // imag axis
	 wire [2:0]	   gi = in_bits[gp*6+3 +: 3] & pmask;
	 wire [2:0]	   bi;
	 assign bi[2] = gi[2];
	 assign bi[1] = gi[1] ^ bi[2];
	 assign bi[0] = gi[0] ^ bi[1];
	 wire [2:0]	   ii = bi & pmask;
	 wire signed [5:0] li = $signed({3'b0, ii}) * 6'sd2 - $signed({3'b0, pmask});
	 assign pam_i[gp] = li * AMP;
      end
   endgenerate

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
                    fr[i] <= pam_r[i];
                    fi[i] <= pam_i[i];
                 end
                 state <= S_TX;
              end
           end
           S_TX: begin
              txiv <= 1'b1;
              txir <= (cnt < N) ? fr[cnt[LOG2N-1:0]]  : 16'sd0;
              txii <= (cnt < N) ? -fi[cnt[LOG2N-1:0]] : 16'sd0;
              if (cnt >= LAT) begin
                 tr[m_rev] <=  txor;
                 ti[m_rev] <= -txoi;
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
