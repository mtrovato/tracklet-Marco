`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 03:16:21 PM
// Design Name: 
// Module Name: VMRouters
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


module VMRouter(
    input clk,
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in_stubinLink1,
    output reg [`MEM_SIZE+2:0] read_add_stubinLink1,
    input [35:0] stubinLink1,
    input [5:0] number_in_stubinLink2,
    output reg [`MEM_SIZE+2:0] read_add_stubinLink2,
    input [35:0] stubinLink2,
    input [5:0] number_in_stubinLink3,
    output reg [`MEM_SIZE+2:0] read_add_stubinLink3,
    input [35:0] stubinLink3,
    
    output reg [35:0] allstuboutn1,
    output [35:0] allstuboutn2,
    output [35:0] allstuboutn3,
    output [35:0] allstuboutn4,
    
    output [18:0] vmstuboutPHI1X1n1,
    output [18:0] vmstuboutPHI1X1n2,
    output [18:0] vmstuboutPHI1X1n3,
    output [18:0] vmstuboutPHI1X1n4,
    output [18:0] vmstuboutPHI1X1n5,
    output [18:0] vmstuboutPHI1X1n6,
    output [18:0] vmstuboutPHI1X1n7,
    output [18:0] vmstuboutPHI1X1n8,
    output [18:0] vmstuboutPHI1X2n1,
    output [18:0] vmstuboutPHI1X2n2,
    output [18:0] vmstuboutPHI1X2n3,
    output [18:0] vmstuboutPHI1X2n4,
    output [18:0] vmstuboutPHI1X2n5,
    output [18:0] vmstuboutPHI1X2n6,
    output [18:0] vmstuboutPHI1X2n7,
    output [18:0] vmstuboutPHI1X2n8,
    
    output [18:0] vmstuboutPHI2X1n1,
    output [18:0] vmstuboutPHI2X1n2,
    output [18:0] vmstuboutPHI2X1n3,
    output [18:0] vmstuboutPHI2X1n4,
    output [18:0] vmstuboutPHI2X1n5,
    output [18:0] vmstuboutPHI2X1n6,
    output [18:0] vmstuboutPHI2X1n7,
    output [18:0] vmstuboutPHI2X1n8,
    output [18:0] vmstuboutPHI2X1n9,
    output [18:0] vmstuboutPHI2X2n1,
    output [18:0] vmstuboutPHI2X2n2,
    output [18:0] vmstuboutPHI2X2n3,
    output [18:0] vmstuboutPHI2X2n4,
    output [18:0] vmstuboutPHI2X2n5,
    output [18:0] vmstuboutPHI2X2n6,
    output [18:0] vmstuboutPHI2X2n7,
    output [18:0] vmstuboutPHI2X2n8,
    
    output [18:0] vmstuboutPHI3X1n1,
    output [18:0] vmstuboutPHI3X1n2,
    output [18:0] vmstuboutPHI3X1n3,
    output [18:0] vmstuboutPHI3X1n4,
    output [18:0] vmstuboutPHI3X1n5,
    output [18:0] vmstuboutPHI3X1n6,
    output [18:0] vmstuboutPHI3X1n7,
    output [18:0] vmstuboutPHI3X1n8,
    output [18:0] vmstuboutPHI3X1n9,
    output [18:0] vmstuboutPHI3X2n1,
    output [18:0] vmstuboutPHI3X2n2,
    output [18:0] vmstuboutPHI3X2n3,
    output [18:0] vmstuboutPHI3X2n4,
    output [18:0] vmstuboutPHI3X2n5,
    output [18:0] vmstuboutPHI3X2n6,
    output [18:0] vmstuboutPHI3X2n7,
    output [18:0] vmstuboutPHI3X2n8,
        
    output [18:0] vmstuboutPHI4X1n1,
    output [18:0] vmstuboutPHI4X1n2,
    output [18:0] vmstuboutPHI4X1n3,
    output [18:0] vmstuboutPHI4X1n4,
    output [18:0] vmstuboutPHI4X1n5,
    output [18:0] vmstuboutPHI4X2n1,
    output [18:0] vmstuboutPHI4X2n2,
    output [18:0] vmstuboutPHI4X2n3,
    output [18:0] vmstuboutPHI4X2n4,
    
    output vmstuboutPHI1X1n1_wr_en,
    output vmstuboutPHI1X1n2_wr_en,
    output vmstuboutPHI1X1n3_wr_en,
    output vmstuboutPHI1X1n4_wr_en,
    output vmstuboutPHI1X1n5_wr_en,
    output vmstuboutPHI1X1n6_wr_en,
    output vmstuboutPHI1X1n7_wr_en,
    output vmstuboutPHI1X1n8_wr_en,
    output vmstuboutPHI1X2n1_wr_en,
    output vmstuboutPHI1X2n2_wr_en,
    output vmstuboutPHI1X2n3_wr_en,
    output vmstuboutPHI1X2n4_wr_en,
    output vmstuboutPHI1X2n5_wr_en,
    output vmstuboutPHI1X2n6_wr_en,
    output vmstuboutPHI1X2n7_wr_en,
    output vmstuboutPHI1X2n8_wr_en,
    
    output vmstuboutPHI2X1n1_wr_en,
    output vmstuboutPHI2X1n2_wr_en,
    output vmstuboutPHI2X1n3_wr_en,
    output vmstuboutPHI2X1n4_wr_en,
    output vmstuboutPHI2X1n5_wr_en,
    output vmstuboutPHI2X1n6_wr_en,
    output vmstuboutPHI2X1n7_wr_en,
    output vmstuboutPHI2X1n8_wr_en,
    output vmstuboutPHI2X1n9_wr_en,
    output vmstuboutPHI2X2n1_wr_en,
    output vmstuboutPHI2X2n2_wr_en,
    output vmstuboutPHI2X2n3_wr_en,
    output vmstuboutPHI2X2n4_wr_en,
    output vmstuboutPHI2X2n5_wr_en,
    output vmstuboutPHI2X2n6_wr_en,
    output vmstuboutPHI2X2n7_wr_en,
    output vmstuboutPHI2X2n8_wr_en,
    
    output vmstuboutPHI3X1n1_wr_en,
    output vmstuboutPHI3X1n2_wr_en,
    output vmstuboutPHI3X1n3_wr_en,
    output vmstuboutPHI3X1n4_wr_en,
    output vmstuboutPHI3X1n5_wr_en,
    output vmstuboutPHI3X1n6_wr_en,
    output vmstuboutPHI3X1n7_wr_en,
    output vmstuboutPHI3X1n8_wr_en,
    output vmstuboutPHI3X1n9_wr_en,
    output vmstuboutPHI3X2n1_wr_en,
    output vmstuboutPHI3X2n2_wr_en,
    output vmstuboutPHI3X2n3_wr_en,
    output vmstuboutPHI3X2n4_wr_en,
    output vmstuboutPHI3X2n5_wr_en,
    output vmstuboutPHI3X2n6_wr_en,
    output vmstuboutPHI3X2n7_wr_en,
    output vmstuboutPHI3X2n8_wr_en,
        
    output vmstuboutPHI4X1n1_wr_en,
    output vmstuboutPHI4X1n2_wr_en,
    output vmstuboutPHI4X1n3_wr_en,
    output vmstuboutPHI4X1n4_wr_en,
    output vmstuboutPHI4X1n5_wr_en,
    output vmstuboutPHI4X2n1_wr_en,
    output vmstuboutPHI4X2n2_wr_en,
    output vmstuboutPHI4X2n3_wr_en,
    output vmstuboutPHI4X2n4_wr_en,

       
    output reg valid_data1,
    output reg valid_data2,
    output reg valid_data3,
    output reg valid_data4
    
    );
    

	///////////////////////////////////////////////
    reg [2:0] BX_pipe;
    reg first_clk_pipe;
    
    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset   
     
    initial begin
       BX_pipe = 3'b111;
    end
    
    always @(posedge clk) begin
        if (rst_pipe)
            BX_pipe <= 3'b111;
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
    
    
    parameter INNER = 1'b1;
    parameter ODD = 1'b1;
    parameter BARREL =1'b1;    

    pipe_delay #(.STAGES(4), .WIDTH(2))
       done_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(start), .val_out(done));
           
    ///////////////////////////////////////////////////
    wire vmstuboutPHI1X1_en;
    wire vmstuboutPHI1X2_en;  
    wire vmstuboutPHI2X1_en;
    wire vmstuboutPHI2X2_en;
    wire vmstuboutPHI3X1_en;
    wire vmstuboutPHI3X2_en;
    wire vmstuboutPHI4X1_en;
    wire vmstuboutPHI4X2_en;
    
    assign vmstuboutPHI1X1n1_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n2_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n3_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n4_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n5_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n6_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n7_wr_en=vmstuboutPHI1X1_en;
    assign vmstuboutPHI1X1n8_wr_en=vmstuboutPHI1X1_en;
        
    assign vmstuboutPHI1X2n1_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n2_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n3_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n4_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n5_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n6_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n7_wr_en=vmstuboutPHI1X2_en;
    assign vmstuboutPHI1X2n8_wr_en=vmstuboutPHI1X2_en;
    
    assign vmstuboutPHI2X1n1_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n2_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n3_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n4_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n5_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n6_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n7_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n8_wr_en=vmstuboutPHI2X1_en;
    assign vmstuboutPHI2X1n9_wr_en=vmstuboutPHI2X1_en;
    
    assign vmstuboutPHI2X2n1_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n2_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n3_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n4_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n5_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n6_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n7_wr_en=vmstuboutPHI2X2_en;
    assign vmstuboutPHI2X2n8_wr_en=vmstuboutPHI2X2_en;
    
    assign vmstuboutPHI3X1n1_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n2_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n3_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n4_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n5_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n6_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n7_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n8_wr_en=vmstuboutPHI3X1_en;
    assign vmstuboutPHI3X1n9_wr_en=vmstuboutPHI3X1_en;
    
    assign vmstuboutPHI3X2n1_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n2_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n3_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n4_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n5_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n6_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n7_wr_en=vmstuboutPHI3X2_en;
    assign vmstuboutPHI3X2n8_wr_en=vmstuboutPHI3X2_en;
        
    assign vmstuboutPHI4X1n1_wr_en=vmstuboutPHI4X1_en;
    assign vmstuboutPHI4X1n2_wr_en=vmstuboutPHI4X1_en;
    assign vmstuboutPHI4X1n3_wr_en=vmstuboutPHI4X1_en;
    assign vmstuboutPHI4X1n4_wr_en=vmstuboutPHI4X1_en;   
    assign vmstuboutPHI4X1n5_wr_en=vmstuboutPHI4X1_en;   
    assign vmstuboutPHI4X2n1_wr_en=vmstuboutPHI4X2_en;
    assign vmstuboutPHI4X2n2_wr_en=vmstuboutPHI4X2_en;
    assign vmstuboutPHI4X2n3_wr_en=vmstuboutPHI4X2_en;
    assign vmstuboutPHI4X2n4_wr_en=vmstuboutPHI4X2_en;
    
    reg [5:0] index;
    reg [18:0] vmstubout;
    reg pre_valid_data;
    reg index_valid_data;
    reg [4:0] behold;
    reg [1:0] link;
    reg [1:0] link_dly;
    reg [1:0] link_dly2;
    reg [1:0] link_dly3;
    
    initial begin
        read_add_stubinLink1 = {`MEM_SIZE+3{1'b1}};
        read_add_stubinLink2 = {`MEM_SIZE+3{1'b1}};
        read_add_stubinLink3 = {`MEM_SIZE+3{1'b1}};
        index = 6'h0;
        link = 2'b00;
    end
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_data;
        behold[3:1] <= behold[2:0];
        valid_data1 <= behold[1];
        valid_data2 <= behold[1];
        valid_data3 <= behold[1];
        valid_data4 <= behold[1];
        index_valid_data <= behold[0];
                
        if(first_clk_pipe) begin
            read_add_stubinLink1 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_stubinLink2 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_stubinLink3 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
        end
        else begin
            if(number_in_stubinLink1>0 | number_in_stubinLink2>0 | number_in_stubinLink3>0) begin
                if(read_add_stubinLink1[`MEM_SIZE-1:0] + 1'b1 < number_in_stubinLink1[`MEM_SIZE-1:0]) begin
                    read_add_stubinLink1[`MEM_SIZE-1:0] <= read_add_stubinLink1[`MEM_SIZE-1:0] + 1'b1;
                    pre_valid_data <= 1'b1;
                    link <= 2'b01;
                end
                else begin
                    read_add_stubinLink1 <= read_add_stubinLink1;
                    if(read_add_stubinLink2[`MEM_SIZE-1:0] + 1'b1 < number_in_stubinLink2[`MEM_SIZE-1:0]) begin
                        read_add_stubinLink2[`MEM_SIZE-1:0] <= read_add_stubinLink2[`MEM_SIZE-1:0] + 1'b1;
                        pre_valid_data <= 1'b1;
                        link <= 2'b10;
                    end
                    else begin
                        read_add_stubinLink2 <= read_add_stubinLink2;
                        if(read_add_stubinLink3[`MEM_SIZE-1:0] + 1'b1 < number_in_stubinLink3[`MEM_SIZE-1:0]) begin
                            read_add_stubinLink3[`MEM_SIZE-1:0] <= read_add_stubinLink3[`MEM_SIZE-1:0] + 1'b1;
                            pre_valid_data <= 1'b1;
                            link <= 2'b11;
                        end
                        else begin
                            read_add_stubinLink3 <= read_add_stubinLink3;
                            pre_valid_data <= 1'b0;
                        end
                    end
                end
            end
            else
                pre_valid_data <= 1'b0;
        end
    end
    
    ///////////////////////////////////////////////////////////////////////////
    
    reg [35:0] stubin;
    reg [35:0] stubin1;
    reg valid_data_dly;
            
    always @(posedge clk) begin
        link_dly  <= link;
        link_dly2 <= link_dly;
        link_dly3 <= link_dly2;
        if(link_dly == 2'b01)
            stubin <= stubinLink1;
        else if(link_dly == 2'b10)
            stubin <= stubinLink2;
        else if(link_dly == 2'b11)
            stubin <= stubinLink3;
        
        stubin1 <= stubin;
        
//        if(stubinLink3 != 0)
//            stubin <= stubinLink3;
//        else begin
//            if(stubinLink2 != 0)
//                stubin <= stubinLink2;
//            else begin
//                if(stubinLink1 != 0)
//                    stubin <= stubinLink1;
//                else 
//                    stubin <= 0; 
//            end
//        end
        if(done[0]) begin
            index <= 6'h0;
        end
        else begin
            if(index_valid_data)
                index <= index + 1'b1;
            else
                index <= index;
        end
            allstuboutn1[35:33] <= stubin[2:0];
            allstuboutn1[32:0]  <= stubin[35:3];
    end
    
    ///////////////////////////////////////////////////////////////////////////
    reg [18:0] vmstubout_dly;

    assign allstuboutn2 = allstuboutn1;
    assign allstuboutn3 = allstuboutn1;
    assign allstuboutn4 = allstuboutn1;
    
    assign vmstuboutPHI1X1n1 = vmstubout_dly;
    assign vmstuboutPHI1X1n2 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n3 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n4 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n5 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n6 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n7 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n8 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X2n1 = vmstubout_dly;
    assign vmstuboutPHI1X2n2 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n3 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n4 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n5 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n6 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n7 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n8 = vmstuboutPHI1X2n1;
        
    assign vmstuboutPHI2X1n1 = vmstubout_dly;
    assign vmstuboutPHI2X1n2 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n3 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n4 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n5 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n6 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n7 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n8 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n9 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X2n1 = vmstubout_dly;
    assign vmstuboutPHI2X2n2 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n3 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n4 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n5 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n6 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n7 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n8 = vmstuboutPHI2X2n1;

    assign vmstuboutPHI3X1n1 = vmstubout_dly;        
    assign vmstuboutPHI3X1n2 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n3 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n4 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n5 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n6 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n7 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n8 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n9 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X2n1 = vmstubout_dly;
    assign vmstuboutPHI3X2n2 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n3 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n4 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n5 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n6 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n7 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n8 = vmstuboutPHI3X2n1;
            
    assign vmstuboutPHI4X1n1 = vmstubout_dly;
    assign vmstuboutPHI4X1n2 = vmstuboutPHI4X1n1;
    assign vmstuboutPHI4X1n3 = vmstuboutPHI4X1n1;
    assign vmstuboutPHI4X1n4 = vmstuboutPHI4X1n1;
    assign vmstuboutPHI4X1n5 = vmstuboutPHI4X1n1;
    assign vmstuboutPHI4X2n1 = vmstubout_dly;
    assign vmstuboutPHI4X2n2 = vmstuboutPHI4X2n1;
    assign vmstuboutPHI4X2n3 = vmstuboutPHI4X2n1;
    assign vmstuboutPHI4X2n4 = vmstuboutPHI4X2n1;
    
    ////////////////////////////////////////////////////////////////////////////
    
    reg pre_vmstuboutPHI1X1_en;
    reg pre_vmstuboutPHI1X2_en;
    reg pre_vmstuboutPHI2X1_en;
    reg pre_vmstuboutPHI2X2_en;
    reg pre_vmstuboutPHI3X1_en;
    reg pre_vmstuboutPHI3X2_en;
    reg pre_vmstuboutPHI4X1_en;
    reg pre_vmstuboutPHI4X2_en;
    
    assign vmstuboutPHI1X1_en = pre_vmstuboutPHI1X1_en & valid_data_dly;
    assign vmstuboutPHI1X2_en = pre_vmstuboutPHI1X2_en & valid_data_dly;
    assign vmstuboutPHI2X1_en = pre_vmstuboutPHI2X1_en & valid_data_dly;
    assign vmstuboutPHI2X2_en = pre_vmstuboutPHI2X2_en & valid_data_dly;
    assign vmstuboutPHI3X1_en = pre_vmstuboutPHI3X1_en & valid_data_dly;
    assign vmstuboutPHI3X2_en = pre_vmstuboutPHI3X2_en & valid_data_dly;
    assign vmstuboutPHI4X1_en = pre_vmstuboutPHI4X1_en & valid_data_dly;
    assign vmstuboutPHI4X2_en = pre_vmstuboutPHI4X2_en & valid_data_dly;

    reg done_dly;
    always @(posedge clk) begin
        done_dly <= done[0];
        valid_data_dly <= valid_data1 & !done_dly;
        vmstubout_dly <= vmstubout;
    end

    generate
    if(INNER & BARREL) begin
        always @(posedge clk) begin     
            vmstubout[18:16] <= stubin[2:0];     
            vmstubout[15:10]  <= index;
            vmstubout[9]    <= 1'b0;
            vmstubout[8:5]   <= stubin[25:22];
            vmstubout[4:2]   <= {ODD ^ stubin[14],stubin[13:12]};
            vmstubout[1:0]   <= stubin[35:34];
            if(stubin1 != 0 & allstuboutn1[23] == 1'b0 & (allstuboutn1[13:11] == (3'b000 + ODD) | allstuboutn1[13:11] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0; 
            if(allstuboutn1[23] == 1'b0 & (allstuboutn1[13:11] == (3'b010 + ODD) | allstuboutn1[13:11] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(allstuboutn1[23] == 1'b0 & (allstuboutn1[13:11] == (3'b100 + ODD) | allstuboutn1[13:11] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(allstuboutn1[23] == 1'b0 & (allstuboutn1[13:11] == (3'b110 + ODD) | allstuboutn1[13:11] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(allstuboutn1[23] == 1'b1 & (allstuboutn1[13:11] == (3'b000 + ODD) | allstuboutn1[13:11] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(allstuboutn1[23] == 1'b1 & (allstuboutn1[13:11] == (3'b010 + ODD) | allstuboutn1[13:11] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(allstuboutn1[23] == 1'b1 & (allstuboutn1[13:11] == (3'b100 + ODD) | allstuboutn1[13:11] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(allstuboutn1[23] == 1'b1 & (allstuboutn1[13:11] == (3'b110 + ODD) | allstuboutn1[13:11] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
    end
    else if(!INNER & BARREL) begin
        always @(posedge clk) begin
            vmstubout[18:16] <= stubin[2:0];
            vmstubout[15:10]  <= index;
            vmstubout[9]    <= 1'b0;
            vmstubout[8:5]   <= stubin[24:21];
            vmstubout[4:2]   <= {ODD ^ stubin[17],stubin[16:15]};
            vmstubout[1:0]   <= stubin[35:34];
            if(stubin1 != 0 & allstuboutn1[22] == 1'b0 & (allstuboutn1[16:14] == (3'b000 + ODD) | allstuboutn1[16:14] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0;
            if(allstuboutn1[22] == 1'b0 & (allstuboutn1[16:14] == (3'b010 + ODD) | allstuboutn1[16:14] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(allstuboutn1[22] == 1'b0 & (allstuboutn1[16:14] == (3'b100 + ODD) | allstuboutn1[16:14] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(allstuboutn1[22] == 1'b0 & (allstuboutn1[16:14] == (3'b110 + ODD) | allstuboutn1[16:14] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(allstuboutn1[22] == 1'b1 & (allstuboutn1[16:14] == (3'b000 + ODD) | allstuboutn1[16:14] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(allstuboutn1[22] == 1'b1 & (allstuboutn1[16:14] == (3'b010 + ODD) | allstuboutn1[16:14] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(allstuboutn1[22] == 1'b1 & (allstuboutn1[16:14] == (3'b100 + ODD) | allstuboutn1[16:14] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(allstuboutn1[22] == 1'b1 & (allstuboutn1[16:14] == (3'b110 + ODD) | allstuboutn1[16:14] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
    end
    else if(INNER & !BARREL) begin
        always @(posedge clk) begin
            vmstubout[18:16] <= stubin[2:0];     
            vmstubout[15:10]  <= index;
            vmstubout[9:8]   <= stubin[23:22];
            vmstubout[7:5]   <= {!ODD ^ stubin[14],stubin[13:12]};
            vmstubout[4:0]   <= stubin[33:29];// used to be [32:29] but it is [33:30] that matches the emulation
            if(stubin1 != 0 & allstuboutn1[31] == 1'b0 & (allstuboutn1[13:11] == (3'b000 + !ODD) | allstuboutn1[13:11] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0; 
            if(allstuboutn1[31] == 1'b0 & (allstuboutn1[13:11] == (3'b010 + !ODD) | allstuboutn1[13:11] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(allstuboutn1[31] == 1'b0 & (allstuboutn1[13:11] == (3'b100 + !ODD) | allstuboutn1[13:11] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(allstuboutn1[31] == 1'b0 & (allstuboutn1[13:11] == (3'b110 + !ODD) | allstuboutn1[13:11] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(allstuboutn1[31] == 1'b1 & (allstuboutn1[13:11] == (3'b000 + !ODD) | allstuboutn1[13:11] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(allstuboutn1[31] == 1'b1 & (allstuboutn1[13:11] == (3'b010 + !ODD) | allstuboutn1[13:11] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(allstuboutn1[31] == 1'b1 & (allstuboutn1[13:11] == (3'b100 + !ODD) | allstuboutn1[13:11] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(allstuboutn1[31] == 1'b1 & (allstuboutn1[13:11] == (3'b110 + !ODD) | allstuboutn1[13:11] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
    end
    else if(!INNER & !BARREL) begin 
        always @(posedge clk) begin
             
            vmstubout[18:16] <= stubin[2:0];
            vmstubout[15:10]  <= index;
            vmstubout[9:8]   <= stubin[20:19];
            vmstubout[7:5]   <= {!ODD ^ stubin[14],stubin[13:12]};
            vmstubout[4:0]   <= stubin[25:21];
                     
        
            /*
            vmstubout[17:15] <= stubin[2:0];
            vmstubout[14:9]  <= index;
            vmstubout[8:7]   <= stubin[20:19];
            vmstubout[6:4]   <= {!ODD ^ stubin[14],stubin[13:12]};
            vmstubout[3:0]   <= stubin[24:21];
            */
            if(allstuboutn1 != 0 & allstuboutn1[24] == 1'b0 & (allstuboutn1[13:11] == (3'b000 + !ODD) | allstuboutn1[13:11] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0;
            if(allstuboutn1[24] == 1'b0 & (allstuboutn1[13:11] == (3'b010 + !ODD) | allstuboutn1[13:11] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(allstuboutn1[24] == 1'b0 & (allstuboutn1[13:11] == (3'b100 + !ODD) | allstuboutn1[13:11] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(allstuboutn1[24] == 1'b0 & (allstuboutn1[13:11] == (3'b110 + !ODD) | allstuboutn1[13:11] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(allstuboutn1[24] == 1'b1 & (allstuboutn1[13:11] == (3'b000 + !ODD) | allstuboutn1[13:11] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(allstuboutn1[24] == 1'b1 & (allstuboutn1[13:11] == (3'b010 + !ODD) | allstuboutn1[13:11] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(allstuboutn1[24] == 1'b1 & (allstuboutn1[13:11] == (3'b100 + !ODD) | allstuboutn1[13:11] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(allstuboutn1[24] == 1'b1 & (allstuboutn1[13:11] == (3'b110 + !ODD) | allstuboutn1[13:11] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
    end
    endgenerate
    
endmodule
