module mux
  #(parameter N = 32, // vector width
    parameter M = 2   // number of vectors
    )
   (
    input [M-1:0]   sel, // select vector
    input [M*N-1:0] in,  // concatenated input {..,in1[N-1:0],in0[N-1:0]
    output [N-1:0]  out  // output
    );

   reg [N-1:0]     mux;
   integer         i;
   always @*
     begin
	mux[N-1:0] = 'b0;
	for(i=0;i<M;i=i+1)
	  mux[N-1:0] = mux[N-1:0] | {(N){sel[i]}} & in[((i+1)*N-1)-:N];
     end
   assign out[N-1:0] = mux[N-1:0];

endmodule
