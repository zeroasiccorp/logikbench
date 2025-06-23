module mults #(parameter N = 8 // input width
               parameter M = 8 // output width (>=N)
	       )
   (
    //Inputs
    input signed [N-1:0]  a, // a input (multiplier)
    input signed [N-1:0]  b, // b input (multiplicand)
    //Outputs
    output signed [M-1:0] c  // a * b final product
    );

   assign c[M-1:0] = a[N-1:0] * b[N-1:0];

endmodule
