//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for macs (signed multiply-accumulate, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_macs_smoke;
   localparam DW=8, ACCW=32;
   reg	      clk=0;
   reg	      clear, en;
   reg signed [DW-1:0] a, b;
   wire signed [ACCW-1:0] c;
   reg signed [ACCW-1:0]     ref;
   reg			     started;
   integer		     t, errors;

   always #5 clk=~clk;

   macs #(.DW(DW), .ACCW(ACCW)) dut (.clk(clk), .clear(clear), .en(en),
                                     .a(a), .b(b), .c(c));

   // reference model: identical accumulation, sampled on the same edge
   always @(posedge clk) begin
      if (clear)
        ref <= 0;
      else if (en)
        ref <= ref + $signed(a) * $signed(b);
   end

   // checker: after each edge the DUT and reference must agree
   always @(posedge clk) begin
      #1;
      if (started && (c !== ref)) begin
         errors = errors + 1;
         $display("FAIL t=%0d: got %0d exp %0d", t, c, ref);
      end
   end

   initial begin
      errors=0; started=0; clear=1'b1; en=1'b0; a=0; b=0;
      @(posedge clk);           // clear takes effect (c, ref -> 0)
      #2 started=1;
      clear <= 1'b0;
      for (t=0; t<80; t=t+1) begin
         a      <= $random;
         b      <= $random;
         en     <= $random;     // LSB: ~50% enable
         clear  <= (t==40);     // one mid-stream clear
         @(posedge clk);
      end
      #2;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
