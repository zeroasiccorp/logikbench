//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LPDDR5 link ECC: SEC-DED (single-error-correct, double-error-detect) over a
// 32-bit data lane, as a (39,32) extended Hamming code (32 data + 6 Hamming
// parity + 1 overall parity). The controller applies one lane per 32 data bits
// of the burst (link-ECC granularity).
//
// Hamming construction: data bit j occupies code position POS[j] (the j-th
// integer that is not a power of two, starting at 3); Hamming parity bit k
// covers every position whose index has bit k set; the overall parity bit makes
// the codeword even, giving double-error detection. POS is a packed constant
// (sliced by genvar at elaboration), so no functions/SV literals are needed.
//
// Two modules: lpddr5_ecc_enc (data -> code) and lpddr5_ecc_dec (code ->
// corrected data + corrected/uncorrectable flags).
//
//#############################################################################

//-----------------------------------------------------------------------------
// (39,32) SEC-DED encoder
//-----------------------------------------------------------------------------
module lpddr5_ecc_enc
  (
   input [31:0]	 data,
   output [38:0] code // {overall, parity[5:0], data[31:0]}
   );

   // code position of each data bit (non-powers-of-two from 3), index 0 = LSB
   localparam [6*32-1:0] POS =
			 {6'd38,6'd37,6'd36,6'd35,6'd34,6'd33,6'd31,6'd30,6'd29,6'd28,6'd27,6'd26,
			  6'd25,6'd24,6'd23,6'd22,6'd21,6'd20,6'd19,6'd18,6'd17,6'd15,6'd14,6'd13,
			  6'd12,6'd11,6'd10,6'd9,6'd7,6'd6,6'd5,6'd3};

   wire [31:0]		 pmask [0:5];
   wire [5:0]		 parity;
   genvar		 gk, gj;
   generate
      for (gk = 0; gk < 6; gk = gk + 1) begin : g_mask
	 for (gj = 0; gj < 32; gj = gj + 1) begin : g_bit
	    assign pmask[gk][gj] = (POS[gj*6 +: 6] >> gk) & 1'b1;
	 end
	 assign parity[gk] = ^(data & pmask[gk]);
      end
   endgenerate

   assign code = {(^data) ^ (^parity), parity, data};

endmodule

//-----------------------------------------------------------------------------
// (39,32) SEC-DED decoder/corrector
//-----------------------------------------------------------------------------
module lpddr5_ecc_dec
  (
   input [38:0]	 code,
   output [31:0] data,	// corrected data
   output	 corr,	// a single-bit error was corrected
   output	 uncorr	// a double-bit (uncorrectable) error was detected
   );

   localparam [6*32-1:0] POS =
			 {6'd38,6'd37,6'd36,6'd35,6'd34,6'd33,6'd31,6'd30,6'd29,6'd28,6'd27,6'd26,
			  6'd25,6'd24,6'd23,6'd22,6'd21,6'd20,6'd19,6'd18,6'd17,6'd15,6'd14,6'd13,
			  6'd12,6'd11,6'd10,6'd9,6'd7,6'd6,6'd5,6'd3};

   wire [31:0]		 rx_d = code[31:0];
   wire [5:0]		 rx_p = code[37:32];
   wire			 rx_o = code[38];

   wire [31:0]		 pmask [0:5];
   wire [5:0]		 syn;
   genvar		 gk, gj;
   generate
      for (gk = 0; gk < 6; gk = gk + 1) begin : g_mask
	 for (gj = 0; gj < 32; gj = gj + 1) begin : g_bit
	    assign pmask[gk][gj] = (POS[gj*6 +: 6] >> gk) & 1'b1;
	 end
	 assign syn[gk] = rx_p[gk] ^ (^(rx_d & pmask[gk]));
      end
   endgenerate

   wire ov = rx_o ^ (^rx_d) ^ (^rx_p);   // overall-parity check (1 = odd)

   assign corr   = (syn != 6'd0) &&  ov;  // single error -> correctable
   assign uncorr = (syn != 6'd0) && !ov;  // double error -> detect only

   // flip the data bit whose code position equals the syndrome
   genvar gd;
   generate
      for (gd = 0; gd < 32; gd = gd + 1) begin : g_corr
	 assign data[gd] = rx_d[gd] ^ (corr && (syn == POS[gd*6 +: 6]));
      end
   endgenerate

endmodule
