//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// gearbox66: 64b/66b link encode/decode datapath. A 64-bit payload is
// self-synchronously scrambled (x^58 + x^39 + 1), tagged with a 2-bit sync
// header (01=data, 10=control) to form a 66-bit block, and repacked by a
// 66->64 bit gearbox into a 64-bit stream. The stream is looped back through a
// 64->66 gearbox, the header is checked, and the payload descrambled. The
// round trip recovers the original payload.
//
//#############################################################################
module gearbox66
  (
   input	     clk,
   input	     nreset,
   input	     tx_valid, // present a payload
   input [63:0]	     tx_data,  // payload
   input	     tx_ctrl,  // 1 = control block (header 10)
   output	     tx_ready, // gearbox can accept a payload
   output reg [63:0] rx_data,  // recovered payload
   output reg	     rx_ctrl,  // recovered header type
   output reg	     rx_valid, // recovered payload valid
   output reg	     rx_herr   // illegal sync header
   );

   wire           accept = tx_valid & tx_ready;

   // TX self-synchronous scrambler
   wire [63:0]	  tx_scr;
   scram64 u_scr (.clk(clk), .nreset(nreset), .en(accept),
                  .din(tx_data), .scr(tx_scr));

   // form 66-bit block: {scrambled[63:0], header[1:0]}
   wire [1:0]     tx_hdr = tx_ctrl ? 2'b10 : 2'b01;
   wire [65:0]	  tx_blk = {tx_scr, tx_hdr};

   // 66 -> 64 gearbox
   wire		  gb_valid;
   wire [63:0]	  gb_data;
   gbpack u_pack (.clk(clk), .nreset(nreset), .in_valid(accept),
                  .in66(tx_blk), .ready(tx_ready),
                  .out_valid(gb_valid), .out64(gb_data));

   // 64 -> 66 gearbox (loopback)
   wire           rx_bvalid;
   wire [65:0]	  rx_blk;
   gbunpack u_unpack (.clk(clk), .nreset(nreset), .in_valid(gb_valid),
                      .in64(gb_data), .out_valid(rx_bvalid), .out66(rx_blk));

   // RX descramble
   wire [1:0]     rx_hdr = rx_blk[1:0];
   wire [63:0]	  rx_scr = rx_blk[65:2];
   wire [63:0]	  rx_dsc;
   descram64 u_dscr (.clk(clk), .nreset(nreset), .en(rx_bvalid),
                     .din(rx_scr), .dout(rx_dsc));

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        rx_data <= 64'b0;
        rx_ctrl <= 1'b0;
        rx_valid <= 1'b0;
        rx_herr <= 1'b0;
     end
     else begin
        rx_data <= rx_dsc;
        rx_ctrl <= (rx_hdr == 2'b10);
        rx_valid <= rx_bvalid;
        rx_herr <= rx_bvalid & ~((rx_hdr == 2'b01) | (rx_hdr == 2'b10));
     end

endmodule

//#############################################################################
// Self-synchronous scrambler, G(x) = 1 + x^39 + x^58, 64-bit parallel.
//#############################################################################
module scram64
  (
   input	 clk,
   input	 nreset,
   input	 en,
   input [63:0]	 din,
   output [63:0] scr
   );

   reg [57:0]    state;
   wire [57:0]	 st [0:64];
   assign st[0] = state;

   genvar        i;
   generate
      for (i = 0; i < 64; i = i + 1) begin : g_scr
         assign scr[i]  = din[i] ^ st[i][38] ^ st[i][57];
         assign st[i+1] = {st[i][56:0], scr[i]};
      end
   endgenerate

   always @(posedge clk or negedge nreset)
     if (!nreset) state <= 58'b0;
     else if (en) state <= st[64];

endmodule

//#############################################################################
// Self-synchronous descrambler, matches scram64 (state fed by received bits).
//#############################################################################
module descram64
  (
   input	 clk,
   input	 nreset,
   input	 en,
   input [63:0]	 din,
   output [63:0] dout
   );

   reg [57:0]    state;
   wire [57:0]	 st [0:64];
   wire [63:0]	 dsc;
   assign st[0] = state;

   genvar        i;
   generate
      for (i = 0; i < 64; i = i + 1) begin : g_dsc
         assign dsc[i]  = din[i] ^ st[i][38] ^ st[i][57];
         assign st[i+1] = {st[i][56:0], din[i]};
      end
   endgenerate

   assign dout = dsc;                 // combinational; top registers it

   always @(posedge clk or negedge nreset)
     if (!nreset) state <= 58'b0;
     else if (en) state <= st[64];

endmodule

//#############################################################################
// 66 -> 64 bit gearbox (LSB-first accumulator).
//#############################################################################
module gbpack
  (
   input	     clk,
   input	     nreset,
   input	     in_valid,
   input [65:0]	     in66,
   output	     ready,
   output reg	     out_valid,
   output reg [63:0] out64
   );

   reg [131:0]   acc;
   reg [7:0]	 cnt;

   assign ready = (cnt <= 8'd66);

   wire          take = in_valid & ready;
   wire [131:0]	 acc_in = take ? (acc | ({66'b0, in66} << cnt)) : acc;
   wire [7:0]	 cnt_in = take ? (cnt + 8'd66) : cnt;
   wire		 emit   = (cnt_in >= 8'd64);

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        acc       <= 132'b0;
        cnt       <= 8'b0;
        out64     <= 64'b0;
        out_valid <= 1'b0;
     end
     else begin
        out64     <= acc_in[63:0];
        out_valid <= emit;
        acc       <= emit ? (acc_in >> 64) : acc_in;
        cnt       <= emit ? (cnt_in - 8'd64) : cnt_in;
     end

endmodule

//#############################################################################
// 64 -> 66 bit gearbox (LSB-first accumulator, inverse of gbpack).
//#############################################################################
module gbunpack
  (
   input	     clk,
   input	     nreset,
   input	     in_valid,
   input [63:0]	     in64,
   output reg	     out_valid,
   output reg [65:0] out66
   );

   reg [131:0]   acc;
   reg [7:0]	 cnt;

   wire [131:0]	 acc_in = in_valid ? (acc | ({68'b0, in64} << cnt)) : acc;
   wire [7:0]	 cnt_in = in_valid ? (cnt + 8'd64) : cnt;
   wire		 emit   = (cnt_in >= 8'd66);

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        acc       <= 132'b0;
        cnt       <= 8'b0;
        out66     <= 66'b0;
        out_valid <= 1'b0;
     end
     else begin
        out66     <= acc_in[65:0];
        out_valid <= emit;
        acc       <= emit ? (acc_in >> 66) : acc_in;
        cnt       <= emit ? (cnt_in - 8'd66) : cnt_in;
     end

endmodule
