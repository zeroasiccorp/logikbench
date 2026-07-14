//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for recip (sequential fixed-point reciprocal, self-checking).
// Checks the exact integer reference (with saturation) and real accuracy.
//
//#############################################################################
`timescale 1ns/1ps
module test_recip_smoke;
   localparam DW=16, QW=8;
   localparam NUM  = 1 <<< (2*QW);      // 65536
   localparam MAXV = (1 <<< DW) - 1;    // 65535
   localparam real SCALE = 256.0;

   reg		   clk=0;
   reg		   nreset, in_valid;
   reg [DW-1:0]	   x;
   wire		   out_valid, busy;
   wire [DW-1:0]   out;
   integer	   t, errors, q, exp;
   real		   xr, tr, outr, err;

   always #5 clk=~clk;

   recip #(.DW(DW), .QW(QW)) dut (.clk(clk), .nreset(nreset), .in_valid(in_valid),
                                  .x(x), .out_valid(out_valid), .busy(busy),
                                  .out(out));

   task run;
      input [DW-1:0] xv;
      begin
         @(posedge clk);
         x <= xv; in_valid <= 1'b1;
         @(posedge clk);
         in_valid <= 1'b0;
         while (out_valid !== 1'b1) @(posedge clk);
         #1;
         // exact integer reference with saturation
         if (x == 0) exp = MAXV;
         else begin
            q = NUM / x;
            exp = (q > MAXV) ? MAXV : q;
         end
         if (out !== exp[DW-1:0]) begin
            errors = errors + 1;
            $display("FAIL exact: x=%0d got %0d exp %0d", x, out, exp);
         end
         // real accuracy for non-saturated mid-range inputs
         if (x >= 64 && out !== MAXV) begin
            xr = x / SCALE;
            tr = 1.0 / xr;
            outr = out / SCALE;
            err = outr - tr;
            if (err < 0.0) err = -err;
            if (err > 0.03) begin
               errors = errors + 1;
               $display("FAIL acc: x=%0d out=%f true=%f err=%f", x, outr, tr, err);
            end
         end
      end
   endtask

   integer vx;
   initial begin
      errors=0; in_valid=0; x=0;
      nreset=0; @(posedge clk); @(posedge clk); nreset=1;
      run(256);         // 1.0 -> 1.0
      run(512);         // 2.0 -> 0.5
      run(128);         // 0.5 -> 2.0
      run(64);          // 0.25 -> 4.0
      run(1);           // tiny -> saturate
      run(0);           // 0 -> saturate
      for (t=0; t<40; t=t+1) begin
         vx = $random;
         run(vx[DW-1:0]);
      end
      if (errors==0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_recip_smoke.vcd");
      $dumpvars(0, test_recip_smoke);
   end
`endif

endmodule
