module rambyte #(parameter DW = 16,
                 parameter AW = 8
                 )
   (input               clk,  // write clock
    input               ce,   // chip enable
    input [DW/8-1:0]    we,   // per byte write mask
    input [AW-1:0]      addr, // write address
    input [DW-1:0]      din,  // write data
    output reg [DW-1:0] dout  // read output data
    );

   // Generic RTL RAM
   reg     [DW-1:0] ram[(2**AW)-1:0];
   integer          i;

   // ASIC style bytemask
   always @(posedge clk)
     if (ce) begin
        for (i=0;i<DW/8;i=i+1)
          if (we[i])
            ram[addr[AW-1:0]][i*8+:8] <= din[i*8+:8];
        dout[DW-1:0] <= ram[addr[AW-1:0]];
     end

endmodule
