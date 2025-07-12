module mux #(parameter DW = 64,
             parameter N = 16   // number of inputs (power of 2)
             )
   (
    input [$clog2(N)-1:0] sel,  // binary select signal
    input [N*DW-1:0]      data, // concatenated inputs
    output [DW-1:0]       out   // selected output
    );

   assign out[DW-1:0] = data[sel*DW +: DW];

endmodule
