//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// hft_parser: market-data packet parser. Decodes a 512-bit market-data word
// into book-update fields using a simplified, self-defined binary layout (not
// any proprietary exchange protocol). Registered output.
//
// Message layout (byte-aligned in the 512-bit word):
//   [7:0]      msg_type   (0=noop, 1=update, 2=delete)
//   [8 +:8]    symbol_id  (low SYMW bits used)
//   [16]       side       (0=bid, 1=ask)
//   [24 +:8]   level      (low LVLW bits used)
//   [32 +:32]  price
//   [64 +:16]  qty
//
//#############################################################################
module hft_parser #(parameter NSYM = 32,
                    parameter NLEVEL = 16,
                    parameter PRICE_W = 32,
                    parameter QTY_W = 16
                    )
   (
    input			    clk,
    input			    nreset,
    input			    md_valid,
    input [511:0]		    md_word,
    output reg			    p_valid,
    output reg [7:0]		    p_type,
    output reg [$clog2(NSYM)-1:0]   p_sym,
    output reg			    p_side,
    output reg [$clog2(NLEVEL)-1:0] p_level,
    output reg [PRICE_W-1:0]	    p_price,
    output reg [QTY_W-1:0]	    p_qty
    );

   localparam SYMW = $clog2(NSYM);
   localparam LVLW = $clog2(NLEVEL);

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        p_valid <= 1'b0;
        p_type  <= 8'b0;
        p_sym   <= {SYMW{1'b0}};
        p_side  <= 1'b0;
        p_level <= {LVLW{1'b0}};
        p_price <= {PRICE_W{1'b0}};
        p_qty   <= {QTY_W{1'b0}};
     end
     else begin
        p_valid <= md_valid;
        p_type  <= md_word[7:0];
        p_sym   <= md_word[8 +: SYMW];
        p_side  <= md_word[16];
        p_level <= md_word[24 +: LVLW];
        p_price <= md_word[32 +: PRICE_W];
        p_qty   <= md_word[64 +: QTY_W];
     end

endmodule
