//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Reed-Solomon RS(544,514) systematic ENCODER (KP4, GF(2^10)).
//
// Codeword = message || parity, parity = remainder of (msg * x^2t) / g(x)
// computed by an LFSR (polynomial division). One symbol/clock: the K=514 data
// symbols stream through unchanged, then the 30 parity symbols are shifted out
// (high-order first), so the 544-symbol codeword is data-then-parity, matching
// the reference model. The 30 generator taps are constant GF multiplies (one
// rs_gfmul per tap, generated; synthesis folds the constant operand).
//
//#############################################################################

module rs_enc
  #(parameter M = 10,	 // symbol width
    parameter K = 514,	 // data symbols
    parameter TWOT = 30, // parity symbols (2t)
    parameter CW = 11)	 // symbol-count width (clog2(544))
   (
    input	       clk,
    input	       rst,
    input	       in_valid,
    input [M-1:0]      in_sym,
    input	       in_last,	// asserted on the K-th (last) data symbol
    output	       in_ready,
    output reg	       out_valid,
    output reg [M-1:0] out_sym,
    output reg	       out_last
    );

   localparam S_DATA = 1'b0, S_PAR = 1'b1;

   // generator polynomial g(x) coefficients g[0..29] (g[30]=1), packed with
   // g[0] in the low bits so GPOLY[j*M +: M] = g[j] (constant, no init block)
   localparam [TWOT*M-1:0] GPOLY = {
				    10'd575, 10'd552, 10'd187, 10'd230, 10'd552,   // g29..g25
				    10'd1,   10'd108, 10'd565, 10'd282, 10'd249,   // g24..g20
				    10'd593, 10'd132, 10'd94,  10'd720, 10'd495,   // g19..g15
				    10'd385, 10'd942, 10'd503, 10'd883, 10'd361,   // g14..g10
				    10'd788, 10'd610, 10'd193, 10'd392, 10'd127,   // g9..g5
				    10'd185, 10'd158, 10'd128, 10'd834, 10'd523};  // g4..g0

   reg [M-1:0]		   par [0:TWOT-1];   // LFSR parity state
   reg			   state;
   reg [CW-1:0]		   cnt;              // parity output counter

   wire			   feed = (state == S_DATA) && in_valid;
   wire [M-1:0]		   fb = in_sym ^ par[TWOT-1];

   // constant-multiply taps: prod[j] = fb * g[j]
   wire [M-1:0]		   prod [0:TWOT-1];
   genvar		   j;
   generate
      for (j = 0; j < TWOT; j = j + 1) begin : g_tap
         rs_gfmul u_mul (.a(fb), .b(GPOLY[j*M +: M]), .product(prod[j]));
      end
   endgenerate

   assign in_ready = (state == S_DATA);

   integer k;
   always @(posedge clk) begin
      if (rst) begin
         state <= S_DATA; cnt <= 0; out_valid <= 1'b0; out_last <= 1'b0;
         out_sym <= {M{1'b0}};
         for (k = 0; k < TWOT; k = k + 1) par[k] <= {M{1'b0}};
      end
      else begin
         out_valid <= 1'b0; out_last <= 1'b0;
         if (state == S_DATA) begin
            if (feed) begin
               // pass the data symbol straight to the codeword output
               out_sym   <= in_sym;
               out_valid <= 1'b1;
               // LFSR update: par[j] <= par[j-1] ^ fb*g[j], par[0] <= fb*g[0]
               par[0] <= prod[0];
               for (k = 1; k < TWOT; k = k + 1)
                 par[k] <= par[k-1] ^ prod[k];
               if (in_last) begin
                  state <= S_PAR;
                  cnt   <= 0;
               end
            end
         end
         else begin // S_PAR: shift out parity high-order first (par[29..0])
            out_sym   <= par[TWOT-1 - cnt];
            out_valid <= 1'b1;
            out_last  <= (cnt == TWOT-1);
            if (cnt == TWOT-1) begin
               state <= S_DATA;
               cnt   <= 0;
            end else
              cnt <= cnt + 1'b1;
         end
      end
   end

endmodule
