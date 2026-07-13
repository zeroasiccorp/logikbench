//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Cellmap for the minimal GPIO padring benchmark. All four sides share
// this single map (square, uniform ring). The ring is a repeating 8-GPIO
// unit: 8 bidirectional cells followed by a power block
// (VDD/VSS/VDDIO/VSSIO), preceded by a power-on cell and a vssio guard,
// all in one power section (NSECTIONS=1).
//
// CELLMAP entry (80 bits, per la_padring):
//   {PROP[15:0], SECTION[15:0], CELL[15:0], COMP[15:0], PIN[15:0]}
// Cell index 0 is the LSB entry (listed last). PIN indexes the pad bus
// (0..NPINS-1); supply cells use NULL. Cell types come from la_padring.vh.
//
// The array holds all 32 GPIO (MAX cells). NCELLS, derived from NPINS (a
// multiple of 8, up to 32), is the active count; la_padring reads only the
// low NCELLS cells, so a smaller NPINS uses the first NPINS/8 units.
//
//#############################################################################

`include "la_padring.vh"

localparam MAX    = 50;                     // total cells stored (32 GPIO)
localparam NCELLS = 2 + 12 * (NPINS / 8);   // active cells for this NPINS

localparam [MAX*80-1:0] CELLMAP = {
   {NULL, 16'd0, LA_VSSIO, NULL, NULL   }, // cell 49: unit 3 power block
   {NULL, 16'd0, LA_VDDIO, NULL, NULL   }, // cell 48: unit 3 power block
   {NULL, 16'd0, LA_VSS,   NULL, NULL   }, // cell 47: unit 3 power block
   {NULL, 16'd0, LA_VDD,   NULL, NULL   }, // cell 46: unit 3 power block
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd31 }, // cell 45: gpio pin 31
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd30 }, // cell 44: gpio pin 30
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd29 }, // cell 43: gpio pin 29
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd28 }, // cell 42: gpio pin 28
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd27 }, // cell 41: gpio pin 27
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd26 }, // cell 40: gpio pin 26
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd25 }, // cell 39: gpio pin 25
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd24 }, // cell 38: gpio pin 24
   {NULL, 16'd0, LA_VSSIO, NULL, NULL   }, // cell 37: unit 2 power block
   {NULL, 16'd0, LA_VDDIO, NULL, NULL   }, // cell 36: unit 2 power block
   {NULL, 16'd0, LA_VSS,   NULL, NULL   }, // cell 35: unit 2 power block
   {NULL, 16'd0, LA_VDD,   NULL, NULL   }, // cell 34: unit 2 power block
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd23 }, // cell 33: gpio pin 23
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd22 }, // cell 32: gpio pin 22
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd21 }, // cell 31: gpio pin 21
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd20 }, // cell 30: gpio pin 20
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd19 }, // cell 29: gpio pin 19
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd18 }, // cell 28: gpio pin 18
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd17 }, // cell 27: gpio pin 17
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd16 }, // cell 26: gpio pin 16
   {NULL, 16'd0, LA_VSSIO, NULL, NULL   }, // cell 25: unit 1 power block
   {NULL, 16'd0, LA_VDDIO, NULL, NULL   }, // cell 24: unit 1 power block
   {NULL, 16'd0, LA_VSS,   NULL, NULL   }, // cell 23: unit 1 power block
   {NULL, 16'd0, LA_VDD,   NULL, NULL   }, // cell 22: unit 1 power block
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd15 }, // cell 21: gpio pin 15
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd14 }, // cell 20: gpio pin 14
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd13 }, // cell 19: gpio pin 13
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd12 }, // cell 18: gpio pin 12
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd11 }, // cell 17: gpio pin 11
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd10 }, // cell 16: gpio pin 10
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd9  }, // cell 15: gpio pin 9
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd8  }, // cell 14: gpio pin 8
   {NULL, 16'd0, LA_VSSIO, NULL, NULL   }, // cell 13: unit 0 power block
   {NULL, 16'd0, LA_VDDIO, NULL, NULL   }, // cell 12: unit 0 power block
   {NULL, 16'd0, LA_VSS,   NULL, NULL   }, // cell 11: unit 0 power block
   {NULL, 16'd0, LA_VDD,   NULL, NULL   }, // cell 10: unit 0 power block
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd7  }, // cell  9: gpio pin 7
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd6  }, // cell  8: gpio pin 6
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd5  }, // cell  7: gpio pin 5
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd4  }, // cell  6: gpio pin 4
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd3  }, // cell  5: gpio pin 3
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd2  }, // cell  4: gpio pin 2
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd1  }, // cell  3: gpio pin 1
   {NULL, 16'd0, LA_BIDIR, NULL, 16'd0  }, // cell  2: gpio pin 0
   {NULL, 16'd0, LA_VSSIO, NULL, NULL   }, // cell  1: vssio guard
   {NULL, 16'd0, LA_POC,   NULL, NULL   }  // cell  0: power-on ctrl
   };
