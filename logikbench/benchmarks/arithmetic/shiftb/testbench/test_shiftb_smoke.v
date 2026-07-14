//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for shiftb (barrel shifter, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_shiftb_smoke;
   localparam DW=8, SW=$clog2(DW);
   reg	      clk=0; reg [DW-1:0] a; reg [SW-1:0] b; reg dir,arith;
   wire [DW-1:0] out;
   always #5 clk=~clk;
   shiftb #(.DW(DW)) dut (.a(a),.b(b),.dir(dir),.arith(arith),.out(out));
   integer t,errors; reg signed [DW-1:0] sa; reg [DW-1:0] exp;
   task chk; input [DW-1:0] av; input [SW-1:0] bv; input dv,arv; begin
      @(posedge clk); a<=av; b<=bv; dir<=dv; arith<=arv;
      @(posedge clk); #1;
      sa=av;
      if (dv==1'b0) exp = av << bv;
      else if (arv) exp = sa >>> bv;
      else exp = av >> bv;
      if(out!==exp) begin errors=errors+1;
         $display("FAIL a=%h b=%0d dir=%b ar=%b: got %h exp %h",
                  av,bv,dv,arv,out,exp); end
   end endtask
   initial begin errors=0; a=0; b=0; dir=0; arith=0;
      chk(8'h81,3'd1,1'b0,1'b0); chk(8'h80,3'd1,1'b1,1'b1);
      chk(8'h80,3'd1,1'b1,1'b0);
      for(t=0;t<40;t=t+1) chk($random,$random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_shiftb_smoke.vcd");
      $dumpvars(0, test_shiftb_smoke);
   end
`endif

endmodule
