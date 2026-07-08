//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module addmod #(parameter DW = 256   // operand / modulus width
                )
   (
    input [DW-1:0]  a,     // addend a (assumed < m)
    input [DW-1:0]  b,     // addend b (assumed < m)
    input [DW-1:0]  m,     // modulus
    output [DW-1:0] result // (a + b) mod m
    );

   wire [DW:0] sum;    // a + b        (DW+1 bits, carry out)
   wire [DW:0] diff;   // (a + b) - m  (DW+1 bits, borrow out)

   // Modular adder: add, then conditionally subtract the modulus. With
   // reduced inputs (a,b < m) the sum is < 2m, so a single conditional
   // subtract returns the result to [0,m).

   assign sum  = a + b;
   assign diff = sum - {1'b0, m};

   // diff[DW] set means sum < m (borrow): keep sum, else use sum - m.
   assign result = diff[DW] ? sum[DW-1:0] : diff[DW-1:0];

endmodule
