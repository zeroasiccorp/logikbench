module ram1p1rwbe_64x128 (
    input  logic          CLK,
    input  logic          CEB,
    input  logic          WEB,
    input  logic [5:0]    A,
    input  logic [127:0]  D,
    input  logic [127:0]  BWEB,
    output logic [127:0]  Q
);
    la_spram #(.DW(128), .AW(6)) mem(
        .clk(CLK),
        .ce(CEB),
        .we(WEB),
        .wmask(BWEB),
        .addr(A),
        .din(D),
        .dout(Q),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule

module ram1p1rwbe_64x22 (
    input  logic          CLK,
    input  logic          CEB,
    input  logic          WEB,
    input  logic [5:0]    A,
    input  logic [21:0]  D,
    input  logic [21:0]  BWEB,
    output logic [21:0]  Q
);
    la_spram #(.DW(22), .AW(6)) mem(
        .clk(CLK),
        .ce(CEB),
        .we(WEB),
        .wmask(BWEB),
        .addr(A),
        .din(D),
        .dout(Q),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule

module ram1p1rwbe_64x44 (
    input  logic          CLK,
    input  logic          CEB,
    input  logic          WEB,
    input  logic [5:0]    A,
    input  logic [43:0]  D,
    input  logic [43:0]  BWEB,
    output logic [43:0]  Q
);
    la_spram #(.DW(44), .AW(6)) mem(
        .clk(CLK),
        .ce(CEB),
        .we(WEB),
        .wmask(BWEB),
        .addr(A),
        .din(D),
        .dout(Q),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule


module ram2p1r1wbe_1024x36 (
    input  logic          CLKA,
    input  logic          CLKB,
    input  logic          CEBA,
    input  logic          CEBB,
    input  logic          WEBA,
    input  logic          WEBB,
    input  logic [9:0]    AA,
    input  logic [9:0]    AB,
    input  logic [35:0]   DA,
    input  logic [35:0]   DB,
    input  logic [35:0]   BWEBA,
    input  logic [35:0]   BWEBB,
    output logic [35:0]   QA,
    output logic [35:0]   QB
);
    la_spram #(.DW(36), .AW(10)) memA (
        .clk(CLKA),
        .ce(CEBA),
        .we(WEBA),
        .wmask(BWEBA),
        .addr(AA),
        .din(DA),
        .dout(QA),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
    la_spram #(.DW(36), .AW(10)) memB (
        .clk(CLKB),
        .ce(CEBB),
        .we(WEBB),
        .wmask(BWEBB),
        .addr(AB),
        .din(DB),
        .dout(QB),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule

module ram2p1r1wbe_1024x68 (
    input  logic          CLKA,
    input  logic          CLKB,
    input  logic          CEBA,
    input  logic          CEBB,
    input  logic          WEBA,
    input  logic          WEBB,
    input  logic [9:0]    AA,
    input  logic [9:0]    AB,
    input  logic [67:0]   DA,
    input  logic [67:0]   DB,
    input  logic [67:0]   BWEBA,
    input  logic [67:0]   BWEBB,
    output logic [67:0]   QA,
    output logic [67:0]   QB
);
    la_spram #(.DW(68), .AW(10)) memA (
        .clk(CLKA),
        .ce(CEBA),
        .we(WEBA),
        .wmask(BWEBA),
        .addr(AA),
        .din(DA),
        .dout(QA),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
    la_spram #(.DW(68), .AW(10)) memB (
        .clk(CLKB),
        .ce(CEBB),
        .we(WEBB),
        .wmask(BWEBB),
        .addr(AB),
        .din(DB),
        .dout(QB),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule

module ram2p1r1wbe_128x64 (
    input  logic          CLKA,
    input  logic          CLKB,
    input  logic          CEBA,
    input  logic          CEBB,
    input  logic          WEBA,
    input  logic          WEBB,
    input  logic [6:0]    AA,
    input  logic [6:0]    AB,
    input  logic [63:0]   DA,
    input  logic [63:0]   DB,
    input  logic [63:0]   BWEBA,
    input  logic [63:0]   BWEBB,
    output logic [63:0]   QA,
    output logic [63:0]   QB
);
    la_spram #(.DW(64), .AW(7)) memA (
        .clk(CLKA),
        .ce(CEBA),
        .we(WEBA),
        .wmask(BWEBA),
        .addr(AA),
        .din(DA),
        .dout(QA),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
    la_spram #(.DW(64), .AW(7)) memB (
        .clk(CLKB),
        .ce(CEBB),
        .we(WEBB),
        .wmask(BWEBB),
        .addr(AB),
        .din(DB),
        .dout(QB),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule

module ram2p1r1wbe_2048x64 (
    input  logic          CLKA,
    input  logic          CLKB,
    input  logic          CEBA,
    input  logic          CEBB,
    input  logic          WEBA,
    input  logic          WEBB,
    input  logic [8:0]    AA,
    input  logic [8:0]    AB,
    input  logic [63:0]   DA,
    input  logic [63:0]   DB,
    input  logic [63:0]   BWEBA,
    input  logic [63:0]   BWEBB,
    output logic [63:0]   QA,
    output logic [63:0]   QB
);
    la_spram #(.DW(64), .AW(9)) memA (
        .clk(CLKA),
        .ce(CEBA),
        .we(WEBA),
        .wmask(BWEBA),
        .addr(AA),
        .din(DA),
        .dout(QA),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
    la_spram #(.DW(64), .AW(9)) memB (
        .clk(CLKB),
        .ce(CEBB),
        .we(WEBB),
        .wmask(BWEBB),
        .addr(AB),
        .din(DB),
        .dout(QB),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule

module ram2p1r1wbe_64x32 (
    input  logic          CLKA,
    input  logic          CLKB,
    input  logic          CEBA,
    input  logic          CEBB,
    input  logic          WEBA,
    input  logic          WEBB,
    input  logic [5:0]    AA,
    input  logic [5:0]    AB,
    input  logic [31:0]   DA,
    input  logic [31:0]   DB,
    input  logic [31:0]   BWEBA,
    input  logic [31:0]   BWEBB,
    output logic [31:0]   QA,
    output logic [31:0]   QB
);
    la_spram #(.DW(32), .AW(6)) memA (
        .clk(CLKA),
        .ce(CEBA),
        .we(WEBA),
        .wmask(BWEBA),
        .addr(AA),
        .din(DA),
        .dout(QA),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
    la_spram #(.DW(32), .AW(6)) memB (
        .clk(CLKB),
        .ce(CEBB),
        .we(WEBB),
        .wmask(BWEBB),
        .addr(AB),
        .din(DB),
        .dout(QB),
        .selctrl(1'b0),
        .ctrl('b0),
        .status()
    );
endmodule
