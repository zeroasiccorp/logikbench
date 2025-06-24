module ramsdp #(parameter DW = 32,
                parameter AW= 6
                )
   (
    input               clk,
    // Port A - Read/Write
    input               we_a,
    input [AW-1:0]      addr_a,
    input [DW-1:0]      din_a,
    output reg [DW-1:0] dout_a,
    // Port B - Read Only
    input [AW-1:0]      addr_b,
    output reg [DW-1:0] dout_b
    );

    // Memory declaration
    reg [DW-1:0] mem [(2**AW)-1:0];

   // Port A: Read/Write
   always @(posedge clk) begin
      if (we_a)
        mem[addr_a] <= din_a;
      dout_a <= mem[addr_a];
   end

   // Port B: Read Only
   always @(posedge clk) begin
      dout_b <= mem[addr_b];
   end

endmodule
