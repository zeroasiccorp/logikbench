//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Parallel CRC-32 (IEEE 802.3 / 10GbE frame check sequence).
//
// Polynomial 0x04C11DB7, reflected input/output, init 0xFFFFFFFF, final XOR
// 0xFFFFFFFF (the standard Ethernet FCS / CRC-32, check value 0xCBF43926 for
// ASCII "123456789").
//
// Processes W bits per clock (default 64, the 10GbE XGMII datapath). The
// per-bit reflected update is written as a combinational loop that synthesis
// unrolls into the parallel CRC XOR tree; the running CRC is tapped at every
// byte boundary (c_tap[]) so the final, possibly partial, word can fold in
// only its valid bytes.
//
// Streaming interface: assert in_valid with W bits of data. On the LAST word
// of a frame assert in_last and set in_bytes to the number of valid bytes in
// that word (1..W/8); the valid bytes are the low byte lanes (in_data[7:0] is
// byte 0). On non-last words all W/8 bytes are consumed and in_bytes is
// ignored. This supports arbitrary frame byte-lengths (partial final beat).
// out_crc / out_valid present the frame FCS one cycle after the last word.
//
//#############################################################################

module crc32
  #(parameter DW = 64)                  // datapath bits/clock (mult of 8)
   (
    input                  clk,
    input                  rst,      // synchronous, active high
    input                  in_valid,
    input [DW-1:0]         in_data,
    input                  in_last,  // last word of the frame
    input [$clog2(DW/8):0] in_bytes, // valid bytes in last word (1..DW/8)
    output reg             out_valid,
    output reg [31:0]      out_crc   // frame FCS (valid when out_valid)
    );

   localparam BW = DW/8;                // byte lanes

   localparam [31:0] POLY = 32'hEDB88320;   // reflect(0x04C11DB7)
   localparam [31:0] INIT = 32'hFFFFFFFF;

   reg [31:0]	     crc;        // running CRC (reflected domain)
   reg               active;     // a frame is in progress

   wire [31:0]	     cur = active ? crc : INIT;   // load INIT at frame start

   // Running CRC tapped at each byte boundary: c_tap[n] = CRC after folding the
   // low n bytes of in_data. These are intermediate nets of one XOR tree.
   reg [31:0]	     c_tap [0:BW];
   reg [31:0]	     cnext;
   integer	     b, i;

   always @* begin
      c_tap[0] = cur;
      for (b = 0; b < BW; b = b + 1) begin
         c_tap[b+1] = c_tap[b];
         for (i = 0; i < 8; i = i + 1)
           c_tap[b+1] = (c_tap[b+1] >> 1) ^
                  (POLY & {32{c_tap[b+1][0] ^ in_data[b*8 + i]}});
      end
      // last word folds only its valid bytes; full words fold all BW
      cnext = in_last ? c_tap[in_bytes] : c_tap[BW];
   end

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
