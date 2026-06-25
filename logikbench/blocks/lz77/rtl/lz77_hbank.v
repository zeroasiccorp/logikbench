//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LZ77 history store. Holds the WIN-byte sliding history as WW-byte words split
// into even/odd word banks so the two consecutive words covering an arbitrary
// source byte read in one cycle (one read per bank). A single (non-replicated)
// copy: candidates are probed serially, so reads (asserted by 're') and the
// commit write land in different cycles and each bank is a single-port SRAM
// (la_spram, half the ASIC area of a dual-port). Per-lane byte write enables
// let a partial word update; writes are masked per byte.
//
// Synchronous read (1-cycle latency): assert re with rsrc, get w0/w1 next
// cycle. w0 = word containing the source start byte, w1 = the following word.
//
//#############################################################################

module lz77_hbank
  #(parameter WW = 64,        // bytes per word
    parameter WAW = 8)        // bank address width (log2(WIN/WW/2))
   (
    input             clk,
    input             re,     // read enable (assert with rsrc)
    // even-bank write
    input             we_ev,
    input [WAW-1:0]   wa_ev,
    input [WW*8-1:0]  wd_ev,
    input [WW-1:0]    wbe_ev,
    // odd-bank write
    input             we_od,
    input [WAW-1:0]   wa_od,
    input [WW*8-1:0]  wd_od,
    input [WW-1:0]    wbe_od,
    // read: source start byte (mod WIN)
    input [14:0]      rsrc,
    output [WW*8-1:0] w0,
    output [WW*8-1:0] w1
    );

   // word index of the source start, and which bank holds it
   wire [8:0]     wrd = rsrc[14:6];     // 0 .. (WIN/WW)-1
   wire           evf = ~wrd[0];        // source-start word is even?
   wire [WAW-1:0] ea  = evf ? wrd[WAW:1] : (wrd[WAW:1] + {{(WAW-1){1'b0}}, 1'b1});
   wire [WAW-1:0] oa  = wrd[WAW:1];

   // per-byte -> per-lane write mask (la_spram BYTEMODE replicates bit i*8)
   wire [WW*8-1:0] wm_ev, wm_od;
   genvar          i;
   generate
      for (i = 0; i < WW; i = i + 1) begin : g_wm
         assign wm_ev[i*8 +: 8] = {8{wbe_ev[i]}};
         assign wm_od[i*8 +: 8] = {8{wbe_od[i]}};
      end
   endgenerate

   // read and write never collide (read in scan cycles, write at commit)
   wire [WAW-1:0]  addr_ev = we_ev ? wa_ev : ea;
   wire [WAW-1:0]  addr_od = we_od ? wa_od : oa;
   wire            ce_ev = re | we_ev;
   wire            ce_od = re | we_od;
   wire [WW*8-1:0] q_ev, q_od;

   la_spram #(.DW(WW*8), .AW(WAW), .BYTEMODE(1)) m_ev
     (.clk(clk), .ce(ce_ev), .we(we_ev), .wmask(wm_ev), .addr(addr_ev),
      .din(wd_ev), .dout(q_ev), .selctrl(1'b0), .ctrl('b0), .status());

   la_spram #(.DW(WW*8), .AW(WAW), .BYTEMODE(1)) m_od
     (.clk(clk), .ce(ce_od), .we(we_od), .wmask(wm_od), .addr(addr_od),
      .din(wd_od), .dout(q_od), .selctrl(1'b0), .ctrl('b0), .status());

   reg evf_d;
   always @(posedge clk) if (re) evf_d <= evf;

   assign w0 = evf_d ? q_ev : q_od;
   assign w1 = evf_d ? q_od : q_ev;

endmodule
