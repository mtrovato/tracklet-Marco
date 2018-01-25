`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 08:46:00 AM
// Design Name: 
// Module Name: DiskTrackletEngine
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


module DiskTrackletEngine #(parameter PHI_MEM = "/home/savvas/Desktop/TRACKLET/FIRM/DISKS/firmware/TrackletProject/SourceCode/LUT_TE_F1D5PHI3R2_F2D5PHI3R2_phi.dat",
            parameter X_MEM = "/home/savvas/Desktop/TRACKLET/FIRM/DISKS/firmware/TrackletProject/SourceCode/LUT_TE_F1D5PHI3R2_F2D5PHI3R2_z.dat",
            parameter BARREL = 1'b0
            )
    (
    input clk,
    input reset,
    input en_proc,
    // programming interface
    // inputs
    input wire io_clk,                    // programming clock
    input wire io_sel,                    // this module has been selected for an I/O operation
    input wire io_sync,                    // start the I/O operation
    input wire [15:0] io_addr,        // slave address, memory or register. Top 16 bits already consumed.
    input wire io_rd_en,                // this is a read operation
    input wire io_wr_en,                // this is a write operation
    input wire [31:0] io_wr_data,    // data to write for write operations
    // outputs
    output wire [31:0] io_rd_data,    // data returned for read operations
    output wire io_rd_ack,                // 'read' data from this module is ready
    //clocks
    input wire [2:0] BX,
    input wire first_clk,
    input wire not_first_clk,
    
    input [1:0]         start,
    output [1:0]        done,
    
    input [5:0]         number_in_innervmstubin,
    output [10:0]       read_add_innervmstubin,
  //  input [5:0]       read_add1,
    input [17:0]        innervmstubin,
    input [5:0]         number_in_outervmstubin,
    output [10:0]       read_add_outervmstubin,
    //input [5:0]       read_add2,        
    input [17:0]        outervmstubin,
   
    output reg [11:0]   stubpairout,
    output reg          valid_data
    
    );

    // no IPbus here yet
    assign io_rd_data[31:0] = 32'h00000000;
    assign io_rd_ack = 1'b0;
    
//    initial begin
//        read_add_innervmstubin = 11'hfff; //Inner Stub address
//        read_add_outervmstubin = 11'hfff; //Outer Stub Address
//    end
    reg [4:0] BX_pipe;
    reg first_clk_pipe;

    wire rst_pipe;
    assign rst_pipe = start[1];   // use the top bit of start as pipelined reset

// Standard Init files
// *******************************************    
    initial begin
       BX_pipe = 5'b11111;
    end
    
    always @(posedge clk) begin
       if (rst_pipe)
           BX_pipe <= 5'b11111;
       else begin
           if (start[0]) begin
                BX_pipe <= BX_pipe + 1'b1;
                first_clk_pipe <= 1'b1;
           end
           else begin
                first_clk_pipe <= 1'b0;
           end
       end
    end

    
    pipe_delay #(.STAGES(4), .WIDTH(2))
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
    
//    parameter [7:0] n_hold = 8'd3;  //Issue Done 5((0-3)+1) after Start
//    reg [n_hold:0] hold;
//    always @(posedge clk) begin
//        hold[0] <= start[0];
//        hold[n_hold:1] <= hold[n_hold-1:0];
//        done <= {0,hold[n_hold]};
//    end
// *******************************************    
   
    reg pre_valid_data;
    reg [4:0] behold; //5 Bit shift Register for pre_valid_data
    
// Double nested loop
  
// Delay outer stub 2 clk cycles-Not Needed.
//    reg [17:0] outervmstubin_hold1;
//    reg [17:0] outervmstubin_hold2;
    
    reg [5:0] pre_read_add1;
    reg [5:0] pre_read_add2;
    
    assign read_add_innervmstubin = {BX_pipe,pre_read_add1};
    assign read_add_outervmstubin = {BX_pipe,pre_read_add2};

    always @(posedge clk) begin  
    //Delay pre_valid_data 5 CLocks.  
    //Total of 5 between Start of data read, and valid data at output
        behold[0] <= pre_valid_data;
        behold[4:1] <= behold[3:0];
        
        if(first_clk_pipe) begin  //Reset Read_addresses If first clock
            pre_read_add1 <= 6'hff;
            pre_read_add2 <= 6'h00;
        end
        else begin  // Loop through all inner data, for each outer data
            if (pre_read_add1 + 1'b1 < number_in_innervmstubin) begin
                pre_read_add1 <= pre_read_add1 + 1'b1;
                pre_valid_data <= 1'b1;
            end
            else begin
                pre_read_add1 <= pre_read_add1;
                // if inner data is last, but outer data is not, increment outer.
                if (number_in_innervmstubin != 0 && pre_read_add1 + 1'b1 == number_in_innervmstubin && pre_read_add2 + 1'b1 < number_in_outervmstubin) begin
                    pre_read_add2 <= pre_read_add2 + 1'b1;
                    pre_valid_data <= 1'b1;
                end
                else begin
                    pre_read_add2 <= pre_read_add2;
                    pre_valid_data <= 1'b0;
                end
            end
        end
        //Delay Outer data 2 clocks.
//        outervmstubin_hold1 <= outervmstubin;
//        outervmstubin_hold2 <= outervmstubin_hold1;
    end
    
    //////////////////////////////////////////////////////////////////////////////
    
    wire [3:0] delta_phi;
    wire [3:0] delta_r;
    wire dout_phi;
    wire dout_z;

    
    if (BARREL) begin
//    assign delta_phi = outervmstubin_hold2[4:2] - innervmstubin[4:2];
//    assign delta_r   = outervmstubin_hold2[1:0] - innervmstubin[1:0];
    assign delta_phi = outervmstubin[4:2] - innervmstubin[4:2];
    assign delta_r   = outervmstubin[1:0] - innervmstubin[1:0];

//Phi Lookup Address = Inner PT,Outer PT, Delta Phi, Delta R
    Memory #(
            .RAM_WIDTH(1),                       // Specify RAM data width
            .RAM_DEPTH(8192),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(PHI_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
          ) lookup_phi (
            .addra(13'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb({innervmstubin[17:15],outervmstubin[17:15],delta_phi,delta_r[2:0]}),    // Read address bus, width determined from RAM_DEPTH
            .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(reset),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(dout_phi)     // RAM output data, width determined from RAM_WIDTH
        );

//Z Lookup Address = Inner Z, Outer Z, Inner R, Outer R.
    Memory #(
            .RAM_WIDTH(1),                       // Specify RAM data width
            .RAM_DEPTH(4096),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(X_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
          ) lookup_z (
            .addra(12'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb({innervmstubin[8:5],outervmstubin[8:5],innervmstubin[1:0],outervmstubin[1:0]}),    // Read address bus, width determined from RAM_DEPTH
            .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(reset),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(dout_z)     // RAM output data, width determined from RAM_WIDTH
        );

	end 
    else // !BARREL
     begin
//    assign delta_phi = outervmstubin_hold2[6:4] - innervmstubin[6:4];
//     assign delta_r   = outervmstubin_hold2[3:1] - innervmstubin[3:1];
     assign delta_phi = outervmstubin[7:5] - innervmstubin[7:5];
     assign delta_r  = outervmstubin[4:0] - innervmstubin[4:0];
    
//Phi Lookup Address = Inner PT,Outer PT, Delta Phi, Delta R
    Memory #(
            .RAM_WIDTH(1),                       // Specify RAM data width
            .RAM_DEPTH(16384),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(PHI_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
          ) lookup_phi (
            .addra(13'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb({innervmstubin[17:15],outervmstubin[17:15],delta_phi,delta_r}),    // Read address bus, width determined from RAM_DEPTH
            .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(reset),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(dout_phi)     // RAM output data, width determined from RAM_WIDTH
        );

//Z Lookup Address = Inner Z, Outer Z, Inner R, Outer R.
    Memory #(
            .RAM_WIDTH(1),                       // Specify RAM data width
            .RAM_DEPTH(4096),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(X_MEM)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
          ) lookup_z (
            .addra(12'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb({innervmstubin[8:7],outervmstubin[8:7],innervmstubin[3:0],outervmstubin[3:0]}),    // Read address bus, width determined from RAM_DEPTH
            .dina(1'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(reset),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(dout_z)     // RAM output data, width determined from RAM_WIDTH
        );
    end  
      
    reg [11:0] stubpair;
    reg [11:0] pre_stubpair;
    always @(posedge clk) begin
        pre_stubpair <= {innervmstubin[14:9],outervmstubin[14:9]};  // Stubpair = Inner Addr,Outer Addr
        stubpair <= pre_stubpair; // The new memories have an extra clock
        if(dout_phi & dout_z & innervmstubin != 0 & outervmstubin != 0) begin
            stubpairout <= stubpair;
            valid_data <= behold[2];
        end
        else begin
            stubpairout <= 12'hfff;   //Is this necessary?
            valid_data <= 1'b0;
        end
    end
    
endmodule
