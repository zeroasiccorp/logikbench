module csa42 #(parameter DW = 16
	       )
   (input [DW-1:0]  in0,  // input
    input [DW-1:0]  in1,  // input
    input [DW-1:0]  in2,  // input
    input [DW-1:0]  in3,  // input
    input           cin,  // intra stage carry in
    output          cout, // intra stage carry out (2x sum)
    output [DW-1:0] s,    // sum
    output [DW-1:0] c     // carry (=2x sum)
    );

   // local wires
   wire [DW-1:0]     sum_int;
   wire [DW:0]       carry_int;

   // csa for in0,in1,in2
   assign sum_int[DW-1:0] = in0[DW-1:0] ^ in1[DW-1:0] ^ in2[DW-1:0];

   assign carry_int[0] = cin;
   assign carry_int[DW:1] = (in0[DW-1:0] & in1[DW-1:0]) |
		            (in1[DW-1:0] & in2[DW-1:0]) |
		            (in2[DW-1:0] & in0[DW-1:0] );

   // combin with in3 (fast input)
   assign s[DW-1:0] = in3[DW-1:0] ^ sum_int[DW-1:0] ^ carry_int[DW-1:0];

   assign c[DW-1:0] = (in3[DW-1:0] & sum_int[DW-1:0]) |
		      (sum_int[DW-1:0] & carry_int[DW-1:0]) |
		      (carry_int[DW-1:0] & in3[DW-1:0] );

   assign cout = carry_int[DW];

endmodule
