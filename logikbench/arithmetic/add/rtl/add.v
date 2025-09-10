module add #(parameter DW = 16
	     )
   (
    //Inputs
    input [DW-1:0]  a,
    input [DW-1:0]  b,
    input           cin,
    //Outputs
    output          cout,
    output [DW-1:0] sum
    );

   assign {cout, sum} = a + b + cin;

endmodule
