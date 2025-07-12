module muls #(parameter DW = 16,
              parameter OW = 32
	      )
   (
    //Inputs
    input signed [DW-1:0]  a, // a input (multiplier)
    input signed [DW-1:0]  b, // b input (multiplicand)
    //Outputs
    output signed [OW-1:0] c  // a * b final product
    );

   assign c[OW-1:0] = a[DW-1:0] * b[DW-1:0];

endmodule
