//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: Reed-Solomon RS(544,514) KP4 codec smoke test (self-checking).
 *
 * Drives the reedsolomon top (rs_enc -> err_in injection -> rs_dec) and checks
 * the recovered data equals the input message (lossless within t=15 errors).
 *
 * TESTED (M=10, K=514, N=544, t=15):
 *   - no error      : recovered data == message, uncorrectable=0.
 *   - 10 errors     : corrected, recovered data == message, uncorrectable=0.
 *   - 15 errors (t) : corrected at the correction limit.
 *   - 16 errors (>t): uncorrectable=1 (detected, not corrected).
 *
 * NOT TESTED:
 *   - Only one injection pattern per error count (not exhaustive positions).
 *   - Back-to-back frames / pipelined throughput.
 *   - Miscorrection probability beyond t (only the flag is checked).
 ******************************************************************************/
`timescale 1ns/1ps
module test_reedsolomon_smoke;
   localparam M=10, K=514, N=544;
   reg clk=0, rst; always #5 clk=~clk;
   reg          in_valid, in_last; reg [M-1:0] in_sym, err_in;
   wire         in_ready, o_valid, o_last, unc; wire [M-1:0] o_sym;
   reedsolomon dut(.clk(clk),.rst(rst),.in_valid(in_valid),.in_sym(in_sym),
                   .in_last(in_last),.err_in(err_in),.in_ready(in_ready),
                   .out_valid(o_valid),.out_sym(o_sym),.out_last(o_last),
                   .uncorrectable(unc));

   reg [M-1:0] msg  [0:K-1];
   reg [M-1:0] es   [0:N-1];     // error stream, indexed by codeword position
   reg [M-1:0] dout [0:N-1];
   integer i, c, dptr, errors, t;
   reg [31:0] lf;

   always @(posedge clk)
     if (!rst && o_valid && dptr<N) begin dout[dptr]<=o_sym; dptr<=dptr+1; end

   task run; input integer ne; input [8*8-1:0] tag; reg expunc; integer j,p;
      begin
         for (i=0;i<N;i=i+1) es[i]=0;
         for (j=0;j<ne;j=j+1) begin
            p=(j*31+5)%N;
            lf={lf[30:0],lf[31]^lf[21]^lf[1]^lf[0]};
            es[p]=(lf[9:0]==0)?10'd1:lf[9:0];
         end
         dptr=0;
         @(posedge clk); rst<=1; @(posedge clk); @(posedge clk); rst<=0;
         @(posedge clk);
         // drive: data at cyclecnt 0..K-1, err_in at cyclecnt 1..N (= es[c-1])
         for (c=0; c<=N; c=c+1) begin
            if (c<K) begin in_valid<=1; in_sym<=msg[c]; in_last<=(c==K-1); end
            else begin in_valid<=0; in_last<=0; end
            err_in <= (c>=1 && c<=N) ? es[c-1] : 10'd0;
            @(posedge clk);
         end
         in_valid<=0; err_in<=0;
         t=0; while (dptr<N && t<4000) begin @(posedge clk); t=t+1; end
         @(posedge clk);
         expunc=(ne>15);
         if (dptr<N) begin errors=errors+1; $display("FAIL [%0s] dptr=%0d",tag,dptr); end
         else if (expunc) begin
            if (unc!==1'b1) begin errors=errors+1; $display("FAIL [%0s] expected unc",tag); end
            else $display("PASS [%0s] uncorrectable flagged",tag);
         end else begin
            if (unc!==1'b0) begin errors=errors+1; $display("FAIL [%0s] unexpected unc",tag); end
            for (j=0;j<K;j=j+1)
              if (dout[j]!==msg[j]) begin errors=errors+1;
                 if (errors<6) $display("FAIL [%0s] data[%0d]=%0d exp %0d",tag,j,dout[j],msg[j]); end
            if (unc===1'b0) $display("PASS [%0s] recovered (e=%0d)",tag,ne);
         end
      end
   endtask

   initial begin
      errors=0; in_valid=0; in_last=0; in_sym=0; err_in=0; dptr=0; lf=32'h1234ABCD;
      for (i=0;i<K;i=i+1) msg[i]=(i*7+1) & 10'h3FF;
      @(posedge clk);
      run(0,  "noerr");
      run(10, "e10");
      run(15, "e15");
      run(16, "e16");
      $display("\n==== errors=%0d ====",errors);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #8000000; $display("FAILED (timeout)"); $finish; end
endmodule
