//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft_encoder: packs a passed risk decision into a 512-bit order packet using
// the same simplified layout as the market-data word. order_packet_valid is
// asserted only for real actions (not none). Registered output.
//
// Order layout: [7:0]=action [8+:SYMW]=symbol [16]=side
//               [32+:PRICE_W]=price [64+:QTY_W]=qty
//
//#############################################################################
module hft_encoder #(parameter NSYM = 32,
                     parameter PRICE_W = 32,
                     parameter QTY_W = 16
                     )
   (
    input		     clk,
    input		     nreset,
    input		     r_valid,
    input [$clog2(NSYM)-1:0] r_sym,
    input [2:0]		     r_action,
    input		     r_side,
    input [PRICE_W-1:0]	     r_price,
    input [QTY_W-1:0]	     r_qty,
    output reg		     order_packet_valid,
    output reg [511:0]	     order_packet_word
    );

   localparam SYMW = $clog2(NSYM);
   localparam A_NONE = 3'd0;
   localparam Z1 = 8 - SYMW;             // pad above sym, below side region
   localparam Z3 = 32 - PRICE_W;         // pad above price in its 32-bit slot
   localparam Z4 = 512 - 64 - QTY_W;     // high padding above qty

   // pack fields into the fixed order layout (mirrors the market-data layout)
   wire [511:0]	word = {{Z4{1'b0}}, r_qty, {Z3{1'b0}}, r_price,
                        15'b0, r_side, {Z1{1'b0}}, r_sym, 5'b0, r_action};

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        order_packet_valid <= 1'b0;
        order_packet_word  <= 512'b0;
     end
     else begin
        order_packet_valid <= r_valid & (r_action != A_NONE);
        order_packet_word  <= word;
     end

endmodule
