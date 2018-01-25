`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2016 04:30:42 PM
// Design Name: 
// Module Name: merger2layer
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


module merger2layer#(
    parameter DATA_WIDTH = 12,
    parameter ACTIVE_MSB = 11,
    parameter ACTIVE_LSB = 6
)
    (
    input clk,
    input en,
    input reset,
    input wire [DATA_WIDTH-1:0] input1,
    input wire valid1,
    output wire outread1,
    input wire [DATA_WIDTH-1:0] input2,
    input wire valid2,
    output wire outread2,
    input wire [DATA_WIDTH-1:0] input3,
    input wire valid3,
    output wire outread3,
    input wire [DATA_WIDTH-1:0] input4,
    input wire valid4,
    output wire outread4,
    input wire inRead,
    output wire [DATA_WIDTH-1:0] out,
    output wire vout,
    output wire [1:0] input_index
    );
    
    
    wire outread_L11_L2, outread_L12_L2;
    wire [DATA_WIDTH+1:0] L1_1_out, L1_2_out;
    wire L1_1_vout, L1_2_vout;

    
    merger #(DATA_WIDTH+2, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L1_1
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA({2'b00,input1}),
        .validA_i(valid1),
        .outreadA(outread1),
        .inputB({2'b01,input2}),
        .validB_i(valid2),
        .outreadB(outread2),
        .inRead(outread_L11_L2),
        .out(L1_1_out),
        .vout(L1_1_vout)
    );

    merger #(DATA_WIDTH+2, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L1_2
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA({2'b10,input3}),
        .validA_i(valid3),
        .outreadA(outread3),
        .inputB({2'b11,input4}),
        .validB_i(valid4),
        .outreadB(outread4),
        .inRead(outread_L12_L2),
        .out(L1_2_out),
        .vout(L1_2_vout)
    );    
    
    merger #(DATA_WIDTH+2, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L2
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA(L1_1_out),
        .validA_i(L1_1_vout),
        .outreadA(outread_L11_L2),
        .inputB(L1_2_out),
        .validB_i(L1_2_vout),
        .outreadB(outread_L12_L2),
        .inRead(inRead),
        .out({input_index[1:0],out[DATA_WIDTH-1:0]}),
        .vout(vout)
    );    
    
endmodule
