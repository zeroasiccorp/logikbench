/******************************************************************************
 * Testbench: viterbi decoder smoke test (self-checking, round-trip).
 *
 * Encodes a random bit stream (+6-bit zero tail) with the K=7 133/171 rate-1/2
 * convolutional code, maps coded bits to soft symbols, optionally injects a
 * few channel errors, feeds the decoder, and checks the decoded bits equal the
 * original input bits.
 ******************************************************************************/
`timescale 1ns / 1ps

module test_viterbi_smoke;

   localparam SW     = 3;
   localparam MAXLEN = 256;
   localparam SHI    = (1<<SW) - 1;   // soft "1"
   localparam SLO    = 0;             // soft "0"

   reg	      clk, rst, in_valid, in_last;
   reg [SW-1:0]	in_sym0, in_sym1;
   wire		out_valid, out_bit;

   viterbi #(.SW(SW), .MAXLEN(MAXLEN)) dut
     (.clk(clk), .rst(rst), .in_valid(in_valid), .in_sym0(in_sym0),
      .in_sym1(in_sym1), .in_last(in_last),
      .out_valid(out_valid), .out_bit(out_bit));

   always #5 clk = ~clk;

   reg        orig [0:MAXLEN-1];   // original bits (data + tail)
   reg [SW-1:0]	sym0 [0:MAXLEN-1];
   reg [SW-1:0]	sym1 [0:MAXLEN-1];
   reg		dec  [0:MAXLEN-1];   // decoded bits
   integer	odx;
   integer	errors, test_num;

   // capture decoder output
   always @(posedge clk)
     if (out_valid) begin
        dec[odx] = out_bit;
        odx = odx + 1;
     end

   reg [5:0] enc_s;
   reg [31:0] lfsr;

   task run;
      input integer ndata;
      input integer nerr;        // coded-bit errors to inject
      input [8*16-1:0] tag;
      integer	       i, len, k, g0, g1, pos, which, bad;
      reg [6:0]	       v;
      begin
         test_num = test_num + 1;
         len = ndata + 6;        // + zero tail
         // random data bits, then 6 zero tail
         for (i = 0; i < ndata; i = i + 1) begin
            lfsr = {lfsr[30:0], lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
            orig[i] = lfsr[0];
         end
         for (i = ndata; i < len; i = i + 1) orig[i] = 1'b0;
         // encode
         enc_s = 6'b0;
         for (i = 0; i < len; i = i + 1) begin
            v  = {orig[i], enc_s};
            g0 = ^(v & 7'o133);
            g1 = ^(v & 7'o171);
            enc_s = v[6:1];
            sym0[i] = g0 ? SHI : SLO;
            sym1[i] = g1 ? SHI : SLO;
         end
         // inject errors (flip a coded soft symbol hard)
         for (bad = 0; bad < nerr; bad = bad + 1) begin
            lfsr = {lfsr[30:0], lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
            pos  = lfsr % len;
            which = lfsr[8];
            if (which) sym0[pos] = (sym0[pos]==SHI) ? SLO : SHI;
            else       sym1[pos] = (sym1[pos]==SHI) ? SLO : SHI;
         end
         // stream the frame
         @(posedge clk); rst <= 1'b1; in_valid <= 1'b0; in_last <= 1'b0;
         @(posedge clk); rst <= 1'b0;
         odx = 0;
         for (k = 0; k < len; k = k + 1) begin
            @(posedge clk);
            in_valid <= 1'b1; in_sym0 <= sym0[k]; in_sym1 <= sym1[k];
            in_last  <= (k == len-1);
         end
         @(posedge clk); in_valid <= 1'b0; in_last <= 1'b0;
         // wait for traceback + output
         k = 0;
         while (odx < len && k < 4*MAXLEN) begin @(posedge clk); k = k + 1; end
         // compare
         bad = 0;
         if (odx != len) bad = 1;
         else
           for (i = 0; i < len; i = i + 1)
             if (dec[i] !== orig[i]) bad = bad + 1;
         if (bad != 0) begin
            errors = errors + 1;
            $display("FAIL [%0s] ndata=%0d nerr=%0d mismatches=%0d (got %0d bits)",
                     tag, ndata, nerr, bad, odx);
         end
         else
           $display("PASS [%0s] ndata=%0d nerr=%0d", tag, ndata, nerr);
      end
   endtask

   initial begin
      clk=0; rst=0; in_valid=0; in_last=0; in_sym0=0; in_sym1=0;
      errors=0; test_num=0; odx=0; lfsr=32'h1234_5678;

      run(32,  0, "32 clean");
      run(64,  0, "64 clean");
      run(100, 0, "100 clean");
      run(64,  3, "64 +3err");
      run(100, 5, "100 +5err");
      run(150, 8, "150 +8err");

      $display("\n============================================");
      $display(" errors = %0d (after %0d tests)", errors, test_num);
      if (errors == 0) $display(" PASSED"); else $display(" FAILED");
      $display("============================================");
      $finish;
   end

   initial begin
      #5000000; $display("FAILED (watchdog timeout)"); $finish;
   end

`ifdef WAVES
   initial begin $dumpfile("test_viterbi_smoke.vcd"); $dumpvars(0, test_viterbi_smoke); end
`endif

endmodule
