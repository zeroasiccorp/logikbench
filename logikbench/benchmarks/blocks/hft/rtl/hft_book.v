//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft_book: level-indexed limit-order book. Per side (bid/ask) a simple
// dual-port RAM stores {price,qty} indexed by {symbol,level}; the RAMs infer
// BRAM. On each update/delete the addressed level is written, and the top of
// book (level 0) for that symbol is read out. A write to level 0 is forwarded
// so the emitted top of book reflects the current update. Output aligns one
// cycle after the input (the RAM read latency).
//
//#############################################################################
module hft_book #(parameter NSYM = 32,
                  parameter NLEVEL = 16,
                  parameter PRICE_W = 32,
                  parameter QTY_W = 16
                  )
   (
    input		       clk,
    input		       nreset,
    input		       p_valid,
    input [7:0]		       p_type,
    input [$clog2(NSYM)-1:0]   p_sym,
    input		       p_side,
    input [$clog2(NLEVEL)-1:0] p_level,
    input [PRICE_W-1:0]	       p_price,
    input [QTY_W-1:0]	       p_qty,
    output		       b_valid,
    output [$clog2(NSYM)-1:0]  b_sym,
    output [PRICE_W-1:0]       b_bid,
    output [QTY_W-1:0]	       b_bidqty,
    output [PRICE_W-1:0]       b_ask,
    output [QTY_W-1:0]	       b_askqty
    );

   localparam SYMW  = $clog2(NSYM);
   localparam LVLW  = $clog2(NLEVEL);
   localparam DEPTH = NSYM * NLEVEL;
   localparam PW    = PRICE_W + QTY_W;
   localparam MSG_UPDATE = 8'd1;
   localparam MSG_DELETE = 8'd2;

   reg [PW-1:0]	bid_mem [0:DEPTH-1];
   reg [PW-1:0]	ask_mem [0:DEPTH-1];
   reg [PW-1:0]	bid_rd, ask_rd;

   wire		wr    = p_valid & ((p_type==MSG_UPDATE)|(p_type==MSG_DELETE));
   wire [PW-1:0] wdata = (p_type==MSG_DELETE) ? {PW{1'b0}} : {p_price, p_qty};
   wire [SYMW+LVLW-1:0]	waddr = {p_sym, p_level};
   wire [SYMW+LVLW-1:0]	raddr = {p_sym, {LVLW{1'b0}}};

   // synchronous write + level-0 read (BRAM inference)
   always @(posedge clk) begin
      if (wr & ~p_side) bid_mem[waddr] <= wdata;
      if (wr &  p_side) ask_mem[waddr] <= wdata;
      bid_rd <= bid_mem[raddr];
      ask_rd <= ask_mem[raddr];
   end

   // delayed control aligned to the RAM read, plus level-0 write forwarding
   reg            d_valid, d_wbid0, d_wask0;
   reg [SYMW-1:0] d_sym;
   reg [PW-1:0]	  d_wdata;

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        d_valid <= 1'b0;
        d_wbid0 <= 1'b0;
        d_wask0 <= 1'b0;
        d_sym   <= {SYMW{1'b0}};
        d_wdata <= {PW{1'b0}};
     end
     else begin
        d_valid <= p_valid;
        d_wbid0 <= wr & (p_side==1'b0) & (p_level=={LVLW{1'b0}});
        d_wask0 <= wr & (p_side==1'b1) & (p_level=={LVLW{1'b0}});
        d_sym   <= p_sym;
        d_wdata <= wdata;
     end

   wire [PW-1:0]  bid_top = d_wbid0 ? d_wdata : bid_rd;
   wire [PW-1:0]  ask_top = d_wask0 ? d_wdata : ask_rd;

   assign b_valid  = d_valid;
   assign b_sym    = d_sym;
   assign b_bid    = bid_top[PW-1 -: PRICE_W];
   assign b_bidqty = bid_top[QTY_W-1:0];
   assign b_ask    = ask_top[PW-1 -: PRICE_W];
   assign b_askqty = ask_top[QTY_W-1:0];

endmodule
