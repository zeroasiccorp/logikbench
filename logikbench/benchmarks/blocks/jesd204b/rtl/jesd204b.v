//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// jesd204b: full-duplex JESD204B (Subclass-0-style) link interface, built from
// the LogikBench serial-link modules. The transmit and receive link layers
// share the SYNC handshake internally; the L*10-bit lane symbols are the chip
// boundary (an external SERDES is assumed). Standard feature set: code-group
// synchronization, self-synchronous scrambling, per-lane deskew, and transport
// framing. ILAS and LMFC/deterministic latency are out of scope.
//
//#############################################################################
module jesd204b #(parameter L = 4, // lanes
                  parameter M = 2, // converters
                  parameter N = 16 // sample width
                  )
   (
    input	      clk,
    input	      nreset,
    // transmit
    input [M*N-1:0]   tx_samples,
    input	      tx_valid,
    output	      tx_ready,
    output [L*10-1:0] tx_lanes,
    // receive
    input [L*10-1:0]  rx_lanes,
    output [M*N-1:0]  rx_samples,
    output	      rx_valid,
    output	      synced,
    output	      rx_err
    );

   // SYNC handshake: RX requests sync, TX responds with commas
   wire           sync_n;

   jesd204b_tx #(.L(L), .M(M), .N(N)) u_tx
     (.clk(clk), .nreset(nreset), .sync_n(sync_n),
      .tx_samples(tx_samples), .tx_valid(tx_valid), .tx_ready(tx_ready),
      .tx_lanes(tx_lanes));

   jesd204b_rx #(.L(L), .M(M), .N(N)) u_rx
     (.clk(clk), .nreset(nreset), .rx_lanes(rx_lanes), .sync_n(sync_n),
      .rx_samples(rx_samples), .rx_valid(rx_valid), .synced(synced),
      .rx_err(rx_err));

endmodule
