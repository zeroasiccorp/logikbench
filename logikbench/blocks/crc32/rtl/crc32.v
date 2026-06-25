//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Parallel CRC-32 (IEEE 802.3 / 10GbE frame check sequence).
//
// Polynomial 0x04C11DB7, reflected input/output, init 0xFFFFFFFF, final XOR
// 0xFFFFFFFF (the standard Ethernet FCS / CRC-32 used by zlib, check value
// 0xCBF43926 for ASCII "123456789").
//
// Processes W bits per clock (default 64, the 10GbE XGMII datapath). The
// per-bit reflected update is written as a combinational loop that synthesis
// unrolls into the parallel CRC XOR tree. Streaming interface: assert in_valid
// with W bits of data; assert in_last on the final word of a frame. out_crc /
// out_valid present the frame FCS one cycle later. The next valid word after a
// last word starts a new frame (CRC re-initialized).
//
// Byte order: in_data[7:0] is the first byte on the wire, [15:8] the second,
// etc.; bits within a byte are processed LSB first (reflected). Frame length
// must be a multiple of W bits.
//
//#############################################################################

module crc32
  #(parameter W = 64)               // datapath bits per clock (multiple of 8)
   (
    input             clk,
    input             rst,          // synchronous, active high
    input             in_valid,
    input [W-1:0]     in_data,
    input             in_last,      // last word of the frame
    output reg        out_valid,
    output reg [31:0] out_crc       // frame FCS (valid when out_valid)
    );

   localparam [31:0] POLY = 32'hEDB88320;   // reflect(0x04C11DB7)
   localparam [31:0] INIT = 32'hFFFFFFFF;

   reg [31:0] crc;        // running CRC (reflected domain)
   reg        active;     // a frame is in progress

   // Combinational CRC update over W input bits (LSB first, reflected).
   function [31:0] crc_upd;
      input [31:0] cin;
      input [W-1:0] d;
      reg [31:0] c;
      integer    i;
      begin
         c = cin;
         for (i = 0; i < W; i = i + 1)
           c = (c >> 1) ^ (POLY & {32{c[0] ^ d[i]}});
         crc_upd = c;
      end
   endfunction

   wire [31:0] cur   = active ? crc : INIT;   // load INIT at frame start
   wire [31:0] cnext = crc_upd(cur, in_data);

   always @(posedge clk) begin
      if (rst) begin
         crc       <= INIT;
         active    <= 1'b0;
         out_valid <= 1'b0;
         out_crc   <= 32'b0;
      end
      else begin
         out_valid <= 1'b0;
         if (in_valid) begin
            crc    <= cnext;
            active <= ~in_last;          // re-init on the next frame
            if (in_last) begin
               out_valid <= 1'b1;
               out_crc   <= cnext ^ INIT; // final XOR
            end
         end
      end
   end

endmodule
