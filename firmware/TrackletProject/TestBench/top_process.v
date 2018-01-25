`timescale 1ns / 1ps
`include "constants.vh"

module top_process #(
parameter INPUT_TYPE1  = "StubsByLayer",
parameter INPUT_SIZE1  = 36,
parameter INPUT_TYPE2  = "StubsByLayer",
parameter INPUT_SIZE2  = 36,
parameter OUTPUT_TYPE1 = "AllStubs",
parameter OUTPUT_SIZE1 = 36,
parameter OUTPUT_TYPE2 = "AllStubs",
parameter OUTPUT_SIZE2 = 36,
parameter OUTPUT_NUM1  = 3,
parameter OUTPUT_NUM2  = 3,
parameter NAME_UUT     = "Custom_UUT"
)(
    input proc_clk, 
    input io_clk,
    input reset,
    // inputs
    input [INPUT_SIZE1-1:0] input1_1,
    input [INPUT_SIZE1-1:0] input1_2,
    input [INPUT_SIZE1-1:0] input1_3,
    input [INPUT_SIZE2-1:0] input2_1,
    input [INPUT_SIZE2-1:0] input2_2,
    input [INPUT_SIZE2-1:0] input2_3
    // outputs
    );
        
    reg [2:0] BX; // bunch crossing counter
    reg first_clk;
    reg not_first_clk;
    
    reg en_proc;
    
    initial BX = 3'b111;
    initial en_proc <= 1'b0;
    
    always @(posedge io_clk) begin
        if (reset)
            en_proc <= 1'b0;
        else if (input1_1 == 128'hFFFFFFFFF)
            en_proc <= 1'b1;
    end
    
    //---------------------------------------------------
    // Connect to processing
    //---------------------------------------------------    
    tracklet_processing #(INPUT_TYPE1,INPUT_SIZE1,INPUT_TYPE2,INPUT_SIZE2,OUTPUT_TYPE1,OUTPUT_SIZE1,OUTPUT_TYPE2,OUTPUT_SIZE2,OUTPUT_NUM1,OUTPUT_NUM2,NAME_UUT) 
    tracklet_process(
        .clk(proc_clk),
        .reset(reset),
        .en_proc(en_proc),
        .BX(BX),
        .first_clk(first_clk),
        .not_first_clk(not_first_clk),
        .input1_1(input1_1),
        .input1_2(input1_2),
        .input1_3(input1_3),
        .input2_1(input2_1),
        .input2_2(input2_2),
        .input2_3(input2_3)
    );
    
    
endmodule