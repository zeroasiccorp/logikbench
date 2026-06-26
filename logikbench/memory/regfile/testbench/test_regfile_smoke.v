//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for regfile (multi-port register file, self-checking).
// Writes distinct addresses through the WP synchronous write ports (two per
// cycle) and reads them back through the RP combinational read ports. Also
// checks that a read with rd_valid=0 returns zero.
// TESTED: AW=6/DW=32/RP=4/WP=2, 8 addresses. PASSED/FAILED.
//
//#############################################################################
`timescale 1ns/1ps
module test_regfile_smoke;
   localparam AW = 6, DW = 32, RP = 4, WP = 2, NW = 8;

   reg	      clk = 0;
   reg [WP-1:0]	wr_valid;
   reg [WP*AW-1:0] wr_addr;
   reg [WP*DW-1:0] wr_data;
   reg [RP-1:0]	   rd_valid;
   reg [RP*AW-1:0] rd_addr;
   wire [RP*DW-1:0] rd_data;
   always #5 clk = ~clk;

   regfile #(.AW(AW), .DW(DW), .RP(RP), .WP(WP)) dut
     (.clk(clk), .wr_valid(wr_valid), .wr_addr(wr_addr), .wr_data(wr_data),
      .rd_valid(rd_valid), .rd_addr(rd_addr), .rd_data(rd_data));

   integer            k, p, base, errors;
   reg [DW-1:0]	      exp [0:NW-1];   // exp[a] = data written to address a

   initial begin
      errors = 0; wr_valid = 0; wr_addr = 0; wr_data = 0;
      rd_valid = 0; rd_addr = 0;

      // write addresses 0..NW-1, two per cycle
      for (k = 0; k < NW; k = k + 1) exp[k] = $random;
      for (k = 0; k < NW; k = k + 2) begin
         @(posedge clk);
         wr_valid <= {WP{1'b1}};
         wr_addr[0*AW +: AW] <= k[AW-1:0];
         wr_addr[1*AW +: AW] <= (k+1);
         wr_data[0*DW +: DW] <= exp[k];
         wr_data[1*DW +: DW] <= exp[k+1];
      end
      @(posedge clk); wr_valid <= 0;

      // read back through all RP ports, group by group
      for (base = 0; base < NW; base = base + RP) begin
         rd_valid <= {RP{1'b1}};
         for (p = 0; p < RP; p = p + 1)
           rd_addr[p*AW +: AW] <= (base + p);
         #1;
         for (p = 0; p < RP; p = p + 1)
           if (rd_data[p*DW +: DW] !== exp[base+p]) begin
              errors = errors + 1;
              $display("FAIL rd addr %0d: got %h exp %h",
                       base+p, rd_data[p*DW +: DW], exp[base+p]);
           end
      end

      // rd_valid=0 must gate to zero
      rd_valid <= {RP{1'b0}}; #1;
      for (p = 0; p < RP; p = p + 1)
        if (rd_data[p*DW +: DW] !== {DW{1'b0}}) begin
           errors = errors + 1;
           $display("FAIL rd_valid=0 port %0d: got %h", p, rd_data[p*DW +: DW]);
        end

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
