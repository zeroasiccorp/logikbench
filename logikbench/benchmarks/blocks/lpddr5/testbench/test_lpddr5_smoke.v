//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for the full LPDDR5 stack: lpddr5_umi (UMI front-end + queues
// + controller) on the host side, a behavioral DFI-layer LPDDR5 model on the
// memory side. Self-checking.
//
// The DFI model (a) stores write data / returns read data (ECC-coded link), and
// (b) checks the command stream against the JEDEC LPDDR5 timing model (tRCD/
// tRP/tRAS/tRC/tRRD_S-L/tFAW/tCCD_S-L/tWTR_S-L/tRTW/tRTP/write-recovery + the
// protocol rules) and power-management protocol (no command in PD/SREF, tXP/
// tXSR exit windows, REF/PDE/SRE only when precharged).
//
// Drives UMI transactions: posted writes spread across banks/groups; reads back
// (clean pass and an injected single-bit link-error pass -> SEC corrects);
// acked writes (RESP_WRITE). Checks UMI response data, opcode and routing,
// zero timing violations, zero uncorrectable ECC, and that PD/SREF were used.
//
//#############################################################################
`timescale 1ns/1ps
module test_lpddr5_smoke;
   localparam DQW=8, BL=4, NBG=2, NBPG=2, ROWW=4, COLW=3, IDW=5, QD=4;
   localparam BGW=1, BAW=1, NB=NBG*NBPG, AW=ROWW+BGW+BAW+COLW, DATAW=BL*DQW;
   localparam NLANE=DATAW/32, CODEW=NLANE*39, UCW=32, UAW=64;
   localparam TRCD=4, TRP=4, TRAS=8, TRC=12, TRTP=2, TWRC=6,
	      TRRD_L=4, TRRD_S=2, TFAW=10, TCCD_L=4, TCCD_S=2,
	      TWTR_L=6, TWTR_S=3, TRTW=3, TRFCAB=20, TREFI=400,
	      RL=8, WL=4, CW=10, T_PDE=8, T_SRE=24, TXP=4, TXSR=12;
   localparam [4:0] REQ_READ=5'h01, REQ_WRITE=5'h03, REQ_POSTED=5'h05,
		    RESP_READ=5'h02, RESP_WRITE=5'h04;

   reg		    clk=0, rst=1;
   reg		    udev_req_valid;
   reg [UCW-1:0]    udev_req_cmd;
   reg [UAW-1:0]    udev_req_dstaddr, udev_req_srcaddr;
   reg [DATAW-1:0]  udev_req_data;
   wire		    udev_req_ready, udev_resp_valid;
   wire [UCW-1:0]   udev_resp_cmd;
   wire [UAW-1:0]   udev_resp_dstaddr, udev_resp_srcaddr;
   wire [DATAW-1:0] udev_resp_data;
   reg		    udev_resp_ready;
   wire		    dfi_valid, dfi_wrdata_en, ecc_corr, ecc_uncorr, dfi_cke;
   wire [3:0]	    dfi_cmd;
   wire [BGW-1:0]   dfi_bg;
   wire [BAW-1:0]   dfi_ba;
   wire [ROWW-1:0]  dfi_addr;
   wire [CODEW-1:0] dfi_wrdata;
   reg		    dfi_rddata_valid;
   reg [CODEW-1:0]  dfi_rddata;
   always #5 clk = ~clk;

   lpddr5_umi #(.DQW(DQW), .BL(BL), .NBG(NBG), .NBPG(NBPG), .ROWW(ROWW),
		.COLW(COLW), .IDW(IDW), .QD(QD), .CW(CW), .UCW(UCW), .UAW(UAW)) dut
     (.clk(clk), .rst(rst),
      .udev_req_valid(udev_req_valid), .udev_req_ready(udev_req_ready),
      .udev_req_cmd(udev_req_cmd), .udev_req_dstaddr(udev_req_dstaddr),
      .udev_req_srcaddr(udev_req_srcaddr), .udev_req_data(udev_req_data),
      .udev_resp_valid(udev_resp_valid), .udev_resp_ready(udev_resp_ready),
      .udev_resp_cmd(udev_resp_cmd), .udev_resp_dstaddr(udev_resp_dstaddr),
      .udev_resp_srcaddr(udev_resp_srcaddr), .udev_resp_data(udev_resp_data),
      .dfi_valid(dfi_valid), .dfi_cmd(dfi_cmd), .dfi_bg(dfi_bg), .dfi_ba(dfi_ba),
      .dfi_addr(dfi_addr), .dfi_cke(dfi_cke), .dfi_wrdata_en(dfi_wrdata_en),
      .dfi_wrdata(dfi_wrdata), .dfi_rddata_valid(dfi_rddata_valid),
      .dfi_rddata(dfi_rddata), .ecc_corr(ecc_corr), .ecc_uncorr(ecc_uncorr));

   localparam [3:0] CMD_ACT=1, CMD_RD=2, CMD_WR=3, CMD_PRE=4, CMD_REF=5,
		    CMD_PDE=6, CMD_PDX=7, CMD_SRE=8, CMD_SRX=9;

   // ---- DFI model (timing + power checks, data store/return, ECC link) ----
   reg [CODEW-1:0]  mem [0:(1<<(BGW+BAW+ROWW+COLW))-1];
   reg		    m_active [0:NB-1];
   reg [ROWW-1:0]   m_row    [0:NB-1];
   integer	    t_act [0:NB-1], t_rd [0:NB-1], t_wr [0:NB-1], t_pre [0:NB-1];
   integer	    t_actbg [0:NBG-1], t_colbg [0:NBG-1], t_wrbg [0:NBG-1];
   integer	    t_actany, t_colany, t_rdany, t_wrany, t_ref;
   integer	    faw_hist [0:3];
   integer	    faw_p, now, terr, b2;
   reg [BGW+BAW-1:0] cbi;
   reg		     m_inject;
   integer	     m_pstate, xtimer, pd_seen, sref_seen;
   integer	     wa_q [0:31]; integer wa_head, wa_tail;
   reg		   rpv [0:RL]; reg [CODEW-1:0] rpd [0:RL]; integer rp;

   task chk;
      input cond; input [8*10-1:0] nm;
      begin if (!cond) begin terr=terr+1;
	 $display("TIMING/PWR VIOLATION %0s at cycle %0d (cmd=%0d)",nm,now,dfi_cmd);
      end end
   endtask

   always @(posedge clk) begin
      if (rst) begin
	 now<=0; faw_p<=0; wa_head<=0; wa_tail<=0; dfi_rddata_valid<=0;
	 m_pstate<=0; xtimer<=0; pd_seen<=0; sref_seen<=0;
	 for (b2=0;b2<NB;b2=b2+1) begin
	    m_active[b2]<=0; t_act[b2]<=-1000; t_rd[b2]<=-1000;
	    t_wr[b2]<=-1000; t_pre[b2]<=-1000; end
	 for (b2=0;b2<NBG;b2=b2+1) begin
	    t_actbg[b2]<=-1000; t_colbg[b2]<=-1000; t_wrbg[b2]<=-1000; end
	 for (b2=0;b2<4;b2=b2+1) faw_hist[b2]<=-1000;
	 t_actany<=-1000; t_colany<=-1000; t_rdany<=-1000; t_wrany<=-1000;
	 t_ref<=-1000;
	 for (b2=0;b2<=RL;b2=b2+1) rpv[b2]<=0;
      end
      else begin
	 now <= now + 1;
	 if (xtimer) xtimer <= xtimer - 1;
	 cbi = {dfi_bg, dfi_ba};
	 if (dfi_valid) begin
	    if (dfi_cmd >= CMD_ACT && dfi_cmd <= CMD_REF) begin
	       chk(m_pstate==0, "lowpwrcmd"); chk(xtimer==0, "xexit"); end
	    case (dfi_cmd)
	      CMD_ACT: begin
		 chk(!m_active[cbi],            "actactive");
		 chk(now-t_act[cbi]>=TRC,       "tRC");
		 chk(now-t_pre[cbi]>=TRP,       "tRP");
		 chk(now-t_actany>=TRRD_S,      "tRRD_S");
		 chk(now-t_actbg[dfi_bg]>=TRRD_L,"tRRD_L");
		 chk(now-faw_hist[faw_p]>=TFAW, "tFAW");
		 chk(now-t_ref>=TRFCAB,         "tRFCab");
		 m_active[cbi]<=1; m_row[cbi]<=dfi_addr;
		 t_act[cbi]<=now; t_actany<=now; t_actbg[dfi_bg]<=now;
		 faw_hist[faw_p]<=now; faw_p<=(faw_p+1)&3;
	      end
	      CMD_RD: begin
		 chk(m_active[cbi],             "rdidle");
		 chk(now-t_act[cbi]>=TRCD,      "tRCD");
		 chk(now-t_colany>=TCCD_S,      "tCCD_S");
		 chk(now-t_colbg[dfi_bg]>=TCCD_L,"tCCD_L");
		 chk(now-t_wrany>=TWTR_S,       "tWTR_S");
		 chk(now-t_wrbg[dfi_bg]>=TWTR_L,"tWTR_L");
		 t_colany<=now; t_colbg[dfi_bg]<=now; t_rd[cbi]<=now; t_rdany<=now;
		 rpv[0]<=1; rpd[0]<=mem[{cbi,m_row[cbi],dfi_addr[COLW-1:0]}];
	      end
	      CMD_WR: begin
		 chk(m_active[cbi],             "wridle");
		 chk(now-t_act[cbi]>=TRCD,      "tRCD");
		 chk(now-t_colany>=TCCD_S,      "tCCD_S");
		 chk(now-t_colbg[dfi_bg]>=TCCD_L,"tCCD_L");
		 chk(now-t_rdany>=TRTW,         "tRTW");
		 t_colany<=now; t_colbg[dfi_bg]<=now; t_wr[cbi]<=now;
		 t_wrany<=now; t_wrbg[dfi_bg]<=now;
		 wa_q[wa_tail]<={cbi,m_row[cbi],dfi_addr[COLW-1:0]};
		 wa_tail<=(wa_tail+1)%32;
	      end
	      CMD_PRE: begin
		 if (&dfi_addr) begin
		    for (b2=0;b2<NB;b2=b2+1) if (m_active[b2]) begin
		       chk(now-t_act[b2]>=TRAS,"tRAS"); chk(now-t_rd[b2]>=TRTP,"tRTP");
		       chk(now-t_wr[b2]>=TWRC,"tWRC"); m_active[b2]<=0; t_pre[b2]<=now;
		    end
		 end else if (m_active[cbi]) begin
		    chk(now-t_act[cbi]>=TRAS,"tRAS"); chk(now-t_rd[cbi]>=TRTP,"tRTP");
		    chk(now-t_wr[cbi]>=TWRC,"tWRC"); m_active[cbi]<=0; t_pre[cbi]<=now;
		 end
	      end
	      CMD_REF: begin
		 for (b2=0;b2<NB;b2=b2+1) chk(!m_active[b2],"refactive");
		 t_ref<=now;
	      end
	      CMD_PDE: begin
		 for (b2=0;b2<NB;b2=b2+1) chk(!m_active[b2],"pdeactive");
		 m_pstate<=1; pd_seen<=pd_seen+1;
	      end
	      CMD_PDX: begin m_pstate<=0; xtimer<=TXP; end
	      CMD_SRE: begin
		 for (b2=0;b2<NB;b2=b2+1) chk(!m_active[b2],"sreactive");
		 m_pstate<=2; sref_seen<=sref_seen+1;
	      end
	      CMD_SRX: begin m_pstate<=0; xtimer<=TXSR; end
	      default: ;
	    endcase
	 end
	 if (dfi_wrdata_en) begin
	    mem[wa_q[wa_head]]<=dfi_wrdata; wa_head<=(wa_head+1)%32;
	 end
	 for (rp=0; rp<RL; rp=rp+1) begin rpv[rp+1]<=rpv[rp]; rpd[rp+1]<=rpd[rp]; end
	 if (!dfi_valid || (dfi_cmd!=CMD_RD)) rpv[0]<=0;
	 dfi_rddata_valid <= rpv[RL];
	 dfi_rddata <= rpd[RL] ^ (m_inject ? {{(CODEW-1){1'b0}},1'b1} : {CODEW{1'b0}});
      end
   end

   // ---- UMI response collector (in order) ----
   localparam NREQ = 24;
   reg [DATAW-1:0] expd [0:NREQ-1];
   reg [DATAW-1:0] rcv  [0:NREQ-1];
   reg [UAW-1:0]   rdst [0:NREQ-1];
   reg [4:0]	   rop  [0:NREQ-1];
   integer	   ri, corr_cnt, kk;
   reg		   any_uncorr;
   reg		   seen [0:NREQ-1];
   always @(posedge clk)
     if (!rst && udev_resp_valid && udev_resp_ready && ri < NREQ) begin
	rcv[ri] <= udev_resp_data; rdst[ri] <= udev_resp_dstaddr;
	rop[ri] <= udev_resp_cmd[4:0]; ri <= ri + 1;
     end
   always @(posedge clk) if (!rst) begin
      if (ecc_corr)   corr_cnt   <= corr_cnt + 1;
      if (ecc_uncorr) any_uncorr <= 1'b1;
   end

   // ---- stimulus ----
   integer i, errors, pass;
   reg [1:0] xbi; reg [ROWW-1:0] xrow; reg [COLW-1:0] xcol;
   task ureq;   // drive one UMI request, wait for accept
      input [4:0] op; input [AW-1:0] a; input [UAW-1:0] src; input [DATAW-1:0] d;
      begin
	 @(posedge clk);
	 udev_req_valid<=1; udev_req_cmd<={{(UCW-5){1'b0}},op};
	 udev_req_dstaddr<={{(UAW-AW){1'b0}},a}; udev_req_srcaddr<=src;
	 udev_req_data<=d;
	 @(posedge clk);
	 while (!udev_req_ready) @(posedge clk);
	 udev_req_valid<=0;
      end
   endtask

   initial begin
      errors=0; terr=0; corr_cnt=0; any_uncorr=0; m_inject=0; ri=0;
      udev_req_valid=0; udev_req_cmd=0; udev_req_dstaddr=0; udev_req_srcaddr=0;
      udev_req_data=0; udev_resp_ready=1;
      rst=1; repeat(6) @(posedge clk); rst<=0; @(posedge clk);

      // posted writes across banks/groups
      for (i=0;i<NREQ;i=i+1) begin
	 xbi=i[1:0]; xrow=(i/4)%(1<<ROWW); xcol=(i/8)%(1<<COLW);
	 expd[i]=$random;
	 ureq(REQ_POSTED, {xrow,xbi,xcol}, 64'h0, expd[i]);
      end
      repeat(600) @(posedge clk);     // drain (also exercises PD/SREF)

      // two read passes: clean, then single-bit link error injected
      for (pass=0; pass<2; pass=pass+1) begin
	 m_inject = (pass==1); ri = 0; corr_cnt = 0;
	 for (i=0;i<NREQ;i=i+1) begin
	    xbi=i[1:0]; xrow=(i/4)%(1<<ROWW); xcol=(i/8)%(1<<COLW);
	    ureq(REQ_READ, {xrow,xbi,xcol}, 64'h100 + i, {DATAW{1'b0}});
	 end
	 repeat(900) @(posedge clk);
	 if (ri !== NREQ) begin
	    errors=errors+1; $display("FAIL pass%0d: %0d/%0d responses",pass,ri,NREQ);
	 end
	 // responses may return reordered; match each to its read via the
	 // routed source address (rdst = 0x100 + read index)
	 for (i=0;i<NREQ;i=i+1) seen[i]=1'b0;
	 for (i=0;i<NREQ;i=i+1) begin
	    kk = rdst[i] - 64'h100;
	    if (rop[i] !== RESP_READ) begin errors=errors+1;
	       $display("FAIL pass%0d i%0d: opcode %h",pass,i,rop[i]); end
	    else if (kk < 0 || kk >= NREQ) begin errors=errors+1;
	       $display("FAIL pass%0d i%0d: bad route %h",pass,i,rdst[i]); end
	    else begin
	       seen[kk] = 1'b1;
	       if (rcv[i] !== expd[kk]) begin errors=errors+1;
		  $display("FAIL pass%0d i%0d(read%0d): data %h exp %h",
			   pass,i,kk,rcv[i],expd[kk]); end
	    end
	 end
	 for (i=0;i<NREQ;i=i+1) if (!seen[i]) begin errors=errors+1;
	    $display("FAIL pass%0d: read %0d unanswered",pass,i); end
	 if (pass==0 && corr_cnt!=0) begin errors=errors+1;
	    $display("FAIL: ecc_corr asserted on clean pass (%0d)",corr_cnt); end
	 if (pass==1 && corr_cnt==0) begin errors=errors+1;
	    $display("FAIL: ecc_corr never asserted on injected pass"); end
      end
      m_inject = 0;

      // acked-write check: RESP_WRITE acks
      ri = 0;
      for (i=0;i<4;i=i+1) ureq(REQ_WRITE, {2'd0,i[1:0],3'd0}, 64'h200+i, $random);
      repeat(200) @(posedge clk);
      if (ri !== 4) begin errors=errors+1;
	 $display("FAIL: %0d/4 write acks",ri); end
      for (i=0;i<4;i=i+1)
	if (rop[i] !== RESP_WRITE) begin errors=errors+1;
	   $display("FAIL ack %0d: opcode %h",i,rop[i]); end

      $display("coverage: power-down=%0d self-refresh=%0d", pd_seen, sref_seen);
      if (pd_seen==0 || sref_seen==0) begin errors=errors+1;
	 $display("FAIL: PD/SREF not exercised"); end
      if (any_uncorr) begin errors=errors+1; $display("FAIL: ecc_uncorr asserted"); end
      if (terr) $display("FAIL: %0d timing/power violation(s)", terr);
      if (errors==0 && terr==0) $display("PASSED");
      else $display("FAILED (%0d errors, %0d violations)", errors, terr);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_lpddr5_smoke.vcd");
      $dumpvars(0, test_lpddr5_smoke);
   end
`endif

endmodule
