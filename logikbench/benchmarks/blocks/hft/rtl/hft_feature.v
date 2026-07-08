//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft_feature: derives trading features from the top of book. Computes the
// spread (ask-bid), the mid price ((bid+ask)/2), the size imbalance
// (bid_qty-ask_qty), and an imbalance-weighted fair value:
//   fair = mid + (imbalance * SKEW_K) >>> SKEW_SH   (saturated to [0, max]).
// The multiply maps to a DSP/hard multiplier. Registered output.
//
//#############################################################################
module hft_feature #(parameter		    NSYM = 32,
                     parameter		    PRICE_W = 32,
                     parameter		    QTY_W = 16,
                     parameter signed [7:0] SKEW_K = 8'sd4,
                     parameter		    SKEW_SH = 4
                     )
   (
    input			  clk,
    input			  nreset,
    input			  b_valid,
    input [$clog2(NSYM)-1:0]	  b_sym,
    input [PRICE_W-1:0]		  b_bid,
    input [QTY_W-1:0]		  b_bidqty,
    input [PRICE_W-1:0]		  b_ask,
    input [QTY_W-1:0]		  b_askqty,
    output reg			  f_valid,
    output reg [$clog2(NSYM)-1:0] f_sym,
    output reg [PRICE_W-1:0]	  f_bid,
    output reg [PRICE_W-1:0]	  f_ask,
    output reg [PRICE_W-1:0]	  f_mid,
    output reg [PRICE_W-1:0]	  f_fair,
    output reg signed [PRICE_W:0] f_spread
    );

   localparam SYMW = $clog2(NSYM);
   localparam IMBW = QTY_W + 1;               // signed qty difference
   localparam MW   = IMBW + 8;                // imbalance * SKEW_K
   localparam FW   = PRICE_W + 9;             // fair-value working width
   localparam signed [FW-1:0] MAXP = {1'b0, {PRICE_W{1'b1}}};

   wire [PRICE_W-1:0]	      mid  = (b_bid + b_ask) >> 1;
   wire signed [PRICE_W:0]    spr = $signed({1'b0, b_ask}) - $signed({1'b0, b_bid});
   wire signed [IMBW-1:0]     imb = $signed({1'b0, b_bidqty}) - $signed({1'b0, b_askqty});
   wire signed [MW-1:0]	      skew = imb * SKEW_K;
   wire signed [FW-1:0]	      fairw = $signed({1'b0, mid}) + (skew >>> SKEW_SH);
   wire [PRICE_W-1:0]	      fairsat = (fairw < 0)    ? {PRICE_W{1'b0}} :
                              (fairw > MAXP) ? {PRICE_W{1'b1}} :
                              fairw[PRICE_W-1:0];

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        f_valid  <= 1'b0;
        f_sym    <= {SYMW{1'b0}};
        f_bid    <= {PRICE_W{1'b0}};
        f_ask    <= {PRICE_W{1'b0}};
        f_mid    <= {PRICE_W{1'b0}};
        f_fair   <= {PRICE_W{1'b0}};
        f_spread <= {(PRICE_W+1){1'b0}};
     end
     else begin
        f_valid  <= b_valid;
        f_sym    <= b_sym;
        f_bid    <= b_bid;
        f_ask    <= b_ask;
        f_mid    <= mid;
        f_fair   <= fairsat;
        f_spread <= spr;
     end

endmodule
