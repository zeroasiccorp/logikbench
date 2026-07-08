//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// jesd204b_scramble: JESD204B self-synchronous scrambler and descrambler,
// polynomial 1 + x^14 + x^15, one octet (8 bits) per cycle, MSB first. The
// descrambler self-synchronizes to the scrambler within two octets. Scrambling
// is applied before 8b/10b encoding and reversed after decoding.
//
//#############################################################################
module jscram8
  (
   input	clk,
   input	nreset,
   input	en,  // advance on a data octet
   input [7:0]	din, // plaintext octet
   output [7:0]	scr  // scrambled octet
   );

   reg [14:0]    state;    // x^1 (bit0) .. x^15 (bit14)
   wire [14:0]	 st [0:8];
   assign st[0] = state;

   genvar        j;
   generate
      for (j = 0; j < 8; j = j + 1) begin : g_scr
         // process MSB first (bit 7 down to 0)
         assign scr[7-j]  = din[7-j] ^ st[j][13] ^ st[j][14];
         assign st[j+1]   = {st[j][13:0], scr[7-j]};
      end
   endgenerate

   always @(posedge clk or negedge nreset)
     if (!nreset)   state <= 15'b0;
     else if (en)   state <= st[8];

endmodule

//#############################################################################
// Matching self-synchronous descrambler (state fed by received octet bits).
//#############################################################################
module jdescram8
  (
   input	clk,
   input	nreset,
   input	en,
   input [7:0]	din, // scrambled octet
   output [7:0]	dsc  // recovered octet
   );

   reg [14:0]    state;
   wire [14:0]	 st [0:8];
   assign st[0] = state;

   genvar        j;
   generate
      for (j = 0; j < 8; j = j + 1) begin : g_dsc
         assign dsc[7-j]  = din[7-j] ^ st[j][13] ^ st[j][14];
         assign st[j+1]   = {st[j][13:0], din[7-j]};
      end
   endgenerate

   always @(posedge clk or negedge nreset)
     if (!nreset)   state <= 15'b0;
     else if (en)   state <= st[8];

endmodule
