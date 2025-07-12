module regfile
  # (parameter AW = 6,  // address with (regs = 2**AW)
     parameter RW = 32, // register width
     parameter RP = 2,  // # read ports
     parameter WP = 1   // # write prots
     )
   (// Single clock
    input              clk,
    // Write Ports (concatenated)
    input [WP-1:0]     wr_valid, // write access
    input [WP*AW-1:0]  wr_addr,  // register address
    input [WP*RW-1:0]  wr_data,  // write data
    // Read Ports (concatenated)
    input [RP-1:0]     rd_valid, // read access
    input [RP*AW-1:0]  rd_addr,  // register address
    output [RP*RW-1:0] rd_data   // output data
    );

   localparam REGS = (2**AW);

   reg [RW-1:0]        mem[REGS-1:0];
   wire [WP-1:0]       write_en [REGS-1:0];
   reg [RW-1:0]        mux [REGS-1:0];

   genvar 	       i,j;

   //#########################################
   // write ports
   //#########################################

   //One hot write enables
   for(i=0;i<REGS;i=i+1)
     begin: gen_regwrite
	for(j=0;j<WP;j=j+1)
	  begin: gen_wp
	     assign write_en[i][j] = wr_valid[j] & (wr_addr[j*AW+:AW] == i);
	  end
     end

   //Write-Port Mux
   for(i=0;i<REGS;i=i+1)
     begin: gen_wrmux
        integer k;
        always @*
          begin
	     mux[i] = 'b0;
	     for(k=0;k<WP;k=k+1)
	       mux[i] = mux[i] | ({(RW){write_en[i][k]}} &
                                  wr_data[((k+1)*RW-1)-:RW]);
          end
     end

   //Memory Array Write
   for(i=0;i<REGS;i=i+1)
     begin: gen_reg
	always @ (posedge clk)
	  if (|write_en[i][WP-1:0])
	    mem[i] <= mux[i];
     end


   //#########################################
   // read ports
   //#########################################

   for (i=0;i<RP;i=i+1) begin: gen_rdport
      assign rd_data[i*RW+:RW] = {(RW){rd_valid[i]}} &
				 mem[rd_addr[i*AW+:AW]];
   end

endmodule
