//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for simdmul (packed SIMD multiply, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_simdmul_smoke;
   localparam DW=4, N=2;
   reg	      clk=0;
   reg [N*DW-1:0] a, b;
   wire [N*2*DW-1:0] out;
   integer	     t, i, errors;
   integer	     sa, sb, exp, got;

   always #5 clk=~clk;

   simdmul #(.DW(DW), .N(N)) dut (.a(a), .b(b), .out(out));

   task chk;
      begin
         @(posedge clk);
         a <= $random;
         b <= $random;
         @(posedge clk); #1;
         for (i=0; i<N; i=i+1) begin
            sa  = $signed(a[i*DW +: DW]);
            sb  = $signed(b[i*DW +: DW]);
            exp = sa * sb;
            got = $signed(out[i*2*DW +: 2*DW]);
            if (got !== exp) begin
               errors = errors + 1;
               $display("FAIL lane %0d: a=%0d b=%0d got %0d exp %0d",
                        i, sa, sb, got, exp);
            end
         end
      end
   endtask

   initial begin
      errors=0; a=0; b=0;
      for (t=0; t<50; t=t+1) chk;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
