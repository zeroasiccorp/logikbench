//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for parametric_fsm_benchmark (chaotic parametrized FSM,
// self-checking). There is no external golden model for the pseudo-random
// transition function, so the reference mirrors the RTL's next-state and output
// equations and checks the observable output 'out' every cycle (and that no X
// propagates). SW = clog2(STATES) is the state width; DW is the I/O width.
//
//#############################################################################
`timescale 1ns/1ps
module test_fsm_smoke;
   localparam STATES = 256;
   localparam DW = 64;
   localparam [31:0] SEED = 32'hA5A5A5A5;
   localparam SW = $clog2(STATES);

   reg		 clk=0, nreset;
   reg [DW-1:0]	 in;
   wire [DW-1:0] out;
   reg [SW-1:0]	 cs, ns;
   reg [DW-1:0]	 rout;
   reg			  started;
   integer		  i, errors;

   always #5 clk=~clk;

   parametric_fsm_benchmark #(.STATES(STATES),
                              .DW(DW),
                              .SEED(SEED)) dut (.clk(clk), .nreset(nreset),
                                                .in(in), .out(out));

   // reference next-state: mirrors the RTL (specific states override default)
   always @(*) begin
      ns = cs ^ in[SW-1:0];
      case (cs)
        {SW{1'b0}}:      ns = in[0] ? (STATES-1) : 1'b1;
        ((STATES/2)-1):  ns = (^in) ? {SW{1'b1}} : {SW{1'b0}};
        (STATES-1):      ns = in ^ (SEED[SW-1:0] >> 1);
        default:         ns = (cs ^ SEED[SW-1:0]) + in;
      endcase
   end

   always @(posedge clk or negedge nreset)
     if (!nreset) cs <= {SW{1'b0}};
     else         cs <= ns;

   always @(posedge clk or negedge nreset)
     if (!nreset) rout <= {DW{1'b0}};
     else         rout <= (cs ^ (cs >> 2)) + in;

   always @(posedge clk) begin
      #1;
      if (started && (out !== rout)) begin
         errors = errors + 1;
         $display("FAIL i=%0d: out=%h ref=%h state=%0d", i, out, rout, cs);
      end
      if (started && (^out === 1'bx)) begin
         errors = errors + 1;
         $display("FAIL i=%0d: out has X (%h)", i, out);
      end
   end

   initial begin
      errors=0; started=0; nreset=0; in=0;
      @(posedge clk); @(posedge clk); #2 started=1; nreset<=1;
      for (i=0; i<200; i=i+1) begin
         in <= $random;
         @(posedge clk);
      end
      #2;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_fsm_smoke.vcd");
      $dumpvars(0, test_fsm_smoke);
   end
`endif

endmodule
