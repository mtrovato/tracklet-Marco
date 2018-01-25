`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:16:02 PM
// Design Name: 
// Module Name: MatchEngine
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


module MatchEngine(
    input clk,
    input reset,
    input en_proc,
        
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in_vmstubin,
    output reg [`MEM_SIZE+4:0] read_add_vmstubin,
    input [18:0] vmstubin,
    input [5:0] number_in_vmprojin,
    output reg [`MEM_SIZE+2:0] read_add_vmprojin,
    input [13:0] vmprojin,
    
    output reg [11:0] matchout,
    output reg valid_data
    );
    
    parameter DISK=1'b0;
    
    reg [4:0] BX_pipe;
    reg first_clk_pipe;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
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
    ///////////////////////////////////////////////////
    initial begin
//        read_add1 = 6'h3f;
//        read_add2 = 6'h3f;
    end
    
    pipe_delay #(.STAGES(6), .WIDTH(2))
           done_delay(.pipe_in(), .pipe_out(), .clk(clk),
           .val_in(start), .val_out(done));
               
    wire pre_valid_data;
    reg [5:0] behold;
    reg [13:0] vmprojin_hold1;
    reg [13:0] vmprojin_hold2;
    
    wire [5:0] pre_read_add1;
    wire [5:0] pre_read_add2;
    
    
    
    double_loop ME_loop(
        .clk(clk),
        .reset(first_clk_pipe),
        .number1in(number_in_vmprojin), // Projections first for the right looping
        .number2in(number_in_vmstubin), // Stubs are second
        .readadd1(pre_read_add2),
        .readadd2(pre_read_add1),
        .valid(pre_valid_data)
    );
    
    reg [10:0] pre_read_add_vmstubin;
    reg [8:0] pre_read_add_vmprojin;
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_data;    
        behold[5:1] <= behold[4:0];
        vmprojin_hold1 <= vmprojin;
        vmprojin_hold2 <= vmprojin_hold1;
        read_add_vmstubin <= {BX_pipe,pre_read_add1[`MEM_SIZE-1:0]};
        read_add_vmprojin <= {BX_pipe[2:0],pre_read_add2[`MEM_SIZE-1:0]};
        
//        read_add_vmstubin <=  pre_read_add_vmstubin;
//        read_add_vmprojin <= pre_read_add_vmprojin;
    end
   
    wire signed [2:0] stubphi;
    wire signed [2:0] projphi;
    generate
        if (DISK) begin
	       assign stubphi = vmstubin[7:5]; // phi position for disk VM stubs
	       assign projphi = vmprojin_hold2[7:5];
        end
        else begin
	       assign stubphi = vmstubin[4:2]; // phi position for barrel VM stubs
	       assign projphi = vmprojin_hold2[6:4];
	    end
    endgenerate
 
    wire pass_cut;
    
//    assign pass_cut = 1'b1;
    assign pass_cut = ((stubphi[2:0] + 1'b1 == projphi[2:0]) & stubphi[2:0] != 3'b111) | 
                      ((projphi[2:0] + 1'b1 == stubphi[2:0]) & projphi[2:0] != 3'b111) |
                      (stubphi[2:0] == projphi[2:0]);
    
    ///////////////////////////////////////////////////////////////////////////
    
    always @(posedge clk) begin
        matchout <= {vmprojin_hold2[13:8],vmstubin[15:10]};
        valid_data <= behold[3] & pass_cut;
    end
endmodule
