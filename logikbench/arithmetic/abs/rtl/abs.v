module abs #(parameter DW = 16
	     )
   (
    //Inputs
    input signed [DW-1:0] a,
    //Outputs
    output [DW-1:0]       z
    );

   assign z = (a < 0) ? -a : a;

endmodule
