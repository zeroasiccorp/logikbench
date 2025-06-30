/*******************************************************************************
 * Function:  Chipio APB UART Controller
 * Author:    Wenting Zhang
 * Copyright: (c) 2023 Zero ASIC. All rights reserved.
 *
 * License: GNU Lesser General Public License 2.1
 *
 * This module is adapted from the OpenCores UART 16550 compatible controller,
 * the original copyright information is included below.
 ******************************************************************************/

//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top.v                                                  ////
////                                                              ////
////                                                              ////
////  This file is part of the "UART 16550 compatible" project    ////
////  http://www.opencores.org/cores/uart16550/                   ////
////                                                              ////
////  Documentation related to this project:                      ////
////  - http://www.opencores.org/cores/uart16550/                 ////
////                                                              ////
////  Projects compatibility:                                     ////
////  - WISHBONE                                                  ////
////  RS232 Protocol                                              ////
////  16550D uart (mostly supported)                              ////
////                                                              ////
////  Overview (main Features):                                   ////
////  UART core top level.                                        ////
////                                                              ////
////  Known problems (limits):                                    ////
////  Note that transmitter and receiver instances are inside     ////
////  the uart_regs.v file.                                       ////
////                                                              ////
////  To Do:                                                      ////
////  Nothing so far.                                             ////
////                                                              ////
////  Author(s):                                                  ////
////      - gorban@opencores.org                                  ////
////      - Jacob Gorban                                          ////
////      - Igor Mohor (igorm@opencores.org)                      ////
////                                                              ////
////  Created:        2001/05/12                                  ////
////  Last Updated:   2001/05/17                                  ////
////                  (See log for the revision history)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000, 2001 Authors                             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.18  2002/07/22 23:02:23  gorban
// Bug Fixes:
//  * Possible loss of sync and bad reception of stop bit on slow baud rates fixed.
//   Problem reported by Kenny.Tung.
//  * Bad (or lack of ) loopback handling fixed. Reported by Cherry Withers.
//
// Improvements:
//  * Made FIFO's as general inferable memory where possible.
//  So on FPGA they should be inferred as RAM (Distributed RAM on Xilinx).
//  This saves about 1/3 of the Slice count and reduces P&R and synthesis times.
//
//  * Added optional baudrate output (baud_o).
//  This is identical to BAUDOUT* signal on 16550 chip.
//  It outputs 16xbit_clock_rate - the divided clock.
//  It's disabled by default. Define UART_HAS_BAUDRATE_OUTPUT to use.
//
// Revision 1.17  2001/12/19 08:40:03  mohor
// Warnings fixed (unused signals removed).
//
// Revision 1.16  2001/12/06 14:51:04  gorban
// Bug in LSR[0] is fixed.
// All WISHBONE signals are now sampled, so another wait-state is introduced on all transfers.
//
// Revision 1.15  2001/12/03 21:44:29  gorban
// Updated specification documentation.
// Added full 32-bit data bus interface, now as default.
// Address is 5-bit wide in 32-bit data bus mode.
// Added wb_sel_i input to the core. It's used in the 32-bit mode.
// Added debug interface with two 32-bit read-only registers in 32-bit mode.
// Bits 5 and 6 of LSR are now only cleared on TX FIFO write.
// My small test bench is modified to work with 32-bit mode.
//
// Revision 1.14  2001/11/07 17:51:52  gorban
// Heavily rewritten interrupt and LSR subsystems.
// Many bugs hopefully squashed.
//
// Revision 1.13  2001/10/20 09:58:40  gorban
// Small synopsis fixes
//
// Revision 1.12  2001/08/25 15:46:19  gorban
// Modified port names again
//
// Revision 1.11  2001/08/24 21:01:12  mohor
// Things connected to parity changed.
// Clock divider changed.
//
// Revision 1.10  2001/08/23 16:05:05  mohor
// Stop bit bug fixed.
// Parity bug fixed.
// WISHBONE read cycle bug fixed,
// OE indicator (Overrun Error) bug fixed.
// PE indicator (Parity Error) bug fixed.
// Register read bug fixed.
//
// Revision 1.4  2001/05/31 20:08:01  gorban
// FIFO changes and other corrections.
//
// Revision 1.3  2001/05/21 19:12:02  gorban
// Corrected some Linter messages.
//
// Revision 1.2  2001/05/17 18:34:18  gorban
// First 'stable' release. Should be sythesizable now. Also added new header.
//
// Revision 1.0  2001-05-17 21:27:12+02  jacob
// Initial revision
//
//

`include "uart_defines.vh"

module uart #(
    parameter RW = 32, // data width
    parameter RAW = 8 // address width
) (  // ctrl
    input               clk,            // main clock signal
    input               nreset,         // async active low reset
    // device port
    input [RAW-1:0]     apb_paddr,      // address bus (<=32b)
    input               apb_psel,       // select signal for each device
    input               apb_penable,    // goes high for cycle 2:n of transfer
    input               apb_pwrite,     // 1=write, 0=read
    input [RW-1:0]      apb_pwdata,     // write data (8, 16, 32b)
    input [RW/8-1:0]    apb_pstrb,      // (optional) write strobe byte lanes
    input [2:0]         apb_pprot,      // (optional) level of access
    output              apb_pready,     // "wait" signal asserted by device
    output reg [RW-1:0] apb_prdata,     // read data (8, 16, 32b)
    output              apb_pslverr,    // (optional) error asserted by device
    // uart interface
    input               rxd_in,         // received data
    output              txd_out,        // transmitted data
    output              rts_out,        // request to send
    input               cts_in,         // clear to send
    output              dtr_out,        // data terminal ready
    input               dsr_in,         // data set ready
    input               ri_in,          // ring indicator
    input               dcd_in,         // data carrier detect
    // interrupt to core
    output              irq             // interrupt request signal output
);

`define UART_DL1 7:0
`define UART_DL2 15:8

    reg enable;

    reg [3:0] ier;
    reg [3:0] iir;
    reg [1:0] fcr;
    reg [4:0] mcr;
    reg [7:0] lcr;
    reg [7:0] msr;
    reg [15:0] dl;  // 32-bit divisor latch
    reg [7:0] scratch;  // UART scratch register
    reg start_dlc;  // activate dlc on writing to UART_DL1
    reg lsr_mask_d;  // delay for lsr_mask condition
    reg msi_reset;  // reset MSR 4 lower bits indicator
    //reg 										threi_clear; // THRE interrupt clear flag
    reg [15:0] dlc;  // 32-bit divisor latch counter

    reg [3:0] trigger_level;  // trigger level of the receiver FIFO
    reg rx_reset;
    reg tx_reset;

    wire dlab;  // divisor latch access bit
    wire loopback;  // loopback bit (MCR bit 4)
    wire cts, dsr, ri, dcd;  // effective signals
    wire cts_c, dsr_c, ri_c, dcd_c;  // Complement effective signals (considering loopback)

    // LSR bits wires and regs
    wire [7:0] lsr;
    wire lsr0, lsr1, lsr2, lsr3, lsr4, lsr5, lsr6, lsr7;
    reg lsr0r, lsr1r, lsr2r, lsr3r, lsr4r, lsr5r, lsr6r, lsr7r;
    wire lsr_mask;  // lsr_mask

    //
    // ASSIGNS
    //

    assign lsr[7:0] = {lsr7r, lsr6r, lsr5r, lsr4r, lsr3r, lsr2r, lsr1r, lsr0r};

	// Synchronizing modem signals
	wire cts_pad, dsr_pad, ri_pad, dcd_pad;
    la_dsync cts_sync (
        .clk(clk),
        .in (cts_in),
        .out(cts_pad)
    );
	la_dsync dsr_sync (
        .clk(clk),
        .in (dsr_in),
        .out(dsr_pad)
    );
	la_dsync ri_sync (
        .clk(clk),
        .in (ri_in),
        .out(ri_pad)
    );
	la_dsync dcd_sync (
        .clk(clk),
        .in (dcd_in),
        .out(dcd_pad)
    );

    assign {cts, dsr, ri, dcd} = ~{cts_pad, dsr_pad, ri_pad, dcd_pad};

    assign {cts_c, dsr_c, ri_c, dcd_c} = loopback ?
        {mcr[`UART_MC_RTS], mcr[`UART_MC_DTR], mcr[`UART_MC_OUT1], mcr[`UART_MC_OUT2]} :
        {cts_pad, dsr_pad, ri_pad, dcd_pad};

    assign dlab = lcr[`UART_LC_DL];
    assign loopback = mcr[4];

    // assign modem outputs
    assign rts_out = mcr[`UART_MC_RTS];
    assign dtr_out = mcr[`UART_MC_DTR];

    // Interrupt signals
    wire rls_int;  // receiver line status interrupt
    wire rda_int;  // receiver data available interrupt
    wire ti_int;  // timeout indicator interrupt
    wire thre_int;  // transmitter holding register empty interrupt
    wire ms_int;  // modem status interrupt

    // FIFO signals
    reg tf_push;
    reg [`UART_FIFO_WIDTH-1:0] tf_data_in;
    reg rf_pop;
    wire [`UART_FIFO_REC_WIDTH-1:0] rf_data_out;
    wire rf_error_bit;  // an error (parity or framing) is inside the fifo
    wire [`UART_FIFO_COUNTER_W-1:0] rf_count;
    wire [`UART_FIFO_COUNTER_W-1:0] tf_count;
    wire [2:0] tstate;
    wire [3:0] rstate;
    wire [9:0] counter_t;

    wire thre_set_en;  // THRE status is delayed one character time when a character is written to fifo.
    reg [7:0] block_cnt;  // While counter counts, THRE status is blocked (delayed one character cycle)
    reg [7:0] block_value;  // One character length minus stop bit

    // Transmitter Instance
    wire serial_out;

    uart_transmitter transmitter (
        .clk       (clk),
        .nreset    (nreset),
        .lcr       (lcr),
        .tf_push   (tf_push),
        .tf_data_in(tf_data_in),
        .enable    (enable),
        .serial_out(serial_out),
        .tstate    (tstate),
        .tf_count  (tf_count),
        .tx_reset  (tx_reset),
        .lsr_mask  (lsr_mask)
    );

    // Synchronizing and sampling serial RX input
	wire srx_pad;
    la_dsync i_uart_sync_flops (
        .clk(clk),
        .in (rxd_in),
        .out(srx_pad)
    );

    // handle loopback
    wire serial_in = loopback ? serial_out : srx_pad;
    assign txd_out = loopback ? 1'b1 : serial_out;

    // Receiver Instance
	wire rf_overrun;
	wire rf_push_pulse;
    uart_receiver receiver (
        .clk          (clk),
        .nreset       (nreset),
        .lcr          (lcr),
        .rf_pop       (rf_pop),
        .serial_in    (serial_in),
        .enable       (enable),
        .counter_t    (counter_t),
        .rf_count     (rf_count),
        .rf_data_out  (rf_data_out),
        .rf_error_bit (rf_error_bit),
        .rf_overrun   (rf_overrun),
        .rx_reset     (rx_reset),
        .lsr_mask     (lsr_mask),
        .rstate       (rstate),
        .rf_push_pulse(rf_push_pulse)
    );

    // bus interface
    assign apb_pslverr = 'b0;
    assign apb_pready = 1'b1; // always ready, no wait state
    wire reg_read = apb_psel & ~apb_penable & ~apb_pwrite;
    wire reg_write = apb_psel & apb_penable & apb_pwrite;
    always @(posedge clk) begin  // asynchronous reading
        if (reg_read) begin
            case (apb_paddr[7:2])
                `UART_REG_RB: apb_prdata <= {24'd0, dlab ? dl[`UART_DL1] : rf_data_out[10:3]};
                `UART_REG_IE: apb_prdata <= {24'd0, dlab ? dl[`UART_DL2] : {4'd0, ier}};
                `UART_REG_II: apb_prdata <= {24'd0, 4'b1100, iir};
                `UART_REG_LC: apb_prdata <= {24'd0, lcr};
                `UART_REG_LS: apb_prdata <= {24'd0, lsr};
                `UART_REG_MS: apb_prdata <= {24'd0, msr};
                `UART_REG_SR: apb_prdata <= {24'd0, scratch};
                // 8 + 8 + 4 + 4 + 8
                `UART_REG_DBG0: apb_prdata <= {msr, lcr, iir, ier, lsr};
                // 5 + 2 + 5 + 4 + 5 + 3
                `UART_REG_DBG1: apb_prdata <= {8'b0, fcr, mcr, rf_count, rstate,
                        tf_count, tstate};
                default: apb_prdata <= 32'bx;
            endcase  // case(wb_addr_i)
        end
    end

    // rf_pop signal handling
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            rf_pop <= 0;
        else if (rf_pop)  // restore the signal to 0 after one clock cycle
            rf_pop <= 0;
        else if (reg_read && (apb_paddr[7:2] == `UART_REG_RB) && !dlab)
            rf_pop <= 1;  // advance read pointer
    end

    wire lsr_mask_condition;
    wire iir_read;
    wire msr_read;
    wire fifo_read;
    wire fifo_write;

    assign lsr_mask_condition = (reg_read && (apb_paddr[7:2] == `UART_REG_LS) && !dlab);
    assign iir_read = (reg_read && (apb_paddr[7:2] == `UART_REG_II) && !dlab);
    assign msr_read = (reg_read && (apb_paddr[7:2] == `UART_REG_MS) && !dlab);
    assign fifo_read = (reg_read && (apb_paddr[7:2] == `UART_REG_RB) && !dlab);
    assign fifo_write = (reg_write && (apb_paddr[7:2] == `UART_REG_TR) && !dlab);

    // lsr_mask_d delayed signal handling
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            lsr_mask_d <= 0;
        else  // reset bits in the Line Status Register
            lsr_mask_d <= lsr_mask_condition;
    end

    // lsr_mask is rise detected
    assign lsr_mask = lsr_mask_condition && ~lsr_mask_d;

    // msi_reset signal handling
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            msi_reset <= 1;
        else if (msi_reset)
            msi_reset <= 0;
        else if (msr_read)
            msi_reset <= 1;  // reset bits in Modem Status Register
    end


    //
    //   WRITES AND RESETS   //
    //
    // Line Control Register
    always @(posedge clk or negedge nreset)
        if (!nreset)
            lcr <= 8'b00000011;  // 8n1 setting
        else if (reg_write && (apb_paddr[7:2] == `UART_REG_LC))
            lcr <= apb_pwdata[7:0];

    // Interrupt Enable Register or UART_DL2
    always @(posedge clk or negedge nreset)
        if (!nreset) begin
            ier <= 4'b0000;  // no interrupts after reset
            dl[`UART_DL2] <= 8'b0;
        end
        else if (reg_write && (apb_paddr[7:2] == `UART_REG_IE))
            if (dlab) begin
                dl[`UART_DL2] <= apb_pwdata[7:0];
            end else
                ier <= apb_pwdata[3:0];  // ier uses only 4 lsb


    // FIFO Control Register and rx_reset, tx_reset signals
    always @(posedge clk or negedge nreset)
        if (!nreset) begin
            fcr <= 2'b11;
            rx_reset <= 0;
            tx_reset <= 0;
        end else if (reg_write && apb_paddr[7:2] == `UART_REG_FC) begin
            fcr <= apb_pwdata[7:6];
            rx_reset <= apb_pwdata[1];
            tx_reset <= apb_pwdata[2];
        end else begin
            rx_reset <= 0;
            tx_reset <= 0;
        end

    // Modem Control Register
    always @(posedge clk or negedge nreset)
        if (!nreset)
            mcr <= 5'b0;
        else if (reg_write && apb_paddr[7:2] == `UART_REG_MC)
            mcr <= apb_pwdata[4:0];

    // Scratch register
    // Line Control Register
    always @(posedge clk or negedge nreset)
        if (!nreset)
            scratch <= 0;  // 8n1 setting
        else if (reg_write && apb_paddr[7:2] == `UART_REG_SR)
            scratch <= apb_pwdata[7:0];

    // TX_FIFO or UART_DL1
    always @(posedge clk or negedge nreset)
        if (!nreset) begin
            dl[`UART_DL1] <= 8'b0;
            tf_push <= 1'b0;
            start_dlc <= 1'b0;
        end
        else if (reg_write && apb_paddr[7:2] == `UART_REG_TR)
            if (dlab) begin
                dl[`UART_DL1] <= apb_pwdata[7:0];
                start_dlc <= 1'b1;  // enable DL counter
                tf_push <= 1'b0;
            end
            else begin
                tf_push <= 1'b1;
                tf_data_in <= apb_pwdata[7:0];
                start_dlc <= 1'b0;
            end  // else: !if(dlab)
        else begin
            start_dlc <= 1'b0;
            tf_push <= 1'b0;
        end  // else: !if(dlab)

    // Receiver FIFO trigger level selection logic (asynchronous mux)
    always @(fcr)
        case (fcr[`UART_FC_TL])
            2'b00: trigger_level = 1;
            2'b01: trigger_level = 4;
            2'b10: trigger_level = 8;
            2'b11: trigger_level = 14;
        endcase  // case(fcr[`UART_FC_TL])

    //
    //  STATUS REGISTERS  //
    //

    // Modem Status Register
    reg [3:0] delayed_modem_signals;
    always @(posedge clk or negedge nreset) begin
        if (!nreset) begin
            msr <= 0;
            delayed_modem_signals[3:0] <= 0;
        end else begin
            msr[`UART_MS_DDCD:`UART_MS_DCTS] <= msi_reset ? 4'b0 :
                    msr[`UART_MS_DDCD:`UART_MS_DCTS] |
                    ({dcd, ri, dsr, cts} ^ delayed_modem_signals[3:0]);
            msr[`UART_MS_CDCD:`UART_MS_CCTS] <= {dcd_c, ri_c, dsr_c, cts_c};
            delayed_modem_signals[3:0] <= {dcd, ri, dsr, cts};
        end
    end


    // Line Status Register

    // activation conditions
    assign lsr0 = (rf_count == 0 && rf_push_pulse);  // data in receiver fifo available set condition
    assign lsr1 = rf_overrun;  // Receiver overrun error
    assign lsr2 = rf_data_out[1];  // parity error bit
    assign lsr3 = rf_data_out[0];  // framing error bit
    assign lsr4 = rf_data_out[2];  // break error in the character
    assign lsr5 = (tf_count == 5'b0 && thre_set_en);  // transmitter fifo is empty
    assign lsr6 = (tf_count == 5'b0 && thre_set_en &&
                   (tstate ==  /*`S_IDLE */ 0));  // transmitter empty
    assign lsr7 = rf_error_bit | rf_overrun;

    // lsr bits
    reg lsr0_d, lsr1_d, lsr2_d, lsr3_d, lsr4_d, lsr5_d, lsr6_d, lsr7_d;  // delayed

    always @(posedge clk or negedge nreset) begin
        if (!nreset) begin
            lsr0_d <= 0;
            lsr0r <= 0;
            lsr1_d <= 0;
            lsr1r <= 0;
            lsr2_d <= 0;
            lsr2r <= 0;
            lsr3_d <= 0;
            lsr3r <= 0;
            lsr4_d <= 0;
            lsr4r <= 0;
            lsr5_d <= 1;
            lsr5r <= 1;
            lsr6_d <= 1;
            lsr6r <= 1;
            lsr7_d <= 0;
            lsr7r <= 0;
        end
        else begin
            lsr0_d <= lsr0; // receiver data available
            lsr0r <=
                (rf_count == 1 && rf_pop && !rf_push_pulse || rx_reset) ? 0 :  // deassert condition
                lsr0r || (lsr0 && ~lsr0_d);  // set on rise of lsr0 and keep asserted until deasserted
            lsr1_d <= lsr1; // receiver overrun
            lsr1r <= lsr_mask ? 0 : lsr1r || (lsr1 && ~lsr1_d);  // set on rise
            lsr2_d <= lsr2; // parity error
            lsr2r <= lsr_mask ? 0 : lsr2r || (lsr2 && ~lsr2_d);
            lsr3_d <= lsr3; // framing error
            lsr3r <= lsr_mask ? 0 : lsr3r || (lsr3 && ~lsr3_d);
            lsr4_d <= lsr4; // break indicator
            lsr4r <= lsr_mask ? 0 : lsr4r || (lsr4 && ~lsr4_d);
            lsr5_d <= lsr5; // transmitter fifo is empty
            lsr5r <= fifo_write ? 0 : lsr5r || (lsr5 && ~lsr5_d);
            lsr6_d <= lsr6; // transmitter empty indicator
            lsr6r <= fifo_write ? 0 : lsr6r || (lsr6 && ~lsr6_d);
            lsr7_d <= lsr7; // error in fifo
            lsr7r <= lsr_mask ? 0 : lsr7r || (lsr7 && ~lsr7_d);
        end
    end

    // Frequency divider
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            dlc <= 0;
        else if (start_dlc | ~(|dlc))
            dlc <= dl - 1;  // preset counter
        else
            dlc <= dlc - 1;  // decrement counter
    end

    // Enable signal generation logic
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            enable <= 1'b0;
        else if (|dl & ~(|dlc))  // dl>0 & dlc==0
            enable <= 1'b1;
        else
            enable <= 1'b0;
    end

    // Delaying THRE status for one character cycle after a character is written to an empty fifo.
    always @(lcr)
        case (lcr[3:0])
            4'b0000: block_value = 95;  // 6 bits
            4'b0100: block_value = 103;  // 6.5 bits
            4'b0001, 4'b1000: block_value = 111;  // 7 bits
            4'b1100: block_value = 119;  // 7.5 bits
            4'b0010, 4'b0101, 4'b1001: block_value = 127;  // 8 bits
            4'b0011, 4'b0110, 4'b1010, 4'b1101: block_value = 143;  // 9 bits
            4'b0111, 4'b1011, 4'b1110: block_value = 159;  // 10 bits
            4'b1111: block_value = 175;  // 11 bits
        endcase  // case(lcr[3:0])

    // Counting time of one character minus stop bit
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            block_cnt <= 8'd0;
        else if (lsr5r & fifo_write)  // THRE bit set & write to fifo occurred
            block_cnt <= block_value;
        else if (enable & block_cnt != 8'b0)  // only work on enable times
            block_cnt <= block_cnt - 1;  // decrement break counter
    end  // always of break condition detection

    // Generating THRE status enable signal
    assign thre_set_en = ~(|block_cnt);


    //
    //	INTERRUPT LOGIC
    //

    assign rls_int = ier[`UART_IE_RLS] &&
        (lsr[`UART_LS_OE] || lsr[`UART_LS_PE] || lsr[`UART_LS_FE] || lsr[`UART_LS_BI]);
    assign rda_int = ier[`UART_IE_RDA] && (rf_count >= {1'b0, trigger_level});
    assign thre_int = ier[`UART_IE_THRE] && lsr[`UART_LS_TFE];
    assign ms_int = ier[`UART_IE_MS] && (|msr[3:0]);
    assign ti_int = ier[`UART_IE_RDA] && (counter_t == 10'b0) && (|rf_count);

    reg rls_int_d;
    reg thre_int_d;
    reg ms_int_d;
    reg ti_int_d;
    reg rda_int_d;

    // delay lines
    always @(posedge clk or negedge nreset) begin
        if (!nreset) begin
            rls_int_d <= 0;
            rda_int_d <= 0;
            ms_int_d <= 0;
            ti_int_d <= 0;
        end
        else begin
            rls_int_d <= rls_int;
            thre_int_d <= thre_int;
            ms_int_d <= ms_int;
            ti_int_d <= ti_int;
        end
    end

    // rise detection signals

    wire rls_int_rise;
    wire thre_int_rise;
    wire ms_int_rise;
    wire ti_int_rise;
    wire rda_int_rise;

    assign rda_int_rise = rda_int & ~rda_int_d;
    assign rls_int_rise = rls_int & ~rls_int_d;
    assign thre_int_rise = thre_int & ~thre_int_d;
    assign ms_int_rise = ms_int & ~ms_int_d;
    assign ti_int_rise = ti_int & ~ti_int_d;

    // interrupt pending flags
    reg rls_int_pnd;
    reg rda_int_pnd;
    reg thre_int_pnd;
    reg ms_int_pnd;
    reg ti_int_pnd;

    // interrupt pending flags assignments
    always @(posedge clk or negedge nreset) begin
        if (!nreset) begin
            rls_int_pnd <= 0;
            rda_int_pnd <= 0;
            thre_int_pnd <= 0;
            ms_int_pnd <= 0;
            ti_int_pnd <= 0;
        end
        else begin
            rls_int_pnd <=
                lsr_mask ? 0 :  // reset condition
                rls_int_rise ? 1 :  // latch condition
                rls_int_pnd && ier[`UART_IE_RLS];  // default operation: remove if masked
            rda_int_pnd <=
                ((rf_count == {1'b0, trigger_level}) && fifo_read) ? 0 :  // reset condition
                rda_int_rise ? 1 :  // latch condition
                rda_int_pnd && ier[`UART_IE_RDA];  // default operation: remove if masked
            thre_int_pnd <=
                fifo_write || (iir_read & ~iir[`UART_II_IP] & iir[`UART_II_II] == `UART_II_THRE) ? 0 :
                thre_int_rise ? 1 : thre_int_pnd && ier[`UART_IE_THRE];
            ms_int_pnd <= msr_read ? 0 : ms_int_rise ? 1 : ms_int_pnd && ier[`UART_IE_MS];
            ti_int_pnd <= fifo_read ? 0 : ti_int_rise ? 1 : ti_int_pnd && ier[`UART_IE_RDA];
        end
    end
    // end of pending flags

    // INT_O logic
    reg int_o;
    always @(posedge clk or negedge nreset) begin
        if (!nreset) int_o <= 1'b0;
        else
            int_o <= rls_int_pnd ? ~lsr_mask :
                    rda_int_pnd ? 1 :
                    ti_int_pnd ? ~fifo_read :
                    thre_int_pnd ? !(fifo_write & iir_read) :
                    ms_int_pnd ? ~msr_read : 0;  // if no interrupt are pending
    end
    assign irq = int_o;

    // Interrupt Identification register
    always @(posedge clk or negedge nreset) begin
        if (!nreset)
            iir <= 1;
        else if (rls_int_pnd) begin // interrupt is pending
            iir[`UART_II_II] <= `UART_II_RLS;  // set identification register to correct value
            iir[`UART_II_IP] <= 1'b0;  // and clear the IIR bit 0 (interrupt pending)
        end
        else if (rda_int) begin // the sequence of conditions determines priority of interrupt identification
            iir[`UART_II_II] <= `UART_II_RDA;
            iir[`UART_II_IP] <= 1'b0;
        end
        else if (ti_int_pnd) begin
            iir[`UART_II_II] <= `UART_II_TI;
            iir[`UART_II_IP] <= 1'b0;
        end
        else if (thre_int_pnd) begin
            iir[`UART_II_II] <= `UART_II_THRE;
            iir[`UART_II_IP] <= 1'b0;
        end
        else if (ms_int_pnd) begin
            iir[`UART_II_II] <= `UART_II_MS;
            iir[`UART_II_IP] <= 1'b0;
        end
        else begin // no interrupt is pending
            iir[`UART_II_II] <= 0;
            iir[`UART_II_IP] <= 1'b1;
        end
    end

endmodule
