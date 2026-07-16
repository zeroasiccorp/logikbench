//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for cache (direct-mapped cache, self-checking).
// Writes distinct lines, reads them back expecting hit + correct data, and
// checks a miss (same index, different tag -> hit=0). The miss test uses a
// previously-written line so it does not rely on the valid array (the RTL has
// no reset, so valid bits power up unknown). Read result is available two
// cycles after the request (1-cycle address register + 1-cycle array read).
// TESTED: DW=32/AW=16/INDEXW=4 write, read-hit, read-miss. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_cache_smoke;
   localparam DW = 32, AW = 16, INDEXW = 4;

   reg	      clk = 0, cpu_valid, cpu_write;
   reg [AW-1:0]	cpu_addr;
   reg [DW-1:0]	cpu_wdata;
   wire [DW-1:0] cpu_rdata;
   wire		 cpu_ready, cpu_hit;
   always #5 clk = ~clk;

   cache #(.DW(DW), .AW(AW), .INDEXW(INDEXW)) dut
     (.clk(clk), .cpu_valid(cpu_valid), .cpu_write(cpu_write),
      .cpu_addr(cpu_addr), .cpu_wdata(cpu_wdata), .cpu_rdata(cpu_rdata),
      .cpu_ready(cpu_ready), .cpu_hit(cpu_hit));

   integer        errors;
   reg [DW-1:0]	  rd;
   reg		  h, rdy;

   task cwrite;
      input [AW-1:0] a;
      input [DW-1:0] d;
      begin
         @(posedge clk); cpu_valid <= 1; cpu_write <= 1;
         cpu_addr <= a; cpu_wdata <= d;
         @(posedge clk); cpu_valid <= 0; cpu_write <= 0;
      end
   endtask

   task cread;
      input [AW-1:0] a;
      begin
         @(posedge clk); cpu_valid <= 1; cpu_write <= 0; cpu_addr <= a;
         @(posedge clk); cpu_valid <= 0;   // request registered
         @(posedge clk);                    // outputs computed
         #1; rd = cpu_rdata; h = cpu_hit; rdy = cpu_ready;
      end
   endtask

   initial begin
      errors = 0; cpu_valid = 0; cpu_write = 0; cpu_addr = 0; cpu_wdata = 0;
      @(posedge clk);

      // write three distinct-index lines
      cwrite(16'h0010, 32'hCAFEBABE);   // idx 0, tag 1
      cwrite(16'h0021, 32'h12345678);   // idx 1, tag 2
      cwrite(16'h0032, 32'hDEADBEEF);   // idx 2, tag 3

      // read each back: expect hit + correct data + ready
      cread(16'h0010);
      if (!(rdy && h && rd === 32'hCAFEBABE)) begin
         errors = errors + 1;
         $display("FAIL hit A0: rdy=%b hit=%b data=%h", rdy, h, rd);
      end
      cread(16'h0021);
      if (!(rdy && h && rd === 32'h12345678)) begin
         errors = errors + 1;
         $display("FAIL hit A1: rdy=%b hit=%b data=%h", rdy, h, rd);
      end
      cread(16'h0032);
      if (!(rdy && h && rd === 32'hDEADBEEF)) begin
         errors = errors + 1;
         $display("FAIL hit A2: rdy=%b hit=%b data=%h", rdy, h, rd);
      end

      // miss: same index 0, different tag -> valid line, tag mismatch -> hit=0
      cread(16'h0090);
      if (!(rdy && !h)) begin
         errors = errors + 1;
         $display("FAIL miss: rdy=%b hit=%b (expected ready, no hit)", rdy, h);
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_cache_smoke.vcd");
      $dumpvars(0, test_cache_smoke);
   end
`endif

endmodule
