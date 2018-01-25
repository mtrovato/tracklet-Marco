`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:14:20 PM
// Design Name: 
// Module Name: TracksPars
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


module CleanTrack(
    input 	  clk,
    input 	  reset,
    input 	  en_proc,
    
    input [1:0]   start,
    output [1:0]  done,
    
    input [125:0] data_in,
    output reg [125:0] data_out,
    input enable
    
    
    );
    
    always @(posedge clk) begin
        if(enable)
        data_out <= data_in;
        else
        data_out <= 126'h0;
    end
       
    reg [2:0] BX_pipe;
    reg first_clk_pipe;
    reg [2:0] BX_hold;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
    initial begin
       BX_pipe = 3'b111;
    end
    
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

        BX_hold <= BX_pipe;
    end 
    
    pipe_delay #(.STAGES(`tmux), .WIDTH(2))
               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done));
               
    
endmodule
