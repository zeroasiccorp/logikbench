//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for padring (self-checking). Exercises one north GPIO
// through the two functional modes of a bidirectional pad:
//   - output mode (oe=1): pad follows the core input 'a'
//   - input  mode (ie=1): core output 'z' follows the externally driven pad
// All other pins/sides are held inactive. Pulls are disabled (pe=0).
//
//#############################################################################
`timescale 1ns/1ps
module test_padring_smoke;

   localparam NPINS     = 16;
   localparam NSECTIONS = 1;
   localparam RINGW     = 8;
   localparam CFGW      = 8;

   reg              clk = 1'b0;
   integer          errors;

   // north core-side control
   reg [NPINS-1:0]      no_a, no_ie, no_oe, no_pe, no_ps, no_schmitt, no_fast;
   reg [NPINS*2-1:0]    no_ds;
   reg [NPINS*CFGW-1:0] no_cfg;
   wire [NPINS-1:0]     no_z;
   wire [NPINS-1:0]     no_pad;

   // external pad driver used for the input-mode test (north pin 0)
   reg                  drive_en, drive_val;

   // shared supply nets
   wire                 vss;
   wire [NSECTIONS-1:0] sup_vdd, sup_vddio, sup_vssio;

   assign vss       = 1'b0;
   assign sup_vdd   = 1'b1;
   assign sup_vddio = 1'b1;
   assign sup_vssio = 1'b0;

   // drive only north pin 0 from the outside; rest left floating
   assign no_pad[0] = drive_en ? drive_val : 1'bz;

   always #5 clk = ~clk;

   padring #(.NPINS(NPINS),
             .NSECTIONS(NSECTIONS),
             .RINGW(RINGW),
             .CFGW(CFGW))
   dut (// continuous ground
        .vss        (vss),
        // NORTH (exercised)
        .no_pad     (no_pad),
        .no_z       (no_z),
        .no_a       (no_a),
        .no_ie      (no_ie),
        .no_oe      (no_oe),
        .no_pe      (no_pe),
        .no_ps      (no_ps),
        .no_schmitt (no_schmitt),
        .no_fast    (no_fast),
        .no_ds      (no_ds),
        .no_cfg     (no_cfg),
        .no_vdd     (sup_vdd),
        .no_vddio   (sup_vddio),
        .no_vssio   (sup_vssio),
        .no_ioring  (),
        // EAST (inactive)
        .ea_pad     (),
        .ea_z       (),
        .ea_a       ({NPINS{1'b0}}),
        .ea_ie      ({NPINS{1'b0}}),
        .ea_oe      ({NPINS{1'b0}}),
        .ea_pe      ({NPINS{1'b0}}),
        .ea_ps      ({NPINS{1'b0}}),
        .ea_schmitt ({NPINS{1'b0}}),
        .ea_fast    ({NPINS{1'b0}}),
        .ea_ds      ({NPINS*2{1'b0}}),
        .ea_cfg     ({NPINS*CFGW{1'b0}}),
        .ea_vdd     (sup_vdd),
        .ea_vddio   (sup_vddio),
        .ea_vssio   (sup_vssio),
        .ea_ioring  (),
        // SOUTH (inactive)
        .so_pad     (),
        .so_z       (),
        .so_a       ({NPINS{1'b0}}),
        .so_ie      ({NPINS{1'b0}}),
        .so_oe      ({NPINS{1'b0}}),
        .so_pe      ({NPINS{1'b0}}),
        .so_ps      ({NPINS{1'b0}}),
        .so_schmitt ({NPINS{1'b0}}),
        .so_fast    ({NPINS{1'b0}}),
        .so_ds      ({NPINS*2{1'b0}}),
        .so_cfg     ({NPINS*CFGW{1'b0}}),
        .so_vdd     (sup_vdd),
        .so_vddio   (sup_vddio),
        .so_vssio   (sup_vssio),
        .so_ioring  (),
        // WEST (inactive)
        .we_pad     (),
        .we_z       (),
        .we_a       ({NPINS{1'b0}}),
        .we_ie      ({NPINS{1'b0}}),
        .we_oe      ({NPINS{1'b0}}),
        .we_pe      ({NPINS{1'b0}}),
        .we_ps      ({NPINS{1'b0}}),
        .we_schmitt ({NPINS{1'b0}}),
        .we_fast    ({NPINS{1'b0}}),
        .we_ds      ({NPINS*2{1'b0}}),
        .we_cfg     ({NPINS*CFGW{1'b0}}),
        .we_vdd     (sup_vdd),
        .we_vddio   (sup_vddio),
        .we_vssio   (sup_vssio),
        .we_ioring  ());

   initial begin
      $timeformat(-9, 0, " ns", 20);
      errors = 0;
      // all inactive
      no_a       <= {NPINS{1'b0}};
      no_ie      <= {NPINS{1'b0}};
      no_oe      <= {NPINS{1'b0}};
      no_pe      <= {NPINS{1'b0}};
      no_ps      <= {NPINS{1'b0}};
      no_schmitt <= {NPINS{1'b0}};
      no_fast    <= {NPINS{1'b0}};
      no_ds      <= {NPINS*2{1'b0}};
      no_cfg     <= {NPINS*CFGW{1'b0}};
      drive_en   <= 1'b0;
      drive_val  <= 1'b0;

      // OUTPUT MODE: pad must follow 'a'
      @(posedge clk);
      no_oe[0] <= 1'b1;
      no_ie[0] <= 1'b0;
      no_a[0]  <= 1'b1;
      @(posedge clk); #1;
      if (no_pad[0] !== 1'b1) begin
         errors = errors + 1;
         $display("FAIL: output a=1, no_pad[0]=%b", no_pad[0]);
      end
      @(posedge clk);
      no_a[0] <= 1'b0;
      @(posedge clk); #1;
      if (no_pad[0] !== 1'b0) begin
         errors = errors + 1;
         $display("FAIL: output a=0, no_pad[0]=%b", no_pad[0]);
      end

      // INPUT MODE: z must follow externally driven pad
      @(posedge clk);
      no_oe[0]  <= 1'b0;
      no_ie[0]  <= 1'b1;
      drive_en  <= 1'b1;
      drive_val <= 1'b1;
      @(posedge clk); #1;
      if (no_z[0] !== 1'b1) begin
         errors = errors + 1;
         $display("FAIL: input pad=1, no_z[0]=%b", no_z[0]);
      end
      @(posedge clk);
      drive_val <= 1'b0;
      @(posedge clk); #1;
      if (no_z[0] !== 1'b0) begin
         errors = errors + 1;
         $display("FAIL: input pad=0, no_z[0]=%b", no_z[0]);
      end

      if (errors == 0) $display("PASSED");
      else $display("FAILED (%0d errors)", errors);
      $finish;
   end

endmodule
