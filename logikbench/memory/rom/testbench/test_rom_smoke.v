//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for rom (synchronous ROM, self-checking).
// The ROM is initialized so mem[i] = i*i. Reads every address (synchronous,
// 1-cycle, gated by en) and checks dout == (i*i) truncated to DW bits.
// TESTED: DW=8/AW=4 full read. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_rom_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW);

   reg	      clk = 0, en;
   reg [AW-1:0]	addr;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   rom #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .en(en), .addr(addr), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]   exp;

   initial begin
      errors = 0; en = 0; addr = 0;

      for (k = 0; k < N; k = k + 1) begin
         en <= 1; addr <= k[AW-1:0];
         @(posedge clk);     // dout <= mem[k] = k*k
         #1;
         exp = (k * k);
         if (dout !== exp) begin
            errors = errors + 1;
            $display("FAIL addr %0d: got %h exp %h", k, dout, exp);
         end
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
