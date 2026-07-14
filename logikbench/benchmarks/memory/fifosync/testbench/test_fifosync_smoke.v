//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for fifosync (synchronous FIFO, self-checking). Writes a
// burst of random words, reads them back, and checks FIFO ordering via a
// reference queue; also checks the FIFO ends up empty.
//
//#############################################################################
`timescale 1ns/1ps
module test_fifosync_smoke;
   localparam DW = 16, AW = 4, NW = 12;
   reg	      clk=0, rst, wr_en, rd_en;
   reg [DW-1:0]	wr_data;
   wire [DW-1:0] rd_data;
   wire		 rd_valid, full, empty;
   reg [DW-1:0]	 q [0:NW-1];
   integer	 qh, qt, t, errors;
   reg [31:0]	 r;

   always #5 clk=~clk;

   fifosync #(.DW(DW), .AW(AW)) dut
     (.clk(clk), .rst(rst), .wr_en(wr_en), .wr_data(wr_data),
      .rd_en(rd_en), .rd_data(rd_data), .rd_valid(rd_valid),
      .full(full), .empty(empty));

   // checker: recovered read data must match the write order
   always @(posedge clk) begin
      #1;
      if (!rst && rd_valid) begin
         if (qh >= qt) begin
            errors=errors+1; if (errors<=8) $display("FAIL: extra read");
         end
         else begin
            if (rd_data !== q[qh]) begin
               errors=errors+1;
               if (errors<=8) $display("FAIL: rd=%h exp=%h", rd_data, q[qh]);
            end
            qh = qh + 1;
         end
      end
   end

   initial begin
      errors=0; qh=0; qt=0; rst=1; wr_en=0; rd_en=0; wr_data=0;
      @(posedge clk); @(posedge clk); #2 rst=0;
      @(posedge clk);
      if (empty !== 1'b1) begin errors=errors+1; $display("FAIL: not empty at start"); end
      // write burst
      for (t=0;t<NW;t=t+1) begin
         @(posedge clk); r=$random;
         wr_en <= 1'b1; wr_data <= r[DW-1:0];
         q[qt] = r[DW-1:0]; qt = qt + 1;
      end
      @(posedge clk); wr_en <= 1'b0;
      // read burst
      for (t=0;t<NW;t=t+1) begin @(posedge clk); rd_en <= 1'b1; end
      @(posedge clk); rd_en <= 1'b0;
      repeat (4) @(posedge clk); #1;
      if (qh !== qt) begin
         errors=errors+1; $display("FAIL: read %0d of %0d", qh, qt);
      end
      if (empty !== 1'b1) begin
         errors=errors+1; $display("FAIL: FIFO not empty at end");
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_fifosync_smoke.vcd");
      $dumpvars(0, test_fifosync_smoke);
   end
`endif

endmodule
