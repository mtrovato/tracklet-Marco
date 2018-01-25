`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:16:38 PM
// Design Name: 
// Module Name: FitInput
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


module Fit_Input(
    input clk,
    input reset,
    input start,
    input read_en,
    output valid,
    input [5:0] number1,
    output reg [5:0] addr1,
    input [35:0] res_input_1,
    input [5:0] number2,
    output reg [5:0] addr2,
    input [35:0] res_input_2,
    output reg [35:0] res_output
    );
    
    reg pre_valid;
    wire start_pipe;

    pipe_delay #(.STAGES(5), .WIDTH(1))
        valid_pipe(.pipe_in(start), .pipe_out(start_pipe), .clk(clk),
        .val_in(pre_valid), .val_out(valid));

    initial begin
        wr_add = 6'h0;
        rd_add = 6'h0;
        addr1 = 6'h3f;
        addr2 = 6'h3f;
//        addr3 = 6'h3f;
//        addr4 = 6'h3f;
    end
    
    reg wr_en;
    reg [35:0] res_stream;
    
    always @(posedge clk) begin
        if(reset) begin
            addr1 <= 6'h3f;
            addr2 <= 6'h3f;
        end
        else begin
            if((addr1 + 1'b1)< number1) begin
                addr1 <= addr1 + 1'b1;                
            end
            else begin
                addr1 <= addr1;
            end
            if(res_input_1 != 0)
                wr_en <= 1'b1;
            else
                wr_en <= 1'b0;
        end
        pre_valid  <= number1 > 6'd0;
        res_stream <= res_input_1;
        
    end
    
    reg [35:0] BRAM [5:0];
    reg [5:0] wr_add;
    reg [5:0] rd_add;
    
    

    always @(posedge clk) begin
        if(start) begin
            wr_add <= 6'h0;
            rd_add <= 6'h0;
        end
        else begin
            if(wr_en) begin
                BRAM[wr_add] <= res_stream;
                wr_add <= wr_add + 1'b1;
            end
            else
                wr_add <= wr_add;
            if(read_en | start_pipe) begin
                res_output <= BRAM[rd_add];
                rd_add <= rd_add + 1'b1;
            end
            else
                rd_add <= rd_add;
        end
    end

endmodule
