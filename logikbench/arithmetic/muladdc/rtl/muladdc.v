module muladdc #(parameter DW = 16,
                 parameter OW = 40
                 )
   (
    input signed [DW-1:0]  a_re,
    input signed [DW-1:0]  a_im,
    input signed [DW-1:0]  b_re,
    input signed [DW-1:0]  b_im,
    input signed [OW-1:0]  c_re,
    input signed [OW-1:0]  c_im,
    output signed [OW-1:0] out_re,
    output signed [OW-1:0] out_im
    );

   wire [2*DW-1:0] prod_re;
   wire [2*DW-1:0] prod_im;

   assign prod_re[2*DW-1:0] = (a_re * b_re) - (a_im * b_im);
   assign prod_im[2*DW-1:0] = (a_re * b_im) + (a_im * b_re);

   assign out_re = c_re + prod_re;
   assign out_im = c_im + prod_im;

endmodule
