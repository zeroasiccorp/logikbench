//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for fifoasync (dual-clock async FIFO, self-checking).
// Writer and reader run on independent clocks. Pushes N words on the write
// side (gated by full), pops them on the read side (gated by empty, 1-cycle
// read-data latency), and checks the popped stream matches the pushed stream
// in order. N < DEPTH so no overflow.
// TESTED: DW=16/AW=6, 20 words, asynchronous clocks. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_fifoasync_smoke;
   localparam DW = 16, AW = 6, N = 20;

   reg	      wr_clk = 0, rd_clk = 0, wr_rst, rd_rst, wr_en, read_en;
   reg [DW-1:0]	wr_data;
   wire		full, empty;
   wire [DW-1:0] rd_data;
   wire		 rd_en = read_en & ~empty;
   always #5 wr_clk = ~wr_clk;
   always #7 rd_clk = ~rd_clk;

   fifoasync #(.DW(DW), .AW(AW)) dut
     (.wr_clk(wr_clk), .wr_rst(wr_rst), .wr_en(wr_en), .wr_data(wr_data),
      .full(full), .rd_clk(rd_clk), .rd_rst(rd_rst), .rd_en(rd_en),
      .rd_data(rd_data), .empty(empty));

   reg [DW-1:0]   tx [0:N-1];
   reg [DW-1:0]	  rx [0:N-1];
   integer	  i, rc, t, errors;
   reg		  pop_d;

   // capture popped words (rd_data is registered: valid the cycle after a pop)
   always @(posedge rd_clk) begin
      if (rd_rst) begin
         pop_d <= 1'b0;
      end
      else begin
         pop_d <= (rd_en && !empty);
         if (pop_d && rc < N) begin rx[rc] = rd_data; rc = rc + 1; end
      end
   end

   initial begin
      errors = 0; wr_en = 0; wr_data = 0; read_en = 0; rc = 0;
      wr_rst = 1; rd_rst = 1;
      for (i = 0; i < N; i = i + 1) tx[i] = $random;

      repeat (4) @(posedge wr_clk); wr_rst <= 0;
      @(posedge rd_clk); rd_rst <= 0; read_en <= 1;

      // push N words (FIFO is deeper than N, so never blocks)
      for (i = 0; i < N; i = i + 1) begin
         @(posedge wr_clk); wr_en <= 1; wr_data <= tx[i];
      end
      @(posedge wr_clk); wr_en <= 0;

      // wait until all popped
      t = 0;
      while (rc < N && t < 2000) begin @(posedge rd_clk); t = t + 1; end

      if (rc < N) begin
         errors = errors + 1;
         $display("FAIL: only %0d/%0d words popped", rc, N);
      end
      else
        for (i = 0; i < N; i = i + 1)
          if (rx[i] !== tx[i]) begin
             errors = errors + 1;
             $display("FAIL item %0d: got %h exp %h", i, rx[i], tx[i]);
          end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
