module absdiffs #(parameter DW = 8  // Operator width (8,16,32,64,128,...)
	         )
   (
    //Inputs
    input signed [DW-1:0] a,
    input signed [DW-1:0] b,
    //Outputs
    output [DW-1:0]       z
    );

   wire [DW-1:0] diff;

   assign diff = a - b;
   assign diff = (diff < 0) ? -diff : diff;

endmodule
