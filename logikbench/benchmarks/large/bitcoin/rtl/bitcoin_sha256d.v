//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * bitcoin_sha256d: double-SHA256 of an 80-byte block header.
 *
 * SHA256d(header) = SHA256(SHA256(header)). The 640-bit header spans two
 * 512-bit message blocks; the caller supplies:
 *   block_a = header bytes  0..63              (nonce-independent)
 *   block_b = header bytes 64..79 + SHA padding (holds the nonce)
 * The second hash is SHA256 of the 256-bit first digest, padded to one block.
 *
 * A single sha256_core (from the sha256 benchmark) is sequenced through three
 * compressions: init(block_a) -> next(block_b) -> init(pad(H1)). digest_valid
 * is edge-detected so the running digest is never sampled stale between passes.
 ******************************************************************************/
module bitcoin_sha256d
  (
   input  wire         clk,
   input  wire         reset_n,
   input  wire         start,     // pulse; block_a/block_b must be stable
   input  wire [511:0] block_a,   // message block 0 (header[0..63])
   input  wire [511:0] block_b,   // message block 1 (header[64..79] + padding)
   output wire         done,      // 1-cycle pulse when 'hash' is valid
   output wire [255:0] hash       // double-SHA256 result
   );

   // ---- sha256_core instance (SHA-256 mode) --------------------------------
   reg          core_init;
   reg          core_next;
   reg  [511:0] core_block;
   wire         core_ready;
   wire [255:0] core_digest;
   wire         core_digest_valid;

   sha256_core u_core
     (.clk          (clk),
      .reset_n      (reset_n),
      .init         (core_init),
      .next         (core_next),
      .mode         (1'b1),            // 1 = SHA-256
      .block        (core_block),
      .ready        (core_ready),
      .digest       (core_digest),
      .digest_valid (core_digest_valid));

   // rising edge of digest_valid = a compression just finished
   reg  dv_d;
   wire dv_rise = core_digest_valid & ~dv_d;

   // second-hash block: 256-bit H1 + SHA padding (0x80, zeros, length = 256)
   reg  [255:0] h1;
   wire [511:0] block_c = {h1, 8'h80, 184'd0, 64'd256};

   localparam ST_IDLE  = 3'd0,
              ST_WAITA = 3'd1,
              ST_WAITB = 3'd2,
              ST_INITC = 3'd3,
              ST_WAITC = 3'd4;

   reg [2:0]   state;
   reg [255:0] hash_reg;
   reg         done_reg;

   assign done = done_reg;
   assign hash = hash_reg;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state      <= ST_IDLE;
         core_init  <= 1'b0;
         core_next  <= 1'b0;
         core_block <= 512'd0;
         h1         <= 256'd0;
         hash_reg   <= 256'd0;
         done_reg   <= 1'b0;
         dv_d       <= 1'b0;
      end
      else begin
         dv_d      <= core_digest_valid;
         core_init <= 1'b0;
         core_next <= 1'b0;
         done_reg  <= 1'b0;

         case (state)
           ST_IDLE:
             if (start && core_ready) begin
                core_block <= block_a;
                core_init  <= 1'b1;
                state      <= ST_WAITA;
             end

           ST_WAITA:                    // block_a done -> issue block_b
             if (dv_rise) begin
                core_block <= block_b;
                core_next  <= 1'b1;
                state      <= ST_WAITB;
             end

           ST_WAITB:                    // block_b done -> H1 = running digest
             if (dv_rise) begin
                h1    <= core_digest;
                state <= ST_INITC;
             end

           ST_INITC:                    // hash H1 (second SHA-256)
             if (core_ready) begin
                core_block <= block_c;
                core_init  <= 1'b1;
                state      <= ST_WAITC;
             end

           ST_WAITC:                    // second hash done -> final digest
             if (dv_rise) begin
                hash_reg <= core_digest;
                done_reg <= 1'b1;
                state    <= ST_IDLE;
             end

           default: state <= ST_IDLE;
         endcase
      end
   end

endmodule
