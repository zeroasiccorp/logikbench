//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for arbiter (fixed-priority, self-checking). Bit 0 is highest
// priority, so the grant is the lowest set request bit (isolated one-hot).
//
//#############################################################################
`timescale 1ns/1ps
module test_arbiter_smoke;
   localparam N = 16;
   reg	      clk=0;
   reg [N-1:0] request;
   wire [N-1:0]	grant;
   integer	t, errors;
   reg [N-1:0]	exp;
   reg [31:0]	r;

   always #5 clk=~clk;

   arbiter #(.N(N)) dut (.request(request), .grant(grant));

   task check;
      input [N-1:0] rv;
      begin
         @(posedge clk); request <= rv;
         @(posedge clk); #1;
         exp = rv & (~rv + 1'b1);        // isolate lowest set bit
         if (grant !== exp) begin
            errors = errors + 1;
            if (errors<=8) $display("FAIL: req=%h grant=%h exp=%h", rv, grant, exp);
         end
      end
   endtask

   initial begin
      errors=0; request=0;
      check(16'h0000);   // no request -> no grant
      check(16'h0001);   // -> 0x0001
      check(16'h8000);   // single bit -> 0x8000
      check(16'hFFFF);   // -> lowest 0x0001
      check(16'hFF00);   // -> 0x0100
      for (t=0;t<200;t=t+1) begin r=$random; check(r[N-1:0]); end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
