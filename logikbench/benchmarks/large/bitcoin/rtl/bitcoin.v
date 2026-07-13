//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * bitcoin: parametrized SHA256d proof-of-work miner.
 *
 * Given an 80-byte block header, a difficulty target, and a base nonce, the
 * core searches for a nonce whose double-SHA256 digest is at or below the
 * target. NENGINES parallel lanes share the search space, interleaved: lane e
 * tries nonce_base + e, + e + NENGINES, ... The header is split into the two
 * SHA-256 message blocks once and broadcast to every lane; only the 32-bit
 * nonce field of the second block varies per trial.
 *
 * Header byte layout (as hashed, most-significant byte first):
 *   block_a = header[639:128]  (bytes 0..63,  nonce-independent)
 *   block_b = header[127:0] + SHA padding (bytes 64..79, holds the nonce)
 * The nonce occupies header bytes 76..79 == second-block bits [415:384].
 *
 * NENGINES scales the design (~one SHA-256 core per lane). Reuses sha256_core
 * from the sha256 benchmark (bound via the package dependency fileset).
 ******************************************************************************/
module bitcoin
  #(parameter integer NENGINES = 128)
  (
   input  wire         clk,
   input  wire         reset_n,
   input  wire         start,
   input  wire [639:0] header,        // 80-byte header (nonce field is a don't care)
   input  wire [255:0] target,
   input  wire [31:0]  nonce_base,
   output wire         found,
   output wire [31:0]  golden_nonce,
   output wire         busy
   );

   // split the header into the two SHA-256 message blocks (done once, shared)
   wire [511:0] block_a      = header[639:128];
   wire [511:0] block_b_base = {header[127:0], 8'h80, 312'd0, 64'd640};

   wire [NENGINES-1:0] e_found;
   wire [NENGINES-1:0] e_busy;
   wire [31:0]         e_golden [0:NENGINES-1];

   genvar g;
   generate
      for (g = 0; g < NENGINES; g = g + 1) begin: lane
         bitcoin_engine #(.NONCE_STRIDE(NENGINES[31:0])) u_eng
           (.clk          (clk),
            .reset_n      (reset_n),
            .start        (start),
            .block_a      (block_a),
            .block_b_base (block_b_base),
            .target       (target),
            .nonce_init   (nonce_base + g[31:0]),
            .found        (e_found[g]),
            .golden_nonce (e_golden[g]),
            .busy         (e_busy[g]));
      end
   endgenerate

   assign found = |e_found;
   assign busy  = |e_busy;

   // report the golden nonce of the lowest-index lane that hit
   integer i;
   reg [31:0] golden_r;
   always @* begin
      golden_r = 32'd0;
      for (i = NENGINES - 1; i >= 0; i = i - 1)
        if (e_found[i])
          golden_r = e_golden[i];
   end
   assign golden_nonce = golden_r;

endmodule
