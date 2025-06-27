`timescale 1ns / 1ps

module tb;

   parameter DW = 16;
   parameter AW = 4; // smaller for faster sim
   localparam DEPTH = 1 << AW;

   reg clk = 0;
   always #5 clk = ~clk;

   reg rst;
   reg wr_en;
   reg rd_en;
   reg [DW-1:0] wr_data;
   wire [DW-1:0] rd_data;
   wire full, empty;
   wire rd_valid;

   // Instantiate DUT
   fifosync #(DW, AW) dut (
      .clk(clk),
      .rst(rst),
      .wr_en(wr_en),
      .wr_data(wr_data),
      .rd_en(rd_en),
      .rd_data(rd_data),
      .rd_valid(rd_valid),
      .full(full),
      .empty(empty)
   );

   // Test state
   integer i;
   reg [DW-1:0] expected;
   reg error;

   initial begin


      $dumpfile("tb.vcd");
      $dumpvars(0, tb);

      rst = 1;
      wr_en = 0;
      rd_en = 0;
      wr_data = 0;
      error = 0;
      #20;
      rst = 0;

      // WRITE PHASE
      for (i = 0; i < DEPTH; i = i + 1) begin
         @(posedge clk);
         wr_en <= 1;
         wr_data <= i;
      end

      @(posedge clk);
      wr_en <= 0;

      // READ PHASE
      for (i = 0; i < DEPTH; i = i + 1) begin
         @(posedge clk);
         rd_en <= 1;
         expected = i;

         @(posedge clk);
         if (rd_valid) begin
            if (rd_data !== expected) begin
               $display("ERROR: Expected %0d, got %0d at time %0t", expected, rd_data, $time);
               error = 1;
            end
         end
         rd_en <= 0;
      end

      #10;
      if (error)
         $display("TEST FAILED");
      else
         $display("TEST PASSED");

      $finish;
   end

endmodule
