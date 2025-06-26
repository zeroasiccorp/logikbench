module fifosync #(parameter DW = 32, // datawidth
                  parameter AW = 6   // DEPTH = 1 << AW
                  )
   (
    input               clk,
    input               rst,
    input               wr_en,
    input [DW-1:0]      wr_data,
    input               rd_en,
    output reg [DW-1:0] rd_data,
    output              full,
    output              empty
    );

   localparam DEPTH = 1 << AW;

   // FIFO storage
   reg [DW-1:0] mem [0:DEPTH-1];

   // state machine variables
   reg [AW-1:0] wr_ptr = 0;
   reg [AW-1:0] rd_ptr = 0;
   reg [AW:0]   count  = 0;


   // fifo state machine
   always @(posedge clk) begin
      if (rst) begin
         count <= 0;
      end
      else begin
         case ({wr_en && !full, rd_en && !empty})
           2'b10: count <= count + 1;  // Write only
           2'b01: count <= count - 1;  // Read only
           default: count <= count;   // Hold
         endcase
      end
   end

   // empty/full indicators
   assign full  = (count == DEPTH);
   assign empty = (count == 0);

   // fifo write
   always @(posedge clk) begin
      if (rst) begin
         wr_ptr <= 0;
      end
      else if (wr_en && !full) begin
         mem[wr_ptr] <= wr_data;
         wr_ptr <= wr_ptr + 1;
      end
   end

   // fifo read
   always @(posedge clk) begin
      if (rst) begin
         rd_ptr <= 0;
      end
      else if (rd_en && !empty) begin
         rd_data <= mem[rd_ptr];
         rd_ptr <= rd_ptr + 1;
      end
   end

endmodule
