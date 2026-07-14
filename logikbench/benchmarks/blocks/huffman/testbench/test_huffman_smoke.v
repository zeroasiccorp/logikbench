//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: huffman codec smoke test (self-checking, round-trip).
 *
 * Streams random 8-bit symbols through the full codec (huffman = huffman_enc +
 * huffman_dec, encoder byte stream wired to the decoder) and checks the
 * recovered symbols equal the input.
 *
 * TESTED:
 *   - End-to-end symbol recovery for frames of 8 / 64 / 200 symbols.
 *   - Variable-length canonical encode + bit-packer and the bit-serial
 *     canonical decode, including the valid/ready handshake and end-of-frame
 *     flush (final partial byte).
 *
 * NOT TESTED:
 *   - Only the baked-in static canonical table (one frequency model); no
 *     dynamic tree building or alternate tables.
 *   - Compression ratio / output-length checks (round-trip only).
 *   - Backpressure stress (decoder is always ready in this TB) or mid-frame
 *     reset.
 ******************************************************************************/
`timescale 1ns/1ps
module test_huffman_smoke;
   localparam NMAX=300;
   reg	      clk=0, rst;
   reg	      in_valid; reg [7:0] in_sym; reg in_last; wire in_ready;
   wire out_valid; wire [7:0] out_sym;
   huffman dut(.clk(clk),.rst(rst),.in_valid(in_valid),.in_sym(in_sym),
               .in_last(in_last),.in_ready(in_ready),
               .out_valid(out_valid),.out_sym(out_sym));
   always #5 clk=~clk;

   reg [7:0] data [0:NMAX-1];
   reg [7:0] rcv  [0:NMAX-1];
   integer   N, fi, rcnt, errors, test_num, w, k;
   reg	     running;
   reg [31:0] lfsr;

   // clocked valid/ready producer
   always @(posedge clk) begin
      if (rst) begin in_valid<=0; fi<=0; end
      else if (running) begin
         if (fi < N) begin
            if (!in_valid) begin
               in_valid<=1; in_sym<=data[fi]; in_last<=(fi==N-1);
            end
            else if (in_ready) begin
               if (fi==N-1) begin in_valid<=0; fi<=fi+1; end
               else begin fi<=fi+1; in_sym<=data[fi+1]; in_last<=(fi+1==N-1); end
            end
         end
         else in_valid<=0;
      end
   end
   // clocked collector
   always @(posedge clk)
     if (!rst && out_valid && rcnt < NMAX) begin rcv[rcnt]<=out_sym; rcnt<=rcnt+1; end

   task run; input integer n; input [8*10-1:0] tag;
      begin
         test_num=test_num+1;
         N=n;
         for (k=0;k<n;k=k+1) begin
            lfsr={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
            // skew toward low symbols (shorter codes) sometimes
            data[k] = lfsr[2] ? lfsr[7:0] : {5'b0, lfsr[10:8]};
         end
         @(posedge clk); rst<=1; rcnt=0; fi=0; running=0;
         @(posedge clk); rst<=0; running<=1;
         w=0; while (rcnt < n && w < 200000) begin @(posedge clk); w=w+1; end
         running<=0;
         if (rcnt < n) begin errors=errors+1; $display("FAIL [%0s] got %0d/%0d",tag,rcnt,n); end
         else begin
            k=0; for (k=0;k<n;k=k+1) if (rcv[k]!==data[k]) errors=errors+1;
            $display("PASS [%0s] %0d syms",tag,n);
         end
      end
   endtask

   initial begin
      rst=1; in_valid=0; in_sym=0; in_last=0; running=0;
      errors=0; test_num=0; rcnt=0; fi=0; lfsr=32'h1234ABCD;
      @(posedge clk);
      run(8,"n8"); run(64,"n64"); run(200,"n200");
      $display("\n==== errors=%0d after %0d tests ====",errors,test_num);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #20000000; $display("FAILED (timeout)"); $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_huffman_smoke.vcd");
      $dumpvars(0, test_huffman_smoke);
   end
`endif

endmodule
