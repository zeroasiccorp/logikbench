module log2 #(parameter DW = 8  // Operator width (8,16,32,64,128,...)
	      )
   (
    input [DW-1:0]            in,
    output reg [$clog2(DW):0] out
    );

   integer i;
   always @(*) begin
      out = 0;
      for (i = DW - 1; i >= 0; i = i - 1) begin
         if (in[i])
           out = i;
      end
   end

endmodule
