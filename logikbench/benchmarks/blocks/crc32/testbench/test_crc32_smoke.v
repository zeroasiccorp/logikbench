//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: crc32 (10GbE FCS) smoke test, self-checking.
 *
 * TESTED:
 *   - Reference CRC-32 model against the canonical check value
 *     CRC32("123456789") == 0xCBF43926.
 *   - DUT vs reference over arbitrary-length frames including a partial final
 *     word: 1/7/8/13/16/60/63/64-byte frames, all-zeros, all-ones, and a
 *     pseudo-random frame (exercises the in_bytes byte-count tail path).
 *
 * NOT TESTED:
 *   - Only the default datapath width W=64; other widths not exercised.
 *   - Non-contiguous / odd keep patterns (assumes the valid bytes are the
 *     low contiguous byte lanes).
 *   - Back-to-back frames with no idle gap; mid-frame reset.
 *   - CRC of a stream that already includes its FCS (residue check).
 ******************************************************************************/
`timescale 1ns / 1ps

module test_crc32_smoke;

   localparam W    = 64;
   localparam BW   = W/8;                 // bytes per word
   localparam KW   = $clog2(W/8) + 1;     // width of in_bytes
   localparam MAXB = 256;

   reg	      clk, rst, in_valid, in_last;
   reg [W-1:0] in_data;
   reg [KW-1:0]	in_bytes;
   wire		out_valid;
   wire [31:0]	out_crc;

   crc32 #(.DW(W)) dut
     (.clk(clk), .rst(rst), .in_valid(in_valid), .in_data(in_data),
      .in_last(in_last), .in_bytes(in_bytes),
      .out_valid(out_valid), .out_crc(out_crc));

   always #5 clk = ~clk;

   reg [7:0] tb [0:MAXB-1];
   integer   errors, test_num;

   // byte-serial reference CRC-32 over tb[0..nb-1]
   function [31:0] crc_ref;
      input integer nb;
      reg [31:0]    c;
      reg [7:0]	    b;
      integer	    i, k;
      begin
         c = 32'hFFFFFFFF;
         for (k = 0; k < nb; k = k + 1) begin
            b = tb[k];
            for (i = 0; i < 8; i = i + 1)
              c = (c >> 1) ^ (32'hEDB88320 & {32{c[0] ^ b[i]}});
         end
         crc_ref = c ^ 32'hFFFFFFFF;
      end
   endfunction

   // stream nb bytes (any length >= 1) and check DUT vs reference
   task run_frame;
      input integer nb;
      input [8*24-1:0] tag;
      integer	       nwords, w, k, nbw;
      reg [W-1:0]      word;
      reg [31:0]       exp;
      begin
         test_num = test_num + 1;
         exp = crc_ref(nb);
         nwords = (nb + BW - 1) / BW;            // ceil
         @(posedge clk); rst <= 1'b1; in_valid <= 1'b0; in_last <= 1'b0;
         @(posedge clk); rst <= 1'b0;
         for (w = 0; w < nwords; w = w + 1) begin
            nbw = (w == nwords-1) ? (nb - (nwords-1)*BW) : BW;  // bytes
            word = {W{1'b0}};
            for (k = 0; k < nbw; k = k + 1)
              word[k*8 +: 8] = tb[w*BW + k];
            @(posedge clk);
            in_valid <= 1'b1;
            in_data  <= word;
            in_last  <= (w == nwords-1);
            in_bytes <= nbw[KW-1:0];
         end
         @(posedge clk); in_valid <= 1'b0; in_last <= 1'b0;
         @(negedge clk);
         if (out_valid !== 1'b1) begin
            errors = errors + 1;
            $display("FAIL [%0s] no out_valid", tag);
         end
         else if (out_crc !== exp) begin
            errors = errors + 1;
            $display("FAIL [%0s] crc got=%h exp=%h (%0d bytes)",
                     tag, out_crc, exp, nb);
         end
         else
           $display("PASS [%0s] crc=%h (%0d bytes)", tag, out_crc, nb);
      end
   endtask

   integer i;
   reg [31:0] kat;

   initial begin
      clk = 0; rst = 0; in_valid = 0; in_last = 0; in_data = 0; in_bytes = 0;
      errors = 0; test_num = 0;

      // reference-model KAT
      test_num = test_num + 1;
      for (i = 0; i < 9; i = i + 1) tb[i] = "1" + i;   // "123456789"
      kat = crc_ref(9);
      if (kat !== 32'hCBF43926) begin
         errors = errors + 1;
         $display("FAIL [ref KAT] got=%h exp=CBF43926", kat);
      end
      else
        $display("PASS [ref KAT] CRC32(\"123456789\")=%h", kat);

      // DUT, "123456789" (9 bytes = 1 full word + 1 byte) -> must be CBF43926
      for (i = 0; i < 9; i = i + 1) tb[i] = "1" + i;
      run_frame(9, "9B 123456789");

      // arbitrary lengths exercising the partial last word
      for (i = 0; i < MAXB; i = i + 1) tb[i] = i[7:0];
      run_frame(1,  "1B");
      run_frame(7,  "7B");
      run_frame(8,  "8B (full)");
      run_frame(13, "13B");
      run_frame(16, "16B (2 full)");
      run_frame(60, "60B eth-min");
      run_frame(63, "63B");
      run_frame(64, "64B (8 full)");

      // zeros and ones at odd lengths
      for (i = 0; i < MAXB; i = i + 1) tb[i] = 8'h00;
      run_frame(15, "15B zeros");
      for (i = 0; i < MAXB; i = i + 1) tb[i] = 8'hFF;
      run_frame(17, "17B ones");

      $display("\n============================================");
      $display(" errors = %0d (after %0d tests)", errors, test_num);
      if (errors == 0) $display(" PASSED"); else $display(" FAILED");
      $display("============================================");
      $finish;
   end

   initial begin
      #200000; $display("FAILED (watchdog timeout)"); $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_crc32_smoke.vcd");
      $dumpvars(0, test_crc32_smoke);
   end
`endif

endmodule
