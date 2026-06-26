//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LZ77 single-candidate match extender. Given the lookahead bytes (la) and the
// two history words spanning the candidate source start, gather a WW-byte
// source slice (barrel-shift by the byte offset), apply overlap (RLE) so that
// source byte k uses la[k-dist] once k >= dist, then compare against the
// lookahead and return the leading-match length (0..WW).
//
// All indices into la/word vectors are static (genvar) or bounded barrel
// shifts; the only reduction is a popcount of the prefix-AND match mask. No
// procedural sweep over a runtime-indexed memory, no functions.
//
//#############################################################################

module lz77_cand
  #(parameter WW = 64,	// compare width in bytes (= MAXMATCH)
    parameter AW = 15,	// distance width
    parameter LENW = 7)	// length width (holds 0..WW)
   (
    input [WW*8-1:0]  la,   // lookahead bytes, byte k = la[k*8 +: 8]
    input [WW*8-1:0]  w0,   // history word holding the source start
    input [WW*8-1:0]  w1,   // following history word
    input [5:0]	      boff, // start byte offset within {w1,w0}
    input [AW-1:0]    mdist, // candidate distance (>= 1)
    input [LENW-1:0]  vlen, // usable lookahead length (<= WW)
    input	      cok,  // candidate valid
    output [LENW-1:0] mlen  // leading match length
    );

   // 2*WW-byte raw history view (w0 in the low half)
   wire [2*WW*8-1:0] gv = {w1, w0};

   // per-byte compare and prefix-AND, built as parallel hardware
   wire [WW-1:0]     eq;       // raw per-position equality (gated by vlen/cok)
   wire [WW-1:0]     pfx;      // prefix-AND of eq (1s up to first mismatch)
   genvar	     k;
   generate
      for (k = 0; k < WW; k = k + 1) begin : g_cmp
         // source byte: history slice unless we are inside the overlap region
         wire [7:0] raw = gv[(boff + k) * 8 +: 8];
         wire [7:0] ov  = la[(k - mdist) * 8 +: 8];  // overlap: la[k-mdist]
         wire [7:0] src = (k < mdist) ? raw : ov;
         wire [7:0] tgt = la[k * 8 +: 8];
         assign eq[k] = cok && (k < vlen) && (src == tgt);
         if (k == 0)
           assign pfx[k] = eq[k];
         else
           assign pfx[k] = pfx[k-1] & eq[k];
      end
   endgenerate

   // match length = popcount of the (monotonic) prefix mask
   integer        i;
   reg [LENW-1:0] cnt;
   always @* begin
      cnt = {LENW{1'b0}};
      for (i = 0; i < WW; i = i + 1)
        cnt = cnt + {{(LENW-1){1'b0}}, pfx[i]};
   end
   assign mlen = cnt;

endmodule
