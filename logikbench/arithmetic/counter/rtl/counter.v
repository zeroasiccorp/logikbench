module counter #(parameter DW = 16  // counter width
             )
   (
    input               clk,
    input               clear,
    input               en,
    output reg [DW-1:0] count
    );

   always @(posedge clk) begin
      if (clear)
        count <= 0;
      else if (en)
        count <= count + 1;
   end

endmodule
