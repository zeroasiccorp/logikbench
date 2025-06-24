module mulreg #(parameter N = 8, // input width
                parameter M = 8  // output width(>=N)
	        )
   (
    //Inputs
    input                     clk, // clock
    input signed [N-1:0]      a,   // a input (multiplier)
    input signed [N-1:0]      b,   // b input (multiplicand)
    //Outputs
    output reg signed [M-1:0] out  // a * b
    );

   reg signed [N-1:0] areg;
   reg signed [N-1:0] breg;
   wire signed [M-1:0] prod;

   // register inputs
   always @ (posedge clk)
     begin
        areg[N-1:0] <= a;
        breg[N-1:0] <= b;
     end

   // multiplier
   assign prod[M-1:0] = areg[N-1:0] * breg[N-1:0];

   // register output
   always @ (posedge clk)
     out[M-1:0]  <= prod;

endmodule
