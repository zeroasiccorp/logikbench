//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// One receive-beamformer channel: a RAM-based programmable delay line followed
// by an apodization weight multiply. Incoming samples are written into a
// circular buffer (lambdalib la_dpram); the delayed sample is read back at
// address (wptr - delay). The la_dpram read is registered (1-cycle latency)
// and returns old data on a same-address read/write collision, so delay==0
// (the current sample) is served by a one-cycle-aligned bypass instead of the
// RAM. Latency from sample_in to prod is 2 cycles.
//#############################################################################
module beamformer_channel
  #(parameter DW    = 12,             // sample width (signed)
    parameter WW    = 12,             // weight width (signed)
    parameter DEPTH = 64,             // delay buffer depth
    parameter AW    = $clog2(DEPTH))  // address / delay width
   (
    input                       clk,
    input                       reset_n,
    input                       in_valid,
    input  signed [DW-1:0]      sample_in,
    input         [AW-1:0]      delay,
    input  signed [WW-1:0]      weight,
    output reg                  out_valid,
    output reg signed [DW+WW-1:0] prod
    );

   reg  [AW-1:0]       wptr;         // circular write pointer
   reg  signed [DW-1:0] sample_r;    // sample_in aligned to RAM read latency
   reg  [AW-1:0]       delay_r;      // delay aligned to RAM read latency
   reg                 dv;           // valid aligned to RAM read latency

   wire [AW-1:0]       rd_addr = wptr - delay;
   wire signed [DW-1:0] rd_dout;
   // delay==0 cannot use the RAM (read-during-write to wptr): bypass it
   wire signed [DW-1:0] delayed = (delay_r == {AW{1'b0}}) ? sample_r : rd_dout;

   la_dpram #(.DW(DW), .AW(AW), .BYTEMASK(0)) u_ram
     (.wr_clk  (clk),
      .wr_ce   (in_valid),
      .wr_we   (in_valid),
      .wr_wmask({DW{1'b1}}),
      .wr_addr (wptr),
      .wr_din  (sample_in),
      .rd_clk  (clk),
      .rd_ce   (in_valid),
      .rd_addr (rd_addr),
      .rd_dout (rd_dout),
      .selctrl (1'b0),
      .ctrl    (32'b0),
      .status  ());

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         wptr      <= {AW{1'b0}};
         sample_r  <= {DW{1'b0}};
         delay_r   <= {AW{1'b0}};
         dv        <= 1'b0;
         prod      <= {(DW+WW){1'b0}};
         out_valid <= 1'b0;
      end
      else begin
         if (in_valid)
           wptr <= wptr + 1'b1;
         sample_r  <= sample_in;
         delay_r   <= delay;
         dv        <= in_valid;
         prod      <= delayed * weight;
         out_valid <= dv;
      end
   end

endmodule
