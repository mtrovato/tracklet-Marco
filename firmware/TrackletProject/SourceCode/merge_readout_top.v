`timescale 1ns / 1ps

//
// This module takes inputs from 8 BRAMs. Inputs from each BRAM should be already sorted 
// by tracklet indices. Input data are merged by three layers of merger modules so that the 
// outputs remains sorted.
//
// Zhengcheng Tao
// 11/23/2015
//

module merge_readout_top #(
    parameter DATA_WIDTH = 12,
    parameter ACTIVE_MSB = 11,
    parameter ACTIVE_LSB = 6
)
    (
    input clk,
    input rst,
    
    input [5:0] number_in1,
    output reg [5:0] addr_out1,
    input [DATA_WIDTH-1:0] data_in1,
    input [5:0] number_in2,
    output reg [5:0] addr_out2,
    input [DATA_WIDTH-1:0] data_in2,
    input [5:0] number_in3,
    output reg [5:0] addr_out3,
    input [DATA_WIDTH-1:0] data_in3,
    input [5:0] number_in4,
    output reg [5:0] addr_out4,
    input [DATA_WIDTH-1:0] data_in4,
    input [5:0] number_in5,
    output reg [5:0] addr_out5,
    input [DATA_WIDTH-1:0] data_in5,
    input [5:0] number_in6,
    output reg [5:0] addr_out6,
    input [DATA_WIDTH-1:0] data_in6,
    input [5:0] number_in7,
    output reg [5:0] addr_out7,
    input [DATA_WIDTH-1:0] data_in7,
    input [5:0] number_in8,
    output reg [5:0] addr_out8,
    input [DATA_WIDTH-1:0] data_in8,
    
    output [DATA_WIDTH-1:0] data_out,
    output valid_out
);

    wire read1, read2, read3, read4, read5, read6, read7, read8;   
    wire valid1, valid2, valid3, valid4, valid5, valid6, valid7, valid8;
    //reg valid1_dly, valid2_dly, valid3_dly, valid4_dly, valid5_dly, valid6_dly, valid7_dly, valid8_dly;
    //wire valid_in;

    assign valid1 = (number_in1 > 6'b0) && (addr_out1 < number_in1);
    assign valid2 = (number_in2 > 6'b0) && (addr_out2 < number_in2);
    assign valid3 = (number_in3 > 6'b0) && (addr_out3 < number_in3);
    assign valid4 = (number_in4 > 6'b0) && (addr_out4 < number_in4);
    assign valid5 = (number_in5 > 6'b0) && (addr_out5 < number_in5);
    assign valid6 = (number_in6 > 6'b0) && (addr_out6 < number_in6);
    assign valid7 = (number_in7 > 6'b0) && (addr_out7 < number_in7);
    assign valid8 = (number_in8 > 6'b0) && (addr_out8 < number_in8);

//    always @ (posedge clk) begin
//        valid1 <= (number_in1 > 6'b0) && (addr_out1 < number_in1);
//        valid2 <= (number_in2 > 6'b0) && (addr_out2 < number_in2);
//        valid3 <= (number_in3 > 6'b0) && (addr_out3 < number_in3);
//        valid4 <= (number_in4 > 6'b0) && (addr_out4 < number_in4);
//        valid5 <= (number_in5 > 6'b0) && (addr_out5 < number_in5);
//        valid6 <= (number_in6 > 6'b0) && (addr_out6 < number_in6);
//        valid7 <= (number_in7 > 6'b0) && (addr_out7 < number_in7);
//        valid8 <= (number_in8 > 6'b0) && (addr_out8 < number_in8);
//    end
    
    //assign valid_in = valid1 | valid2 | valid3 | valid4 | valid5 | valid6 | valid7 | valid8; 

    always @ (posedge clk) begin
        if (rst) begin
            addr_out1 <= 6'b0;
            addr_out2 <= 6'b0;
            addr_out3 <= 6'b0;
            addr_out4 <= 6'b0;
            addr_out5 <= 6'b0;
            addr_out6 <= 6'b0;
            addr_out7 <= 6'b0;
            addr_out8 <= 6'b0;            
        end else begin
            if (read1) begin
                addr_out1 <= addr_out1 + 1'b1;
            end       
            if (read2) begin
                addr_out2 <= addr_out2 + 1'b1;
            end
            if (read3) begin
                addr_out3 <= addr_out3 + 1'b1;
            end
            if (read4) begin
                addr_out4 <= addr_out4 + 1'b1;
            end
            if (read5) begin
                addr_out5 <= addr_out5 + 1'b1;
            end
            if (read6) begin
                addr_out6 <= addr_out6 + 1'b1;
            end
            if (read7) begin
                addr_out7 <= addr_out7 + 1'b1;
            end
            if (read8) begin
                addr_out8 <= addr_out8 + 1'b1;
            end
        end
    end

    merger3Layer #(DATA_WIDTH, ACTIVE_MSB, ACTIVE_LSB)
    merger3L_i
    (
        .clk(clk),
        .en(1'b1),
        .reset(rst),
        .input1(data_in1),
        .valid1(valid1),
        .outread1(read1),
        .input2(data_in2),
        .valid2(valid2),
        .outread2(read2),
        .input3(data_in3),
        .valid3(valid3),
        .outread3(read3),
        .input4(data_in4),
        .valid4(valid4),
        .outread4(read4),
        .input5(data_in5),
        .valid5(valid5),
        .outread5(read5),
        .input6(data_in6),
        .valid6(valid6),
        .outread6(read6),
        .input7(data_in7),
        .valid7(valid7),
        .outread7(read7),
        .input8(data_in8),
        .valid8(valid8),
        .outread8(read8),
        .inRead(1'b1),
        .out(data_out),
        .vout(valid_out)
    ); 

endmodule