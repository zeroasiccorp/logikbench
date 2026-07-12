module riscv_bootrom (
    input [8:0] addr,
    output reg [63:0] dout
);

    always @(*) begin
        case (addr)
        9'd0: dout = 64'h0001e2b77c105073;
        9'd1: dout = 64'h0010041b3002a073;
        9'd2: dout = 64'hf140257301f41413;
        9'd3: dout = 64'h0105859300000597;
        9'd4: dout = 64'h0000001300040067;
        default: dout = 64'd0;
        endcase
    end

endmodule
