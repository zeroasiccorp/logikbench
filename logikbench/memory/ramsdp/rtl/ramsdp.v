module ramsdp #(parameter DW = 32,
                parameter AW = 6
                )
   (
    // single clock
    input               clk,
    // Port A - Write Only
    input               en_a,
    input               we_a,
    input [AW-1:0]      addr_a,
    input [DW-1:0]      din_a,
    // Port B - Read Only
    input               en_b,
    input [AW-1:0]      addr_b,
    output reg [DW-1:0] dout_b
    );

   // Memory declaration
   reg [DW-1:0] mem [(2**AW)-1:0];

   // Port A: Write Only
   always @(posedge clk) begin
      if (en_a)
        if (we_a)
          mem[addr_a] <= din_a;
   end

   // Port B: Read Only
   always @(posedge clk) begin
      if (en_b)
        dout_b <= mem[addr_b];
   end

endmodule
