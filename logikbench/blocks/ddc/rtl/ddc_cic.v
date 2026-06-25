//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Cascaded Integrator-Comb (CIC) decimator (Hogenauer, 1981).
//
// Multiplierless decimate-by-R filter for a single real lane:
//   1. STAGES integrator sections running at the HIGH (input) rate.
//   2. A rate change: keep one sample out of every R inputs (decimation).
//   3. STAGES comb (differentiator) sections running at the LOW (output)
//      rate, with differential delay M = 1.
//
// Bit growth: the maximum register growth of an N-stage CIC with rate change
// R and differential delay M is
//
//   Bmax = ceil( N * log2(R*M) )      bits of headroom
//
// so every internal register is sized IQW + Bmax to avoid overflow. With the
// defaults (STAGES=4, R=8, M=1): Bmax = ceil(4*log2(8)) = 12, giving 28-bit
// internal registers for IQW=16. The final comb output is arithmetically
// right-shifted by Bmax to bring the DC gain (R*M)^N back to unity-ish and
// return an IQW-bit Q1.15 sample.
//
// The STAGES integrators and STAGES combs are built as generate chains (one
// register + one adder per stage), NOT a single procedural unrolled loop.
//
// Streaming: in_valid is asserted on every input sample; out_valid strobes
// once per R input samples (the decimated rate). No backpressure.
//
//#############################################################################

module ddc_cic
  #(parameter IQW = 16,	  // input/output sample width (Q1.15)
    parameter STAGES = 4, // number of integrator/comb stages (N)
    parameter R = 8,	  // decimation factor
    parameter M = 1	  // differential delay
    )
   (
    input			clk,
    input			rst, // synchronous, active high
    input			in_valid,
    input signed [IQW-1:0]	in_data,
    output reg			out_valid,
    output reg signed [IQW-1:0]	out_data
    );

   // Internal register width = IQW + ceil(STAGES*log2(R*M)).
   localparam BG  = $clog2(R*M);          // log2(R*M), exact for power-of-two R
   localparam BMAX = STAGES * BG;         // total bit growth headroom
   localparam W   = IQW + BMAX;           // internal register width
   localparam CW  = $clog2(R);            // decimation counter width

   // Stage buses: integ[0] = sign-extended input, integ[STAGES] = last
   // integrator output. comb[0] = decimated integrator output.
   wire signed [W-1:0] ig_in [0:STAGES];
   wire signed [W-1:0] cb_out [0:STAGES];

   reg [CW-1:0]	       cnt;          // decimation phase counter
   wire		       sample = (cnt == 0);   // take one sample per R
   reg		       cb_en;        // comb-rate enable (delayed sample)

   // sign-extend input into the wide integrator datapath
   assign ig_in[0] = {{(W-IQW){in_data[IQW-1]}}, in_data};

   //----------------------------------------------------------------------
   // STAGES integrators at the high rate: y[n] = y[n-1] + x[n]
   //----------------------------------------------------------------------
   genvar gi;
   generate
      for (gi = 0; gi < STAGES; gi = gi + 1) begin : g_integ
         reg signed [W-1:0] acc;
         always @(posedge clk) begin
            if (rst)
              acc <= {W{1'b0}};
            else if (in_valid)
              acc <= acc + ig_in[gi];
         end
         assign ig_in[gi+1] = acc;
      end
   endgenerate

   //----------------------------------------------------------------------
   // Decimation: register the last integrator output once per R samples.
   //----------------------------------------------------------------------
   reg signed [W-1:0] dec_data;
   always @(posedge clk) begin
      if (rst) begin
         cnt      <= {CW{1'b0}};
         dec_data <= {W{1'b0}};
         cb_en    <= 1'b0;
      end
      else begin
         cb_en <= 1'b0;
         if (in_valid) begin
            if (cnt == (R[CW-1:0] - 1'b1))
              cnt <= {CW{1'b0}};
            else
              cnt <= cnt + 1'b1;
            if (sample) begin
               dec_data <= ig_in[STAGES];
               cb_en    <= 1'b1;     // pulse comb chain next cycle
            end
         end
      end
   end

   assign cb_out[0] = dec_data;

   //----------------------------------------------------------------------
   // STAGES comb sections at the low rate: y[n] = x[n] - x[n-M]
   //----------------------------------------------------------------------
   genvar gc;
   generate
      for (gc = 0; gc < STAGES; gc = gc + 1) begin : g_comb
         reg signed [W-1:0] dly [0:M-1];
         integer            k;
         always @(posedge clk) begin
            if (rst) begin
               for (k = 0; k < M; k = k + 1)
                 dly[k] <= {W{1'b0}};
            end
            else if (cb_en) begin
               dly[0] <= cb_out[gc];
               for (k = 1; k < M; k = k + 1)
                 dly[k] <= dly[k-1];
            end
         end
         assign cb_out[gc+1] = cb_out[gc] - dly[M-1];
      end
   endgenerate

   //----------------------------------------------------------------------
   // Output: drop BMAX bits to renormalize, register on the comb strobe.
   //----------------------------------------------------------------------
   wire signed [W-1:0] norm = cb_out[STAGES] >>> BMAX;

   always @(posedge clk) begin
      if (rst) begin
         out_valid <= 1'b0;
         out_data  <= {IQW{1'b0}};
      end
      else begin
         out_valid <= cb_en;
         if (cb_en)
           out_data <= norm[IQW-1:0];
      end
   end

endmodule
