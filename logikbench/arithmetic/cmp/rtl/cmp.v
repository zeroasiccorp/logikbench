module cmp #(parameter DW = 16
	     )
   (
    //Inputs
    input [DW-1:0] a,
    input [DW-1:0] b,
    //Outputs
    output         aeqb, // a==b
    output         agtb, // a>b
    output         altb  // a<b
    );

   assign aeqb = (a == b);
   assign agtb = (a > b);
   assign altb = (a < b);

endmodule
