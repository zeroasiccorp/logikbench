//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ramasync (sync-write, async-read RAM, self-checking).
// Reads are combinational (dout = mem[addr]); writes are synchronous. Writes
// all addresses then reads them back combinationally and compares.
// TESTED: DW=8/AW=4 full write+read-back. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_ramasync_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW);

   reg	      clk = 0, we;
   reg [AW-1:0]	addr;
   reg [DW-1:0]	din;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   ramasync #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];

   initial begin
      errors = 0; we = 0; addr = 0; din = 0;

      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); we <= 1; addr <= k[AW-1:0]; din <= exp[k];
      end
      @(posedge clk); we <= 0;
      @(posedge clk);     // let we=0 settle so reads don't race the last write

      // combinational read-back
      for (k = 0; k < N; k = k + 1) begin
         addr = k[AW-1:0]; #1;
         if (dout !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL addr %0d: got %h exp %h", k, dout, exp[k]);
         end
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
