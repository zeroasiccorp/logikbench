module sqdiff #(parameter DW = 16
	        )
   (
    //Inputs
    input signed [DW-1:0] a,
    input signed [DW-1:0] b,
    //Outputs
    output [2*DW-1:0]     z
    );

   wire signed [DW:0] diff;

   assign diff = a - b;
   assign z = diff * diff;

endmodule
