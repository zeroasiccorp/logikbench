//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for pipeline (self-checking). With enable and valid held
// high, the data output is the input delayed by N stages; a reference shift
// register (clocked identically) is compared against data_out when valid_out is
// asserted. Also checks reset clears the valid pipeline.
//
//#############################################################################
`timescale 1ns/1ps
module test_pipeline_smoke;
   localparam DW = 16, N = 4;
   reg	      clk=0, nreset, en, valid_in;
   reg [DW-1:0]	data_in;
   wire		valid_out;
   wire [DW-1:0] data_out;
   reg [DW-1:0]  ref [0:N-1];
   integer	 i, t, errors;
   reg [31:0]	 r;

   always #5 clk=~clk;

   pipeline #(.DW(DW), .N(N)) dut
     (.clk(clk), .nreset(nreset), .en(en), .valid_in(valid_in),
      .data_in(data_in), .valid_out(valid_out), .data_out(data_out));

   // reference: same shift behavior as the DUT when enabled
   always @(posedge clk or negedge nreset)
     if (!nreset)
       for (i=0;i<N;i=i+1) ref[i] <= {DW{1'b0}};
     else if (en) begin
        ref[0] <= data_in;
        for (i=1;i<N;i=i+1) ref[i] <= ref[i-1];
     end

   // checker
   always @(posedge clk) begin
      #1;
      if (nreset && valid_out && (data_out !== ref[N-1])) begin
         errors = errors + 1;
         if (errors<=8) $display("FAIL: data_out=%h exp=%h", data_out, ref[N-1]);
      end
   end

   initial begin
      errors=0; en=1'b1; valid_in=1'b1; data_in=0; nreset=0;
      @(posedge clk); @(posedge clk); #1;
      if (valid_out !== 1'b0) begin
         errors=errors+1; $display("FAIL: valid_out set during reset");
      end
      #1 nreset=1;
      for (t=0;t<300;t=t+1) begin @(posedge clk); r=$random; data_in <= r[DW-1:0]; end
      #1;
      if (valid_out !== 1'b1) begin
         errors=errors+1; $display("FAIL: valid_out not asserted when full");
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_pipeline_smoke.vcd");
      $dumpvars(0, test_pipeline_smoke);
   end
`endif

endmodule
