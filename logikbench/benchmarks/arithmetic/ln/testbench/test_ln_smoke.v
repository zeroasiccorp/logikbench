//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ln (normalize + polynomial, self-checking).
// Checks the exact integer datapath and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_ln_smoke;
   localparam DW=16, QW=8;
   localparam real SCALE = 256.0;
   localparam real TOL   = 0.04;

   reg		   clk=0;
   reg signed [DW-1:0] x;
   wire signed [DW-1:0]	out;
   integer		tc, errors, i;
   integer		ux, p, e, mant, u, q2, q1, q0, lg, l2, exp_v;
   real			xr, tr, outr, err;

   always #5 clk=~clk;

   ln #(.DW(DW), .QW(QW)) dut (.x(x), .out(out));

   task check;
      input signed [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv;
         @(posedge clk); #1;
         // exact integer reference of the datapath
         ux = x;
         p = 0;
         for (i=0; i<DW; i=i+1)
           if ((ux >> i) & 1) p = i;
         e = p - QW;
         if (p >= QW) mant = ux >> (p - QW);
         else         mant = ux << (QW - p);
         u = mant & 255;
         q2 = 52;
         q1 = ((q2 * u) >>> QW) - 166;
         q0 = ((q1 * u) >>> QW) + 369;
         lg = (q0 * u) >>> QW;
         l2 = (e <<< QW) + lg;
         exp_v = (l2 * 177) >>> QW;
         if ($signed(out) !== exp_v) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, $signed(out), exp_v);
         end
         // real-valued accuracy vs true ln
         xr = x / SCALE;
         tr = $ln(xr);
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
      errors=0; x=256;
      // directed: 1.0, 2.0, 4.0, 0.5, smallest, largest
      check(256);       // ln(1) = 0
      check(512);       // ln(2) = 0.693
      check(1024);      // ln(4) = 1.386
      check(128);       // ln(0.5) = -0.693
      check(1);         // ln(1/256) = -5.545
      check(32767);     // ln(~128)
      check(255);       // just below 1.0
      // random positive
      for (tc=0; tc<200; tc=tc+1)
        check(({$random} % 32767) + 1);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
