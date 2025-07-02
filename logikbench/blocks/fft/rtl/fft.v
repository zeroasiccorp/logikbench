/****************************************************************************
 *  LICENSE: MIT (see ../../../../LICENSE)
 *  AUTHOR: LogikBench Authors
 ****************************************************************************
 *
 *  !!!WARNING!!!: Collaboration with AI assistant. Work in progress.
 *
 *  Streaming 64-point Radix-2 FFT with sine lookup ROM
 *  One complex sample input per clock, output streamed after pipeline delay
 *
 ***************************************************************************/
module fft
  #(
    parameter DW = 16, // data width (Q1.15 fixed-point)
    parameter N = 64   // FFT size
    )
   (
    input wire                  clk,
    input wire                  rst,
    input wire                  in_valid,
    input wire signed [DW-1:0]  in_real,
    input wire signed [DW-1:0]  in_imag,

    output wire                 out_valid,
    output wire signed [DW-1:0] out_real,
    output wire signed [DW-1:0] out_imag
    );

   localparam LOG2N = $clog2(N);

   //###################################################
   // Internal state
   //###################################################

   reg signed [DW-1:0] stage_real [0:LOG2N][0:N-1];
   reg signed [DW-1:0] stage_imag [0:LOG2N][0:N-1];
   reg [LOG2N:0]       sample_count;
   reg [LOG2N:0]       output_count;
   reg                 processing;

   // static look up table
   reg signed [DW-1:0] sine_lut [0:255];

   integer             i;

   //###################################################
   // Input Buffering
   //###################################################

   always @(posedge clk) begin
      if (rst) begin
         sample_count <= 0;
         processing <= 0;
      end
      else if (in_valid && !processing) begin
         stage_real[0][sample_count] <= in_real;
         stage_imag[0][sample_count] <= in_imag;
         sample_count <= sample_count + 1;
         if (sample_count == N-1)
           processing <= 1;
      end
   end

   //###################################################
   // FFT Pipeline Stages (Radix-2 Cooley-Tukey)
   //###################################################

   integer stage, j, k, m, span;
   reg signed [DW-1:0] u_real, u_imag, t_real, t_imag;
   reg signed [15:0]   w_r, w_i;
   reg signed [31:0]   mul1, mul2, mul3, mul4;

   always @(posedge clk) begin
      if (processing) begin
         for (stage = 1; stage <= LOG2N; stage = stage + 1) begin
            span = 1 << stage;
            for (j = 0; j < N; j = j + span) begin
               for (k = 0; k < span/2; k = k + 1) begin
                  m = j + k;
                  // Twiddle angle: 256*(k*2^LOG2N/span)/N
                  w_i = -sine_lut[(k << (8 - stage))];
                  w_r = cosine_lut((k << (8 - stage)));

                  u_real = stage_real[stage-1][m];
                  u_imag = stage_imag[stage-1][m];

                  t_real = stage_real[stage-1][m + span/2];
                  t_imag = stage_imag[stage-1][m + span/2];

                  // Complex multiply (t * w)
                  mul1 = t_real * w_r;
                  mul2 = t_imag * w_i;
                  mul3 = t_real * w_i;
                  mul4 = t_imag * w_r;

                  stage_real[stage][m] <= u_real + ((mul1 - mul2) >>> 15);
                  stage_imag[stage][m] <= u_imag + ((mul3 + mul4) >>> 15);

                  stage_real[stage][m + span/2] <= u_real - ((mul1 - mul2) >>> 15);
                  stage_imag[stage][m + span/2] <= u_imag - ((mul3 + mul4) >>> 15);
               end
            end
         end
      end
   end

   //###################################################
   // Output Stage (Bit-Reversed Order)
   //###################################################

   function [LOG2N-1:0] bit_reverse;
      input [LOG2N-1:0] in;
      integer           i;
      begin
         for (i = 0; i < LOG2N; i = i + 1)
           bit_reverse[i] = in[LOG2N-1 - i];
      end
   endfunction

   reg out_valid_reg = 0;
   always @(posedge clk) begin
      if (processing) begin
         out_valid_reg <= 1;
         output_count <= output_count + 1;
         if (output_count == N-1) begin
            out_valid_reg <= 0;
            processing <= 0;
            sample_count <= 0;
            output_count <= 0;
         end
      end
   end

   assign out_valid = out_valid_reg;
   assign out_real  = stage_real[LOG2N][bit_reverse(output_count)];
   assign out_imag  = stage_imag[LOG2N][bit_reverse(output_count)];

   //#################################################
   // Sin/Cos Twiddle Factor lookup table
   //#################################################


   //TODO! Obviously this won't synthesize!
   //change to a case statement and see how this can be mapped
   //via a ROM compiler. It should be a dual port RAM
   //with one table and two ports (one fore sine, one for cosine)

   function [15:0] cosine_lut;
      input [7:0] angle_idx;
      begin
         cosine_lut = sine_lut[(angle_idx + 64) % 256];
      end
   endfunction

   initial
     begin
        sine_lut[0] = 16'sd0;
        sine_lut[1] = 16'sd804;
        sine_lut[2] = 16'sd1607;
        sine_lut[3] = 16'sd2410;
        sine_lut[4] = 16'sd3211;
        sine_lut[5] = 16'sd4011;
        sine_lut[6] = 16'sd4807;
        sine_lut[7] = 16'sd5601;
        sine_lut[8] = 16'sd6392;
        sine_lut[9] = 16'sd7179;
        sine_lut[10] = 16'sd7961;
        sine_lut[11] = 16'sd8739;
        sine_lut[12] = 16'sd9511;
        sine_lut[13] = 16'sd10278;
        sine_lut[14] = 16'sd11038;
        sine_lut[15] = 16'sd11792;
        sine_lut[16] = 16'sd12539;
        sine_lut[17] = 16'sd13278;
        sine_lut[18] = 16'sd14009;
        sine_lut[19] = 16'sd14732;
        sine_lut[20] = 16'sd15446;
        sine_lut[21] = 16'sd16150;
        sine_lut[22] = 16'sd16845;
        sine_lut[23] = 16'sd17530;
        sine_lut[24] = 16'sd18204;
        sine_lut[25] = 16'sd18867;
        sine_lut[26] = 16'sd19519;
        sine_lut[27] = 16'sd20159;
        sine_lut[28] = 16'sd20787;
        sine_lut[29] = 16'sd21402;
        sine_lut[30] = 16'sd22004;
        sine_lut[31] = 16'sd22594;
        sine_lut[32] = 16'sd23169;
        sine_lut[33] = 16'sd23731;
        sine_lut[34] = 16'sd24278;
        sine_lut[35] = 16'sd24811;
        sine_lut[36] = 16'sd25329;
        sine_lut[37] = 16'sd25831;
        sine_lut[38] = 16'sd26318;
        sine_lut[39] = 16'sd26789;
        sine_lut[40] = 16'sd27244;
        sine_lut[41] = 16'sd27683;
        sine_lut[42] = 16'sd28105;
        sine_lut[43] = 16'sd28510;
        sine_lut[44] = 16'sd28897;
        sine_lut[45] = 16'sd29268;
        sine_lut[46] = 16'sd29621;
        sine_lut[47] = 16'sd29955;
        sine_lut[48] = 16'sd30272;
        sine_lut[49] = 16'sd30571;
        sine_lut[50] = 16'sd30851;
        sine_lut[51] = 16'sd31113;
        sine_lut[52] = 16'sd31356;
        sine_lut[53] = 16'sd31580;
        sine_lut[54] = 16'sd31785;
        sine_lut[55] = 16'sd31970;
        sine_lut[56] = 16'sd32137;
        sine_lut[57] = 16'sd32284;
        sine_lut[58] = 16'sd32412;
        sine_lut[59] = 16'sd32520;
        sine_lut[60] = 16'sd32609;
        sine_lut[61] = 16'sd32678;
        sine_lut[62] = 16'sd32727;
        sine_lut[63] = 16'sd32757;
        sine_lut[64] = 16'sd32767;
        sine_lut[65] = 16'sd32757;
        sine_lut[66] = 16'sd32727;
        sine_lut[67] = 16'sd32678;
        sine_lut[68] = 16'sd32609;
        sine_lut[69] = 16'sd32520;
        sine_lut[70] = 16'sd32412;
        sine_lut[71] = 16'sd32284;
        sine_lut[72] = 16'sd32137;
        sine_lut[73] = 16'sd31970;
        sine_lut[74] = 16'sd31785;
        sine_lut[75] = 16'sd31580;
        sine_lut[76] = 16'sd31356;
        sine_lut[77] = 16'sd31113;
        sine_lut[78] = 16'sd30851;
        sine_lut[79] = 16'sd30571;
        sine_lut[80] = 16'sd30272;
        sine_lut[81] = 16'sd29955;
        sine_lut[82] = 16'sd29621;
        sine_lut[83] = 16'sd29268;
        sine_lut[84] = 16'sd28897;
        sine_lut[85] = 16'sd28510;
        sine_lut[86] = 16'sd28105;
        sine_lut[87] = 16'sd27683;
        sine_lut[88] = 16'sd27244;
        sine_lut[89] = 16'sd26789;
        sine_lut[90] = 16'sd26318;
        sine_lut[91] = 16'sd25831;
        sine_lut[92] = 16'sd25329;
        sine_lut[93] = 16'sd24811;
        sine_lut[94] = 16'sd24278;
        sine_lut[95] = 16'sd23731;
        sine_lut[96] = 16'sd23169;
        sine_lut[97] = 16'sd22594;
        sine_lut[98] = 16'sd22004;
        sine_lut[99] = 16'sd21402;
        sine_lut[100] = 16'sd20787;
        sine_lut[101] = 16'sd20159;
        sine_lut[102] = 16'sd19519;
        sine_lut[103] = 16'sd18867;
        sine_lut[104] = 16'sd18204;
        sine_lut[105] = 16'sd17530;
        sine_lut[106] = 16'sd16845;
        sine_lut[107] = 16'sd16150;
        sine_lut[108] = 16'sd15446;
        sine_lut[109] = 16'sd14732;
        sine_lut[110] = 16'sd14009;
        sine_lut[111] = 16'sd13278;
        sine_lut[112] = 16'sd12539;
        sine_lut[113] = 16'sd11792;
        sine_lut[114] = 16'sd11038;
        sine_lut[115] = 16'sd10278;
        sine_lut[116] = 16'sd9511;
        sine_lut[117] = 16'sd8739;
        sine_lut[118] = 16'sd7961;
        sine_lut[119] = 16'sd7179;
        sine_lut[120] = 16'sd6392;
        sine_lut[121] = 16'sd5601;
        sine_lut[122] = 16'sd4807;
        sine_lut[123] = 16'sd4011;
        sine_lut[124] = 16'sd3211;
        sine_lut[125] = 16'sd2410;
        sine_lut[126] = 16'sd1607;
        sine_lut[127] = 16'sd804;
        sine_lut[128] = 16'sd0;
        sine_lut[129] = -16'sd804;
        sine_lut[130] = -16'sd1607;
        sine_lut[131] = -16'sd2410;
        sine_lut[132] = -16'sd3211;
        sine_lut[133] = -16'sd4011;
        sine_lut[134] = -16'sd4807;
        sine_lut[135] = -16'sd5601;
        sine_lut[136] = -16'sd6392;
        sine_lut[137] = -16'sd7179;
        sine_lut[138] = -16'sd7961;
        sine_lut[139] = -16'sd8739;
        sine_lut[140] = -16'sd9511;
        sine_lut[141] = -16'sd10278;
        sine_lut[142] = -16'sd11038;
        sine_lut[143] = -16'sd11792;
        sine_lut[144] = -16'sd12539;
        sine_lut[145] = -16'sd13278;
        sine_lut[146] = -16'sd14009;
        sine_lut[147] = -16'sd14732;
        sine_lut[148] = -16'sd15446;
        sine_lut[149] = -16'sd16150;
        sine_lut[150] = -16'sd16845;
        sine_lut[151] = -16'sd17530;
        sine_lut[152] = -16'sd18204;
        sine_lut[153] = -16'sd18867;
        sine_lut[154] = -16'sd19519;
        sine_lut[155] = -16'sd20159;
        sine_lut[156] = -16'sd20787;
        sine_lut[157] = -16'sd21402;
        sine_lut[158] = -16'sd22004;
        sine_lut[159] = -16'sd22594;
        sine_lut[160] = -16'sd23169;
        sine_lut[161] = -16'sd23731;
        sine_lut[162] = -16'sd24278;
        sine_lut[163] = -16'sd24811;
        sine_lut[164] = -16'sd25329;
        sine_lut[165] = -16'sd25831;
        sine_lut[166] = -16'sd26318;
        sine_lut[167] = -16'sd26789;
        sine_lut[168] = -16'sd27244;
        sine_lut[169] = -16'sd27683;
        sine_lut[170] = -16'sd28105;
        sine_lut[171] = -16'sd28510;
        sine_lut[172] = -16'sd28897;
        sine_lut[173] = -16'sd29268;
        sine_lut[174] = -16'sd29621;
        sine_lut[175] = -16'sd29955;
        sine_lut[176] = -16'sd30272;
        sine_lut[177] = -16'sd30571;
        sine_lut[178] = -16'sd30851;
        sine_lut[179] = -16'sd31113;
        sine_lut[180] = -16'sd31356;
        sine_lut[181] = -16'sd31580;
        sine_lut[182] = -16'sd31785;
        sine_lut[183] = -16'sd31970;
        sine_lut[184] = -16'sd32137;
        sine_lut[185] = -16'sd32284;
        sine_lut[186] = -16'sd32412;
        sine_lut[187] = -16'sd32520;
        sine_lut[188] = -16'sd32609;
        sine_lut[189] = -16'sd32678;
        sine_lut[190] = -16'sd32727;
        sine_lut[191] = -16'sd32757;
        sine_lut[192] = -16'sd32767;
        sine_lut[193] = -16'sd32757;
        sine_lut[194] = -16'sd32727;
        sine_lut[195] = -16'sd32678;
        sine_lut[196] = -16'sd32609;
        sine_lut[197] = -16'sd32520;
        sine_lut[198] = -16'sd32412;
        sine_lut[199] = -16'sd32284;
        sine_lut[200] = -16'sd32137;
        sine_lut[201] = -16'sd31970;
        sine_lut[202] = -16'sd31785;
        sine_lut[203] = -16'sd31580;
        sine_lut[204] = -16'sd31356;
        sine_lut[205] = -16'sd31113;
        sine_lut[206] = -16'sd30851;
        sine_lut[207] = -16'sd30571;
        sine_lut[208] = -16'sd30272;
        sine_lut[209] = -16'sd29955;
        sine_lut[210] = -16'sd29621;
        sine_lut[211] = -16'sd29268;
        sine_lut[212] = -16'sd28897;
        sine_lut[213] = -16'sd28510;
        sine_lut[214] = -16'sd28105;
        sine_lut[215] = -16'sd27683;
        sine_lut[216] = -16'sd27244;
        sine_lut[217] = -16'sd26789;
        sine_lut[218] = -16'sd26318;
        sine_lut[219] = -16'sd25831;
        sine_lut[220] = -16'sd25329;
        sine_lut[221] = -16'sd24811;
        sine_lut[222] = -16'sd24278;
        sine_lut[223] = -16'sd23731;
        sine_lut[224] = -16'sd23169;
        sine_lut[225] = -16'sd22594;
        sine_lut[226] = -16'sd22004;
        sine_lut[227] = -16'sd21402;
        sine_lut[228] = -16'sd20787;
        sine_lut[229] = -16'sd20159;
        sine_lut[230] = -16'sd19519;
        sine_lut[231] = -16'sd18867;
        sine_lut[232] = -16'sd18204;
        sine_lut[233] = -16'sd17530;
        sine_lut[234] = -16'sd16845;
        sine_lut[235] = -16'sd16150;
        sine_lut[236] = -16'sd15446;
        sine_lut[237] = -16'sd14732;
        sine_lut[238] = -16'sd14009;
        sine_lut[239] = -16'sd13278;
        sine_lut[240] = -16'sd12539;
        sine_lut[241] = -16'sd11792;
        sine_lut[242] = -16'sd11038;
        sine_lut[243] = -16'sd10278;
        sine_lut[244] = -16'sd9511;
        sine_lut[245] = -16'sd8739;
        sine_lut[246] = -16'sd7961;
        sine_lut[247] = -16'sd7179;
        sine_lut[248] = -16'sd6392;
        sine_lut[249] = -16'sd5601;
        sine_lut[250] = -16'sd4807;
        sine_lut[251] = -16'sd4011;
        sine_lut[252] = -16'sd3211;
        sine_lut[253] = -16'sd2410;
        sine_lut[254] = -16'sd1607;
        sine_lut[255] = -16'sd804;
     end

endmodule
