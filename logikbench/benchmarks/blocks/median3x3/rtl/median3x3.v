//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
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
// Two line buffers are lambdalib la_spram (BRAM): each is a depth-IMGW row
// delay used read-first (write the current pixel at column c while reading the
// previous row's pixel at c). They are chained (lb2 fed by lb1's read) with a
// 2-stage alignment pipeline to absorb the 1-cycle synchronous-read latency, so
// the three window rows line up. A 3-column shift register forms the 3x3 window
// centered on the output pixel; out-of-frame neighbors are zero (zero-pad),
// keeping the image the same size through the pipeline. Sobel Gx/Gy use the
// constant +-1/+-2 kernel (shifts/adds, no DSP); the output is the saturated L1
// magnitude |Gx|+|Gy|.
//
//#############################################################################

module median3x3
  #(parameter DW = 8,
    parameter IMGW = 512,
    parameter IMGH = 512,
    parameter AW = 9,  // clog2(IMGW)
    parameter PW = 19) // clog2(IMGW*IMGH)
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

   reg [PW-1:0]	       incnt;            // input pixels seen this frame
   reg [PW-1:0]	       ocnt;             // outputs produced this frame
   reg [PW-1:0]	       wvcnt;            // aligned window-columns seen
   reg [AW-1:0]	       orow_c;           // output column (border gating)
   reg [PW-1:0]	       orow_r;           // output row
   reg		       started, indone;

   wire		       flush = indone && (ocnt < TOTAL);
   wire		       adv   = (in_valid && !indone) || flush;
   wire [DW-1:0]       botin = (in_valid && !indone) ? in_pix : {DW{1'b0}};

   // ---- la_spram line buffers (chained, read-first) + alignment pipeline ----
   reg [AW-1:0]	       caddr;           // lb1 column address
   reg [AW-1:0]	       caddr_q;         // lb2 column address (1-stage delayed)
   reg		       adv_d, adv_d2;
   reg [DW-1:0]	       botd1, botd2;    // bottom row aligned (in_pix delayed)
   reg [DW-1:0]	       midq;            // mid row aligned (lb1 read delayed)
   wire [DW-1:0]       lb1q, lb2q;

   la_spram #(.DW(DW), .AW(AW), .BYTEMASK(0)) u_lb1
     (.clk(clk), .ce(adv),   .we(adv),   .wmask({DW{1'b1}}), .addr(caddr),
      .din(botin), .dout(lb1q), .selctrl(1'b0), .ctrl('b0), .status());
   la_spram #(.DW(DW), .AW(AW), .BYTEMASK(0)) u_lb2
     (.clk(clk), .ce(adv_d), .we(adv_d), .wmask({DW{1'b1}}), .addr(caddr_q),
      .din(lb1q),  .dout(lb2q), .selctrl(1'b0), .ctrl('b0), .status());

   wire         wvalid = adv_d2;        // aligned window-column valid
   wire [DW-1:0] rtop = lb2q;           // row r-2
   wire [DW-1:0] rmid = midq;           // row r-1
   wire [DW-1:0] rbot = botd2;          // row r

   // 3-column window shift registers (newest at *2)
   reg [DW-1:0]	 t0,t1,t2, m0,m1,m2, b0,b1,b2;

   // ---- border-gated 3x3 window (zero-pad out-of-frame) ----
   wire		 l_ok = (orow_c != 0);
   wire		 r_ok = (orow_c != IMGW-1);
   wire		 u_ok = (orow_r != 0);
   wire		 d_ok = (orow_r != IMGH-1);
   wire [DW-1:0] p00=(u_ok&&l_ok)?t0:0, p01=u_ok?t1:0, p02=(u_ok&&r_ok)?t2:0;
   wire [DW-1:0] p10=l_ok?m0:0,         p11=m1,        p12=r_ok?m2:0;
   wire [DW-1:0] p20=(d_ok&&l_ok)?b0:0, p21=d_ok?b1:0, p22=(d_ok&&r_ok)?b2:0;

   // 3x3 window aliases (raster: p0..p8 = p00..p22)
   wire [DW-1:0] p0=p00, p1=p01, p2=p02, p3=p10, p4=p11, p5=p12,
                 p6=p20, p7=p21, p8=p22;
   // median-of-9 via odd-even transposition network (36 compare-swaps)
   wire [DW-1:0] c0_lo=(p0<p1)?p0:p1, c0_hi=(p0<p1)?p1:p0;
   wire [DW-1:0] c1_lo=(p2<p3)?p2:p3, c1_hi=(p2<p3)?p3:p2;
   wire [DW-1:0] c2_lo=(p4<p5)?p4:p5, c2_hi=(p4<p5)?p5:p4;
   wire [DW-1:0] c3_lo=(p6<p7)?p6:p7, c3_hi=(p6<p7)?p7:p6;
   wire [DW-1:0] c4_lo=(c0_hi<c1_lo)?c0_hi:c1_lo, c4_hi=(c0_hi<c1_lo)?c1_lo:c0_hi;
   wire [DW-1:0] c5_lo=(c1_hi<c2_lo)?c1_hi:c2_lo, c5_hi=(c1_hi<c2_lo)?c2_lo:c1_hi;
   wire [DW-1:0] c6_lo=(c2_hi<c3_lo)?c2_hi:c3_lo, c6_hi=(c2_hi<c3_lo)?c3_lo:c2_hi;
   wire [DW-1:0] c7_lo=(c3_hi<p8)?c3_hi:p8, c7_hi=(c3_hi<p8)?p8:c3_hi;
   wire [DW-1:0] c8_lo=(c0_lo<c4_lo)?c0_lo:c4_lo, c8_hi=(c0_lo<c4_lo)?c4_lo:c0_lo;
   wire [DW-1:0] c9_lo=(c4_hi<c5_lo)?c4_hi:c5_lo, c9_hi=(c4_hi<c5_lo)?c5_lo:c4_hi;
   wire [DW-1:0] c10_lo=(c5_hi<c6_lo)?c5_hi:c6_lo, c10_hi=(c5_hi<c6_lo)?c6_lo:c5_hi;
   wire [DW-1:0] c11_lo=(c6_hi<c7_lo)?c6_hi:c7_lo, c11_hi=(c6_hi<c7_lo)?c7_lo:c6_hi;
   wire [DW-1:0] c12_lo=(c8_hi<c9_lo)?c8_hi:c9_lo, c12_hi=(c8_hi<c9_lo)?c9_lo:c8_hi;
   wire [DW-1:0] c13_lo=(c9_hi<c10_lo)?c9_hi:c10_lo, c13_hi=(c9_hi<c10_lo)?c10_lo:c9_hi;
   wire [DW-1:0] c14_lo=(c10_hi<c11_lo)?c10_hi:c11_lo, c14_hi=(c10_hi<c11_lo)?c11_lo:c10_hi;
   wire [DW-1:0] c15_lo=(c11_hi<c7_hi)?c11_hi:c7_hi, c15_hi=(c11_hi<c7_hi)?c7_hi:c11_hi;
   wire [DW-1:0] c16_lo=(c8_lo<c12_lo)?c8_lo:c12_lo, c16_hi=(c8_lo<c12_lo)?c12_lo:c8_lo;
   wire [DW-1:0] c17_lo=(c12_hi<c13_lo)?c12_hi:c13_lo, c17_hi=(c12_hi<c13_lo)?c13_lo:c12_hi;
   wire [DW-1:0] c18_lo=(c13_hi<c14_lo)?c13_hi:c14_lo, c18_hi=(c13_hi<c14_lo)?c14_lo:c13_hi;
   wire [DW-1:0] c19_lo=(c14_hi<c15_lo)?c14_hi:c15_lo, c19_hi=(c14_hi<c15_lo)?c15_lo:c14_hi;
   wire [DW-1:0] c20_lo=(c16_hi<c17_lo)?c16_hi:c17_lo, c20_hi=(c16_hi<c17_lo)?c17_lo:c16_hi;
   wire [DW-1:0] c21_lo=(c17_hi<c18_lo)?c17_hi:c18_lo, c21_hi=(c17_hi<c18_lo)?c18_lo:c17_hi;
   wire [DW-1:0] c22_lo=(c18_hi<c19_lo)?c18_hi:c19_lo, c22_hi=(c18_hi<c19_lo)?c19_lo:c18_hi;
   wire [DW-1:0] c23_lo=(c19_hi<c15_hi)?c19_hi:c15_hi, c23_hi=(c19_hi<c15_hi)?c15_hi:c19_hi;
   wire [DW-1:0] c24_lo=(c16_lo<c20_lo)?c16_lo:c20_lo, c24_hi=(c16_lo<c20_lo)?c20_lo:c16_lo;
   wire [DW-1:0] c25_lo=(c20_hi<c21_lo)?c20_hi:c21_lo, c25_hi=(c20_hi<c21_lo)?c21_lo:c20_hi;
   wire [DW-1:0] c26_lo=(c21_hi<c22_lo)?c21_hi:c22_lo, c26_hi=(c21_hi<c22_lo)?c22_lo:c21_hi;
   wire [DW-1:0] c27_lo=(c22_hi<c23_lo)?c22_hi:c23_lo, c27_hi=(c22_hi<c23_lo)?c23_lo:c22_hi;
   wire [DW-1:0] c28_lo=(c24_hi<c25_lo)?c24_hi:c25_lo, c28_hi=(c24_hi<c25_lo)?c25_lo:c24_hi;
   wire [DW-1:0] c29_lo=(c25_hi<c26_lo)?c25_hi:c26_lo, c29_hi=(c25_hi<c26_lo)?c26_lo:c25_hi;
   wire [DW-1:0] c30_lo=(c26_hi<c27_lo)?c26_hi:c27_lo, c30_hi=(c26_hi<c27_lo)?c27_lo:c26_hi;
   wire [DW-1:0] c31_lo=(c27_hi<c23_hi)?c27_hi:c23_hi, c31_hi=(c27_hi<c23_hi)?c23_hi:c27_hi;
   wire [DW-1:0] c32_lo=(c24_lo<c28_lo)?c24_lo:c28_lo, c32_hi=(c24_lo<c28_lo)?c28_lo:c24_lo;
   wire [DW-1:0] c33_lo=(c28_hi<c29_lo)?c28_hi:c29_lo, c33_hi=(c28_hi<c29_lo)?c29_lo:c28_hi;
   wire [DW-1:0] c34_lo=(c29_hi<c30_lo)?c29_hi:c30_lo, c34_hi=(c29_hi<c30_lo)?c30_lo:c29_hi;
   wire [DW-1:0] c35_lo=(c30_hi<c31_lo)?c30_hi:c31_lo, c35_hi=(c30_hi<c31_lo)?c31_lo:c30_hi;
   wire [DW-1:0] mag = c34_lo;  // median (middle lane)

   always @(posedge clk) begin
      if (rst) begin
         incnt<=0; ocnt<=0; wvcnt<=0; orow_c<=0; orow_r<=0;
         started<=0; indone<=0; caddr<=0; caddr_q<=0; adv_d<=0; adv_d2<=0;
         out_valid<=0; out_sof<=0; out_pix<={DW{1'b0}};
      end else begin
         out_valid<=0; out_sof<=0;
         if (in_sof) begin
            incnt<=0; ocnt<=0; wvcnt<=0; orow_c<=0; orow_r<=0;
            started<=0; indone<=0; caddr<=0; caddr_q<=0; adv_d<=0; adv_d2<=0;
         end
         // stage A: lb1 access + bottom-row delay
         adv_d <= adv;
         if (adv) begin
            caddr   <= (caddr==IMGW-1) ? {AW{1'b0}} : caddr + 1'b1;
            caddr_q <= caddr;
            botd1   <= botin;
            if (in_valid && !indone) begin
               if (incnt == TOTAL-1) indone<=1;
               incnt <= incnt + 1'b1;
            end
         end
         // stage B: lb2 access + mid-row align
         adv_d2 <= adv_d;
         if (adv_d) begin
            midq  <= lb1q;
            botd2 <= botd1;
         end
         // stage C: aligned window column -> shift + output
         if (wvalid) begin
            t2<=rtop; t1<=t2; t0<=t1;
            m2<=rmid; m1<=m2; m0<=m1;
            b2<=rbot; b1<=b2; b0<=b1;
            wvcnt <= wvcnt + 1'b1;
            if (!started && (wvcnt >= IMGW+2)) started<=1;
            if ((started || (wvcnt >= IMGW+2)) && (ocnt < TOTAL)) begin
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
