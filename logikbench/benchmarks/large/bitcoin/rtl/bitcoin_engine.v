//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * bitcoin_engine: one nonce-search mining lane.
 *
 * Starting at nonce_init and stepping by NONCE_STRIDE, the engine inserts the
 * trial nonce into the header's second block, computes SHA256d, and checks the
 * result against the target. On the first hit it latches the golden nonce and
 * asserts 'found'. block_a and block_b_base (nonce field zeroed) are constant
 * across the search -- only the nonce word changes per trial.
 ******************************************************************************/
module bitcoin_engine
  #(parameter [31:0] NONCE_STRIDE = 32'd1)
  (
   input  wire         clk,
   input  wire         reset_n,
   input  wire         start,
   input  wire [511:0] block_a,       // header block 0 (constant)
   input  wire [511:0] block_b_base,  // header block 1, nonce field = 0
   input  wire [255:0] target,
   input  wire [31:0]  nonce_init,
   output wire         found,
   output wire [31:0]  golden_nonce,
   output wire         busy
   );

   reg  [31:0]  nonce;
   // insert the trial nonce into the header nonce field (block bits [415:384])
   wire [511:0] block_b = {block_b_base[511:416], nonce, block_b_base[383:0]};

   reg          d_start;
   wire         d_done;
   wire [255:0] d_hash;

   bitcoin_sha256d u_hash
     (.clk     (clk),
      .reset_n (reset_n),
      .start   (d_start),
      .block_a (block_a),
      .block_b (block_b),
      .done    (d_done),
      .hash    (d_hash));

   wire hit;
   bitcoin_compare u_cmp (.hash(d_hash), .target(target), .below(hit));

   localparam ST_IDLE = 2'd0,
              ST_RUN  = 2'd1,
              ST_WAIT = 2'd2,
              ST_DONE = 2'd3;

   reg [1:0]  state;
   reg        found_reg;
   reg [31:0] golden_reg;

   assign found        = found_reg;
   assign golden_nonce = golden_reg;
   assign busy         = (state == ST_RUN) || (state == ST_WAIT);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state      <= ST_IDLE;
         nonce      <= 32'd0;
         d_start    <= 1'b0;
         found_reg  <= 1'b0;
         golden_reg <= 32'd0;
      end
      else begin
         d_start <= 1'b0;
         case (state)
           ST_IDLE:
             if (start) begin
                nonce     <= nonce_init;
                found_reg <= 1'b0;
                state     <= ST_RUN;
             end

           ST_RUN: begin           // launch one SHA256d over the current nonce
              d_start <= 1'b1;
              state   <= ST_WAIT;
           end

           ST_WAIT:
             if (d_done) begin
                if (hit) begin
                   found_reg  <= 1'b1;
                   golden_reg <= nonce;
                   state      <= ST_DONE;
                end
                else begin
                   nonce <= nonce + NONCE_STRIDE;
                   state <= ST_RUN;
                end
             end

           ST_DONE: ;              // hold the result until reset / new start

           default: state <= ST_IDLE;
         endcase
      end
   end

endmodule
