module shiftreg # (parameter DW = 8
                   )
   (
    input           clk,
    input           en, // shift enable
    input           in, // serial input
    output [DW-1:0] out // parallel output
    );

   reg [DW-1:0] preg;
   integer i;

   always @(posedge clk)
     if (en) begin
        for (i = 0; i < DW-1; i = i+1)
          preg[i+1] <= preg[i];
        preg[0] <= in;
     end

   // exposing allof shift register
   assign out[DW-1:0] = preg;

endmodule
