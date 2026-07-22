//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// jesd204b_rx: JESD204B receive link layer. Per lane: bit-align to the K.28.5
// comma (wordalign), 8b/10b decode, and count commas for code-group sync.
// Once all lanes are synced (sync_n asserted high), data octets are buffered in
// per-lane elastic FIFOs and released together (lane deskew), descrambled, and
// deframed (transport) back into samples.
//
//#############################################################################
module jesd204b_rx #(parameter L = 4,
                     parameter M = 2,
                     parameter N = 16
                     )
   (
    input	     clk,
    input	     nreset,
    input [L*10-1:0] rx_lanes,
    output reg	     sync_n, // 1 = synced (deassert SYNC request)
    output [M*N-1:0] rx_samples,
    output reg	     rx_valid,
    output	     synced,
    output	     rx_err
    );

   localparam SMPW      = M*N;
   localparam COMMA_RDN = 10'b0011111010;   // K.28.5 (RD-)
   localparam THRESH    = 4;                  // commas for code-group sync

   wire [L-1:0]	lane_synced;
   wire [L-1:0]	fifo_empty;
   wire [7:0]	fifo_rd [0:L-1];
   wire [L-1:0]	derr_lane;

   wire		all_synced = &lane_synced;
   wire		all_ready  = &(~fifo_empty);
   wire		pop = synced & all_ready;

   assign         synced = sync_n;

   // per-lane align, decode, comma-count, and deskew FIFO
   genvar         l;
   generate
      for (l = 0; l < L; l = l + 1) begin : g_lane
         wire [9:0] sym = rx_lanes[l*10 +: 10];
         wire [9:0] aln;
         wire	    wlk;
         wire [7:0] doct;
         wire	    dk, derr;

         wordalign #(.DW(10), .PW(10), .COMMA(COMMA_RDN)) u_wa
           (.clk(clk), .nreset(nreset), .din(sym),
            .dout(aln), .locked(wlk), .offset());

         dec8b10b u_dec (.clk(clk), .nreset(nreset), .din(aln),
                         .dout(doct), .k(dk), .err(derr));

         // comma counter -> lane code-group sync
         reg [3:0] ccnt;
         always @(posedge clk or negedge nreset)
           if (!nreset)              ccnt <= 4'b0;
           else if (wlk & dk & (ccnt < THRESH)) ccnt <= ccnt + 4'b1;
         assign lane_synced[l] = (ccnt >= THRESH);

         // buffer data octets (non-comma) once synced
         wire wr = synced & wlk & ~dk & ~derr;
         jfifo8 #(.AW(4)) u_fifo
           (.clk(clk), .nreset(nreset), .wr(wr), .wdata(doct),
            .rd(pop), .rdata(fifo_rd[l]), .empty(fifo_empty[l]), .full());

         assign derr_lane[l] = wlk & derr;
      end
   endgenerate

   // latch sync once all lanes achieve code-group sync
   always @(posedge clk or negedge nreset)
     if (!nreset)       sync_n <= 1'b0;
     else if (all_synced) sync_n <= 1'b1;

   // deskewed octets -> descramble -> transport deframe
   wire [SMPW-1:0] dsc_bus;
   generate
      for (l = 0; l < L; l = l + 1) begin : g_dsc
         wire [7:0] dsc;
         jdescram8 u_ds (.clk(clk), .nreset(nreset), .en(pop),
                         .din(fifo_rd[l]), .dsc(dsc));
         assign dsc_bus[l*8 +: 8] = dsc;
      end
   endgenerate

   linkmap #(.M(M), .S(1), .N(N), .L(L)) u_deframe
     (.clk(clk), .nreset(nreset), .smp_in({SMPW{1'b0}}), .lane_out(),
      .lane_in(dsc_bus), .smp_out(rx_samples));

   always @(posedge clk or negedge nreset)
     if (!nreset) rx_valid <= 1'b0;
     else         rx_valid <= pop;

   assign rx_err = |derr_lane;

endmodule

//#############################################################################
// Small synchronous FIFO (octet-wide) for lane deskew.
//#############################################################################
module jfifo8 #(parameter AW = 4)
   (
    input	 clk,
    input	 nreset,
    input	 wr,
    input [7:0]	 wdata,
    input	 rd,
    output [7:0] rdata,
    output	 empty,
    output	 full
    );

   reg [7:0]     mem [0:(1<<AW)-1];
   reg [AW:0]	 wptr, rptr;
   wire [AW:0]	 cnt = wptr - rptr;

   assign        empty = (cnt == 0);
   assign        full  = (cnt == (1<<AW));
   assign        rdata = mem[rptr[AW-1:0]];

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        wptr <= 0;
        rptr <= 0;
     end
     else begin
        if (wr & ~full) begin
           mem[wptr[AW-1:0]] <= wdata;
           wptr <= wptr + 1'b1;
        end
        if (rd & ~empty)
          rptr <= rptr + 1'b1;
     end

endmodule
