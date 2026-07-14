//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ramsp (single-port la_spram, self-checking).
// Writes pseudo-random data to every address, then reads it all back and
// compares. Read is synchronous (la_spram, 1-cycle, read-first), so reads are
// done write-all-then-read-all to avoid same-cycle read/write hazards.
// TESTED: DW=8/AW=4 full write+read-back. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_ramsp_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW);

   reg	      clk = 0, we;
   reg [AW-1:0]	addr;
   reg [DW-1:0]	din;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   ramsp #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];

   initial begin
      errors = 0; we = 0; addr = 0; din = 0;

      // write every address
      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); we <= 1; addr <= k[AW-1:0]; din <= exp[k];
      end
      @(posedge clk); we <= 0;

      // read every address back (1-cycle synchronous read)
      for (k = 0; k < N; k = k + 1) begin
         addr <= k[AW-1:0];
         @(posedge clk);     // dout <= mem[k] at this edge
         #1;                 // settle past the NBA update
         if (dout !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL addr %0d: got %h exp %h", k, dout, exp[k]);
         end
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_ramsp_smoke.vcd");
      $dumpvars(0, test_ramsp_smoke);
   end
`endif

endmodule
