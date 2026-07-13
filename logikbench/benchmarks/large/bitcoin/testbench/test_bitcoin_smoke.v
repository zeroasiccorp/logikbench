//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: bitcoin SHA256d miner (self-check). Uses the real Bitcoin genesis
 * block header and target, seeds the nonce base just below the known winning
 * nonce (0x1dac2b7c == 2083236893), and checks that the miner finds it. A full
 * 2^32 sweep is infeasible in simulation, so the base is seeded near the
 * golden nonce. Prints PASSED or FAILED.
 * TESTED: end-to-end double-SHA256 of the genesis header, target compare,
 *         multi-lane nonce distribution and golden-nonce arbitration.
 * NOT TESTED: large NENGINES, full-range search, back-to-back work items.
 ******************************************************************************/
`timescale 1ns/1ps
module test_bitcoin_smoke;

   localparam integer NENGINES = 2;

   // Bitcoin genesis block: 80-byte header, difficulty target, winning nonce.
   localparam [639:0] GENESIS_HEADER =
     640'h0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c;
   localparam [255:0] GENESIS_TARGET =
     256'h00000000FFFF0000000000000000000000000000000000000000000000000000;
   localparam [31:0]  GOLDEN_NONCE = 32'h1dac2b7c;

   reg          clk = 1'b0;
   reg          reset_n;
   reg          start;
   reg  [639:0] header;
   reg  [255:0] target;
   reg  [31:0]  nonce_base;
   wire         found;
   wire [31:0]  golden_nonce;
   wire         busy;

   always #5 clk = ~clk;

   bitcoin #(.NENGINES(NENGINES)) dut
     (.clk(clk), .reset_n(reset_n), .start(start),
      .header(header), .target(target), .nonce_base(nonce_base),
      .found(found), .golden_nonce(golden_nonce), .busy(busy));

   initial begin
      // static work item (config, applied before the first edge)
      header     = GENESIS_HEADER;
      target     = GENESIS_TARGET;
      nonce_base = GOLDEN_NONCE - 32'd1;   // lane 1 lands on the golden nonce
      start      = 1'b0;

      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      reset_n <= 1'b1;
      @(posedge clk);

      // kick off the search
      start <= 1'b1;
      @(posedge clk);
      start <= 1'b0;

      // wait for a lane to report a hit
      while (!found)
        @(posedge clk);

      if (golden_nonce === GOLDEN_NONCE)
        $display("PASSED");
      else begin
         $display("FAILED: golden nonce mismatch");
         $display("  expected 0x%08x", GOLDEN_NONCE);
         $display("  got      0x%08x", golden_nonce);
      end
      $finish;
   end

   // watchdog so a miss/hang fails instead of running forever
   initial begin
      #200000;
      $display("FAILED: timeout, no nonce found");
      $finish;
   end

endmodule
