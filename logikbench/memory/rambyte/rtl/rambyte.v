//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Per-byte write-mask single-port RAM. Implemented on lambdalib la_spram in
// byte mask mode (BYTEMODE=1) so memory mapping is technology agnostic (FPGA
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

   // Expand the per-byte mask to a byte-aligned per-bit mask; la_spram in
   // byte mode consumes wmask[i*8] for each 8-bit lane.
   wire [DW-1:0] wmask;
   genvar gi;
   generate
      for (gi = 0; gi < DW/8; gi = gi + 1) begin : g_lane
         assign wmask[gi*8+:8] = {8{we[gi]}};
      end
   endgenerate

   la_spram #(.DW(DW), .AW(AW), .BYTEMODE(1)) memory
     (.clk     (clk),
      .ce      (ce),
      .we      (1'b1),
      .wmask   (wmask),
      .addr    (addr),
      .din     (din),
      .dout    (dout),
      .selctrl (1'b0),
      .ctrl    ('b0),
      .status  ());

endmodule
