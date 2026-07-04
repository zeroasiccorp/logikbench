//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// UMI front-end for the LPDDR5 controller (SUMI device endpoint + queues).
//
// Wraps lpddr5 with a Universal Memory Interface (UMI) transaction port: it
// unpacks incoming SUMI request packets {cmd, dstaddr, srcaddr, data} into the
// controller's generic burst requests, and packs read data / write acks back
// into SUMI response packets routed to the original source. One UMI transaction
// maps to one LPDDR5 burst (UMI data width = BL*DQW).
//
//   - request decode (UMI cmd field layout, JESD-independent UMI spec):
//       opcode = cmd[4:0]  (REQ_READ=0x01, REQ_WRITE=0x03, REQ_POSTED=0x05)
//   - per-tag context store keeps {srcaddr, dstaddr, cmd} so a read response
//     can be addressed back to the requester; the controller's read id is the
//     tag.
//   - read data -> RESP_READ packet; acked write -> RESP_WRITE packet (ack on
//     accept); posted write -> no response. Responses flow through an output
//     queue; read responses are never back-pressured (queue >= read in-flight).
//
// The DFI memory-side interface is passed straight through to the PHY.
//
//#############################################################################

module lpddr5_umi
  #(parameter DQW = 16,
    parameter BL = 32,
    parameter NBG = 4,
    parameter NBPG = 4,
    parameter ROWW = 16,
    parameter COLW = 6,
    parameter IDW = 6,
    parameter QD = 4,
    parameter CW = 12,	// controller timing-counter width
    parameter UCW = 32,	// UMI command width
    parameter UAW = 64,	// UMI address width
    // derived
    parameter NB = NBG*NBPG,
    parameter AW = ROWW + $clog2(NBG) + $clog2(NBPG) + COLW,
    parameter DATAW = BL*DQW,
    parameter NLANE = DATAW/32,
    parameter CODEW = NLANE*39
    )
   (
    input		      clk,
    input		      rst,
    // UMI device request (host -> controller)
    input		      udev_req_valid,
    output		      udev_req_ready,
    input [UCW-1:0]	      udev_req_cmd,
    input [UAW-1:0]	      udev_req_dstaddr,
    input [UAW-1:0]	      udev_req_srcaddr,
    input [DATAW-1:0]	      udev_req_data,
    // UMI device response (controller -> host)
    output reg		      udev_resp_valid,
    input		      udev_resp_ready,
    output reg [UCW-1:0]      udev_resp_cmd,
    output reg [UAW-1:0]      udev_resp_dstaddr,
    output reg [UAW-1:0]      udev_resp_srcaddr,
    output reg [DATAW-1:0]    udev_resp_data,
    // DFI memory-side interface (straight through to the PHY)
    output		      dfi_valid,
    output [3:0]	      dfi_cmd,
    output [$clog2(NBG)-1:0]  dfi_bg,
    output [$clog2(NBPG)-1:0] dfi_ba,
    output [ROWW-1:0]	      dfi_addr,
    output		      dfi_cke,
    output		      dfi_wrdata_en,
    output [CODEW-1:0]	      dfi_wrdata,
    input		      dfi_rddata_valid,
    input [CODEW-1:0]	      dfi_rddata,
    output		      ecc_corr,
    output		      ecc_uncorr
    );

   // UMI opcodes (cmd[4:0])
   localparam [4:0] REQ_READ=5'h01, REQ_WRITE=5'h03, REQ_POSTED=5'h05,
		    RESP_READ=5'h02, RESP_WRITE=5'h04;

   wire [4:0]	    req_op   = udev_req_cmd[4:0];
   wire		    is_read  = (req_op == REQ_READ);
   wire		    is_wack  = (req_op == REQ_WRITE);    // write needing an ack
   wire		    is_post  = (req_op == REQ_POSTED);
   wire		    is_write = is_wack | is_post;

   // ---- response output queue ----
   localparam	    RQD = 64, RQW = $clog2(RQD);
   reg [UCW-1:0]    rq_cmd  [0:RQD-1];
   reg [UAW-1:0]    rq_dst  [0:RQD-1];
   reg [UAW-1:0]    rq_src  [0:RQD-1];
   reg [DATAW-1:0]  rq_data [0:RQD-1];
   reg [RQW-1:0]    rq_wr, rq_rd;
   reg [RQW:0]	    rq_cnt;
   wire		    rq_full = (rq_cnt == RQD);

   // ---- per-tag request context (for routing read responses back) ----
   reg [UAW-1:0]    ctx_src [0:(1<<IDW)-1];
   reg [UAW-1:0]    ctx_dst [0:(1<<IDW)-1];
   reg [UCW-1:0]    ctx_cmd [0:(1<<IDW)-1];
   reg [IDW-1:0]    tag;

   // ---- controller host port ----
   wire		    cmd_ready, rsp_valid;
   wire [IDW-1:0]   rsp_id;
   wire [DATAW-1:0] rsp_data;
   reg		    cmd_valid;

   // a read response from the controller is pushed every time rsp_valid is
   // high; size RQD >= controller read in-flight so it never blocks. An acked
   // write pushes its ack on accept, but only on cycles a read isn't pushing.
   wire		    rd_push = rsp_valid;
   wire		    wack_ok = is_wack && !rd_push && !rq_full;
   // accept a request when the controller can take it (and, for acked writes,
   // when an ack slot is available this cycle)
   assign udev_req_ready = !rst && cmd_ready && (is_read || is_post || wack_ok);

   always @* begin
      cmd_valid = udev_req_valid && udev_req_ready;
   end

   lpddr5 #(.DQW(DQW), .BL(BL), .NBG(NBG), .NBPG(NBPG), .ROWW(ROWW),
	    .COLW(COLW), .IDW(IDW), .QD(QD), .CW(CW)) u_ctrl
     (.clk(clk), .rst(rst),
      .cmd_valid(cmd_valid), .cmd_ready(cmd_ready),
      .cmd_write(is_write), .cmd_addr(udev_req_dstaddr[AW-1:0]),
      .cmd_id(tag), .cmd_wdata(udev_req_data),
      .rsp_valid(rsp_valid), .rsp_id(rsp_id), .rsp_data(rsp_data),
      .dfi_valid(dfi_valid), .dfi_cmd(dfi_cmd), .dfi_bg(dfi_bg),
      .dfi_ba(dfi_ba), .dfi_addr(dfi_addr), .dfi_cke(dfi_cke),
      .dfi_wrdata_en(dfi_wrdata_en), .dfi_wrdata(dfi_wrdata),
      .dfi_rddata_valid(dfi_rddata_valid), .dfi_rddata(dfi_rddata),
      .ecc_corr(ecc_corr), .ecc_uncorr(ecc_uncorr));

   reg push_rd, push_wr, pop;
   always @(posedge clk) begin
      if (rst) begin
	 tag <= 0; rq_wr <= 0; rq_rd <= 0; rq_cnt <= 0;
	 udev_resp_valid <= 0; udev_resp_cmd <= 0; udev_resp_dstaddr <= 0;
	 udev_resp_srcaddr <= 0; udev_resp_data <= 0;
      end
      else begin
	 push_rd = 1'b0; push_wr = 1'b0;

	 // accept a request: record context; acked write enqueues its ack
	 if (cmd_valid) begin
	    ctx_src[tag] <= udev_req_srcaddr;
	    ctx_dst[tag] <= udev_req_dstaddr;
	    ctx_cmd[tag] <= udev_req_cmd;
	    if (is_read) tag <= tag + 1'b1;
	    if (wack_ok) begin
	       rq_cmd [rq_wr] <= {udev_req_cmd[UCW-1:5], RESP_WRITE};
	       rq_dst [rq_wr] <= udev_req_srcaddr;
	       rq_src [rq_wr] <= udev_req_dstaddr;
	       rq_data[rq_wr] <= {DATAW{1'b0}};
	       push_wr = 1'b1;
	    end
	 end

	 // read response -> response packet (mutually exclusive with wack push)
	 if (rsp_valid) begin
	    rq_cmd [rq_wr] <= {ctx_cmd[rsp_id][UCW-1:5], RESP_READ};
	    rq_dst [rq_wr] <= ctx_src[rsp_id];
	    rq_src [rq_wr] <= ctx_dst[rsp_id];
	    rq_data[rq_wr] <= rsp_data;
	    push_rd = 1'b1;
	 end

	 if (push_rd || push_wr) rq_wr <= rq_wr + 1'b1;

	 // drain to the response port
	 pop = (rq_cnt != 0) && (!udev_resp_valid || udev_resp_ready);
	 if (pop) begin
	    udev_resp_valid   <= 1'b1;
	    udev_resp_cmd     <= rq_cmd [rq_rd];
	    udev_resp_dstaddr <= rq_dst [rq_rd];
	    udev_resp_srcaddr <= rq_src [rq_rd];
	    udev_resp_data    <= rq_data[rq_rd];
	    rq_rd <= rq_rd + 1'b1;
	 end
	 else if (udev_resp_ready) udev_resp_valid <= 1'b0;

	 rq_cnt <= rq_cnt + (push_rd | push_wr) - pop;
      end
   end

endmodule
