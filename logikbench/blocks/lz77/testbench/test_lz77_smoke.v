//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: LZ77 (hash-based LZSS) codec smoke test (self-checking).
 *
 * Drives the lz77 top (lz77_enc -> token stream -> lz77_dec) and checks the
 * reconstructed bytes equal the input (lossless round trip).
 *
 * TESTED (defaults: WIN=32768, WW=64, NWAY=4, HASHBITS=14, MINMATCH=4):
 *   - rand32      : 32 random bytes (mostly literals).
 *   - periodic    : 64 bytes, period-7 pattern (distance-7 matches + runs).
 *   - alpha4      : 100 bytes, 2-bit alphabet (many overlapping matches).
 *   - periodic200 : 200 bytes, period-7 (longer match runs).
 *   - rand300     : 300 random bytes.
 *
 * NOT TESTED:
 *   - Compression ratio (correctness only; ratio is exercised separately).
 *   - Inputs longer than the 32 KB window (wrap-around eviction).
 *   - Non-default parameter sets.
 *   - out_ready backpressure stalls on the decoder output.
 ******************************************************************************/
`timescale 1ns/1ps
module test_lz77_smoke;
   localparam NMAX=512;
   reg clk=0, rst;
   reg in_valid; reg [7:0] in_byte; reg in_last; wire in_ready;
   wire out_valid; wire [7:0] out_byte;
   lz77 dut(.clk(clk),.rst(rst),.in_valid(in_valid),.in_byte(in_byte),
            .in_last(in_last),.in_ready(in_ready),
            .out_valid(out_valid),.out_byte(out_byte));
   always #5 clk=~clk;
   reg [7:0] data [0:NMAX-1];
   reg [7:0] rcv  [0:NMAX-1];
   integer   N, fi, rcnt, errors, test_num, w, k;
   reg       running; reg [31:0] lfsr;

   always @(posedge clk) begin
      if (rst) begin in_valid<=0; fi<=0; end
      else if (running && fi<N) begin
         if (!in_valid) begin in_valid<=1; in_byte<=data[fi]; in_last<=(fi==N-1); end
         else if (in_ready) begin
            if (fi==N-1) begin in_valid<=0; fi<=fi+1; end
            else begin fi<=fi+1; in_byte<=data[fi+1]; in_last<=(fi+1==N-1); end
         end
      end
      else if (running) in_valid<=0;
   end
   always @(posedge clk)
     if (!rst && out_valid && rcnt<NMAX) begin rcv[rcnt]<=out_byte; rcnt<=rcnt+1; end

   task run; input integer n; input integer mode; input [8*12-1:0] tag;
      begin
         test_num=test_num+1; N=n;
         for (k=0;k<n;k=k+1) begin
            lfsr={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
            case (mode)
              0: data[k] = lfsr[7:0];             // random (mostly literals)
              1: data[k] = data[k>=13?k-13:k] ^ 8'h00; // wait, fill below
              2: data[k] = {6'b0, lfsr[1:0]};     // tiny alphabet (many matches)
              default: data[k] = lfsr[7:0];
            endcase
         end
         // mode 1: periodic pattern (period 7) -> distance-7 matches + runs
         if (mode==1)
           for (k=0;k<n;k=k+1) data[k] = "A" + (k % 7);
         @(posedge clk); rst<=1; rcnt=0; fi=0; running=0;
         @(posedge clk); rst<=0; running<=1;
         w=0; while (rcnt<n && w<300000) begin @(posedge clk); w=w+1; end
         running<=0;
         if (rcnt<n) begin errors=errors+1; $display("FAIL [%0s] got %0d/%0d",tag,rcnt,n); end
         else begin
            k=0; for (k=0;k<n;k=k+1) if (rcv[k]!==data[k]) errors=errors+1;
            $display("PASS [%0s] %0d bytes",tag,n);
         end
      end
   endtask

   initial begin
      rst=1; in_valid=0; in_byte=0; in_last=0; running=0;
      errors=0; test_num=0; rcnt=0; fi=0; lfsr=32'hBEEF1234;
      @(posedge clk);
      run(32,0,"rand32"); run(64,1,"periodic"); run(100,2,"alpha4");
      run(200,1,"periodic200"); run(300,0,"rand300");
      $display("\n==== errors=%0d after %0d tests ====",errors,test_num);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #40000000; $display("FAILED (timeout)"); $finish; end
endmodule
