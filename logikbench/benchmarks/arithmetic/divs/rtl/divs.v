//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Signed integer divide (sequential digit-recurrence).
//
// Computes quotient and remainder for DW-bit signed operands with truncation
// toward zero (the quotient sign is the XOR of the operand signs; the remainder
// takes the dividend's sign). Operands are converted to magnitude at start, the
// unsigned restoring recurrence runs for DW cycles, and the results are negated
// as needed. Handshake mirrors the sqrt block.
//
//#############################################################################

module divs #(parameter DW = 16
              )
   (
    input		   clk,
    input		   nreset,    // async reset, active low
    input		   in_valid,  // pulse to latch operands and start
    input signed [DW-1:0]  dividend,
    input signed [DW-1:0]  divisor,
    output reg		   out_valid, // pulse when result is valid
    output reg		   busy,      // high while iterating
    output signed [DW-1:0] quotient,
    output signed [DW-1:0] remainder
    );

   reg [DW-1:0]      quo;   // magnitude of dividend / quotient
   reg [DW:0]	     rem;   // running remainder magnitude (DW+1 bits)
   reg [DW-1:0]	     dvsr;  // magnitude of divisor
   reg		     qsign; // quotient sign
   reg		     rsign; // remainder sign (= dividend sign)
   reg [$clog2(DW+1)-1:0] cnt;

   wire [2*DW:0]	  cat   = {rem, quo} << 1;
   wire [DW:0]		  rem_s = cat[2*DW:DW];
   wire [DW-1:0]	  quo_s = cat[DW-1:0];
   wire			  ge    = (rem_s >= {1'b0, dvsr});

   // apply signs to the magnitude results
   assign quotient  = qsign ? (~quo + 1'b1) : quo;
   assign remainder = rsign ? (~rem[DW-1:0] + 1'b1) : rem[DW-1:0];

   always @(posedge clk or negedge nreset) begin
      if (!nreset) begin
         out_valid <= 1'b0;
         busy      <= 1'b0;
         quo       <= {DW{1'b0}};
         rem       <= {(DW+1){1'b0}};
         dvsr      <= {DW{1'b0}};
         qsign     <= 1'b0;
         rsign     <= 1'b0;
         cnt       <= {$clog2(DW+1){1'b0}};
      end
      else begin
         out_valid <= 1'b0;
         if (in_valid && !busy) begin
            quo   <= dividend[DW-1] ? (~dividend + 1'b1) : dividend;
            dvsr  <= divisor[DW-1]  ? (~divisor + 1'b1)  : divisor;
            qsign <= dividend[DW-1] ^ divisor[DW-1];
            rsign <= dividend[DW-1];
            rem   <= {(DW+1){1'b0}};
            cnt   <= DW[$clog2(DW+1)-1:0];
            busy  <= 1'b1;
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
