//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft_strategy: turns features into an order decision. If the fair value is
// above the ask by MARGIN it buys (lifts the ask); if below the bid by MARGIN
// it sells (hits the bid); if the spread is wider than WIDE it cancels resting
// quotes; otherwise it replaces (requotes at the mid). Emits action, side,
// price, qty, and the reference (mid) price for the risk stage. Registered.
//
// action encoding: 0=none 1=buy 2=sell 3=cancel 4=replace
//
//#############################################################################
module hft_strategy #(parameter	NSYM = 32,
                      parameter	PRICE_W = 32,
                      parameter	QTY_W = 16,
                      parameter	MARGIN = 16,
                      parameter	WIDE = 256,
                      parameter	ORDER_QTY = 10
                      )
   (
    input			  clk,
    input			  nreset,
    input			  f_valid,
    input [$clog2(NSYM)-1:0]	  f_sym,
    input [PRICE_W-1:0]		  f_bid,
    input [PRICE_W-1:0]		  f_ask,
    input [PRICE_W-1:0]		  f_mid,
    input [PRICE_W-1:0]		  f_fair,
    input signed [PRICE_W:0]	  f_spread,
    output reg			  s_valid,
    output reg [$clog2(NSYM)-1:0] s_sym,
    output reg [2:0]		  s_action,
    output reg			  s_side,
    output reg [PRICE_W-1:0]	  s_price,
    output reg [QTY_W-1:0]	  s_qty,
    output reg [PRICE_W-1:0]	  s_ref
    );

   localparam SYMW = $clog2(NSYM);
   localparam A_NONE=3'd0, A_BUY=3'd1, A_SELL=3'd2, A_CANCEL=3'd3, A_REPLACE=3'd4;
   localparam [QTY_W-1:0] OQTY = ORDER_QTY;

   // widened price comparisons (avoid PRICE_W overflow on +MARGIN)
   wire [PRICE_W:0]	  fair_w = {1'b0, f_fair};
   wire [PRICE_W:0]	  ask_w  = {1'b0, f_ask};
   wire [PRICE_W:0]	  bid_w  = {1'b0, f_bid};
   wire			  buy_c  = (fair_w > (ask_w + MARGIN));
   wire			  sell_c = ((fair_w + MARGIN) < bid_w);
   wire			  wide_c = (f_spread > $signed(WIDE));

   // decision (priority: buy, then sell, then cancel-on-wide, else replace)
   wire [2:0]		  act = buy_c  ? A_BUY :
                          sell_c ? A_SELL :
                          wide_c ? A_CANCEL : A_REPLACE;
   wire			  sd  = (~buy_c & sell_c);            // side 1 only on sell
   wire [PRICE_W-1:0]	  pr         = buy_c  ? f_ask :
                          sell_c ? f_bid : f_mid;
   wire [QTY_W-1:0]	  qt  = (~buy_c & ~sell_c & wide_c) ? {QTY_W{1'b0}} : OQTY;

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        s_valid  <= 1'b0;
        s_sym    <= {SYMW{1'b0}};
        s_action <= A_NONE;
        s_side   <= 1'b0;
        s_price  <= {PRICE_W{1'b0}};
        s_qty    <= {QTY_W{1'b0}};
        s_ref    <= {PRICE_W{1'b0}};
     end
     else begin
        s_valid  <= f_valid;
        s_sym    <= f_sym;
        s_action <= f_valid ? act : A_NONE;
        s_side   <= sd;
        s_price  <= pr;
        s_qty    <= qt;
        s_ref    <= f_mid;
     end

endmodule
