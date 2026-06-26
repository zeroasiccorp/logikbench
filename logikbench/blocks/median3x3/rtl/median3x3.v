//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Median 3x3 filter (streaming, same-size, zero-padded border).
//
// Common pixel-stream interface (shared by sobel3x3 / median3x3 / conv2d so the
// filters cascade directly): one 8-bit pixel/cycle in raster order, in_sof
// pulses on the first pixel of a frame; out_valid/out_pix/out_sof carry the
// filtered stream in the SAME framing (one output pixel per input pixel,
// IMGH*IMGW per frame), so a filter's output is a valid input to the next.
//
// Two line buffers (shift registers, depth IMGW) + 3 column shift registers
// form the 3x3 window centered on the output pixel; out-of-frame neighbors are
// zero (zero-pad), keeping the image the same size through the pipeline.
// The 3x3 window feeds an odd-even transposition sorting network (36 compare-
// swaps); the median (middle lane) is the output. Compares only -- no DSP.
//
//#############################################################################

module median3x3
  #(parameter DW = 8,
    parameter IMGW = 64,
    parameter IMGH = 64,
    parameter AW = 7,  // clog2(IMGW)
    parameter PW = 13) // clog2(IMGW*IMGH)
   (
    input		clk,
    input		rst,
    input		in_valid,
    input		in_sof,
    input [DW-1:0]	in_pix,
    output reg		out_valid,
    output reg		out_sof,
    output reg [DW-1:0]	out_pix
    );

   localparam [PW-1:0] TOTAL = IMGW*IMGH;

   // ---- line buffers (row delays) and column shift registers ----
   reg [DW-1:0]	       lb1 [0:IMGW-1];   // row r-1 delay
   reg [DW-1:0]	       lb2 [0:IMGW-1];   // row r-2 delay
   reg [DW-1:0]	       t0,t1,t2;         // top row window cols (oc-1,oc,oc+1)
   reg [DW-1:0]	       m0,m1,m2;         // mid row window cols
   reg [DW-1:0]	       b0,b1,b2;         // bot row window cols

   reg [PW-1:0]	       incnt;            // input pixels seen this frame
   reg [PW-1:0]	       ocnt;             // outputs produced this frame
   reg [AW-1:0]	       orow_c;           // output column (for border gating)
   reg [PW-1:0]	       orow_r;           // output row
   reg		       started, indone;

   wire		       flush = indone && (ocnt < TOTAL);
   wire		       adv   = (in_valid && !indone) || flush;
   wire [DW-1:0]       botin = (in_valid && !indone) ? in_pix : {DW{1'b0}};

   // ---- border-gated 3x3 window (zero-pad out-of-frame) ----
   wire		       l_ok = (orow_c != 0);          // has left neighbor
   wire		       r_ok = (orow_c != IMGW-1);     // has right neighbor
   wire		       u_ok = (orow_r != 0);          // has top neighbor
   wire		       d_ok = (orow_r != IMGH-1);     // has bottom neighbor
   wire [DW-1:0]       p00 = (u_ok&&l_ok)?t0:0, p01=u_ok?t1:0, p02=(u_ok&&r_ok)?t2:0;
   wire [DW-1:0]       p10 = l_ok?m0:0,         p11=m1,        p12=r_ok?m2:0;
   wire [DW-1:0]       p20 = (d_ok&&l_ok)?b0:0, p21=d_ok?b1:0, p22=(d_ok&&r_ok)?b2:0;

   // 3x3 window aliases (raster: p0..p8 = p00..p22)
   wire [DW-1:0]       p0=p00, p1=p01, p2=p02, p3=p10, p4=p11, p5=p12,
                       p6=p20, p7=p21, p8=p22;
   // median-of-9 via odd-even transposition network (36 compare-swaps)
   wire [DW-1:0]       c0_lo=(p0<p1)?p0:p1, c0_hi=(p0<p1)?p1:p0;
   wire [DW-1:0]       c1_lo=(p2<p3)?p2:p3, c1_hi=(p2<p3)?p3:p2;
   wire [DW-1:0]       c2_lo=(p4<p5)?p4:p5, c2_hi=(p4<p5)?p5:p4;
   wire [DW-1:0]       c3_lo=(p6<p7)?p6:p7, c3_hi=(p6<p7)?p7:p6;
   wire [DW-1:0]       c4_lo=(c0_hi<c1_lo)?c0_hi:c1_lo, c4_hi=(c0_hi<c1_lo)?c1_lo:c0_hi;
   wire [DW-1:0]       c5_lo=(c1_hi<c2_lo)?c1_hi:c2_lo, c5_hi=(c1_hi<c2_lo)?c2_lo:c1_hi;
   wire [DW-1:0]       c6_lo=(c2_hi<c3_lo)?c2_hi:c3_lo, c6_hi=(c2_hi<c3_lo)?c3_lo:c2_hi;
   wire [DW-1:0]       c7_lo=(c3_hi<p8)?c3_hi:p8, c7_hi=(c3_hi<p8)?p8:c3_hi;
   wire [DW-1:0]       c8_lo=(c0_lo<c4_lo)?c0_lo:c4_lo, c8_hi=(c0_lo<c4_lo)?c4_lo:c0_lo;
   wire [DW-1:0]       c9_lo=(c4_hi<c5_lo)?c4_hi:c5_lo, c9_hi=(c4_hi<c5_lo)?c5_lo:c4_hi;
   wire [DW-1:0]       c10_lo=(c5_hi<c6_lo)?c5_hi:c6_lo, c10_hi=(c5_hi<c6_lo)?c6_lo:c5_hi;
   wire [DW-1:0]       c11_lo=(c6_hi<c7_lo)?c6_hi:c7_lo, c11_hi=(c6_hi<c7_lo)?c7_lo:c6_hi;
   wire [DW-1:0]       c12_lo=(c8_hi<c9_lo)?c8_hi:c9_lo, c12_hi=(c8_hi<c9_lo)?c9_lo:c8_hi;
   wire [DW-1:0]       c13_lo=(c9_hi<c10_lo)?c9_hi:c10_lo, c13_hi=(c9_hi<c10_lo)?c10_lo:c9_hi;
   wire [DW-1:0]       c14_lo=(c10_hi<c11_lo)?c10_hi:c11_lo, c14_hi=(c10_hi<c11_lo)?c11_lo:c10_hi;
   wire [DW-1:0]       c15_lo=(c11_hi<c7_hi)?c11_hi:c7_hi, c15_hi=(c11_hi<c7_hi)?c7_hi:c11_hi;
   wire [DW-1:0]       c16_lo=(c8_lo<c12_lo)?c8_lo:c12_lo, c16_hi=(c8_lo<c12_lo)?c12_lo:c8_lo;
   wire [DW-1:0]       c17_lo=(c12_hi<c13_lo)?c12_hi:c13_lo, c17_hi=(c12_hi<c13_lo)?c13_lo:c12_hi;
   wire [DW-1:0]       c18_lo=(c13_hi<c14_lo)?c13_hi:c14_lo, c18_hi=(c13_hi<c14_lo)?c14_lo:c13_hi;
   wire [DW-1:0]       c19_lo=(c14_hi<c15_lo)?c14_hi:c15_lo, c19_hi=(c14_hi<c15_lo)?c15_lo:c14_hi;
   wire [DW-1:0]       c20_lo=(c16_hi<c17_lo)?c16_hi:c17_lo, c20_hi=(c16_hi<c17_lo)?c17_lo:c16_hi;
   wire [DW-1:0]       c21_lo=(c17_hi<c18_lo)?c17_hi:c18_lo, c21_hi=(c17_hi<c18_lo)?c18_lo:c17_hi;
   wire [DW-1:0]       c22_lo=(c18_hi<c19_lo)?c18_hi:c19_lo, c22_hi=(c18_hi<c19_lo)?c19_lo:c18_hi;
   wire [DW-1:0]       c23_lo=(c19_hi<c15_hi)?c19_hi:c15_hi, c23_hi=(c19_hi<c15_hi)?c15_hi:c19_hi;
   wire [DW-1:0]       c24_lo=(c16_lo<c20_lo)?c16_lo:c20_lo, c24_hi=(c16_lo<c20_lo)?c20_lo:c16_lo;
   wire [DW-1:0]       c25_lo=(c20_hi<c21_lo)?c20_hi:c21_lo, c25_hi=(c20_hi<c21_lo)?c21_lo:c20_hi;
   wire [DW-1:0]       c26_lo=(c21_hi<c22_lo)?c21_hi:c22_lo, c26_hi=(c21_hi<c22_lo)?c22_lo:c21_hi;
   wire [DW-1:0]       c27_lo=(c22_hi<c23_lo)?c22_hi:c23_lo, c27_hi=(c22_hi<c23_lo)?c23_lo:c22_hi;
   wire [DW-1:0]       c28_lo=(c24_hi<c25_lo)?c24_hi:c25_lo, c28_hi=(c24_hi<c25_lo)?c25_lo:c24_hi;
   wire [DW-1:0]       c29_lo=(c25_hi<c26_lo)?c25_hi:c26_lo, c29_hi=(c25_hi<c26_lo)?c26_lo:c25_hi;
   wire [DW-1:0]       c30_lo=(c26_hi<c27_lo)?c26_hi:c27_lo, c30_hi=(c26_hi<c27_lo)?c27_lo:c26_hi;
   wire [DW-1:0]       c31_lo=(c27_hi<c23_hi)?c27_hi:c23_hi, c31_hi=(c27_hi<c23_hi)?c23_hi:c27_hi;
   wire [DW-1:0]       c32_lo=(c24_lo<c28_lo)?c24_lo:c28_lo, c32_hi=(c24_lo<c28_lo)?c28_lo:c24_lo;
   wire [DW-1:0]       c33_lo=(c28_hi<c29_lo)?c28_hi:c29_lo, c33_hi=(c28_hi<c29_lo)?c29_lo:c28_hi;
   wire [DW-1:0]       c34_lo=(c29_hi<c30_lo)?c29_hi:c30_lo, c34_hi=(c29_hi<c30_lo)?c30_lo:c29_hi;
   wire [DW-1:0]       c35_lo=(c30_hi<c31_lo)?c30_hi:c31_lo, c35_hi=(c30_hi<c31_lo)?c31_lo:c30_hi;
   wire [DW-1:0]       mag = c34_lo;  // median (middle lane)


   integer	       k;
   always @(posedge clk) begin
      if (rst) begin
         incnt<=0; ocnt<=0; orow_c<=0; orow_r<=0; started<=0; indone<=0;
         out_valid<=0; out_sof<=0; out_pix<={DW{1'b0}};
      end else begin
         out_valid<=0; out_sof<=0;
         if (in_sof) begin
            incnt<=0; ocnt<=0; orow_c<=0; orow_r<=0; started<=0; indone<=0;
         end
         if (adv) begin
            // shift line buffers (lb1 fed by new bottom pixel, lb2 by lb1 out)
            lb2[0] <= lb1[IMGW-1];
            for (k=1;k<IMGW;k=k+1) lb2[k] <= lb2[k-1];
            lb1[0] <= botin;
            for (k=1;k<IMGW;k=k+1) lb1[k] <= lb1[k-1];
            // column windows: newest at *2
            t2<=lb2[IMGW-1]; t1<=t2; t0<=t1;
            m2<=lb1[IMGW-1]; m1<=m2; m0<=m1;
            b2<=botin;       b1<=b2; b0<=b1;
            // input bookkeeping
            if (in_valid && !indone) begin
               if (incnt == TOTAL-1) indone<=1;
               incnt <= incnt + 1'b1;
            end
            // the centered window for output (0,0) is ready once IMGW+2 pixels
            // have entered (1 full row + 2 columns of fill)
            if (!started && (incnt >= IMGW+2)) started<=1;
            if ((started || (incnt >= IMGW+2)) && (ocnt < TOTAL)) begin
               out_valid <= 1'b1;
               out_sof   <= (ocnt == 0);
               out_pix   <= mag;
               ocnt <= ocnt + 1'b1;
               if (orow_c == IMGW-1) begin orow_c<=0; orow_r<=orow_r+1'b1; end
               else orow_c <= orow_c + 1'b1;
            end
         end
      end
   end

endmodule
