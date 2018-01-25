`timescale 1ns / 1ps
`include "constants.vh"

// Use this module as an interface to the processing module

module prep_processing #(
parameter INPUT_SIZE1  = 36,
parameter READ_ADD1    = `MEM_SIZE+1,
parameter INPUT_SIZE2  = 36,
parameter READ_ADD2    = `MEM_SIZE+1,
parameter OUTPUT_SIZE1 = 36,
parameter OUTPUT_SIZE2 = 36,
parameter UUT_NAME = "Custom_UUT"
)(
    input clk,
    input reset,
    input en_proc,
    input [1:0] start,
    input [1:0] done,
    
    input [5:0] number_in_1_1,
    input [5:0] number_in_1_2,
    input [5:0] number_in_1_3,
    input [5:0] number_in_2_1,
    input [5:0] number_in_2_2,
    input [5:0] number_in_2_3,
    output wire [READ_ADD1:0] read_add_1_1,
    output wire [READ_ADD1:0] read_add_1_2,
    output wire [READ_ADD1:0] read_add_1_3,
    output wire [READ_ADD2:0] read_add_2_1,
    output wire [READ_ADD2:0] read_add_2_2,
    output wire [READ_ADD2:0] read_add_2_3,
    input [INPUT_SIZE1-1:0] input_1_1,
    input [INPUT_SIZE1-1:0] input_1_2,
    input [INPUT_SIZE1-1:0] input_1_3,
    input [INPUT_SIZE2-1:0] input_2_1,
    input [INPUT_SIZE2-1:0] input_2_2,
    input [INPUT_SIZE2-1:0] input_2_3,
    output wire [OUTPUT_SIZE1-1:0] output_1_1,
    output wire [OUTPUT_SIZE1-1:0] output_1_2,
    output wire [OUTPUT_SIZE1-1:0] output_1_3,
    output wire [OUTPUT_SIZE2-1:0] output_2_1,
    output wire [OUTPUT_SIZE2-1:0] output_2_2,
    output wire [OUTPUT_SIZE2-1:0] output_2_3,
    output wire valid_1_1,
    output wire valid_1_2,
    output wire valid_1_3,
    output wire valid_2_1,
    output wire valid_2_2,
    output wire valid_2_3
    );
    
    generate 
        if (UUT_NAME=="Custom_UUT") begin
            processingmodule #(INPUT_SIZE1,INPUT_SIZE2,OUTPUT_SIZE1,OUTPUT_SIZE2) UUT_PROCESS(
                .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
                .number_in_1_1(number_in_1_1), .number_in_1_2(number_in_1_2), .number_in_1_3(number_in_1_3),
                .number_in_2_1(number_in_2_1), .number_in_2_2(number_in_2_2), .number_in_2_3(number_in_2_3),
                .read_add_1_1(read_add_1_1), .read_add_1_2(read_add_1_2), .read_add_1_3(read_add_1_3),
                .read_add_2_1(read_add_2_1), .read_add_2_2(read_add_2_2), .read_add_2_3(read_add_2_3),
                .input_1_1(input_1_1), .input_1_2(input_1_2), .input_1_3(input_1_3),
                .input_2_1(input_2_1), .input_2_2(input_2_2), .input_2_3(input_2_3),
                .output_1_1(output_1_1), .output_1_2(output_1_2), .output_1_3(output_1_3),
                .output_2_1(output_2_1), .output_2_2(output_2_2), .output_2_3(output_2_3),
                .valid_1_1(valid_1_1), .valid_1_2(valid_1_2), .valid_1_3(valid_1_3),
                .valid_2_1(valid_2_1), .valid_2_2(valid_2_2), .valid_2_3(valid_2_3));
        end
    endgenerate
    
    // add your UUT to test here
      
endmodule
