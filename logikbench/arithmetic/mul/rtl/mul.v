module mul #(parameter DW = 16,
             parameter OW = 32
	     )
   (
    //Inputs
    input [DW-1:0]  a,  // a input (multiplier)
    input [DW-1:0]  b,  // b input (multiplicand)
    //Outputs
    output [OW-1:0] out // a * b final product
    );

   assign out[DW-1:0] = a[DW-1:0] * b[DW-1:0];

endmodule
