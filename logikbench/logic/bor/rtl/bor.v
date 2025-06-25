module bor #(parameter DW = 32 // data width
              )
   (
    input [DW-1:0] in,
    output         out
    );

   assign out = |in;

endmodule
