//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for mod (sequential unsigned modulo, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_mod_smoke;
   localparam DW=8;
   reg	      clk=0;
   reg	      nreset, in_valid;
   reg [DW-1:0]	dividend, divisor;
   wire		out_valid, busy;
   wire [DW-1:0] remainder;
   integer	 t, errors;
   reg [DW-1:0]	 exp_r;

   always #5 clk=~clk;

   mod #(.DW(DW)) dut (.clk(clk), .nreset(nreset), .in_valid(in_valid),
                       .dividend(dividend), .divisor(divisor),
                       .out_valid(out_valid), .busy(busy),
                       .remainder(remainder));

   task run;
      input [DW-1:0] a;
      input [DW-1:0] b;
      begin
         @(posedge clk);
         dividend <= a; divisor <= b; in_valid <= 1'b1;
         @(posedge clk);
         in_valid <= 1'b0;
         while (out_valid !== 1'b1) @(posedge clk);
         #1;
         exp_r = (b != 0) ? (a % b) : a;   // mod by zero returns dividend
         if (remainder !== exp_r) begin
            errors = errors + 1;
            $display("FAIL: %0d mod %0d got %0d exp %0d", a, b, remainder, exp_r);
         end
      end
   endtask

   integer va, vb;
   initial begin
      errors=0; in_valid=0; dividend=0; divisor=0;
      nreset=0; @(posedge clk); @(posedge clk); nreset=1;
      run(100, 7);
      run(255, 16);
      run(0, 5);
      run(255, 255);
      run(200, 13);
      run(100, 0);      // mod 0 -> dividend
      for (t=0; t<60; t=t+1) begin
         va = $random; vb = $random;
         run(va[DW-1:0], vb[DW-1:0]);
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_mod_smoke.vcd");
      $dumpvars(0, test_mod_smoke);
   end
`endif

endmodule
