//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for shiftreg (serial-in parallel-out shift register).
// Feeds a serial bit stream and checks the parallel output against a software
// shift model (preg[0]<=in, preg[i+1]<=preg[i]). Checks begin after DW shifts
// (the RTL has no reset, so the register starts unknown and must be flushed).
// Also checks that en=0 holds the contents.
// TESTED: DW=8, serial shift-in + hold. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_shiftreg_smoke;
   localparam DW = 8;
   reg	      clk = 0, en;
   reg	      in;
   wire [DW-1:0] out;
   always #5 clk = ~clk;

   shiftreg #(.DW(DW)) dut (.clk(clk), .en(en), .in(in), .out(out));

   integer        t, errors;
   reg		  b;
   reg [DW-1:0]	  model;

   initial begin
      errors = 0; en = 0; in = 0; model = 0;
      @(posedge clk);

      // shift in a stream; check once the initial unknown state is flushed
      for (t = 0; t < DW + 24; t = t + 1) begin
         b = $random;
         in <= b; en <= 1;
         @(posedge clk);                  // DUT samples in=b, shifts
         model = {model[DW-2:0], b};      // mirror the shift
         #1;
         if (t >= DW && out !== model) begin
            errors = errors + 1;
            $display("FAIL t=%0d: out=%h model=%h", t, out, model);
         end
      end

      // en=0 should hold the contents
      in <= ~in; en <= 0;
      @(posedge clk); #1;
      if (out !== model) begin
         errors = errors + 1;
         $display("FAIL hold: out=%h model=%h", out, model);
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
