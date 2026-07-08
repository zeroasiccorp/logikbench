//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Fixed-point inverse square root 1/sqrt(x) (sequential, two-phase).
//
// For a Q(DW-QW).QW unsigned input x (value X = x/2^QW), the inverse square
// root 1/sqrt(X) in the same format is 2^(3*QW/2)/sqrt(x). It is computed in
// two sequential digit-recurrence phases (no multiplier): first floor(sqrt(x))
// via the non-restoring square-root recurrence, then the constant division
// 2^(3*QW/2)/root via the restoring divider. QW must be even and DW even.
// x = 0 saturates to all ones. Handshake mirrors the sqrt block.
//
//#############################################################################

module rsqrt #(parameter DW = 16,
               parameter QW = 8	// fractional bits, even (QW=8 tuned)
               )
   (
    input	    clk,
    input	    nreset,    // async reset, active low
    input	    in_valid,  // pulse to latch x and start
    input [DW-1:0]  x,
    output reg	    out_valid, // pulse when out is valid
    output reg	    busy,      // high while iterating
    output [DW-1:0] out	       // 1/sqrt(x) in Q(DW-QW).QW, saturated
    );

   localparam SQW  = DW / 2;                     // root width
   localparam CW   = (3*QW)/2 + 1;               // numerator / quotient width
   localparam [CW-1:0] CONST = {1'b1, {((3*QW)/2){1'b0}}};  // 2^(3QW/2)
   localparam [DW-1:0] MAXV  = {DW{1'b1}};

   localparam	       IDLE  = 2'd0;
   localparam	       PSQRT = 2'd1;
   localparam	       PDIV  = 2'd2;

   reg [1:0]	       state;
   // sqrt phase registers
   reg [DW-1:0]	       snum;   // running remainder
   reg [DW-1:0]	       sres;   // partial root
   reg [DW-1:0]	       sbitm;  // current weight 4^k
   reg [$clog2(SQW+1)-1:0] sqcnt;
   // divide phase registers
   reg [CW-1:0]		   dquo;   // numerator / quotient
   reg [SQW:0]		   drem;   // running remainder
   reg [SQW-1:0]	   ddvsr;  // divisor = root
   reg [SQW-1:0]	   droot;  // captured root (0 => saturate)
   reg [$clog2(CW+1)-1:0]  dcnt;

   // sqrt step (non-restoring digit recurrence): compute next remainder/root
   wire [DW-1:0]	   strial = sres + sbitm;
   wire			   sge    = (snum >= strial);
   wire [DW-1:0]	   snum_n  = sge ? (snum - strial) : snum;
   wire [DW-1:0]	   sres_n  = sge ? ((sres >> 1) + sbitm) : (sres >> 1);

   // divide step (restoring) on the combined {drem, dquo} register
   wire [SQW+CW:0]	   cat2   = {drem, dquo} << 1;
   wire [SQW:0]		   rem_s2 = cat2[SQW+CW:CW];
   wire [CW-1:0]	   quo_s2 = cat2[CW-1:0];
   wire			   ge2    = (rem_s2 >= {1'b0, ddvsr});

   assign out = (droot == 0) ? MAXV : {{(DW-CW){1'b0}}, dquo};

   always @(posedge clk or negedge nreset) begin
      if (!nreset) begin
         out_valid <= 1'b0;
         busy      <= 1'b0;
         state     <= IDLE;
         snum      <= {DW{1'b0}};
         sres      <= {DW{1'b0}};
         sbitm     <= {DW{1'b0}};
         sqcnt     <= {$clog2(SQW+1){1'b0}};
         dquo      <= {CW{1'b0}};
         drem      <= {(SQW+1){1'b0}};
         ddvsr     <= {SQW{1'b0}};
         droot     <= {SQW{1'b0}};
         dcnt      <= {$clog2(CW+1){1'b0}};
      end
      else begin
         out_valid <= 1'b0;
         case (state)
           IDLE: begin
              if (in_valid && !busy) begin
                 snum  <= x;
                 sres  <= {DW{1'b0}};
                 sbitm <= {{(DW-1){1'b0}}, 1'b1} << (DW-2);
                 sqcnt <= SQW[$clog2(SQW+1)-1:0];
                 busy  <= 1'b1;
                 state <= PSQRT;
              end
           end
           PSQRT: begin
              snum  <= snum_n;
              sres  <= sres_n;
              sbitm <= sbitm >> 2;
              sqcnt <= sqcnt - 1'b1;
              if (sqcnt == 1) begin
                 // sres_n is the final root; set up the constant division
                 droot <= sres_n[SQW-1:0];
                 ddvsr <= sres_n[SQW-1:0];
                 dquo   <= CONST;
                 drem   <= {(SQW+1){1'b0}};
                 dcnt   <= CW[$clog2(CW+1)-1:0];
                 state  <= PDIV;
              end
           end
           PDIV: begin
              if (ge2) begin
                 drem <= rem_s2 - {1'b0, ddvsr};
                 dquo <= quo_s2 | {{(CW-1){1'b0}}, 1'b1};
              end
              else begin
                 drem <= rem_s2;
                 dquo <= quo_s2;
              end
              dcnt <= dcnt - 1'b1;
              if (dcnt == 1) begin
                 busy      <= 1'b0;
                 out_valid <= 1'b1;
                 state     <= IDLE;
              end
           end
           default: state <= IDLE;
         endcase
      end
   end

endmodule
