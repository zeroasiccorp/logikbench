//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for requant (mul, round-half-even shift, saturate).
// Self-checking against an independent wide reference.
//
//#############################################################################
`timescale 1ns/1ps
module test_requant_smoke;
   localparam IW=32, MW=16, SHW=6, OW=8;
   localparam signed [63:0] OMAX = (64'sd1 <<< (OW-1)) - 1;   // +127
   localparam signed [63:0] OMIN = -(64'sd1 <<< (OW-1));             // -128

   reg			    clk=0;
   reg signed [IW-1:0]	    acc;
   reg signed [MW-1:0]	    scale;
   reg [SHW-1:0]	    shift;
   wire signed [OW-1:0]	    out;
   integer		    t, errors;
   reg signed [63:0]	    p, fl, rem, hlf, r, exp;

   always #5 clk=~clk;

   requant #(.IW(IW), .MW(MW), .SHW(SHW), .OW(OW)) dut
     (.acc(acc), .scale(scale), .shift(shift), .out(out));

   task check;
      input signed [IW-1:0] av;
      input signed [MW-1:0] sv;
      input [SHW-1:0]	    shv;
      begin
         @(posedge clk);
         acc   <= av;
         scale <= sv;
         shift <= shv;
         @(posedge clk); #1;
         // independent reference: round-half-away-from-zero then saturate
         p = acc * scale;
         fl = p >>> shift;
         rem = p - (fl <<< shift);
         if (shift == 0) begin
            r = p;
         end else begin
            hlf = (64'sd1 <<< (shift - 1));
            if (rem > hlf)       r = fl + 1;
            else if (rem < hlf)  r = fl;
            else                 r = (p >= 0) ? (fl + 1) : fl;  // tie away 0
         end
         if (r > OMAX)      exp = OMAX;
         else if (r < OMIN) exp = OMIN;
         else               exp = r;
         if ($signed(out) !== exp) begin
            errors = errors + 1;
            $display("FAIL: acc=%0d scale=%0d shift=%0d got %0d exp %0d",
                     acc, scale, shift, $signed(out), exp);
         end
      end
   endtask

   initial begin
      errors=0; acc=0; scale=0; shift=0;
      // directed: round-half-away-from-zero ties (positive and negative)
      check(3, 1, 1);   // 1.5 -> 2 (away)
      check(1, 1, 1);   // 0.5 -> 1 (away)
      check(5, 1, 1);   // 2.5 -> 3 (away)
      check(7, 1, 1);   // 3.5 -> 4 (away)
      check(-3, 1, 1);  // -1.5 -> -2 (away)
      check(-5, 1, 1);  // -2.5 -> -3 (away)
      // directed: saturation
      check(1000, 1, 0);        // -> +127
      check(-1000, 1, 0);       // -> -128
      // random mix (moderate acc so rounding is visible at the output)
      for (t=0; t<200; t=t+1)
        check($random >>> 12, $random, $random & 32'h1F);
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_requant_smoke.vcd");
      $dumpvars(0, test_requant_smoke);
   end
`endif

endmodule
