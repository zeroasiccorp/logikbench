//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for raminit (preloaded writable RAM, self-checking).
// First reads back the initial squares table (mem[i] == i*i), then writes
// random data over it and reads that back. Synchronous 1-cycle read.
// TESTED: DW=16/AW=4. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_raminit_smoke;
   localparam DW = 16, AW = 4, N = (1 << AW);

   reg	      clk = 0, en, we;
   reg [AW-1:0]	addr;
   reg [DW-1:0]	din;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   raminit #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .en(en), .we(we), .addr(addr), .din(din), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];

   initial begin
      errors = 0; en = 0; we = 0; addr = 0; din = 0;

      // read back the preloaded squares table
      for (k = 0; k < N; k = k + 1) begin
         en <= 1; we <= 0; addr <= k[AW-1:0];
         @(posedge clk);     // dout <= mem[k]
         #1;
         if (dout !== (k * k)) begin
            errors = errors + 1;
            $display("FAIL init addr %0d: got %h exp %h", k, dout, k * k);
         end
      end

      // overwrite with random data
      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); en <= 1; we <= 1; addr <= k[AW-1:0]; din <= exp[k];
      end
      @(posedge clk); en <= 0; we <= 0;

      // read the new data back
      for (k = 0; k < N; k = k + 1) begin
         en <= 1; we <= 0; addr <= k[AW-1:0];
         @(posedge clk);
         #1;
         if (dout !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL read addr %0d: got %h exp %h", k, dout, exp[k]);
         end
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
