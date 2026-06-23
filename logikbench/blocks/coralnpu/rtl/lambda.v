module lambda_expand #(
    parameter IDW = 16,  // Input data width
    parameter GDW = 8    // Group width
) (
    input [IDW-1:0] din,
    output [IDW*GDW-1:0] dout
);

  genvar i;
  genvar j;
  for (i = 0; i < IDW; i = i + 1) begin : INPUTDATA
    for (j = 0; j < GDW; j = j + 1) begin : GROUPDATA
      assign dout[i * GDW + j] = din[i];
    end
  end

endmodule


module Sram_512x128(
  input          clock,
  input          enable,
  input          write,
  input  [8:0]   addr,
  input  [127:0] wdata,
  input  [15:0] wmask,
  output [127:0] rdata
);

  wire [127:0] wmask_bits;
  lambda_expand #(.IDW(16), .GDW(8)) expand (
    .din(wmask),
    .dout(wmask_bits)
  );

  la_spram #(.DW(128), .AW(9)) memory (
    .clk(clock),
    .ce(enable),
    .we(write),
    .wmask(wmask_bits),
    .addr(addr),
    .din(wdata),
    .dout(rdata),
    .selctrl(1'b0),
    .ctrl('b0),
    .status()
  );

endmodule

module Sram_2048x128(
  input          clock,
  input          enable,
  input          write,
  input  [10:0]   addr,
  input  [127:0] wdata,
  input  [15:0] wmask,
  output [127:0] rdata
);

  wire [127:0] wmask_bits;
  lambda_expand #(.IDW(16), .GDW(8)) expand (
    .din(wmask),
    .dout(wmask_bits)
  );

  la_spram #(.DW(128), .AW(11)) memory (
    .clk(clock),
    .ce(enable),
    .we(write),
    .wmask(wmask_bits),
    .addr(addr),
    .din(wdata),
    .dout(rdata),
    .selctrl(1'b0),
    .ctrl('b0),
    .status()
  );

endmodule
