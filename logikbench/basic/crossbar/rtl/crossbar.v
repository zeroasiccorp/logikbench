module crossbar #(parameter DW = 64,
                  parameter N = 16   // number of ports
                  )
   (
    input [N*DW-1:0]      din, // N DW-wide input words, concatenated
    input [N*N-1:0]       sel, // N N-wide one-hot selects, concatenated
    output reg [N*DW-1:0] dout // N DW-wide output words, concatenated
);

   integer i,j;

   reg [DW-1:0] din_array [0:N-1];
   reg [N-1:0]  sel_array [0:N-1];

   // unpack data for simplicity
   always @(*) begin
      for (i = 0; i < N; i = i + 1) begin
         din_array[i] = din[i*DW +: DW];
         sel_array[i] = sel[i*N +: N];
      end
   end

   // N output muxes with independent selects
   always @(*) begin
      for (i = 0; i < N; i = i + 1) begin
         dout[i*DW +: DW] = {DW{1'b0}};
         for (j = 0; j < N; j = j + 1)
           if (sel_array[i][j])
             dout[i*DW +: DW] = din_array[j];
      end
   end

endmodule
