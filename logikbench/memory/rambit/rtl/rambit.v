module rambit #(parameter DW = 16,
                parameter AW = 8
                )
   (input               clk,  // write clock
    input               ce,   // chip enable
    input [DW-1:0]      we,   // per bit write mask
    input [AW-1:0]      addr, // write address
    input [DW-1:0]      din,  // write data
    output reg [DW-1:0] dout  // read output data
    );

   // Generic RTL RAM
   reg     [DW-1:0] ram[(2**AW)-1:0];
   integer          i;

   // ASIC style bitmask
   always @(posedge clk)
     if (ce) begin
        for (i=0;i<DW;i=i+1)
          if (we[i])
            ram[addr[AW-1:0]][i] <= din[i];
        dout[DW-1:0] <= ram[addr[AW-1:0]];
     end

endmodule
