module sub #(parameter N = 8  // Operator width (8,16,32,64,128,...)
	     )
   (
    //Inputs
    input [N-1:0]  a,
    input [N-1:0]  b,
    //Outputs
    output [N-1:0] z
    );

   assign {cout, z[N-1:0]} = a[N-1:0] - b[N-1:0];

endmodule
