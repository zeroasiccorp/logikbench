//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_cdc_fifo: dual-clock (asynchronous) FIFO with gray-code pointers.
 *
 * Carries assembled words from the forwarded-clock receive-capture domain
 * (wr_clk = rx_fwclk) into the receiver core-clock domain (rd_clk = rx_clk).
 * Pointers cross domains as gray code through 2-flop synchronizers, the
 * standard safe clock-domain-crossing structure. Read data is first-word
 * fall-through (rd_data is the head whenever rd_empty is low).
 ******************************************************************************/
module chiplink_cdc_fifo
  #(parameter DW = 32,
    parameter AW = 3)            // FIFO depth = 2^AW
  (
   input             wr_clk,
   input             wr_rst_n,
   input             wr_en,
   input  [DW-1:0]   wr_data,
   output            wr_full,
   input             rd_clk,
   input             rd_rst_n,
   input             rd_en,
   output [DW-1:0]   rd_data,
   output            rd_empty
   );

   reg [DW-1:0] mem [0:(1<<AW)-1];

   // pointers are (AW+1) bits: the extra MSB distinguishes full from empty
   reg  [AW:0] wbin, wgray;
   reg  [AW:0] rbin, rgray;
   reg  [AW:0] rgray_s1, rgray_s2;   // read gray -> write domain
   reg  [AW:0] wgray_s1, wgray_s2;   // write gray -> read domain

   wire        do_wr = wr_en & ~wr_full;
   wire [AW:0] wbin_nxt  = wbin + do_wr;
   wire [AW:0] wgray_nxt = (wbin_nxt >> 1) ^ wbin_nxt;

   wire        do_rd = rd_en & ~rd_empty;
   wire [AW:0] rbin_nxt  = rbin + do_rd;
   wire [AW:0] rgray_nxt = (rbin_nxt >> 1) ^ rbin_nxt;

   // ---- write domain ----
   always @(posedge wr_clk or negedge wr_rst_n) begin
      if (!wr_rst_n) begin
         wbin  <= {(AW+1){1'b0}};
         wgray <= {(AW+1){1'b0}};
      end
      else begin
         wbin  <= wbin_nxt;
         wgray <= wgray_nxt;
      end
   end

   always @(posedge wr_clk)
     if (do_wr)
       mem[wbin[AW-1:0]] <= wr_data;

   always @(posedge wr_clk or negedge wr_rst_n) begin
      if (!wr_rst_n) begin
         rgray_s1 <= {(AW+1){1'b0}};
         rgray_s2 <= {(AW+1){1'b0}};
      end
      else begin
         rgray_s1 <= rgray;
         rgray_s2 <= rgray_s1;
      end
   end

   // full: next write gray equals read gray with the two MSBs inverted
   assign wr_full = (wgray_nxt ==
                     {~rgray_s2[AW:AW-1], rgray_s2[AW-2:0]});

   // ---- read domain ----
   always @(posedge rd_clk or negedge rd_rst_n) begin
      if (!rd_rst_n) begin
         rbin  <= {(AW+1){1'b0}};
         rgray <= {(AW+1){1'b0}};
      end
      else begin
         rbin  <= rbin_nxt;
         rgray <= rgray_nxt;
      end
   end

   always @(posedge rd_clk or negedge rd_rst_n) begin
      if (!rd_rst_n) begin
         wgray_s1 <= {(AW+1){1'b0}};
         wgray_s2 <= {(AW+1){1'b0}};
      end
      else begin
         wgray_s1 <= wgray;
         wgray_s2 <= wgray_s1;
      end
   end

   assign rd_empty = (rgray == wgray_s2);
   assign rd_data  = mem[rbin[AW-1:0]];

endmodule
