module mul #(parameter N = 8, // input width
             parameter M = 8  // output width(>=N)
	     )
   (
    //Inputs
    input          clk, // clock
    input [N-1:0]  a,   // a input (multiplier)
    input [N-1:0]  b,   // b input (multiplicand)
    //Outputs
    output [M-1:0] c    // a * b final product
    );

   assign c[M-1:0] = a[N-1:0] * b[N-1:0];

endmodule

module signed_mult (out, clk, a, b);
 output [15:0] out;
 input clk;
 input signed [7:0] a;
 input signed [7:0] b;
 reg signed [7:0] a_reg;
 reg signed [7:0] b_reg;
 reg signed [15:0] out;
 wire signed [15:0] mult_out;
 assign mult_out = a_reg * b_reg;
 always @ (posedge clk)
 begin
 a_reg <= a;
 b_reg <= b;
 out <= mult_out;
 end
endmodule
