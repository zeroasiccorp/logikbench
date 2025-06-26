module ramdp #(parameter DW = 16,
               parameter AW = 10
               )
   (
    // single clock
    input               clk,
    // Port A - Read/Write
    input               en_a,
    input               we_a,
    input [AW-1:0]      addr_a,
    input [DW-1:0]      din_a,
    output reg [DW-1:0] dout_a,
    // Port B - Read/Write
    input               en_b,
    input               we_b,
    input [AW-1:0]      addr_b,
    input [DW-1:0]      din_b,
    output reg [DW-1:0] dout_b
    );

   // RAM
   reg [DW-1:0] mem [(2**AW)-1:0];

   // Port A
   always @(posedge clk) begin
      if (en_a) begin
         if (we_a)
           mem[addr_a] <= din_a;
         dout_a[DW-1:0] <= mem[addr_a];
      end
   end

   // Port B
   always @(posedge clk) begin
      if (en_b) begin
         if (we_b)
           mem[addr_b] <= din_b;
         dout_b[DW-1:0] <= mem[addr_b];
      end
   end

endmodule
