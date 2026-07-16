//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: tpu 8x8 weight-stationary systolic matrix multiply (self-check).
 * Loads a weight matrix B, streams an activation matrix A, and compares each
 * drained result row C[m][*] to a software integer matmul C = A * B.
 * TESTED: random signed int8 tiles (several), identity-B passthrough.
 * NOT TESTED: only N=8/DW=8; single tile (no cross-tile accumulation).
 * (The interface is fixed-latency valid-only -- there is no backpressure.)
 ******************************************************************************/
`timescale 1ns/1ps
module test_tpu_smoke;
   localparam N = 8, DW = 8, ACCW = 32, LAT = 2*N-1;

   reg	      clk = 0, rst;
   always #5 clk = ~clk;

   reg              w_valid, a_valid;
   reg [N*DW-1:0]   w_data, a_data;
   wire		    c_valid;
   wire [N*ACCW-1:0] c_data;

   tpu #(.N(N), .DW(DW), .ACCW(ACCW)) dut
     (.clk(clk), .rst(rst), .w_valid(w_valid), .w_data(w_data),
      .a_valid(a_valid), .a_data(a_data), .c_valid(c_valid), .c_data(c_data));

   // matrices and reference
   reg signed [DW-1:0]   A [0:N*N-1];
   reg signed [DW-1:0]	 B [0:N*N-1];
   integer		 C [0:N*N-1];   // golden
   reg [N*ACCW-1:0]	 rcv [0:N-1];    // captured result rows
   reg [N*ACCW-1:0]	 row;            // temp for part-select of a word
   integer		 rcnt;

   integer		 i, j, m, acc, errors, t, tc;

   // capture result rows as they drain
   always @(posedge clk)
     if (!rst && c_valid && rcnt < N) begin
        rcv[rcnt] <= c_data;
        rcnt <= rcnt + 1;
     end

   // run one full matmul: load B, stream A, collect C, check vs golden
   task run;
      input [8*8-1:0] tag;
      begin
         // software reference C = A * B
         for (m = 0; m < N; m = m + 1)
           for (j = 0; j < N; j = j + 1) begin
              acc = 0;
              for (i = 0; i < N; i = i + 1)
                acc = acc + A[m*N+i] * B[i*N+j];
              C[m*N+j] = acc;
           end

         // reset
         rcnt = 0;
         @(posedge clk); rst <= 1; w_valid <= 0; a_valid <= 0;
         @(posedge clk); @(posedge clk); rst <= 0; @(posedge clk);

         // weight load: bottom matrix row first (shift south)
         for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1)
              w_data[j*DW +: DW] <= B[(N-1-i)*N + j];
            w_valid <= 1;
            @(posedge clk);
         end
         w_valid <= 0;

         // compute: stream A one row per cycle
         for (m = 0; m < N; m = m + 1) begin
            for (j = 0; j < N; j = j + 1)
              a_data[j*DW +: DW] <= A[m*N + j];
            a_valid <= 1;
            @(posedge clk);
         end
         a_valid <= 0;

         // wait for all rows to drain
         t = 0;
         while (rcnt < N && t < 4*N + LAT) begin
            @(posedge clk); t = t + 1;
         end

         // check
         if (rcnt < N) begin
            errors = errors + 1;
            $display("FAIL [%0s]: captured %0d/%0d rows", tag, rcnt, N);
         end
         else begin
            for (m = 0; m < N; m = m + 1) begin
               row = rcv[m];
               for (j = 0; j < N; j = j + 1)
                 if ($signed(row[j*ACCW +: ACCW]) !== C[m*N+j]) begin
                    errors = errors + 1;
                    $display("FAIL [%0s]: C[%0d][%0d] got %0d exp %0d", tag,
                             m, j, $signed(row[j*ACCW +: ACCW]), C[m*N+j]);
                 end
            end
         end
      end
   endtask

   initial begin
      errors = 0; w_valid = 0; a_valid = 0; w_data = 0; a_data = 0; rst = 1;

      // identity B: C should equal A
      for (i = 0; i < N*N; i = i + 1) begin
         A[i] = $random;
         B[i] = ((i/N) == (i%N)) ? 8'sd1 : 8'sd0;
      end
      run("ident");

      // several random signed int8 tiles
      for (tc = 0; tc < 4; tc = tc + 1) begin
         for (i = 0; i < N*N; i = i + 1) begin
            A[i] = $random;
            B[i] = $random;
         end
         run("rand");
      end

      if (errors == 0)
        $display("PASSED");
      else
        $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_tpu_smoke.vcd");
      $dumpvars(0, test_tpu_smoke);
   end
`endif

endmodule
