module sine #(parameter DW = 8
	      )
   (
    input               clk,
    input               nreset,
    input [DW-1:0]      a,
    output reg [DW-1:0] out
    );

`include "sine_table256.vh"

   wire [DW-1:0] sine_table[2**DW-1:0];
   genvar i;

   //#############################
   // one shot lookup
   //#############################

   always @(posedge clk or posedge nreset)
     if (nreset)
       out <= 'b0;
     else
       out <= sine_table[a];

   //#############################
   // tables
   //#############################

   if (DW==8)
     begin
        for (i = 0; i < 2**DW; i = i + 1)
          assign sine_table[i] = SINETABLE_256[i];
     end
   else
     begin
        initial
          $display("Only DW=8 implemented for sine function");
     end

endmodule
