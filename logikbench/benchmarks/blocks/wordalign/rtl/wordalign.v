//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// wordalign: comma/sync-pattern detector and barrel bitslip aligner, the
// code-group-synchronization function of a serial converter link. Each cycle a
// W-bit deserialized word arrives; the block searches a 2-word window for the
// COMMA pattern at every bit offset, locks onto the first offset where it is
// found, and barrel-rotates the window so the aligned word appears on 'dout'
// (comma at the low bits).
//
//#############################################################################
module wordalign #(parameter	      DW = 40,  // word width
                   parameter	      PW = 10, // pattern width
                   parameter [PW-1:0] COMMA = 10'b0011111010
                   )
   (
    input                       clk,
    input                       nreset,
    input [DW-1:0]              din,    // deserialized word
    output reg [DW-1:0]         dout,   // aligned word
    output reg                  locked, // comma offset acquired
    output reg [$clog2(DW)-1:0] offset  // locked bit offset
    );

   localparam OW = $clog2(DW);

   // sliding 2-word window (previous | current)
   reg [DW-1:0] prev;
   wire [2*DW-1:0] window = {din, prev};

   // one comparator per candidate offset (generated)
   wire [DW-1:0]   match;
   genvar	  o;
   generate
      for (o = 0; o < DW; o = o + 1) begin : g_match
         assign match[o] = (window[o +: PW] == COMMA);
      end
   endgenerate

   // isolate the lowest matching offset and encode to binary (one-hot -> bin)
   wire [DW-1:0]  first = match & (~match + 1'b1);
   wire		 found = |match;
   wire [OW-1:0] off_c;
   genvar	 b, j;
   generate
      for (b = 0; b < OW; b = b + 1) begin : g_enc
         wire [DW-1:0] contrib;
         for (j = 0; j < DW; j = j + 1) begin : g_bit
            assign contrib[j] = first[j] & j[b];
         end
         assign off_c[b] = |contrib;
      end
   endgenerate

   // align using the locked offset once acquired, else the current candidate
   wire [OW-1:0]  use_off = locked ? offset : off_c;
   wire [2*DW-1:0] rotated = window >> use_off;
   wire [DW-1:0]   dout_nxt = rotated[DW-1:0];

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        prev   <= {DW{1'b0}};
        dout   <= {DW{1'b0}};
        locked <= 1'b0;
        offset <= {OW{1'b0}};
     end
     else begin
        prev <= din;
        dout <= dout_nxt;
        if (!locked & found) begin
           locked <= 1'b1;
           offset <= off_c;
        end
     end

endmodule
