module max #(parameter DW = 16
	     )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    //Outputs
    output [DW-1:0] z
    );

   assign z = (a > b) ? a : b;

endmodule
