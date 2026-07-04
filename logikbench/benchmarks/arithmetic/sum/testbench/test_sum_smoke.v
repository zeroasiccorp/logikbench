//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for sum (vector sum, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_sum_smoke;
   localparam N=4, DW=4, OW=DW+$clog2(N);
   reg	      clk=0; reg [N*DW-1:0] a,b; wire [OW-1:0] out;
   always #5 clk=~clk;
   sum #(.N(N),.DW(DW)) dut (.a(a),.b(b),.out(out));
   integer t,i,errors; reg [63:0] acc; reg [OW-1:0] exp;
   task chk; begin
      @(posedge clk);
      for (i=0;i<N;i=i+1) a[i*DW+:DW]<=$random;
      @(posedge clk); #1;
      acc=0; for(i=0;i<N;i=i+1) acc = acc + a[i*DW+:DW];
      exp = acc[OW-1:0];
      if(out!==exp) begin errors=errors+1;
         $display("FAIL: got %h exp %h",out,exp); end
   end endtask
   initial begin errors=0; a=0; b=0;
      for(t=0;t<40;t=t+1) chk;
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
