module shiftreg #(parameter SW = 4  // selector width
	          )
   (
    //Inputs
    input [N-1:0]  a, // a input (multiplier)
    input [N-1:0]  b, // b input (multiplicand)
    //Outputs
    output [M-1:0] z  // a * b final product
    );
parameter SELWIDTH = 5;
input CLK, CE, SI;
input [SELWIDTH-1:0] SEL;
output DO;
   localparam DW = 2**SELWIDTH;
reg [DW-1:0] data;
assign DO = data[SEL];
always @(posedge CLK)
 begin
 if (CE == 1'b1)
 data <= {data[DATAWIDTH-2:0], SI};
 end
endmodule
