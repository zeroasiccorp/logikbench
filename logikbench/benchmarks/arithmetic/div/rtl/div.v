//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Unsigned integer divide (sequential digit-recurrence).
//
// Computes quotient = floor(dividend / divisor) and the remainder for DW-bit
// unsigned operands. Uses the classic restoring shift-subtract recurrence: a
// (2*DW+1)-bit {rem, quo} register shifts left one place per clock; when the
// top part is >= divisor it subtracts and sets the quotient LSB. Latency is DW
// cycles. A single add/compare/subtract and shifts (no multiplier, no memory).
//
// Handshake mirrors the sqrt block: pulse in_valid for one cycle to latch and
// start; busy is high while iterating; out_valid pulses when the result is
// valid. Divide-by-zero yields an all-ones quotient (the natural recurrence
// result).
//
//#############################################################################

module div #(parameter DW = 16
             )
   (
    input	    clk,
    input	    nreset,    // async reset, active low
    input	    in_valid,  // pulse to latch operands and start
    input [DW-1:0]  dividend,
    input [DW-1:0]  divisor,
    output reg	    out_valid, // pulse when quotient/remainder are valid
    output reg	    busy,      // high while iterating
    output [DW-1:0] quotient,
    output [DW-1:0] remainder
    );

   reg [DW-1:0]      quo;   // dividend shifting out / quotient building in
   reg [DW:0]	     rem;   // running remainder (DW+1 bits)
   reg [DW-1:0]	     dvsr;  // divisor
   reg [$clog2(DW+1)-1:0] cnt;

   // one shift-subtract step on the combined {rem, quo} register
   wire [2*DW:0]	  cat   = {rem, quo} << 1;
   wire [DW:0]		  rem_s = cat[2*DW:DW];
   wire [DW-1:0]	  quo_s = cat[DW-1:0];
   wire			  ge    = (rem_s >= {1'b0, dvsr});

   assign quotient  = quo;
   assign remainder = rem[DW-1:0];

   always @(posedge clk or negedge nreset) begin
      if (!nreset) begin
         out_valid <= 1'b0;
         busy      <= 1'b0;
         quo       <= {DW{1'b0}};
         rem       <= {(DW+1){1'b0}};
         dvsr      <= {DW{1'b0}};
         cnt       <= {$clog2(DW+1){1'b0}};
      end
      else begin
         out_valid <= 1'b0;
         if (in_valid && !busy) begin
            quo  <= dividend;
            rem  <= {(DW+1){1'b0}};
            dvsr <= divisor;
            cnt  <= DW[$clog2(DW+1)-1:0];
            busy <= 1'b1;
         end
         else if (busy) begin
            if (ge) begin
               rem <= rem_s - {1'b0, dvsr};
               quo <= quo_s | {{(DW-1){1'b0}}, 1'b1};
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
