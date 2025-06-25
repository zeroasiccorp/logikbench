module onehot #(parameter DW = 32 // must be power of 2!
                )
   (
    input wire [$clog2(DW)-1:0] in, // binary input
    output reg [DW-1:0]         out // onehot output
    );


   integer i;

   always @(*) begin
      out = {DW{1'b0}};
      for (i = 0; i < DW; i = i + 1) begin
         if (in == i[$clog2(DW)-1:0])
           out[i] = 1'b1;
      end
   end

endmodule
