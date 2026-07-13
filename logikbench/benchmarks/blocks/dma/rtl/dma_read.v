//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// dma_read: AXI4 read master. On 'start' it issues a single INCR read burst of
// 'len' beats (len <= 256) from 'addr' and streams the returned beats out on
// the beat interface (beat_valid/beat_data, back-pressured by beat_ready). The
// caller keeps each transfer to one burst by chunking (len <= DEPTH), so no
// burst splitting is needed here.
//#############################################################################
module dma_read
  #(parameter AW   = 32,
    parameter DW   = 64,
    parameter IDW  = 4,
    parameter LENW = 9)          // per-burst beat count width (<=256)
   (
    input  wire            clk,
    input  wire            reset_n,
    // request
    input  wire            start,
    input  wire [AW-1:0]   addr,
    input  wire [LENW-1:0] len,        // beats, >= 1
    output wire            busy,
    output wire            done,       // 1-cycle pulse when the burst completes
    // beat output
    output wire            beat_valid,
    output wire [DW-1:0]   beat_data,
    input  wire            beat_ready,
    // AXI read address channel
    output reg  [AW-1:0]   araddr,
    output reg  [7:0]      arlen,
    output wire [2:0]      arsize,
    output wire [1:0]      arburst,
    output wire [IDW-1:0]  arid,
    output reg             arvalid,
    input  wire            arready,
    // AXI read data channel
    input  wire [DW-1:0]   rdata,
    input  wire            rlast,
    input  wire            rvalid,
    output wire            rready
    );

   localparam [2:0] ARSIZE = $clog2(DW/8);

   localparam ST_IDLE = 2'd0,
              ST_AR   = 2'd1,
              ST_DATA = 2'd2,
              ST_FIN  = 2'd3;

   reg [1:0] state;
   reg       done_r;

   assign arsize  = ARSIZE;
   assign arburst = 2'b01;                 // INCR
   assign arid    = {IDW{1'b0}};
   assign busy    = (state != ST_IDLE);
   assign done    = done_r;

   assign rready     = (state == ST_DATA) & beat_ready;
   assign beat_valid = (state == ST_DATA) & rvalid;
   assign beat_data  = rdata;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state   <= ST_IDLE;
         araddr  <= {AW{1'b0}};
         arlen   <= 8'd0;
         arvalid <= 1'b0;
         done_r  <= 1'b0;
      end
      else begin
         done_r <= 1'b0;
         case (state)
           ST_IDLE:
             if (start) begin
                araddr  <= addr;
                arlen   <= len - 1'b1;      // AXI ARLEN = beats - 1
                arvalid <= 1'b1;
                state   <= ST_AR;
             end
           ST_AR:
             if (arvalid && arready) begin
                arvalid <= 1'b0;
                state   <= ST_DATA;
             end
           ST_DATA:
             if (rvalid && rready && rlast)
               state <= ST_FIN;
           ST_FIN: begin
              done_r <= 1'b1;
              state  <= ST_IDLE;
           end
           default: state <= ST_IDLE;
         endcase
      end
   end

endmodule
