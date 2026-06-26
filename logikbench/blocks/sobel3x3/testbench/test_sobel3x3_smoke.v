/******************************************************************************
 * Testbench: sobel3x3 streaming edge detector (self-checking).
 * Streams an 8x8 image and compares each output pixel to a software Sobel
 * (zero-padded border, L1 magnitude |Gx|+|Gy|, saturated to 8 bits).
 * TESTED: full-frame interior+border vs reference; same-size streaming with
 *         in_sof/out_sof framing; flush of the bottom border row.
 * NOT TESTED: only DW=8 and one image size; L1 (not L2) metric; no backpressure.
 ******************************************************************************/
`timescale 1ns/1ps
module test_sobel3x3_smoke;
   localparam DW=8, W=8, H=8, AW=3, PW=7;
   reg clk=0, rst; always #5 clk=~clk;
   reg in_valid, in_sof; reg [DW-1:0] in_pix;
   wire out_valid, out_sof; wire [DW-1:0] out_pix;
   sobel3x3 #(.DW(DW),.IMGW(W),.IMGH(H),.AW(AW),.PW(PW)) dut
     (.clk(clk),.rst(rst),.in_valid(in_valid),.in_sof(in_sof),.in_pix(in_pix),
      .out_valid(out_valid),.out_sof(out_sof),.out_pix(out_pix));

   reg [DW-1:0] img [0:H*W-1];
   reg [DW-1:0] rcv [0:H*W-1];
   reg [DW-1:0] ref [0:H*W-1];
   integer i,r,c,dr,dc,rr,cc,errors,rcnt,t;
   integer gx,gy,mag,px;

   function [DW-1:0] gp; input integer rr,cc; begin
      if (rr<0||rr>=H||cc<0||cc>=W) gp=0; else gp=img[rr*W+cc]; end
   endfunction

   always @(posedge clk)
     if (!rst && out_valid && rcnt<H*W) begin rcv[rcnt]<=out_pix; rcnt<=rcnt+1; end

   initial begin
      errors=0; in_valid=0; in_sof=0; in_pix=0; rcnt=0;
      // image: left half dark, right half bright + a ramp
      for (r=0;r<H;r=r+1) for (c=0;c<W;c=c+1)
        img[r*W+c] = (c<W/2) ? (c*3) : (200 + c);
      // reference sobel (zero-pad, |Gx|+|Gy| saturated)
      for (r=0;r<H;r=r+1) for (c=0;c<W;c=c+1) begin
         gx = gp(r-1,c+1)+2*gp(r,c+1)+gp(r+1,c+1)
             -gp(r-1,c-1)-2*gp(r,c-1)-gp(r+1,c-1);
         gy = gp(r+1,c-1)+2*gp(r+1,c)+gp(r+1,c+1)
             -gp(r-1,c-1)-2*gp(r-1,c)-gp(r-1,c+1);
         if (gx<0) gx=-gx; if (gy<0) gy=-gy;
         mag=gx+gy; if (mag>255) mag=255;
         ref[r*W+c]=mag;
      end
      @(posedge clk); rst<=1; @(posedge clk); @(posedge clk); rst<=0; @(posedge clk);
      // stream the frame
      for (i=0;i<H*W;i=i+1) begin
         in_valid<=1; in_sof<=(i==0); in_pix<=img[i]; @(posedge clk);
      end
      in_valid<=0; in_sof<=0;
      // drain
      t=0; while (rcnt<H*W && t<4*H*W) begin @(posedge clk); t=t+1; end
      if (rcnt<H*W) begin errors=errors+1; $display("FAIL captured %0d/%0d",rcnt,H*W); end
      else begin
         for (i=0;i<H*W;i=i+1)
           if (rcv[i]!==ref[i]) begin errors=errors+1;
              if (errors<8) $display("FAIL out[%0d] (r%0d,c%0d)=%0d exp %0d",
                                     i,i/W,i%W,rcv[i],ref[i]); end
         if (errors==0) $display("PASS [sobel] %0dx%0d matches reference",W,H);
      end
      $display("\n==== errors=%0d ====",errors);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #100000; $display("FAILED (timeout)"); $finish; end
endmodule
