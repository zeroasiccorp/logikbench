module prio #(parameter DW = 32) // data width
   (
    input [DW-1:0]      in,   // input vector
    output reg [DW-1:0] out,  // one hot output
    output reg          valid // input vector!=0
    );


   integer i;
   reg     found;

   always @(*) begin
      out   = {DW{1'b0}};
      valid = 0;
      found = 0;

      for (i = DW-1; i >= 0; i = i - 1) begin
         if (!found && in[i]) begin
            out[i] = 1'b1;
            valid  = 1;
            found  = 1;
         end
      end
   end

endmodule
