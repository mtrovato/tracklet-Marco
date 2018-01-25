`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 01:08:52 PM
// Design Name: 
// Module Name: Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_array #(
  parameter RAM_WIDTH = 12,                       // Specify RAM data width
  parameter RAM_DEPTH = 128,                     // Specify RAM depth (number of entries)
  parameter INIT_FILE = ""                       // Specify name/location of RAM initialization file if using one (leave blank if not)

) (
  input [clogb2(RAM_DEPTH)-1:0] addra, // Write address bus, width determined from RAM_DEPTH
  input [clogb2(RAM_DEPTH)-1:0] addrb, // Read address bus, width determined from RAM_DEPTH
  input [RAM_WIDTH-1:0] dina,          // RAM input data
  input clka,                          // Write clock
  input clkb,                          // Read clock
  input wea,                           // Write enable
  //input enb,                           // Read Enable, for additional power savings, disable when not in use
  input rstb,                          // Output reset (does not affect memory contents)
  input regceb,                        // Output register enable
  output [RAM_WIDTH-1:0] doutb         // RAM output data
);

  (* ram_style = "distributed" *) reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
  //reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_one
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = {RAM_WIDTH{1'b1}};
    end
  endgenerate

  always @(posedge clka)
    if (wea)
      BRAM[addra] <= dina; 
 
  assign doutb = BRAM[addrb];

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>1; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule
