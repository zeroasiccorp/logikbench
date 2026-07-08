//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// jesd204b_tx: JESD204B transmit link layer. While the link is not synced
// (sync_n=0) every lane sends the K.28.5 comma (code-group synchronization).
// Once synced, samples are framed (transport map), scrambled per lane, and
// 8b/10b encoded. A pipeline bubble sends a comma until real octets are ready,
// so the receiver simply ignores commas between data.
//
//#############################################################################
module jesd204b_tx #(parameter L = 4, // lanes
                     parameter M = 2, // converters
                     parameter N = 16 // sample width
                     )
   (
    input	      clk,
    input	      nreset,
    input	      sync_n,	  // 1 = synced (send data), 0 = send commas
    input [M*N-1:0]   tx_samples, // samples to transmit
    input	      tx_valid,
    output	      tx_ready,
    output [L*10-1:0] tx_lanes	  // 10-bit symbol per lane
    );

   localparam SMPW = M*N;

   wire	      data_mode = sync_n;
   assign         tx_ready = data_mode;
   wire           accept = data_mode & tx_valid;

   // transport framer: samples -> octets (one per lane), registered
   wire [SMPW-1:0] octets;
   linkmap #(.M(M), .S(1), .N(N), .L(L)) u_frame
     (.clk(clk), .nreset(nreset), .smp_in(tx_samples), .lane_out(octets),
      .lane_in({SMPW{1'b0}}), .smp_out());

   // octets are valid one cycle after a sample is accepted
   reg            vld_oct;
   always @(posedge clk or negedge nreset)
     if (!nreset) vld_oct <= 1'b0;
     else         vld_oct <= accept;

   // per-lane scramble + 8b/10b encode (comma when no data octet is ready)
   genvar         l;
   generate
      for (l = 0; l < L; l = l + 1) begin : g_lane
         wire [7:0] oct = octets[l*8 +: 8];
         wire [7:0] scr;
         wire [9:0] sym;
         jscram8 u_scr (.clk(clk), .nreset(nreset), .en(vld_oct),
                        .din(oct), .scr(scr));
         enc8b10b u_enc (.clk(clk), .nreset(nreset), .k(~vld_oct),
                         .din(scr), .dout(sym));
         assign tx_lanes[l*10 +: 10] = sym;
      end
   endgenerate

endmodule
