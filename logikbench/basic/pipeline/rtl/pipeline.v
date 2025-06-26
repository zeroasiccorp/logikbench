module pipeline #(parameter DW = 32, // data width
                  parameter N = 8    // pipeline stages
                  )
   (
    input           clk,
    input           nreset,    // async active low reset
    input           en,        // pipeline enable
    input           valid_in,  // valid input
    input [DW-1:0]  data_in,   // data input
    output          valid_out, // valid output
    output [DW-1:0] data_out   // data output
    );

   reg [DW-1:0] data_regs [0:N-1];
   reg [N-1:0]  valid_regs;

   integer      i,j;

   // valid pipeline (with async reset)
   always @(posedge clk or negedge nreset)
     if (~nreset)
       valid_regs <= 'b0;
     else if (en) begin
        valid_regs[0] <= valid_in;
        for (i = 1; i < N; i = i + 1)
          valid_regs[i] <= valid_regs[i-1];
     end

   // data pipeline, sample on valid
   always @(posedge clk)
     if (en) begin
        if(valid_in)
          data_regs[0] <= data_in;
        for (j = 1; j < N; j = j + 1)
          if(valid_regs[j-1])
            data_regs[j] <= data_regs[j-1];
     end

   // signal assignment
   assign data_out  = data_regs[N-1];
   assign valid_out = valid_regs[N-1];

endmodule
