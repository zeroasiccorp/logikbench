//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for addsklansky (self-checking, exhaustive at DW=8).
//
//#############################################################################
`timescale 1ns/1ps
module test_addsklansky_smoke;
   localparam DW=8;
   reg        clk=0;
   reg [DW-1:0] a, b;
   reg          cin;
   wire         cout;
   wire [DW-1:0] sum;
   integer       va, vb, vc, errors;
   reg [DW:0]    exp;

   always #5 clk=~clk;

   addsklansky #(.DW(DW)) dut (.a(a), .b(b), .cin(cin), .cout(cout), .sum(sum));

   // every a, b, cin combination
   initial begin
      errors=0; a=0; b=0; cin=0;
      for (va=0; va<(1<<DW); va=va+1)
        for (vb=0; vb<(1<<DW); vb=vb+1)
          for (vc=0; vc<2; vc=vc+1) begin
             @(posedge clk);
             a <= va; b <= vb; cin <= vc;
             @(posedge clk); #1;
             exp = va + vb + vc;
             if ({cout,sum} !== exp) begin
                errors = errors + 1;
                if (errors < 10)
                  $display("FAIL a=%h b=%h cin=%b: got %h exp %h",
                           a, b, cin, {cout,sum}, exp);
             end
          end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_addsklansky_smoke.vcd");
      $dumpvars(0, test_addsklansky_smoke);
   end
`endif

endmodule
