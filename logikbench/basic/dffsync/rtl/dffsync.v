module dffsync #(parameter DW = 64
                 )
   (
    input               clk,
    input               reset,
    input [DW-1:0]      d,
    output reg [DW-1:0] q
    );

   always @(posedge clk)
     if (reset)
       q <= 'b0;
     else
       q <= d;

endmodule
