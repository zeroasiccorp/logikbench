//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// True dual-port RAM (two read/write ports), single clock, whole word.
// Implemented on lambdalib la_tdpram so memory mapping is technology agnostic
// (FPGA BRAM / ASIC macro) and handled by lambdalib. Note: la_tdpram
// suppresses a port's read while that port is writing.

module ramtdp #(parameter DW = 16,
                parameter AW = 8
                )
   (
    // single clock
    input	    clk,
    // Port A - Read/Write
    input	    en_a,
    input	    we_a,
    input [AW-1:0]  addr_a,
    input [DW-1:0]  din_a,
    output [DW-1:0] dout_a,
    // Port B - Read/Write
    input	    en_b,
    input	    we_b,
    input [AW-1:0]  addr_b,
    input [DW-1:0]  din_b,
    output [DW-1:0] dout_b
    );

   la_tdpram #(.DW(DW), .AW(AW), .BYTEMODE(0)) memory
     (.clk_a   (clk),
      .ce_a    (en_a),
      .we_a    (we_a),
      .wmask_a ({DW{1'b1}}),
      .addr_a  (addr_a),
      .din_a   (din_a),
      .dout_a  (dout_a),
      .clk_b   (clk),
      .ce_b    (en_b),
      .we_b    (we_b),
      .wmask_b ({DW{1'b1}}),
      .addr_b  (addr_b),
      .din_b   (din_b),
      .dout_b  (dout_b),
      .selctrl (1'b0),
      .ctrl    ('b0),
      .status  ());

endmodule
