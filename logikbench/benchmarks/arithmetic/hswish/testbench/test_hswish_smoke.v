//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for hswish (hard-swish, self-checking).
// Checks the exact integer region formula and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_hswish_smoke;
   localparam DW=16, QW=8;
   localparam signed THREE = 3 <<< QW;  // 768
   localparam signed SIX          = 6 <<< QW;   // 1536
   localparam real   SCALE = 256.0;     // 2^QW
   localparam real   TOL          = 0.02;       // fixed-point tolerance

   reg		     clk=0;
   reg signed [DW-1:0] x;
   wire signed [DW-1:0]	out;
   integer		t, errors;
   integer		exp;
   real			xr, tr, outr, err;

   always #5 clk=~clk;

   hswish #(.DW(DW), .QW(QW)) dut (.x(x), .out(out));

   task check;
      input signed [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv;
         @(posedge clk); #1;
         // exact integer region reference
         if (x <= -THREE)       exp = 0;
         else if (x >= THREE)   exp = x;
         else                   exp = (x * (x + THREE)) / SIX;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, $signed(out), exp);
         end
         // real-valued accuracy vs true hard-swish
         xr = x / SCALE;
         if (xr <= -3.0)      tr = 0.0;
         else if (xr >= 3.0)  tr = xr;
         else                 tr = xr * (xr + 3.0) / 6.0;
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
      // directed: both saturating regions, boundaries, and mid values
      check(-1000);     // -> 0
      check( 1000);     // -> x
      check(0);         // -> 0
      check(256);       // x=1.0
      check(-384);      // x=-1.5 (hardswish minimum region)
      check(-768);      // x=-3.0 boundary
      check(768);       // x=+3.0 boundary
      // random
      for (t=0; t<200; t=t+1)
        check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_hswish_smoke.vcd");
      $dumpvars(0, test_hswish_smoke);
   end
`endif

endmodule
