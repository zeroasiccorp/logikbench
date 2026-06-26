//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Soft-decision Viterbi decoder for the K=7, rate-1/2 convolutional code
// (generators G0=133, G1=171 octal -- the IEEE 802.11a/g / DVB / NASA code).
//
// 64 states, fully-parallel add-compare-select (one trellis step per clock),
// soft inputs (SW-bit symbols, 2 per step), RAM-based traceback.
//
// Frame-based operation: stream a frame of soft symbol pairs with in_valid;
// assert in_last on the final pair. The decoder then traces back the whole
// frame from the best (min path-metric) state and streams the decoded bits
// out (out_valid/out_bit) oldest-first. Encode with a 6-bit zero tail to
// terminate the trellis at state 0 for best accuracy. Frame length <= MAXLEN.
//
//#############################################################################

module viterbi
  #(parameter SW = 3,	   // soft symbol width (bits)
    parameter MAXLEN = 256 // max frame length (decoded bits)
    )
   (
    input	   clk,
    input	   rst,	    // synchronous, active high
    input	   in_valid,
    input [SW-1:0] in_sym0, // soft estimate of coded bit 0 (G0)
    input [SW-1:0] in_sym1, // soft estimate of coded bit 1 (G1)
    input	   in_last, // last symbol pair of the frame
    output reg	   out_valid,
    output reg	   out_bit  // decoded bit (oldest first)
    );

   localparam NSTATE = 64;
   localparam PMW    = 12;                 // path-metric width
   localparam [6:0] G0 = 7'o133;
   localparam [6:0] G1 = 7'o171;
   localparam [SW-1:0] SMAX = {SW{1'b1}};
   localparam [PMW-1:0]	PM_BIG = 12'd2000;
   localparam		AW = $clog2(MAXLEN);

   // FSM
   localparam		ST_ACCEPT = 2'd0, ST_TB = 2'd1, ST_OUT = 2'd2;
   reg [1:0]		state;

   reg [PMW-1:0]	pm [0:NSTATE-1];     // path metrics
   reg [63:0]		dec_ram [0:MAXLEN-1]; // survivor decisions (1 bit/state)
   reg			out_buf [0:MAXLEN-1]; // decoded bits, indexed by step
   reg [AW:0]		wp;                  // write pointer / step count
   reg [AW:0]		len;                 // frame length
   reg [AW:0]		tb_i;                // traceback index
   reg [5:0]		tb_state;            // traceback state
   reg [AW:0]		op;                  // output pointer

   integer		j;

   //----------------------------------------------------------------
   // Branch metric unit: soft distance d(sym,bit)= bit?(SMAX-sym):sym
   // bm4[{g1,g0}] = d(sym0,g0) + d(sym1,g1)
   //----------------------------------------------------------------
   wire [SW:0]		d0_0 = in_sym0;             // g0=0
   wire [SW:0]		d0_1 = SMAX - in_sym0;      // g0=1
   wire [SW:0]		d1_0 = in_sym1;             // g1=0
   wire [SW:0]		d1_1 = SMAX - in_sym1;      // g1=1
   wire [SW+1:0]	bm4 [0:3];
   assign bm4[0] = d0_0 + d1_0;   // g1g0 = 00
   assign bm4[1] = d0_1 + d1_0;   // g1g0 = 01
   assign bm4[2] = d0_0 + d1_1;   // g1g0 = 10
   assign bm4[3] = d0_1 + d1_1;   // g1g0 = 11

   //----------------------------------------------------------------
   // ACS: 64 parallel butterflies. State i has predecessors
   // {i[4:0],0} and {i[4:0],1}; expected code from v={i[5:0],p}.
   //----------------------------------------------------------------
   wire [PMW-1:0] pmn  [0:NSTATE-1];
   wire [NSTATE-1:0] decw;

   genvar	     i;
   generate
      for (i = 0; i < NSTATE; i = i + 1) begin : acs
         localparam [6:0] V0 = (i << 1) & 7'h7f;          // {i[5:0],0}
         localparam [6:0] V1 = ((i << 1) | 1) & 7'h7f;    // {i[5:0],1}
         localparam [5:0] P0 = (i << 1) & 6'h3f;          // {i[4:0],0}
         localparam [5:0] P1 = ((i << 1) | 1) & 6'h3f;    // {i[4:0],1}
         localparam [1:0] C0 = {^(V0 & G1), ^(V0 & G0)};
         localparam [1:0] C1 = {^(V1 & G1), ^(V1 & G0)};
         wire [PMW-1:0]	  m0 = pm[P0] + bm4[C0];
         wire [PMW-1:0]	  m1 = pm[P1] + bm4[C1];
         assign pmn[i]  = (m1 < m0) ? m1 : m0;
         assign decw[i] = (m1 < m0) ? 1'b1 : 1'b0;
      end
   endgenerate

   // min path metric + best state (for normalization and traceback start)
   reg [PMW-1:0] minpm;
   reg [5:0]	 bestidx;
   always @* begin
      minpm   = pmn[0];
      bestidx = 6'd0;
      for (j = 1; j < NSTATE; j = j + 1)
        if (pmn[j] < minpm) begin
           minpm   = pmn[j];
           bestidx = j[5:0];
        end
   end

   wire [63:0] dec_rd = dec_ram[tb_i[AW-1:0]];
   wire	       tb_p   = dec_rd[tb_state];

   //----------------------------------------------------------------
   // Control / datapath
   //----------------------------------------------------------------
   always @(posedge clk) begin
      if (rst) begin
         state     <= ST_ACCEPT;
         wp        <= 0;
         out_valid <= 1'b0;
         out_bit   <= 1'b0;
         for (j = 0; j < NSTATE; j = j + 1)
           pm[j] <= (j == 0) ? {PMW{1'b0}} : PM_BIG;
      end
      else begin
         out_valid <= 1'b0;
         case (state)
           ST_ACCEPT: begin
              if (in_valid) begin
                 dec_ram[wp[AW-1:0]] <= decw;
                 for (j = 0; j < NSTATE; j = j + 1)
                   pm[j] <= pmn[j] - minpm;
                 wp <= wp + 1'b1;
                 if (in_last) begin
                    len      <= wp + 1'b1;
                    tb_i     <= wp;            // start at last step
                    tb_state <= bestidx;
                    state    <= ST_TB;
                 end
              end
           end
           ST_TB: begin
              out_buf[tb_i[AW-1:0]] <= tb_state[5];     // decoded bit at step
              tb_state <= {tb_state[4:0], tb_p};        // predecessor
              if (tb_i == 0) begin
                 state <= ST_OUT;
                 op    <= 0;
              end
              else
                tb_i <= tb_i - 1'b1;
           end
           ST_OUT: begin
              out_valid <= 1'b1;
              out_bit   <= out_buf[op[AW-1:0]];
              op <= op + 1'b1;
              if (op == len - 1) begin
                 state <= ST_ACCEPT;
                 wp    <= 0;
                 for (j = 0; j < NSTATE; j = j + 1)
                   pm[j] <= (j == 0) ? {PMW{1'b0}} : PM_BIG;
              end
           end
         endcase
      end
   end

endmodule
