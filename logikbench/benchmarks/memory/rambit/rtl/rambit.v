//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Per-bit write-mask single-port RAM. Implemented on lambdalib la_spram in
// per-bit mask mode (BYTEMASK=0) so memory mapping is technology agnostic
// (FPGA BRAM / ASIC macro) and handled by lambdalib.

module rambit #(parameter DW = 16,
                parameter AW = 8
                )
   (input               clk,  // write clock
    input               ce,   // chip enable
    input [DW-1:0]      we,   // per bit write mask
    input [AW-1:0]      addr, // write address
    input [DW-1:0]      din,  // write data
    output [DW-1:0]     dout  // read output data
    );

   la_spram #(.DW(DW), .AW(AW), .BYTEMASK(0)) memory
     (.clk     (clk),
      .ce      (ce),
      .we      (1'b1),
      .wmask   (we),
      .addr    (addr),
      .din     (din),
      .dout    (dout),
      .selctrl (1'b0),
      .ctrl    ('b0),
      .status  ());

endmodule
