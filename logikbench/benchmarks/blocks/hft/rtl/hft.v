//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft: tick-to-trade high-frequency-trading pipeline. A 512-bit market-data
// word streams in (valid-only, no backpressure) and flows through six
// registered stages -- parse, book update, feature, strategy, risk, encode --
// producing a 512-bit order packet. Latency is 6 cycles. See README.md.
//
//#############################################################################
module hft #(parameter		    NSYM = 32,
             parameter		    NLEVEL = 16,
             parameter		    PRICE_W = 32,
             parameter		    QTY_W = 16,
             parameter		    POS_W = 32,
             parameter signed [7:0] SKEW_K = 8'sd4,
             parameter		    SKEW_SH = 4,
             parameter		    MARGIN = 16,
             parameter		    WIDE = 256,
             parameter		    ORDER_QTY = 10,
             parameter		    POS_LIMIT = 1000,
             parameter		    NOTIONAL_LIMIT = 32'h0010_0000,
             parameter		    PRICE_BAND = 1024
             )
   (
    input	   clk,
    input	   nreset,
    input	   market_data_valid,
    input [511:0]  market_data_word,
    output	   order_packet_valid,
    output [511:0] order_packet_word
    );

   localparam SYMW = $clog2(NSYM);
   localparam LVLW = $clog2(NLEVEL);

   // parser -> book
   wire	      p_valid;
   wire [7:0] p_type;
   wire [SYMW-1:0] p_sym;
   wire		   p_side;
   wire [LVLW-1:0] p_level;
   wire [PRICE_W-1:0] p_price;
   wire [QTY_W-1:0]   p_qty;

   // book -> feature
   wire		      b_valid;
   wire [SYMW-1:0]    b_sym;
   wire [PRICE_W-1:0] b_bid, b_ask;
   wire [QTY_W-1:0]   b_bidqty, b_askqty;

   // feature -> strategy
   wire		      f_valid;
   wire [SYMW-1:0]    f_sym;
   wire [PRICE_W-1:0] f_bid, f_ask, f_mid, f_fair;
   wire signed [PRICE_W:0] f_spread;

   // strategy -> risk
   wire			   s_valid;
   wire [SYMW-1:0]	   s_sym;
   wire [2:0]		   s_action;
   wire			   s_side;
   wire [PRICE_W-1:0]	   s_price, s_ref;
   wire [QTY_W-1:0]	   s_qty;

   // risk -> encoder
   wire			   r_valid;
   wire [SYMW-1:0]	   r_sym;
   wire [2:0]		   r_action;
   wire			   r_side;
   wire [PRICE_W-1:0]	   r_price;
   wire [QTY_W-1:0]	   r_qty;

   hft_parser #(.NSYM(NSYM), .NLEVEL(NLEVEL), .PRICE_W(PRICE_W), .QTY_W(QTY_W))
   u_parser
     (.clk(clk), .nreset(nreset),
      .md_valid(market_data_valid), .md_word(market_data_word),
      .p_valid(p_valid), .p_type(p_type), .p_sym(p_sym), .p_side(p_side),
      .p_level(p_level), .p_price(p_price), .p_qty(p_qty));

   hft_book #(.NSYM(NSYM), .NLEVEL(NLEVEL), .PRICE_W(PRICE_W), .QTY_W(QTY_W))
   u_book
     (.clk(clk), .nreset(nreset),
      .p_valid(p_valid), .p_type(p_type), .p_sym(p_sym), .p_side(p_side),
      .p_level(p_level), .p_price(p_price), .p_qty(p_qty),
      .b_valid(b_valid), .b_sym(b_sym), .b_bid(b_bid), .b_bidqty(b_bidqty),
      .b_ask(b_ask), .b_askqty(b_askqty));

   hft_feature #(.NSYM(NSYM), .PRICE_W(PRICE_W), .QTY_W(QTY_W),
                 .SKEW_K(SKEW_K), .SKEW_SH(SKEW_SH))
   u_feature
     (.clk(clk), .nreset(nreset),
      .b_valid(b_valid), .b_sym(b_sym), .b_bid(b_bid), .b_bidqty(b_bidqty),
      .b_ask(b_ask), .b_askqty(b_askqty),
      .f_valid(f_valid), .f_sym(f_sym), .f_bid(f_bid), .f_ask(f_ask),
      .f_mid(f_mid), .f_fair(f_fair), .f_spread(f_spread));

   hft_strategy #(.NSYM(NSYM), .PRICE_W(PRICE_W), .QTY_W(QTY_W),
                  .MARGIN(MARGIN), .WIDE(WIDE), .ORDER_QTY(ORDER_QTY))
   u_strategy
     (.clk(clk), .nreset(nreset),
      .f_valid(f_valid), .f_sym(f_sym), .f_bid(f_bid), .f_ask(f_ask),
      .f_mid(f_mid), .f_fair(f_fair), .f_spread(f_spread),
      .s_valid(s_valid), .s_sym(s_sym), .s_action(s_action), .s_side(s_side),
      .s_price(s_price), .s_qty(s_qty), .s_ref(s_ref));

   hft_risk #(.NSYM(NSYM), .PRICE_W(PRICE_W), .QTY_W(QTY_W), .POS_W(POS_W),
              .POS_LIMIT(POS_LIMIT), .NOTIONAL_LIMIT(NOTIONAL_LIMIT),
              .PRICE_BAND(PRICE_BAND))
   u_risk
     (.clk(clk), .nreset(nreset),
      .s_valid(s_valid), .s_sym(s_sym), .s_action(s_action), .s_side(s_side),
      .s_price(s_price), .s_qty(s_qty), .s_ref(s_ref),
      .r_valid(r_valid), .r_sym(r_sym), .r_action(r_action), .r_side(r_side),
      .r_price(r_price), .r_qty(r_qty));

   hft_encoder #(.NSYM(NSYM), .PRICE_W(PRICE_W), .QTY_W(QTY_W))
   u_encoder
     (.clk(clk), .nreset(nreset),
      .r_valid(r_valid), .r_sym(r_sym), .r_action(r_action), .r_side(r_side),
      .r_price(r_price), .r_qty(r_qty),
      .order_packet_valid(order_packet_valid),
      .order_packet_word(order_packet_word));

endmodule
