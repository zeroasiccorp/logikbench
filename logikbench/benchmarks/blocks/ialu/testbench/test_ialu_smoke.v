//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for ialu (integer ALU, self-checking).
// Drives each one-hot operation with directed and random operands and compares
// ia_result against a software reference. Stimulus is applied on clock edges
// with non-blocking assignments (the DUT is combinational; the clock paces the
// vectors).
//
// TESTED: add, sub, and, or, xor, sll, srl, sra, sltu, slt at DW=64, plus the
//   ia_zero and ia_neg flags on every op.
// NOT TESTED here: de_sext word-ops and the add/sub-specific ia_carry/ia_over
//   flags are not checked at smoke level.
//
//#############################################################################
`timescale 1ns/1ps
module test_ialu_smoke;
   localparam DW = 64;

   // one-hot control bit positions
   localparam OH_ADD=0, OH_SUB=1, OH_SLL=2, OH_SRL=3, OH_SRA=4,
              OH_AND=5, OH_OR=6, OH_XOR=7, OH_SLTU=8, OH_SLT=9;

   reg	      clk = 0;
   reg [DW-1:0]	a, b;
   reg [10:0]	oh;   // {sext,slt,sltu,xor,or,and,sra,srl,sll,sub,add}
   wire [DW-1:0] r;
   wire		 z, c, n, o;
   always #5 clk = ~clk;

   ialu #(.DW(DW)) dut
     (.op_rs1(a), .op_rs2(b), .ia_result(r),
      .ia_zero(z), .ia_carry(c), .ia_neg(n), .ia_over(o), .clk(clk),
      .de_add(oh[0]), .de_sub(oh[1]), .de_sll(oh[2]), .de_srl(oh[3]),
      .de_sra(oh[4]), .de_and(oh[5]), .de_or(oh[6]), .de_xor(oh[7]),
      .de_sltu(oh[8]), .de_slt(oh[9]), .de_sext(oh[10]));

   integer          errors, t;

   // apply a one-hot op (operands already driven) and check the result
   task op_check;
      input [10:0]    sel;
      input [DW-1:0]  want;
      input [8*8-1:0] nm;
      begin
         @(posedge clk); oh <= sel;
         @(posedge clk);          // combinational result settles
         if (r !== want) begin
            errors = errors + 1;
            $display("FAIL %0s: got %h exp %h (a=%h b=%h)", nm, r, want, a, b);
         end
         if (z !== (want == {DW{1'b0}})) begin
            errors = errors + 1;
            $display("FAIL %0s zero: got %b exp %b (r=%h)", nm, z,
                     (want == {DW{1'b0}}), want);
         end
         if (n !== want[DW-1]) begin
            errors = errors + 1;
            $display("FAIL %0s neg: got %b exp %b (r=%h)", nm, n,
                     want[DW-1], want);
         end
      end
   endtask

   // drive a/b then sweep all checked ops against the reference
   task run_ops;
      input [DW-1:0] av;
      input [DW-1:0] bv;
      reg [5:0]	     sh;
      begin
         @(posedge clk); a <= av; b <= bv; oh <= 0;
         @(posedge clk);
         sh = bv[5:0];
         op_check(11'b1 << OH_ADD,  av + bv,                         "add");
         op_check(11'b1 << OH_SUB,  av - bv,                         "sub");
         op_check(11'b1 << OH_AND,  av & bv,                         "and");
         op_check(11'b1 << OH_OR,   av | bv,                         "or");
         op_check(11'b1 << OH_XOR,  av ^ bv,                         "xor");
         op_check(11'b1 << OH_SLL,  av << sh,                        "sll");
         op_check(11'b1 << OH_SRL,  av >> sh,                        "srl");
         op_check(11'b1 << OH_SRA,  $signed(av) >>> sh,              "sra");
         op_check(11'b1 << OH_SLTU, (av < bv) ? {{(DW-1){1'b0}},1'b1}
                  : {DW{1'b0}},          "sltu");
         op_check(11'b1 << OH_SLT,  ($signed(av) < $signed(bv))
                  ? {{(DW-1){1'b0}},1'b1}
                  : {DW{1'b0}},                    "slt");
      end
   endtask

   initial begin
      errors = 0; a = 0; b = 0; oh = 0;

      // directed vectors
      run_ops(64'd5, 64'd3);
      run_ops(64'hFFFFFFFFFFFFFFF0, 64'd4);
      run_ops(64'h8000000000000000, 64'd1);
      run_ops(64'd0, 64'd0);
      run_ops(64'd7, 64'd7);   // equal operands: sub/slt/sltu/xor -> 0 (zero flag)

      // random vectors
      for (t = 0; t < 24; t = t + 1)
        run_ops({$random, $random}, {$random, $random});

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_ialu_smoke.vcd");
      $dumpvars(0, test_ialu_smoke);
   end
`endif

endmodule
