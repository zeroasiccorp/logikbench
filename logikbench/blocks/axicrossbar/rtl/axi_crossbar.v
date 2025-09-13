/*

Copyright (c) 2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4 crossbar
 */
module axi_crossbar #
(
    // Number of AXI inputs (slave interfaces)
    parameter NS = 4,
    // Number of AXI outputs (master interfaces)
    parameter NM = 4,
    // Width of data bus in bits
    parameter DW = 32,
    // Width of address bus in bits
    parameter AW = 32,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DW/8),
    // Input ID field width (from AXI masters)
    parameter S_ID_WIDTH = 8,
    // Output ID field width (towards AXI slaves)
    // Additional bits required for response routing
    parameter M_ID_WIDTH = S_ID_WIDTH+$clog2(NS),
    // Propagate awuser signal
    parameter AWUSER_ENABLE = 0,
    // Width of awuser signal
    parameter AWUSER_WIDTH = 1,
    // Propagate wuser signal
    parameter WUSER_ENABLE = 0,
    // Width of wuser signal
    parameter WUSER_WIDTH = 1,
    // Propagate buser signal
    parameter BUSER_ENABLE = 0,
    // Width of buser signal
    parameter BUSER_WIDTH = 1,
    // Propagate aruser signal
    parameter ARUSER_ENABLE = 0,
    // Width of aruser signal
    parameter ARUSER_WIDTH = 1,
    // Propagate ruser signal
    parameter RUSER_ENABLE = 0,
    // Width of ruser signal
    parameter RUSER_WIDTH = 1,
    // Number of concurrent unique IDs for each slave interface
    // NS concatenated fields of 32 bits
    parameter S_THREADS = {NS{32'd2}},
    // Number of concurrent operations for each slave interface
    // NS concatenated fields of 32 bits
    parameter S_ACCEPT = {NS{32'd16}},
    // Number of regions per master interface
    parameter M_REGIONS = 1,
    // Master interface base addresses
    // NM concatenated fields of M_REGIONS concatenated fields of ADDR_WIDTH bits
    // set to zero for default addressing based on M_ADDR_WIDTH
    parameter M_BASE_ADDR = 0,
    // Master interface address widths
    // NM concatenated fields of M_REGIONS concatenated fields of 32 bits
    parameter M_ADDR_WIDTH = {NM{{M_REGIONS{32'd24}}}},
    // Read connections between interfaces
    // NM concatenated fields of NS bits
    parameter M_CONNECT_READ = {NM{{NS{1'b1}}}},
    // Write connections between interfaces
    // NM concatenated fields of NS bits
    parameter M_CONNECT_WRITE = {NM{{NS{1'b1}}}},
    // Number of concurrent operations for each master interface
    // NM concatenated fields of 32 bits
    parameter M_ISSUE = {NM{32'd4}},
    // Secure master (fail operations based on awprot/arprot)
    // NM bits
    parameter M_SECURE = {NM{1'b0}},
    // Slave interface AW channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S_AW_REG_TYPE = {NS{2'd0}},
    // Slave interface W channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S_W_REG_TYPE = {NS{2'd0}},
    // Slave interface B channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S_B_REG_TYPE = {NS{2'd1}},
    // Slave interface AR channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S_AR_REG_TYPE = {NS{2'd0}},
    // Slave interface R channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S_R_REG_TYPE = {NS{2'd2}},
    // Master interface AW channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M_AW_REG_TYPE = {NM{2'd1}},
    // Master interface W channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M_W_REG_TYPE = {NM{2'd2}},
    // Master interface B channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M_B_REG_TYPE = {NM{2'd0}},
    // Master interface AR channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M_AR_REG_TYPE = {NM{2'd1}},
    // Master interface R channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M_R_REG_TYPE = {NM{2'd0}}
)
(
    input  wire                             clk,
    input  wire                             rst,

    /*
     * AXI slave interfaces
     */
    input  wire [NS*S_ID_WIDTH-1:0]    s_axi_awid,
    input  wire [NS*AW-1:0]    s_axi_awaddr,
    input  wire [NS*8-1:0]             s_axi_awlen,
    input  wire [NS*3-1:0]             s_axi_awsize,
    input  wire [NS*2-1:0]             s_axi_awburst,
    input  wire [NS-1:0]               s_axi_awlock,
    input  wire [NS*4-1:0]             s_axi_awcache,
    input  wire [NS*3-1:0]             s_axi_awprot,
    input  wire [NS*4-1:0]             s_axi_awqos,
    input  wire [NS*AWUSER_WIDTH-1:0]  s_axi_awuser,
    input  wire [NS-1:0]               s_axi_awvalid,
    output wire [NS-1:0]               s_axi_awready,
    input  wire [NS*DW-1:0]    s_axi_wdata,
    input  wire [NS*STRB_WIDTH-1:0]    s_axi_wstrb,
    input  wire [NS-1:0]               s_axi_wlast,
    input  wire [NS*WUSER_WIDTH-1:0]   s_axi_wuser,
    input  wire [NS-1:0]               s_axi_wvalid,
    output wire [NS-1:0]               s_axi_wready,
    output wire [NS*S_ID_WIDTH-1:0]    s_axi_bid,
    output wire [NS*2-1:0]             s_axi_bresp,
    output wire [NS*BUSER_WIDTH-1:0]   s_axi_buser,
    output wire [NS-1:0]               s_axi_bvalid,
    input  wire [NS-1:0]               s_axi_bready,
    input  wire [NS*S_ID_WIDTH-1:0]    s_axi_arid,
    input  wire [NS*AW-1:0]    s_axi_araddr,
    input  wire [NS*8-1:0]             s_axi_arlen,
    input  wire [NS*3-1:0]             s_axi_arsize,
    input  wire [NS*2-1:0]             s_axi_arburst,
    input  wire [NS-1:0]               s_axi_arlock,
    input  wire [NS*4-1:0]             s_axi_arcache,
    input  wire [NS*3-1:0]             s_axi_arprot,
    input  wire [NS*4-1:0]             s_axi_arqos,
    input  wire [NS*ARUSER_WIDTH-1:0]  s_axi_aruser,
    input  wire [NS-1:0]               s_axi_arvalid,
    output wire [NS-1:0]               s_axi_arready,
    output wire [NS*S_ID_WIDTH-1:0]    s_axi_rid,
    output wire [NS*DW-1:0]    s_axi_rdata,
    output wire [NS*2-1:0]             s_axi_rresp,
    output wire [NS-1:0]               s_axi_rlast,
    output wire [NS*RUSER_WIDTH-1:0]   s_axi_ruser,
    output wire [NS-1:0]               s_axi_rvalid,
    input  wire [NS-1:0]               s_axi_rready,

    /*
     * AXI master interfaces
     */
    output wire [NM*M_ID_WIDTH-1:0]    m_axi_awid,
    output wire [NM*AW-1:0]    m_axi_awaddr,
    output wire [NM*8-1:0]             m_axi_awlen,
    output wire [NM*3-1:0]             m_axi_awsize,
    output wire [NM*2-1:0]             m_axi_awburst,
    output wire [NM-1:0]               m_axi_awlock,
    output wire [NM*4-1:0]             m_axi_awcache,
    output wire [NM*3-1:0]             m_axi_awprot,
    output wire [NM*4-1:0]             m_axi_awqos,
    output wire [NM*4-1:0]             m_axi_awregion,
    output wire [NM*AWUSER_WIDTH-1:0]  m_axi_awuser,
    output wire [NM-1:0]               m_axi_awvalid,
    input  wire [NM-1:0]               m_axi_awready,
    output wire [NM*DW-1:0]    m_axi_wdata,
    output wire [NM*STRB_WIDTH-1:0]    m_axi_wstrb,
    output wire [NM-1:0]               m_axi_wlast,
    output wire [NM*WUSER_WIDTH-1:0]   m_axi_wuser,
    output wire [NM-1:0]               m_axi_wvalid,
    input  wire [NM-1:0]               m_axi_wready,
    input  wire [NM*M_ID_WIDTH-1:0]    m_axi_bid,
    input  wire [NM*2-1:0]             m_axi_bresp,
    input  wire [NM*BUSER_WIDTH-1:0]   m_axi_buser,
    input  wire [NM-1:0]               m_axi_bvalid,
    output wire [NM-1:0]               m_axi_bready,
    output wire [NM*M_ID_WIDTH-1:0]    m_axi_arid,
    output wire [NM*AW-1:0]    m_axi_araddr,
    output wire [NM*8-1:0]             m_axi_arlen,
    output wire [NM*3-1:0]             m_axi_arsize,
    output wire [NM*2-1:0]             m_axi_arburst,
    output wire [NM-1:0]               m_axi_arlock,
    output wire [NM*4-1:0]             m_axi_arcache,
    output wire [NM*3-1:0]             m_axi_arprot,
    output wire [NM*4-1:0]             m_axi_arqos,
    output wire [NM*4-1:0]             m_axi_arregion,
    output wire [NM*ARUSER_WIDTH-1:0]  m_axi_aruser,
    output wire [NM-1:0]               m_axi_arvalid,
    input  wire [NM-1:0]               m_axi_arready,
    input  wire [NM*M_ID_WIDTH-1:0]    m_axi_rid,
    input  wire [NM*DW-1:0]    m_axi_rdata,
    input  wire [NM*2-1:0]             m_axi_rresp,
    input  wire [NM-1:0]               m_axi_rlast,
    input  wire [NM*RUSER_WIDTH-1:0]   m_axi_ruser,
    input  wire [NM-1:0]               m_axi_rvalid,
    output wire [NM-1:0]               m_axi_rready
);

axi_crossbar_wr #(
    .S_COUNT(NS),
    .M_COUNT(NM),
    .DATA_WIDTH(DW),
    .ADDR_WIDTH(AW),
    .STRB_WIDTH(STRB_WIDTH),
    .S_ID_WIDTH(S_ID_WIDTH),
    .M_ID_WIDTH(M_ID_WIDTH),
    .AWUSER_ENABLE(AWUSER_ENABLE),
    .AWUSER_WIDTH(AWUSER_WIDTH),
    .WUSER_ENABLE(WUSER_ENABLE),
    .WUSER_WIDTH(WUSER_WIDTH),
    .BUSER_ENABLE(BUSER_ENABLE),
    .BUSER_WIDTH(BUSER_WIDTH),
    .S_THREADS(S_THREADS),
    .S_ACCEPT(S_ACCEPT),
    .M_REGIONS(M_REGIONS),
    .M_BASE_ADDR(M_BASE_ADDR),
    .M_ADDR_WIDTH(M_ADDR_WIDTH),
    .M_CONNECT(M_CONNECT_WRITE),
    .M_ISSUE(M_ISSUE),
    .M_SECURE(M_SECURE),
    .S_AW_REG_TYPE(S_AW_REG_TYPE),
    .S_W_REG_TYPE (S_W_REG_TYPE),
    .S_B_REG_TYPE (S_B_REG_TYPE)
)
axi_crossbar_wr_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI slave interfaces
     */
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awlock(s_axi_awlock),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awqos(s_axi_awqos),
    .s_axi_awuser(s_axi_awuser),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wuser(s_axi_wuser),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bid(s_axi_bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_buser(s_axi_buser),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),

    /*
     * AXI master interfaces
     */
    .m_axi_awid(m_axi_awid),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_awlock(m_axi_awlock),
    .m_axi_awcache(m_axi_awcache),
    .m_axi_awprot(m_axi_awprot),
    .m_axi_awqos(m_axi_awqos),
    .m_axi_awregion(m_axi_awregion),
    .m_axi_awuser(m_axi_awuser),
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_wuser(m_axi_wuser),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_bid(m_axi_bid),
    .m_axi_bresp(m_axi_bresp),
    .m_axi_buser(m_axi_buser),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready)
);

axi_crossbar_rd #(
    .S_COUNT(NS),
    .M_COUNT(NM),
    .DATA_WIDTH(DW),
    .ADDR_WIDTH(AW),
    .STRB_WIDTH(STRB_WIDTH),
    .S_ID_WIDTH(S_ID_WIDTH),
    .M_ID_WIDTH(M_ID_WIDTH),
    .ARUSER_ENABLE(ARUSER_ENABLE),
    .ARUSER_WIDTH(ARUSER_WIDTH),
    .RUSER_ENABLE(RUSER_ENABLE),
    .RUSER_WIDTH(RUSER_WIDTH),
    .S_THREADS(S_THREADS),
    .S_ACCEPT(S_ACCEPT),
    .M_REGIONS(M_REGIONS),
    .M_BASE_ADDR(M_BASE_ADDR),
    .M_ADDR_WIDTH(M_ADDR_WIDTH),
    .M_CONNECT(M_CONNECT_READ),
    .M_ISSUE(M_ISSUE),
    .M_SECURE(M_SECURE),
    .S_AR_REG_TYPE(S_AR_REG_TYPE),
    .S_R_REG_TYPE (S_R_REG_TYPE)
)
axi_crossbar_rd_inst (
    .clk(clk),
    .rst(rst),

    /*
     * AXI slave interfaces
     */
    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlock(s_axi_arlock),
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arqos(s_axi_arqos),
    .s_axi_aruser(s_axi_aruser),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rlast(s_axi_rlast),
    .s_axi_ruser(s_axi_ruser),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),

    /*
     * AXI master interfaces
     */
    .m_axi_arid(m_axi_arid),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arlock(m_axi_arlock),
    .m_axi_arcache(m_axi_arcache),
    .m_axi_arprot(m_axi_arprot),
    .m_axi_arqos(m_axi_arqos),
    .m_axi_arregion(m_axi_arregion),
    .m_axi_aruser(m_axi_aruser),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),
    .m_axi_ruser(m_axi_ruser),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready)
);

endmodule

`resetall
