`timescale 1ns / 1ps

module tb;

   parameter DW = 32;
   parameter N  = 4;

   reg              clk;
   reg              nreset;
   reg              en;
   reg              valid_in;
   reg  [DW-1:0]    data_in;
   wire             valid_out;
   wire [DW-1:0]    data_out;

   // Instantiate the DUT
   pipeline #( .DW(DW), .N(N) ) dut (
      .clk(clk),
      .nreset(nreset),
      .en(en),
      .valid_in(valid_in),
      .data_in(data_in),
      .valid_out(valid_out),
      .data_out(data_out)
   );

   // Clock generation: 10ns period
   initial clk = 0;
   always #5 clk = ~clk;

   // Expected output pipeline to track inputs delayed by N cycles
   reg [DW-1:0] expected_data [0:255]; // support up to 256 cycles
   reg         expected_valid [0:255];

   integer cycle;
   integer errors;

   reg error_flag;

   initial begin
      $display("DW = %0d, N = %0d", DW, N);
      $dumpfile("tb.vcd");
      $dumpvars(0, tb);

      // Initialize
      errors = 0;
      error_flag = 0;

      // Reset and initial inputs
      en <= 1;
      valid_in <= 0;
      data_in <= 0;
      nreset <= 0;

      // Reset pulse
      #10;
      nreset <= 1;

      // Initialize expected arrays
      for (cycle = 0; cycle < 256; cycle = cycle + 1) begin
         expected_data[cycle] = 0;
         expected_valid[cycle] = 0;
      end

      // Test loop for 30 cycles
      for (cycle = 0; cycle < 30; cycle = cycle + 1) begin
         @(posedge clk);

         // Drive inputs with non-blocking assignments
         if (cycle >= 2 && cycle <= 10) begin
            valid_in <= 1;
            data_in  <= cycle * 3; // arbitrary data pattern
         end else begin
            valid_in <= 0;
            data_in  <= 0;
         end

         // Record expected outputs delayed by N cycles
         expected_valid[cycle + N] <= valid_in;
         expected_data[cycle + N] <= data_in;

         // Check output from previous cycle (except first cycles)
         if (cycle >= N) begin
            if (valid_out !== expected_valid[cycle]) begin
               $display("ERROR at cycle %0d: valid_out expected %b, got %b", cycle, expected_valid[cycle], valid_out);
               errors = errors + 1;
               error_flag <= 1;
            end
            // Only check data_out if valid_out is high
            if (valid_out && (data_out !== expected_data[cycle])) begin
               $display("ERROR at cycle %0d: data_out expected %h, got %h", cycle, expected_data[cycle], data_out);
               errors = errors + 1;
               error_flag <= 1;
            end
         end

         $display("Cycle %0d | valid_in=%b data_in=%h | valid_out=%b data_out=%h | error_flag=%b",
                  cycle, valid_in, data_in, valid_out, data_out, error_flag);
      end

      // Extra cycles to flush pipeline output
      for (cycle = 30; cycle < 30+N; cycle = cycle + 1) begin
         @(posedge clk);

         valid_in <= 0;
         data_in <= 0;

         expected_valid[cycle + N] <= 0;
         expected_data[cycle + N] <= 0;

         if (cycle >= N) begin
            if (valid_out !== expected_valid[cycle]) begin
               $display("ERROR at cycle %0d: valid_out expected %b, got %b", cycle, expected_valid[cycle], valid_out);
               errors = errors + 1;
               error_flag <= 1;
            end
            // Only check data_out if valid_out is high
            if (valid_out && (data_out !== expected_data[cycle])) begin
               $display("ERROR at cycle %0d: data_out expected %h, got %h", cycle, expected_data[cycle], data_out);
               errors = errors + 1;
               error_flag <= 1;
            end
         end

         $display("Cycle %0d | valid_in=0 data_in=0 | valid_out=%b data_out=%h | error_flag=%b",
                  cycle, valid_out, data_out, error_flag);
      end

      // Summary
      if (errors == 0)
        $display("TEST PASSED!");
      else
        $display("TEST FAILED: %0d errors detected", errors);

      $finish;
   end

endmodule
