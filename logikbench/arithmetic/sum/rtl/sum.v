module sum #(parameter N = 8,
             parameter DW = 16
             )
   (
    input [N*DW-1:0]             a,  // concatenated input vector a
    input [N*DW-1:0]             b,  // concatenated input vector b
    output [DW + $clog2(N) -1:0] out // Sum of products
    );

   // Internal variables
   integer i;
   reg [DW + $clog2(N) -1:0] sum;

   // Unpack elements and compute dot product
   always @(*) begin
      sum = 0;
      for (i = 0; i < N; i = i + 1) begin
         sum = sum + a[i*DW +: DW];
      end
   end

   assign out = sum;

endmodule
