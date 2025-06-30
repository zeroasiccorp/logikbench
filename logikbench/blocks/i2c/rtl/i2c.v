/*******************************************************************************
 * Function:  Chipio APB I2C Controller
 * Author:    Wenting Zhang
 * Copyright: (c) 2023 Zero ASIC. All rights reserved.
 *
 * License: BSD
 *
 * This module is adapted from the OpenCores WISHBONE I2C master controller,
 * the original copyright information is included below.
 ******************************************************************************/

/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE revB.2 compliant I2C Master controller Top-level  ////
////                                                             ////
////                                                             ////
////  Author: Richard Herveille                                  ////
////          richard@asics.ws                                   ////
////          www.asics.ws                                       ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/projects/i2c/    ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Richard Herveille                        ////
////                    richard@asics.ws                         ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: i2c_master_top.v,v 1.12 2009-01-19 20:29:26 rherveille Exp $
//
//  $Date: 2009-01-19 20:29:26 $
//  $Revision: 1.12 $
//  $Author: rherveille $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               Revision 1.11  2005/02/27 09:26:24  rherveille
//               Fixed register overwrite issue.
//               Removed full_case pragma, replaced it by a default statement.
//
//               Revision 1.10  2003/09/01 10:34:38  rherveille
//               Fix a blocking vs. non-blocking error in the wb_dat output mux.
//
//               Revision 1.9  2003/01/09 16:44:45  rherveille
//               Fixed a bug in the Command Register declaration.
//
//               Revision 1.8  2002/12/26 16:05:12  rherveille
//               Small code simplifications
//
//               Revision 1.7  2002/12/26 15:02:32  rherveille
//               Core is now a Multimaster I2C controller
//
//               Revision 1.6  2002/11/30 22:24:40  rherveille
//               Cleaned up code
//
//               Revision 1.5  2001/11/10 10:52:55  rherveille
//               Changed PRER reset value from 0x0000 to 0xffff, conform specs.
//

`include "i2c_defines.vh"

module i2c #(
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
    // i2c interface
    input               scl_in,         // SCL-line input
    output              scl_out,        // SCL-line output (always 1'b0)
    output              scl_oe,         // SCL-line output enable (active high)
    input               sda_in,         // SDA-line input
    output              sda_out,        // SDA-line output (always 1'b0)
    output              sda_oe,         // SDA-line output enable (active high)
    // interrupt to core
    output reg          irq             // interrupt request signal output
);

    // parameters
    parameter [6:0] DEFAULT_SLAVE_ADDR = 7'b111_1110;

    //
    // variable declarations
    //

    // registers
    reg [15:0] prer;  // clock prescale register
    reg [7:0] ctr;  // control register
    reg [7:0] txr;  // transmit register
    wire [7:0] rxr;  // receive register
    reg [7:0] cr;  // command register
    wire [7:0] sr;  // status register
    reg [6:0] sladr;  // slave address register
    reg sync_rst;  // manually generate reset

    // done signal: command completed, clear command register
    wire done;
    wire slave_done;
    // core enable signal
    wire core_en;
    wire ien;
    wire slave_en;
    wire slave_dat_req;
    wire slave_dat_avail;

    // status register signals
    wire irxack;
    reg rxack;  // received acknowledge from slave
    reg tip;  // transfer in progress
    reg irq_flag;  // interrupt pending flag
    wire i2c_busy;  // bus busy (start signal detected)
    wire i2c_al;  // i2c bus arbitration lost
    reg al;  // status register arbitration lost bit
    reg slave_mode;
    //
    // module body
    //

    // bus interface
    assign apb_pslverr = 'b0;
    assign apb_pready = 1'b1; // always ready, no wait state

    // assign register read data
    wire reg_read = apb_psel & ~apb_penable & ~apb_pwrite;
    always @(posedge clk) begin
        if (reg_read) begin
            case (apb_paddr[7:2])
                `I2C_REG_PRERLO: apb_prdata <= {24'd0, prer[7:0]};
                `I2C_REG_PRERHI: apb_prdata <= {24'd0, prer[15:8]};
                `I2C_REG_CTR: apb_prdata <= {24'd0, ctr};
                `I2C_REG_DR: apb_prdata <= {24'd0, rxr};  // transmit register (txr)
                `I2C_REG_CMDSR: apb_prdata <= {24'd0, sr};  // command register (cr)
                `I2C_REG_DTXR: apb_prdata <= {24'd0, txr};  // Debug out of TXR
                `I2C_REG_DCR: apb_prdata <= {24'd0, cr};  // Debug out control reg
                `I2C_REG_SLADR: apb_prdata <= {24'd0, 1'b0, sladr};  // slave address
                default: apb_prdata <= 32'bx;
            endcase
        end
    end

    // register write
    wire reg_write = apb_psel & apb_penable & apb_pwrite;
    always @(posedge clk or negedge nreset)
        if (!nreset) begin
            prer <= 16'hffff;
            ctr <= 8'h0;
            txr <= 8'h0;
            sladr <= DEFAULT_SLAVE_ADDR;
            sync_rst <= 1'b0;
        end
        else if (sync_rst) begin
            prer <= 16'hffff;
            ctr <= 8'h0;
            txr <= 8'h0;
            sladr <= DEFAULT_SLAVE_ADDR;
            sync_rst <= 1'b0;
        end
        else if (reg_write)
            case (apb_paddr[7:2])
                `I2C_REG_PRERLO: prer[7:0] <= apb_pwdata[7:0];
                `I2C_REG_PRERHI: prer[15:8] <= apb_pwdata[7:0];
                `I2C_REG_CTR: ctr <= apb_pwdata[7:0];
                `I2C_REG_DR: txr <= apb_pwdata[7:0];
                `I2C_REG_SLADR: sladr <= apb_pwdata[6:0];
                `I2C_REG_RST: sync_rst <= apb_pwdata[0];
                default: ;
            endcase

    // generate command register (special case)
    always @(posedge clk or negedge nreset)
        if (!nreset)
            cr <= 8'h0;
        else if (sync_rst)
            cr <= 8'h0;
        else if (reg_write) begin
            if (core_en & (apb_paddr[7:2] == `I2C_REG_CMDSR))
                cr <= apb_pwdata[7:0];
        end
        else begin
            cr[1] <= 1'b0;
            if (done | i2c_al)
                cr[7:4] <= 4'h0;  // clear command bits when done
                                  // or when aribitration lost
            cr[2] <= 1'b0;  // reserved bits
            cr[0] <= 1'b0;  // clear IRQ_ACK bit
        end

    wire slave_act;

    // decode command register
    wire sta = cr[7];
    wire sto = cr[6];
    wire rd = cr[5];
    wire wr = cr[4];
    wire ack = cr[3];
    wire sl_cont = cr[1];
    wire iack = cr[0];

    // decode control register
    assign core_en = ctr[7];
    assign ien = ctr[6];
    assign slave_en = ctr[5];

    wire scl_oen, sda_oen;
    assign scl_oe = !scl_oen;
    assign sda_oe = !sda_oen;

    // hookup byte controller block
    i2c_byte_ctrl byte_controller (
        .clk            (clk),
        .my_addr        (sladr),
        .rst            (sync_rst),
        .nReset         (nreset),
        .ena            (core_en),
        .clk_cnt        (prer),
        .start          (sta),
        .stop           (sto),
        .read           (rd),
        .write          (wr),
        .ack_in         (ack),
        .din            (txr),
        .cmd_ack        (done),
        .ack_out        (irxack),
        .dout           (rxr),
        .i2c_busy       (i2c_busy),
        .i2c_al         (i2c_al),
        .scl_i          (scl_in),
        .scl_o          (scl_out),
        .scl_oen        (scl_oen),
        .sda_i          (sda_in),
        .sda_o          (sda_out),
        .sda_oen        (sda_oen),
        .sl_cont        (sl_cont),
        .slave_en       (slave_en),
        .slave_dat_req  (slave_dat_req),
        .slave_dat_avail(slave_dat_avail),
        .slave_act      (slave_act),
        .slave_cmd_ack  (slave_done)
    );

    // status register block + interrupt request signal
    always @(posedge clk or negedge nreset)
        if (!nreset) begin
            al <= 1'b0;
            rxack <= 1'b0;
            tip <= 1'b0;
            irq_flag <= 1'b0;
            slave_mode <= 1'b0;
        end
        else if (sync_rst) begin
            al <= 1'b0;
            rxack <= 1'b0;
            tip <= 1'b0;
            irq_flag <= 1'b0;
            slave_mode <= 1'b0;
        end
        else begin
            al <= i2c_al | (al & ~sta);
            rxack <= irxack;
            tip <= (rd | wr);
            // interrupt request flag is always generated
            irq_flag <= (done | slave_done | i2c_al | slave_dat_req |
                    slave_dat_avail | irq_flag) & ~iack;
            if (done)
                slave_mode <= slave_act;
        end

    // generate interrupt request signals
    always @(posedge clk or negedge nreset)
        if (!nreset)
            irq <= 1'b0;
        else if (sync_rst)
            irq <= 1'b0;
        else
            // interrupt signal is only generated when IEN (interrupt enable bit
            // is set)
            irq <= irq_flag && ien;

    // assign status register bits
    assign sr[7] = rxack;
    assign sr[6] = i2c_busy;
    assign sr[5] = al;
    assign sr[4] = slave_mode;  // reserved
    assign sr[3] = slave_dat_avail;
    assign sr[2] = slave_dat_req;
    assign sr[1] = tip;
    assign sr[0] = irq_flag;

endmodule
