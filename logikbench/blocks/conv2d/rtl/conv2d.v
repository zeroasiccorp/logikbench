//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Programmable 3x3 2D convolution (streaming, same-size, zero-padded border).
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
// Nine runtime signed coefficients (packed coeff, Q1.(CW-1)) multiply the 3x3
// window (one multiplier per tap -> 9 DSPs), summed in an adder tree, then
// rounded and saturated to OUTW bits.
//
//#############################################################################

module conv2d
  #(parameter DW = 8,
    parameter CW = 8,
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
    input [9*CW-1:0]	coeff, // 9 signed Q1.(CW-1) taps, c0..c8
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

   // 9 programmable taps: prod[k] = window_pixel[k] * coeff[k]
   localparam	       FRAC = CW-1;
   localparam	       ACCW = DW+1+CW+4;
   wire [DW-1:0]       pwin [0:8];
   assign pwin[0]=p00; assign pwin[1]=p01; assign pwin[2]=p02;
   assign pwin[3]=p10; assign pwin[4]=p11; assign pwin[5]=p12;
   assign pwin[6]=p20; assign pwin[7]=p21; assign pwin[8]=p22;
   wire signed [DW+CW:0] prod [0:8];
   genvar		 gk;
   generate
      for (gk = 0; gk < 9; gk = gk + 1) begin : g_mac
         assign prod[gk] = $signed({1'b0, pwin[gk]})
           * $signed(coeff[gk*CW +: CW]);
      end
   endgenerate
   wire signed [ACCW-1:0] acc = prod[0]+prod[1]+prod[2]+prod[3]+prod[4]
                          +prod[5]+prod[6]+prod[7]+prod[8];
   wire signed [ACCW-1:0] racc = acc + (1 <<< (FRAC-1));
   wire signed [ACCW-1:0] sacc = racc >>> FRAC;
   wire [DW-1:0]	  mag = (sacc < 0)   ? {DW{1'b0}} :
                          (sacc > 255) ? 8'd255      : sacc[DW-1:0];


   integer		  k;
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
