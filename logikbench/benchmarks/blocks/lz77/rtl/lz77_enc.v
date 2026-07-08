//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LZ77 (LZSS) hash-based ENCODER, FPGA/ASIC style. A 4-byte multiplicative hash
// of the current position indexes a 16K-entry table holding the NWAY most-recent
// positions with that hash. The candidates are probed SERIALLY against a single
// (non-replicated) history store and extended by a WW-byte parallel compare; the
// longest match (>= MINMATCH) wins and emits a {len,dist} match token (advance
// len) or a literal token (advance 1). The history and hash table are
// single-port SRAM (la_spram, half the ASIC area of dual-port) -- reads and the
// commit write fall in different FSM cycles. The 32 KB history is word-organized
// (byte-write) so the 2 words covering any source byte read in one cycle.
//
// The hash is only a hint: every candidate is verified by the byte compare and
// gated by dist in [1, min(pos, WIN)], so a stale/aliased entry can never form
// an invalid match -- it just becomes a literal. Lossless regardless.
//
// FSM: FILL -> PROBE -> BUCKET -> SCAN(xNWAY) -> COMMIT. Synchronous SRAM reads
// take a cycle, so each candidate's history read is issued one cycle and its
// match length evaluated the next (pipelined down the serial scan). Only the
// current position is inserted each step -- a ratio simplification, never a
// correctness one.
//
//#############################################################################

module lz77_enc
  #(parameter WIN = 32768,
    parameter WW = 64,
    parameter NWAY = 4,
    parameter HASHBITS = 12,
    parameter MINMATCH = 4,
    parameter LENW = 7,
    parameter AW = 15,
    parameter PW = 16,
    parameter WAW = 8)
   (
    input             clk,
    input             rst,
    input             in_valid,
    input [7:0]       in_byte,
    input             in_last,
    output            in_ready,
    output            out_valid,
    output            out_match,
    output [7:0]      out_lit,
    output [LENW-1:0] out_len,
    output [AW-1:0]   out_dist,
    input             out_ready
    );

   localparam S_FILL  = 3'd0, S_PROBE = 3'd1, S_BUCKET = 3'd2,
              S_SCAN  = 3'd3, S_COMMIT = 3'd4;
   localparam EW = NWAY*PW;

   reg [2:0]      state;
   reg [PW-1:0]   pos;
   reg [WW*8-1:0] la;            // lookahead, byte k = la[k*8 +: 8]
   reg [LENW-1:0] nla;           // valid lookahead bytes
   reg            indone;

   // hash table (single-port): NWAY positions/bucket, newest in the low slot
   reg [HASHBITS-1:0] hreg;
   reg [EW-1:0]   htab_q;        // latched bucket for the serial scan

   wire [31:0] h_in = {la[3*8 +: 8], la[2*8 +: 8], la[1*8 +: 8], la[0 +: 8]};
   wire [HASHBITS-1:0] hval;
   lz77_hash #(.HASHBITS(HASHBITS)) u_hash (.data(h_in), .hash(hval));

   wire [EW-1:0] hbk;            // hash-table read data
   wire          ht_ce = (state == S_PROBE) || (state == S_BUCKET);
   wire          ht_we = (state == S_BUCKET);
   wire [HASHBITS-1:0] ht_addr = (state == S_BUCKET) ? hreg : hval;
   wire [EW-1:0] ht_din = {hbk[EW-PW-1:0], pos};
   la_spram #(.DW(EW), .AW(HASHBITS), .BYTEMASK(0)) u_htab
     (.clk(clk), .ce(ht_ce), .we(ht_we), .wmask({EW{1'b1}}), .addr(ht_addr),
      .din(ht_din), .dout(hbk), .selctrl(1'b0), .ctrl('b0), .status());

   // serial candidate scan bookkeeping
   reg [$clog2(NWAY+1)-1:0] ci;   // index of the candidate being issued
   reg [5:0]      eboff;          // pipelined params of the in-flight candidate
   reg [AW-1:0]   edist;
   reg            ecok;
   reg            epend;
   reg [LENW-1:0] bestlen;
   reg [AW-1:0]   bestdist;

   // candidate currently being issued this cycle (bucket -> cand0, scan -> ci)
   wire [PW-1:0]  cposf = (state == S_BUCKET) ? hbk[PW-1:0]
                                              : htab_q[ci*PW +: PW];
   wire [PW-1:0]  dtmp  = pos - cposf;
   wire           cokc  = (dtmp >= 1) && (dtmp <= WIN) && (dtmp <= pos) &&
                          (nla >= MINMATCH[LENW-1:0]);
   wire           issue = (state == S_BUCKET) ||
                          (state == S_SCAN && (ci < NWAY[$clog2(NWAY+1)-1:0]));

   // single history store + single match extender
   reg            we_ev, we_od;
   reg [WAW-1:0]  wa_ev, wa_od;
   reg [WW*8-1:0] wd_ev, wd_od;
   reg [WW-1:0]   wbe_ev, wbe_od;
   wire [WW*8-1:0] w0, w1;
   wire [LENW-1:0] cmlen;

   lz77_hbank #(.WW(WW), .WAW(WAW)) u_bank
     (.clk(clk), .re(issue),
      .we_ev(we_ev), .wa_ev(wa_ev), .wd_ev(wd_ev), .wbe_ev(wbe_ev),
      .we_od(we_od), .wa_od(wa_od), .wd_od(wd_od), .wbe_od(wbe_od),
      .rsrc(cposf[AW-1:0]), .w0(w0), .w1(w1));

   lz77_cand #(.WW(WW), .AW(AW), .LENW(LENW)) u_cand
     (.la(la), .w0(w0), .w1(w1), .boff(eboff), .mdist(edist),
      .vlen(nla), .cok(ecok), .mlen(cmlen));

   wire            ismatch = (bestlen >= MINMATCH[LENW-1:0]);
   wire [LENW-1:0] adv = ismatch ? bestlen : 7'd1;

   assign in_ready  = (state == S_FILL) && !indone && (nla < WW[LENW-1:0]);
   assign out_valid = (state == S_COMMIT);
   assign out_match = ismatch;
   assign out_lit   = la[7:0];
   assign out_len   = bestlen;
   assign out_dist  = bestdist;

   // ------------------------------------------------------------------
   // commit history write: consumed bytes la[0..adv-1] -> byte positions
   // pos..pos+adv-1 (mod WIN), spanning up to two words
   // ------------------------------------------------------------------
   wire [5:0]      lane0   = pos[5:0];
   wire [8:0]      wloword = pos[AW-1:6];
   wire [LENW:0]   endlane = {1'b0, lane0} + adv;
   wire [LENW-1:0] spill   = (endlane > WW[LENW:0]) ?
                             (endlane - WW[LENW:0]) : {LENW{1'b0}};
   reg [WW*8-1:0]  dlo, dhi;
   reg [WW-1:0]    belo, behi;
   integer         j;
   always @* begin
      dlo = {WW*8{1'b0}}; dhi = {WW*8{1'b0}};
      belo = {WW{1'b0}};  behi = {WW{1'b0}};
      for (j = 0; j < WW; j = j + 1) begin
         if ((j >= lane0) && ({1'b0, j[5:0]} < endlane)) begin
            dlo[j*8 +: 8] = la[(j - lane0) * 8 +: 8];
            belo[j] = 1'b1;
         end
         if (j < spill) begin
            dhi[j*8 +: 8] = la[(WW - lane0 + j) * 8 +: 8];
            behi[j] = 1'b1;
         end
      end
      if (wloword[0] == 1'b0) begin
         we_ev = 1'b1;          wa_ev = wloword[WAW:1];
         wd_ev = dlo;           wbe_ev = belo;
         we_od = (spill != 0);  wa_od = wloword[WAW:1];
         wd_od = dhi;           wbe_od = behi;
      end else begin
         we_od = 1'b1;          wa_od = wloword[WAW:1];
         wd_od = dlo;           wbe_od = belo;
         we_ev = (spill != 0);  wa_ev = wloword[WAW:1] + 1'b1;
         wd_ev = dhi;           wbe_ev = behi;
      end
      if (!(state == S_COMMIT && out_ready)) begin
         we_ev = 1'b0; we_od = 1'b0;
      end
   end

   // ------------------------------------------------------------------
   // FSM
   // ------------------------------------------------------------------
   always @(posedge clk) begin
      if (rst) begin
         state <= S_FILL; pos <= 0; nla <= 0; indone <= 1'b0;
      end else begin
         case (state)
           S_FILL: begin
              if (in_valid && in_ready) begin
                 la[nla*8 +: 8] <= in_byte;
                 nla <= nla + 7'd1;
                 if (in_last) indone <= 1'b1;
              end
              if (((nla >= WW[LENW-1:0]) || indone) && (nla != 0))
                state <= S_PROBE;
           end
           S_PROBE: begin
              hreg  <= hval;             // hash-table read issued (ht_ce)
              state <= S_BUCKET;
           end
           S_BUCKET: begin
              htab_q  <= hbk;            // latch bucket; insert pos (ht_we)
              // issue candidate 0 read; register its params
              eboff   <= cposf[5:0];
              edist   <= dtmp[AW-1:0];
              ecok    <= cokc;
              epend   <= 1'b1;
              ci      <= 1;
              bestlen <= {LENW{1'b0}};
              state   <= S_SCAN;
           end
           S_SCAN: begin
              // evaluate the candidate issued last cycle
              if (epend && (cmlen > bestlen)) begin
                 bestlen  <= cmlen;
                 bestdist <= edist;
              end
              if (ci < NWAY[$clog2(NWAY+1)-1:0]) begin
                 // issue candidate ci read; register its params
                 eboff <= cposf[5:0];
                 edist <= dtmp[AW-1:0];
                 ecok  <= cokc;
                 epend <= 1'b1;
                 ci    <= ci + 1'b1;
              end else begin
                 epend <= 1'b0;
                 state <= S_COMMIT;
              end
           end
           S_COMMIT: begin
              if (out_ready) begin
                 pos <= pos + {{(PW-LENW){1'b0}}, adv};
                 la  <= la >> (adv * 8);
                 nla <= nla - adv;
                 state <= S_FILL;
              end
           end
         endcase
      end
   end

endmodule
