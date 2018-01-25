`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2015 11:52:43 AM
// Design Name: 
// Module Name: ProjTransmitter
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


module ProjectionTransceiver(
    input clk,
    input reset,                        //whole system reset at beginning i.e. setup board
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in_projin_disk_1,
    output [`MEM_SIZE+3:0] read_add_projin_disk_1,
    input [53:0] projin_disk_1,
    input [5:0] number_in_projin_disk_2,
    output [`MEM_SIZE+3:0] read_add_projin_disk_2,
    input [53:0] projin_disk_2,
    input [5:0] number_in_projin_disk_3,
    output [`MEM_SIZE+3:0] read_add_projin_disk_3,
    input [53:0] projin_disk_3,
    input [5:0] number_in_projin_disk_4,
    output [`MEM_SIZE+3:0] read_add_projin_disk_4,
    input [53:0] projin_disk_4,
    input [5:0] number_in_projin_disk_5,
    output [`MEM_SIZE+3:0] read_add_projin_disk_5,
    input [53:0] projin_disk_5,
    input [5:0] number_in_projin_disk_6,
    output [`MEM_SIZE+3:0] read_add_projin_disk_6,
    input [53:0] projin_disk_6,
    input [5:0] number_in_projin_disk_7,
    output [`MEM_SIZE+3:0] read_add_projin_disk_7,
    input [53:0] projin_disk_7,
    input [5:0] number_in_projin_layer_1,
    output [`MEM_SIZE+3:0] read_add_projin_layer_1,
    input [53:0] projin_layer_1,
    input [5:0] number_in_projin_layer_2,
    output [`MEM_SIZE+3:0] read_add_projin_layer_2,
    input [53:0] projin_layer_2,
    input [5:0] number_in_projin_layer_3,
    output [`MEM_SIZE+3:0] read_add_projin_layer_3,
    input [53:0] projin_layer_3,
    input [5:0] number_in_projin_layer_4,
    output [`MEM_SIZE+3:0] read_add_projin_layer_4,
    input [53:0] projin_layer_4,
    input [5:0] number_in_projin_layer_5,
    output [`MEM_SIZE+3:0] read_add_projin_layer_5,
    input [53:0] projin_layer_5,
    input [5:0] number_in_projin_layer_6,
    output [`MEM_SIZE+3:0] read_add_projin_layer_6,
    input [53:0] projin_layer_6,
    input [5:0] number_in_projin_layer_7,
    output [`MEM_SIZE+3:0] read_add_projin_layer_7,
    input [53:0] projin_layer_7,
    input [5:0] number_in_projin_layer_8,
    output [`MEM_SIZE+3:0] read_add_projin_layer_8,
    input [53:0] projin_layer_8,
    input [5:0] number_in_projin_layer_9,
    output [`MEM_SIZE+3:0] read_add_projin_layer_9,
    input [53:0] projin_layer_9,
    input [5:0] number_in_projin_layer_10,
    output [`MEM_SIZE+3:0] read_add_projin_layer_10,
    input [53:0] projin_layer_10,
    input [5:0] number_in_projin_layer_11,
    output [`MEM_SIZE+3:0] read_add_projin_layer_11,
    input [53:0] projin_layer_11,
    input [5:0] number_in_projin_layer_12,
    output [`MEM_SIZE+3:0] read_add_projin_layer_12,
    input [53:0] projin_layer_12,
    input [5:0] number_in_projin_layer_13,
    output [`MEM_SIZE+3:0] read_add_projin_layer_13,
    input [53:0] projin_layer_13,
        
    output reg [54:0] proj_data_stream,
    output reg valid_proj_data_stream,
    input [54:0] incomming_proj_data_stream,
    input valid_incomming_proj_data_stream,
    
    output [53:0] projout_layer_1,
    output [53:0] projout_layer_2,
    output [53:0] projout_layer_3,
    output [53:0] projout_layer_4,
    output [53:0] projout_layer_5,
    output [53:0] projout_layer_6,
    output [53:0] projout_layer_7,
    output [53:0] projout_layer_8,
    output [53:0] projout_disk_1,
    output [53:0] projout_disk_2,
    output [53:0] projout_disk_3,
    output [53:0] projout_disk_4,
    output [53:0] projout_disk_5,
    output [53:0] projout_disk_6,
    output reg valid_layer_1,
    output reg valid_layer_2,
    output reg valid_layer_3,
    output reg valid_layer_4,
    output reg valid_layer_5,
    output reg valid_layer_6,
    output reg valid_layer_7,
    output reg valid_layer_8,
    output reg valid_disk_1,
    output reg valid_disk_2,
    output reg valid_disk_3,
    output reg valid_disk_4,
    output reg valid_disk_5,
    output reg valid_disk_6
    );
    
    parameter LD_COMBINATION = "L3F3F5";

    reg [3:0] BX_pipe;
    
    wire done_sending_proj;
    
    wire valid;
    reg valid_dly;
    wire [54:0] mem_dat_stream; //priority encoded data stream from the 12 memories
    reg  [54:0] mem_dat_stream_dly1;
    reg  [54:0] mem_dat_stream_dly2;
    wire [54:0] data_output;    //same memory stream but now coming from the FIFO
    
    wire [7:0] valid_layer_pre; 
    wire [7:0] valid_disk_pre; 
    
    wire [3:0] output_BX;       //output BX from the returning residuals

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
   
    reg startdly1, startdly2, startdly3, startdly4;
    
    always @ (posedge clk) begin 
        // delay start to synch with Jorge's code
        startdly1 <= start[0];
        startdly2 <= startdly1;
        startdly3 <= startdly2;
        startdly4 <= startdly3;
        
        // delay to synch output data and valid signals
        valid_layer_1 <= valid_layer_pre[0];// & valid_incomming_proj_data_stream;
        valid_layer_2 <= valid_layer_pre[1];// & valid_incomming_proj_data_stream;
        valid_layer_3 <= valid_layer_pre[2];// & valid_incomming_proj_data_stream;
        valid_layer_4 <= valid_layer_pre[3];// & valid_incomming_proj_data_stream;
        valid_layer_5 <= valid_layer_pre[4];// & valid_incomming_proj_data_stream;
        valid_layer_6 <= valid_layer_pre[5];// & valid_incomming_proj_data_stream;
        valid_layer_7 <= valid_layer_pre[6];// & valid_incomming_proj_data_stream;
        valid_layer_8 <= valid_layer_pre[7];// & valid_incomming_proj_data_stream;
        valid_disk_1 <= valid_disk_pre[0];// & valid_incomming_proj_data_stream;
        valid_disk_2 <= valid_disk_pre[1];// & valid_incomming_proj_data_stream;
        valid_disk_3 <= valid_disk_pre[2];// & valid_incomming_proj_data_stream;
        valid_disk_4 <= valid_disk_pre[3];// & valid_incomming_proj_data_stream;
        valid_disk_5 <= valid_disk_pre[4];// & valid_incomming_proj_data_stream;
        valid_disk_6 <= valid_disk_pre[5];// & valid_incomming_proj_data_stream;
    end
    
    wire [`MEM_SIZE-1:0] pre_read_add1;
    wire [`MEM_SIZE-1:0] pre_read_add2;
    wire [`MEM_SIZE-1:0] pre_read_add3;
    wire [`MEM_SIZE-1:0] pre_read_add4;
    wire [`MEM_SIZE-1:0] pre_read_add5;
    wire [`MEM_SIZE-1:0] pre_read_add6;
    wire [`MEM_SIZE-1:0] pre_read_add7;
    wire [`MEM_SIZE-1:0] pre_read_add8;
    wire [`MEM_SIZE-1:0] pre_read_add9;
    wire [`MEM_SIZE-1:0] pre_read_add10;
    wire [`MEM_SIZE-1:0] pre_read_add11;
    wire [`MEM_SIZE-1:0] pre_read_add12;
    wire [`MEM_SIZE-1:0] pre_read_add13;
    wire [`MEM_SIZE-1:0] pre_read_add14;
    wire [`MEM_SIZE-1:0] pre_read_add15;
    wire [`MEM_SIZE-1:0] pre_read_add16;
    wire [`MEM_SIZE-1:0] pre_read_add17;
    wire [`MEM_SIZE-1:0] pre_read_add18;
    wire [`MEM_SIZE-1:0] pre_read_add19;
    wire [`MEM_SIZE-1:0] pre_read_add20;
    
    assign read_add_projin_disk_1 = {BX_pipe,pre_read_add1[`MEM_SIZE-1:0]};
    assign read_add_projin_disk_2 = {BX_pipe,pre_read_add2[`MEM_SIZE-1:0]};
    assign read_add_projin_disk_3 = {BX_pipe,pre_read_add3[`MEM_SIZE-1:0]};
    assign read_add_projin_disk_4 = {BX_pipe,pre_read_add4[`MEM_SIZE-1:0]};
    assign read_add_projin_disk_5 = {BX_pipe,pre_read_add5[`MEM_SIZE-1:0]};
    assign read_add_projin_disk_6 = {BX_pipe,pre_read_add6[`MEM_SIZE-1:0]};
    assign read_add_projin_disk_7 = {BX_pipe,pre_read_add7[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_1 = {BX_pipe,pre_read_add8[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_2 = {BX_pipe,pre_read_add9[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_3 = {BX_pipe,pre_read_add10[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_4 = {BX_pipe,pre_read_add11[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_5 = {BX_pipe,pre_read_add12[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_6 = {BX_pipe,pre_read_add13[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_7 = {BX_pipe,pre_read_add14[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_8 = {BX_pipe,pre_read_add15[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_9 = {BX_pipe,pre_read_add16[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_10 = {BX_pipe,pre_read_add17[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_11 = {BX_pipe,pre_read_add18[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_12 = {BX_pipe,pre_read_add19[`MEM_SIZE-1:0]};
    assign read_add_projin_layer_13 = {BX_pipe,pre_read_add20[`MEM_SIZE-1:0]};
    
    
    mem_readout_top_2 #(LD_COMBINATION) send_proj(
        .clk(clk),                  // main clock
        .reset(startdly4),          // synchronously negated active-hi reset
        .BX(BX),                    // BX number
        .BX_pipe(BX_pipe),
        // DISKS
        .number_in1(number_in_projin_disk_1),          // starting number of items for this memory
        .number_in2(number_in_projin_disk_2),          // starting number of items for this memory
        .number_in3(number_in_projin_disk_3),          // starting number of items for this memory
        .number_in4(number_in_projin_disk_4),          // starting number of items for this memory
        .number_in5(number_in_projin_disk_5),          // starting number of items for this memory
        .number_in6(number_in_projin_disk_6),          // starting number of items for this memory
        .number_in7(number_in_projin_disk_7),          // starting number of items for this memory
        // LAYERS
        .number_in8(number_in_projin_layer_1),          // starting number of items for this memory
        .number_in9(number_in_projin_layer_2),          // starting number of items for this memory
        .number_in10(number_in_projin_layer_3),          // starting number of items for this memory
        .number_in11(number_in_projin_layer_4),          // starting number of items for this memory
        .number_in12(number_in_projin_layer_5),          // starting number of items for this memory
        .number_in13(number_in_projin_layer_6),          // starting number of items for this memory
        .number_in14(number_in_projin_layer_7),          // starting number of items for this memory
        .number_in15(number_in_projin_layer_8),          // starting number of items for this memory
        .number_in16(number_in_projin_layer_9),          // starting number of items for this memory
        .number_in17(number_in_projin_layer_10),          // starting number of items for this memory
        .number_in18(number_in_projin_layer_11),          // starting number of items for this memory
        .number_in19(number_in_projin_layer_12),          // starting number of items for this memory
        .number_in20(number_in_projin_layer_13),          // starting number of items for this memory
        
        .input1(projin_disk_1[50:0]),     
        .input2(projin_disk_2[50:0]),     
        .input3(projin_disk_3[50:0]),     
        .input4(projin_disk_4[50:0]),     
        .input5(projin_disk_5[50:0]),     
        .input6(projin_disk_6[50:0]),     
        .input7(projin_disk_7[50:0]),     
        .input8(projin_layer_1[50:0]),     
        .input9(projin_layer_2[50:0]),     
        .input10(projin_layer_3[50:0]),     
        .input11(projin_layer_4[50:0]),     
        .input12(projin_layer_5[50:0]),     
        .input13(projin_layer_6[50:0]),     
        .input14(projin_layer_7[50:0]),     
        .input15(projin_layer_8[50:0]),     
        .input16(projin_layer_9[50:0]),     
        .input17(projin_layer_10[50:0]),     
        .input18(projin_layer_11[50:0]),     
        .input19(projin_layer_12[50:0]),     
        .input20(projin_layer_13[50:0]),     
        
        .read_add1(pre_read_add1),          // lower part of memory address
        .read_add2(pre_read_add2),          // lower part of memory address
        .read_add3(pre_read_add3),          // lower part of memory address
        .read_add4(pre_read_add4),          // lower part of memory address
        .read_add5(pre_read_add5),          // lower part of memory address
        .read_add6(pre_read_add6),          // lower part of memory address
        .read_add7(pre_read_add7),          // lower part of memory address
        .read_add8(pre_read_add8),          // lower part of memory address
        .read_add9(pre_read_add9),          // lower part of memory address
        .read_add10(pre_read_add10),          // lower part of memory address
        .read_add11(pre_read_add11),          // lower part of memory address
        .read_add12(pre_read_add12),          // lower part of memory address
        .read_add13(pre_read_add13),          // lower part of memory address
        .read_add14(pre_read_add14),          // lower part of memory address
        .read_add15(pre_read_add15),          // lower part of memory address
        .read_add16(pre_read_add16),          // lower part of memory address
        .read_add17(pre_read_add17),          // lower part of memory address
        .read_add18(pre_read_add18),          // lower part of memory address
        .read_add19(pre_read_add19),          // lower part of memory address
        .read_add20(pre_read_add20),          // lower part of memory address
        
        .mem_dat_stream(mem_dat_stream),
        .valid(valid),
        .send_BX(send_BX),
        .none(done_sending_proj)                 // no more items
    );
 
    // send the mem_dat_stream and valid signal to the links (pipe to top level)
    always @ (posedge clk) begin
        if(valid) 
            proj_data_stream <= mem_dat_stream[54:0];
        else
            proj_data_stream <= 55'b0;
            
    end

    mem_readin_top #(LD_COMBINATION) get_resid(
        .clk(clk),
        .reset(fifo_rst5),
        .data_residuals(incomming_proj_data_stream[54:0]), //with FIFO: data_output without FIFO: mem_dat_stream_dly2
        .datanull(!valid_incomming_proj_data_stream),      //with FIFO: FIFO_EMPTY  without FIFO: !FIFO_wr_en  

        .output_BX(output_BX),
        .send_BX(BX_sent),

        // 4 layers times 2 dtc regions. This will probably grow later
        .output1(projout_layer_1), //returning residuals for this memory
        .output2(projout_layer_2), //returning residuals for this memory
        .output3(projout_layer_3), //returning residuals for this memory
        .output4(projout_layer_4), //returning residuals for this memory
        .output5(projout_layer_5), //returning residuals for this memory
        .output6(projout_layer_6), //returning residuals for this memory
        .output7(projout_layer_7), //returning residuals for this memory
        .output8(projout_layer_8), //returning residuals for this memory
        .output9(projout_disk_1), //returning residuals for this memory
        .output10(projout_disk_2), //returning residuals for this memory
        .output11(projout_disk_3), //returning residuals for this memory
        .output12(projout_disk_4), //returning residuals for this memory
        .output13(projout_disk_5), //returning residuals for this memory
        .output14(projout_disk_6), //returning residuals for this memory
                    
        .wr_en_layer(valid_layer_pre), //valid signal for writing to memory
        .wr_en_disk(valid_disk_pre) //valid signal for writing to memory
    );
       
       
    initial begin
       BX_pipe = 4'b1111;
    end
    
    always @(posedge clk) begin
       if(rst_pipe) begin
           BX_pipe <= 4'b1111;
       end
       else begin
           if(start[0]) begin
               BX_pipe <= BX_pipe + 1'b1;
           end
       end
    end
 
    pipe_delay #(.STAGES(`LINK_LATENCY-4), .WIDTH(2))
           done_delay(.pipe_in(), .pipe_out(), .clk(clk),
           .val_in(start), .val_out(done));
     
     
endmodule
