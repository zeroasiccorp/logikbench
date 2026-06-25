//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// OFDM loopback modem (802.11a/g style).
//
// Full transmit + receive chain reusing the logikbench `fft` block as the
// transform engine, one OFDM symbol per transaction (frame-based):
//   TX: bits -> QAM map -> IFFT (via fft + conjugation) -> cyclic prefix
//   RX: CP removal -> FFT -> ( x N rescale ) -> QAM demap -> bits
// Loopback is internal (ideal channel), so decoded bits == input bits.
//
// Modulation (mod): 0 = QPSK (2 b/subcarrier), 1 = 16-QAM (4 b), 2 = 64-QAM
// (6 b). Gray-coded square QAM, levels +/-{1,3,5,7}*AMP per axis. Bits are
// carried in fixed 6-bit per-subcarrier slots (low 2*B used): in_bits[sc*6+:6]
// = {Qfield[2:0], Ifield[2:0]}, each field's low B bits significant.
//
// The fft block is streaming with fixed latency LAT, bit-reversed output, and
// 1/N scaling. IFFT uses ifft(X)=conj(fft(conj(X))) (the fft's 1/N is the IFFT
// scale); the RX FFT then carries an extra 1/N, undone by the <<LOG2N rescale
// before slicing. The fft instances are held in reset between symbols so each
// symbol starts from a clean pipeline.
//
//#############################################################################

module ofdm
  #(parameter DW = 16,
    parameter N = 64,
    parameter CP = 16
    )
   (
    input                clk,
    input                rst,
    input                in_valid,
    input [1:0]          mod, // 0=QPSK,1=16QAM,2=64QAM
    input [6*N-1:0]      in_bits,
    output reg           out_valid,
    output reg [6*N-1:0] out_bits
    );

   localparam LOG2N = 6;
   localparam LAT   = 70;                       // fft latency (N=64), measured
   localparam signed [DW-1:0] AMP = 16'sd2048;  // base PAM level

   function [LOG2N-1:0] bitrev;
      input [LOG2N-1:0] x; integer b;
      begin for (b=0;b<LOG2N;b=b+1) bitrev[b]=x[LOG2N-1-b]; end
   endfunction

   // Gray-coded PAM mapper: 3-bit field (low B used) -> signed level
   function signed [DW-1:0] pam_map;
      input [2:0]   g3;
      input [1:0]   modsel;
      integer	    B, idx;
      reg [2:0]	    g, bin;
      begin
         B   = modsel + 1;
         g   = g3 & ((1<<B)-1);
         bin[2] = g[2];
         bin[1] = g[1] ^ bin[2];
         bin[0] = g[0] ^ bin[1];
         idx = bin & ((1<<B)-1);
         pam_map = (2*idx - ((1<<B)-1)) * AMP;
      end
   endfunction

   // PAM slicer: signed level -> 3-bit Gray field (low B valid)
   function [2:0] pam_demap;
      input signed [DW-1:0] lvl;
      input [1:0]	    modsel;
      integer		    B, idx, lim;
      reg [2:0]		    bin, g;
      begin
         B   = modsel + 1;
         lim = (1<<B) - 1;
         // idx = round((lvl/A + (2^B-1))/2); 2*A = 2^(1+log2 AMP) = 2^12
         idx = (lvl + ((1<<B)*AMP)) >>> 12;
         if (idx < 0)   idx = 0;
         if (idx > lim) idx = lim;
         bin = idx[2:0];
         g[2] = bin[2];
         g[1] = bin[1] ^ bin[2];
         g[0] = bin[0] ^ bin[1];
         pam_demap = g & lim[2:0];
      end
   endfunction

   reg signed [DW-1:0] fr [0:N-1];
   reg signed [DW-1:0] fi [0:N-1];
   reg signed [DW-1:0] tr [0:N-1];
   reg signed [DW-1:0] ti [0:N-1];
   reg signed [DW-1:0] sym [0:N+CP-1];
   reg signed [DW-1:0] symi[0:N+CP-1];
   reg signed [DW-1:0] xr [0:N-1];
   reg signed [DW-1:0] xi [0:N-1];
   reg [1:0]	       mod_r;

   wire		       fft_rst;
   reg		       txiv, rxiv;
   reg signed [DW-1:0] txir, txii, rxir, rxii;
   wire		       txov, rxov;
   wire signed [DW-1:0]	txor, txoi, rxor, rxoi;

   fft #(.DW(DW), .N(N)) u_ifft
     (.clk(clk), .rst(fft_rst), .in_valid(txiv), .in_real(txir),
      .in_imag(txii), .out_valid(txov), .out_real(txor), .out_imag(txoi));
   fft #(.DW(DW), .N(N)) u_fft
     (.clk(clk), .rst(fft_rst), .in_valid(rxiv), .in_real(rxir),
      .in_imag(rxii), .out_valid(rxov), .out_real(rxor), .out_imag(rxoi));

   localparam S_IDLE=0, S_TX=1, S_CP=4, S_RX=2, S_OUT=3;
   reg [2:0]  state;
   assign fft_rst = rst | (state == S_IDLE);
   reg [9:0] cnt;
   integer   i;
   wire [LOG2N-1:0] m = cnt - LAT;

   always @(posedge clk) begin
      if (rst) begin
         state <= S_IDLE; cnt <= 0; out_valid <= 1'b0;
         txiv <= 1'b0; rxiv <= 1'b0;
      end
      else begin
         out_valid <= 1'b0;
         case (state)
           S_IDLE: begin
              txiv <= 1'b0; rxiv <= 1'b0; cnt <= 0;
              if (in_valid) begin
                 mod_r <= mod;
                 for (i = 0; i < N; i = i + 1) begin
                    fr[i] <= pam_map(in_bits[i*6   +: 3], mod);  // I
                    fi[i] <= pam_map(in_bits[i*6+3 +: 3], mod);  // Q
                 end
                 state <= S_TX;
              end
           end
           S_TX: begin
              txiv <= 1'b1;
              txir <= (cnt < N) ? fr[cnt[LOG2N-1:0]]  : 16'sd0;
              txii <= (cnt < N) ? -fi[cnt[LOG2N-1:0]] : 16'sd0;  // conj in
              if (cnt >= LAT) begin
                 tr[bitrev(m)] <=  txor;
                 ti[bitrev(m)] <= -txoi;                          // conj out
              end
              if (cnt == LAT + N - 1) begin txiv <= 1'b0; state <= S_CP; end
              else cnt <= cnt + 1'b1;
           end
           S_CP: begin
              for (i = 0; i < CP; i = i + 1) begin
                 sym[i] <= tr[N-CP+i];  symi[i] <= ti[N-CP+i];
              end
              for (i = 0; i < N; i = i + 1) begin
                 sym[CP+i] <= tr[i];    symi[CP+i] <= ti[i];
              end
              cnt <= 0; state <= S_RX;
           end
           S_RX: begin
              rxiv <= 1'b1;
              rxir <= (cnt < N) ? sym[CP+cnt]  : 16'sd0;          // CP removed
              rxii <= (cnt < N) ? symi[CP+cnt] : 16'sd0;
              if (cnt >= LAT) begin
                 xr[bitrev(m)] <= rxor;
                 xi[bitrev(m)] <= rxoi;
              end
              if (cnt == LAT + N - 1) begin rxiv <= 1'b0; state <= S_OUT; end
              else cnt <= cnt + 1'b1;
           end
           S_OUT: begin
              for (i = 0; i < N; i = i + 1) begin
                 // rescale by N (undo RX-FFT 1/N) then slice
                 out_bits[i*6   +: 3] <= pam_demap(xr[i] <<< LOG2N, mod_r);
                 out_bits[i*6+3 +: 3] <= pam_demap(xi[i] <<< LOG2N, mod_r);
              end
              out_valid <= 1'b1;
              state <= S_IDLE;
           end
         endcase
      end
   end

endmodule
