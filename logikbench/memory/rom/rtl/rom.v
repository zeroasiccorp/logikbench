module rom #(parameter DW = 16,
             parameter AW = 10
             )
   (
    input               clk,  // clock
    input               en,   // memory enable
    input [AW-1:0]      addr, // addr
    output reg [DW-1:0] dout  // data output
    );

   reg [DW-1:0] mem [(2**AW)-1:0];

   // ROM initialization
   integer      i;
   initial
     begin
        for (i = 0; i < 2**AW; i = i + 1)
          mem[i] = i;
     end

   always @(posedge clk)
      if (en)
        dout <= mem[addr];

endmodule
