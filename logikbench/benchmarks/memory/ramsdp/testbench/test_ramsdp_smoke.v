//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ramsdp (simple dual-port la_dpram, self-checking).
// Port A is write-only, port B is read-only (synchronous, 1-cycle). Writes all
// addresses through port A then reads them back through port B and compares.
// TESTED: DW=8/AW=4 full write+read-back. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_ramsdp_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW);

   reg	      clk = 0, en_a, we_a, en_b;
   reg [AW-1:0]	addr_a, addr_b;
   reg [DW-1:0]	din_a;
   wire [DW-1:0] dout_b;
   always #5 clk = ~clk;

   ramsdp #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .en_a(en_a), .we_a(we_a), .addr_a(addr_a), .din_a(din_a),
      .en_b(en_b), .addr_b(addr_b), .dout_b(dout_b));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];

   initial begin
      errors = 0; en_a = 0; we_a = 0; din_a = 0; addr_a = 0;
      en_b = 0; addr_b = 0;

      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); en_a <= 1; we_a <= 1; addr_a <= k[AW-1:0];
         din_a <= exp[k];
      end
      @(posedge clk); en_a <= 0; we_a <= 0;

      for (k = 0; k < N; k = k + 1) begin
         en_b <= 1; addr_b <= k[AW-1:0];
         @(posedge clk);     // dout_b <= mem[k]
         #1;
         if (dout_b !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL addr %0d: got %h exp %h", k, dout_b, exp[k]);
         end
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
