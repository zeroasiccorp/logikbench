//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for bor (reduction OR, self-checking). Drives directed and
// random vectors and compares the output against a reference.
// TESTED: DW=8 output vs reference. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_bor_smoke;
   localparam DW = 8;
   reg	      clk = 0;
   reg [DW-1:0]	in;
   wire		out;
   always #5 clk = ~clk;

   bor #(.DW(DW)) dut (.in(in), .out(out));

   integer        t, errors;
   reg		  exp;

   task chk;
      input [DW-1:0] v;
      begin
         @(posedge clk); in <= v;
         @(posedge clk); #1;
         exp = |v;
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL in=%h: got %h exp %h", v, out, exp);
         end
      end
   endtask

   initial begin
      errors = 0; in = 0;
      chk(8'h00); chk(8'hff); chk(8'h01); chk(8'h7f); chk(8'haa);
      for (t = 0; t < 24; t = t + 1) chk($random);
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
