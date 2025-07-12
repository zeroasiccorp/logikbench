module bin2gray #(parameter DW = 64
                  )
   (
    input [DW-1:0]  in, // binary input
    output [DW-1:0] out // gray encoded output
    );
   assign out = in ^ (in >> 1);

endmodule
