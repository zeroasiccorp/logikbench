//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for sigmoid (PLAN piecewise-linear, self-checking).
// Checks the exact integer PLAN segments and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_sigmoid_smoke;
   localparam DW=16, QW=8;
   localparam signed ONE = (1 <<< QW);          // 1.0
   localparam signed B1 = (1 <<< QW);           // 1.0
   localparam signed B2 = (19 <<< QW) >>> 3;    // 2.375
   localparam signed B3 = (5 <<< QW);           // 5.0
   localparam signed O0 = (1 <<< QW) >>> 1;     // 0.5
   localparam signed O1 = (5 <<< QW) >>> 3;     // 0.625
   localparam signed O2 = (27 <<< QW) >>> 5;    // 0.84375
   localparam real   SCALE = 256.0;             // 2^QW
   localparam real   TOL   = 0.03;              // PLAN error + fixed point

   reg		     clk=0;
   reg signed [DW-1:0] x;
   wire signed [DW-1:0]	out;
   integer		t, errors;
   integer		xa, y, exp;
   real			xr, tr, outr, err;

   always #5 clk=~clk;

   sigmoid #(.DW(DW), .QW(QW)) dut (.x(x), .out(out));

   task check;
      input signed [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv;
         @(posedge clk); #1;
         // exact integer PLAN reference
         xa = (x < 0) ? -x : x;
         if      (xa >= B3) y = ONE;
         else if (xa >= B2) y = (xa >>> 5) + O2;
         else if (xa >= B1) y = (xa >>> 3) + O1;
         else               y = (xa >>> 2) + O0;
         exp = (x < 0) ? (ONE - y) : y;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, $signed(out), exp);
         end
         // real-valued accuracy vs true sigmoid
         xr = x / SCALE;
         tr = 1.0 / (1.0 + $exp(-xr));
         outr = $itor($signed(out)) / SCALE;
         err = outr - tr;
         if (err < 0.0) err = -err;
         if (err > TOL) begin
            errors = errors + 1;
            $display("FAIL acc: x=%0d out=%f true=%f err=%f", x, outr, tr, err);
         end
      end
   endtask

   initial begin
      errors=0; x=0;
      // directed: zero, segment boundaries, saturation, symmetry
      check(0);         // 0.5
      check(256);       // x=1.0
      check(-256);      // x=-1.0
      check(608);       // x=2.375 boundary
      check(1280);      // x=5.0 -> 1.0
      check(-1280);     // x=-5.0 -> 0.0
      // random
      for (t=0; t<200; t=t+1)
        check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_sigmoid_smoke.vcd");
      $dumpvars(0, test_sigmoid_smoke);
   end
`endif

endmodule
