/******************************************************************************
 * Testbench: fft accelerator smoke test (self-checking)
 *
 * Purpose: stream complex frames through the streaming R2SDF FFT and verify
 *          the output against a behavioral DFT reference (computed here with
 *          $sin/$cos in real arithmetic). The DUT emits bins in bit-reversed
 *          order, scaled by 1/N; the checker accounts for both, and searches
 *          for the pipeline latency offset so no latency constant is hardwired.
 *
 * Vectors: impulse, DC, single tone, and a deterministic pseudo-random frame.
 ******************************************************************************/
`timescale 1ns / 1ps

module test_fft_smoke;

   localparam DW    = 16;
   localparam N     = 64;
   localparam LOG2N = 6;
   localparam CAP   = 4*N;          // capture window
   real	      TOL;                  // max abs error (normalized units)

   //##########################################################
   // Clock / DUT
   //##########################################################
   reg	      clk;
   reg	      rst;
   reg	      in_valid;
   reg signed [DW-1:0] in_real, in_imag;
   wire		       out_valid;
   wire signed [DW-1:0]	out_real, out_imag;

   fft #(.DW(DW), .N(N)) dut
     (.clk(clk), .rst(rst), .in_valid(in_valid),
      .in_real(in_real), .in_imag(in_imag),
      .out_valid(out_valid), .out_real(out_real), .out_imag(out_imag));

   always #5 clk = ~clk;

   //##########################################################
   // Storage
   //##########################################################
   reg signed [DW-1:0] xin_r [0:N-1];
   reg signed [DW-1:0] xin_i [0:N-1];
   reg signed [DW-1:0] cap_r [0:CAP-1];
   reg signed [DW-1:0] cap_i [0:CAP-1];
   real		       gold_r [0:N-1];
   real		       gold_i [0:N-1];

   integer	       errors, test_num;
   integer	       n, k;

   //##########################################################
   // Helpers
   //##########################################################
   function real fx2real;
      input signed [DW-1:0] v;
      begin
         fx2real = $itor(v) / 32768.0;
      end
   endfunction

   function [LOG2N-1:0] bitrev;
      input [LOG2N-1:0] in;
      integer		b;
      begin
         for (b = 0; b < LOG2N; b = b + 1)
           bitrev[b] = in[LOG2N-1-b];
      end
   endfunction

   // behavioral DFT of xin[] -> gold[] (already divided by N to match DUT)
   task compute_golden;
      integer kk, nn;
      real    ang, c, s, xr, xi, ar, ai;
      begin
         for (kk = 0; kk < N; kk = kk + 1) begin
            ar = 0.0; ai = 0.0;
            for (nn = 0; nn < N; nn = nn + 1) begin
               ang = 2.0 * 3.14159265358979 * kk * nn / N;
               c = $cos(ang); s = $sin(ang);
               xr = fx2real(xin_r[nn]);
               xi = fx2real(xin_i[nn]);
               ar = ar + xr*c + xi*s;   // real part of x * e^{-j..}
               ai = ai - xr*s + xi*c;   // imag part
            end
            gold_r[kk] = ar / N;
            gold_i[kk] = ai / N;
         end
      end
   endtask

   // stream the frame (then zeros) and capture every cycle
   task stream_and_capture;
      integer i;
      begin
         @(posedge clk); rst <= 1'b1; in_valid <= 1'b0;
         in_real <= 0; in_imag <= 0;
         @(posedge clk); rst <= 1'b0;
         for (i = 0; i < CAP; i = i + 1) begin
            @(posedge clk);
            in_valid <= 1'b1;
            if (i < N) begin in_real <= xin_r[i]; in_imag <= xin_i[i]; end
            else       begin in_real <= 0;        in_imag <= 0;        end
            cap_r[i] <= out_real;
            cap_i[i] <= out_imag;
         end
         @(posedge clk);
      end
   endtask

   // find the latency offset that best matches gold (bit-reversed), then check
   task check_frame;
      input [8*16-1:0] tag;
      integer	       L, bestL, m, brm;
      real	       err, besterr, e, mx;
      begin
         besterr = 1.0e9; bestL = 0;
         for (L = 0; L + N <= CAP; L = L + 1) begin
            err = 0.0;
            for (m = 0; m < N; m = m + 1) begin
               brm = bitrev(m[LOG2N-1:0]);
               e = fx2real(cap_r[L+m]) - gold_r[brm];
               if (e < 0.0) e = -e; err = err + e;
               e = fx2real(cap_i[L+m]) - gold_i[brm];
               if (e < 0.0) e = -e; err = err + e;
            end
            if (err < besterr) begin besterr = err; bestL = L; end
         end
         // worst single-bin error at the best offset
         mx = 0.0;
         for (m = 0; m < N; m = m + 1) begin
            brm = bitrev(m[LOG2N-1:0]);
            e = fx2real(cap_r[bestL+m]) - gold_r[brm];
            if (e < 0.0) e = -e; if (e > mx) mx = e;
            e = fx2real(cap_i[bestL+m]) - gold_i[brm];
            if (e < 0.0) e = -e; if (e > mx) mx = e;
         end
         if (mx > TOL) begin
            errors = errors + 1;
            $display("FAIL [%0s] maxerr=%f (>%f) at offset=%0d", tag, mx, TOL,
                     bestL);
         end
         else
           $display("PASS [%0s] maxerr=%f offset=%0d", tag, mx, bestL);
      end
   endtask

   task run_vector;
      input [8*16-1:0] tag;
      begin
         test_num = test_num + 1;
         compute_golden;
         stream_and_capture;
         check_frame(tag);
      end
   endtask

   //##########################################################
   // Vector generators
   //##########################################################
   task gen_impulse;
      integer i;
      begin
         for (i = 0; i < N; i = i + 1) begin xin_r[i]=0; xin_i[i]=0; end
         xin_r[0] = 16'sd16384;   // 0.5
      end
   endtask

   task gen_dc;
      integer i;
      begin
         for (i = 0; i < N; i = i + 1) begin xin_r[i]=16'sd8192; xin_i[i]=0; end
      end
   endtask

   task gen_tone;
      input integer kbin;
      integer	    i;
      real	    a;
      begin
         for (i = 0; i < N; i = i + 1) begin
            a = 0.4 * $cos(2.0*3.14159265358979*kbin*i/N);
            xin_r[i] = $rtoi(a * 32768.0);
            xin_i[i] = 0;
         end
      end
   endtask

   task gen_random;
      integer i;
      reg [31:0] lfsr;
      begin
         lfsr = 32'hdeadbeef;
         for (i = 0; i < N; i = i + 1) begin
            lfsr = {lfsr[30:0], lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
            xin_r[i] = $signed(lfsr[15:0]) >>> 3;   // keep magnitude modest
            lfsr = {lfsr[30:0], lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
            xin_i[i] = $signed(lfsr[15:0]) >>> 3;
         end
      end
   endtask

   //##########################################################
   // Main
   //##########################################################
   initial begin
      clk = 0; rst = 0; in_valid = 0; in_real = 0; in_imag = 0;
      errors = 0; test_num = 0;
      TOL = 0.03;

      gen_impulse;   run_vector("impulse");
      gen_dc;        run_vector("dc");
      gen_tone(5);   run_vector("tone k=5");
      gen_tone(13);  run_vector("tone k=13");
      gen_random;    run_vector("random");

      $display("\n============================================");
      $display(" errors = %0d (after %0d tests)", errors, test_num);
      if (errors == 0) $display(" PASSED"); else $display(" FAILED");
      $display("============================================");
      $finish;
   end

   initial begin
      #2000000;
      $display("FAILED (watchdog timeout)");
      $finish;
   end

`ifdef WAVES
   initial begin
      $dumpfile("test_fft_smoke.vcd");
      $dumpvars(0, test_fft_smoke);
   end
`endif

endmodule
