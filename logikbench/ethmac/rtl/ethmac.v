//This wraps up the eth_mac_1g module to hide the unused cfg pin interface
//on the block, reducing the port count by about a factor of 5.

module ethmac
  # (
     parameter DATA_WIDTH = 8,
     parameter ENABLE_PADDING = 1,
     parameter MIN_FRAME_LENGTH = 64,
     parameter PTP_TS_ENABLE = 0,
     parameter PTP_TS_FMT_TOD = 1,
     parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 64,
     parameter TX_PTP_TS_CTRL_IN_TUSER = 0,
     parameter TX_PTP_TAG_ENABLE = PTP_TS_ENABLE,
     parameter TX_PTP_TAG_WIDTH = 16,
     parameter TX_USER_WIDTH = (PTP_TS_ENABLE ? (TX_PTP_TAG_ENABLE ? TX_PTP_TAG_WIDTH : 0) + (TX_PTP_TS_CTRL_IN_TUSER ? 1 : 0) : 0) + 1,
     parameter RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1,
     parameter PFC_ENABLE = 0,
     parameter PAUSE_ENABLE = PFC_ENABLE
     )
   (
    input  wire                         rx_clk,
    input  wire                         rx_rst,
    input  wire                         tx_clk,
    input  wire                         tx_rst,

    /*
     * AXI input
     */
    input  wire [DATA_WIDTH-1:0]        tx_axis_tdata,
    input  wire                         tx_axis_tvalid,
    output wire                         tx_axis_tready,
    input  wire                         tx_axis_tlast,
    input  wire [TX_USER_WIDTH-1:0]     tx_axis_tuser,

    /*
     * AXI output
     */
    output wire [DATA_WIDTH-1:0]        rx_axis_tdata,
    output wire                         rx_axis_tvalid,
    output wire                         rx_axis_tlast,
    output wire [RX_USER_WIDTH-1:0]     rx_axis_tuser,

    /*
     * GMII interface
     */
    input  wire [DATA_WIDTH-1:0]        gmii_rxd,
    input  wire                         gmii_rx_dv,
    input  wire                         gmii_rx_er,
    output wire [DATA_WIDTH-1:0]        gmii_txd,
    output wire                         gmii_tx_en,
    output wire                         gmii_tx_er,

    /*
     * PTP
     */
    input  wire [PTP_TS_WIDTH-1:0]      tx_ptp_ts,
    input  wire [PTP_TS_WIDTH-1:0]      rx_ptp_ts,
    output wire [PTP_TS_WIDTH-1:0]      tx_axis_ptp_ts,
    output wire [TX_PTP_TAG_WIDTH-1:0]  tx_axis_ptp_ts_tag,
    output wire                         tx_axis_ptp_ts_valid,

    /*
     * Link-level Flow Control (LFC) (IEEE 802.3 annex 31B PAUSE)
     */
    input  wire                         tx_lfc_req,
    input  wire                         tx_lfc_resend,
    input  wire                         rx_lfc_en,
    output wire                         rx_lfc_req,
    input  wire                         rx_lfc_ack,

    /*
     * Priority Flow Control (PFC) (IEEE 802.3 annex 31D PFC)
     */
    input  wire [7:0]                   tx_pfc_req,
    input  wire                         tx_pfc_resend,
    input  wire [7:0]                   rx_pfc_en,
    output wire [7:0]                   rx_pfc_req,
    input  wire [7:0]                   rx_pfc_ack,

    /*
     * Pause interface
     */
    input  wire                         tx_lfc_pause_en,
    input  wire                         tx_pause_req,
    output wire                         tx_pause_ack,

    /*
     * Control
     */
    input  wire                         rx_clk_enable,
    input  wire                         tx_clk_enable,
    input  wire                         rx_mii_select,
    input  wire                         tx_mii_select,

    /*
     * Status
     */
    output wire                         tx_start_packet,
    output wire                         tx_error_underflow,
    output wire                         rx_start_packet,
    output wire                         rx_error_bad_frame,
    output wire                         rx_error_bad_fcs,
    output wire                         stat_tx_mcf,
    output wire                         stat_rx_mcf,
    output wire                         stat_tx_lfc_pkt,
    output wire                         stat_tx_lfc_xon,
    output wire                         stat_tx_lfc_xoff,
    output wire                         stat_tx_lfc_paused,
    output wire                         stat_tx_pfc_pkt,
    output wire [7:0]                   stat_tx_pfc_xon,
    output wire [7:0]                   stat_tx_pfc_xoff,
    output wire [7:0]                   stat_tx_pfc_paused,
    output wire                         stat_rx_lfc_pkt,
    output wire                         stat_rx_lfc_xon,
    output wire                         stat_rx_lfc_xoff,
    output wire                         stat_rx_lfc_paused,
    output wire                         stat_rx_pfc_pkt,
    output wire [7:0]                   stat_rx_pfc_xon,
    output wire [7:0]                   stat_rx_pfc_xoff,
    output wire [7:0]                   stat_rx_pfc_paused,

    /*
     * Configuration
     */
    input  wire [7:0]                   cfg_ifg,
    input  wire                         cfg_tx_enable,
    input  wire                         cfg_rx_enable
    );

   eth_mac_1g
     # (
        .DATA_WIDTH(DATA_WIDTH),
        .ENABLE_PADDING(ENABLE_PADDING),
        .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
        .PTP_TS_ENABLE(PTP_TS_ENABLE),
        .PTP_TS_FMT_TOD(PTP_TS_FMT_TOD),
        .PTP_TS_WIDTH(PTP_TS_WIDTH),
        .TX_PTP_TS_CTRL_IN_TUSER(TX_PTP_TS_CTRL_IN_TUSER),
        .TX_PTP_TAG_ENABLE(TX_PTP_TAG_ENABLE),
        .TX_PTP_TAG_WIDTH(TX_PTP_TAG_WIDTH),
        .TX_USER_WIDTH(TX_USER_WIDTH),
        .RX_USER_WIDTH(RX_USER_WIDTH),
        .PFC_ENABLE(PFC_ENABLE),
        .PAUSE_ENABLE(PAUSE_ENABLE)
        )
   eth_mac_1g
     (
      .rx_clk(rx_clk),
      .rx_rst(rx_rst),
      .tx_clk(tx_clk),
      .tx_rst(tx_rst),
      .tx_axis_tdata(tx_axis_tdata),
      .tx_axis_tvalid(tx_axis_tvalid),
      .tx_axis_tready(tx_axis_tready),
      .tx_axis_tlast(tx_axis_tlast),
      .tx_axis_tuser(tx_axis_tuser),
      .rx_axis_tdata(rx_axis_tdata),
      .rx_axis_tvalid(rx_axis_tvalid),
      .rx_axis_tlast(rx_axis_tlast),
      .rx_axis_tuser(rx_axis_tuser),
      .gmii_rxd(gmii_rxd),
      .gmii_rx_dv(gmii_rx_dv),
      .gmii_rx_er(gmii_rx_er),
      .gmii_txd(gmii_txd),
      .gmii_tx_en(gmii_tx_en),
      .gmii_tx_er(gmii_tx_er),
      .tx_ptp_ts(tx_ptp_ts),
      .rx_ptp_ts(rx_ptp_ts),
      .tx_axis_ptp_ts(tx_axis_ptp_ts),
      .tx_axis_ptp_ts_tag(tx_axis_ptp_ts_tag),
      .tx_axis_ptp_ts_valid(tx_axis_ptp_ts_valid),
      .tx_lfc_req(tx_lfc_req),
      .tx_lfc_resend(tx_lfc_resend),
      .rx_lfc_en(rx_lfc_en),
      .rx_lfc_req(rx_lfc_req),
      .rx_lfc_ack(rx_lfc_ack),
      .tx_pfc_req(tx_pfc_req),
      .tx_pfc_resend(tx_pfc_resend),
      .rx_pfc_en(rx_pfc_en),
      .rx_pfc_req(rx_pfc_req),
      .rx_pfc_ack(rx_pfc_ack),
      .tx_lfc_pause_en(tx_lfc_pause_en),
      .tx_pause_req(tx_pause_req),
      .tx_pause_ack(tx_pause_ack),
      .rx_clk_enable(rx_clk_enable),
      .tx_clk_enable(tx_clk_enable),
      .rx_mii_select(rx_mii_select),
      .tx_mii_select(tx_mii_select),
      .tx_start_packet(tx_start_packet),
      .tx_error_underflow(tx_error_underflow),
      .rx_start_packet(rx_start_packet),
      .rx_error_bad_frame(rx_error_bad_frame),
      .rx_error_bad_fcs(rx_error_bad_fcs),
      .stat_tx_mcf(stat_tx_mcf),
      .stat_rx_mcf(stat_rx_mcf),
      .stat_tx_lfc_pkt(stat_tx_lfc_pkt),
      .stat_tx_lfc_xon(stat_tx_lfc_xon),
      .stat_tx_lfc_xoff(stat_tx_lfc_xoff),
      .stat_tx_lfc_paused(stat_tx_lfc_paused),
      .stat_tx_pfc_pkt(stat_tx_pfc_pkt),
      .stat_tx_pfc_xon(stat_tx_pfc_xon),
      .stat_tx_pfc_xoff(stat_tx_pfc_xoff),
      .stat_tx_pfc_paused(stat_tx_pfc_paused),
      .stat_rx_lfc_pkt(stat_rx_lfc_pkt),
      .stat_rx_lfc_xon(stat_rx_lfc_xon),
      .stat_rx_lfc_xoff(stat_rx_lfc_xoff),
      .stat_rx_lfc_paused(stat_rx_lfc_paused),
      .stat_rx_pfc_pkt(stat_rx_pfc_pkt),
      .stat_rx_pfc_xon(stat_rx_pfc_xon),
      .stat_rx_pfc_xoff(stat_rx_pfc_xoff),
      .stat_rx_pfc_paused(stat_rx_pfc_paused),
      .cfg_ifg(cfg_ifg),
      .cfg_tx_enable(cfg_tx_enable),
      .cfg_rx_enable(cfg_rx_enable),
      .cfg_mcf_rx_eth_dst_mcast('h0),
      .cfg_mcf_rx_check_eth_dst_mcast('h0),
      .cfg_mcf_rx_eth_dst_ucast('h0),
      .cfg_mcf_rx_check_eth_dst_ucast('h0),
      .cfg_mcf_rx_eth_src('h0),
      .cfg_mcf_rx_check_eth_src('h0),
      .cfg_mcf_rx_eth_type('h0),
      .cfg_mcf_rx_opcode_lfc('h0),
      .cfg_mcf_rx_check_opcode_lfc('h0),
      .cfg_mcf_rx_opcode_pfc('h0),
      .cfg_mcf_rx_check_opcode_pfc('h0),
      .cfg_mcf_rx_forward('h0),
      .cfg_mcf_rx_enable('h0),
      .cfg_tx_lfc_eth_dst('h0),
      .cfg_tx_lfc_eth_src('h0),
      .cfg_tx_lfc_eth_type('h0),
      .cfg_tx_lfc_opcode('h0),
      .cfg_tx_lfc_en('h0),
      .cfg_tx_lfc_quanta('h0),
      .cfg_tx_lfc_refresh('h0),
      .cfg_tx_pfc_eth_dst('h0),
      .cfg_tx_pfc_eth_src('h0),
      .cfg_tx_pfc_eth_type('h0),
      .cfg_tx_pfc_opcode('h0),
      .cfg_tx_pfc_en('h0),
      .cfg_tx_pfc_quanta('h0),
      .cfg_tx_pfc_refresh('h0),
      .cfg_rx_lfc_opcode('h0),
      .cfg_rx_lfc_en('h0),
      .cfg_rx_pfc_opcode('h0),
      .cfg_rx_pfc_en('h0)
      );


endmodule
