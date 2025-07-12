module mul #(parameter DW = 16,
             parameter OW = 32
	     )
   (
    //Inputs
    input [DW-1:0]  a, // a input (multiplier)
    input [DW-1:0]  b, // b input (multiplicand)
    //Outputs
    output [OW-1:0] c  // a * b final product
    );

   assign c[DW-1:0] = a[DW-1:0] * b[DW-1:0];

endmodule
