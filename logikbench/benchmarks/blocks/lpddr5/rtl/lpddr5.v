//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LPDDR5 memory controller core (JESD209-5 command model, DFI-style PHY port).
//
// A synthesizable, technology-agnostic LPDDR5 controller (no PHY): it takes
// generic read/write burst requests on a valid/ready host port and issues a
// JEDEC LPDDR5 command stream on a DFI-style command/data interface, honoring
// the LPDDR5 bank-group timing model. The (inherently tech-specific) PHY lives
// outside this block and connects at the DFI boundary, as in a real LPDDR5
// controller.
//
// Organization (bank-group mode, NBG groups x NBPG banks):
//   - one lpddr5_bank per bank (open-row + per-bank tRCD/tRAS/tRP/tRC/tRTP/
//     write-recovery tracking), instantiated with generate;
//   - a per-bank request queue (depth QD) so the scheduler can reorder across
//     banks and have several requests outstanding per bank;
//   - cross-bank timing here: tRRD_S/L, rolling tFAW, tCCD_S/L, and read/write
//     bus turnaround (tWTR_S/L, tRTW);
//   - an all-bank auto-refresh engine (tREFI interval, PREA + REFab, tRFCab);
//   - a bank-group-aware open-page scheduler that issues at most one command
//     per CK, preferring ready column commands (which naturally exploits the
//     shorter tCCD_S / tRRD_S between different bank groups).
//
// One host request maps to one LPDDR5 burst (BL columns). Command timing is in
// CK (command-clock) units; defaults are a representative LPDDR5-6400 bin and
// are all overridable parameters. See README for the JEDEC references.
//
//#############################################################################

module lpddr5
  #(parameter DQW = 16,		  // channel DQ width
    parameter BL = 32,		  // burst length (BG mode)
    parameter NBG = 4,		  // number of bank groups
    parameter NBPG = 4,		  // banks per bank group
    parameter ROWW = 16,	  // row address width
    parameter COLW = 6,		  // column address width (in bursts)
    parameter IDW = 6,		  // request id width
    parameter QD = 4,		  // per-bank request queue depth
    // timing (CK units, representative LPDDR5-6400 bin)
    parameter TRCD = 15,
    parameter TRP = 15,
    parameter TRAS = 34,
    parameter TRC = 49,
    parameter TRTP = 6,
    parameter TWRC = 30,	  // write recovery: WL + BL/n + tWR
    parameter TRRD_L = 8,
    parameter TRRD_S = 4,
    parameter TFAW = 20,
    parameter TCCD_L = 8,
    parameter TCCD_S = 4,
    parameter TWTR_L = 16,
    parameter TWTR_S = 8,
    parameter TRTW = 8,
    parameter TRFCAB = 224,
    parameter TREFI = 1950,
    parameter RL = 20,		  // read latency (CK), RD -> dfi_rddata_valid
    parameter WL = 10,		  // write latency (CK), WR -> dfi_wrdata
    parameter CW = 12,		  // timing counter width
    parameter T_PDE = 16,	  // idle CK before power-down entry
    parameter T_SRE = 64,	  // idle CK before self-refresh entry
    parameter TXP = 8,		  // power-down exit latency (CK)
    parameter TXSR = 30,	  // self-refresh exit latency (CK)
    // derived (do not override)
    parameter NB = NBG * NBPG,
    parameter BGW = $clog2(NBG),
    parameter BAW = $clog2(NBPG),
    parameter BIW = BGW + BAW,
    parameter QPW = $clog2(QD),
    parameter AW = ROWW + BGW + BAW + COLW,
    parameter DATAW = BL * DQW,
    parameter NLANE = DATAW / 32, // 32-bit ECC lanes
    parameter CODEW = NLANE * 39  // DFI data carries SEC-DED codes
    )
   (
    input		   clk,
    input		   rst,	      // synchronous, active high
    // host request port (one burst per request)
    input		   cmd_valid,
    output		   cmd_ready,
    input		   cmd_write, // 1=write, 0=read
    input [AW-1:0]	   cmd_addr,  // {row, bg, bank, col}
    input [IDW-1:0]	   cmd_id,
    input [DATAW-1:0]	   cmd_wdata, // write burst data
    // host read response
    output reg		   rsp_valid,
    output reg [IDW-1:0]   rsp_id,
    output reg [DATAW-1:0] rsp_data,
    // DFI-style command interface to the PHY
    output reg		   dfi_valid, // a command is issued this CK
    output reg [3:0]	   dfi_cmd,   // CMD_* (decoded)
    output reg [BGW-1:0]   dfi_bg,
    output reg [BAW-1:0]   dfi_ba,
    output reg [ROWW-1:0]  dfi_addr,  // row (ACT) or column (RD/WR)
    output reg		   dfi_cke,   // clock-enable (low in power-down/SREF)
    // DFI write data (driven ~WL CK after a WR command)
    output reg		   dfi_wrdata_en,
    output reg [CODEW-1:0] dfi_wrdata,
    // DFI read data (returned by the PHY RL CK after a RD command)
    input		   dfi_rddata_valid,
    input [CODEW-1:0]	   dfi_rddata,
    // link-ECC status for the just-returned read response
    output reg		   ecc_corr,  // a single-bit error was corrected
    output reg		   ecc_uncorr // a double-bit error was detected
    );

   localparam COLLO = 0;
   localparam BALO  = COLW;
   localparam BGLO  = COLW + BAW;
   localparam ROWLO = COLW + BAW + BGW;
   // decoded command codes
   localparam [3:0] CMD_NOP = 4'd0, CMD_ACT = 4'd1, CMD_RD = 4'd2,
		    CMD_WR = 4'd3, CMD_PRE = 4'd4, CMD_REF = 4'd5,
		    CMD_PDE = 4'd6, CMD_PDX = 4'd7,   // power-down enter/exit
		    CMD_SRE = 4'd8, CMD_SRX = 4'd9;   // self-refresh enter/exit

   //##########################################################################
   // per-bank request queues (depth QD) : {w,row,col,id,wdata}
   //##########################################################################
   reg		    q_w   [0:NB-1][0:QD-1];
   reg [ROWW-1:0]   q_row [0:NB-1][0:QD-1];
   reg [ROWW-1:0]   q_col [0:NB-1][0:QD-1];
   reg [IDW-1:0]    q_id  [0:NB-1][0:QD-1];
   reg [CODEW-1:0]  q_wd  [0:NB-1][0:QD-1];
   reg [QPW-1:0]    q_wr  [0:NB-1];
   reg [QPW-1:0]    q_rd  [0:NB-1];
   reg [QPW:0]	    q_cnt [0:NB-1];

   // address decode of the incoming request
   wire [COLW-1:0]  a_col = cmd_addr[COLLO +: COLW];
   wire [BIW-1:0]   a_bi  = cmd_addr[BALO  +: BIW];   // {bg,ba}
   wire [ROWW-1:0]  a_row = cmd_addr[ROWLO +: ROWW];

   assign cmd_ready = !rst && (q_cnt[a_bi] != QD);

   //##########################################################################
   // per-bank queue heads (request the scheduler currently sees per bank)
   //##########################################################################
   wire			h_v   [0:NB-1];
   wire			h_w   [0:NB-1];
   wire [ROWW-1:0]	h_row [0:NB-1];
   wire [ROWW-1:0]	h_col [0:NB-1];
   wire [IDW-1:0]	h_id  [0:NB-1];
   wire [CODEW-1:0]	h_wd  [0:NB-1];

   genvar		gh;
   generate
      for (gh = 0; gh < NB; gh = gh + 1) begin : g_head
	 assign h_v[gh]   = (q_cnt[gh] != 0);
	 assign h_w[gh]   = q_w[gh][q_rd[gh]];
	 assign h_row[gh] = q_row[gh][q_rd[gh]];
	 assign h_col[gh] = q_col[gh][q_rd[gh]];
	 assign h_id[gh]  = q_id[gh][q_rd[gh]];
	 assign h_wd[gh]  = q_wd[gh][q_rd[gh]];
      end
   endgenerate

   //##########################################################################
   // per-bank state machines
   //##########################################################################
   wire			row_open [0:NB-1];
   wire [ROWW-1:0]	open_row [0:NB-1];
   wire			can_act  [0:NB-1];
   wire			can_col  [0:NB-1];
   wire			can_pre  [0:NB-1];
   reg			do_act   [0:NB-1];
   reg			do_rd    [0:NB-1];
   reg			do_wr    [0:NB-1];
   reg			do_pre   [0:NB-1];
   reg			do_ref   [0:NB-1];

   genvar		gb;
   generate
      for (gb = 0; gb < NB; gb = gb + 1) begin : g_bank
	 lpddr5_bank #(.ROWW(ROWW), .CW(CW), .TRCD(TRCD), .TRP(TRP),
		       .TRAS(TRAS), .TRC(TRC), .TRTP(TRTP), .TWRC(TWRC),
		       .TRFC(TRFCAB)) u_bank
	   (.clk(clk), .rst(rst),
	    .act_row(h_row[gb]),
	    .do_act(do_act[gb]), .do_rd(do_rd[gb]), .do_wr(do_wr[gb]),
	    .do_pre(do_pre[gb]), .do_ref(do_ref[gb]),
	    .row_open(row_open[gb]), .open_row(open_row[gb]),
	    .can_act(can_act[gb]), .can_col(can_col[gb]), .can_pre(can_pre[gb]));
      end
   endgenerate

   //##########################################################################
   // cross-bank timing trackers (saturating down counters)
   //##########################################################################
   reg [CW-1:0] rrd_s, ccd_s, rtw, wtr_s;
   reg [CW-1:0]	rrd_l [0:NBG-1];
   reg [CW-1:0]	ccd_l [0:NBG-1];
   reg [CW-1:0]	wtr_l [0:NBG-1];
   reg [CW-1:0]	faw  [0:3];
   reg [1:0]	faw_ptr;
   integer	gi;

   wire		faw_ok = (faw[0]==0) || (faw[1]==0) || (faw[2]==0) || (faw[3]==0);

   //##########################################################################
   // refresh engine (all-bank: PREA then REFab)
   //##########################################################################
   localparam [1:0] R_IDLE = 0, R_PRE = 1, R_REF = 2, R_WAIT = 3;
   reg [1:0]	    rstate;
   reg [CW-1:0]	    refi, ref_busy;
   reg		    any_open, all_pre_ok, any_pending;
   always @* begin
      any_open   = 1'b0;
      all_pre_ok = 1'b1;
      any_pending = 1'b0;
      for (gi = 0; gi < NB; gi = gi + 1) begin
	 if (row_open[gi]) any_open = 1'b1;
	 if (row_open[gi] && !can_pre[gi]) all_pre_ok = 1'b0;
	 if (q_cnt[gi] != 0) any_pending = 1'b1;
      end
   end

   //##########################################################################
   // power-management FSM (precharge power-down + self-refresh)
   //##########################################################################
   localparam [1:0] P_ACT = 0, P_PD = 1, P_SREF = 2;
   reg [1:0]	    pstate;
   reg [CW-1:0]	    idle_cnt, xcnt;
   reg		    busy_w;

   //##########################################################################
   // scheduler: classify each bank head, then priority-pick one command per CK
   //##########################################################################
   reg		    c_col [0:NB-1];
   reg		    c_act [0:NB-1];
   reg		    c_pre [0:NB-1];
   reg [BIW-1:0]    sel_col, sel_act, sel_pre, sel_ip;
   reg		    has_col, has_act, has_pre, has_ip;
   integer	    b;

   always @* begin
      has_col = 1'b0; has_act = 1'b0; has_pre = 1'b0; has_ip = 1'b0;
      sel_col = {BIW{1'b0}}; sel_act = {BIW{1'b0}}; sel_pre = {BIW{1'b0}};
      sel_ip  = {BIW{1'b0}};
      for (b = 0; b < NB; b = b + 1) begin
	 c_col[b] = 1'b0; c_act[b] = 1'b0; c_pre[b] = 1'b0;
	 if (h_v[b]) begin
	    if (row_open[b] && (open_row[b] == h_row[b])) begin
	       // page hit -> column command (tCCD + bus turnaround)
	       if (can_col[b] && (ccd_s==0) && (ccd_l[b[BIW-1:BAW]]==0) &&
		   (h_w[b] ? (rtw==0)
		    : ((wtr_s==0) && (wtr_l[b[BIW-1:BAW]]==0))))
		 c_col[b] = 1'b1;
	    end
	    else if (row_open[b]) begin
	       if (can_pre[b]) c_pre[b] = 1'b1;        // page miss -> precharge
	    end
	    else begin
	       if (can_act[b] && (rrd_s==0) && (rrd_l[b[BIW-1:BAW]]==0) &&
		   faw_ok)
		 c_act[b] = 1'b1;                       // idle -> activate
	    end
	 end
	 if (c_col[b] && !has_col) begin has_col=1'b1; sel_col=b[BIW-1:0]; end
	 if (c_act[b] && !has_act) begin has_act=1'b1; sel_act=b[BIW-1:0]; end
	 if (c_pre[b] && !has_pre) begin has_pre=1'b1; sel_pre=b[BIW-1:0]; end
	 // idle-precharge candidate (close open pages before low power)
	 if (row_open[b] && can_pre[b] && !has_ip) begin
	    has_ip=1'b1; sel_ip=b[BIW-1:0];
	 end
      end
   end

   //##########################################################################
   // in-flight read-id fifo and write-data launch fifo
   //##########################################################################
   localparam RDF = 32, RDFW = $clog2(RDF);
   reg [IDW-1:0] ridq [0:RDF-1];
   reg [RDFW:0]	 rid_cnt;
   reg [RDFW-1:0] rid_wr, rid_rd;

   localparam	  WRF = 16, WRFW = $clog2(WRF);
   reg [CODEW-1:0] wdq   [0:WRF-1];
   reg [CW-1:0]	   wdcnt [0:WRF-1];
   reg [WRFW:0]	   wd_cnt;
   reg [WRFW-1:0]  wd_wr, wd_rd;

   reg		   wpush, wpop, rpush, rpop;
   reg		   qpush [0:NB-1];
   reg		   qpop  [0:NB-1];
   integer	   k;

   //##########################################################################
   // link ECC: encode host write data, decode/correct read response data
   //##########################################################################
   wire [CODEW-1:0] wcode;                  // encoded cmd_wdata (per lane)
   wire [DATAW-1:0] rdec;                   // decoded dfi_rddata (per lane)
   wire [NLANE-1:0] lane_corr, lane_uncorr;
   genvar	    ge;
   generate
      for (ge = 0; ge < NLANE; ge = ge + 1) begin : g_ecc
	 lpddr5_ecc_enc u_enc (.data(cmd_wdata[ge*32 +: 32]),
			       .code(wcode[ge*39 +: 39]));
	 lpddr5_ecc_dec u_dec (.code(dfi_rddata[ge*39 +: 39]),
			       .data(rdec[ge*32 +: 32]),
			       .corr(lane_corr[ge]), .uncorr(lane_uncorr[ge]));
      end
   endgenerate

   always @(posedge clk) begin
      if (rst) begin
	 for (k = 0; k < NB; k = k + 1) begin
	    q_wr[k] <= 0; q_rd[k] <= 0; q_cnt[k] <= 0;
	    do_act[k] <= 0; do_rd[k] <= 0; do_wr[k] <= 0;
	    do_pre[k] <= 0; do_ref[k] <= 0;
	 end
	 for (k = 0; k < NBG; k = k + 1) begin
	    rrd_l[k] <= 0; ccd_l[k] <= 0; wtr_l[k] <= 0;
	 end
	 for (k = 0; k < 4; k = k + 1) faw[k] <= 0;
	 for (k = 0; k < WRF; k = k + 1) wdcnt[k] <= 0;
	 rrd_s <= 0; ccd_s <= 0; rtw <= 0; wtr_s <= 0; faw_ptr <= 0;
	 rstate <= R_IDLE; refi <= TREFI[CW-1:0]; ref_busy <= 0;
	 pstate <= P_ACT; idle_cnt <= 0; xcnt <= 0; dfi_cke <= 1'b1;
	 dfi_valid <= 0; dfi_cmd <= CMD_NOP; dfi_bg <= 0; dfi_ba <= 0;
	 dfi_addr <= 0; dfi_wrdata_en <= 0; dfi_wrdata <= 0;
	 rsp_valid <= 0; rsp_id <= 0; rsp_data <= 0;
	 ecc_corr <= 0; ecc_uncorr <= 0;
	 rid_cnt <= 0; rid_wr <= 0; rid_rd <= 0;
	 wd_cnt <= 0; wd_wr <= 0; wd_rd <= 0;
      end
      else begin
	 // ---- defaults ----
	 dfi_valid <= 1'b0; dfi_cmd <= CMD_NOP;
	 dfi_wrdata_en <= 1'b0; rsp_valid <= 1'b0;
	 ecc_corr <= 1'b0; ecc_uncorr <= 1'b0;
	 wpush = 1'b0; wpop = 1'b0; rpush = 1'b0; rpop = 1'b0;
	 for (k = 0; k < NB; k = k + 1) begin
	    do_act[k] <= 0; do_rd[k] <= 0; do_wr[k] <= 0;
	    do_pre[k] <= 0; do_ref[k] <= 0;
	    qpush[k] = 1'b0; qpop[k] = 1'b0;
	 end

	 // ---- decrement cross-bank counters ----
	 if (rrd_s) rrd_s <= rrd_s - 1'b1;
	 if (ccd_s) ccd_s <= ccd_s - 1'b1;
	 if (rtw)   rtw   <= rtw   - 1'b1;
	 if (wtr_s) wtr_s <= wtr_s - 1'b1;
	 for (k = 0; k < NBG; k = k + 1) begin
	    if (rrd_l[k]) rrd_l[k] <= rrd_l[k] - 1'b1;
	    if (ccd_l[k]) ccd_l[k] <= ccd_l[k] - 1'b1;
	    if (wtr_l[k]) wtr_l[k] <= wtr_l[k] - 1'b1;
	 end
	 for (k = 0; k < 4; k = k + 1) if (faw[k]) faw[k] <= faw[k] - 1'b1;
	 if (ref_busy) ref_busy <= ref_busy - 1'b1;
	 if (refi && (pstate != P_SREF)) refi <= refi - 1'b1;  // paused in SREF

	 // ---- host request accept (push to target bank queue) ----
	 if (cmd_valid && cmd_ready) begin
	    q_w  [a_bi][q_wr[a_bi]] <= cmd_write;
	    q_row[a_bi][q_wr[a_bi]] <= a_row;
	    q_col[a_bi][q_wr[a_bi]] <= {{(ROWW-COLW){1'b0}}, a_col};
	    q_id [a_bi][q_wr[a_bi]] <= cmd_id;
	    q_wd [a_bi][q_wr[a_bi]] <= wcode;       // store ECC-encoded data
	    q_wr[a_bi] <= q_wr[a_bi] + 1'b1;
	    qpush[a_bi] = 1'b1;
	 end

	 // ---- idle tracking ----
	 busy_w = has_col || has_act || has_pre || (rstate != R_IDLE) ||
		  any_pending || (rid_cnt != 0) || (wd_cnt != 0);
	 if (busy_w) idle_cnt <= 0;
	 else if (idle_cnt != {CW{1'b1}}) idle_cnt <= idle_cnt + 1'b1;

	 // ---- power management + command issue ----
	 if (pstate == P_PD) begin
	    if (any_pending || (refi <= TXP[CW-1:0])) begin
	       dfi_valid <= 1'b1; dfi_cmd <= CMD_PDX; dfi_cke <= 1'b1;
	       xcnt <= TXP[CW-1:0]; pstate <= P_ACT;
	    end
	    else if (idle_cnt >= T_SRE[CW-1:0]) begin
	       dfi_valid <= 1'b1; dfi_cmd <= CMD_SRE; pstate <= P_SREF;
	    end
	 end
	 else if (pstate == P_SREF) begin
	    if (any_pending) begin
	       dfi_valid <= 1'b1; dfi_cmd <= CMD_SRX; dfi_cke <= 1'b1;
	       xcnt <= TXSR[CW-1:0]; pstate <= P_ACT; refi <= TREFI[CW-1:0];
	    end
	 end
	 else if (xcnt != 0) begin
	    xcnt <= xcnt - 1'b1;            // exit latency: issue nothing
	 end
	 else if (!any_pending && (rstate == R_IDLE) &&
		  (idle_cnt >= T_PDE[CW-1:0]) && (refi > (TXP[CW-1:0] + 3'd4))) begin
	    if (any_open) begin
	       if (has_ip) begin               // close open pages first
		  do_pre[sel_ip] <= 1'b1;
		  dfi_valid <= 1'b1; dfi_cmd <= CMD_PRE;
		  dfi_bg <= sel_ip[BIW-1:BAW]; dfi_ba <= sel_ip[BAW-1:0];
		  dfi_addr <= {ROWW{1'b0}};
	       end
	    end
	    else begin                          // all idle -> power down
	       dfi_valid <= 1'b1; dfi_cmd <= CMD_PDE; dfi_cke <= 1'b0;
	       pstate <= P_PD;
	    end
	 end
	 // ---- refresh / command issue ----
	 else if (rstate != R_IDLE) begin
	    case (rstate)
	      R_PRE: begin
		 if (!any_open) rstate <= R_REF;
		 else if (all_pre_ok) begin    // tRAS-safe PREA (one command)
		    for (k = 0; k < NB; k = k + 1)
		      if (row_open[k]) do_pre[k] <= 1'b1;
		    dfi_valid <= 1'b1; dfi_cmd <= CMD_PRE;
		    dfi_addr  <= {ROWW{1'b1}};
		    rstate <= R_REF;
		 end
	      end
	      R_REF: begin
		 if (!any_open) begin
		    dfi_valid <= 1'b1; dfi_cmd <= CMD_REF;
		    ref_busy  <= TRFCAB[CW-1:0];
		    rstate    <= R_WAIT;
		 end
	      end
	      R_WAIT: if (ref_busy <= 1) begin
		 rstate <= R_IDLE; refi <= TREFI[CW-1:0];
	      end
	      default: rstate <= R_IDLE;
	    endcase
	 end
	 else if (refi == 0) begin
	    rstate <= R_PRE;
	 end
	 else if (has_col) begin
	    dfi_valid <= 1'b1;
	    dfi_bg    <= sel_col[BIW-1:BAW];
	    dfi_ba    <= sel_col[BAW-1:0];
	    dfi_addr  <= h_col[sel_col];
	    ccd_s     <= TCCD_S[CW-1:0];
	    ccd_l[sel_col[BIW-1:BAW]] <= TCCD_L[CW-1:0];
	    q_rd[sel_col] <= q_rd[sel_col] + 1'b1;   // pop serviced request
	    qpop[sel_col] = 1'b1;
	    if (h_w[sel_col]) begin
	       do_wr[sel_col] <= 1'b1; dfi_cmd <= CMD_WR;
	       rtw <= TRTW[CW-1:0];
	       wdq[wd_wr]   <= h_wd[sel_col];
	       wdcnt[wd_wr] <= WL[CW-1:0];
	       wd_wr <= wd_wr + 1'b1; wpush = 1'b1;
	    end
	    else begin
	       do_rd[sel_col] <= 1'b1; dfi_cmd <= CMD_RD;
	       wtr_s <= TWTR_S[CW-1:0];
	       wtr_l[sel_col[BIW-1:BAW]] <= TWTR_L[CW-1:0];
	       ridq[rid_wr] <= h_id[sel_col];
	       rid_wr <= rid_wr + 1'b1; rpush = 1'b1;
	    end
	 end
	 else if (has_act && !ref_busy) begin
	    do_act[sel_act] <= 1'b1;
	    dfi_valid <= 1'b1; dfi_cmd <= CMD_ACT;
	    dfi_bg <= sel_act[BIW-1:BAW]; dfi_ba <= sel_act[BAW-1:0];
	    dfi_addr <= h_row[sel_act];
	    rrd_s <= TRRD_S[CW-1:0];
	    rrd_l[sel_act[BIW-1:BAW]] <= TRRD_L[CW-1:0];
	    faw[faw_ptr] <= TFAW[CW-1:0];
	    faw_ptr <= faw_ptr + 1'b1;
	 end
	 else if (has_pre) begin
	    do_pre[sel_pre] <= 1'b1;
	    dfi_valid <= 1'b1; dfi_cmd <= CMD_PRE;
	    dfi_bg <= sel_pre[BIW-1:BAW]; dfi_ba <= sel_pre[BAW-1:0];
	    dfi_addr <= {ROWW{1'b0}};
	 end

	 // ---- write-data launch (decrement all in-flight, launch head) ----
	 for (k = 0; k < WRF; k = k + 1)
	   if (wdcnt[k] != 0) wdcnt[k] <= wdcnt[k] - 1'b1;
	 if ((wd_cnt != 0) && (wdcnt[wd_rd] <= 1)) begin
	    dfi_wrdata_en <= 1'b1;
	    dfi_wrdata    <= wdq[wd_rd];
	    wd_rd <= wd_rd + 1'b1; wpop = 1'b1;
	 end

	 // ---- read-data return (in order, on dfi_rddata_valid) ----
	 if (dfi_rddata_valid && (rid_cnt != 0)) begin
	    rsp_valid  <= 1'b1;
	    rsp_id     <= ridq[rid_rd];
	    rsp_data   <= rdec;                 // ECC-decoded/corrected data
	    ecc_corr   <= |lane_corr;
	    ecc_uncorr <= |lane_uncorr;
	    rid_rd     <= rid_rd + 1'b1; rpop = 1'b1;
	 end

	 // ---- fifo occupancy (combine simultaneous push/pop) ----
	 wd_cnt  <= wd_cnt  + wpush - wpop;
	 rid_cnt <= rid_cnt + rpush - rpop;
	 for (k = 0; k < NB; k = k + 1)
	   q_cnt[k] <= q_cnt[k] + qpush[k] - qpop[k];
      end
   end

endmodule
