//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for rambyte (single-port RAM with per-byte write mask).
// 'we' is the per-byte write mask (one bit per 8-bit lane), 'ce' gates access
// (synchronous 1-cycle read). Writes all addresses (mask = all ones), reads
// back, then verifies a per-byte masked write updates only the masked lane.
// TESTED: DW=16/AW=4 full write+read-back + one byte-masked write.
//
//#############################################################################
`timescale 1ns/1ps
module test_rambyte_smoke;
   localparam DW = 16, AW = 4, N = (1 << AW), NB = DW/8;

   reg	      clk = 0, ce;
   reg [NB-1:0]	we;
   reg [AW-1:0]	addr;
   reg [DW-1:0]	din;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   rambyte #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .ce(ce), .we(we), .addr(addr), .din(din), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];
   reg [DW-1:0]	  masked;

   initial begin
      errors = 0; ce = 0; we = 0; addr = 0; din = 0;

      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); ce <= 1; we <= {NB{1'b1}}; addr <= k[AW-1:0];
         din <= exp[k];
      end
      @(posedge clk); we <= {NB{1'b0}};

      for (k = 0; k < N; k = k + 1) begin
         ce <= 1; we <= {NB{1'b0}}; addr <= k[AW-1:0];
         @(posedge clk); #1;
         if (dout !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL addr %0d: got %h exp %h", k, dout, exp[k]);
         end
      end

      // byte-masked write to addr 2: only low byte should change
      masked = (exp[2] & 16'hFF00) | 16'h00A5;
      @(posedge clk); ce <= 1; we <= 2'b01; addr <= 4'd2; din <= 16'h33A5;
      @(posedge clk); we <= 2'b00;
      ce <= 1; addr <= 4'd2;
      @(posedge clk); #1;
      if (dout !== masked) begin
         errors = errors + 1;
         $display("FAIL byte-masked write: got %h exp %h", dout, masked);
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_rambyte_smoke.vcd");
      $dumpvars(0, test_rambyte_smoke);
   end
`endif

endmodule
