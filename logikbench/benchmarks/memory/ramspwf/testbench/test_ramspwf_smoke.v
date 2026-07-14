//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ramspwf (single-port write-first RAM, self-checking).
// Writes all addresses (en&we) and reads them back (en&~we), then checks the
// write-first read-during-write: writing NEW to an address drives NEW on dout
// the same cycle. TESTED: DW=8/AW=4. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_ramspwf_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW);

   reg	      clk = 0, en, we;
   reg [AW-1:0]	addr;
   reg [DW-1:0]	din;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   ramspwf #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .en(en), .we(we), .addr(addr), .din(din), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];

   initial begin
      errors = 0; en = 0; we = 0; addr = 0; din = 0;

      // write every address
      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); en <= 1; we <= 1; addr <= k[AW-1:0]; din <= exp[k];
      end
      @(posedge clk); en <= 0; we <= 0;

      // read back and compare
      for (k = 0; k < N; k = k + 1) begin
         en <= 1; we <= 0; addr <= k[AW-1:0];
         @(posedge clk);     // dout <= mem[k]
         #1;
         if (dout !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL read addr %0d: got %h exp %h", k, dout, exp[k]);
         end
      end

      // write-first: writing NEW to addr 0 drives NEW on dout this cycle
      @(posedge clk); en <= 1; we <= 1; addr <= 0; din <= 8'hA5;
      @(posedge clk); #1;    // dout <= din (write-first) = A5
      if (dout !== 8'hA5) begin
         errors = errors + 1;
         $display("FAIL write-first: dout %h exp A5", dout);
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_ramspwf_smoke.vcd");
      $dumpvars(0, test_ramspwf_smoke);
   end
`endif

endmodule
