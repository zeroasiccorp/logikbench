//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink: source-synchronous parallel chiplet die-to-die link controller
 * (the digital layer of an AIB/BoW/UCIe-style link), single data rate.
 *
 * Contains a transmit endpoint and a receive endpoint, but they are NOT wired
 * together inside the design: the link (tx_fwclk, tx_data / rx_fwclk, rx_data)
 * is exposed at the top level and closed externally (a testbench, or the far
 * die) with per-lane skew and forwarded-clock flight delay. Three clock
 * domains: tx_clk (transmit core), rx_fwclk (forwarded clock, receive capture),
 * and rx_clk (receive core), with a gray-code async FIFO crossing from the
 * forwarded clock into rx_clk.
 ******************************************************************************/
module chiplink
  #(parameter NLANES = 8,
    parameter DW = 32)
  (
   // transmit endpoint (tx_clk domain)
   input               tx_clk,
   input               tx_rst_n,
   input [DW-1:0]      tx_din,
   input               tx_din_valid,
   output              tx_din_ready,
   // forwarded clock + lane data out (link, driven off tx_clk)
   output              tx_fwclk,
   output [NLANES-1:0] tx_data,
   // receive endpoint
   input               rx_clk,
   input               rx_rst_n,
   input               rx_fwclk, // forwarded clock in (link)
   input [NLANES-1:0]  rx_data,  // lane data in (link)
   output [DW-1:0]     rx_dout,
   output              rx_dout_valid,
   output              rx_aligned
   );

   chiplink_tx #(.NLANES(NLANES), .DW(DW)) u_tx
     (.tx_clk       (tx_clk),
      .tx_rst_n     (tx_rst_n),
      .tx_din       (tx_din),
      .tx_din_valid (tx_din_valid),
      .tx_din_ready (tx_din_ready),
      .tx_fwclk     (tx_fwclk),
      .tx_data      (tx_data));

   chiplink_rx #(.NLANES(NLANES), .DW(DW)) u_rx
     (.rx_clk        (rx_clk),
      .rx_rst_n      (rx_rst_n),
      .rx_fwclk      (rx_fwclk),
      .rx_data       (rx_data),
      .rx_dout       (rx_dout),
      .rx_dout_valid (rx_dout_valid),
      .rx_aligned    (rx_aligned));

endmodule
