//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for rotr (barrel rotate right, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_rotr_smoke;
   localparam DW=16, BW=$clog2(DW);
   reg	      clk=0;
   reg [DW-1:0]	a;
   reg [BW-1:0]	b;
   wire [DW-1:0] out;
   integer	 t, errors;
   reg [DW-1:0]	 exp;

   always #5 clk=~clk;

   rotr #(.DW(DW)) dut (.a(a), .b(b), .out(out));

   task check;
      input [DW-1:0] av;
      input [BW-1:0] bv;
      begin
         @(posedge clk);
         a <= av; b <= bv;
         @(posedge clk); #1;
         // independent reference: rotate via a doubled word
         exp = ({a, a} >> b) & {DW{1'b1}};
         if (out !== exp) begin
            errors = errors + 1;
            $display("FAIL: a=%h b=%0d got %h exp %h", a, b, out, exp);
         end
      end
   endtask

   integer va;
   initial begin
      errors=0; a=0; b=0;
      check(16'h8001, 0);
      check(16'h8001, 1);
      check(16'h0001, 15);
      check(16'hACE1, 4);
      check(16'hFFFF, 7);
      for (t=0; t<100; t=t+1) begin
         va = $random;
         check(va[DW-1:0], t[BW-1:0]);
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_rotr_smoke.vcd");
      $dumpvars(0, test_rotr_smoke);
   end
`endif

endmodule
