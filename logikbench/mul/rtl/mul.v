module mul #(parameter N = 8, // input width
             parameter M = 8  // output width(>=N)
	     )
   (
    //Inputs
    input [N-1:0]  a, // a input (multiplier)
    input [N-1:0]  b, // b input (multiplicand)
    //Outputs
    output [M-1:0] c  // a * b final product
    );

   assign c[M-1:0] = a[N-1:0] * b[N-1:0];

endmodule
