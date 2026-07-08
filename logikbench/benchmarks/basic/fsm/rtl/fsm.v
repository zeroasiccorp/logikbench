//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
module parametric_fsm_benchmark
  #(parameter	     STATES = 256, // number of states
    parameter	     DW = 64,	   // input / output width
    parameter [31:0] SEED = 32'hA5A5A5A5
    )
   (
    input		clk,
    input		nreset,	// async reset, active low
    input [DW-1:0]	in,
    output reg [DW-1:0]	out
    );

   // Parametrized FSM with pseudo-random ("chaotic") transitions: the state
   // update mixes the state index, input, and SEED with XOR/shift/add so the
   // tool cannot fold it onto a counter and a dedicated carry chain. The state
   // count scales with STATES; a few states get arbitrary "bridge" transitions
   // while the rest use the mixed default.
   localparam STATE_WIDTH = $clog2(STATES);

   reg [STATE_WIDTH-1:0] current_state;
   reg [STATE_WIDTH-1:0] next_state;

   // state register
   always @(posedge clk or negedge nreset)
     if (!nreset)
       current_state <= {STATE_WIDTH{1'b0}};
     else
       current_state <= next_state;

   // next-state logic (special states, then the mixed default for the rest)
   always @(*)
     case (current_state)
       {STATE_WIDTH{1'b0}}: begin
          next_state = in[0] ? (STATES - 1) : 1'b1;
       end
       ((STATES/2) - 1): begin
          next_state = (^in) ? {STATE_WIDTH{1'b1}} : {STATE_WIDTH{1'b0}};
       end
       (STATES - 1): begin
          next_state = in ^ (SEED[STATE_WIDTH-1:0] >> 1);
       end
       default: begin
          next_state = (current_state ^ SEED[STATE_WIDTH-1:0]) + in;
       end
     endcase

   // output register: an irregular hash of the state and the input
   always @(posedge clk or negedge nreset)
     if (!nreset)
       out <= {DW{1'b0}};
     else
       out <= (current_state ^ (current_state >> 2)) + in;

endmodule
