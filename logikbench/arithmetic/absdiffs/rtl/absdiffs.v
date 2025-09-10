module absdiffs #(parameter DW = 16
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
   assign z    = (diff < 0) ? -diff : diff;

endmodule
