//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// codec8b10b: 8b/10b line-coding encoder + decoder (Widmer/Franaszek), the
// line code used by high-speed serial converter links (e.g. JESD204B). The
// top instantiates an independent encoder and decoder so both paths are
// exercised. Data symbols (256) plus the K.28.5 comma are supported.
//
// Bit order: input is HGF EDCBA (din[7:5]=HGF, din[4:0]=EDCBA); the 10-bit
// code is abcdei fghj with 'a' first (dout[9]=a ... dout[0]=j).
//
//#############################################################################
module codec8b10b
  (
   input	clk,
   input	nreset,
   // encoder
   input	enc_k,	  // 1 = emit K.28.5 comma
   input [7:0]	enc_din,  // data byte
   output [9:0]	enc_dout, // 10-bit code
   // decoder
   input [9:0]	dec_din,  // 10-bit code
   output [7:0]	dec_dout, // decoded byte
   output	dec_k,	  // decoded control (comma)
   output	dec_err	  // invalid code
   );

   enc8b10b u_enc (.clk(clk), .nreset(nreset), .k(enc_k), .din(enc_din),
                   .dout(enc_dout));

   dec8b10b u_dec (.clk(clk), .nreset(nreset), .din(dec_din),
                   .dout(dec_dout), .k(dec_k), .err(dec_err));

endmodule

//#############################################################################
// 8b/10b encoder with running disparity.
//#############################################################################
module enc8b10b
  (
   input	    clk,
   input	    nreset,
   input	    k,
   input [7:0]	    din,
   output reg [9:0] dout
   );

   wire [4:0]    x = din[4:0];   // EDCBA
   wire [2:0]	 y = din[7:5];   // HGF
   reg		 rd;             // running disparity: 0 = RD-, 1 = RD+

   // 5b/6b and 3b/4b RD- code tables (ROM: sanctioned case use)
   reg [5:0]	 code6;
   reg [3:0]	 code4p;
   always @(*)
     case (x)
       5'd0 : code6 = 6'b100111;   5'd1 : code6 = 6'b011101;
       5'd2 : code6 = 6'b101101;   5'd3 : code6 = 6'b110001;
       5'd4 : code6 = 6'b110101;   5'd5 : code6 = 6'b101001;
       5'd6 : code6 = 6'b011001;   5'd7 : code6 = 6'b111000;
       5'd8 : code6 = 6'b111001;   5'd9 : code6 = 6'b100101;
       5'd10: code6 = 6'b010101;   5'd11: code6 = 6'b110100;
       5'd12: code6 = 6'b001101;   5'd13: code6 = 6'b101100;
       5'd14: code6 = 6'b011100;   5'd15: code6 = 6'b010111;
       5'd16: code6 = 6'b011011;   5'd17: code6 = 6'b100011;
       5'd18: code6 = 6'b010011;   5'd19: code6 = 6'b110010;
       5'd20: code6 = 6'b001011;   5'd21: code6 = 6'b101010;
       5'd22: code6 = 6'b011010;   5'd23: code6 = 6'b111010;
       5'd24: code6 = 6'b110011;   5'd25: code6 = 6'b100110;
       5'd26: code6 = 6'b010110;   5'd27: code6 = 6'b110110;
       5'd28: code6 = 6'b001110;   5'd29: code6 = 6'b101110;
       5'd30: code6 = 6'b011110;   5'd31: code6 = 6'b101011;
     endcase
   always @(*)
     case (y)
       3'd0: code4p = 4'b1011;   3'd1: code4p = 4'b1001;
       3'd2: code4p = 4'b0101;   3'd3: code4p = 4'b1100;
       3'd4: code4p = 4'b1101;   3'd5: code4p = 4'b1010;
       3'd6: code4p = 4'b0110;   3'd7: code4p = 4'b1110;
     endcase

   // 6b disparity handling (is_d07: neutral code with RD-selected variant)
   wire [2:0] n6 = code6[5]+code6[4]+code6[3]+code6[2]+code6[1]+code6[0];
   wire	      nz6 = (n6 != 3'd3);
   wire	      is_d07 = (x == 5'd7);
   wire	      sel6 = rd & (nz6 | is_d07);
   wire [5:0] out6 = sel6 ? ~code6 : code6;
   wire	      rd_mid = rd ^ nz6;

   // 3b/4b: Dx.7 alternate (A7) to bound run length
   wire	      is7 = (y == 3'd7);
   wire	      a7 = is7 & ((~rd_mid & (x==5'd17 | x==5'd18 | x==5'd20)) |
                          ( rd_mid & (x==5'd11 | x==5'd13 | x==5'd14)));
   wire [3:0] code4 = a7 ? 4'b0111 : code4p;
   wire [2:0] n4 = code4[3]+code4[2]+code4[1]+code4[0];
   wire	      nz4 = (n4 != 3'd2);
   wire	      sel4 = rd_mid & nz4;
   wire [3:0] out4 = sel4 ? ~code4 : code4;
   wire	      rd_data = rd_mid ^ nz4;

   // K.28.5 comma is a fixed pattern that toggles RD
   wire [9:0] dout_nxt = k ? (rd ? 10'b1100000101 : 10'b0011111010)
              : {out6, out4};
   wire	      rd_nxt   = k ? ~rd : rd_data;

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        dout <= 10'b0;
        rd   <= 1'b0;
     end
     else begin
        dout <= dout_nxt;
        rd   <= rd_nxt;
     end

endmodule

//#############################################################################
// 8b/10b decoder. Disparity is normalized (minority-ones forms folded to their
// RD- pattern) so a single reverse ROM over the RD- table decodes both
// variants. K.28.5 is detected from the comma 6b pattern.
//#############################################################################
module dec8b10b
  (
   input	    clk,
   input	    nreset,
   input [9:0]	    din,
   output reg [7:0] dout,
   output reg	    k,
   output reg	    err
   );

   wire [5:0] in6 = din[9:4];
   wire [3:0] in4 = din[3:0];
   wire [2:0] n6 = in6[5]+in6[4]+in6[3]+in6[2]+in6[1]+in6[0];
   wire [2:0] n4 = in4[3]+in4[2]+in4[1]+in4[0];
   wire [5:0] key6 = (n6 < 3'd3) ? ~in6 : in6;
   wire [3:0] key4 = (n4 < 3'd2) ? ~in4 : in4;

   reg [4:0]  val5;  reg valid5;
   reg [2:0]  val3;  reg valid3;
   always @(*) begin
      valid5 = 1'b1;
      case (key6)
        6'b100111: val5 = 5'd0;    6'b011101: val5 = 5'd1;
        6'b101101: val5 = 5'd2;    6'b110001: val5 = 5'd3;
        6'b110101: val5 = 5'd4;    6'b101001: val5 = 5'd5;
        6'b011001: val5 = 5'd6;    6'b111000: val5 = 5'd7;
        6'b000111: val5 = 5'd7;    6'b111001: val5 = 5'd8;
        6'b100101: val5 = 5'd9;    6'b010101: val5 = 5'd10;
        6'b110100: val5 = 5'd11;   6'b001101: val5 = 5'd12;
        6'b101100: val5 = 5'd13;   6'b011100: val5 = 5'd14;
        6'b010111: val5 = 5'd15;   6'b011011: val5 = 5'd16;
        6'b100011: val5 = 5'd17;   6'b010011: val5 = 5'd18;
        6'b110010: val5 = 5'd19;   6'b001011: val5 = 5'd20;
        6'b101010: val5 = 5'd21;   6'b011010: val5 = 5'd22;
        6'b111010: val5 = 5'd23;   6'b110011: val5 = 5'd24;
        6'b100110: val5 = 5'd25;   6'b010110: val5 = 5'd26;
        6'b110110: val5 = 5'd27;   6'b001110: val5 = 5'd28;
        6'b101110: val5 = 5'd29;   6'b011110: val5 = 5'd30;
        6'b101011: val5 = 5'd31;
        default:  begin val5 = 5'd0; valid5 = 1'b0; end
      endcase
   end
   always @(*) begin
      valid3 = 1'b1;
      case (key4)
        4'b1011: val3 = 3'd0;   4'b1001: val3 = 3'd1;
        4'b0101: val3 = 3'd2;   4'b1100: val3 = 3'd3;
        4'b1101: val3 = 3'd4;   4'b1010: val3 = 3'd5;
        4'b0110: val3 = 3'd6;   4'b1110: val3 = 3'd7;
        4'b0111: val3 = 3'd7;
        default: begin val3 = 3'd0; valid3 = 1'b0; end
      endcase
   end

   wire       is_k     = (key6 == 6'b001111);
   wire	      comma_ok = (in4 == 4'b1010) | (in4 == 4'b0101);
   wire [7:0] dout_nxt = is_k ? 8'hBC : {val3, val5};
   wire	      err_nxt  = is_k ? ~comma_ok : ~(valid5 & valid3);

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        dout <= 8'b0;
        k    <= 1'b0;
        err  <= 1'b0;
     end
     else begin
        dout <= dout_nxt;
        k    <= is_k;
        err  <= err_nxt;
     end

endmodule
