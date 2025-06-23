module muladd #(parameter N = 8, // input width
                parameter M = 8 // output width (>=N)
	        )
   (
    //Inputs
    input [N-1:0]  a,     // a input (multiplier)
    input [N-1:0]  b,     // b input (multiplicand)
    input [M-1:0]  c,     // c input (add input)
    //Outputs
    output [M-1:0] result // a * b + c
    );

   assign result[M-1:0] = a[N-1:0] * b[N-1:0] + c[M-1:0];

endmodule
