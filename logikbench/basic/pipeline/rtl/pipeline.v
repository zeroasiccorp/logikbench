module pipeline #(parameter DW = 32, // data width
                  parameter N = 8    // pipeline stages
                  )
   (
    input           clk,
    input           en, // pipeline enable
    input [DW-1:0]  in, // data input
    output [DW-1:0] out // data output
    );

   reg [DW-1:0] pipeline_regs [0:N-1];

   integer      i;
   always @(posedge clk)
     if (en) begin
        pipeline_regs[0] <= in;
        for (i = 1; i < N; i = i + 1) begin
           pipeline_regs[i] <= pipeline_regs[i-1];
        end
     end
   assign out = pipeline_regs[N-1];

endmodule
