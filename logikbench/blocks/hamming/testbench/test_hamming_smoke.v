/******************************************************************************
 * Testbench: Hamming (Hsiao SEC-DED) codec smoke test (self-checking).
 *
 * Drives the hamming top (hamming_enc -> err_mask injection -> hamming_dec),
 * applying bit-flips on err_mask and checking out/syndrome.
 *
 * TESTED (DW=64, PW=8):
 *   - no error     : out == data, syndrome == 0.
 *   - single error : out == data (corrected) and syndrome != 0, for ALL
 *                    72 codeword bit positions (data and check bits).
 *   - double error : syndrome != 0 (detected) across sampled bit pairs.
 *
 * NOT TESTED:
 *   - Only DW=64/PW=8 with PIPELINE=1; other widths/modes not exercised.
 *   - Triple+ bit errors (outside the SEC-DED guarantee).
 *   - That double-error data is uncorrupted -- it is not, by design; only
 *     detection (syndrome != 0) is checked for double errors.
 *   - Exhaustive data patterns (a few representative words only).
 ******************************************************************************/
`timescale 1ns / 1ps

module test_hamming_smoke;

   localparam DW = 64;
   localparam PW = 8;
   localparam CW = DW + PW;

   reg	      clk, nreset;
   reg [DW-1:0]	data;
   reg [CW-1:0]	errmask;
   wire [DW-1:0] decoded;
   wire [PW-1:0] syndrome;

   hamming #(.DW(DW), .PW(PW), .PIPELINE(1)) dut
     (.clk(clk), .nreset(nreset), .in(data), .err_mask(errmask),
      .out(decoded), .syndrome(syndrome));

   always #5 clk = ~clk;

   integer errors, test_num;

   // drive (data, errmask), hold both stable across the pipeline, then sample
   // at negedge so decoded/syndrome reflect (d,e).
   task drive;
      input [DW-1:0] d;
      input [CW-1:0] e;
      begin
         @(posedge clk); data <= d; errmask <= e;
         @(posedge clk);
         @(posedge clk);
         @(negedge clk);   // decoded/syndrome now reflect (d,e)
      end
   endtask

   task test_noerror;
      input [DW-1:0] d;
      input [8*12-1:0] tag;
      begin
         test_num = test_num + 1;
         drive(d, {CW{1'b0}});
         if (decoded !== d || syndrome !== {PW{1'b0}}) begin
            errors = errors + 1;
            $display("FAIL [%0s] noerr dec=%h exp=%h syn=%h", tag, decoded, d,
                     syndrome);
         end
         else $display("PASS [%0s] noerr", tag);
      end
   endtask

   task test_single;     // flip each of the CW positions, must correct
      input [DW-1:0] d;
      input [8*12-1:0] tag;
      integer	       p, bad;
      begin
         test_num = test_num + 1;
         bad = 0;
         for (p = 0; p < CW; p = p + 1) begin
            drive(d, ({{(CW-1){1'b0}},1'b1}) << p);
            if (decoded !== d || syndrome === {PW{1'b0}}) bad = bad + 1;
         end
         if (bad != 0) begin
            errors = errors + 1;
            $display("FAIL [%0s] single-error: %0d/%0d positions wrong",
                     tag, bad, CW);
         end
         else $display("PASS [%0s] single-error corrected (all %0d pos)",
                       tag, CW);
      end
   endtask

   task test_double;     // flip pairs, must be DETECTED (syndrome != 0)
      input [DW-1:0] d;
      input [8*12-1:0] tag;
      integer	       p, q, bad, n;
      begin
         test_num = test_num + 1;
         bad = 0; n = 0;
         for (p = 0; p < CW; p = p + 7) begin
            for (q = p + 1; q < CW; q = q + 11) begin
               drive(d, (({{(CW-1){1'b0}},1'b1}) << p) |
                     (({{(CW-1){1'b0}},1'b1}) << q));
               n = n + 1;
               if (syndrome === {PW{1'b0}}) bad = bad + 1;  // undetected!
            end
         end
         if (bad != 0) begin
            errors = errors + 1;
            $display("FAIL [%0s] double-error: %0d/%0d undetected", tag, bad, n);
         end
         else $display("PASS [%0s] double-error detected (all %0d pairs)",
                       tag, n);
      end
   endtask

   initial begin
      clk = 0; nreset = 0; data = 0; errmask = 0;
      errors = 0; test_num = 0;
      @(posedge clk); @(posedge clk); nreset <= 1'b1;

      test_noerror(64'h0,                "zeros");
      test_noerror(64'hFFFFFFFFFFFFFFFF, "ones");
      test_noerror(64'hA5A5A5A5_5A5A5A5A, "a5/5a");

      test_single(64'hA5A5A5A5_5A5A5A5A, "a5 single");
      test_single(64'h0123456789ABCDEF, "rnd single");

      test_double(64'hA5A5A5A5_5A5A5A5A, "a5 double");

      $display("\n============================================");
      $display(" errors = %0d (after %0d tests)", errors, test_num);
      if (errors == 0) $display(" PASSED"); else $display(" FAILED");
      $display("============================================");
      $finish;
   end

   initial begin #500000; $display("FAILED (watchdog timeout)"); $finish; end

`ifdef WAVES
   initial begin $dumpfile("test_hamming_smoke.vcd");
      $dumpvars(0, test_hamming_smoke); end
`endif

endmodule
