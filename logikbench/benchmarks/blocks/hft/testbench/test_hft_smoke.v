//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for hft (tick-to-trade pipeline, self-checking). A reference
// model mirrors the six pipeline stages (parse/book/feature/strategy/risk/
// encode) and predicts each emitted order packet; because the DUT pipeline is
// in-order, a FIFO scoreboard compares predicted vs actual order packets
// regardless of the 6-cycle latency. Drives random market-data messages.
//
//#############################################################################
`timescale 1ns/1ps
module test_hft_smoke;
   localparam NSYM=32, NLEVEL=16, PRICE_W=32, QTY_W=16, POS_W=32;
   localparam signed [7:0] SKEW_K=8'sd4;
   localparam SKEW_SH=4, MARGIN=16, WIDE=256, ORDER_QTY=10;
   localparam POS_LIMIT=1000, NOTIONAL_LIMIT=32'h0010_0000, PRICE_BAND=1024;
   localparam SYMW=$clog2(NSYM), LVLW=$clog2(NLEVEL), DEPTH=NSYM*NLEVEL;
   localparam A_NONE=0, A_BUY=1, A_SELL=2, A_CANCEL=3, A_REPLACE=4;

   reg		 clk=0, nreset;
   reg		 md_valid;
   reg [511:0]	 md_word;
   wire		 op_valid;
   wire [511:0]	 op_word;
   integer	 t, errors;

   always #5 clk=~clk;

   hft dut (.clk(clk), .nreset(nreset),
	    .market_data_valid(md_valid), .market_data_word(md_word),
	    .order_packet_valid(op_valid), .order_packet_word(op_word));

   // reference book + position state
   reg [PRICE_W-1:0] rbp [0:DEPTH-1];
   reg [QTY_W-1:0]   rbq [0:DEPTH-1];
   reg [PRICE_W-1:0] rap [0:DEPTH-1];
   reg [QTY_W-1:0]   raq [0:DEPTH-1];
   reg signed [POS_W:0] rpos [0:NSYM-1];

   // FIFO scoreboard of expected order words
   reg [511:0]	 expq [0:8191];
   integer	 qhead, qtail;

   integer	 j;
   task init_state;
      begin
	 for (j=0;j<DEPTH;j=j+1) begin
	    rbp[j]=0; rbq[j]=0; rap[j]=0; raq[j]=0;
	    dut.u_book.bid_mem[j]=0; dut.u_book.ask_mem[j]=0;  // model BRAM=0
	 end
	 for (j=0;j<NSYM;j=j+1) rpos[j]=0;
	 dut.u_book.bid_rd=0; dut.u_book.ask_rd=0;
	 qhead=0; qtail=0;
      end
   endtask

   // reference: apply one message, predict + enqueue expected order (if any)
   task ref_apply;
      input [511:0] vec;
      reg [7:0]	 mt;  reg [SYMW-1:0] sym; reg side; reg [LVLW-1:0] lvl;
      reg [PRICE_W-1:0] pr; reg [QTY_W-1:0] qt;
      integer	 idx, i0;
      reg [PRICE_W-1:0] bid, ask; reg [QTY_W-1:0] bidq, askq;
      reg [PRICE_W-1:0] mid, fair; reg signed [63:0] spr, imb, skew, fairw;
      reg [2:0]	 act; reg osd; reg [PRICE_W-1:0] opr, oref; reg [QTY_W-1:0] oqt;
      reg is_order, has_price, band_bad, notion_bad, pos_bad, pass;
      reg signed [63:0] notion, delta, newpos;
      reg [511:0] w;
      begin
	 mt=vec[7:0]; sym=vec[8+:SYMW]; side=vec[16]; lvl=vec[24+:LVLW];
	 pr=vec[32+:PRICE_W]; qt=vec[64+:QTY_W];
	 idx = sym*NLEVEL + lvl;
	 i0  = sym*NLEVEL;
	 // book update
	 if (mt==8'd1) begin
	    if (!side) begin rbp[idx]=pr; rbq[idx]=qt; end
	    else       begin rap[idx]=pr; raq[idx]=qt; end
	 end
	 else if (mt==8'd2) begin
	    if (!side) begin rbp[idx]=0; rbq[idx]=0; end
	    else       begin rap[idx]=0; raq[idx]=0; end
	 end
	 // top of book
	 bid=rbp[i0]; bidq=rbq[i0]; ask=rap[i0]; askq=raq[i0];
	 // features
	 mid  = (bid+ask) >> 1;
	 spr  = $signed({1'b0,ask}) - $signed({1'b0,bid});
	 imb  = $signed({1'b0,bidq}) - $signed({1'b0,askq});
	 skew = imb * SKEW_K;
	 fairw= $signed({1'b0,mid}) + (skew >>> SKEW_SH);
	 if (fairw < 0)		 fair = 0;
	 else if (fairw > {1'b0,{PRICE_W{1'b1}}}) fair = {PRICE_W{1'b1}};
	 else			 fair = fairw[PRICE_W-1:0];
	 // strategy
	 if ({1'b0,fair} > ({1'b0,ask}+MARGIN)) begin
	    act=A_BUY;     osd=0; opr=ask; oqt=ORDER_QTY;
	 end
	 else if (({1'b0,fair}+MARGIN) < {1'b0,bid}) begin
	    act=A_SELL;    osd=1; opr=bid; oqt=ORDER_QTY;
	 end
	 else if (spr > WIDE) begin
	    act=A_CANCEL;  osd=0; opr=mid; oqt=0;
	 end
	 else begin
	    act=A_REPLACE; osd=0; opr=mid; oqt=ORDER_QTY;
	 end
	 oref = mid;
	 // risk
	 is_order  = (act==A_BUY)|(act==A_SELL);
	 has_price = (act!=A_NONE)&(act!=A_CANCEL);
	 band_bad  = has_price & (({1'b0,opr} > ({1'b0,oref}+PRICE_BAND)) |
				  (({1'b0,opr}+PRICE_BAND) < {1'b0,oref}));
	 notion	   = opr * oqt;
	 notion_bad= is_order & (notion > NOTIONAL_LIMIT);
	 delta	   = (act==A_BUY) ? $signed({1'b0,oqt}) :
		     (act==A_SELL)? -$signed({1'b0,oqt}) : 0;
	 newpos	   = rpos[sym] + delta;
	 pos_bad   = is_order & ((newpos > POS_LIMIT)|(newpos < -POS_LIMIT));
	 pass	   = (act!=A_NONE) & ~(band_bad|notion_bad|pos_bad);
	 if (pass & is_order) rpos[sym] = newpos;
	 if (pass) begin
	    w = 512'b0;
	    w[7:0]	    = {5'b0, act};
	    w[8 +: SYMW]    = sym;
	    w[16]	    = osd;
	    w[32 +: PRICE_W]= opr;
	    w[64 +: QTY_W]  = oqt;
	    expq[qtail] = w;
	    qtail = qtail + 1;
	 end
      end
   endtask

   // monitor: compare each emitted order against the scoreboard, in order
   always @(posedge clk) begin
      #1;
      if (nreset && op_valid) begin
	 if (qhead >= qtail) begin
	    errors = errors + 1;
	    $display("FAIL: unexpected order %h (queue empty)", op_word);
	 end
	 else begin
	    if (op_word !== expq[qhead]) begin
	       errors = errors + 1;
	       if (errors <= 8)
		 $display("FAIL: order got %h exp %h", op_word, expq[qhead]);
	    end
	    qhead = qhead + 1;
	 end
      end
   end

   reg [511:0] vec;
   reg [7:0]   mt; reg [SYMW-1:0] sym; reg s; reg [LVLW-1:0] lvl;
   reg [PRICE_W-1:0] pr; reg [QTY_W-1:0] qt; reg [31:0] rnd;
   initial begin
      errors=0; md_valid=0; md_word=0; nreset=0;
      init_state;
      @(posedge clk); @(posedge clk); #2 nreset=1;
      for (t=0; t<400; t=t+1) begin
	 rnd=$random; mt  = (rnd%10<7) ? 8'd1 : (rnd%10<9) ? 8'd2 : 8'd0;
	 rnd=$random; sym = rnd % 8;
	 rnd=$random; s   = rnd & 1;
	 rnd=$random; lvl = rnd % 4;
	 rnd=$random; pr  = 900 + (rnd % 200);
	 rnd=$random; qt  = 1 + (rnd % 3000);
	 vec = 512'b0;
	 vec[7:0]	  = mt;
	 vec[8 +: SYMW]	  = sym;
	 vec[16]	  = s;
	 vec[24 +: LVLW]  = lvl;
	 vec[32 +: PRICE_W]= pr;
	 vec[64 +: QTY_W] = qt;
	 ref_apply(vec);
	 @(posedge clk); md_valid<=1; md_word<=vec;
      end
      @(posedge clk); md_valid<=0; md_word<=0;
      repeat (16) @(posedge clk);   // drain pipeline
      #1;
      if (qhead !== qtail) begin
	 errors = errors + 1;
	 $display("FAIL: %0d expected orders not emitted", qtail-qhead);
      end
      if (errors==0) $display("PASSED (%0d orders checked)", qhead);
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_hft_smoke.vcd");
      $dumpvars(0, test_hft_smoke);
   end
`endif

endmodule
