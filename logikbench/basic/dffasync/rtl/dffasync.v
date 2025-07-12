module dffasync #(parameter DW = 64
                  )
   (
    input               clk,
    input               nreset,
    input [DW-1:0]      d,
    output reg [DW-1:0] q
    );

   always @(posedge clk or negedge nreset)
     if (!nreset)
       q <= 'b0;
     else
       q <= d;

endmodule
