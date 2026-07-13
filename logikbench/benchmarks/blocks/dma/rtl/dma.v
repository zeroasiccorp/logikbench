//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// dma: single-channel AXI4 burst-master scatter-gather DMA engine.
//
// Program 'desc_head_ptr' with the byte address of the head descriptor and
// pulse 'start'. The engine fetches a linked list of 4-word descriptors
// (src, dst, length-in-beats, next|LAST) over its single AXI4 master port and
// executes each memory-to-memory copy, following next pointers until the LAST
// descriptor, then pulses 'done'. Reads run ahead of writes through an internal
// FIFO, chunked to DEPTH beats so each transfer is a single INCR burst.
//
// Simplifications (see README): INCR bursts only, one outstanding burst at a
// time, WSTRB all-ones (word-granular length), fixed 4-word descriptor layout,
// BRESP passed through without error recovery.
//#############################################################################
module dma
  #(parameter DW    = 64,        // AXI data width
    parameter AW    = 32,        // address width
    parameter IDW   = 4,         // AXI id width
    parameter DEPTH = 32)        // internal FIFO depth (power of two)
   (
    input  wire            clk,
    input  wire            reset_n,
    // control
    input  wire            start,
    input  wire [AW-1:0]   desc_head_ptr,
    output wire            busy,
    output wire            done,
    // AXI4 master -- read address
    output wire [AW-1:0]   araddr,
    output wire [7:0]      arlen,
    output wire [2:0]      arsize,
    output wire [1:0]      arburst,
    output wire [IDW-1:0]  arid,
    output wire            arvalid,
    input  wire            arready,
    // AXI4 master -- read data
    input  wire [DW-1:0]   rdata,
    input  wire            rlast,
    input  wire            rvalid,
    output wire            rready,
    // AXI4 master -- write address
    output wire [AW-1:0]   awaddr,
    output wire [7:0]      awlen,
    output wire [2:0]      awsize,
    output wire [1:0]      awburst,
    output wire [IDW-1:0]  awid,
    output wire            awvalid,
    input  wire            awready,
    // AXI4 master -- write data
    output wire [DW-1:0]   wdata,
    output wire [DW/8-1:0] wstrb,
    output wire            wlast,
    output wire            wvalid,
    input  wire            wready,
    // AXI4 master -- write response
    input  wire            bvalid,
    output wire            bready
    );

   localparam LENW = 9;                 // per-chunk beat count (<= DEPTH <= 256)
   localparam TOTW = 16;                // descriptor length field width
   localparam PW   = $clog2(DEPTH);     // FIFO pointer width

   // controller <-> engines
   wire            r_start, r_done, beat_valid, beat_ready;
   wire [AW-1:0]   r_addr;
   wire [LENW-1:0] r_len;
   wire [DW-1:0]   beat_data;
   wire            w_start, w_done;
   wire [AW-1:0]   w_addr;
   wire [LENW-1:0] w_len;
   // FIFO
   wire            fifo_push, fifo_pop, fifo_full, fifo_empty;
   wire [DW-1:0]   fifo_din, fifo_dout;

   dma_sg #(.AW(AW), .DW(DW), .LENW(LENW), .DEPTH(DEPTH), .TOTW(TOTW)) u_sg
     (.clk(clk), .reset_n(reset_n), .start(start), .head_ptr(desc_head_ptr),
      .busy(busy), .done(done),
      .r_start(r_start), .r_addr(r_addr), .r_len(r_len), .r_done(r_done),
      .beat_valid(beat_valid), .beat_data(beat_data), .beat_ready(beat_ready),
      .w_start(w_start), .w_addr(w_addr), .w_len(w_len), .w_done(w_done),
      .fifo_push(fifo_push), .fifo_din(fifo_din), .fifo_full(fifo_full));

   dma_read #(.AW(AW), .DW(DW), .IDW(IDW), .LENW(LENW)) u_read
     (.clk(clk), .reset_n(reset_n),
      .start(r_start), .addr(r_addr), .len(r_len),
      .busy(), .done(r_done),
      .beat_valid(beat_valid), .beat_data(beat_data), .beat_ready(beat_ready),
      .araddr(araddr), .arlen(arlen), .arsize(arsize), .arburst(arburst),
      .arid(arid), .arvalid(arvalid), .arready(arready),
      .rdata(rdata), .rlast(rlast), .rvalid(rvalid), .rready(rready));

   dma_fifo #(.DW(DW), .DEPTH(DEPTH), .PW(PW)) u_fifo
     (.clk(clk), .reset_n(reset_n),
      .push(fifo_push), .din(fifo_din), .pop(fifo_pop),
      .dout(fifo_dout), .full(fifo_full), .empty(fifo_empty));

   dma_write #(.AW(AW), .DW(DW), .IDW(IDW), .LENW(LENW)) u_write
     (.clk(clk), .reset_n(reset_n),
      .start(w_start), .addr(w_addr), .len(w_len),
      .busy(), .done(w_done),
      .pop(fifo_pop), .pdata(fifo_dout), .pempty(fifo_empty),
      .awaddr(awaddr), .awlen(awlen), .awsize(awsize), .awburst(awburst),
      .awid(awid), .awvalid(awvalid), .awready(awready),
      .wdata(wdata), .wstrb(wstrb), .wlast(wlast), .wvalid(wvalid),
      .wready(wready), .bvalid(bvalid), .bready(bready));

endmodule
