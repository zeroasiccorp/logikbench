//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for lfsr (parametrizable combinatorial LFSR core, vendored
// from Alex Forencich's verilog-lfsr, MIT). Self-checking: instantiates the
// core twice -- once as a Fibonacci scrambler (feedback) and once as the
// matching feed-forward descrambler -- with externally registered state, and
// verifies the descrambler recovers the original data stream (PRBS31 config).
//
//#############################################################################
`timescale 1ns/1ps
module test_lfsr_smoke;
   localparam LFSRW = 31;
   localparam DW = 8;
   localparam [LFSRW-1:0] POLY = 31'h10000001;   // PRBS31

   reg			  clk=0, nreset;
   reg [DW-1:0]		  din;
   reg [LFSRW-1:0]	  scr_state, dsc_state;
   wire [DW-1:0]	  sdata, rdata;
   wire [LFSRW-1:0]	  scr_next, dsc_next;
   integer		  t, errors;
   reg [31:0]		  r;

   always #5 clk=~clk;

   // scrambler (feedback) : plaintext -> scrambled
   lfsr #(.LFSRW(LFSRW), .LFSR_POLY(POLY), .LFSR_CONFIG("FIBONACCI"),
          .LFSR_FEED_FORWARD(0), .REVERSE(0), .DW(DW)) u_scr
     (.data_in(din), .state_in(scr_state),
      .data_out(sdata), .state_out(scr_next));

   // descrambler (feed forward) : scrambled -> recovered
   lfsr #(.LFSRW(LFSRW), .LFSR_POLY(POLY), .LFSR_CONFIG("FIBONACCI"),
          .LFSR_FEED_FORWARD(1), .REVERSE(0), .DW(DW)) u_dsc
     (.data_in(sdata), .state_in(dsc_state),
      .data_out(rdata), .state_out(dsc_next));

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        scr_state <= {LFSRW{1'b0}};
        dsc_state <= {LFSRW{1'b0}};
     end
     else begin
        scr_state <= scr_next;
        dsc_state <= dsc_next;
     end

   initial begin
      errors=0; din=0; nreset=0;
      @(posedge clk); @(posedge clk); #2 nreset=1;
      for (t=0; t<500; t=t+1) begin
         @(posedge clk); r=$random; din <= r[DW-1:0]; #1;
         if ((t>3) && (rdata !== din)) begin
            errors = errors + 1;
            if (errors<=8) $display("FAIL: rdata=%h din=%h", rdata, din);
         end
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_lfsr_smoke.vcd");
      $dumpvars(0, test_lfsr_smoke);
   end
`endif

endmodule
