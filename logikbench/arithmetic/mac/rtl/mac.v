module mac #(parameter DW = 16,
             parameter OW = 40
             )
   (
    input               clk,
    input               clear,
    input               en,
    input [DW-1:0]      a,
    input [DW-1:0]      b,
    output reg [OW-1:0] c
    );

   always @(posedge clk) begin
      if (clear)
        c <= 0;
      else if (en)
        c <= c + a * b;
   end

endmodule
