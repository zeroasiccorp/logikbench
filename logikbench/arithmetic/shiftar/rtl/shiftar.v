module shiftar #(parameter DW = 16
	       )
   (
    //Inputs
    input signed [DW-1:0]         a,  // data
    input signed [$clog2(DW)-1:0] b,  // shift amount
    //Outputs
    output [DW-1:0]               out // a >> b
    );

   assign out[DW-1:0] = a >> b;

endmodule
