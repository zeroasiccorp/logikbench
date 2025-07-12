module muladd #(parameter DW = 16,
                parameter OW = 32,
	        )
   (
    //Inputs
    input [DW-1:0]  a, // a input (multiplier)
    input [DW-1:0]  b, // b input (multiplicand)
    input [OW-1:0]  c, // c input (add input)
    //Outputs
    output [OW-1:0] z  // a * b + c
    );

   assign z = a * b + c;

endmodule
