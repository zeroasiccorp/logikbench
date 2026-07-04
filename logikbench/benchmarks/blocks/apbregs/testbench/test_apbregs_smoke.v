//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for apbdev (APB register file, self-checking).
// Writes pseudo-random data to all 2**AW registers over APB write
// transactions, reads each back (registered read, 1-cycle latency), and checks
// both the read data and the flattened ctrl output. Also checks apb_pready.
// TESTED: DW=32/AW=5, full-word writes, read-back, ctrl flatten. PASSED/FAILED.
// NOT TESTED: byte strobes (apb_pstrb unused by the RTL), pprot, reset (the
// RTL has no register reset), back-to-back/wait-state protocol corners.
//
//#############################################################################
`timescale 1ns/1ps
module test_apbregs_smoke;
   localparam DW = 32, AW = 5, NR = (1 << AW);

   reg	      clk = 0, nreset;
   reg [AW-1:0]	paddr;
   reg		penable, pwrite, psel;
   reg [DW-1:0]	pwdata;
   reg [3:0]	pstrb;
   reg [2:0]	pprot;
   wire		pready;
   wire [DW-1:0] prdata;
   wire [DW*NR-1:0] ctrl;
   always #5 clk = ~clk;

   apbdev #(.DW(DW), .AW(AW)) dut
     (.nreset(nreset), .apb_pclk(clk), .apb_paddr(paddr), .apb_penable(penable),
      .apb_pwrite(pwrite), .apb_pwdata(pwdata), .apb_pstrb(pstrb),
      .apb_pprot(pprot), .apb_psel(psel), .apb_pready(pready),
      .apb_prdata(prdata), .ctrl(ctrl));

   integer          errors, k;
   reg [DW-1:0]	    expect_mem [0:NR-1];
   reg [DW-1:0]	    rd;

   // APB write transaction (setup -> access)
   task apb_write;
      input [AW-1:0] a;
      input [DW-1:0] d;
      begin
         @(posedge clk); psel <= 1; penable <= 0; pwrite <= 1;
         paddr <= a; pwdata <= d;
         @(posedge clk); penable <= 1;
         @(posedge clk); psel <= 0; penable <= 0; pwrite <= 0;
      end
   endtask

   // APB read transaction; prdata is registered (regs[paddr] one cycle later)
   task apb_read;
      input [AW-1:0] a;
      output [DW-1:0] d;
      begin
         @(posedge clk); psel <= 1; penable <= 0; pwrite <= 0; paddr <= a;
         @(posedge clk); penable <= 1;
         @(posedge clk); d = prdata; psel <= 0; penable <= 0;
      end
   endtask

   initial begin
      errors = 0; psel = 0; penable = 0; pwrite = 0; paddr = 0; pwdata = 0;
      pstrb = 4'hF; pprot = 0; nreset = 0;
      @(posedge clk); @(posedge clk); nreset = 1; @(posedge clk);

      // write all registers
      for (k = 0; k < NR; k = k + 1) begin
         expect_mem[k] = $random;
         apb_write(k[AW-1:0], expect_mem[k]);
      end

      // read each back
      for (k = 0; k < NR; k = k + 1) begin
         apb_read(k[AW-1:0], rd);
         if (rd !== expect_mem[k]) begin
            errors = errors + 1;
            $display("FAIL read addr %0d: got %h exp %h", k, rd, expect_mem[k]);
         end
      end

      // check the flattened ctrl output
      for (k = 0; k < NR; k = k + 1)
        if (ctrl[k*DW +: DW] !== expect_mem[k]) begin
           errors = errors + 1;
           $display("FAIL ctrl addr %0d: got %h exp %h",
                    k, ctrl[k*DW +: DW], expect_mem[k]);
        end

      // pready should be tied high
      if (pready !== 1'b1) begin
         errors = errors + 1;
         $display("FAIL: apb_pready not high");
      end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
