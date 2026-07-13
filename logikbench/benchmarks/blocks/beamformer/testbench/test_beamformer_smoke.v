//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// Testbench: beamformer delay-and-sum (self-check). Drives an identical ramp
// (sample[k] = k) on every channel so the focused output has a closed form:
//   phase A - all delays 0, all weights 1  -> beam[k] = NCHAN*k
//   phase B - one channel delayed by 3     -> beam[k] = NCHAN*k - 3 (k >= 3)
// Verifies the RAM-based delay lines, the delay==0 bypass, the weight multiply,
// and the summation. Prints PASSED or FAILED.
//#############################################################################
`timescale 1ns/1ps
module test_beamformer_smoke;

   localparam NCHAN = 4;
   localparam DW    = 12;
   localparam WW    = 12;
   localparam DEPTH = 16;
   localparam AW    = 4;
   localparam PW    = DW + WW;
   localparam OW    = PW + 2;   // clog2(NCHAN=4) = 2

   reg               clk = 1'b0;
   reg               reset_n;
   reg               run;
   reg  [1:0]        phase;         // 0 = case A, 1 = case B
   reg               dut_valid;     // registered valid, aligned with sample_in
   reg  [NCHAN*DW-1:0] sample_in;
   reg  [NCHAN*AW-1:0] delay;
   reg  [NCHAN*WW-1:0] weight;
   wire              out_valid;
   wire signed [OW-1:0] beam;

   integer           fed;
   integer           oc;
   integer           errors;
   integer           c;
   reg signed [OW-1:0] expv;

   always #5 clk = ~clk;

   beamformer #(.NCHAN(NCHAN), .DW(DW), .WW(WW), .DEPTH(DEPTH)) dut
     (.clk(clk), .reset_n(reset_n), .in_valid(dut_valid),
      .sample_in(sample_in), .delay(delay), .weight(weight),
      .out_valid(out_valid), .beam(beam));

   // driver: feed sample[k] = k on every channel while 'run'
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         fed       <= 0;
         sample_in <= {(NCHAN*DW){1'b0}};
         dut_valid <= 1'b0;
      end
      else if (run) begin
         for (c = 0; c < NCHAN; c = c + 1)
           sample_in[c*DW +: DW] <= fed[DW-1:0];
         dut_valid <= 1'b1;
         fed <= fed + 1;
      end
      else begin
         dut_valid <= 1'b0;
      end
   end

   // checker: k-th focused output corresponds to input k
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
        oc <= 0;
      else if (out_valid) begin
         expv = (phase == 2'd0) ? (NCHAN * oc) : (NCHAN * oc - 3);
         if ((phase == 2'd0) || (oc >= 3)) begin
            if (beam !== expv) begin
               errors = errors + 1;
               $display("FAILED: phase=%0d k=%0d beam=%0d expected=%0d",
                        phase, oc, beam, expv);
            end
         end
         oc <= oc + 1;
      end
   end

   initial begin
      errors = 0;
      run    = 1'b0;
      phase  = 2'd0;
      delay  = {(NCHAN*AW){1'b0}};
      weight = {(NCHAN*WW){1'b0}};
      for (c = 0; c < NCHAN; c = c + 1)
        weight[c*WW +: WW] = 1;               // all apodization weights = 1

      // ---- case A: all delays 0 ----
      phase = 2'd0;
      delay = {(NCHAN*AW){1'b0}};
      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      reset_n = 1'b1;
      @(posedge clk);
      run = 1'b1;
      repeat (24) @(posedge clk);
      run = 1'b0;
      repeat (6) @(posedge clk);

      // ---- case B: last channel delayed by 3 ----
      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      phase = 2'd1;
      delay = {(NCHAN*AW){1'b0}};
      delay[(NCHAN-1)*AW +: AW] = 3;
      reset_n = 1'b1;
      @(posedge clk);
      run = 1'b1;
      repeat (24) @(posedge clk);
      run = 1'b0;
      repeat (6) @(posedge clk);

      if (errors == 0)
        $display("PASSED");
      else
        $display("FAILED (%0d errors)", errors);
      $finish;
   end

   // watchdog
   initial begin
      #100000;
      $display("FAILED: timeout");
      $finish;
   end

endmodule
