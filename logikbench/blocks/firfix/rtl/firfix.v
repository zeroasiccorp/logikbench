/****************************************************************************
 *  LICENSE: MIT (see ../../../../LICENSE)
 *  AUTHOR: LogikBench authors
 ****************************************************************************
 *  DESCRIPTION:
 *
 *  FIR Filter (Direct Form)
 *
 *    x[n] --->(+)----->(+)----->(+)-----> ... ---->(+)-----> y[n]
 *              ^        ^        ^                  ^
 *             [*h0]    [*h1]    [*h2]              [*hN]
 *              ^        ^        ^                  ^
 *             [z0]     [z1]     [z2]               [zN]
 *
 *    Legend:
 *      x[n]   : input sample
 *      h0..hN : FIR coefficients
 *      z0..zN : delayed input samples (shift register)
 *      y[n]   : output sample
 *
 ***************************************************************************/
module firfix
  #(parameter            DW = 16,                     // data width
    parameter            ACCW = 16,                   // accumulator width
    parameter            N = 8,                       // number of taps
    parameter [DW*N-1:0] H = {1'b1, {(DW*N-1){1'b0}}} // taps coeffs
    )
   (
    input                        clk,
    input                        clear,
    input                        valid,
    input signed [DW-1:0]        x,
    output reg signed [ACCW-1:0] y
    );

   // Shift register to hold input samples samples
   reg signed [DW-1:0] shift_reg [0:N-1];
   integer             i;

   // Multiply-Accumulate result
   reg signed [ACCW-1:0] acc;

   always @(posedge clk) begin
      if (clear) begin
         for (i = 0; i < N; i = i + 1)
           shift_reg[i] <= 0;
         y <= 0;
      end
      else if (valid) begin
         // shift register
         for (i = N-1; i > 0; i = i - 1)
           shift_reg[i] <= shift_reg[i-1];
         shift_reg[0] <= x;
         // dot-product
         acc = 0;
         for (i = 0; i < N; i = i + 1)
           acc = acc + shift_reg[i] * H[i];
         y <= acc;
      end
   end


endmodule
