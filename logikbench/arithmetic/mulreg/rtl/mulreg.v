module mulreg #(parameter DW = 16,
                parameter OW = 32
	        )
   (
    //Inputs
    input                      clk, // clock
    input signed [DW-1:0]      a,   // a input (multiplier)
    input signed [DW-1:0]      b,   // b input (multiplicand)
    //Outputs
    output reg signed [OW-1:0] out  // a * b
    );

   reg signed [DW-1:0] areg;
   reg signed [DW-1:0] breg;
   wire signed [OW-1:0] prod;

   // register inputs
   always @ (posedge clk)
     begin
        areg[DW-1:0] <= a;
        breg[DW-1:0] <= b;
     end

   // multiplier
   assign prod[OW-1:0] = areg[DW-1:0] * breg[DW-1:0];

   // register output
   always @ (posedge clk)
     out[OW-1:0]  <= prod;

endmodule
