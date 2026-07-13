//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * chiplink_rx: receive side of the chiplet link.
 *
 * Keeps a free-running frame phase (rphase, 0..SER-1) and a small per-lane bit
 * history. A per-lane chiplink_train instance locks each lane's deskew delay
 * during training; 'aligned' asserts when every lane is locked. The deskewed
 * lane bit (history read 'delay' cycles back) is placed into the word
 * accumulator at its frame phase, and a completed DW word is presented with
 * dout_valid once per frame after alignment.
 ******************************************************************************/
module chiplink_rx
  #(parameter DW = 32,
    parameter NLANES = 8)
  (
   input  clk,
   input  reset_n,
   input  train,
   input  [NLANES-1:0] lane,     // received (skewed) lane bits
   output reg  [DW-1:0]   dout,
   output reg             dout_valid,
   output aligned
   );

   localparam SER = DW / NLANES;
   localparam PW  = (SER < 2) ? 1 : $clog2(SER);

   reg  [PW-1:0]     rphase;
   reg  [SER-1:0]    hist [0:NLANES-1];  // hist[l][0]=now, [k]=k cycles ago
   reg  [DW-1:0]     wacc;               // word being assembled
   wire [NLANES-1:0] locked;
   wire [PW-1:0]     delay [0:NLANES-1];

   integer i;

   assign aligned = &locked;

   // free-running receive frame phase
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
        rphase <= {PW{1'b0}};
      else
        rphase <= (rphase == (SER-1)) ? {PW{1'b0}} : (rphase + 1'b1);
   end

   // per-lane bit history (shift new bit into bit 0)
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
        for (i = 0; i < NLANES; i = i + 1)
          hist[i] <= {SER{1'b0}};
      else
        for (i = 0; i < NLANES; i = i + 1)
          hist[i] <= {hist[i][SER-2:0], lane[i]};
   end

   // per-lane deskew / alignment
   genvar g;
   generate
      for (g = 0; g < NLANES; g = g + 1) begin: trn
         chiplink_train #(.SER(SER), .PW(PW)) u_train
           (.clk      (clk),
            .reset_n  (reset_n),
            .train    (train),
            // detect the marker from the same history register the data path
            // reads, so the computed deskew and the payload share one time base
            .lane_bit (hist[g][0]),
            .rphase   (rphase),
            .locked   (locked[g]),
            .delay    (delay[g]));
      end
   endgenerate

   // deskewed bit per lane: the bit 'delay' cycles in the past
   reg [NLANES-1:0] dbit;
   always @* begin
      for (i = 0; i < NLANES; i = i + 1)
        dbit[i] = hist[i][delay[i]];
   end

   // assemble the word across the frame; emit the finished word at phase 0
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         wacc       <= {DW{1'b0}};
         dout       <= {DW{1'b0}};
         dout_valid <= 1'b0;
      end
      else begin
         // present the word completed over the previous frame (wacc still holds
         // it this cycle, before the new phase-0 writes below take effect)
         if (aligned && (rphase == {PW{1'b0}})) begin
            dout       <= wacc;
            dout_valid <= 1'b1;
         end
         else begin
            dout_valid <= 1'b0;
         end
         // place each deskewed lane bit at its phase position
         for (i = 0; i < NLANES; i = i + 1)
           wacc[i*SER + rphase] <= dbit[i];
      end
   end

endmodule
