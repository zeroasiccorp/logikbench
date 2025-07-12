module mulc #(parameter DW = 16
              )
   (
    input signed [DW-1:0]    a_re,
    input signed [DW-1:0]    a_im,
    input signed [DW-1:0]    b_re,
    input signed [DW-1:0]    b_im,
    output signed [2*DW-1:0] out_re,
    output signed [2*DW-1:0] out_im
    );

   assign out_re[2*DW-1:0] = (a_re * b_re) - (a_im * b_im);
   assign out_im[2*DW-1:0] = (a_re * b_im) + (a_im * b_re);

endmodule
