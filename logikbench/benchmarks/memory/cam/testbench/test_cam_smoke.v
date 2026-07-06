//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for cam (exact-match CAM, self-checking). Loads DEPTH entries
// with distinct keys (10+i), searches each stored key (expect hit at index i),
// searches an absent key (expect no hit), then invalidates an entry and
// re-searches its key (expect no hit). Outputs are registered (1-cycle).
// TESTED: DW=8/AW=3. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_cam_smoke;
   localparam DW = 8, AW = 3, DEPTH = (1 << AW);

   reg	      clk = 0, we, wvalid;
   reg [AW-1:0]	waddr;
   reg [DW-1:0]	wdata, sdata;
   wire		match;
   wire [AW-1:0] match_addr;
   always #5 clk = ~clk;

   cam #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .we(we), .waddr(waddr), .wdata(wdata), .wvalid(wvalid),
      .sdata(sdata), .match(match), .match_addr(match_addr));

   integer        k, errors;

   initial begin
      errors = 0; we = 0; waddr = 0; wdata = 0; wvalid = 0; sdata = 0;

      // load DEPTH entries with distinct keys key[i] = 10+i, all valid
      for (k = 0; k < DEPTH; k = k + 1) begin
         @(posedge clk);
         we <= 1; waddr <= k[AW-1:0]; wdata <= (10 + k); wvalid <= 1;
      end
      @(posedge clk); we <= 0;

      // search each stored key -> hit at index k
      for (k = 0; k < DEPTH; k = k + 1) begin
         sdata = (10 + k);
         @(posedge clk); #1;   // registered outputs
         if (!match || match_addr !== k[AW-1:0]) begin
            errors = errors + 1;
            $display("FAIL search %0d: match=%b addr=%0d exp %0d",
                     10 + k, match, match_addr, k);
         end
      end

      // search an absent key -> no hit
      sdata = 99;
      @(posedge clk); #1;
      if (match) begin
         errors = errors + 1;
         $display("FAIL miss: match=1 for absent key 99");
      end

      // invalidate entry 2, then search its key (12) -> no hit
      @(posedge clk); we <= 1; waddr <= 2; wdata <= 12; wvalid <= 0;
      @(posedge clk); we <= 0;
      sdata = 12;
      @(posedge clk); #1;
      if (match) begin
         errors = errors + 1;
         $display("FAIL invalidated entry 2 still matches key 12");
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
