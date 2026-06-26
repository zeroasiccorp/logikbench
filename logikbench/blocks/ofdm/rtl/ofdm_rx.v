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

   reg signed [DW-1:0]	      rr [0:N-1];   // received time samples (CP removed)
   reg signed [DW-1:0]	      ri [0:N-1];
   reg signed [DW-1:0]	      xr [0:N-1];   // recovered freq bins
   reg signed [DW-1:0]	      xi [0:N-1];
   reg [1:0]		      mod_r;
   reg [2:0]		      state;
   reg [9:0]		      cnt;
   integer		      i;

   wire			      fft_rst;
   reg			      rxiv;
   reg signed [DW-1:0]	      rxir, rxii;
   wire			      rxov;
   wire signed [DW-1:0]	      rxor, rxoi;
   wire [LOG2N-1:0]	      m;

   // Per-axis QAM demap (replaces the pam_demap function): one combinational
   // unit per subcarrier built with generate. The rescaled level is offset and
   // shifted to a level index, clamped to [0,lim], then binary-to-gray encoded
   // and masked to B=mod_r+1 bits (lim = 1,3,7 for QPSK/16-QAM/64-QAM).
   wire [2:0]		      dlim = (4'd1 << (mod_r + 2'd1)) - 4'd1;  // 1,3,7
   wire [3:0]		      d2b  = (4'd1 << (mod_r + 2'd1));          // 2,4,8
   wire signed [DW+1:0]	      doff = $signed({2'b0, d2b}) * AMP;   // (1<<B)*AMP
   wire [2:0]		      dem_r [0:N-1];
   wire [2:0]		      dem_i [0:N-1];
   // bit-reversed fft output index (replaces the bitrev function)
   wire [LOG2N-1:0]	      m_rev;

   assign fft_rst = rst | (state == S_IDLE) | (state == S_COLLECT);
   assign m = cnt - LAT;

   genvar gp, gb;
   generate
      for (gb = 0; gb < LOG2N; gb = gb + 1) begin : g_brev
	 assign m_rev[gb] = m[LOG2N-1-gb];
      end
      for (gp = 0; gp < N; gp = gp + 1) begin : g_dem
	 // real axis: rescale, offset, shift to index, clamp, binary->gray
	 wire signed [DW-1:0]  lr   = xr[gp] <<< LOG2N;
	 wire signed [DW+1:0]  sr   = lr + doff;
	 wire signed [DW+1:0]  shr  = sr >>> 12;
	 wire [2:0]	       idr  = (shr < 0) ? 3'd0 :
			       (shr > $signed({1'b0, dlim})) ? dlim :
			       shr[2:0];
	 assign dem_r[gp][2] = idr[2]            & dlim[2];
	 assign dem_r[gp][1] = (idr[1] ^ idr[2]) & dlim[1];
	 assign dem_r[gp][0] = (idr[0] ^ idr[1]) & dlim[0];
	 // imag axis
	 wire signed [DW-1:0]  li   = xi[gp] <<< LOG2N;
	 wire signed [DW+1:0]  si   = li + doff;
	 wire signed [DW+1:0]  shi  = si >>> 12;
	 wire [2:0]	       idi  = (shi < 0) ? 3'd0 :
			       (shi > $signed({1'b0, dlim})) ? dlim :
			       shi[2:0];
	 assign dem_i[gp][2] = idi[2]            & dlim[2];
	 assign dem_i[gp][1] = (idi[1] ^ idi[2]) & dlim[1];
	 assign dem_i[gp][0] = (idi[0] ^ idi[1]) & dlim[0];
      end
   endgenerate

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
                 xr[m_rev] <= rxor;
                 xi[m_rev] <= rxoi;
              end
              if (cnt == LAT + N - 1) begin
                 rxiv  <= 1'b0;
                 state <= S_OUT;
              end
              else cnt <= cnt + 1'b1;
           end
           S_OUT: begin
              for (i = 0; i < N; i = i + 1) begin
                 out_bits[i*6   +: 3] <= dem_r[i];
                 out_bits[i*6+3 +: 3] <= dem_i[i];
              end
              out_valid <= 1'b1;
              state     <= S_IDLE;
           end
         endcase
      end
   end

endmodule
