//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Unsigned integer modulo / remainder (sequential digit-recurrence).
//
// Computes remainder = dividend mod divisor for DW-bit unsigned operands using
// the same restoring shift-subtract recurrence as the div block (the quotient
// is built internally but only the remainder is exposed). Latency is DW cycles.
// Handshake mirrors the sqrt block. Modulo by zero returns the dividend.
//
//#############################################################################

module mod #(parameter DW = 16
             )
   (
    input	    clk,
    input	    nreset,    // async reset, active low
    input	    in_valid,  // pulse to latch operands and start
    input [DW-1:0]  dividend,
    input [DW-1:0]  divisor,
    output reg	    out_valid, // pulse when remainder is valid
    output reg	    busy,      // high while iterating
    output [DW-1:0] remainder
    );

   reg [DW-1:0]      quo;   // dividend shifting out (quotient, internal)
   reg [DW:0]	     rem;   // running remainder (DW+1 bits)
   reg [DW-1:0]	     dvsr;  // divisor
   reg [$clog2(DW+1)-1:0] cnt;

   // one shift-subtract step on the combined {rem, quo} register
   wire [2*DW:0]	  cat   = {rem, quo} << 1;
   wire [DW:0]		  rem_s = cat[2*DW:DW];
   wire [DW-1:0]	  quo_s = cat[DW-1:0];
   wire			  ge    = (rem_s >= {1'b0, dvsr});

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
