//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for maxn (N-input maximum, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_maxn_smoke;
   localparam N=8, DW=8;
   reg	      clk=0;
   reg [N*DW-1:0] a;
   wire [DW-1:0]  out;
   integer	  t, i, errors;
   reg [DW-1:0]	  exp, el;

   always #5 clk=~clk;

   maxn #(.N(N), .DW(DW)) dut (.a(a), .out(out));

   task check;
      begin
         @(posedge clk);
         for (i=0; i<N; i=i+1) a[i*DW +: DW] <= $random;
         @(posedge clk); #1;
         exp = a[0 +: DW];
         for (i=1; i<N; i=i+1) begin
            el = a[i*DW +: DW];
            if (el > exp) exp = el;
         end
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL: got %0d exp %0d", out, exp);
         end
      end
   endtask

   initial begin
      errors=0; a=0;
      for (t=0; t<100; t=t+1) check;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
