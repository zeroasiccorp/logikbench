//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// dma_write: AXI4 write master. On 'start' it issues a single INCR write burst
// of 'len' beats (len <= 256) to 'addr', sourcing the write data by popping the
// FIFO (pop/pdata/pempty). WSTRB is all-ones (word-granular transfers). It
// consumes the B response before signalling done.
//#############################################################################
module dma_write
  #(parameter AW   = 32,
    parameter DW   = 64,
    parameter IDW  = 4,
    parameter LENW = 9)
   (
    input  wire            clk,
    input  wire            reset_n,
    // request
    input  wire            start,
    input  wire [AW-1:0]   addr,
    input  wire [LENW-1:0] len,
    output wire            busy,
    output wire            done,
    // FIFO pop side
    output wire            pop,
    input  wire [DW-1:0]   pdata,
    input  wire            pempty,
    // AXI write address channel
    output reg  [AW-1:0]   awaddr,
    output reg  [7:0]      awlen,
    output wire [2:0]      awsize,
    output wire [1:0]      awburst,
    output wire [IDW-1:0]  awid,
    output reg             awvalid,
    input  wire            awready,
    // AXI write data channel
    output wire [DW-1:0]   wdata,
    output wire [DW/8-1:0] wstrb,
    output wire            wlast,
    output wire            wvalid,
    input  wire            wready,
    // AXI write response channel
    input  wire            bvalid,
    output wire            bready
    );

   localparam [2:0] AWSIZE = $clog2(DW/8);

   localparam ST_IDLE = 3'd0,
              ST_AW   = 3'd1,
              ST_W    = 3'd2,
              ST_B    = 3'd3,
              ST_FIN  = 3'd4;

   reg [2:0]      state;
   reg [LENW-1:0] cnt;                     // beats remaining to write
   reg            done_r;

   assign awsize  = AWSIZE;
   assign awburst = 2'b01;
   assign awid    = {IDW{1'b0}};
   assign busy    = (state != ST_IDLE);
   assign done    = done_r;

   assign wstrb  = {(DW/8){1'b1}};
   assign wdata  = pdata;
   assign wvalid = (state == ST_W) & ~pempty;
   assign wlast  = (state == ST_W) & (cnt == {{(LENW-1){1'b0}}, 1'b1});
   assign pop    = wvalid & wready;
   assign bready = (state == ST_B);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state   <= ST_IDLE;
         awaddr  <= {AW{1'b0}};
         awlen   <= 8'd0;
         cnt     <= {LENW{1'b0}};
         awvalid <= 1'b0;
         done_r  <= 1'b0;
      end
      else begin
         done_r <= 1'b0;
         case (state)
           ST_IDLE:
             if (start) begin
                awaddr  <= addr;
                awlen   <= len - 1'b1;
                cnt     <= len;
                awvalid <= 1'b1;
                state   <= ST_AW;
             end
           ST_AW:
             if (awvalid && awready) begin
                awvalid <= 1'b0;
                state   <= ST_W;
             end
           ST_W:
             if (wvalid && wready) begin
                cnt <= cnt - 1'b1;
                if (cnt == {{(LENW-1){1'b0}}, 1'b1})
                  state <= ST_B;
             end
           ST_B:
             if (bvalid && bready)
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
