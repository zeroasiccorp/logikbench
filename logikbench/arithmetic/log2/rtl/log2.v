module log2 #(parameter DW = 16
	      )
   (
    input [DW-1:0]            a,
    output reg [$clog2(DW):0] out
    );

   integer i;
   always @(*) begin
      out = 0;
      for (i = DW - 1; i >= 0; i = i - 1) begin
         if (a[i])
           out = i;
      end
   end

endmodule
