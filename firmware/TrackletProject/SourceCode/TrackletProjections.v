`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 01:49:03 PM
// Design Name: 
// Module Name: TrackProj
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


module TrackletProjections(
    input clk,
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    
    input [53:0] data_in,
    input enable,
    
    output [5:0] number_out,
    input [`MEM_SIZE+3:0] read_add,
    output reg [53:0] data_out
    );
    
    parameter neighbor=1'b0;
    
    pipe_delay #(.STAGES(`tmux), .WIDTH(2))
               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done));
    
    reg [53:0] data_in_dly;
    reg [`MEM_SIZE:0] wr_add;
    reg wr_en;
    
    reg [3:0] BX_pipe;
    reg [3:0] rd_BX_pipe;
    reg first_clk_pipe;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
        
    initial begin
       BX_pipe = 4'b1111;
       rd_BX_pipe = 4'b1111;
       data_in_dly = 54'h0;
    end
    
    always @(posedge clk) begin
       if(rst_pipe) begin
           BX_pipe <= 4'b1111;
           rd_BX_pipe <= 4'b1111;
           //data_in_dly <= 54'h0;
       end
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
    
    wire [53:0] pre_data_out;
    reg [5:0] pre_number_out;
    reg wr_en_hold;
    
    always @(posedge clk) begin
        if(data_in > 0)
            data_in_dly <= data_in;
        else
            data_in_dly <= data_in_dly;
        if(first_clk_pipe) begin
            wr_en <= 1'b0;
            wr_add <= {`MEM_SIZE+1{1'b1}};
            pre_number_out <= wr_add + 1'b1;
            //number_out <= pre_number_out;             
        end
        else begin
            if(enable) begin
                wr_en <= 1'b1;
                wr_add <= wr_add + 1'b1;
            end
            else begin
                wr_en <= 1'b0;
                wr_add <= wr_add;
            end                      
        end
                               
        data_out <= pre_data_out;
        wr_en_hold <= wr_en;
    end
      
        
        reg_array #(
       //Memory #(
               .RAM_WIDTH(6),                       // Specify RAM data width
               .RAM_DEPTH(16),                     // Specify RAM depth (number of entries)
               .INIT_FILE("") //"full.txt")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
             ) Number_out (
               .addra(BX_pipe),    // Write address bus, width determined from RAM_DEPTH
               .addrb(read_add[8:5]),    // Read address bus, width determined from RAM_DEPTH
               .dina(wr_add+1'b1),      // RAM input data, width determined from RAM_WIDTH
               .clka(clk),      // Write clock
               .clkb(clk),      // Read clock
               .wea(1'b1),        // Write enable
               //.enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
               .rstb(rst_pipe),      // Output reset (does not affect memory contents)
               .regceb(1'b1),  // Output register enable
               //.doutb(pre_data_out)     // RAM output data, width determined from RAM_WIDTH
               .doutb(number_out)
       );
                                                   

//        Memory #(
//            .RAM_WIDTH(54),                       // Specify RAM data width
//            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
//            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
//            .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
//          ) Projection (
//            .addra({BX_pipe,wr_add}),    // Write address bus, width determined from RAM_DEPTH
//            .addrb(read_add),    // Read address bus, width determined from RAM_DEPTH
//            .dina(data_in_dly),      // RAM input data, width determined from RAM_WIDTH
//            .clka(clk),      // Write clock
//            .clkb(clk),      // Read clock
//            .wea(wr_en),        // Write enable
//            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
//            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
//            .regceb(1'b1),  // Output register enable
//            .doutb(pre_data_out)     // RAM output data, width determined from RAM_WIDTH
//        );
        
    generate
       if(neighbor==1'b0)
           Memory #(
               .RAM_WIDTH(54),                       // Specify RAM data width
               .RAM_DEPTH(2**(`MEM_SIZE+4)),                     // Specify RAM depth (number of entries)
               .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
               .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
             ) Projection (
               .addra({BX_pipe[3:0],wr_add[`MEM_SIZE-1:0]}),    // Write address bus, width determined from RAM_DEPTH
               .addrb(read_add[`MEM_SIZE+3:0]),    // Read address bus, width determined from RAM_DEPTH
               .dina(data_in_dly),      // RAM input data, width determined from RAM_WIDTH
               .clka(clk),      // Write clock
               .clkb(clk),      // Read clock
               .wea(wr_en),        // Write enable
               .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
               .rstb(rst_pipe),      // Output reset (does not affect memory contents)
               .regceb(1'b1),  // Output register enable
               .doutb(pre_data_out)     // RAM output data, width determined from RAM_WIDTH
               );
       else
           reg_array #(
             //Memory #(
                 .RAM_WIDTH(54),                       // Specify RAM data width
                 .RAM_DEPTH(2**(`MEM_SIZE+1)),                     // Specify RAM depth (number of entries)
                 .INIT_FILE("") //"full.txt")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
               ) Projection (
                 .addra({BX_pipe[0],wr_add[`MEM_SIZE-1:0]}),    // Write address bus, width determined from RAM_DEPTH
                 .addrb(read_add[`MEM_SIZE:0]),    // Read address bus, width determined from RAM_DEPTH
                 .dina(data_in_dly),      // RAM input data, width determined from RAM_WIDTH
                 .clka(clk),      // Write clock
                 .clkb(clk),      // Read clock
                 .wea(wr_en),        // Write enable
                 //.enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
                 .rstb(rst_pipe),      // Output reset (does not affect memory contents)
                 .regceb(1'b1),  // Output register enable
                 .doutb(pre_data_out)
             );
    endgenerate
        
endmodule
