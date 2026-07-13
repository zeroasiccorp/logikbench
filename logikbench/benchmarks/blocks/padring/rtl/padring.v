//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/*
 *
 * A generic scalable technology independent padring that helps asses
 * the area of a minimal GPIO padring in ASICs. In FPGAs, the logic
 * optimizes away to nothing since the buffers are pass through.
 *
 * The ring wraps lambdalib's la_padring, configured as a square,
 * uniform ring of bidirectional GPIO cells (plus minimal supply cells)
 * on all four sides. The per-side cellmap is defined in padring.vh.
 */

module padring
  #(parameter NPINS = 16,    // total signal pins per side
    parameter NSECTIONS = 1, // power sections per side
    parameter RINGW = 8,     // io ring width
    parameter CFGW = 8       // config width
    )
   (// continuous ground
    inout                       vss,
    // NORTH
    inout [NPINS-1:0]           no_pad,
    output [NPINS-1:0]          no_z,
    input [NPINS-1:0]           no_a,
    input [NPINS-1:0]           no_ie,
    input [NPINS-1:0]           no_oe,
    input [NPINS-1:0]           no_pe,
    input [NPINS-1:0]           no_ps,
    input [NPINS-1:0]           no_schmitt,
    input [NPINS-1:0]           no_fast,
    input [NPINS*2-1:0]         no_ds,
    input [NPINS*CFGW-1:0]      no_cfg,
    inout [NSECTIONS-1:0]       no_vdd,
    inout [NSECTIONS-1:0]       no_vddio,
    inout [NSECTIONS-1:0]       no_vssio,
    inout [NSECTIONS*RINGW-1:0] no_ioring,
    // EAST
    inout [NPINS-1:0]           ea_pad,
    output [NPINS-1:0]          ea_z,
    input [NPINS-1:0]           ea_a,
    input [NPINS-1:0]           ea_ie,
    input [NPINS-1:0]           ea_oe,
    input [NPINS-1:0]           ea_pe,
    input [NPINS-1:0]           ea_ps,
    input [NPINS-1:0]           ea_schmitt,
    input [NPINS-1:0]           ea_fast,
    input [NPINS*2-1:0]         ea_ds,
    input [NPINS*CFGW-1:0]      ea_cfg,
    inout [NSECTIONS-1:0]       ea_vdd,
    inout [NSECTIONS-1:0]       ea_vddio,
    inout [NSECTIONS-1:0]       ea_vssio,
    inout [NSECTIONS*RINGW-1:0] ea_ioring,
    // SOUTH
    inout [NPINS-1:0]           so_pad,
    output [NPINS-1:0]          so_z,
    input [NPINS-1:0]           so_a,
    input [NPINS-1:0]           so_ie,
    input [NPINS-1:0]           so_oe,
    input [NPINS-1:0]           so_pe,
    input [NPINS-1:0]           so_ps,
    input [NPINS-1:0]           so_schmitt,
    input [NPINS-1:0]           so_fast,
    input [NPINS*2-1:0]         so_ds,
    input [NPINS*CFGW-1:0]      so_cfg,
    inout [NSECTIONS-1:0]       so_vdd,
    inout [NSECTIONS-1:0]       so_vddio,
    inout [NSECTIONS-1:0]       so_vssio,
    inout [NSECTIONS*RINGW-1:0] so_ioring,
    // WEST
    inout [NPINS-1:0]           we_pad,
    output [NPINS-1:0]          we_z,
    input [NPINS-1:0]           we_a,
    input [NPINS-1:0]           we_ie,
    input [NPINS-1:0]           we_oe,
    input [NPINS-1:0]           we_pe,
    input [NPINS-1:0]           we_ps,
    input [NPINS-1:0]           we_schmitt,
    input [NPINS-1:0]           we_fast,
    input [NPINS*2-1:0]         we_ds,
    input [NPINS*CFGW-1:0]      we_cfg,
    inout [NSECTIONS-1:0]       we_vdd,
    inout [NSECTIONS-1:0]       we_vddio,
    inout [NSECTIONS-1:0]       we_vssio,
    inout [NSECTIONS*RINGW-1:0] we_ioring
    );

`include "padring.vh"

   // per-side aliases for a square, uniform ring. These give the
   // AUTOINST bit-select ranges (which use la_padring's per-side
   // parameter names) something to resolve against in this scope.
   localparam NO_NPINS = NPINS, EA_NPINS = NPINS,
              SO_NPINS = NPINS, WE_NPINS = NPINS;
   localparam NO_NSECTIONS = NSECTIONS, EA_NSECTIONS = NSECTIONS,
              SO_NSECTIONS = NSECTIONS, WE_NSECTIONS = NSECTIONS;

   // analog inout buses are unused in this GPIO-only ring
   wire [NPINS*3-1:0] no_aio;
   wire [NPINS*3-1:0] ea_aio;
   wire [NPINS*3-1:0] so_aio;
   wire [NPINS*3-1:0] we_aio;

   la_padring #(.CFGW         (CFGW),
                .RINGW        (RINGW),
                // north
                .NO_NPINS     (NPINS),
                .NO_NCELLS    (NCELLS),
                .NO_NSECTIONS (NSECTIONS),
                .NO_CELLMAP   (CELLMAP),
                // east
                .EA_NPINS     (NPINS),
                .EA_NCELLS    (NCELLS),
                .EA_NSECTIONS (NSECTIONS),
                .EA_CELLMAP   (CELLMAP),
                // south
                .SO_NPINS     (NPINS),
                .SO_NCELLS    (NCELLS),
                .SO_NSECTIONS (NSECTIONS),
                .SO_CELLMAP   (CELLMAP),
                // west
                .WE_NPINS     (NPINS),
                .WE_NCELLS    (NCELLS),
                .WE_NSECTIONS (NSECTIONS),
                .WE_CELLMAP   (CELLMAP))
   ipadring (// Outputs
	     .no_zp			(no_z[NO_NPINS-1:0]),
	     .no_zn			(),
	     .ea_zp			(ea_z[EA_NPINS-1:0]),
	     .ea_zn			(),
	     .so_zp			(so_z[SO_NPINS-1:0]),
	     .so_zn			(),
	     .we_zp			(we_z[WE_NPINS-1:0]),
	     .we_zn			(),
	     // Inouts
	     .vss			(vss),
	     .no_pad			(no_pad[NO_NPINS-1:0]),
	     .no_aio			(no_aio[NO_NPINS*3-1:0]),
	     .no_vdd			(no_vdd[NO_NSECTIONS-1:0]),
	     .no_vddio			(no_vddio[NO_NSECTIONS-1:0]),
	     .no_vssio			(no_vssio[NO_NSECTIONS-1:0]),
	     .no_ioring			(no_ioring[NO_NSECTIONS*RINGW-1:0]),
	     .ea_pad			(ea_pad[EA_NPINS-1:0]),
	     .ea_aio			(ea_aio[EA_NPINS*3-1:0]),
	     .ea_vdd			(ea_vdd[EA_NSECTIONS-1:0]),
	     .ea_vddio			(ea_vddio[EA_NSECTIONS-1:0]),
	     .ea_vssio			(ea_vssio[EA_NSECTIONS-1:0]),
	     .ea_ioring			(ea_ioring[EA_NSECTIONS*RINGW-1:0]),
	     .so_pad			(so_pad[SO_NPINS-1:0]),
	     .so_aio			(so_aio[SO_NPINS*3-1:0]),
	     .so_vdd			(so_vdd[SO_NSECTIONS-1:0]),
	     .so_vddio			(so_vddio[SO_NSECTIONS-1:0]),
	     .so_vssio			(so_vssio[SO_NSECTIONS-1:0]),
	     .so_ioring			(so_ioring[SO_NSECTIONS*RINGW-1:0]),
	     .we_pad			(we_pad[WE_NPINS-1:0]),
	     .we_aio			(we_aio[WE_NPINS*3-1:0]),
	     .we_vdd			(we_vdd[WE_NSECTIONS-1:0]),
	     .we_vddio			(we_vddio[WE_NSECTIONS-1:0]),
	     .we_vssio			(we_vssio[WE_NSECTIONS-1:0]),
	     .we_ioring			(we_ioring[WE_NSECTIONS*RINGW-1:0]),
	     // Inputs
	     .no_a			(no_a[NO_NPINS-1:0]),
	     .no_ie			(no_ie[NO_NPINS-1:0]),
	     .no_oe			(no_oe[NO_NPINS-1:0]),
	     .no_pe			(no_pe[NO_NPINS-1:0]),
	     .no_ps			(no_ps[NO_NPINS-1:0]),
	     .no_schmitt		(no_schmitt[NO_NPINS-1:0]),
	     .no_fast			(no_fast[NO_NPINS-1:0]),
	     .no_ds			(no_ds[NO_NPINS*2-1:0]),
	     .no_cfg			(no_cfg[NO_NPINS*CFGW-1:0]),
	     .ea_a			(ea_a[EA_NPINS-1:0]),
	     .ea_ie			(ea_ie[EA_NPINS-1:0]),
	     .ea_oe			(ea_oe[EA_NPINS-1:0]),
	     .ea_pe			(ea_pe[EA_NPINS-1:0]),
	     .ea_ps			(ea_ps[EA_NPINS-1:0]),
	     .ea_schmitt		(ea_schmitt[EA_NPINS-1:0]),
	     .ea_fast			(ea_fast[EA_NPINS-1:0]),
	     .ea_ds			(ea_ds[EA_NPINS*2-1:0]),
	     .ea_cfg			(ea_cfg[EA_NPINS*CFGW-1:0]),
	     .so_a			(so_a[SO_NPINS-1:0]),
	     .so_ie			(so_ie[SO_NPINS-1:0]),
	     .so_oe			(so_oe[SO_NPINS-1:0]),
	     .so_pe			(so_pe[SO_NPINS-1:0]),
	     .so_ps			(so_ps[SO_NPINS-1:0]),
	     .so_schmitt		(so_schmitt[SO_NPINS-1:0]),
	     .so_fast			(so_fast[SO_NPINS-1:0]),
	     .so_ds			(so_ds[SO_NPINS*2-1:0]),
	     .so_cfg			(so_cfg[SO_NPINS*CFGW-1:0]),
	     .we_a			(we_a[WE_NPINS-1:0]),
	     .we_ie			(we_ie[WE_NPINS-1:0]),
	     .we_oe			(we_oe[WE_NPINS-1:0]),
	     .we_pe			(we_pe[WE_NPINS-1:0]),
	     .we_ps			(we_ps[WE_NPINS-1:0]),
	     .we_schmitt		(we_schmitt[WE_NPINS-1:0]),
	     .we_fast			(we_fast[WE_NPINS-1:0]),
	     .we_ds			(we_ds[WE_NPINS*2-1:0]),
	     .we_cfg			(we_cfg[WE_NPINS*CFGW-1:0]));

endmodule
