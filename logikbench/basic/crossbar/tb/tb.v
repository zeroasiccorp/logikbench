`timescale 1ns / 1ps

module tb;

    parameter DW = 8;
    parameter N  = 4;

    reg  [N*DW-1:0] din;
    reg  [N*N-1:0]  sel;
    wire [N*DW-1:0] dout;

    integer i, j;
    reg [DW-1:0] expected [0:N-1];

    // DUT instantiation
    crossbar #(DW, N) dut (
        .din(din),
        .sel(sel),
        .dout(dout)
    );

    initial begin
        $display("Starting crossbar test for DW=%0d, N=%0d", DW, N);

        // Initialize deterministic input data: din[0] = 0x10, din[1] = 0x11, etc.
        for (i = 0; i < N; i = i + 1)
            din[i*DW +: DW] = 8'h10 + i;

        // Sweep all valid one-hot select vectors for all output ports
        for (i = 0; i < N; i = i + 1) begin  // i = output port
            for (j = 0; j < N; j = j + 1) begin  // j = input port to select
                // Clear sel vector
                sel = 0;
                // Set one-hot for output port i to select input port j
                sel[i*N +: N] = 1 << j;

                // Wait for propagation
                #1;

                // Expected: output[i] = input[j]
                expected[i] = din[j*DW +: DW];

                // Check
                if (dout[i*DW +: DW] === expected[i]) begin
                    $display("PASS: dout[%0d] = 0x%02h (selected din[%0d] for sel=%02h)", i, dout[i*DW +: DW], j, sel);
                end else begin
                    $display("FAIL: dout[%0d] = 0x%02h, expected 0x%02h (sel[%0d] = input[%0d])",
                             i, dout[i*DW +: DW], expected[i], i, j);
                end
            end
        end

        $display("Test complete.");
        $finish;
    end

endmodule
