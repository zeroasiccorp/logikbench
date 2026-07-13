//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// colorconv: streaming color-space conversion image accelerator.
//
// A pixel {r,g,b} enters each cycle (in_valid) and, two registered stages
// later, the converted pixel {c0,c1,c2} leaves (out_valid). The 'mode' input
// selects the conversion (BT.601 full range, fixed-point Q0.8 coefficients):
//   mode 0: RGB -> YCbCr   (c0=Y, c1=Cb, c2=Cr)
//   mode 1: YCbCr -> RGB   (r,g,b carry Y,Cb,Cr; c0=R, c1=G, c2=B)
//   mode 2: RGB -> gray    (c0=c1=c2=Y)
// Each output channel is a 3-term fixed-point multiply-add (colorconv_matrix)
// followed by saturation to [0, 2^DW-1] (colorconv_clamp).
//#############################################################################
module colorconv
  #(parameter DW = 8)                 // pixel component width
   (
    input               clk,
    input               rst,          // synchronous, active high
    input  [DW-1:0]     r,
    input  [DW-1:0]     g,
    input  [DW-1:0]     b,
    input  [1:0]        mode,
    input               in_valid,
    output reg [DW-1:0] c0,
    output reg [DW-1:0] c1,
    output reg [DW-1:0] c2,
    output reg          out_valid
    );

   localparam CW    = 12;             // signed coefficient width
   localparam SHIFT = 8;              // coefficients scaled by 2^8 = 256
   localparam ACCW  = DW + CW + 4;
   localparam signed [DW+1:0] OFFS = (1 << (DW - 1));   // chroma bias 2^(DW-1)

   //-------------------------------------------------------------------------
   // Stage 1: register the incoming pixel
   //-------------------------------------------------------------------------
   reg [DW-1:0] r_q, g_q, b_q;
   reg [1:0]    mode_q;
   reg          valid_q;

   always @(posedge clk) begin
      if (rst)
        valid_q <= 1'b0;
      else begin
         r_q     <= r;
         g_q     <= g;
         b_q     <= b;
         mode_q  <= mode;
         valid_q <= in_valid;
      end
   end

   //-------------------------------------------------------------------------
   // Signed inputs. Forward/gray use {R,G,B}; inverse uses {Y, Cb-bias,
   // Cr-bias} (the r/g/b ports carry {Y,Cb,Cr} in mode 1).
   //-------------------------------------------------------------------------
   wire signed [DW:0] rext = $signed({1'b0, r_q});
   wire signed [DW:0] gext = $signed({1'b0, g_q});
   wire signed [DW:0] bext = $signed({1'b0, b_q});
   wire signed [DW:0] cbs  = $signed({1'b0, g_q}) - $signed(OFFS);
   wire signed [DW:0] crs  = $signed({1'b0, b_q}) - $signed(OFFS);

   //-------------------------------------------------------------------------
   // Per-channel coefficients / bias and the shared inputs, selected by mode.
   //-------------------------------------------------------------------------
   reg signed [CW-1:0] k00, k01, k02, k10, k11, k12, k20, k21, k22;
   reg signed [DW+1:0] off0, off1, off2;
   reg signed [DW:0]   x0s, x1s, x2s;

   always @* begin
      case (mode_q)
        2'd0: begin  // RGB -> YCbCr
           k00 =  77; k01 =  150; k02 =  29;  off0 = 0;
           k10 = -43; k11 = -85;  k12 =  128; off1 = OFFS;
           k20 =  128; k21 = -107; k22 = -21; off2 = OFFS;
           x0s = rext; x1s = gext; x2s = bext;
        end
        2'd1: begin  // YCbCr -> RGB
           k00 = 256; k01 = 0;    k02 =  359; off0 = 0;
           k10 = 256; k11 = -88;  k12 = -183; off1 = 0;
           k20 = 256; k21 = 454;  k22 = 0;    off2 = 0;
           x0s = rext; x1s = cbs;  x2s = crs;   // rext = Y in this mode
        end
        default: begin  // RGB -> grayscale (Y on all three)
           k00 = 77; k01 = 150; k02 = 29; off0 = 0;
           k10 = 77; k11 = 150; k12 = 29; off1 = 0;
           k20 = 77; k21 = 150; k22 = 29; off2 = 0;
           x0s = rext; x1s = gext; x2s = bext;
        end
      endcase
   end

   //-------------------------------------------------------------------------
   // One multiply-add + clamp per output channel (combinational)
   //-------------------------------------------------------------------------
   wire signed [ACCW-1:0] res0, res1, res2;
   wire [DW-1:0]          p0, p1, p2;

   colorconv_matrix #(.DW(DW), .CW(CW), .SHIFT(SHIFT)) u_m0
     (.x0(x0s), .x1(x1s), .x2(x2s), .k0(k00), .k1(k01), .k2(k02),
      .offset(off0), .result(res0));

   colorconv_matrix #(.DW(DW), .CW(CW), .SHIFT(SHIFT)) u_m1
     (.x0(x0s), .x1(x1s), .x2(x2s), .k0(k10), .k1(k11), .k2(k12),
      .offset(off1), .result(res1));

   colorconv_matrix #(.DW(DW), .CW(CW), .SHIFT(SHIFT)) u_m2
     (.x0(x0s), .x1(x1s), .x2(x2s), .k0(k20), .k1(k21), .k2(k22),
      .offset(off2), .result(res2));

   colorconv_clamp #(.DW(DW), .IW(ACCW)) u_c0 (.val(res0), .pixel(p0));

   colorconv_clamp #(.DW(DW), .IW(ACCW)) u_c1 (.val(res1), .pixel(p1));

   colorconv_clamp #(.DW(DW), .IW(ACCW)) u_c2 (.val(res2), .pixel(p2));

   //-------------------------------------------------------------------------
   // Stage 2: register the converted pixel
   //-------------------------------------------------------------------------
   always @(posedge clk) begin
      if (rst)
        out_valid <= 1'b0;
      else begin
         c0        <= p0;
         c1        <= p1;
         c2        <= p2;
         out_valid <= valid_q;
      end
   end

endmodule
