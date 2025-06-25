module muxpri #(parameter DW = 32, // data width
                parameter N = 2    // number of inputs (power of 2)
                )
   (
    input [N-1:0]       sel,  // select signals
    input [N*DW-1:0]    data, // concatenated inputs
    output reg [DW-1:0] out,  // selected output
    output reg          hit   // >0 select signals was high
    );

   //
   integer i;
   always @* begin
      out = {DW{1'b0}};
      hit = 1'b0;
      for (i = 0; i < N; i = i + 1) begin
         if (sel[i] && ~hit) begin
            out = data[i*DW +: DW];
            hit = 1'b1;
         end
      end
   end
endmodule
