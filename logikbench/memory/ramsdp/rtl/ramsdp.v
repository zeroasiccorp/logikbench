//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
// Simple dual-port RAM (1 write port + 1 read port), single clock, whole
// word. Implemented on lambdalib la_dpram so memory mapping is technology
// agnostic (FPGA BRAM / ASIC macro) and handled by lambdalib.

module ramsdp #(parameter DW = 16,
                parameter AW = 10
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
    output [DW-1:0]     dout_b
    );

   la_dpram #(.DW(DW), .AW(AW), .BYTEMODE(0)) memory
     (.wr_clk   (clk),
      .wr_ce    (en_a),
      .wr_we    (we_a),
      .wr_wmask ({DW{1'b1}}),
      .wr_addr  (addr_a),
      .wr_din   (din_a),
      .rd_clk   (clk),
      .rd_ce    (en_b),
      .rd_addr  (addr_b),
      .rd_dout  (dout_b),
      .selctrl  (1'b0),
      .ctrl     ('b0),
      .status   ());

endmodule
