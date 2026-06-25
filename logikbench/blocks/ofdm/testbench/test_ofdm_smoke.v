/******************************************************************************
 * Testbench: ofdm loopback modem smoke test (self-checking, round-trip).
 *
 * Drives random bits + a modulation select through the full TX->RX loopback
 * (ofdm = ofdm_tx + ofdm_rx, ideal internal channel) and checks the recovered
 * bits equal the transmitted bits.
 *
 * TESTED:
 *   - End-to-end bit recovery for every supported modulation: QPSK, 16-QAM,
 *     and 64-QAM (multiple random frames each).
 *   - The QAM map/demap, IFFT/FFT (via the fft block), cyclic prefix, and the
 *     16/64-QAM amplitude rescale path.
 *
 * NOT TESTED:
 *   - Ideal channel only: no AWGN/multipath, equalizer is identity, so this
 *     is a clean encode/decode round-trip (no BER/EVM characterization).
 *   - No pilot/null subcarrier map (all 64 subcarriers carry data).
 *   - Only N=64 / CP=16 / DW=16; no carrier/timing sync or channel estimation.
 *   - Back-to-back symbols (one symbol per transaction).
 ******************************************************************************/
`timescale 1ns/1ps
module test_ofdm_smoke;
   localparam N=64, DW=16, NB=6*N;
   reg	      clk=0, rst, in_valid; reg [1:0] mod; reg [NB-1:0] in_bits;
   wire out_valid; wire [NB-1:0] out_bits;
   ofdm #(.DW(DW),.N(N)) dut(.clk(clk),.rst(rst),.in_valid(in_valid),
			     .mod(mod),.in_bits(in_bits),.out_valid(out_valid),.out_bits(out_bits));
   always #5 clk=~clk;
   integer errors, test_num, k, b, w; reg [31:0] lfsr; reg [NB-1:0] exp;

   task run; input [1:0] msel; input [8*10-1:0] tag;
      integer sc, nb; reg [2:0] ifld, qfld;
      begin
	 test_num=test_num+1;
	 nb = msel + 1;                       // bits per axis
	 exp = {NB{1'b0}};
	 for (sc=0;sc<N;sc=sc+1) begin
            ifld=0; qfld=0;
            for (b=0;b<nb;b=b+1) begin
               lfsr={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]}; ifld[b]=lfsr[0];
               lfsr={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]}; qfld[b]=lfsr[0];
            end
            exp[sc*6   +: 3] = ifld;
            exp[sc*6+3 +: 3] = qfld;
	 end
	 @(posedge clk); in_valid<=1; mod<=msel; in_bits<=exp;
	 @(posedge clk); in_valid<=0;
	 w=0; while(!out_valid && w<2000) begin @(posedge clk); w=w+1; end
	 if (!out_valid) begin errors=errors+1; $display("FAIL [%0s] no out",tag); end
	 else if (out_bits!==exp) begin
            errors=errors+1; $display("FAIL [%0s] mismatch", tag);
	 end
	 else $display("PASS [%0s]", tag);
      end
   endtask

   initial begin
      rst=1; in_valid=0; mod=0; in_bits=0; errors=0; test_num=0; lfsr=32'hCAFEBABE;
      @(posedge clk); @(posedge clk); rst<=0;
      run(2'd0,"qpsk-1"); run(2'd0,"qpsk-2");
      run(2'd1,"16qam-1"); run(2'd1,"16qam-2");
      run(2'd2,"64qam-1"); run(2'd2,"64qam-2"); run(2'd2,"64qam-3");
      $display("\n==== errors=%0d after %0d tests ====", errors, test_num);
      if (errors==0) $display(" PASSED"); else $display(" FAILED");
      $finish;
   end
   initial begin #5000000; $display("FAILED (timeout)"); $finish; end
endmodule
