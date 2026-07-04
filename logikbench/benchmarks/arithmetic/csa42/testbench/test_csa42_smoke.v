//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for csa42 (4:2 carry-save compressor, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_csa42_smoke;
   localparam DW=8;
   reg	      clk=0; reg [DW-1:0] in0,in1,in2,in3; reg cin;
   wire cout; wire [DW-1:0] s,c;
   always #5 clk=~clk;
   csa42 #(.DW(DW)) dut (.in0(in0),.in1(in1),.in2(in2),.in3(in3),.cin(cin),
                         .cout(cout),.s(s),.c(c));
   integer t,errors,ti,to;
   task chk; input [DW-1:0] a0,a1,a2,a3; input ci; begin
      @(posedge clk); in0<=a0; in1<=a1; in2<=a2; in3<=a3; cin<=ci;
      @(posedge clk); #1;
      ti = a0 + a1 + a2 + a3 + ci;
      to = s + (c<<1) + (cout<<DW);
      if(to!==ti) begin errors=errors+1;
         $display("FAIL in=%h,%h,%h,%h cin=%b: in_sum=%0d out_sum=%0d",
                  a0,a1,a2,a3,ci,ti,to); end
   end endtask
   initial begin errors=0; in0=0;in1=0;in2=0;in3=0;cin=0;
      chk(8'hff,8'hff,8'hff,8'hff,1'b1); chk(8'h00,8'h00,8'h00,8'h00,1'b0);
      for(t=0;t<30;t=t+1) chk($random,$random,$random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
