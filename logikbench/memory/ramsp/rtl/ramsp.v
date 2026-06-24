// Whole-word single-port RAM. Implemented on lambdalib la_spram (write mask
// tied all-ones) so memory mapping is technology agnostic (FPGA BRAM / ASIC
// macro) and handled by lambdalib.

module ramsp #(parameter DW = 16,
               parameter AW = 10
               )
   (
    input               clk,  // clock
    input               we,   // write enable
    input [AW-1:0]      addr, // addr
    input [DW-1:0]      din,  // data input
    output [DW-1:0]     dout  // data output
    );

   la_spram #(.DW(DW), .AW(AW), .BYTEMODE(0)) memory
     (.clk     (clk),
      .ce      (1'b1),
      .we      (we),
      .wmask   ({DW{1'b1}}),
      .addr    (addr),
      .din     (din),
      .dout    (dout),
      .selctrl (1'b0),
      .ctrl    ('b0),
      .status  ());

endmodule
