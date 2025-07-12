module la_syncfifo #(parameter DW = 32,
                     parameter DEPTH = 4 // FIFO depth
                     )
   (// basic interface
    input           clk,
    input           nreset,  //async reset
    input           clear,   //clear fifo statemachine (sync)
    // write port
    input           wr_en,   // write fifo
    input [DW-1:0]  wr_din,  // data to write
    output          wr_full, // fifo full
    // read port
    input           rd_en,   // read fifo
    output [DW-1:0] rd_dout, // output data
    output          rd_empty // fifo is empty
    );

   // local params
   localparam AW = $clog2(DEPTH);

   // local wires
   reg [AW:0] wr_addr;
   wire [AW:0] wr_addr_nxt;
   reg [AW:0]  rd_addr;
   wire [AW:0] rd_addr_nxt;
   wire        fifo_read;
   wire        fifo_write;
   wire        rd_wrap_around;
   wire        wr_wrap_around;

   //############################
   // FIFO Empty/Full
   //############################

   assign wr_full = {~wr_addr[AW], wr_addr[AW-1:0]} == rd_addr[AW:0];

   assign rd_empty = wr_addr[AW:0] == rd_addr[AW:0];

   assign fifo_read = rd_en & ~rd_empty;

   assign fifo_write = wr_en & ~wr_full;

   //############################
   // FIFO Pointers - wrap around DEPTH-1
   //############################
   assign rd_wrap_around = rd_addr[AW-1:0] == (DEPTH[AW-1:0] - 1'b1);
   assign wr_wrap_around = wr_addr[AW-1:0] == (DEPTH[AW-1:0] - 1'b1);

   assign rd_addr_nxt[AW]     = rd_wrap_around ? ~rd_addr[AW] : rd_addr[AW];
   assign rd_addr_nxt[AW-1:0] = rd_wrap_around ? 'b0 : (rd_addr[AW-1:0] + 1);

   assign wr_addr_nxt[AW]     = (wr_addr[AW-1:0] == (DEPTH[AW-1:0]-1'b1)) ? ~wr_addr[AW] : wr_addr[AW];
   assign wr_addr_nxt[AW-1:0] = (wr_addr[AW-1:0] == (DEPTH[AW-1:0]-1'b1)) ? 'b0 : (wr_addr[AW-1:0] + 1);

   always @(posedge clk or negedge nreset)
     if (~nreset) begin
        wr_addr[AW:0] <= 'd0;
        rd_addr[AW:0] <= 'b0;
     end
     else if(clear) begin
        wr_addr[AW:0]    <= 'd0;
        rd_addr[AW:0]    <= 'b0;
     end
     else if (fifo_write & fifo_read) begin
        wr_addr[AW:0] <= wr_addr_nxt[AW:0];
        rd_addr[AW:0] <= rd_addr_nxt[AW:0];
     end else if (fifo_write) begin
        wr_addr[AW:0] <= wr_addr_nxt[AW:0];
        end else if (fifo_read) begin
           rd_addr[AW:0] <= rd_addr_nxt[AW:0];
        end

   //###########################
   //# Dual Port Memory
   //###########################

   reg [DW-1:0] ram[DEPTH-1:0];

   // Write port (FIFO input)
   always @(posedge clk)
     if (wr_en & ~wr_full)
       ram[wr_addr[AW-1:0]] <= wr_din[DW-1:0];

   // Read port (FIFO output)
   assign rd_dout[DW-1:0] = ram[rd_addr[AW-1:0]];

endmodule
