module min #(parameter DW = 16
	         )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    //Outputs
    output [DW-1:0] out
    );

   assign out = (a < b) ? a : b;

endmodule
