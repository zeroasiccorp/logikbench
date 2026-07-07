//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// linkmap: transport-layer framer and deframer for a serial data-converter
// link. It maps converter samples to octets and distributes the octets across
// lanes (framer), and reverses the mapping (deframer). Framer and deframer are
// independent paths so both are exercised; the mapping is a parametric,
// deterministic permutation that scales with M, S, N, and L.
//
// M samples-per-frame words of M... : M converters, S samples/frame, N-bit
// samples (N a multiple of 8), L lanes. Octet g is placed on lane (g mod L) at
// frame position (g / L) -- the round-robin octet-to-lane mapping.
//
//#############################################################################
module linkmap #(parameter M = 4,  // converters
                 parameter S = 4,  // samples per frame
                 parameter N = 16, // sample width (multiple of 8)
                 parameter L = 4   // lanes
                 )
   (
    input		   clk,
    input		   nreset,
    input [M*S*N-1:0]	   smp_in,   // packed samples
    output reg [M*S*N-1:0] lane_out, // framed lane data
    input [M*S*N-1:0]	   lane_in,  // framed lane data (to deframe)
    output reg [M*S*N-1:0] smp_out   // recovered samples
    );

   localparam NB        = N/8;          // octets per sample
   localparam TOCT      = M*S*NB;       // total octets per frame
   localparam FOCT      = TOCT/L;       // octets per lane
   localparam LANEW     = FOCT*8;       // bits per lane
   localparam SMPW      = M*S*N;

   wire [SMPW-1:0] framed;
   wire [SMPW-1:0] deframed;

   // octet g: source = sample (g/NB), byte (g%NB); dest = lane (g%L), pos (g/L)
   genvar	   g;
   generate
      for (g = 0; g < TOCT; g = g + 1) begin : g_map
         localparam integer SRC  = (g/NB)*N + (g%NB)*8;
         localparam integer DEST = (g%L)*LANEW + (g/L)*8;
         assign framed[DEST +: 8]   = smp_in[SRC +: 8];
         assign deframed[SRC +: 8]  = lane_in[DEST +: 8];
      end
   endgenerate

   always @(posedge clk or negedge nreset)
     if (!nreset) begin
        lane_out <= {SMPW{1'b0}};
        smp_out  <= {SMPW{1'b0}};
     end
     else begin
        lane_out <= framed;
        smp_out  <= deframed;
     end

endmodule
