module shiftr #(parameter DW = 16
	       )
   (
    //Inputs
    input [DW-1:0]         a,  // data
    input [$clog2(DW)-1:0] b,  // shift amount
    //Outputs
    output [DW-1:0]        out // a >> b
    );

   assign out[DW-1:0] = a >> b;

endmodule
