module fifoasync #(parameter DW = 16,
                   parameter AW = 4 // DEPTH = 1 << AW
                   )
   (
    // write port
    input               wr_clk,
    input               wr_rst,
    input               wr_en,
    input [DW-1:0]      wr_data,
    output              full,
    // read port
    input               rd_clk,
    input               rd_rst,
    input               rd_en,
    output reg [DW-1:0] rd_data,
    output              empty
    );

   localparam DEPTH = 1 << AW;

   // ram
   reg [DW-1:0] mem [0:DEPTH-1];

   // Binary and gray pointers
   reg [AW:0]   wr_ptr_bin;
   reg [AW:0]   wr_ptr_gray;
   reg [AW:0]   rd_ptr_bin;
   reg [AW:0]   rd_ptr_gray;

   // Synchronized pointers
   reg [AW:0]   rd_ptr_gray_sync1;
   reg [AW:0]   rd_ptr_gray_sync2;
   reg [AW:0]   wr_ptr_gray_sync1;
   reg [AW:0]   wr_ptr_gray_sync2;

   // Write logic
   always @(posedge wr_clk) begin
      if (wr_rst) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
        end
      else if (wr_en && !full) begin
         mem[wr_ptr_bin[AW-1:0]] <= wr_data[DW-1:0];
         wr_ptr_bin  <= wr_ptr_bin + 1;
         wr_ptr_gray <= (wr_ptr_bin + 1) ^ ((wr_ptr_bin + 1) >> 1);
      end
   end

    // Read logic
    always @(posedge rd_clk) begin
        if (rd_rst) begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
            rd_data     <= 0;
        end
        else if (rd_en && !empty) begin
           rd_data     <= mem[rd_ptr_bin[AW-1:0]];
           rd_ptr_bin  <= rd_ptr_bin + 1;
           rd_ptr_gray <= (rd_ptr_bin + 1) ^ ((rd_ptr_bin + 1) >> 1);
        end
    end

    // read pointer synchronizes
    always @(posedge wr_clk) begin
        if (wr_rst) begin
           rd_ptr_gray_sync1 <= 0;
           rd_ptr_gray_sync2 <= 0;
        end
        else begin
           rd_ptr_gray_sync1 <= rd_ptr_gray;
           rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // write pointer synchronizers
    always @(posedge rd_clk) begin
        if (rd_rst) begin
           wr_ptr_gray_sync1 <= 0;
           wr_ptr_gray_sync2 <= 0;
        end
        else begin
           wr_ptr_gray_sync1 <= wr_ptr_gray;
           wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // Convert Gray to Binary
    function [AW:0] gray2bin;
        input [AW:0] gray;
        integer i;
        begin
            gray2bin[AW] = gray[AW];
            for (i = AW - 1; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i + 1] ^ gray[i];
        end
    endfunction

    // Full and Empty flags
    wire [AW:0] rd_ptr_bin_sync = gray2bin(rd_ptr_gray_sync2);
    wire [AW:0] wr_ptr_bin_sync = gray2bin(wr_ptr_gray_sync2);

    assign full  = (wr_ptr_gray == {~rd_ptr_gray_sync2[AW:AW-1], rd_ptr_gray_sync2[AW-2:0]});
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

endmodule
