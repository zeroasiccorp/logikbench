module abs #(parameter DW = 16
	     )
   (
    //Inputs
    input signed [DW-1:0] a,
    //Outputs
    output [DW-1:0]       out
    );

   assign out = (a < 0) ? -a : a;

endmodule
