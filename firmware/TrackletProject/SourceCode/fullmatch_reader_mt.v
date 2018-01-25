`timescale 1ns / 1ps
`include "constants.vh"

// Read full matches from local and neighboring sectors for each layer.
// The merged tracklet indices remain sorted.
//
// Zhengcheng Tao


module FMReaderMT # (
    parameter RESDWIDTH = 40,
    parameter ACTIVE_MSB = RESDWIDTH-5,
     parameter ACTIVE_LSB = RESDWIDTH-10
)(
    input clk,
    input rst,
    input new_bx,
    input [3:0] BX_pipe,

    input [RESDWIDTH-1:0] fullmatchin_1,
    input [5:0] numberin_1,
    output reg [`MEM_SIZE+3:0] read_addr_1,
    output read_enable_1,
    input [RESDWIDTH-1:0] fullmatchin_2,
    input [5:0] numberin_2,
    output reg [`MEM_SIZE+3:0] read_addr_2,
    output read_enable_2,
    input [RESDWIDTH-1:0] fullmatchin_3,
    input [5:0] numberin_3,
    output reg [`MEM_SIZE+3:0] read_addr_3,
    output read_enable_3,
    input [RESDWIDTH-1:0] fullmatchin_4,
    input [5:0] numberin_4,
    output reg [`MEM_SIZE+3:0] read_addr_4,
    output read_enable_4,

    input inRead,   //read enable for the merger
    output [RESDWIDTH-1:0] fullmatchout,
    output valid_o
);

    wire outread_1, outread_2, outread_3, outread_4;
    wire prevalid_1, prevalid_2, prevalid_3, prevalid_4;
    reg  [2:0] valid_1_pipe, valid_2_pipe, valid_3_pipe, valid_4_pipe;
    wire prefetch_1, prefetch_2, prefetch_3, prefetch_4;
    
    assign read_enable_1 = prefetch_1 || outread_1;
    assign read_enable_2 = prefetch_2 || outread_2;
    assign read_enable_3 = prefetch_3 || outread_3;
    assign read_enable_4 = prefetch_4 || outread_4;

    // This valid flag actually indicates the next data incoming is valid, NOT the current data the read_addr points to.
    assign prevalid_1 = !new_bx && (read_addr_1[`MEM_SIZE-1:0]+1'b1 < numberin_1[`MEM_SIZE-1:0]);
    assign prevalid_2 = !new_bx && (read_addr_2[`MEM_SIZE-1:0]+1'b1 < numberin_2[`MEM_SIZE-1:0]);
    assign prevalid_3 = !new_bx && (read_addr_3[`MEM_SIZE-1:0]+1'b1 < numberin_3[`MEM_SIZE-1:0]);
    assign prevalid_4 = !new_bx && (read_addr_4[`MEM_SIZE-1:0]+1'b1 < numberin_4[`MEM_SIZE-1:0]);

    // generate a pulse indicating the upcoming data is the first entry
    assign prefetch_1 = (prevalid_1 || valid_1_pipe[0] || valid_1_pipe[1]) && (!valid_1_pipe[2]);
    assign prefetch_2 = (prevalid_2 || valid_2_pipe[0] || valid_2_pipe[1]) && (!valid_2_pipe[2]);
    assign prefetch_3 = (prevalid_3 || valid_3_pipe[0] || valid_3_pipe[1]) && (!valid_3_pipe[2]);
    assign prefetch_4 = (prevalid_4 || valid_4_pipe[0] || valid_4_pipe[1]) && (!valid_4_pipe[2]);

    always @(posedge clk) begin
        if (new_bx) begin
            // initialize read_add at the beginning of new BX
            read_addr_1 <= {BX_pipe[3:0]+1'b1,{`MEM_SIZE{1'b1}}};
            read_addr_2 <= {BX_pipe[3:0]+1'b1,{`MEM_SIZE{1'b1}}};
            read_addr_3 <= {BX_pipe[3:0]+1'b1,{`MEM_SIZE{1'b1}}};
            read_addr_4 <= {BX_pipe[3:0]+1'b1,{`MEM_SIZE{1'b1}}};
            
            valid_1_pipe[2:0] <= 3'b0;
            valid_2_pipe[2:0] <= 3'b0;
            valid_3_pipe[2:0] <= 3'b0;
            valid_4_pipe[2:0] <= 3'b0;
            
        end
        else begin
            if (prefetch_1 || outread_1) begin
                read_addr_1[`MEM_SIZE-1:0] <= read_addr_1[`MEM_SIZE-1:0] + 1'b1;
                valid_1_pipe[0] <= prevalid_1;
                valid_1_pipe[2:1] <= valid_1_pipe[1:0];
            end 
            if (prefetch_2 || outread_2) begin
                read_addr_2[`MEM_SIZE-1:0] <= read_addr_2[`MEM_SIZE-1:0] + 1'b1;
                valid_2_pipe[0] <= prevalid_2;
                valid_2_pipe[2:1] <= valid_2_pipe[1:0];
            end
            if (prefetch_3 || outread_3) begin
                read_addr_3[`MEM_SIZE-1:0] <= read_addr_3[`MEM_SIZE-1:0] + 1'b1;
                valid_3_pipe[0] <= prevalid_3;
                valid_3_pipe[2:1] <= valid_3_pipe[1:0];
            end
            if (prefetch_4 || outread_4) begin
                read_addr_4[`MEM_SIZE-1:0] <= read_addr_4[`MEM_SIZE-1:0] + 1'b1;
                valid_4_pipe[0] <= prevalid_4;
                valid_4_pipe[2:1] <= valid_4_pipe[1:0];
            end
   
        end
        
    end

    // two layer mergers
    merger2layer #(RESDWIDTH, ACTIVE_MSB, ACTIVE_LSB)
    merger2L
    (
        .clk(clk),
        .en(1'b1),
        .reset(new_bx),
        .input1(fullmatchin_1),
        .valid1(valid_1_pipe[2]),
        .outread1(outread_1),
        .input2(fullmatchin_2),
        .valid2(valid_2_pipe[2]),
        .outread2(outread_2),
        .input3(fullmatchin_3),
        .valid3(valid_3_pipe[2]),
        .outread3(outread_3),
        .input4(fullmatchin_4),
        .valid4(valid_4_pipe[2]),
        .outread4(outread_4),
        .inRead(inRead),
        .out(fullmatchout),
        .vout(valid_o),
        .input_index()
    );

endmodule