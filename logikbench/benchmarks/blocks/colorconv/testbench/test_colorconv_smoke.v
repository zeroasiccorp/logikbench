//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: colorconv (self-check). Streams known pixels through the DUT and
 * compares against BT.601 golden values computed in real arithmetic, within a
 * small fixed-point tolerance. Prints PASSED or FAILED.
 * TESTED: RGB->YCbCr on the primaries (white/black/red/green/blue + arbitrary),
 *         grayscale mode (equal outputs), and a neutral YCbCr->RGB round point.
 * NOT TESTED: full inverse over the gamut (clamped chroma is lossy), streaming
 *         back-to-back throughput.
 ******************************************************************************/
`timescale 1ns/1ps
module test_colorconv_smoke;

   localparam DW  = 8;
   localparam integer TOL = 2;

   reg           clk = 1'b0;
   reg           rst;
   reg  [DW-1:0] r, g, b;
   reg  [1:0]    mode;
   reg           in_valid;
   wire [DW-1:0] c0, c1, c2;
   wire          out_valid;

   integer errors;

   always #5 clk = ~clk;

   colorconv #(.DW(DW)) dut
     (.clk(clk), .rst(rst), .r(r), .g(g), .b(b), .mode(mode),
      .in_valid(in_valid), .c0(c0), .c1(c1), .c2(c2), .out_valid(out_valid));

   function integer absdiff;
      input integer a;
      input integer bb;
      begin
         absdiff = (a > bb) ? (a - bb) : (bb - a);
      end
   endfunction

   function integer clampi;
      input integer v;
      begin
         clampi = (v < 0) ? 0 : (v > 255) ? 255 : v;
      end
   endfunction

   // drive one pixel and wait out the 2-stage pipeline (deterministic latency)
   task apply;
      input [DW-1:0] ir;
      input [DW-1:0] ig;
      input [DW-1:0] ib;
      input [1:0]    imode;
      begin
         @(posedge clk);
         r <= ir; g <= ig; b <= ib; mode <= imode; in_valid <= 1'b1;
         @(posedge clk);
         in_valid <= 1'b0;
         @(posedge clk);   // stage-2 edge: outputs and out_valid update
         #1;               // settle past the non-blocking updates
         if (out_valid !== 1'b1) begin
            $display("FAILED: out_valid not asserted when expected");
            errors = errors + 1;
         end
      end
   endtask

   task chk;
      input integer e0;
      input integer e1;
      input integer e2;
      begin
         if ((absdiff(c0, e0) > TOL) || (absdiff(c1, e1) > TOL) ||
             (absdiff(c2, e2) > TOL)) begin
            $display("FAILED: got (%0d,%0d,%0d) expected ~(%0d,%0d,%0d)",
                     c0, c1, c2, e0, e1, e2);
            errors = errors + 1;
         end
      end
   endtask

   // forward RGB->YCbCr, golden via BT.601 real arithmetic
   task fwd_check;
      input [DW-1:0] ir;
      input [DW-1:0] ig;
      input [DW-1:0] ib;
      real    yf, cbf, crf;
      integer yi, cbi, cri;
      begin
         yf  =  0.299*ir     + 0.587*ig     + 0.114*ib;
         cbf = -0.168736*ir  - 0.331264*ig  + 0.5*ib      + 128.0;
         crf =  0.5*ir       - 0.418688*ig  - 0.081312*ib + 128.0;
         yi  = clampi($rtoi(yf  + 0.5));
         cbi = clampi($rtoi(cbf + 0.5));
         cri = clampi($rtoi(crf + 0.5));
         apply(ir, ig, ib, 2'd0);
         chk(yi, cbi, cri);
      end
   endtask

   initial begin
      errors   = 0;
      r = 0; g = 0; b = 0; mode = 0; in_valid = 0;
      rst = 1'b1;
      repeat (3) @(posedge clk);
      rst <= 1'b0;
      @(posedge clk);

      // RGB -> YCbCr on the primaries and an arbitrary pixel
      fwd_check(255, 255, 255);   // white  -> Y=255, Cb=128, Cr=128
      fwd_check(0,   0,   0);     // black  -> Y=0,   Cb=128, Cr=128
      fwd_check(255, 0,   0);     // red
      fwd_check(0,   255, 0);     // green
      fwd_check(0,   0,   255);   // blue
      fwd_check(100, 150, 200);   // arbitrary

      // grayscale: all three outputs equal Y
      apply(255, 0, 0, 2'd2);
      if ((c0 !== c1) || (c1 !== c2)) begin
         $display("FAILED: gray outputs differ (%0d,%0d,%0d)", c0, c1, c2);
         errors = errors + 1;
      end
      chk(76, 76, 76);            // Y of pure red ~ 76

      // inverse at the neutral point: YCbCr(128,128,128) -> RGB(128,128,128)
      apply(128, 128, 128, 2'd1);
      chk(128, 128, 128);

      if (errors == 0)
        $display("PASSED");
      else
        $display("FAILED: %0d error(s)", errors);
      $finish;
   end

   initial begin
      #100000;
      $display("FAILED: timeout");
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_colorconv_smoke.vcd");
      $dumpvars(0, test_colorconv_smoke);
   end
`endif

endmodule
