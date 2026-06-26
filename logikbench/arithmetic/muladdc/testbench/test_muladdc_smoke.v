//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for muladdc (signed complex multiply-add, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_muladdc_smoke;
   localparam DW=8, OW=24;
   reg	      clk=0; reg [DW-1:0] are,aim,bre,bim; reg [OW-1:0] cre,cim;
   wire [OW-1:0] out_re,out_im;
   always #5 clk=~clk;
   muladdc #(.DW(DW),.OW(OW)) dut
     (.a_re(are),.a_im(aim),.b_re(bre),.b_im(bim),.c_re(cre),.c_im(cim),
      .out_re(out_re),.out_im(out_im));
   integer t,errors;
   reg signed [DW-1:0] sar,sai,sbr,sbi; reg signed [OW-1:0] scr,sci,ere,eim;
   task chk; input [DW-1:0] ar,ai,br,bi; input [OW-1:0] cr,ci; begin
      @(posedge clk); are<=ar;aim<=ai;bre<=br;bim<=bi;cre<=cr;cim<=ci;
      @(posedge clk); #1;
      sar=ar;sai=ai;sbr=br;sbi=bi;scr=cr;sci=ci;
      ere = scr + (sar*sbr - sai*sbi); eim = sci + (sar*sbi + sai*sbr);
      if(out_re!==ere || out_im!==eim) begin errors=errors+1;
         $display("FAIL: re got %h exp %h, im got %h exp %h",
                  out_re,ere,out_im,eim); end
   end endtask
   initial begin errors=0; are=0;aim=0;bre=0;bim=0;cre=0;cim=0;
      chk(8'hff,8'h00,8'h02,8'h00,24'd0,24'd0);
      for(t=0;t<30;t=t+1) chk($random,$random,$random,$random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end
endmodule
