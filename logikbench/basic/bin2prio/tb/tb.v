`timescale 1ns / 1ps

module tb;

   parameter DW = 8;

   reg [DW-1:0] in;
   wire [DW-1:0]  out;
   wire           valid;

   integer        i;
   reg [DW-1:0] expected_out;
   reg           expected_valid;

   // DUT
   bin2prio #(DW) dut (.in(in),
                       .out(out),
                       .valid(valid));

   // Function to get priority one-hot (highest bit)
   function [DW-1:0] get_highest_onehot;
      input [DW-1:0] vec;
      integer        k;
      reg            found;
      begin
         get_highest_onehot = 0;
         found = 0;
         for (k = DW-1; k >= 0; k = k - 1) begin
            if (!found && vec[k]) begin
               get_highest_onehot[k] = 1'b1;
               found = 1;
            end
         end
        end
   endfunction

   initial begin
      $display("============================================");
      $display(" Running bin2prio Testbench");
      $display(" Parameter Settings: DW = %0d", DW);
      $display(" Priority: Highest-indexed '1' gets selected");
      $display("============================================");

      // Test all single-bit patterns
      for (i = 0; i < DW; i = i + 1) begin
         in = 1 << i;
         #1;
         expected_out   = 1 << i;
         expected_valid = 1;

         if (out === expected_out && valid === expected_valid)
           $display("PASS: in = %b -> out = %b, valid = %b", in, out, valid);
         else
           $display("FAIL: in = %b -> out = %b (exp %b), valid = %b (exp %b)",
                    in, out, expected_out, valid, expected_valid);
      end

      // Test multiple bits set
      in = 8'b00110110; // highest '1' at bit 5
      #1;
      expected_out   = 8'b00100000;
      expected_valid = 1;
      $display("PASS: in = %b -> out = %b, valid = %b", in, out, valid);
      if (out !== expected_out || valid !== expected_valid)
        $display("FAIL: expected out = %b, valid = %b", expected_out, expected_valid);

      // Test all-zero case
      in = 0;
      #1;
      expected_out   = 0;
      expected_valid = 0;
      $display("PASS: in = %b -> out = %b, valid = %b", in, out, valid);
      if (out !== expected_out || valid !== expected_valid)
        $display("FAIL: expected out = %b, valid = %b", expected_out, expected_valid);

      $display("Test complete.");
      $finish;
   end

endmodule
