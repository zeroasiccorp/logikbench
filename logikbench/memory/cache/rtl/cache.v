module cache #(parameter DW = 64,
               parameter AW = 64,
               parameter INDEXW = 8 // NUM_LINES = 1 << INDEXW
               )
   (
    input wire          clk,
    // CPU interface
    input               cpu_valid,
    input               cpu_write,
    input [AW-1:0]      cpu_addr,
    input [DW-1:0]      cpu_wdata,
    output reg [DW-1:0] cpu_rdata,
    output reg          cpu_ready,
    output reg          cpu_hit
    );

   localparam TAG_WIDTH = AW - INDEXW;
   localparam NUM_LINES = 1 << INDEXW;

   // memory arrays
   reg [DW-1:0]        data_array [0:NUM_LINES-1];
   reg [TAG_WIDTH-1:0] tag_array[0:NUM_LINES-1];
   reg                 valid_array[0:NUM_LINES-1];

   // Pipeline for synchronous read
   reg [TAG_WIDTH-1:0]  tag_q;
   reg [INDEXW-1:0]     index_q;
   reg                  read_valid_q;
   reg                  write_q;

   // Synchronous read/write
   always @(posedge clk) begin
      // Store read pipeline info
      tag_q        <= cpu_addr[AW-1:INDEXW];
      index_q      <= cpu_addr[INDEXW-1:0];
      read_valid_q <= cpu_valid;
      write_q      <= cpu_write;

      // Write on valid
      if (cpu_valid && cpu_write) begin
         data_array[cpu_addr[INDEXW-1:0]]  <= cpu_wdata[DW-1:0];
         tag_array[cpu_addr[INDEXW-1:0]]   <= cpu_addr[AW-1:INDEXW];
         valid_array[cpu_addr[INDEXW-1:0]] <= 1;
      end
      // Read happens on next cycle
      cpu_rdata <= data_array[index_q];
      cpu_hit   <= (valid_array[index_q] && tag_array[index_q] == tag_q);
      cpu_ready <= read_valid_q;
   end

endmodule
