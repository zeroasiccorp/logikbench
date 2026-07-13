//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: sha256 (self-check). Hashes the NIST single-block "abc" message
 * through the DUT's 32-bit register interface and compares the digest to the
 * known SHA-256 value, printing PASSED or FAILED.
 * TESTED: SHA-256 mode, one 512-bit block ("abc"), the register read/write
 * path, and the init to digest-ready handshake.
 * NOT TESTED: SHA-224 mode, multi-block chaining, back-to-back throughput.
 ******************************************************************************/
`timescale 1ns/1ps
module test_sha256_smoke;

   // secworks/sha256 register map
   localparam [7:0] ADDR_CTRL   = 8'h08;
   localparam [7:0] ADDR_STATUS = 8'h09;
   localparam [7:0] ADDR_BLOCK0 = 8'h10;
   localparam [7:0] ADDR_DIGEST0 = 8'h20;
   localparam [7:0] CTRL_INIT   = 8'h01;   // start a fresh hash
   localparam [7:0] CTRL_MODE   = 8'h04;   // 1 = SHA-256, 0 = SHA-224

   // NIST single-block "abc" message and expected SHA-256 digest
   localparam [511:0] BLOCK_ABC =
     512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
   localparam [255:0] DIGEST_ABC =
     256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD;

   reg         clk = 1'b0;
   reg         reset_n;
   always #5 clk = ~clk;

   reg         cs, we;
   reg  [7:0]  address;
   reg  [31:0] write_data;
   wire [31:0] read_data;
   wire        error;

   sha256 dut (.clk(clk), .reset_n(reset_n), .cs(cs), .we(we),
               .address(address), .write_data(write_data),
               .read_data(read_data), .error(error));

   reg [255:0] digest;
   reg [31:0]  rd;
   integer     i;

   // single-word register write (stimulus driven on the clock edge)
   task bus_write(input [7:0] a, input [31:0] d);
      begin
         @(posedge clk); cs <= 1'b1; we <= 1'b1; address <= a; write_data <= d;
         @(posedge clk); cs <= 1'b0; we <= 1'b0;
      end
   endtask

   // single-word register read; read_data is combinational on address
   task bus_read(input [7:0] a, output [31:0] d);
      begin
         @(posedge clk); cs <= 1'b1; we <= 1'b0; address <= a;
         @(posedge clk); #1 d = read_data; cs <= 1'b0;
      end
   endtask

   initial begin
      cs = 0; we = 0; address = 0; write_data = 0; digest = 0; rd = 0;
      // async reset, then release on a clock edge
      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      reset_n <= 1'b1;
      @(posedge clk);

      // load the 512-bit block, most-significant word first
      for (i = 0; i < 16; i = i + 1)
        bus_write(ADDR_BLOCK0 + i[7:0], BLOCK_ABC[511 - i*32 -: 32]);

      // start the SHA-256 hash (MODE | INIT)
      bus_write(ADDR_CTRL, {24'h0, (CTRL_MODE | CTRL_INIT)});

      // poll STATUS until the ready bit (bit 0) is set
      rd = 0;
      while (rd[0] === 1'b0)
        bus_read(ADDR_STATUS, rd);

      // read back the 256-bit digest, most-significant word first
      for (i = 0; i < 8; i = i + 1) begin
         bus_read(ADDR_DIGEST0 + i[7:0], rd);
         digest[255 - i*32 -: 32] = rd;
      end

      if (digest === DIGEST_ABC)
        $display("PASSED");
      else begin
         $display("FAILED: sha256(\"abc\") mismatch");
         $display("  expected 0x%064x", DIGEST_ABC);
         $display("  got      0x%064x", digest);
      end
      $finish;
   end

   // watchdog so a hang fails instead of running forever
   initial begin
      #100000;
      $display("FAILED: timeout waiting for digest");
      $finish;
   end

endmodule
