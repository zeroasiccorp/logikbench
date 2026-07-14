//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Smoke testbench for mulc (signed complex multiplier, self-checking).
//
//#############################################################################
`timescale 1ns/1ps
module test_mulc_smoke;
   localparam DW=8, PW=2*DW;
   reg	      clk=0; reg [DW-1:0] are,aim,bre,bim;
   wire [PW-1:0] out_re,out_im;
   always #5 clk=~clk;
   mulc #(.DW(DW)) dut (.a_re(are),.a_im(aim),.b_re(bre),.b_im(bim),
                        .out_re(out_re),.out_im(out_im));
   integer t,errors;
   reg signed [DW-1:0] sar,sai,sbr,sbi; reg signed [PW-1:0] ere,eim;
   task chk; input [DW-1:0] ar,ai,br,bi; begin
      @(posedge clk); are<=ar; aim<=ai; bre<=br; bim<=bi;
      @(posedge clk); #1;
      sar=ar; sai=ai; sbr=br; sbi=bi;
      ere = sar*sbr - sai*sbi; eim = sar*sbi + sai*sbr;
      if(out_re!==ere || out_im!==eim) begin errors=errors+1;
         $display("FAIL: re got %h exp %h, im got %h exp %h",
                  out_re,ere,out_im,eim); end
   end endtask
   initial begin errors=0; are=0;aim=0;bre=0;bim=0;
      chk(8'h7f,8'h00,8'h7f,8'h00); chk(8'hff,8'hff,8'hff,8'hff);
      for(t=0;t<30;t=t+1) chk($random,$random,$random,$random);
      if(errors==0)$display("PASSED");else $display("FAILED (%0d errors)",errors);
      $finish; end

`ifdef WAVES
   initial begin
      $dumpfile("test_mulc_smoke.vcd");
      $dumpvars(0, test_mulc_smoke);
   end
`endif

endmodule
