//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: sad8x8 block matcher (self-checking).
 * Applies block pairs and checks the SAD against a software reference.
 * TESTED: identical blocks (0), constant offset, max (16320), random vs ref.
 * NOT TESTED: only N=8/PW=8; single-cycle latency only.
 ******************************************************************************/
`timescale 1ns/1ps
module test_sad8x8_smoke;
   localparam N=8, PW=8, NP=N*N, SADW=14;
   reg clk=0, rst; always #5 clk=~clk;
   reg valid_in; reg [NP*PW-1:0] curblk, refblk;
   wire valid_out; wire [SADW-1:0] sad;
   sad8x8 #(.N(N),.PW(PW)) dut(.clk(clk),.rst(rst),.valid_in(valid_in),
       .curblk(curblk),.refblk(refblk),.valid_out(valid_out),.sad(sad));

   integer i,errors,exp,d; reg [PW-1:0] ca[0:NP-1], rb[0:NP-1];
   reg [31:0] lf;

   task apply; input [8*8-1:0] tag; integer j;
      begin
         exp=0;
         for (j=0;j<NP;j=j+1) begin
            curblk[j*PW +: PW]=ca[j]; refblk[j*PW +: PW]=rb[j];
            d = ca[j]-rb[j]; if (d<0) d=-d; exp=exp+d;
         end
         valid_in<=1; @(posedge clk); valid_in<=0; @(posedge clk);
         if (!valid_out) begin errors=errors+1; $display("FAIL [%0s] no valid",tag); end
         else if (sad!==exp[SADW-1:0]) begin errors=errors+1;
            $display("FAIL [%0s] sad=%0d exp=%0d",tag,sad,exp); end
         else $display("PASS [%0s] sad=%0d",tag,sad);
      end
   endtask

   initial begin
      errors=0; valid_in=0; curblk=0; refblk=0; lf=32'hF00DBEEF;
      @(posedge clk); rst<=1; @(posedge clk); @(posedge clk); rst<=0; @(posedge clk);
      // identical -> 0
      for (i=0;i<NP;i=i+1) begin ca[i]=i; rb[i]=i; end
      apply("ident");
      // constant offset +5 -> 64*5=320 (no clamp, all <250)
      for (i=0;i<NP;i=i+1) begin ca[i]=100; rb[i]=95; end
      apply("offset5");
      // max -> 64*255 = 16320
      for (i=0;i<NP;i=i+1) begin ca[i]=255; rb[i]=0; end
      apply("max");
      // random vs reference
      for (i=0;i<NP;i=i+1) begin
         lf={lf[30:0],lf[31]^lf[21]^lf[1]^lf[0]}; ca[i]=lf[7:0];
         lf={lf[30:0],lf[31]^lf[21]^lf[1]^lf[0]}; rb[i]=lf[7:0];
      end
      apply("rand");
      $display("\n==== errors=%0d ====",errors);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #50000; $display("FAILED timeout"); $finish; end
endmodule
