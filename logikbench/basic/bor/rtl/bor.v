module bor #(parameter DW = 64
              )
   (
    input [DW-1:0] in,
    output         out
    );

   assign out = |in;

endmodule
