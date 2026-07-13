//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_rx: receive endpoint. Two clock domains.
 *
 * rx_fwclk (forwarded-clock capture domain):
 *   - samples the NLANES lane bits every forwarded-clock cycle (SDR),
 *   - training locks each lane's marker phase (capphase); deskew is taken
 *     RELATIVE TO LANE 0 so all lanes read the same transmit frame,
 *   - the deskewed bits reassemble a DW word once per frame (snapshotted at
 *     lane 0's frame boundary),
 *   - the completed word is pushed into the async CDC FIFO.
 * rx_clk (receiver core domain):
 *   - pops the FIFO to drive rx_dout / rx_dout_valid,
 *   - rx_aligned is the (synchronized) link-locked status.
 *
 * SER (= DW/NLANES) must be a power of two. Lane 0 is the deskew reference;
 * per-lane skew is resolved within one frame (whole-UI, < SER cycles).
 ******************************************************************************/
module chiplink_rx
  #(parameter NLANES = 8,
    parameter DW = 32)
  (
   input               rx_clk,
   input               rx_rst_n,
   input               rx_fwclk,
   input [NLANES-1:0]  rx_data,
   output reg [DW-1:0] rx_dout,
   output reg          rx_dout_valid,
   output              rx_aligned
   );

   localparam SER  = DW / NLANES;
   localparam PW   = (SER < 2) ? 1 : $clog2(SER);
   localparam MASK = SER - 1;                 // SER is a power of two
   localparam HD   = 8;                        // per-lane history depth

   // ---------------- forwarded-clock capture domain ----------------
   reg  [PW-1:0]      rphase;
   reg  [HD-1:0]      hist [0:NLANES-1];
   reg  [SER-1:0]     lane_acc [0:NLANES-1];
   wire [NLANES-1:0]  locked;
   wire [PW-1:0]      capphase [0:NLANES-1];
   wire               aligned_fw = &locked;
   reg                armed;
   integer            i;

   always @(posedge rx_fwclk or negedge rx_rst_n) begin
      if (!rx_rst_n)
        rphase <= {PW{1'b0}};
      else
        rphase <= (rphase == (SER-1)) ? {PW{1'b0}} : (rphase + 1'b1);
   end

   always @(posedge rx_fwclk or negedge rx_rst_n) begin
      if (!rx_rst_n)
        for (i = 0; i < NLANES; i = i + 1)
          hist[i] <= {HD{1'b0}};
      else
        for (i = 0; i < NLANES; i = i + 1)
          hist[i] <= {hist[i][HD-2:0], rx_data[i]};
   end

   // per-lane marker lock (from the captured history bit, same timebase as
   // assembly); train on the first marker, then hold
   genvar g;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: trn
         chiplink_train #(.SER(SER), .PW(PW)) u_train
           (.fwclk    (rx_fwclk),
            .rst_n    (rx_rst_n),
            .train    (1'b1),
            .lane_bit (hist[g][0]),
            .rphase   (rphase),
            .locked   (locked[g]),
            .capphase (capphase[g]));
      end
   endgenerate

   // deskew per lane, referenced to lane 0 (the earliest/reference lane, which
   // removes the common phase offset so every lane reads the same transmit
   // frame). rel = how many cycles later than lane 0 this lane arrives; align
   // all lanes to the latest one by delaying each by (maxrel - rel).
   wire [PW-1:0] rel [0:NLANES-1];
   wire [PW-1:0] del [0:NLANES-1];
   reg  [PW-1:0] maxrel;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: dsk
         assign rel[g] = (capphase[g] + SER - capphase[0]) & MASK;
         assign del[g] = maxrel - rel[g];
      end
   endgenerate
   always @* begin
      maxrel = {PW{1'b0}};
      for (i = 0; i < NLANES; i = i + 1)
        if (locked[i] && (rel[i] > maxrel))
          maxrel = rel[i];
   end

   // shift the deskewed bit of each lane into its accumulator; after a frame
   // lane_acc[l][p] holds that lane's transmit frame-phase p bit
   always @(posedge rx_fwclk or negedge rx_rst_n) begin
      if (!rx_rst_n)
        for (i = 0; i < NLANES; i = i + 1)
          lane_acc[i] <= {SER{1'b0}};
      else
        for (i = 0; i < NLANES; i = i + 1)
          lane_acc[i] <= {hist[i][del[i]], lane_acc[i][SER-1:1]};
   end

   wire [DW-1:0] asm_word;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: asm
         assign asm_word[g*SER +: SER] = lane_acc[g];
      end
   endgenerate

   // frame boundary = lane 0's marker phase advanced by the deskew depth (the
   // aligned-to-latest transmit frame boundary); arm after the first aligned
   // boundary so the first pushed word is a complete frame
   wire boundary = (rphase == ((capphase[0] + maxrel) & MASK));
   always @(posedge rx_fwclk or negedge rx_rst_n) begin
      if (!rx_rst_n)
        armed <= 1'b0;
      else if (aligned_fw && boundary)
        armed <= 1'b1;
   end

   reg              push;
   reg  [DW-1:0]    push_word;
   always @(posedge rx_fwclk or negedge rx_rst_n) begin
      if (!rx_rst_n) begin
         push      <= 1'b0;
         push_word <= {DW{1'b0}};
      end
      else begin
         push      <= armed && aligned_fw && boundary;
         push_word <= asm_word;
      end
   end

   // ---------------- clock-domain crossing (fwclk -> rx_clk) ----------------
   wire            fifo_full;
   wire            fifo_empty;
   wire [DW-1:0]   fifo_dout;
   wire            fifo_rd = ~fifo_empty;

   chiplink_cdc_fifo #(.DW(DW), .AW(3)) u_fifo
     (.wr_clk   (rx_fwclk),
      .wr_rst_n (rx_rst_n),
      .wr_en    (push),
      .wr_data  (push_word),
      .wr_full  (fifo_full),
      .rd_clk   (rx_clk),
      .rd_rst_n (rx_rst_n),
      .rd_en    (fifo_rd),
      .rd_data  (fifo_dout),
      .rd_empty (fifo_empty));

   always @(posedge rx_clk or negedge rx_rst_n) begin
      if (!rx_rst_n) begin
         rx_dout       <= {DW{1'b0}};
         rx_dout_valid <= 1'b0;
      end
      else begin
         rx_dout_valid <= fifo_rd;
         rx_dout       <= fifo_dout;
      end
   end

   // aligned status synchronized into the core clock
   reg align_s1, align_s2;
   always @(posedge rx_clk or negedge rx_rst_n) begin
      if (!rx_rst_n) begin
         align_s1 <= 1'b0;
         align_s2 <= 1'b0;
      end
      else begin
         align_s1 <= aligned_fw;
         align_s2 <= align_s1;
      end
   end
   assign rx_aligned = align_s2;

endmodule
