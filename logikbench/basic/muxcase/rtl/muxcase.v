module muxcase #(parameter DW = 8 // data width
                 )
   (
    input [7:0]         sel, // binary select signal
    input [8*DW-1:0]    in,  // concatenated inputs
    output reg [DW-1:0] out  // selected output
    );

   always @(*) begin
    case (sel)
      8'b0000_0001: out = in[DW*0+:DW];
      8'b0000_0010: out = in[DW*1+:DW];
      8'b0000_0100: out = in[DW*2+:DW];
      8'b0000_1000: out = in[DW*3+:DW];
      8'b0001_0000: out = in[DW*4+:DW];
      8'b0010_0000: out = in[DW*5+:DW];
      8'b0100_0000: out = in[DW*6+:DW];
      8'b1000_0000: out = in[DW*7+:DW];
      default: out = {DW{1'b0}};
    endcase
end

endmodule
