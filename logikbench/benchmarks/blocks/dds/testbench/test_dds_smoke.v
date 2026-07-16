//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * Testbench: dds (self-check). Drives a frequency control word that advances
 * the top AW phase bits by one per cycle (full period = 2^AW = 1024 samples),
 * captures one period of the sine/cosine stream, and checks the waveform shape
 * (robust to LUT quantization and a small pipeline offset).
 * TESTED: quadrant reconstruction (zero / +full / zero / -full crossings),
 *         constant power sin^2+cos^2, and cosine leading sine by a quarter.
 * NOT TESTED: arbitrary FCW frequencies, phase continuity across periods.
 ******************************************************************************/
`timescale 1ns/1ps
module test_dds_smoke;

   localparam integer PW = 24;
   localparam integer AW = 10;
   localparam integer OW = 12;
   localparam integer NS = (1 << AW);         // samples per period (1024)
   localparam integer QUARTER = (1 << (AW-2)); // 256
   localparam integer FS = (1 << (OW-1)) - 1;  // 2047 full scale
   localparam integer FS2 = FS*FS;

   reg                 clk = 1'b0;
   reg                 reset_n;
   reg                 en;
   reg  [PW-1:0]       fcw;
   wire signed [OW-1:0] sine;
   wire signed [OW-1:0] cosine;
   wire                out_valid;

   always #5 clk = ~clk;

   dds #(.PW(PW), .AW(AW), .OW(OW)) dut
     (.clk(clk), .reset_n(reset_n), .en(en), .fcw(fcw),
      .sine(sine), .cosine(cosine), .out_valid(out_valid));

   reg signed [OW-1:0] sarr [0:NS-1];
   reg signed [OW-1:0] carr [0:NS-1];
   integer i, k, errors, mag2;

   function integer iabs;
      input integer v;
      begin
         iabs = (v < 0) ? -v : v;
      end
   endfunction

   task chk;
      input cond;
      input [8*40:1] msg;
      begin
         if (!cond) begin
            errors = errors + 1;
            $display("FAILED: %0s", msg);
         end
      end
   endtask

   initial begin
      errors = 0;
      en     = 1'b0;
      // FCW that advances the top AW bits by exactly 1 each cycle
      fcw    = (1 << (PW - AW));   // advance top AW phase bits by 1/cycle

      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      reset_n <= 1'b1;
      en      <= 1'b1;

      // let the pipeline fill, then capture exactly one period
      @(posedge clk);
      i = 0;
      while (i < NS) begin
         @(posedge clk);
         if (out_valid) begin
            sarr[i] = sine;
            carr[i] = cosine;
            i = i + 1;
         end
      end

      // waveform-shape checks (tolerant of quantization + small offset)
      chk(iabs(sarr[0])       <  40,        "sine(0) not near zero");
      chk(sarr[QUARTER]       >  (FS-60),   "sine(pi/2) not near +full");
      chk(iabs(sarr[2*QUARTER]) < 40,       "sine(pi) not near zero");
      chk(sarr[3*QUARTER]     < -(FS-60),   "sine(3pi/2) not near -full");

      // constant power: sin^2 + cos^2 ~ FS^2
      for (k = 0; k < NS; k = k + 97) begin
         mag2 = sarr[k]*sarr[k] + carr[k]*carr[k];
         chk(iabs(mag2 - FS2) < (FS2/8), "sin^2+cos^2 not constant");
      end

      // cosine leads sine by a quarter period: cos[k] == sine[k+QUARTER]
      for (k = 0; k < NS; k = k + 131) begin
         chk(iabs(carr[k] - sarr[(k+QUARTER) % NS]) < 4,
             "cosine not a quarter ahead of sine");
      end

      if (errors == 0)
        $display("PASSED");
      else
        $display("FAILED: %0d checks failed", errors);
      $finish;
   end

   initial begin
      #500000;
      $display("FAILED: timeout");
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_dds_smoke.vcd");
      $dumpvars(0, test_dds_smoke);
   end
`endif

endmodule
