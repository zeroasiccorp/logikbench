//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for rambit (single-port RAM with per-bit write mask).
// 'we' is the per-bit write mask, 'ce' gates access (read+write share the
// port, synchronous 1-cycle read). Writes all addresses (mask = all ones),
// reads back, then verifies a partial-bit masked write updates only the
// masked bits.
// TESTED: DW=8/AW=4 full write+read-back + one masked write. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_rambit_smoke;
   localparam DW = 8, AW = 4, N = (1 << AW);

   reg	      clk = 0, ce;
   reg [DW-1:0]	we;
   reg [AW-1:0]	addr;
   reg [DW-1:0]	din;
   wire [DW-1:0] dout;
   always #5 clk = ~clk;

   rambit #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .ce(ce), .we(we), .addr(addr), .din(din), .dout(dout));

   integer        k, errors;
   reg [DW-1:0]	  exp [0:N-1];
   reg [DW-1:0]	  masked;

   initial begin
      errors = 0; ce = 0; we = 0; addr = 0; din = 0;

      // full write (mask all ones)
      for (k = 0; k < N; k = k + 1) begin
         exp[k] = $random;
         @(posedge clk); ce <= 1; we <= {DW{1'b1}}; addr <= k[AW-1:0];
         din <= exp[k];
      end
      @(posedge clk); we <= {DW{1'b0}};   // stop writing, keep ce for reads

      // read back (mask zero => no write, just read)
      for (k = 0; k < N; k = k + 1) begin
         ce <= 1; we <= {DW{1'b0}}; addr <= k[AW-1:0];
         @(posedge clk); #1;
         if (dout !== exp[k]) begin
            errors = errors + 1;
            $display("FAIL addr %0d: got %h exp %h", k, dout, exp[k]);
         end
      end

      // masked write to addr 3: only low nibble should change
      masked = (exp[3] & 8'hF0) | (8'h0A & 8'h0F);
      @(posedge clk); ce <= 1; we <= 8'h0F; addr <= 4'd3; din <= 8'h0A;
      @(posedge clk); we <= 8'h00;
      ce <= 1; addr <= 4'd3;
      @(posedge clk); #1;
      if (dout !== masked) begin
         errors = errors + 1;
         $display("FAIL masked write: got %h exp %h", dout, masked);
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_rambit_smoke.vcd");
      $dumpvars(0, test_rambit_smoke);
   end
`endif

endmodule
