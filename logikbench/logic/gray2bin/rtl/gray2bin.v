module gray2bin #(parameter DW = 32) // data width
   (
    input [DW-1:0]  in, // gray encoded input
    output [DW-1:0] out // binary output
    );

   integer i;
   reg [DW-1:0] b;

   always @(*) begin
      b[DW-1] = in[DW-1];
      for (i = DW-2; i >= 0; i = i - 1)
        b[i] = b[i+1] ^ in[i];
   end
   assign out[DW-1:0] = b;

endmodule
