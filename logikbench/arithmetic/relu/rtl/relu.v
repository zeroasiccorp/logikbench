module relu #(parameter DW = 16)
   (
    input signed [DW-1:0]  in,
    output signed [DW-1:0] out
    );

   assign out = (in > 0) ? in : 0;

endmodule
