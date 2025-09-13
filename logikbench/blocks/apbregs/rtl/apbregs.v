module apbdev
  #(parameter DW = 32, // reg data width
    parameter AW = 5   // reg address width
    )
   (input                    nreset,      // async active low
    input                    apb_pclk,    // apb clock
    input [AW-1:0]          apb_paddr,   // address bus
    input                    apb_penable, // goes high for cycle 2:n
    input                    apb_pwrite,  // 1=write, 0=read
    input [DW-1:0]           apb_pwdata,  // write data (8, 16, 32b)
    input [3:0]              apb_pstrb,   // (optional) wire strobe bytelanes
    input [2:0]              apb_pprot,   // (optional) level of access
    input                    apb_psel,    // select signal for each device
    output                   apb_pready,  // device "wait" signal
    output reg [DW-1:0]      apb_prdata,  // read data (8, 16, 32b)
    // ctrl outputs
    output [DW*(2**AW)-1:0] ctrl         // ctrl outputs
    );

   reg [DW-1:0] regs [(2**AW)-1:0];

   // apb interface
   assign reg_write    = apb_psel & apb_penable & apb_pwrite;
   assign reg_read     = apb_psel & ~apb_penable & ~apb_pwrite;
   assign apb_pready   = 1'b1;

   // register access
   always @(posedge apb_pclk) begin
      if (reg_write)
        regs[apb_paddr] <= apb_pwdata;
      apb_prdata <= regs[apb_paddr];
   end

   // flatten output vector
   genvar i;
   generate
      for (i = 0; i < 2**AW; i = i + 1) begin : flatten
         assign ctrl[i*DW +: DW] = regs[i];
      end
   endgenerate

endmodule
