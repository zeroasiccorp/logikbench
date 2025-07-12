module shiftb #(parameter DW = 16
                )
   (
    input [DW-1:0]         a,     // Input data
    input [$clog2(DW)-1:0] b,     // Shift amount
    input                  dir,   // 0 = left, 1 = right
    input                  arith, // 0 = logical, 1 = arithmetic
    output [DW-1:0]        out    // Shifted result
    );

   wire [DW-1:0] right_result;
   wire [DW-1:0] left_result;
   wire signed [DW-1:0] a_signed = a;

   // Logical right shift
   assign right_result = (arith == 1'b0) ? (a >> b) :
                         // Arithmetic right shift (sign-extend)
                         $signed(a_signed >>> b);

   // Logical left shift (same for arithmetic)
   assign left_result = a << b;

   // Select direction
   assign out = (dir == 1'b1) ? right_result : left_result;

endmodule
