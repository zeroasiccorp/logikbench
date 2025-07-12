module arbiter #(parameter N = 16)
   (
    input [N-1:0]      request, // request inputs, [0] is highest priority
    output reg [N-1:0] grant    // one hot grant vector
    );

   integer i;
   reg     already_granted;

   always @(*) begin
      grant = {N{1'b0}};
      already_granted = 0;
      for (i = 0; i < N; i = i + 1) begin
         if (!already_granted && request[i]) begin
            grant[i] = 1'b1;
            already_granted = 1'b1;
         end
      end
   end

endmodule
