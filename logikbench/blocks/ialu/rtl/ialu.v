module ialu
  #(parameter DW  = 64 // address width
    )
   (
    // DATA
    input [DW-1:0]  op_rs1,    //primary input operand
    input [DW-1:0]  op_rs2,    //secondary input operand
    output [DW-1:0] ia_result, //bpu result
    output          ia_zero,   // zero flag
    output          ia_carry,  // carry flag
    output          ia_neg,    // negative flag
    output          ia_over,   // negative flag
    // CONTROL
    input           clk,
    input           de_add,    // rd=rs1 + rs2
    input           de_sub,    // rd=rs1 - rs2
    input           de_sll,    // rd=rs1 << rs2
    input           de_srl,    // rd=rs1 >> rs2
    input           de_sra,    // rd=rs1 >>> rs2
    input           de_and,    // rd=rs1 & rs2
    input           de_or,     // rd=rs1 | rs2
    input           de_xor,    // rd=rs1 ^ rs2
    input           de_sltu,   // rd=1 if rs1<rs2, else rd=0
    input           de_slt,    // rd=1 if rs1<rs2, else rd=0
    input           de_sext    // addiw, addw, instr, etc
    );

   //local wires
   wire [DW-1:0]   op_a;
   wire [DW-1:0]   op_b;
   wire [DW-1:0]   op_b_inv;
   wire [2*DW-1:0] a_sext;
   wire [5:0]      shamt;
   wire [DW-1:0]   add_result;
   wire [DW-1:0]   add_carry;
   wire            add_carry_out;
   wire [DW-1:0]   slt_result;
   wire [DW-1:0]   asr_result;
   wire [DW-1:0]   lsl_result;
   wire [DW-1:0]   xor_result;
   wire [DW-1:0]   or_result;
   wire [DW-1:0]   and_result;
   wire [DW-1:0]   muxed_result;
   wire            arch16;
   wire            arch32;
   wire            arch64;
   wire            arch128;
   wire            op_a_sign;
   wire            op_b_sign;
   wire            add_cout;
   wire            add_over;
   wire            add_neg;
   wire            slt_flag;
   wire            ia_zero_lo;
   wire            ia_zero_hi;
   wire            sel_full;
   wire            sel_half;
   wire            sel_quarter;
   wire            asr_sign;
   wire            sel_sext;
   wire            sign_sext;
   wire            ia_zero_quarter;
   wire            ia_zero_half;
   wire            ia_zero_full;

   integer         i;




   // name reassign...
   assign op_a = op_rs1;
   assign op_b = op_rs2;

   //#############################
   // adder
   //############################

   //Size based sign selection
   assign op_a_sign = op_a[DW-1];

   assign op_b_sign = op_b[DW-1];

   //Sub operation
   assign op_b_inv[DW-1:0] = ({(DW){de_sub}} ^ op_b[DW-1:0]);

   assign {add_carry_out,add_result} =  op_a + op_b_inv + de_sub;

   //Adder Flags
   assign add_cout  = add_carry_out;


   assign add_neg  = add_result[DW-1];

   assign add_over = (~op_a_sign & ~(op_b_sign ^ de_sub) & add_neg) |
                     (op_a_sign  &  (op_b_sign ^ de_sub) & ~add_neg);


   //#############################
   // slt instruction
   //############################

   assign slt_flag   = de_slt ? (add_neg ^ add_over) : ~add_cout;

   assign slt_result = {{(DW-1){1'b0}},slt_flag};

   //#############################
   // Left Shifter
   //############################

   assign shamt[5:0] = de_sext ? {1'b0,op_b[4:0]} :
		       op_b[5:0];

   assign lsl_result[DW-1:0]= op_a[DW-1:0] << shamt[5:0];


   //#############################
   // Right Shifter
   //############################

   assign asr_sign = de_sext ? op_a[DW/2-1] :
		     op_a_sign;

   assign a_sext[2*DW-1:DW]   = {(DW){(asr_sign & de_sra)}};

   assign a_sext[DW-1:DW/2]   = de_sext ? {(DW/2){(asr_sign & de_sra)}} :
				op_a[DW-1:DW/2];

   assign a_sext[DW/2-1:0]    = op_a[DW/2-1:0];

   assign asr_result[DW-1:0]= a_sext[2*DW-1:0] >> shamt[5:0];

   //#############################
   // bit manipulation
   //############################

   assign xor_result[DW-1:0] = op_a[DW-1:0] ^ op_b[DW-1:0];

   assign and_result[DW-1:0] = op_a[DW-1:0] & op_b[DW-1:0];

   assign or_result[DW-1:0]  = op_a[DW-1:0] | op_b[DW-1:0];

   //#############################
   // result mux
   //############################

   assign muxed_result = (de_add        & add_result)  |
                         ((de_slt | de_sltu) & slt_result) |
                         ((de_srl | de_sra)  & asr_result) |
                         (de_sll        & lsl_result) |
                         (de_xor        & xor_result) |
                         (de_or         & or_result)  |
                         (de_and        & and_result);

   //sign extend 32b results for RV addiw type instructions
   assign sign_sext = muxed_result[DW/2-1];

   assign ia_result[DW/2-1:0]  = muxed_result[DW/2-1:0];

   assign ia_result[DW-1:DW/2] = de_sext ? {(DW/2){sign_sext}} :
				           muxed_result[DW-1:DW/2];

   //#############################
   // flags
   //############################

   assign ia_zero_full    = (~|ia_result[DW-1:DW/2])   & ia_zero_half;

   assign ia_zero =  ia_zero_full;

   assign ia_neg  =  ia_result[DW-1];

   assign ia_over    = de_add ? add_over : 1'b0;

   assign ia_carry   = de_add ? add_cout : 1'b0;


endmodule
