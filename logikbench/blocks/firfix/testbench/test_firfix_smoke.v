/****************************************************************************
 * Testbench: firfix fixed-coefficient FIR (self-checking, signed).
 * Streams random signed samples through the DUT (compile-time signed
 * coefficients via the H parameter) and compares y against an independent
 * signed FIR reference model with the same direct-form semantics.
 * Exercises NEGATIVE samples and coefficients -- the case that exposed the
 * unsigned-multiply bug (part-select strips signedness) before the $signed fix.
 * TESTED: DW=8/N=4, signed coeffs, signed samples vs golden. PASSED/FAILED.
 ****************************************************************************/
`timescale 1ns/1ps
module test_firfix_smoke;
   localparam DW = 8, ACCW = 32, N = 4;
   // signed coefficients packed { c3, c2, c1, c0 } so H[i*DW +: DW] = c_i
   localparam [N*DW-1:0] HP = { -8'sd1, 8'sd2, -8'sd5, 8'sd3 };

   reg			 clk = 0, clear, valid;
   reg [DW-1:0]		 x;
   wire [ACCW-1:0]	 y;
   always #5 clk = ~clk;

   firfix #(.DW(DW), .ACCW(ACCW), .N(N), .H(HP)) dut
     (.clk(clk), .clear(clear), .valid(valid), .x(x), .y(y));

   // independent signed reference coefficients (must match HP)
   reg signed [DW-1:0] hh [0:N-1];

   reg signed [DW-1:0] rsh [0:N-1];
   reg signed [ACCW-1:0] racc, ry;
   integer		 k, t, errors;
   reg			 check;

   always @(posedge clk) begin
      if (clear) begin
         for (k = 0; k < N; k = k + 1) rsh[k] <= 0;
         ry <= 0;
      end
      else if (valid) begin
         racc = 0;
         for (k = 0; k < N; k = k + 1) racc = racc + rsh[k] * hh[k];
         for (k = N-1; k > 0; k = k - 1) rsh[k] <= rsh[k-1];
         rsh[0] <= $signed(x);
         ry <= racc;
      end
   end

   always @(posedge clk)
     if (check && (y !== ry)) begin
        errors = errors + 1;
        $display("FAIL t=%0d: dut y=%0d ref=%0d", t, $signed(y), ry);
     end

   initial begin
      errors = 0; check = 0; clear = 1; valid = 0; x = 0;
      hh[0] = 8'sd3; hh[1] = -8'sd5; hh[2] = 8'sd2; hh[3] = -8'sd1;

      @(posedge clk); clear <= 1; valid <= 0;
      @(posedge clk); @(posedge clk); clear <= 0; @(posedge clk);
      check <= 1;
      for (t = 0; t < 60; t = t + 1) begin
         x     <= $random;   // full 8-bit range, includes negatives
         valid <= 1;
         @(posedge clk);
      end
      valid <= 0;
      @(posedge clk); @(posedge clk);

      if (errors == 0) $display("PASSED");
      else             $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
