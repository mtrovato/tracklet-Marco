`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 08:46:00 AM
// Design Name: 
// Module Name: TE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TrackletEngine #(parameter PHI_MEM = "z1p1L1L2.txt",
            parameter Z_MEM = "z1p1L1L2.txt",
            parameter BARREL = 1'b1
            )
    (
    input clk,
    input reset,
    input en_proc,
        
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in_innervmstubin,
    output [`MEM_SIZE+4:0] read_add_innervmstubin,
    input [18:0] innervmstubin,
    input [5:0] number_in_outervmstubin,
    output [`MEM_SIZE+4:0] read_add_outervmstubin,
    input [18:0] outervmstubin,
    
    output reg [11:0] stubpairout,
    output reg valid_data
    
    );

    reg [4:0] BX_pipe; // BX counter is used to read the appropriate address of VMStub memories
    reg first_clk_pipe; // First clock of the BX will reset the double-nested loop

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset

// Standard Init files    
    initial begin
       BX_pipe = 5'b11111;
    end
    
    always @(posedge clk) begin
       if (rst_pipe)
           BX_pipe <= 5'b11111;
       else begin
           if(start[0]) begin
               BX_pipe <= BX_pipe + 1'b1;
               first_clk_pipe <= 1'b1;
           end
           else begin
               first_clk_pipe <= 1'b0;
           end
       end
    end
    
    pipe_delay #(.STAGES(5), .WIDTH(2))
       done_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(start), .val_out(done));
    
    wire pre_valid_data;
    reg [5:0] behold; //6 Bit shift Register for pre_valid_data
    
  // Double nested loop
    // Delay outer stub 2 clk cycles
    reg [17:0] innervmstubin_hold1;
    reg [17:0] innervmstubin_hold2;
    wire [5:0] pre_read_add1;
    wire [5:0] pre_read_add2;
    
    assign read_add_innervmstubin = {BX_pipe,pre_read_add1[`MEM_SIZE-1:0]};
    assign read_add_outervmstubin = {BX_pipe,pre_read_add2[`MEM_SIZE-1:0]};
    
    double_loop TE_loop( // Loop over inner and outer vmstubs and produce the corresponding address into VMStub memories
        .clk(clk),
        .reset(first_clk_pipe),
        .number1in(number_in_innervmstubin),
        .number2in(number_in_outervmstubin),
        .readadd1(pre_read_add1),
        .readadd2(pre_read_add2),
        .valid(pre_valid_data) // Valid bit for allowed combinations
    );
      
    //////////////////////////////////////////////////////////////////////////////
    
    wire signed [3:0] delta_phi;
    wire signed [4:0] delta_r;
    wire signed [5:0]  delta_r_DISK;
    wire dout_phi;
    wire dout_z;
    wire signed [3:0] out_phi;
    wire signed [3:0] in_phi;   
    
    generate
    if(BARREL) begin
        wire signed [1:0] out_r;
        wire signed [1:0] in_r;       
        assign out_phi = {1'b0,outervmstubin[4:2]}; // Force phi to be positive from unsigned quantities
        assign in_phi = {1'b0,innervmstubin[4:2]};
        assign delta_phi =  out_phi - in_phi;
        assign out_r = outervmstubin[1:0];
        assign in_r = innervmstubin[1:0];      
        assign delta_r   = out_r - in_r;
        
        Memory #(
                .RAM_WIDTH(1),                       // Specify RAM data width
                .RAM_DEPTH(8192),                     // Specify RAM depth (number of entries)
                .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
                .INIT_FILE(PHI_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
              ) lookup_phi (
                .addra(13'b0),    // Write address bus, width determined from RAM_DEPTH
                .addrb({innervmstubin[18:16],outervmstubin[18:16],delta_phi,delta_r[2:0]}),    // Read address bus, width determined from RAM_DEPTH
                .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
                .clka(clk),      // Write clock
                .clkb(clk),      // Read clock
                .wea(1'b0),        // Write enable
                .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
                .rstb(rst_pipe),      // Output reset (does not affect memory contents)
                .regceb(1'b1),  // Output register enable
                .doutb(dout_phi)     // RAM output data, width determined from RAM_WIDTH
            );
    
    //Z Lookup Address = Inner Z, Outer Z, Inner R, Outer R.
        Memory #(
                .RAM_WIDTH(1),                       // Specify RAM data width
                .RAM_DEPTH(4096),                     // Specify RAM depth (number of entries)
                .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
                .INIT_FILE(Z_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
              ) lookup_z (
                .addra(12'b0),    // Write address bus, width determined from RAM_DEPTH
                .addrb({innervmstubin[8:5],outervmstubin[8:5],innervmstubin[1:0],outervmstubin[1:0]}),    // Read address bus, width determined from RAM_DEPTH
                .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
                .clka(clk),      // Write clock
                .clkb(clk),      // Read clock
                .wea(1'b0),        // Write enable
                .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
                .rstb(rst_pipe),      // Output reset (does not affect memory contents)
                .regceb(1'b1),  // Output register enable
                .doutb(dout_z)     // RAM output data, width determined from RAM_WIDTH
            );
    end
    else begin
        wire signed [5:0] out_r;
        wire signed [5:0] in_r;       
        assign out_phi = {1'b0,outervmstubin[7:5]}; // Force phi to be positive from unsigned quantities
        assign in_phi = {1'b0,innervmstubin[7:5]};
        assign delta_phi =  out_phi - in_phi;
        assign out_r = {1'b0,outervmstubin[4:0]};
        assign in_r = {1'b0,innervmstubin[4:0]};      
        assign delta_r_DISK   = out_r - in_r;
        
        Memory #(
                .RAM_WIDTH(1),                       // Specify RAM data width
                .RAM_DEPTH(16384),                     // Specify RAM depth (number of entries)
                .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
                .INIT_FILE(PHI_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
              ) lookup_phi (
                .addra(14'b0),    // Write address bus, width determined from RAM_DEPTH
                .addrb({innervmstubin[18:16],outervmstubin[18:16],delta_phi,delta_r_DISK[5:2]}),    // Read address bus, width determined from RAM_DEPTH
                .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
                .clka(clk),      // Write clock
                .clkb(clk),      // Read clock
                .wea(1'b0),        // Write enable
                .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
                .rstb(rst_pipe),      // Output reset (does not affect memory contents)
                .regceb(1'b1),  // Output register enable
                .doutb(dout_phi)     // RAM output data, width determined from RAM_WIDTH
            );
    
    //Z Lookup Address = Inner Z, Outer Z, Inner R, Outer R.
        Memory #(
                .RAM_WIDTH(1),                       // Specify RAM data width
                .RAM_DEPTH(16384),                     // Specify RAM depth (number of entries)
                .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
                .INIT_FILE(Z_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
              ) lookup_z (
                .addra(12'b0),    // Write address bus, width determined from RAM_DEPTH
                .addrb({innervmstubin[9:8],outervmstubin[9:8],innervmstubin[4:0],outervmstubin[4:0]}),    // Read address bus, width determined from RAM_DEPTH
                .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
                .clka(clk),      // Write clock
                .clkb(clk),      // Read clock
                .wea(1'b0),        // Write enable
                .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
                .rstb(rst_pipe),      // Output reset (does not affect memory contents)
                .regceb(1'b1),  // Output register enable
                .doutb(dout_z)     // RAM output data, width determined from RAM_WIDTH
            );
    end
    endgenerate
    
    reg [11:0] stubpair;
    reg [11:0] pre_stubpair;
    always @(posedge clk) begin
        behold[0] <= pre_valid_data;
        behold[5:1] <= behold[4:0];
        pre_stubpair <= {innervmstubin[15:10],outervmstubin[15:10]};  // Stubpair = Inner Addr,Outer Addr
        stubpair <= pre_stubpair; // The new memories have an extra clock
        if(dout_phi & dout_z) begin // If the stub pair passes selection from LUTs assign valid data 
            stubpairout <= stubpair;
            valid_data <= behold[2];
        end
        else begin
            stubpairout <= 12'hfff;   //Is this necessary?
            valid_data <= 1'b0;
        end
    end
    
endmodule
