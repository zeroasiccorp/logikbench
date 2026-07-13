//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// Testbench: dma scatter-gather AXI4 copy engine (self-check).
// A behavioral AXI4 slave memory model backs the DMA master. A 3-descriptor
// chain is placed in memory; each descriptor copies a source region to a
// destination region (the last descriptor is >DEPTH beats to exercise chunking
// and the LAST flag). After 'done', every destination beat is compared to its
// source. Prints PASSED or FAILED.
// TESTED: descriptor fetch, chained SG walk, INCR read/write bursts, chunking.
// NOT TESTED: unaligned addresses, WSTRB masking, multiple outstanding bursts.
//#############################################################################
`timescale 1ns/1ps
module test_dma_smoke;

   localparam DW    = 64;
   localparam AW    = 32;
   localparam IDW   = 4;
   localparam DEPTH = 32;
   localparam SHIFT = 3;               // log2(DW/8), byte-addr -> word index
   localparam MEMW  = 1024;

   reg              clk = 1'b0;
   reg              reset_n;
   reg              start;
   reg  [AW-1:0]    desc_head_ptr;
   wire             busy, done;

   // AXI master wires (driven by the DUT / by the TB slave model)
   wire [AW-1:0]    araddr;   wire [7:0] arlen;   wire [2:0] arsize;
   wire [1:0]       arburst;  wire [IDW-1:0] arid; wire arvalid; reg arready;
   reg  [DW-1:0]    rdata;    reg rlast; reg rvalid; wire rready;
   wire [AW-1:0]    awaddr;   wire [7:0] awlen;   wire [2:0] awsize;
   wire [1:0]       awburst;  wire [IDW-1:0] awid; wire awvalid; reg awready;
   wire [DW-1:0]    wdata;    wire [DW/8-1:0] wstrb; wire wlast; wire wvalid; reg wready;
   reg              bvalid;   wire bready;

   always #5 clk = ~clk;

   dma #(.DW(DW), .AW(AW), .IDW(IDW), .DEPTH(DEPTH)) dut
     (.clk(clk), .reset_n(reset_n), .start(start), .desc_head_ptr(desc_head_ptr),
      .busy(busy), .done(done),
      .araddr(araddr), .arlen(arlen), .arsize(arsize), .arburst(arburst),
      .arid(arid), .arvalid(arvalid), .arready(arready),
      .rdata(rdata), .rlast(rlast), .rvalid(rvalid), .rready(rready),
      .awaddr(awaddr), .awlen(awlen), .awsize(awsize), .awburst(awburst),
      .awid(awid), .awvalid(awvalid), .awready(awready),
      .wdata(wdata), .wstrb(wstrb), .wlast(wlast), .wvalid(wvalid), .wready(wready),
      .bvalid(bvalid), .bready(bready));

   // ---- backing memory ----
   reg [DW-1:0] mem [0:MEMW-1];

   // ---- AXI slave: read channel ----
   localparam RIDLE = 1'b0, RBURST = 1'b1;
   reg          rst_r;
   reg [AW-1:0] r_idx;
   reg [8:0]    r_cnt;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         rst_r <= RIDLE; arready <= 1'b0; rvalid <= 1'b0; rlast <= 1'b0;
         rdata <= {DW{1'b0}}; r_idx <= {AW{1'b0}}; r_cnt <= 9'd0;
      end
      else case (rst_r)
        RIDLE: begin
           arready <= 1'b1; rvalid <= 1'b0; rlast <= 1'b0;
           if (arvalid && arready) begin
              arready <= 1'b0;
              r_idx   <= araddr >> SHIFT;
              r_cnt   <= arlen + 1'b1;
              rdata   <= mem[araddr >> SHIFT];
              rvalid  <= 1'b1;
              rlast   <= (arlen == 8'd0);
              rst_r   <= RBURST;
           end
        end
        RBURST:
          if (rvalid && rready) begin
             if (r_cnt == 9'd1) begin
                rvalid  <= 1'b0;
                rst_r   <= RIDLE;
                arready <= 1'b1;
             end
             else begin
                r_idx <= r_idx + 1'b1;
                r_cnt <= r_cnt - 1'b1;
                rdata <= mem[r_idx + 1'b1];
                rlast <= (r_cnt == 9'd2);
             end
          end
      endcase
   end

   // ---- AXI slave: write channel ----
   localparam WIDLE = 2'd0, WBURST = 2'd1, WRESP = 2'd2;
   reg [1:0]    wst;
   reg [AW-1:0] w_idx;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         wst <= WIDLE; awready <= 1'b0; wready <= 1'b0; bvalid <= 1'b0;
         w_idx <= {AW{1'b0}};
      end
      else case (wst)
        WIDLE: begin
           awready <= 1'b1; wready <= 1'b0; bvalid <= 1'b0;
           if (awvalid && awready) begin
              awready <= 1'b0;
              w_idx   <= awaddr >> SHIFT;
              wready  <= 1'b1;
              wst     <= WBURST;
           end
        end
        WBURST:
          if (wvalid && wready) begin
             mem[w_idx] <= wdata;
             w_idx      <= w_idx + 1'b1;
             if (wlast) begin
                wready <= 1'b0;
                bvalid <= 1'b1;
                wst    <= WRESP;
             end
          end
        WRESP:
          if (bvalid && bready) begin
             bvalid  <= 1'b0;
             awready <= 1'b1;
             wst     <= WIDLE;
          end
      endcase
   end

   // ---- stimulus + self-check ----
   integer i, errors;
   reg [DW-1:0] exp, got;

   // source/destination word regions and lengths (beats)
   // desc0: src word 0,  dst word 200, len 5
   // desc1: src word 8,  dst word 208, len 3
   // desc2: src word 16, dst word 216, len 40  (> DEPTH -> two chunks)
   task check_region(input integer swrd, input integer dwrd, input integer len);
      integer k;
      begin
         for (k = 0; k < len; k = k + 1) begin
            exp = mem[swrd + k];
            got = mem[dwrd + k];
            if (got !== exp) begin
               errors = errors + 1;
               if (errors <= 3)
                 $display("FAILED: dst word %0d = 0x%016x, expected 0x%016x",
                          dwrd + k, got, exp);
            end
         end
      end
   endtask

   initial begin
      errors = 0;
      for (i = 0; i < MEMW; i = i + 1) mem[i] = {DW{1'b0}};

      // source patterns
      for (i = 0; i < 5;  i = i + 1) mem[0  + i] = 64'hA0000000_00000000 + i*3 + 1;
      for (i = 0; i < 3;  i = i + 1) mem[8  + i] = 64'hB0000000_00000000 + i*5 + 2;
      for (i = 0; i < 40; i = i + 1) mem[16 + i] = 64'hC0000000_00000000 + i*7 + 3;

      // descriptor chain (4 words each): src, dst, len, next|LAST
      // desc0 @ word 100 (byte 800)
      mem[100] = 0    << SHIFT;   // src byte addr = word 0
      mem[101] = 200  << SHIFT;   // dst byte addr = word 200
      mem[102] = 5;               // len beats
      mem[103] = (104 << SHIFT);  // next = desc1 byte addr, LAST=0
      // desc1 @ word 104 (byte 832)
      mem[104] = 8   << SHIFT;
      mem[105] = 208 << SHIFT;
      mem[106] = 3;
      mem[107] = (108 << SHIFT);  // next = desc2, LAST=0
      // desc2 @ word 108 (byte 864) -- LAST
      mem[108] = 16  << SHIFT;
      mem[109] = 216 << SHIFT;
      mem[110] = 40;
      mem[111] = 64'h1;           // next=0, LAST=1

      start = 1'b0;
      desc_head_ptr = 100 << SHIFT;   // head = desc0 byte addr
      reset_n = 1'b0;
      repeat (4) @(posedge clk);
      reset_n <= 1'b1;
      @(posedge clk);

      start <= 1'b1;
      @(posedge clk);
      start <= 1'b0;

      // wait for completion
      @(posedge done);
      @(posedge clk);

      check_region(0,  200, 5);
      check_region(8,  208, 3);
      check_region(16, 216, 40);

      if (errors == 0)
        $display("PASSED");
      else
        $display("FAILED: %0d mismatched words", errors);
      $finish;
   end

   // watchdog
   initial begin
      #200000;
      $display("FAILED: timeout, dma did not complete");
      $finish;
   end

endmodule
