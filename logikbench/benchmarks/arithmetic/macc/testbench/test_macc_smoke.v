//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for macc (complex multiply-accumulate, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_macc_smoke;
   localparam DW=8, OW=32;
   reg			 clk=0;
   reg			 clear, en;
   reg signed [DW-1:0]	 a_re, a_im, b_re, b_im;
   wire signed [OW-1:0]	 out_re, out_im;
   reg signed [OW-1:0]	 ref_re, ref_im;
   reg			 started;
   integer		 t, errors;

   always #5 clk=~clk;

   macc #(.DW(DW), .OW(OW)) dut (.clk(clk), .clear(clear), .en(en),
				.a_re(a_re), .a_im(a_im),
				.b_re(b_re), .b_im(b_im),
				.out_re(out_re), .out_im(out_im));

   // reference model: identical complex accumulation on the same edge
   always @(posedge clk) begin
      if (clear) begin
	 ref_re <= 0;
	 ref_im <= 0;
      end
      else if (en) begin
	 ref_re <= ref_re + (a_re * b_re - a_im * b_im);
	 ref_im <= ref_im + (a_re * b_im + a_im * b_re);
      end
   end

   // checker: DUT and reference must agree after each edge
   always @(posedge clk) begin
      #1;
      if (started && (out_re !== ref_re || out_im !== ref_im)) begin
	 errors = errors + 1;
	 $display("FAIL t=%0d: got (%0d,%0d) exp (%0d,%0d)",
		  t, out_re, out_im, ref_re, ref_im);
      end
   end

   initial begin
      errors=0; started=0; clear=1'b1; en=1'b0;
      a_re=0; a_im=0; b_re=0; b_im=0;
      @(posedge clk);		// clear takes effect
      #2 started=1;
      clear <= 1'b0;
      for (t=0; t<80; t=t+1) begin
	 a_re	<= $random; a_im <= $random;
	 b_re	<= $random; b_im <= $random;
	 en	<= $random;
	 clear	<= (t==40);
	 @(posedge clk);
      end
      #2;
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end
endmodule
