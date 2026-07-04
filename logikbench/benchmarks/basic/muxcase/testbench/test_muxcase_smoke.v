//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muxcase (one-hot 8:1 mux, self-checking).
// The select is one-hot (8'b0000_0001 selects input 0, etc.); any non-one-hot
// select returns 0 (default). Loads each input slice, checks every one-hot
// select, and checks that sel=0 and a multi-hot select both return 0.
// TESTED: DW=8, 8 one-hot selects + two default cases. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_muxcase_smoke;
   localparam DW = 8;
   reg	      clk = 0;
   reg [7:0]  sel;
   reg [8*DW-1:0] in;
   wire [DW-1:0]  out;
   always #5 clk = ~clk;

   muxcase #(.DW(DW)) dut (.sel(sel), .in(in), .out(out));

   integer          k, errors;
   reg [DW-1:0]	    slice [0:7];

   task chk;
      input [7:0]    s;
      input [DW-1:0] e;
      begin
         @(posedge clk); sel <= s;
         @(posedge clk); #1;
         if (out !== e) begin
            errors = errors + 1;
            $display("FAIL sel=%b: got %h exp %h", s, out, e);
         end
      end
   endtask

   initial begin
      errors = 0; sel = 0; in = 0;
      for (k = 0; k < 8; k = k + 1) begin
         slice[k] = $random;
         in[k*DW +: DW] = slice[k];
      end
      for (k = 0; k < 8; k = k + 1)
        chk(8'b1 << k, slice[k]);
      chk(8'b0000_0000, {DW{1'b0}});   // none selected -> 0
      chk(8'b0000_0011, {DW{1'b0}});   // multi-hot -> default 0
      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
