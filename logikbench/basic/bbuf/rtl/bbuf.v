module bbuf #(parameter DW = 64
              )
   (
    input [DW-1:0]  in,
    output [DW-1:0] out
    );

   assign out = in;

endmodule
