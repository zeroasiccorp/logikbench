//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for sqrt (unsigned integer square root, self-checking).
// Drives directed and random radicands, waits for out_valid, and checks the
// algorithm-independent invariants that uniquely define floor(sqrt(x)):
//   root*root + rem == x   and   rem <= 2*root
// TESTED: DW=32, directed edge cases + random. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_sqrt_smoke;
   localparam DW = 32;

   reg	      clk = 0, nreset, in_valid;
   reg [DW-1:0]	x;
   wire		out_valid, busy;
   wire [DW/2-1:0] root;
   wire [DW/2:0]   rem;
   always #5 clk = ~clk;

   sqrt #(.DW(DW)) dut
     (.clk(clk), .nreset(nreset), .in_valid(in_valid), .x(x),
      .out_valid(out_valid), .busy(busy), .root(root), .rem(rem));

   integer	    t, k, errors;
   reg		    done;
   reg [DW+1:0]	    chk2;

   task run;
      input [DW-1:0] xv;
      begin
	 @(posedge clk); in_valid <= 1; x <= xv;
	 @(posedge clk); in_valid <= 0;
	 done = 0; t = 0;
	 while (!done && t < DW + 4) begin
	    @(posedge clk); #1;
	    if (out_valid) done = 1; else t = t + 1;
	 end
	 chk2 = root * root + rem;
	 if (!done) begin
	    errors = errors + 1;
	    $display("FAIL x=%h: no out_valid", xv);
	 end
	 else if (chk2 !== {2'b0, xv}) begin
	    errors = errors + 1;
	    $display("FAIL x=%h: root=%0d rem=%0d root^2+rem=%0d",
		     xv, root, rem, chk2);
	 end
	 else if (rem > {root, 1'b0}) begin
	    errors = errors + 1;
	    $display("FAIL x=%h: rem=%0d exceeds 2*root=%0d", xv, rem, root << 1);
	 end
      end
   endtask

   initial begin
      errors = 0; nreset = 0; in_valid = 0; x = 0;
      @(posedge clk); @(posedge clk); nreset <= 1; @(posedge clk);

      // directed: small values, perfect squares and neighbours, extremes
      run(32'd0); run(32'd1); run(32'd2); run(32'd3); run(32'd4);
      run(32'd8); run(32'd9); run(32'd15); run(32'd16); run(32'd17);
      run(32'd65535); run(32'd65536); run(32'd1000000);
      run(32'hFFFFFFFF); run(32'hFFFE0001);   // (65535)^2

      // random
      for (k = 0; k < 50; k = k + 1) run({$random, $random});

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
