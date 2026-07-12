//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LZ77 (LZSS) DECODER. Consumes tokens (literal or {len,dist} match) and
// reconstructs the byte stream into a WIN-byte circular output history. A
// literal writes one byte; a match copies len bytes from dist back. The history
// is a single-port SRAM (la_spram, half the ASIC area of dual-port), so a copy
// takes two cycles per byte: a read cycle (fetch the source byte) then a write
// cycle (store + emit). The one-cycle gap removes the read-after-write hazard,
// so overlap (dist < len, RLE) needs no forwarding. Tokens in (valid/ready),
// bytes out (valid).
//
//#############################################################################

module lz77_dec
  #(parameter WIN = 32768,
    parameter LENW = 7,
    parameter AW = 15,
    parameter PW = 16)
   (
    input            clk,
    input            rst,
    input            in_valid,
    input            in_match,
    input [7:0]      in_lit,
    input [LENW-1:0] in_len,
    input [AW-1:0]   in_dist,
    output           in_ready,
    output reg       out_valid,
    output reg [7:0] out_byte
    );

   localparam D_IDLE = 2'd0, D_RD = 2'd1, D_WR = 2'd2;

   reg [1:0]      state;
   reg [PW-1:0]   outpos;
   reg [PW-1:0]   ra;          // source read pointer (absolute)
   reg [LENW-1:0] copyrem;

   // single-port output history SRAM
   reg            ce, we;
   reg [AW-1:0]   addr;
   reg [7:0]      din;
   wire [7:0]     dout;

   la_spram #(.DW(8), .AW(AW), .BYTEMASK(0)) u_obuf
     (.clk(clk), .ce(ce), .we(we), .wmask(8'hFF), .addr(addr), .din(din),
      .dout(dout), .selctrl(1'b0), .ctrl('b0), .status());

   assign in_ready = (state == D_IDLE);

   // SRAM port: literal/copy write at outpos, copy source read at ra
   always @* begin
      ce = 1'b0; we = 1'b0; addr = outpos[AW-1:0]; din = 8'b0;
      if (state == D_IDLE && in_valid && !in_match) begin
         ce = 1'b1; we = 1'b1; din = in_lit;
      end else if (state == D_RD) begin
         ce = 1'b1; we = 1'b0; addr = ra[AW-1:0];
      end else if (state == D_WR) begin
         ce = 1'b1; we = 1'b1; din = dout;
      end
   end

   always @(posedge clk) begin
      if (rst) begin
         state <= D_IDLE; outpos <= 0; ra <= 0; copyrem <= 0;
         out_valid <= 1'b0; out_byte <= 8'b0;
      end else begin
         out_valid <= 1'b0;
         case (state)
           D_IDLE: begin
              if (in_valid) begin
                 if (in_match) begin
                    ra      <= outpos - {{(PW-AW){1'b0}}, in_dist};
                    copyrem <= in_len;
                    state   <= D_RD;
                 end else begin
                    out_byte  <= in_lit;
                    out_valid <= 1'b1;
                    outpos    <= outpos + 1'b1;
                 end
              end
           end
           D_RD: begin
              state <= D_WR;             // dout (source byte) valid next cycle
           end
           D_WR: begin
              out_byte  <= dout;
              out_valid <= 1'b1;
              outpos    <= outpos + 1'b1;
              ra        <= ra + 1'b1;
              copyrem   <= copyrem - 7'd1;
              state     <= (copyrem == 7'd1) ? D_IDLE : D_RD;
           end
         endcase
      end
   end

endmodule
