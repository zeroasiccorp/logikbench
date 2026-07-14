//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for atan (CORDIC vectoring-mode arctan, self-checking).
// Checks the exact integer CORDIC recurrence and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_atan_smoke;
   localparam DW=16, QW=8, N=12;
   localparam real SCALE = 256.0;
   localparam real TOL   = 0.03;        // Q8.8 CORDIC accuracy (radians)

   reg		   clk=0;
   reg signed [DW-1:0] t;
   wire signed [DW-1:0]	out;
   integer		tc, errors, k;
   integer		xi, yi, zi, xsh, ysh, exp;
   integer		atant [0:N-1];
   real			tr_in, tr, outr, err;

   always #5 clk=~clk;

   atan #(.DW(DW), .QW(QW), .N(N)) dut (.t(t), .out(out));

   initial begin
      atant[0]=201; atant[1]=119; atant[2]=63; atant[3]=32;
      atant[4]=16;  atant[5]=8;   atant[6]=4;  atant[7]=2;
      atant[8]=1;   atant[9]=0;   atant[10]=0; atant[11]=0;
   end

   task check;
      input signed [DW-1:0] tv;
      begin
         @(posedge clk);
         t <= tv;
         @(posedge clk); #1;
         // exact integer CORDIC vectoring reference
         xi = 256; yi = t; zi = 0;
         for (k=0; k<N; k=k+1) begin
            xsh = xi >>> k;
            ysh = yi >>> k;
            if (yi < 0) begin
               xi = xi - ysh; yi = yi + xsh; zi = zi - atant[k];
            end else begin
               xi = xi + ysh; yi = yi - xsh; zi = zi + atant[k];
            end
         end
         exp = zi;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL exact: t=%0d got %0d exp %0d", t, $signed(out), exp);
         end
         // real-valued accuracy vs true arctan
         tr_in = t / SCALE;
         tr = $atan(tr_in);
         outr = $itor($signed(out)) / SCALE;
         err = outr - tr;
         if (err < 0.0) err = -err;
         if (err > TOL) begin
            errors = errors + 1;
            $display("FAIL acc: t=%0d out=%f true=%f err=%f", t, outr, tr, err);
         end
      end
   endtask

   initial begin
      errors=0; t=0;
      // directed: 0, +/-1.0 (-> +/-pi/4), small, large
      check(0);
      check(256);       // 1.0 -> pi/4
      check(-256);
      check(64);        // 0.25
      check(2048);      // 8.0 -> ~1.446
      check(-2048);
      // random in value range [-8, 8]
      for (tc=0; tc<200; tc=tc+1)
        check(({$random} % 4097) - 2048);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_atan_smoke.vcd");
      $dumpvars(0, test_atan_smoke);
   end
`endif

endmodule
