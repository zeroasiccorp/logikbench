//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: qr CORDIC-Givens QR decomposition (self-check).
 * Loads a fixed 16x16 strongly diagonally dominant, positive-diagonal integer
 * matrix A, runs the decomposition, and checks the result R without a golden
 * reference:
 *   (1) R is upper-triangular   -- every strictly sub-diagonal entry is ~0
 *   (2) Q is orthogonal         -- Frobenius norm is preserved: sum(R^2) ==
 *                                  sum(A^2) within tolerance
 * Tolerances absorb CORDIC and fixed-point rounding, which grow with the number
 * of rotations (N*(N-1)/2). Prints PASSED or FAILED.
 * NOT TESTED: N != 16, negative-diagonal / ill-conditioned matrices.
 ******************************************************************************/
`timescale 1ns/1ps
module test_qr_smoke;

   localparam N  = 16;
   localparam DW = 16;

   reg                  clk = 1'b0;
   reg                  reset_n;
   reg                  start;
   reg  [N*N*DW-1:0]    a_in;
   wire                 done;
   wire [N*N*DW-1:0]    r_out;

   always #5 clk = ~clk;

   qr #(.N(N), .DW(DW)) dut
     (.clk(clk), .reset_n(reset_n), .start(start),
      .a_in(a_in), .done(done), .r_out(r_out));

   reg  signed [DW-1:0] Amat [0:N*N-1];
   reg  signed [DW-1:0] R    [0:N*N-1];
   integer k, i, j;
   integer sumA, sumR, diff, mag, thr, errors;

   initial begin
      // strongly diagonally dominant, positive-diagonal test matrix (row-major)
      for (i = 0; i < N; i = i + 1)
        for (j = 0; j < N; j = j + 1)
          Amat[i*N + j] = (i == j) ? (100 - i)
                                   : (((i + j) & 1) ? 2 : 1);

      a_in = {(N*N*DW){1'b0}};
      for (k = 0; k < N*N; k = k + 1)
        a_in[k*DW +: DW] = Amat[k];

      errors  = 0;
      start   = 1'b0;
      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      reset_n <= 1'b1;
      @(posedge clk);

      start <= 1'b1;
      @(posedge clk);
      start <= 1'b0;

      while (!done)
        @(posedge clk);
      @(posedge clk);

      for (k = 0; k < N*N; k = k + 1)
        R[k] = $signed(r_out[k*DW +: DW]);

      // (1) upper-triangular: sub-diagonal entries ~ 0
      thr = 8;
      for (i = 0; i < N; i = i + 1)
        for (j = 0; j < N; j = j + 1)
          if (i > j) begin
             mag = R[i*N + j];
             if (mag < 0) mag = -mag;
             if (mag > thr) begin
                errors = errors + 1;
                $display("FAILED: R[%0d][%0d] = %0d not ~0 (thr %0d)",
                         i, j, R[i*N + j], thr);
             end
          end

      // (2) Frobenius-norm preservation (Q orthogonal)
      sumA = 0; sumR = 0;
      for (k = 0; k < N*N; k = k + 1) begin
         sumA = sumA + Amat[k] * Amat[k];
         sumR = sumR + R[k]    * R[k];
      end
      diff = sumR - sumA;
      if (diff < 0) diff = -diff;
      if (diff * 100 > 15 * sumA) begin
         errors = errors + 1;
         $display("FAILED: Frobenius sum(R^2)=%0d sum(A^2)=%0d (>15%%)",
                  sumR, sumA);
      end

      if (errors == 0)
        $display("PASSED");
      else
        $display("FAILED (%0d check(s))", errors);
      $finish;
   end

   initial begin
      #200000;
      $display("FAILED: timeout");
      $finish;
   end

endmodule
