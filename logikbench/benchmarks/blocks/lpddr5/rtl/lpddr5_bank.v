//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// LPDDR5 per-bank state machine and timing tracker (one instance per bank).
//
// Tracks the open row and the per-bank timing eligibility for the four bank-
// local commands using saturating down-counters (a command is allowed when its
// counter has reached zero):
//
//   t_act : cycles until ACTIVATE is allowed   (tRP after PRE, tRC after ACT,
//           tRFCpb after a per-bank refresh)
//   t_col : cycles until a column RD/WR command is allowed  (tRCD after ACT)
//   t_pre : cycles until PRECHARGE is allowed   (tRAS after ACT, tRTP after RD,
//           write-recovery after WR)
//
// Cross-bank constraints (tRRD, tFAW, tCCD, bus turnaround, refresh interval)
// live in the lpddr5 top, which gates these per-bank "can_*" outputs before it
// actually issues a command and pulses the matching do_* strobe back here.
// All timing values arrive as parameters in CK (command-clock) units.
//
//#############################################################################

module lpddr5_bank
  #(parameter ROWW = 16,  // row address width
    parameter CW = 12,	  // timing counter width (holds the largest tXXX)
    parameter TRCD = 15,  // ACT -> RD/WR
    parameter TRP = 15,	  // PRE -> ACT
    parameter TRAS = 34,  // ACT -> PRE
    parameter TRC = 49,	  // ACT -> ACT (same bank) = tRAS + tRP
    parameter TRTP = 6,	  // RD  -> PRE
    parameter TWRC = 30,  // WR  -> PRE (WL + burst + tWR), write recovery
    parameter TRFC = 224) // refresh -> ACT (tRFCpb)
   (
    input	      clk,
    input	      rst,	// synchronous, active high
    input [ROWW-1:0]  act_row,	// row to open on do_act
    input	      do_act,	// issue ACTIVATE to this bank
    input	      do_rd,	// issue READ
    input	      do_wr,	// issue WRITE
    input	      do_pre,	// issue PRECHARGE
    input	      do_ref,	// issue per-bank refresh (bank must be idle)
    output	      row_open,	// a row is currently open
    output [ROWW-1:0] open_row,	// the open row address
    output	      can_act,	// ACTIVATE allowed (idle and t_act==0)
    output	      can_col,	// RD/WR allowed   (open and t_col==0)
    output	      can_pre	// PRECHARGE allowed(open and t_pre==0)
    );

   reg			rowv;
   reg [ROWW-1:0]	row;
   reg [CW-1:0]		t_act, t_col, t_pre;

   assign row_open = rowv;
   assign open_row = row;
   assign can_act  = !rowv && (t_act == {CW{1'b0}});
   assign can_col  =  rowv && (t_col == {CW{1'b0}});
   assign can_pre  =  rowv && (t_pre == {CW{1'b0}});

   // saturating-at-zero down counters
   wire [CW-1:0] act_d = (t_act != 0) ? t_act - 1'b1 : t_act;
   wire [CW-1:0] col_d = (t_col != 0) ? t_col - 1'b1 : t_col;
   wire [CW-1:0] pre_d = (t_pre != 0) ? t_pre - 1'b1 : t_pre;

   always @(posedge clk) begin
      if (rst) begin
	 rowv  <= 1'b0;
	 row   <= {ROWW{1'b0}};
	 t_act <= {CW{1'b0}};
	 t_col <= {CW{1'b0}};
	 t_pre <= {CW{1'b0}};
      end
      else begin
	 // default: advance all counters toward zero
	 t_act <= act_d;
	 t_col <= col_d;
	 t_pre <= pre_d;
	 if (do_act) begin
	    rowv  <= 1'b1;
	    row   <= act_row;
	    t_col <= TRCD[CW-1:0];
	    t_pre <= TRAS[CW-1:0];
	    t_act <= TRC[CW-1:0];
	 end
	 else if (do_rd) begin
	    // read-to-precharge guard (keep the larger of pending/tRTP)
	    if (TRTP[CW-1:0] > pre_d) t_pre <= TRTP[CW-1:0];
	 end
	 else if (do_wr) begin
	    if (TWRC[CW-1:0] > pre_d) t_pre <= TWRC[CW-1:0];
	 end
	 else if (do_pre) begin
	    rowv  <= 1'b0;
	    t_act <= TRP[CW-1:0];
	 end
	 else if (do_ref) begin
	    // bank must already be idle; block ACT for tRFCpb
	    t_act <= TRFC[CW-1:0];
	 end
      end
   end

endmodule
