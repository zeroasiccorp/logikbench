//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for div (sequential unsigned divide, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_div_smoke;
   localparam DW=8;
   reg	      clk=0;
   reg	      nreset;
   reg	      in_valid;
   reg [DW-1:0]	dividend, divisor;
   wire		out_valid, busy;
   wire [DW-1:0] quotient, remainder;
   integer	 t, errors;
   reg [DW-1:0]	 exp_q, exp_r;

   always #5 clk=~clk;

   div #(.DW(DW)) dut (.clk(clk), .nreset(nreset), .in_valid(in_valid),
                       .dividend(dividend), .divisor(divisor),
                       .out_valid(out_valid), .busy(busy),
                       .quotient(quotient), .remainder(remainder));

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
         if (b != 0) begin
            exp_q = a / b;
            exp_r = a % b;
            if (quotient !== exp_q || remainder !== exp_r) begin
               errors = errors + 1;
               $display("FAIL: %0d/%0d got q=%0d r=%0d exp q=%0d r=%0d",
                        a, b, quotient, remainder, exp_q, exp_r);
            end
         end else begin
            if (quotient !== {DW{1'b1}}) begin
               errors = errors + 1;
               $display("FAIL divby0: %0d/0 got q=%0d exp all-ones", a, quotient);
            end
         end
      end
   endtask

   integer va, vb;
   initial begin
      errors=0; in_valid=0; dividend=0; divisor=0;
      nreset=0; @(posedge clk); @(posedge clk); nreset=1;
      // directed
      run(100, 7);
      run(255, 1);
      run(0, 5);
      run(255, 255);
      run(200, 13);
      run(100, 0);      // divide by zero -> all ones
      // random
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
      $dumpfile("test_div_smoke.vcd");
      $dumpvars(0, test_div_smoke);
   end
`endif

endmodule
