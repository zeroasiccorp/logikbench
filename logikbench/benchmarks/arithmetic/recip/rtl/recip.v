//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Fixed-point reciprocal 1/x (sequential digit-recurrence).
//
// For a Q(DW-QW).QW unsigned input x (value X = x/2^QW), the reciprocal 1/X in
// the same format is 2^(2*QW)/x. This is computed as a fixed-numerator restoring
// division of the constant 2^(2*QW) by x. The result is saturated to the DW-bit
// output range (small x, including x = 0, saturates to all ones). Latency is
// NUMW = 2*QW+1 cycles. Handshake mirrors the sqrt block.
//
//#############################################################################

module recip #(parameter DW = 16,
               parameter QW = 8	// fractional bits (QW=8 tuned)
               )
   (
    input	    clk,
    input	    nreset,    // async reset, active low
    input	    in_valid,  // pulse to latch x and start
    input [DW-1:0]  x,
    output reg	    out_valid, // pulse when out is valid
    output reg	    busy,      // high while iterating
    output [DW-1:0] out	       // 1/x in Q(DW-QW).QW, saturated
    );

   localparam NUMW = 2*QW + 1;                   // numerator / quotient width
   localparam [NUMW-1:0] NUM  = {1'b1, {(2*QW){1'b0}}};   // 2^(2*QW)
   localparam [DW-1:0]	 MAXV = {DW{1'b1}};  // saturation value

   reg [NUMW-1:0]	 quo;   // numerator shifting out / quotient building in
   reg [DW:0]		 rem;   // running remainder (DW+1 bits)
   reg [DW-1:0]		 dvsr;  // divisor (x)
   reg [$clog2(NUMW+1)-1:0] cnt;

   wire [DW+NUMW:0]	    cat  = {rem, quo} << 1;
   wire [DW:0]		    rem_s = cat[DW+NUMW:NUMW];
   wire [NUMW-1:0]	    quo_s = cat[NUMW-1:0];
   wire			    ge   = (rem_s >= {1'b0, dvsr});

   assign out = (quo > {{(NUMW-DW){1'b0}}, MAXV}) ? MAXV : quo[DW-1:0];

   always @(posedge clk or negedge nreset) begin
      if (!nreset) begin
         out_valid <= 1'b0;
         busy      <= 1'b0;
         quo       <= {NUMW{1'b0}};
         rem       <= {(DW+1){1'b0}};
         dvsr      <= {DW{1'b0}};
         cnt       <= {$clog2(NUMW+1){1'b0}};
      end
      else begin
         out_valid <= 1'b0;
         if (in_valid && !busy) begin
            quo  <= NUM;
            rem  <= {(DW+1){1'b0}};
            dvsr <= x;
            cnt  <= NUMW[$clog2(NUMW+1)-1:0];
            busy <= 1'b1;
         end
         else if (busy) begin
            if (ge) begin
               rem <= rem_s - {1'b0, dvsr};
               quo <= quo_s | {{(NUMW-1){1'b0}}, 1'b1};
            end
            else begin
               rem <= rem_s;
               quo <= quo_s;
            end
            cnt <= cnt - 1'b1;
            if (cnt == 1) begin
               busy      <= 1'b0;
               out_valid <= 1'b1;
            end
         end
      end
   end

endmodule
