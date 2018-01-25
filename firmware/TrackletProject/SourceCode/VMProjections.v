`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:00:52 PM
// Design Name: 
// Module Name: VMProj
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


module VMProjections(
    input clk,
    input reset,
    input en_proc,
        
    input [1:0] start,
    output [1:0] done,
    
    input [13:0] data_in, // was [12:0]
    input enable,
    
    output reg [5:0] number_out,
    input [`MEM_SIZE+2:0] read_add,
    output reg [13:0] data_out
    );
    
    reg [13:0] data_in_dly;
    reg [`MEM_SIZE:0] wr_add;
    reg wr_en;
    
    reg [2:0] BX_pipe;
    reg first_clk_pipe;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
    initial begin
       BX_pipe = 3'b111;
    end
    
    pipe_delay #(.STAGES(`tmux), .WIDTH(2))
               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done));    
               
    always @(posedge clk) begin
       if (rst_pipe)
           BX_pipe <= 3'b111;
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
    wire [13:0] pre_data_out;
    always @(posedge clk) begin
        data_in_dly <= data_in;
        if(first_clk_pipe) begin
            wr_add <= {`MEM_SIZE+1{1'b1}};
            number_out <= wr_add + 1'b1;
        end
        else begin
            if(enable) begin
                wr_add <= wr_add + 1'b1;
                wr_en <= 1'b1;
            end
            else begin
                wr_add <= wr_add;
                wr_en <= 1'b0;
            end
        end
        data_out <= pre_data_out;
    end

//width changes


    reg_array #(
    //Memory #(
            .RAM_WIDTH(14),                       // Specify RAM data width
            .RAM_DEPTH(2**(`MEM_SIZE+1)),                     // Specify RAM depth (number of entries)
            //.RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
          ) VMProjection (
            .addra({BX_pipe[0],wr_add[`MEM_SIZE-1:0]}),    // Write address bus, width determined from RAM_DEPTH
            .addrb(read_add[`MEM_SIZE:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina(data_in_dly),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(wr_en),        // Write enable
            //.enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(pre_data_out)     // RAM output data, width determined from RAM_WIDTH
    );
        
endmodule
