//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for bin2prio (priority encoder, self-checking). The output is
// the one-hot of the highest set input bit; valid is asserted when the input is
// nonzero.
//
//#############################################################################
`timescale 1ns/1ps
module test_bin2prio_smoke;
   localparam DW = 16;
   reg	      clk=0;
   reg [DW-1:0]	in;
   wire [DW-1:0] out;
   wire		 valid;
   integer	 t, i, errors;
   reg [DW-1:0]	 exp;
   reg		 found;
   reg [31:0]	 r;

   always #5 clk=~clk;

   bin2prio #(.DW(DW)) dut (.in(in), .out(out), .valid(valid));

   task check;
      input [DW-1:0] iv;
      begin
         @(posedge clk); in <= iv;
         @(posedge clk); #1;
         exp = {DW{1'b0}}; found = 1'b0;
         for (i=DW-1; i>=0; i=i-1)
           if (!found && iv[i]) begin exp[i]=1'b1; found=1'b1; end
         if ((out !== exp) || (valid !== (|iv))) begin
            errors = errors + 1;
            if (errors<=8)
              $display("FAIL: in=%h out=%h exp=%h v=%b", iv, out, exp, valid);
         end
      end
   endtask

   initial begin
      errors=0; in=0;
      check(16'h0000);   // -> valid 0
      check(16'h0001);   // -> 0x0001
      check(16'h8000);   // -> 0x8000
      check(16'hFFFF);   // -> 0x8000 (highest)
      check(16'h00FF);   // -> 0x0080
      for (t=0;t<200;t=t+1) begin r=$random; check(r[DW-1:0]); end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
