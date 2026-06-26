//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Reed-Solomon RS(544,514) SYNDROME computer (KP4, GF(2^10)).
//
// Computes the 2t=30 syndromes S_i = r(alpha^(FCR+i)), FCR=0, i=0..29, by
// Horner evaluation of the received codeword (high-order symbol first). One
// symbol/clock: 30 parallel Horner cells, each a constant GF multiply by
// alpha^i (one rs_gfmul, generated) plus an XOR with the incoming symbol. A
// clean codeword yields all-zero syndromes.
//
//#############################################################################

module rs_syndrome
  #(parameter M = 10,	 // symbol width
    parameter TWOT = 30) // number of syndromes (2t)
   (
    input		clk,
    input		rst,
    input		in_valid,
    input		in_sop,	 // first symbol of the codeword
    input		in_last, // last symbol of the codeword
    input [M-1:0]	in_sym,
    output reg		s_valid, // syndromes ready (one cycle after last)
    output reg		s_nz,	 // any syndrome nonzero (errors present)
    output [TWOT*M-1:0]	s_flat	 // S[i] at s_flat[i*M +: M]
    );

   // alpha^i packed with alpha^0 in the low bits: APOW[i*M +: M] = alpha^i
   localparam [TWOT*M-1:0] APOW = {
				   10'd800, 10'd400, 10'd200, 10'd100, 10'd50,    // a29..a25
				   10'd25,  10'd520, 10'd260, 10'd130, 10'd65,    // a24..a20
				   10'd548, 10'd274, 10'd137, 10'd576, 10'd288,   // a19..a15
				   10'd144, 10'd72,  10'd36,  10'd18,  10'd9,     // a14..a10
				   10'd512, 10'd256, 10'd128, 10'd64,  10'd32,    // a9..a5
				   10'd16,  10'd8,   10'd4,   10'd2,   10'd1};    // a4..a0

   reg [M-1:0]		   acc [0:TWOT-1];
   wire [M-1:0]		   mul [0:TWOT-1];   // acc[i] * alpha^i
   wire [M-1:0]		   nxt [0:TWOT-1];   // next accumulator value

   genvar		   i;
   generate
      for (i = 0; i < TWOT; i = i + 1) begin : g_cell
         rs_gfmul u_mul (.a(acc[i]), .b(APOW[i*M +: M]), .product(mul[i]));
         // first symbol: acc=0 so Horner step = in_sym; else acc*alpha ^ sym
         assign nxt[i] = (in_sop ? {M{1'b0}} : mul[i]) ^ in_sym;
         assign s_flat[i*M +: M] = acc[i];
      end
   endgenerate

   integer k;
   always @(posedge clk) begin
      if (rst) begin
         s_valid <= 1'b0; s_nz <= 1'b0;
         for (k = 0; k < TWOT; k = k + 1) acc[k] <= {M{1'b0}};
      end
      else begin
         s_valid <= 1'b0;
         if (in_valid) begin
            for (k = 0; k < TWOT; k = k + 1) acc[k] <= nxt[k];
            if (in_last) s_valid <= 1'b1;   // accs hold final S next cycle
         end
      end
   end

   // s_nz reflects the registered syndromes when valid
   always @(posedge clk) begin
      if (rst) s_nz <= 1'b0;
      else if (in_valid && in_last) begin
         // OR-reduce the next (final) accumulators
         s_nz <= |{nxt[0],nxt[1],nxt[2],nxt[3],nxt[4],nxt[5],nxt[6],nxt[7],
                   nxt[8],nxt[9],nxt[10],nxt[11],nxt[12],nxt[13],nxt[14],
                   nxt[15],nxt[16],nxt[17],nxt[18],nxt[19],nxt[20],nxt[21],
                   nxt[22],nxt[23],nxt[24],nxt[25],nxt[26],nxt[27],nxt[28],
                   nxt[29]};
      end
   end

endmodule
