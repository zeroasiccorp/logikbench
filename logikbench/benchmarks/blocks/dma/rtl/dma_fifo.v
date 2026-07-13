//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// dma_fifo: synchronous FIFO (first-word-fall-through) buffering one chunk of
// data between the read master and the write master. DEPTH must be a power of
// two (the pointer wrap uses an extra MSB for full/empty).
//#############################################################################
module dma_fifo
  #(parameter DW    = 64,
    parameter DEPTH = 32,
    parameter PW    = 5)          // pointer width, PW = log2(DEPTH)
   (
    input  wire          clk,
    input  wire          reset_n,
    input  wire          push,
    input  wire [DW-1:0] din,
    input  wire          pop,
    output wire [DW-1:0] dout,
    output wire          full,
    output wire          empty
    );

   reg [DW-1:0] mem [0:DEPTH-1];
   reg [PW:0]   wptr;
   reg [PW:0]   rptr;

   wire [PW-1:0] wa = wptr[PW-1:0];
   wire [PW-1:0] ra = rptr[PW-1:0];

   assign empty = (wptr == rptr);
   assign full  = (wa == ra) && (wptr[PW] != rptr[PW]);
   assign dout  = mem[ra];

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         wptr <= {(PW+1){1'b0}};
         rptr <= {(PW+1){1'b0}};
      end
      else begin
         if (push && !full) begin
            mem[wa] <= din;
            wptr    <= wptr + 1'b1;
         end
         if (pop && !empty)
           rptr <= rptr + 1'b1;
      end
   end

endmodule
