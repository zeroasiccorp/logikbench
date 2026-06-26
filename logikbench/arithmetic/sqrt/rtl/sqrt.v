//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Unsigned integer square root (sequential digit-recurrence).
//
// Computes root = floor(sqrt(x)) for a DW-bit unsigned input, plus the
// remainder rem = x - root*root (which satisfies 0 <= rem <= 2*root). DW must
// be even; the root is DW/2 bits and the remainder is DW/2+1 bits.
//
// Uses the classic digit-by-digit (non-restoring) recurrence: a one-hot weight
// "bitm" sweeps from 4^(DW/2-1) down to 4^0, one position per clock. Each cycle
// trial-subtracts (res + bitm) from the running remainder num; when it fits the
// bit is set into the result. The datapath is a single add + compare/subtract
// and a couple of shifts (no multiplier, no memory). Latency is DW/2 cycles.
//
// Handshake: pulse in_valid for one cycle to latch x and start; busy is high
// while iterating; out_valid pulses for one cycle when root/rem are valid.
//
//#############################################################################

module sqrt
  #(parameter DW = 32   // input width (even); root is DW/2, rem is DW/2+1
    )
   (
    input	      clk,
    input	      nreset,	 // async reset, active low
    input	      in_valid,	 // pulse to latch x and start
    input [DW-1:0]    x,	 // radicand
    output reg	      out_valid, // pulse when root/rem are valid
    output reg	      busy,	 // high while iterating
    output [DW/2-1:0] root,	 // floor(sqrt(x))
    output [DW/2:0]   rem	 // x - root*root  (0..2*root)
    );

   // working registers: num = running remainder, res = partial result,
   // bitm = current weight (4^k), swept from 4^(DW/2-1) down to 1.
   reg [DW-1:0]	num;
   reg [DW-1:0]	res;
   reg [DW-1:0]	bitm;

   // trial value for this digit
   wire [DW-1:0] trial = res + bitm;

   // root/remainder are the low bits of the final res/num
   assign root = res[DW/2-1:0];
   assign rem  = num[DW/2:0];

   always @(posedge clk or negedge nreset) begin
      if (!nreset) begin
	 out_valid <= 1'b0;
	 busy	   <= 1'b0;
	 num	   <= {DW{1'b0}};
	 res	   <= {DW{1'b0}};
	 bitm	   <= {DW{1'b0}};
      end
      else begin
	 out_valid <= 1'b0;
	 if (in_valid && !busy) begin
	    // latch and start: highest weight is 4^(DW/2-1) = 1 << (DW-2)
	    num	 <= x;
	    res	 <= {DW{1'b0}};
	    bitm <= {{(DW-1){1'b0}}, 1'b1} << (DW-2);
	    busy <= 1'b1;
	 end
	 else if (busy) begin
	    if (num >= trial) begin
	       num <= num - trial;
	       res <= (res >> 1) + bitm;
	    end
	    else begin
	       res <= res >> 1;
	    end
	    bitm <= bitm >> 2;
	    if (bitm == {{(DW-1){1'b0}}, 1'b1}) begin   // last digit (bitm==1)
	       busy      <= 1'b0;
	       out_valid <= 1'b1;
	    end
	 end
      end
   end

endmodule
