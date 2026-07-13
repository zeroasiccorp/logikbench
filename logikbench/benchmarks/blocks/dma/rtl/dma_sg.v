//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// dma_sg: scatter-gather controller. On 'start' it walks a linked list of
// descriptors beginning at head_ptr. Each descriptor is four DW-bit words in
// memory:
//   word0 = src byte address
//   word1 = dst byte address
//   word2 = length in beats
//   word3 = next-descriptor byte address, with bit0 = LAST flag
// For each descriptor it copies 'length' beats src->dst in chunks of up to
// DEPTH beats (read a chunk into the FIFO, then write it out), then follows
// next_ptr until the LAST descriptor, then pulses 'done'.
//#############################################################################
module dma_sg
  #(parameter AW    = 32,
    parameter DW    = 64,
    parameter LENW  = 9,        // per-chunk beat count width
    parameter DEPTH = 32,       // FIFO depth == max chunk
    parameter TOTW  = 16)       // descriptor length field width (beats)
   (
    input  wire            clk,
    input  wire            reset_n,
    input  wire            start,
    input  wire [AW-1:0]   head_ptr,
    output reg             busy,
    output reg             done,
    // read engine
    output reg             r_start,
    output reg  [AW-1:0]   r_addr,
    output reg  [LENW-1:0] r_len,
    input  wire            r_done,
    input  wire            beat_valid,
    input  wire [DW-1:0]   beat_data,
    output reg             beat_ready,
    // write engine
    output reg             w_start,
    output reg  [AW-1:0]   w_addr,
    output reg  [LENW-1:0] w_len,
    input  wire            w_done,
    // FIFO push side
    output wire            fifo_push,
    output wire [DW-1:0]   fifo_din,
    input  wire            fifo_full
    );

   localparam BYTES = DW/8;

   localparam S_IDLE   = 3'd0,
              S_FETCH  = 3'd1,
              S_DESC   = 3'd2,
              S_CHUNK  = 3'd3,
              S_CREAD  = 3'd4,
              S_CWRITE = 3'd5,
              S_NEXT   = 3'd6,
              S_FIN    = 3'd7;

   reg [2:0]      state;
   reg [DW-1:0]   d0, d1, d2, d3;   // captured descriptor words
   reg [1:0]      bcnt;             // descriptor beat counter
   reg [AW-1:0]   src_cur, dst_cur, next_ptr;
   reg [TOTW-1:0] rem;
   reg            last;
   reg [LENW-1:0] chunk;

   assign fifo_din  = beat_data;
   assign fifo_push = (state == S_CREAD) & beat_valid & ~fifo_full;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state      <= S_IDLE;
         busy       <= 1'b0;
         done       <= 1'b0;
         r_start    <= 1'b0;
         w_start    <= 1'b0;
         beat_ready <= 1'b0;
         r_addr     <= {AW{1'b0}};
         r_len      <= {LENW{1'b0}};
         w_addr     <= {AW{1'b0}};
         w_len      <= {LENW{1'b0}};
         bcnt       <= 2'd0;
         rem        <= {TOTW{1'b0}};
         last       <= 1'b0;
         chunk      <= {LENW{1'b0}};
         src_cur    <= {AW{1'b0}};
         dst_cur    <= {AW{1'b0}};
         next_ptr   <= {AW{1'b0}};
         d0 <= {DW{1'b0}}; d1 <= {DW{1'b0}};
         d2 <= {DW{1'b0}}; d3 <= {DW{1'b0}};
      end
      else begin
         r_start <= 1'b0;
         w_start <= 1'b0;
         done    <= 1'b0;
         case (state)
           S_IDLE: begin
              beat_ready <= 1'b0;
              if (start) begin
                 busy       <= 1'b1;
                 r_addr     <= head_ptr;
                 r_len      <= 4;               // fetch 4 descriptor words
                 r_start    <= 1'b1;
                 bcnt       <= 2'd0;
                 beat_ready <= 1'b1;
                 state      <= S_FETCH;
              end
           end
           S_FETCH: begin
              beat_ready <= 1'b1;
              if (beat_valid) begin
                 case (bcnt)
                   2'd0: d0 <= beat_data;
                   2'd1: d1 <= beat_data;
                   2'd2: d2 <= beat_data;
                   2'd3: d3 <= beat_data;
                 endcase
                 bcnt <= bcnt + 1'b1;
              end
              if (r_done) begin
                 beat_ready <= 1'b0;
                 state      <= S_DESC;
              end
           end
           S_DESC: begin
              src_cur  <= d0[AW-1:0];
              dst_cur  <= d1[AW-1:0];
              rem      <= d2[TOTW-1:0];
              next_ptr <= {d3[AW-1:1], 1'b0};    // strip LAST flag
              last     <= d3[0];
              state    <= S_CHUNK;
           end
           S_CHUNK: begin
              if (rem == {TOTW{1'b0}})
                state <= S_NEXT;
              else begin
                 r_addr  <= src_cur;
                 r_start <= 1'b1;
                 if (rem > DEPTH) begin
                    chunk <= DEPTH;
                    r_len <= DEPTH;
                 end
                 else begin
                    chunk <= rem[LENW-1:0];
                    r_len <= rem[LENW-1:0];
                 end
                 state <= S_CREAD;
              end
           end
           S_CREAD: begin
              beat_ready <= ~fifo_full;
              if (r_done) begin
                 beat_ready <= 1'b0;
                 w_addr     <= dst_cur;
                 w_len      <= chunk;
                 w_start    <= 1'b1;
                 state      <= S_CWRITE;
              end
           end
           S_CWRITE:
             if (w_done) begin
                src_cur <= src_cur + (chunk * BYTES);
                dst_cur <= dst_cur + (chunk * BYTES);
                rem     <= rem - chunk;
                state   <= S_CHUNK;
             end
           S_NEXT:
             if (last)
               state <= S_FIN;
             else begin
                r_addr     <= next_ptr;
                r_len      <= 4;
                r_start    <= 1'b1;
                bcnt       <= 2'd0;
                beat_ready <= 1'b1;
                state      <= S_FETCH;
             end
           S_FIN: begin
              done  <= 1'b1;
              busy  <= 1'b0;
              state <= S_IDLE;
           end
           default: state <= S_IDLE;
         endcase
      end
   end

endmodule
