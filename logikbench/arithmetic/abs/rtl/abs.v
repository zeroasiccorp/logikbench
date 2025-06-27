module abs #(parameter DW = 8  // Operator width (8,16,32,64,128,...)
	     )
   (
    //Inputs
    input signed [DW-1:0] a,
    //Outputs
    output [DW-1:0]       z
    );

   assign z = (a < 0) ? -a : a;

endmodule
