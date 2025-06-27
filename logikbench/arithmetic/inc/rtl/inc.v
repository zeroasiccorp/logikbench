module inc #(parameter N = 8  // Operator width (8,16,32,64,128,...)
	     )
   (
    //Inputs
    input [N-1:0]  a,
    output [N-1:0] z
    );

   assign z = a + 1'b1;

endmodule
