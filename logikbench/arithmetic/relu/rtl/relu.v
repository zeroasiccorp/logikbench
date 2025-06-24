module relu #(parameter N = 8) // data width
   (
    input signed [N-1:0]  in,
    output signed [N-1:0] out
    );

   assign out = (in > 0) ? in : 0;

endmodule
