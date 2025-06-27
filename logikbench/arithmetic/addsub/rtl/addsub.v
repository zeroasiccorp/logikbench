module addsub #(parameter N = 8  // Operator width (8,16,32,64,128,...)
	     )
   (
    //Inputs
    input [N-1:0]  a,
    input [N-1:0]  b,
    input          sel,
    //Outputs
    output [N-1:0] z
    );

   assign z = sel ? a + b : a - b;

endmodule
