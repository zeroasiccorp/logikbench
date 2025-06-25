module bbuf #(parameter DW = 32 // data width
              )
   (
    input [DW-1:0]  in,
    output [DW-1:0] out
    );

   assign out = in;

endmodule
