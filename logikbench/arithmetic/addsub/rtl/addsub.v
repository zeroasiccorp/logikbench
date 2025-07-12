module addsub #(parameter DW = 16
	     )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    input           sel,
    //Outputs
    output [DW-1:0] z
    );

   assign z = sel ? a + b : a - b;

endmodule
