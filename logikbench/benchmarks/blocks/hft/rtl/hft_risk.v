//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft_risk: pre-trade risk checks. Rejects an order (forces action to none)
// if it breaches a price band around the reference (mid), a per-order notional
// limit (price*qty), or a per-symbol position limit. Buys/sells that pass
// update the running per-symbol position. Cancels are always allowed; replaces
// are band-checked only. Registered output.
//
//#############################################################################
module hft_risk #(parameter NSYM = 32,
                  parameter PRICE_W = 32,
                  parameter QTY_W = 16,
                  parameter POS_W = 32,
                  parameter POS_LIMIT = 1000,
                  parameter NOTIONAL_LIMIT = 32'h0010_0000,
                  parameter PRICE_BAND = 1024
                  )
   (
    input			  clk,
    input			  nreset,
    input			  s_valid,
    input [$clog2(NSYM)-1:0]	  s_sym,
    input [2:0]			  s_action,
    input			  s_side,
    input [PRICE_W-1:0]		  s_price,
    input [QTY_W-1:0]		  s_qty,
    input [PRICE_W-1:0]		  s_ref,
    output reg			  r_valid,
    output reg [$clog2(NSYM)-1:0] r_sym,
    output reg [2:0]		  r_action,
    output reg			  r_side,
    output reg [PRICE_W-1:0]	  r_price,
    output reg [QTY_W-1:0]	  r_qty
    );

   localparam SYMW = $clog2(NSYM);
   localparam A_NONE=3'd0, A_BUY=3'd1, A_SELL=3'd2, A_CANCEL=3'd3, A_REPLACE=3'd4;

   integer    i;
   reg signed [POS_W-1:0] position [0:NSYM-1];

   wire			  is_order  = (s_action==A_BUY) | (s_action==A_SELL);
   wire			  has_price = (s_action!=A_NONE) & (s_action!=A_CANCEL);

   // price band around the reference
   wire [PRICE_W:0]	  price_w = {1'b0, s_price};
   wire [PRICE_W:0]	  ref_w   = {1'b0, s_ref};
   wire			  band_bad = has_price &
                          ((price_w > (ref_w + PRICE_BAND)) |
                           ((price_w + PRICE_BAND) < ref_w));

   // notional = price * qty
   wire [PRICE_W+QTY_W-1:0] notional = s_price * s_qty;
   wire			    notion_bad = is_order & (notional > NOTIONAL_LIMIT);

   // position after this order
   wire signed [POS_W:0]    pos_cur = position[s_sym];
   wire signed [POS_W:0]    delta   = (s_action==A_BUY)  ?  $signed({1'b0, s_qty}) :
                            (s_action==A_SELL) ? -$signed({1'b0, s_qty}) :
                            {(POS_W+1){1'b0}};
   wire signed [POS_W:0]    newpos  = pos_cur + delta;
   wire			    pos_bad     = is_order &
                            ((newpos > POS_LIMIT) | (newpos < -POS_LIMIT));

   wire			    reject = band_bad | notion_bad | pos_bad;
   wire			    pass   = s_valid & (s_action!=A_NONE) & ~reject;

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        r_valid  <= 1'b0;
        r_sym    <= {SYMW{1'b0}};
        r_action <= A_NONE;
        r_side   <= 1'b0;
        r_price  <= {PRICE_W{1'b0}};
        r_qty    <= {QTY_W{1'b0}};
        for (i=0; i<NSYM; i=i+1)
          position[i] <= {POS_W{1'b0}};
     end
     else begin
        r_valid  <= s_valid;
        r_sym    <= s_sym;
        r_action <= pass ? s_action : A_NONE;
        r_side   <= s_side;
        r_price  <= s_price;
        r_qty    <= s_qty;
        if (pass & is_order)
          position[s_sym] <= newpos[POS_W-1:0];
     end

endmodule
