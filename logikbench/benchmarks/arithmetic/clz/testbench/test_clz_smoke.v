//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for clz (count leading zeros, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_clz_smoke;
   localparam DW=16, OW=$clog2(DW)+1;
   reg	      clk=0;
   reg [DW-1:0]	a;
   wire [OW-1:0] out;
   integer	 t, i, errors;
   reg [OW-1:0]	 exp;
   reg		 found;

   always #5 clk=~clk;

   clz #(.DW(DW)) dut (.a(a), .out(out));

   task check;
      input [DW-1:0] av;
      begin
         @(posedge clk);
         a <= av;
         @(posedge clk); #1;
         exp = DW; found = 1'b0;
         for (i=DW-1; i>=0; i=i-1)
           if (!found && a[i]) begin exp = DW-1-i; found = 1'b1; end
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL: a=%h got %0d exp %0d", a, out, exp);
         end
      end
   endtask

   initial begin
      errors=0; a=0;
      check(16'h0000);  // -> DW
      check(16'h8000);  // -> 0
      check(16'h0001);  // -> 15
      check(16'hFFFF);  // -> 0
      check(16'h00FF);  // -> 8
      for (t=0; t<100; t=t+1) check($random);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_clz_smoke.vcd");
      $dumpvars(0, test_clz_smoke);
   end
`endif

endmodule
