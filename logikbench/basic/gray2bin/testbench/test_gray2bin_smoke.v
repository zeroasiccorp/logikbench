//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for gray2bin (Gray-to-binary decode, self-checking).
// Drives the Gray code of a known binary value B (B ^ (B>>1)) and checks the
// output decodes back to B. Independent of the DUT's internal recurrence.
// TESTED: DW=8, Gray->binary round-trip vs reference. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_gray2bin_smoke;
   localparam DW = 8;
   reg	      clk = 0;
   reg [DW-1:0]	in;
   wire [DW-1:0] out;
   always #5 clk = ~clk;

   gray2bin #(.DW(DW)) dut (.in(in), .out(out));

   integer        t, errors;

   task chk;
      input [DW-1:0] b;     // binary value; drive its Gray code, expect b back
      begin
         @(posedge clk); in <= b ^ (b >> 1);
         @(posedge clk); #1;
         if (out !== b) begin
            errors = errors + 1;
            $display("FAIL b=%h: gray=%h got %h", b, b ^ (b >> 1), out);
         end
      end
   endtask

   initial begin
      errors = 0; in = 0;
      chk(8'h00); chk(8'hff); chk(8'h01); chk(8'h80); chk(8'haa);
      for (t = 0; t < 24; t = t + 1) chk($random);
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
