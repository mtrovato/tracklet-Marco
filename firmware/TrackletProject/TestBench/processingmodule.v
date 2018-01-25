`timescale 1 ns / 1 ps
`include "constants.vh"

module processingmodule #(
parameter INPUT_SIZE1 = 36,
parameter INPUT_SIZE2 = 36,
parameter OUTPUT_SIZE1 = 36,
parameter OUTPUT_SIZE2 = 36
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
    output reg [`MEM_SIZE+2:0] read_add_1_1,
    output reg [`MEM_SIZE+2:0] read_add_1_2,
    output reg [`MEM_SIZE+2:0] read_add_1_3,
    output reg [`MEM_SIZE+2:0] read_add_2_1,
    output reg [`MEM_SIZE+2:0] read_add_2_2,
    output reg [`MEM_SIZE+2:0] read_add_2_3,
    input [INPUT_SIZE1-1:0] input_1_1,
    input [INPUT_SIZE1-1:0] input_1_2,
    input [INPUT_SIZE1-1:0] input_1_3,
    input [INPUT_SIZE2-1:0] input_2_1,
    input [INPUT_SIZE2-1:0] input_2_2,
    input [INPUT_SIZE2-1:0] input_2_3,
    output reg [OUTPUT_SIZE1-1:0] output_1_1,
    output reg [OUTPUT_SIZE1-1:0] output_1_2,
    output reg [OUTPUT_SIZE1-1:0] output_1_3,
    output reg [OUTPUT_SIZE2-1:0] output_2_1,
    output reg [OUTPUT_SIZE2-1:0] output_2_2,
    output reg [OUTPUT_SIZE2-1:0] output_2_3,
    output reg valid_1_1,
    output reg valid_1_2,
    output reg valid_1_3,
    output reg valid_2_1,
    output reg valid_2_2,
    output reg valid_2_3
);

    //---------------------------------------------------
    // Deal w/ start signals
    //---------------------------------------------------
    reg [2:0] BX_pipe;
    reg [2:0] BX_pipe_dly;
    reg first_clk_pipe;
    reg first_clk_dly;
    
    wire rst_pipe;
    assign rst_pipe = start[1];
    
    initial BX_pipe = 3'b111;
    
    always @(posedge clk) begin
        BX_pipe_dly <= BX_pipe;
        if (rst_pipe) BX_pipe <= 3'b111;
        else begin
            if (start[0]) begin
                BX_pipe <= BX_pipe + 1'b1;
                first_clk_pipe <= 1'b1;
            end
            else first_clk_pipe <= 1'b0;            
        end
        first_clk_dly <= first_clk_pipe;
    end
    
    pipe_delay #(.STAGES(3), .WIDTH(2))  // # STAGES should be the latency of the module
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
    
    //---------------------------------------------------
    // Deal w/ reading in
    //---------------------------------------------------
    reg pre_valid_1_1;
    reg pre_valid_1_2;
    reg pre_valid_1_3;
    reg pre_valid_2_1;
    reg pre_valid_2_2;
    reg pre_valid_2_3;
    reg pre_valid_1_1_dly;
    reg pre_valid_1_2_dly;
    reg pre_valid_1_3_dly;
    reg pre_valid_2_1_dly;
    reg pre_valid_2_2_dly;
    reg pre_valid_2_3_dly;
    
    initial begin
        read_add_1_1 = {`MEM_SIZE+3{1'b1}};
        read_add_1_2 = {`MEM_SIZE+3{1'b1}};
        read_add_1_3 = {`MEM_SIZE+3{1'b1}};
        read_add_2_1 = {`MEM_SIZE+3{1'b1}};
        read_add_2_2 = {`MEM_SIZE+3{1'b1}};
        read_add_2_3 = {`MEM_SIZE+3{1'b1}};
    end

    always @(posedge clk) begin
        if (first_clk_pipe) begin
            read_add_1_1 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_1_2 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_1_2 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_2_1 <= {BX_pipe,{`MEM_SIZE{1'b1}}};            
            read_add_2_2 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_2_3 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
        end
        else begin
            if (number_in_1_1 > 0) begin
                if (read_add_1_1[`MEM_SIZE-1:0] + 1'b1 < number_in_1_1[`MEM_SIZE-1:0]) begin
                    read_add_1_1[`MEM_SIZE-1:0] <= read_add_1_1[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_1_1 <= 1'b1;
                end
                else begin
                    read_add_1_1  <= read_add_1_1;
                    pre_valid_1_1 <= 1'b0;
                end
            end
            if (number_in_1_2 > 0) begin 
                if (read_add_1_2[`MEM_SIZE-1:0] + 1'b1 < number_in_1_2[`MEM_SIZE-1:0]) begin
                    read_add_1_2[`MEM_SIZE-1:0] <= read_add_1_2[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_1_2 <= 1'b1;
                end
                else begin
                    read_add_1_2  <= read_add_1_2;
                    pre_valid_1_2 <= 1'b0;
                end
            end
            if (number_in_1_3 > 0) begin 
                if (read_add_1_3[`MEM_SIZE-1:0] + 1'b1 < number_in_1_3[`MEM_SIZE-1:0]) begin
                    read_add_1_3[`MEM_SIZE-1:0] <= read_add_1_3[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_1_3 <= 1'b1;
                end
                else begin
                    read_add_1_3  <= read_add_1_3;
                    pre_valid_1_3 <= 1'b0;
                end
            end
            if (number_in_2_1 > 0) begin 
                if (read_add_2_1[`MEM_SIZE-1:0] + 1'b1 < number_in_2_1[`MEM_SIZE-1:0]) begin
                    read_add_2_1[`MEM_SIZE-1:0] <= read_add_2_1[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_2_1 <= 1'b1;
                end
                else begin
                    read_add_2_1  <= read_add_2_1;
                    pre_valid_2_1 <= 1'b0;
                end
            end
            if (number_in_2_2 > 0) begin 
                if (read_add_2_2[`MEM_SIZE-1:0] + 1'b1 < number_in_2_2[`MEM_SIZE-1:0]) begin
                    read_add_2_2[`MEM_SIZE-1:0] <= read_add_2_2[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_2_2 <= 1'b1;
                end
                else begin
                    read_add_2_2  <= read_add_2_2;
                    pre_valid_2_2 <= 1'b0;
                end
            end            
            if (number_in_2_3 > 0) begin 
                if (read_add_2_3[`MEM_SIZE-1:0] + 1'b1 < number_in_2_3[`MEM_SIZE-1:0]) begin
                    read_add_2_3[`MEM_SIZE-1:0] <= read_add_2_3[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_2_3 <= 1'b1;
                end
                else begin
                    read_add_2_3  <= read_add_2_3;
                    pre_valid_2_3 <= 1'b0;
                end
            end
        end
    end
        
    always @(posedge clk) begin
        output_1_1 <= input_1_1;
        output_1_2 <= input_1_2;
        output_1_3 <= input_1_3;
        output_2_1 <= input_2_1;
        output_2_2 <= input_2_2;
        output_2_3 <= input_2_3;
        pre_valid_1_1_dly <= pre_valid_1_1;
        pre_valid_1_2_dly <= pre_valid_1_2;
        pre_valid_1_3_dly <= pre_valid_1_3;
        pre_valid_2_1_dly <= pre_valid_2_1;
        pre_valid_2_2_dly <= pre_valid_2_2;
        pre_valid_2_3_dly <= pre_valid_2_3;
        valid_1_1 <= pre_valid_1_1_dly;
        valid_1_2 <= pre_valid_1_2_dly;
        valid_1_3 <= pre_valid_1_3_dly;
        valid_2_1 <= pre_valid_2_1_dly;
        valid_2_2 <= pre_valid_2_2_dly;
        valid_2_3 <= pre_valid_2_3_dly;
    end

endmodule