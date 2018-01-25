`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2015 08:34:26 PM
// Design Name: 
// Module Name: merger3Layer
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


module merger3Layer #(
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
    input wire [DATA_WIDTH-1:0] input5,
    input wire valid5,
    output wire outread5,
    input wire [DATA_WIDTH-1:0] input6,
    input wire valid6,
    output wire outread6,
    input wire [DATA_WIDTH-1:0] input7,
    input wire valid7,
    output wire outread7,
    input wire [DATA_WIDTH-1:0] input8,
    input wire valid8,
    output wire outread8,
    input wire inRead,
    output wire [DATA_WIDTH-1:0] out,
    output wire vout,
    output wire [2:0] input_index
    );
    
    wire outread_L11_L21, outread_L12_L21, outread_L13_L22, outread_L14_L22, outread_L21_L31, outread_L22_L31;
    wire [DATA_WIDTH+2:0] L1_1_out;
    wire [DATA_WIDTH+2:0] L1_2_out;
    wire [DATA_WIDTH+2:0] L1_3_out;
    wire [DATA_WIDTH+2:0] L1_4_out;
    wire [DATA_WIDTH+2:0] L2_1_out;
    wire [DATA_WIDTH+2:0] L2_2_out;
    wire L1_1_vout, L1_2_vout, L1_3_vout, L1_4_vout, L2_1_vout, L2_2_vout;
    
    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L1_1
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA({3'b000,input1}),
        .validA_i(valid1),
        .outreadA(outread1),
        .inputB({3'b001,input2}),
        .validB_i(valid2),
        .outreadB(outread2),
        .inRead(outread_L11_L21),
        .out(L1_1_out),
        .vout(L1_1_vout)
    );

    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L1_2
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA({3'b010,input3}),
        .validA_i(valid3),
        .outreadA(outread3),
        .inputB({3'b011,input4}),
        .validB_i(valid4),
        .outreadB(outread4),
        .inRead(outread_L12_L21),
        .out(L1_2_out),
        .vout(L1_2_vout)
    );
    
    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L1_3
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA({3'b100,input5}),
        .validA_i(valid5),
        .outreadA(outread5),
        .inputB({3'b101,input6}),
        .validB_i(valid6),
        .outreadB(outread6),
        .inRead(outread_L13_L22),
        .out(L1_3_out),
        .vout(L1_3_vout)
    );

    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L1_4
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA({3'b110,input7}),
        .validA_i(valid7),
        .outreadA(outread7),
        .inputB({3'b111,input8}),
        .validB_i(valid8),
        .outreadB(outread8),
        .inRead(outread_L14_L22),
        .out(L1_4_out),
        .vout(L1_4_vout)
    );    

    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L2_1
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA(L1_1_out),
        .validA_i(L1_1_vout),
        .outreadA(outread_L11_L21),
        .inputB(L1_2_out),
        .validB_i(L1_2_vout),
        .outreadB(outread_L12_L21),
        .inRead(outread_L21_L31),
        .out(L2_1_out),
        .vout(L2_1_vout)
    );
    
    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L2_2
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA(L1_3_out),
        .validA_i(L1_3_vout),
        .outreadA(outread_L13_L22),
        .inputB(L1_4_out),
        .validB_i(L1_4_vout),
        .outreadB(outread_L14_L22),
        .inRead(outread_L22_L31),
        .out(L2_2_out),
        .vout(L2_2_vout)
    );  
    
    merger #(DATA_WIDTH+3, ACTIVE_MSB, ACTIVE_LSB) 
    merger_L3_1
    (
        .clk(clk),
        .en(en),
        .reset(reset),
        .inputA(L2_1_out),
        .validA_i(L2_1_vout),
        .outreadA(outread_L21_L31),
        .inputB(L2_2_out),
        .validB_i(L2_2_vout),
        .outreadB(outread_L22_L31),
        .inRead(inRead),
        .out({input_index[2:0],out[DATA_WIDTH-1:0]}),
        .vout(vout)
    );
            
endmodule