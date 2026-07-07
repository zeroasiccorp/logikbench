//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for gelu (x*sigmoid(1.702x) with PLAN sigmoid).
// Checks the exact integer datapath and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_gelu_smoke;
   localparam DW=16, QW=8;
   localparam signed ONE = (1 <<< QW);
   localparam signed B1 = (1 <<< QW);
   localparam signed B2 = (19 <<< QW) >>> 3;
   localparam signed B3 = (5 <<< QW);
   localparam signed O0 = (1 <<< QW) >>> 1;
   localparam signed O1 = (5 <<< QW) >>> 3;
   localparam signed O2 = (27 <<< QW) >>> 5;
   localparam signed K  = (1702 * (1 <<< QW) + 500) / 1000;
   localparam real   SCALE = 256.0;
   localparam real   TOL   = 0.15;      // generous: double approximation

   reg		     clk=0;
   reg signed [DW-1:0] x;
   wire signed [DW-1:0]	out;
   integer		t, errors;
   integer		sarg, xa, y, sig, exp;
   real			xr, tr, outr, err, g;

   always #5 clk=~clk;

   gelu #(.DW(DW), .QW(QW)) dut (.x(x), .out(out));

   task check;
      input signed [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv;
         @(posedge clk); #1;
         // exact integer reference of the datapath
         sarg = (x * K) >>> QW;
         xa = (sarg < 0) ? -sarg : sarg;
         if      (xa >= B3) y = ONE;
         else if (xa >= B2) y = (xa >>> 5) + O2;
         else if (xa >= B1) y = (xa >>> 3) + O1;
         else               y = (xa >>> 2) + O0;
         sig = (sarg < 0) ? (ONE - y) : y;
         exp = (x * sig) >>> QW;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, $signed(out), exp);
         end
         // real-valued accuracy vs true GELU (tanh form of x*Phi(x))
         xr = x / SCALE;
         g = 0.7978845608 * (xr + 0.044715 * xr * xr * xr);
         tr = 0.5 * xr * (1.0 + $tanh(g));
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
      // directed: zero, small +/-, transition region, saturation
      check(0);         // 0
      check(256);       // x=1.0
      check(-256);      // x=-1.0
      check(512);       // x=2.0 (near max error)
      check(-512);      // x=-2.0
      check(2560);      // x=10.0 -> ~x
      // random
      for (t=0; t<200; t=t+1)
        check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
