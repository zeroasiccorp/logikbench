//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for tanh (PLAN via 2*sigmoid(2x)-1, self-checking).
// Checks the exact integer reference and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_tanh_smoke;
   localparam DW=16, QW=8;
   localparam signed ONE = (1 <<< QW);
   localparam signed B1 = (1 <<< QW);
   localparam signed B2 = (19 <<< QW) >>> 3;
   localparam signed B3 = (5 <<< QW);
   localparam signed O0 = (1 <<< QW) >>> 1;
   localparam signed O1 = (5 <<< QW) >>> 3;
   localparam signed O2 = (27 <<< QW) >>> 5;
   localparam real   SCALE = 256.0;
   localparam real   TOL   = 0.05;      // ~2x PLAN error + fixed point

   reg		     clk=0;
   reg signed [DW-1:0] x;
   wire signed [DW-1:0]	out;
   integer		t, errors;
   integer		x2, xa, y, sig, exp;
   real			xr, tr, outr, err;

   always #5 clk=~clk;

   tanh #(.DW(DW), .QW(QW)) dut (.x(x), .out(out));

   task check;
      input signed [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv;
         @(posedge clk); #1;
         // exact integer reference: PLAN sigmoid(2x), then 2*sig-1
         x2 = x <<< 1;
         xa = (x2 < 0) ? -x2 : x2;
         if      (xa >= B3) y = ONE;
         else if (xa >= B2) y = (xa >>> 5) + O2;
         else if (xa >= B1) y = (xa >>> 3) + O1;
         else               y = (xa >>> 2) + O0;
         sig = (x2 < 0) ? (ONE - y) : y;
         exp = (sig <<< 1) - ONE;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, $signed(out), exp);
         end
         // real-valued accuracy vs true tanh
         xr = x / SCALE;
         tr = $tanh(xr);
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
      // directed: zero, symmetry, saturation
      check(0);         // 0
      check(256);       // x=1.0
      check(-256);      // x=-1.0
      check(768);       // x=3.0 -> ~1.0
      check(-768);      // x=-3.0 -> ~-1.0
      // random
      for (t=0; t<200; t=t+1)
        check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
