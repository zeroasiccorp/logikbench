//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for exp (range-reduce + polynomial, self-checking).
// Checks the exact integer datapath (incl. saturation) and real accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_exp_smoke;
   localparam DW=16, QW=8;
   localparam MAXV = (1 <<< (DW-1)) - 1;        // 32767
   localparam real SCALE = 256.0;

   reg		   clk=0;
   reg signed [DW-1:0] x;
   wire signed [DW-1:0]	out;
   integer		tc, errors;
   integer		m, kk, frac, p2, p1, p0, pv, shifted, exp_v;
   real			xr, tr, outr, err, tol;

   always #5 clk=~clk;

   exp #(.DW(DW), .QW(QW)) dut (.x(x), .out(out));

   task check;
      input signed [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv;
         @(posedge clk); #1;
         // exact integer reference of the datapath
         m = (x * 369) >>> QW;
         kk = m >>> QW;
         frac = m & 255;
         p2 = 14;
         p1 = ((p2 * frac) >> QW) + 61;
         p0 = ((p1 * frac) >> QW) + 177;
         pv = ((p0 * frac) >> QW) + 256;
         if (kk >= 0) shifted = pv <<< kk;
         else         shifted = pv >>> (-kk);
         if      (kk >= 7)       exp_v = MAXV;
         else if (kk <= -9)      exp_v = 0;
         else if (shifted > MAXV) exp_v = MAXV;
         else                    exp_v = shifted;
         if ($signed(out) !== exp_v) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, $signed(out), exp_v);
         end
         // real accuracy (skip near saturation), relative tolerance
         xr = x / SCALE;
         tr = $exp(xr);
         outr = $itor($signed(out)) / SCALE;
         err = outr - tr;
         if (err < 0.0) err = -err;
         tol = 0.02 + 0.05 * tr;
         if (tr < 120.0 && err > tol) begin
            errors = errors + 1;
            $display("FAIL acc: x=%0d out=%f true=%f err=%f", x, outr, tr, err);
         end
      end
   endtask

   initial begin
      errors=0; x=0;
      // directed: 0, +/-1, +/-2, 4, saturation, underflow
      check(0);
      check(256);       // 1.0
      check(-256);      // -1.0
      check(512);       // 2.0
      check(-512);      // -2.0
      check(1024);      // 4.0
      check(1536);      // 6.0 -> saturate
      check(-1536);     // -6.0 -> ~0
      // random in value range [-6, 4.69]
      for (tc=0; tc<200; tc=tc+1)
        check(({$random} % 2737) - 1536);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_exp_smoke.vcd");
      $dumpvars(0, test_exp_smoke);
   end
`endif

endmodule
