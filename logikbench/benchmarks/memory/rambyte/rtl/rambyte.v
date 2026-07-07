//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Per-byte write-mask single-port RAM. Implemented on lambdalib la_spram in
// byte mask mode (BYTEMASK=1) so memory mapping is technology agnostic (FPGA
// byte-wide BRAM / ASIC macro) and handled by lambdalib.

module rambyte #(parameter DW = 16,
                 parameter AW = 8
                 )
   (input               clk,  // write clock
    input               ce,   // chip enable
    input [DW/8-1:0]    we,   // per byte write mask
    input [AW-1:0]      addr, // write address
    input [DW-1:0]      din,  // write data
    output [DW-1:0]     dout  // read output data
    );

   // la_spram in byte mode takes a DW/8-wide per-byte write mask, so the
   // per-byte enable drives wmask directly.
   la_spram #(.DW(DW), .AW(AW), .BYTEMASK(1)) memory
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
