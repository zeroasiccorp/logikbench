module min #(parameter DW = 8  // Operator width (8,16,32,64,128,...)
	         )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    //Outputs
    output [DW-1:0] z
    );

   assign z = (a < b) ? a : b;

endmodule
