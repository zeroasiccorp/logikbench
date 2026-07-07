//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for addtree (balanced adder-reduction tree, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_addtree_smoke;
   localparam N=16, DW=8, OW=DW+$clog2(N);
   reg			 clk=0;
   reg [N*DW-1:0]	 a;
   wire [OW-1:0]	 out;
   integer		 t, i, errors;
   reg [OW-1:0]		 exp;
   reg [N*DW-1:0]	 rv;

   always #5 clk=~clk;

   addtree #(.N(N), .DW(DW)) dut (.a(a), .out(out));

   task check;
      input [N*DW-1:0] av;
      begin
	 @(posedge clk);
	 a <= av;
	 @(posedge clk); #1;
	 exp = 0;
	 for (i=0; i<N; i=i+1) exp = exp + av[i*DW +: DW];
	 if (out !== exp) begin
	    errors = errors + 1;
	    $display("FAIL: got %0d exp %0d", out, exp);
	 end
      end
   endtask

   initial begin
      errors=0; a=0;
      check({N*DW{1'b0}});		// -> 0
      check({N*DW{1'b1}});		// -> N*(2^DW-1)
      rv = 0; rv[0 +: DW] = 8'h01;
      check(rv);			// -> 1
      for (t=0; t<100; t=t+1) begin
	 for (i=0; i<N; i=i+1) rv[i*DW +: DW] = $random;
	 check(rv);
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
