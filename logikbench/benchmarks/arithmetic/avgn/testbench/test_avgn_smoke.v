//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for avgn (N-input average, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_avgn_smoke;
   localparam N=8, DW=8;
   reg	      clk=0;
   reg [N*DW-1:0] a;
   wire [DW-1:0]  out;
   integer	  t, i, errors;
   integer	  acc, exp;

   always #5 clk=~clk;

   avgn #(.N(N), .DW(DW)) dut (.a(a), .out(out));

   task check;
      begin
         @(posedge clk);
         for (i=0; i<N; i=i+1) a[i*DW +: DW] <= $random;
         @(posedge clk); #1;
         acc = 0;
         for (i=0; i<N; i=i+1) acc = acc + a[i*DW +: DW];
         exp = acc / N;
         if (out !== exp[DW-1:0]) begin
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

`ifdef WAVES
   initial begin
      $dumpfile("test_avgn_smoke.vcd");
      $dumpvars(0, test_avgn_smoke);
   end
`endif

endmodule
