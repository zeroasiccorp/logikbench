//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for cos (CORDIC rotation-mode cosine, self-checking).
// Checks the exact integer CORDIC recurrence and the real-valued accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_cos_smoke;
   localparam DW=16, QW=8, N=12;
   localparam ZMAX = 402;               // pi/2 in Q8.8
   localparam real SCALE = 256.0;
   localparam real TOL   = 0.03;        // Q8.8 CORDIC accuracy (~2-3%)

   reg		   clk=0;
   reg signed [DW-1:0] z;
   wire signed [DW-1:0]	out;
   integer		t, errors, k;
   integer		xi, yi, zi, xsh, ysh, exp;
   integer		atant [0:N-1];
   real			zr, tr, outr, err;

   always #5 clk=~clk;

   cos #(.DW(DW), .QW(QW), .N(N)) dut (.z(z), .out(out));

   initial begin
      atant[0]=201; atant[1]=119; atant[2]=63; atant[3]=32;
      atant[4]=16;  atant[5]=8;   atant[6]=4;  atant[7]=2;
      atant[8]=1;   atant[9]=0;   atant[10]=0; atant[11]=0;
   end

   task check;
      input signed [DW-1:0] zv;
      begin
         @(posedge clk);
         z <= zv;
         @(posedge clk); #1;
         // exact integer CORDIC reference
         xi = 155; yi = 0; zi = z;
         for (k=0; k<N; k=k+1) begin
            xsh = xi >>> k;
            ysh = yi >>> k;
            if (zi >= 0) begin
               xi = xi - ysh; yi = yi + xsh; zi = zi - atant[k];
            end else begin
               xi = xi + ysh; yi = yi - xsh; zi = zi + atant[k];
            end
         end
         exp = xi;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL exact: z=%0d got %0d exp %0d", z, $signed(out), exp);
         end
         // real-valued accuracy vs true cosine
         zr = z / SCALE;
         tr = $cos(zr);
         outr = $itor($signed(out)) / SCALE;
         err = outr - tr;
         if (err < 0.0) err = -err;
         if (err > TOL) begin
            errors = errors + 1;
            $display("FAIL acc: z=%0d out=%f true=%f err=%f", z, outr, tr, err);
         end
      end
   endtask

   initial begin
      errors=0; z=0;
      // directed: 0, +/-pi/2, +/-pi/4-ish, +/-1.0 rad
      check(0);
      check(ZMAX);      // ~pi/2 -> ~0
      check(-ZMAX);
      check(201);       // ~pi/4
      check(-201);
      check(256);       // 1.0 rad
      // random in [-pi/2, pi/2]
      for (t=0; t<200; t=t+1)
        check(({$random} % (2*ZMAX+1)) - ZMAX);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
