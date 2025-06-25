module ramsp #(parameter DW = 32,
               parameter AW = 6
               )
   (
    input               clk,  // clock
    input               we,   // write enable
    input [AW-1:0]      addr, // addr
    input [DW-1:0]      din,  // data input
    output reg [DW-1:0] dout  // data output
    );

   reg [DW-1:0] mem [(2**AW)-1:0];

   always @(posedge clk) begin
      if (we)
        mem[addr] <= din;
      dout <= mem[addr];
   end

endmodule
