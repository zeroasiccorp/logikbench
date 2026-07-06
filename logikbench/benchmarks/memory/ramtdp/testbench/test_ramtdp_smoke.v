//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ramtdp (true dual-port la_tdpram, self-checking).
// Both ports can read and write (synchronous, 1-cycle read). Writes the low
// half of the address space through port A and the high half through port B,
// then reads each half back through the OPPOSITE port and compares.
// TESTED: DW=8/AW=4 cross-port write/read-back. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_ramtdp_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW), H = N/2;

   reg	      clk = 0, en_a, we_a, en_b, we_b;
   reg [AW-1:0]	addr_a, addr_b;
   reg [DW-1:0]	din_a, din_b;
   wire [DW-1:0] dout_a, dout_b;
   always #5 clk = ~clk;

   ramtdp #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .en_a(en_a), .we_a(we_a), .addr_a(addr_a), .din_a(din_a),
      .dout_a(dout_a), .en_b(en_b), .we_b(we_b), .addr_b(addr_b),
      .din_b(din_b), .dout_b(dout_b));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];

   initial begin
      errors = 0;
      en_a = 0; we_a = 0; addr_a = 0; din_a = 0;
      en_b = 0; we_b = 0; addr_b = 0; din_b = 0;
      for (k = 0; k < N; k = k + 1) exp[k] = $random;

      // port A writes low half [0,H), port B writes high half [H,N)
      for (k = 0; k < H; k = k + 1) begin
         @(posedge clk);
         en_a <= 1; we_a <= 1; addr_a <= k[AW-1:0];        din_a <= exp[k];
         en_b <= 1; we_b <= 1; addr_b <= (H+k);            din_b <= exp[H+k];
      end
      @(posedge clk); we_a <= 0; we_b <= 0;

      // read low half via port B, high half via port A (opposite ports)
      for (k = 0; k < H; k = k + 1) begin
         en_b <= 1; we_b <= 0; addr_b <= k[AW-1:0];
         en_a <= 1; we_a <= 0; addr_a <= (H+k);
         @(posedge clk); #1;
         if (dout_b !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL portB addr %0d: got %h exp %h", k, dout_b, exp[k]);
         end
         if (dout_a !== exp[H+k]) begin
            errors = errors + 1;
            $display("FAIL portA addr %0d: got %h exp %h",
                     H+k, dout_a, exp[H+k]);
         end
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
