module apbdev
  #(parameter AW = 32, // architecture address width
    parameter RW = 32, // reg width
    parameter RAW = 5  // reg address width
    )
   (input               nreset,      // async active low
    input               apb_pclk,    // apb clock
    input [RAW-1:0]     apb_paddr,   // address bus
    input               apb_penable, // goes high for cycle 2:n
    input               apb_pwrite,  // 1=write, 0=read
    input [RW-1:0]      apb_pwdata,  // write data (8, 16, 32b)
    input [3:0]         apb_pstrb,   // (optional) wire strobe bytelanes
    input [2:0]         apb_pprot,   // (optional) level of access
    input               apb_psel,    // select signal for each device
    output              apb_pready,  // device "wait" signal
    output reg [RW-1:0] apb_prdata   // read data (8, 16, 32b)
    );

   reg [RW-1:0] regs [(2**RAW)-1:0];

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

endmodule
