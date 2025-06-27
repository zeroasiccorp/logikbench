module mac #(parameter DW = 16,  // input data widths
             parameter ACCW = 40 // accumulator width
             )
   (
    input                 clk,
    input                 clear,
    input                 en,
    input [DW-1:0]        a,
    input [DW-1:0]        b,
    output reg [ACCW-1:0] acc
    );

   always @(posedge clk) begin
      if (clear)
        acc <= 0;
      else if (en)
        acc <= acc + a * b;
   end

endmodule
