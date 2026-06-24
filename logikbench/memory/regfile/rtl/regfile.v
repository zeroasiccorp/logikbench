module regfile
  # (parameter AW = 6,  // address with (regs = 2**AW)
     parameter DW = 32, // register width
     parameter RP = 2,  // # read ports
     parameter WP = 1   // # write prots
     )
   (// Single clock
    input              clk,
    // Write Ports (concatenated)
    input [WP-1:0]     wr_valid, // write access
    input [WP*AW-1:0]  wr_addr,  // register address
    input [WP*DW-1:0]  wr_data,  // write data
    // Read Ports (concatenated)
    input [RP-1:0]     rd_valid, // read access
    input [RP*AW-1:0]  rd_addr,  // register address
    output [RP*DW-1:0] rd_data   // output data
    );

   localparam REGS = (2**AW);

   reg [DW-1:0]        mem[REGS-1:0];

   integer 	       w;
   genvar 	       r;

   //#########################################
   // write ports
   //#########################################

   // Behavioral inferred memory so the tool maps it to a RAM resource
   // (distributed RAM/LUTRAM) instead of a discrete flop array. On a same
   // cycle write collision (two ports, same address) the highest-numbered
   // port wins.
   always @(posedge clk)
     for (w=0;w<WP;w=w+1)
       if (wr_valid[w])
	 mem[wr_addr[w*AW+:AW]] <= wr_data[w*DW+:DW];

   //#########################################
   // read ports
   //#########################################

   // Asynchronous (combinational) read, gated by rd_valid.
   for (r=0;r<RP;r=r+1) begin: gen_rdport
      assign rd_data[r*DW+:DW] = {(DW){rd_valid[r]}} &
				 mem[rd_addr[r*AW+:AW]];
   end

endmodule
