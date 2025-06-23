module mult #(parameter N = 8  // Operator width (8,16,32,64,128)
	      )
   (
    //Inputs
    input [N-1:0]  a, // a input (multiplier)
    input [N-1:0]  b, // b input (multiplicand)
    //Outputs
    output [N-1:0] c  // a*b final product
    );

   wire [2*N-1:0] product;

   assign product[2*N-1:0] = a[N-1:0] * b[N-1:0];

   assign c[N-1:0] =  product[N-1:0];

endmodule
