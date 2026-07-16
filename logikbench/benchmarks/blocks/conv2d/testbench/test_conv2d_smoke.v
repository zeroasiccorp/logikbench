//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: conv2d programmable 3x3 convolution (self-checking).
 * Loads identity and box-blur kernels, streams an 8x8 image, and compares each
 * output to a software 2D conv (zero-pad, round-half-up, saturate).
 * TESTED: identity + blur kernels, full frame vs reference, same-size framing.
 * NOT TESTED: only DW=CW=8 / one image size; two kernels; no backpressure.
 ******************************************************************************/
`timescale 1ns/1ps
module test_conv2d_smoke;
   localparam DW=8, CW=8, W=8, H=8, AW=3, PW=7, FRAC=CW-1;
   reg clk=0, rst; always #5 clk=~clk;
   reg in_valid, in_sof; reg [DW-1:0] in_pix; reg [9*CW-1:0] coeff;
   wire out_valid, out_sof; wire [DW-1:0] out_pix;
   conv2d #(.DW(DW),.CW(CW),.IMGW(W),.IMGH(H),.AW(AW),.PW(PW)) dut
     (.clk(clk),.rst(rst),.in_valid(in_valid),.in_sof(in_sof),.in_pix(in_pix),
      .coeff(coeff),.out_valid(out_valid),.out_sof(out_sof),.out_pix(out_pix));

   reg [DW-1:0] img [0:H*W-1];
   reg [DW-1:0] rcv [0:H*W-1];
   reg [DW-1:0] ref [0:H*W-1];
   reg signed [CW-1:0] kk [0:8];
   integer i,r,c,dr,dc,n,errors,rcnt,t,acc,racc,sacc;

   function [DW-1:0] gp; input integer rr,cc; begin
      if (rr<0||rr>=H||cc<0||cc>=W) gp=0; else gp=img[rr*W+cc]; end
   endfunction

   always @(posedge clk)
     if (!rst && out_valid && rcnt<H*W) begin rcv[rcnt]<=out_pix; rcnt<=rcnt+1; end

   task run; input [8*8-1:0] tag;
      begin
         for (i=0;i<9;i=i+1) coeff[i*CW +: CW] = kk[i];
         for (r=0;r<H;r=r+1) for (c=0;c<W;c=c+1) begin
            acc=0; n=0;
            for (dr=-1;dr<=1;dr=dr+1) for (dc=-1;dc<=1;dc=dc+1) begin
               acc = acc + gp(r+dr,c+dc) * kk[n]; n=n+1;
            end
            racc = acc + (1<<(FRAC-1)); sacc = racc >>> FRAC;
            if (sacc<0) sacc=0; if (sacc>255) sacc=255;
            ref[r*W+c]=sacc;
         end
         rcnt=0;
         @(posedge clk); rst<=1; @(posedge clk); @(posedge clk); rst<=0; @(posedge clk);
         for (i=0;i<H*W;i=i+1) begin
            in_valid<=1; in_sof<=(i==0); in_pix<=img[i]; @(posedge clk);
         end
         in_valid<=0; in_sof<=0;
         t=0; while (rcnt<H*W && t<4*H*W) begin @(posedge clk); t=t+1; end
         if (rcnt<H*W) begin errors=errors+1; $display("FAIL [%0s] cap %0d",tag,rcnt); end
         else begin
            for (i=0;i<H*W;i=i+1)
              if (rcv[i]!==ref[i]) begin errors=errors+1;
                 if (errors<6) $display("FAIL [%0s] o[%0d]=%0d exp %0d",tag,i,rcv[i],ref[i]); end
            if (errors==0) $display("PASS [%0s] matches reference",tag);
         end
      end
   endtask

   initial begin
      errors=0; in_valid=0; in_sof=0; in_pix=0; coeff=0; rcnt=0;
      for (i=0;i<H*W;i=i+1) img[i]=(i*9+5) & 8'hFF;
      @(posedge clk);
      // identity kernel (center ~1.0 = 127 in Q1.7)
      for (i=0;i<9;i=i+1) kk[i]=0; kk[4]=8'sd127;
      run("identity");
      // 3x3 box blur (all 14 ~ 1/9 in Q1.7)
      for (i=0;i<9;i=i+1) kk[i]=8'sd14;
      run("blur");
      $display("\n==== errors=%0d ====",errors);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #200000; $display("FAILED (timeout)"); $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_conv2d_smoke.vcd");
      $dumpvars(0, test_conv2d_smoke);
   end
`endif

endmodule
