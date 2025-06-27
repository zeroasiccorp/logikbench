module csa32 #(parameter DW = 8  // Operator width (8,16,32,64,128,...)
	       )
   (
    //Inputs
    input [DW-1:0]  in0,
    input [DW-1:0]  in1,
    input [DW-1:0]  in2,
    //Outputs
    output [DW-1:0] s,
    output [DW-1:0] c
    );

   assign s[DW-1:0] = in0[DW-1:0] ^ in1[DW-1:0] ^ in2[DW-1:0];

   assign c[DW-1:0] = (in0[DW-1:0] & in1[DW-1:0]) |
		      (in1[DW-1:0] & in2[DW-1:0]) |
		      (in2[DW-1:0] & in0[DW-1:0] );

endmodule
