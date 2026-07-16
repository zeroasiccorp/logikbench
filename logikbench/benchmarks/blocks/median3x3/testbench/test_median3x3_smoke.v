//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: median3x3 streaming filter (self-checking).
 * Streams an 8x8 salt-and-pepper image and compares each output to a software
 * median-of-9 (zero-padded border).
 * TESTED: full-frame vs reference incl. spike removal and borders; same-size
 *         streaming framing; flush.
 * NOT TESTED: only DW=8 / one image size; no backpressure.
 ******************************************************************************/
`timescale 1ns/1ps
module test_median3x3_smoke;
   localparam DW=8, W=8, H=8, AW=3, PW=7;
   reg clk=0, rst; always #5 clk=~clk;
   reg in_valid, in_sof; reg [DW-1:0] in_pix;
   wire out_valid, out_sof; wire [DW-1:0] out_pix;
   median3x3 #(.DW(DW),.IMGW(W),.IMGH(H),.AW(AW),.PW(PW)) dut
     (.clk(clk),.rst(rst),.in_valid(in_valid),.in_sof(in_sof),.in_pix(in_pix),
      .out_valid(out_valid),.out_sof(out_sof),.out_pix(out_pix));

   reg [DW-1:0] img [0:H*W-1];
   reg [DW-1:0] rcv [0:H*W-1];
   reg [DW-1:0] ref [0:H*W-1];
   reg [DW-1:0] win [0:8];
   integer i,r,c,dr,dc,n,a,b,errors,rcnt,t;
   reg [DW-1:0] tmp;

   function [DW-1:0] gp; input integer rr,cc; begin
      if (rr<0||rr>=H||cc<0||cc>=W) gp=0; else gp=img[rr*W+cc]; end
   endfunction

   always @(posedge clk)
     if (!rst && out_valid && rcnt<H*W) begin rcv[rcnt]<=out_pix; rcnt<=rcnt+1; end

   initial begin
      errors=0; in_valid=0; in_sof=0; in_pix=0; rcnt=0;
      // image with salt-and-pepper noise on a ramp
      for (i=0;i<H*W;i=i+1) img[i]=(i*5+3) & 8'hFF;
      img[9]=8'h00; img[18]=8'hFF; img[27]=8'h00; img[36]=8'hFF; img[20]=8'hFF;
      // reference median-of-9 (zero-pad), insertion sort
      for (r=0;r<H;r=r+1) for (c=0;c<W;c=c+1) begin
         n=0;
         for (dr=-1;dr<=1;dr=dr+1) for (dc=-1;dc<=1;dc=dc+1) begin
            win[n]=gp(r+dr,c+dc); n=n+1;
         end
         for (a=1;a<9;a=a+1) begin
            tmp=win[a]; b=a-1;
            while (b>=0 && win[b]>tmp) begin win[b+1]=win[b]; b=b-1; end
            win[b+1]=tmp;
         end
         ref[r*W+c]=win[4];
      end
      @(posedge clk); rst<=1; @(posedge clk); @(posedge clk); rst<=0; @(posedge clk);
      for (i=0;i<H*W;i=i+1) begin
         in_valid<=1; in_sof<=(i==0); in_pix<=img[i]; @(posedge clk);
      end
      in_valid<=0; in_sof<=0;
      t=0; while (rcnt<H*W && t<4*H*W) begin @(posedge clk); t=t+1; end
      if (rcnt<H*W) begin errors=errors+1; $display("FAIL captured %0d/%0d",rcnt,H*W); end
      else begin
         for (i=0;i<H*W;i=i+1)
           if (rcv[i]!==ref[i]) begin errors=errors+1;
              if (errors<8) $display("FAIL out[%0d] (r%0d,c%0d)=%0d exp %0d",
                                     i,i/W,i%W,rcv[i],ref[i]); end
         if (errors==0) $display("PASS [median] %0dx%0d matches reference",W,H);
      end
      $display("\n==== errors=%0d ====",errors);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #100000; $display("FAILED (timeout)"); $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_median3x3_smoke.vcd");
      $dumpvars(0, test_median3x3_smoke);
   end
`endif

endmodule
