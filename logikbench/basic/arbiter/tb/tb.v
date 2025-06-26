`timescale 1ns / 1ps

module tb;

    parameter N = 4;

    reg  [N-1:0] request;
    wire [N-1:0] grant;

    integer i;
    integer expected_index;

    // Instantiate DUT
    arbiter #(N) dut (.request(request),
                      .grant(grant)
                      );


   function integer first_onehot_index;
        input [N-1:0] vec;
        integer k;
        begin
            first_onehot_index = -1;
            for (k = 0; k < N; k = k + 1) begin
                if (vec[k] == 1'b1 && first_onehot_index == -1)
                    first_onehot_index = k;
            end
        end
    endfunction

    initial begin
        $display("Starting arbiter test...");
        $display("Priority: request[0] is highest");

        // Try all request combinations (except 0)
        for (i = 1; i < (1 << N); i = i + 1) begin
            request = i;  // Try all 1..2^N-1 patterns
            #1;

            // Get expected priority winner
            expected_index = first_onehot_index(request);

            if (grant == (1 << expected_index)) begin
                $display("PASS: request = %b -> grant = %b", request, grant);
            end else begin
                $display("FAIL: request = %b -> grant = %b, expected = %b",
                         request, grant, (1 << expected_index));
            end
        end

        $display("Test complete.");
        $finish;
    end

endmodule
