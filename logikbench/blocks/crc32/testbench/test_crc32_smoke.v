/******************************************************************************
 * Testbench: crc32 (10GbE FCS) smoke test, self-checking.
 *
 * - Validates a byte-serial reference CRC-32 against the canonical check
 *   value: CRC32("123456789") == 0xCBF43926.
 * - Streams full-width frames through the DUT (W bits/clock) and compares the
 *   frame FCS against the reference computed over the same bytes.
 ******************************************************************************/
`timescale 1ns / 1ps

module test_crc32_smoke;

   localparam W   = 64;
   localparam BW  = W/8;          // bytes per word
   localparam MAXB = 256;

   reg              clk, rst, in_valid, in_last;
   reg  [W-1:0]     in_data;
   wire             out_valid;
   wire [31:0]      out_crc;

   crc32 #(.W(W)) dut
     (.clk(clk), .rst(rst), .in_valid(in_valid), .in_data(in_data),
      .in_last(in_last), .out_valid(out_valid), .out_crc(out_crc));

   always #5 clk = ~clk;

   reg [7:0] tb [0:MAXB-1];       // byte buffer
   integer   errors, test_num;

   // byte-serial reference CRC-32 over tb[0..nb-1]
   function [31:0] crc_ref;
      input integer nb;
      reg [31:0] c;
      reg [7:0]  b;
      integer    i, k;
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

   // stream nb bytes (must be a multiple of BW) and check DUT vs reference
   task run_frame;
      input integer nb;
      input [8*24-1:0] tag;
      integer nwords, w, k;
      reg [W-1:0] word;
      reg [31:0]  exp;
      begin
         test_num = test_num + 1;
         exp = crc_ref(nb);
         nwords = nb / BW;
         @(posedge clk); rst <= 1'b1; in_valid <= 1'b0; in_last <= 1'b0;
         @(posedge clk); rst <= 1'b0;
         for (w = 0; w < nwords; w = w + 1) begin
            for (k = 0; k < BW; k = k + 1)
              word[k*8 +: 8] = tb[w*BW + k];
            @(posedge clk);
            in_valid <= 1'b1;
            in_data  <= word;
            in_last  <= (w == nwords-1);
         end
         @(posedge clk); in_valid <= 1'b0; in_last <= 1'b0;
         @(negedge clk);
         if (out_valid !== 1'b1) begin
            errors = errors + 1;
            $display("FAIL [%0s] no out_valid", tag);
         end
         else if (out_crc !== exp) begin
            errors = errors + 1;
            $display("FAIL [%0s] crc got=%h exp=%h", tag, out_crc, exp);
         end
         else
           $display("PASS [%0s] crc=%h (%0d bytes)", tag, out_crc, nb);
      end
   endtask

   integer i;
   reg [31:0] kat;

   initial begin
      clk = 0; rst = 0; in_valid = 0; in_last = 0; in_data = 0;
      errors = 0; test_num = 0;

      // 1) reference model KAT: CRC32("123456789") == 0xCBF43926
      test_num = test_num + 1;
      tb[0]="1"; tb[1]="2"; tb[2]="3"; tb[3]="4"; tb[4]="5";
      tb[5]="6"; tb[6]="7"; tb[7]="8"; tb[8]="9";
      kat = crc_ref(9);
      if (kat !== 32'hCBF43926) begin
         errors = errors + 1;
         $display("FAIL [ref KAT] got=%h exp=CBF43926", kat);
      end
      else
        $display("PASS [ref KAT] CRC32(\"123456789\")=%h", kat);

      // 2) DUT, 8 bytes "12345678" (one 64b word)
      for (i = 0; i < 8; i = i + 1) tb[i] = "1" + i;
      run_frame(8, "8B ascii");

      // 3) DUT, all zeros, 16 bytes
      for (i = 0; i < 16; i = i + 1) tb[i] = 8'h00;
      run_frame(16, "16B zeros");

      // 4) DUT, incrementing, 64 bytes
      for (i = 0; i < 64; i = i + 1) tb[i] = i[7:0];
      run_frame(64, "64B incr");

      // 5) DUT, 0xFF, 8 bytes
      for (i = 0; i < 8; i = i + 1) tb[i] = 8'hFF;
      run_frame(8, "8B ones");

      // 6) DUT, pseudo-random (LFSR), 32 bytes
      begin : rnd
         reg [15:0] l; l = 16'hACE1;
         for (i = 0; i < 32; i = i + 1) begin
            l = {l[14:0], l[15]^l[13]^l[12]^l[10]};
            tb[i] = l[7:0];
         end
      end
      run_frame(32, "32B random");

      $display("\n============================================");
      $display(" errors = %0d (after %0d tests)", errors, test_num);
      if (errors == 0) $display(" PASSED"); else $display(" FAILED");
      $display("============================================");
      $finish;
   end

   initial begin
      #100000; $display("FAILED (watchdog timeout)"); $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_crc32_smoke.vcd");
      $dumpvars(0, test_crc32_smoke);
   end
`endif

endmodule
