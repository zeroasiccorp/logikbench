module dec #(parameter DW = 16
	     )
   (
    //Inputs
    input [DW-1:0]  a,
    output [DW-1:0] out
    );

   assign out = a - 1'b1;

endmodule
