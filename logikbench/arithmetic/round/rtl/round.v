module round #(parameter DW = 16,
               parameter FW = 8 // frection width (<DW)
               )
   (
    //Inputs
    input signed [DW-1:0] a,
    //Outputs
    output [DW-1:0]       out
    );

   wire [DW-FW-1:0] intval = a[DW-1:FW];
   wire [FW-1:0]    fraction = a[FW-1:0];
   wire             halfbit = fraction[FW-1];
   wire             oddint = intval[0];
   wire             tailset;
   wire             roundup;

   assign tailset = |fraction[FW-2:0];
   assign roundup = halfbit & (tailset | oddint);
   assign out = intval + roundup;

endmodule
