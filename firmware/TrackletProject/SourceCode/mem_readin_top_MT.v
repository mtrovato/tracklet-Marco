`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2015 02:18:28 PM
// Design Name: 
// Module Name: mem_readin_top
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

module mem_readin_top_MT(
    input clk,                      // main clock
    input reset,                    // start over
    input [44:0] data_residuals,    // data out from neighboring sector, from FIFO (would be residuals)
    input valid,                 // when FIFO is empty data is not valid
    
    output reg [3:0] output_BX,
    output reg send_BX,
    
    output [39:0] output_match_1,
    output [39:0] output_match_2,
    output [39:0] output_match_3,
    output [39:0] output_match_4,
    output [39:0] output_match_5,
    output [39:0] output_match_6,
    output [39:0] output_match_7,
    output [39:0] output_match_8,
    output [39:0] output_match_9,
    output [39:0] output_match_10,
    output [39:0] output_match_11,
    output [39:0] output_match_12,
    output [39:0] output_match_13,
    output [39:0] output_match_14,
    output [39:0] output_match_15,
    output [39:0] output_match_16,
    output [39:0] output_match_17,
    
    output wr_en_mem01,
    output wr_en_mem02,
    output wr_en_mem03,
    output wr_en_mem04,
    output wr_en_mem05,
    output wr_en_mem06,
    output wr_en_mem07,
    output wr_en_mem08,
    output wr_en_mem09,
    output wr_en_mem10,
    output wr_en_mem11,
    output wr_en_mem12,
    output wr_en_mem13,
    output wr_en_mem14,
    output wr_en_mem15,
    output wr_en_mem16,
    output wr_en_mem17


);
    
    parameter seeding = "Layer";
    
    assign output_match_1 = data_residuals[39:0];
    assign output_match_2 = data_residuals[39:0];
    assign output_match_3 = data_residuals[39:0];
    assign output_match_4 = data_residuals[39:0];
    assign output_match_5 = data_residuals[39:0];
    assign output_match_6 = data_residuals[39:0];
    assign output_match_7 = data_residuals[39:0];
    assign output_match_8 = data_residuals[39:0];
    assign output_match_9 = data_residuals[39:0];
    assign output_match_10 = data_residuals[39:0];
    assign output_match_11 = data_residuals[39:0];
    assign output_match_12 = data_residuals[39:0];
    assign output_match_13 = data_residuals[39:0];
    assign output_match_14 = data_residuals[39:0];
    assign output_match_15 = data_residuals[39:0];
    assign output_match_16 = data_residuals[39:0];
    assign output_match_17 = data_residuals[39:0];
        
generate
    if(seeding == "Layer") begin
        assign wr_en_mem01  = (data_residuals[44:40]==5'b00001); // L1L2_L3D3,L1L2_L3D4
        assign wr_en_mem02  = (data_residuals[44:40]==5'b00010); // L1L2_L4D3,L1L2_L4D4
        assign wr_en_mem03  = (data_residuals[44:40]==5'b00011); // L1L2_L5D3,L1L2_L5D4
        assign wr_en_mem04  = (data_residuals[44:40]==5'b00100); // L1L2_L6D3,L1L2_L6D4
        
        assign wr_en_mem05  = (data_residuals[44:40]==5'b00101); // L3L4_L1D3,L3L4_L1D4
        assign wr_en_mem06  = (data_residuals[44:40]==5'b00110); // L3L4_L2D3,L3L4_L2D4
        assign wr_en_mem07  = (data_residuals[44:40]==5'b00111); // L3L4_L5D3,L3L4_L5D4
        assign wr_en_mem08  = (data_residuals[44:40]==5'b01000); // L3L4_L6D3,L3L4_L6D4
        
        assign wr_en_mem09  = (data_residuals[44:40]==5'b01001) & (data_residuals[39:36] != 4'b0111) ; // L5L6_L1D3,L5L6_L1D4 // CHECK TRACKLET INDEX
        assign wr_en_mem10  = (data_residuals[44:40]==5'b01010) & (data_residuals[39:36] != 4'b0111) ; // L5L6_L2D3,L5L6_L2D4 // CHECK TRACKLET INDEX
        assign wr_en_mem11  = (data_residuals[44:40]==5'b01011); // L5L6_L3D3,L5L6_L3D4
        assign wr_en_mem12  = (data_residuals[44:40]==5'b01100); // L5L6_L4D3,L5L6_L4D4
        
        assign wr_en_mem13  = (data_residuals[44:40]==5'b01001) & (data_residuals[39:36] == 4'b0111) ; // F1F2_L1D3,F1F2_L1D4 // CHECK TRACKLET INDEX
        assign wr_en_mem14  = (data_residuals[44:40]==5'b01010) & (data_residuals[39:36] == 4'b0111) ; // F1F2_L2D3,F1F2_L2D4 // CHECK TRACKLET INDEX
        assign wr_en_mem15  = 1'b0;
        assign wr_en_mem16  = 1'b0;
        assign wr_en_mem17  = 1'b0;
    end
    if(seeding == "Disk") begin
        assign wr_en_mem01  = (data_residuals[44:40]==5'b00001) & (data_residuals[39:36] == 4'b0111) ; // F1F2_F3D5,F1F2_F3D6 // CHECK TRACKLET INDEX
        assign wr_en_mem02  = (data_residuals[44:40]==5'b00010) & (data_residuals[39:36] == 4'b0111) ; // F1F2_F4D5,F1F2_F4D6 // CHECK TRACKLET INDEX
        assign wr_en_mem03  = (data_residuals[44:40]==5'b00011) & (data_residuals[39:36] == 4'b0111) ; // F1F2_F5D5,F1F2_F5D6 // CHECK TRACKLET INDEX
                
        assign wr_en_mem04  = (data_residuals[44:40]==5'b00100) & (data_residuals[39:36] == 4'b0111) ; // F3F4_F1D5,F3F4_F1D6 // CHECK TRACKLET INDEX
        assign wr_en_mem05  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] == 4'b0111) ; // F3F4_F2D5,F3F4_F2D6 // CHECK TRACKLET INDEX
        assign wr_en_mem06  = (data_residuals[44:40]==5'b00110) & (data_residuals[39:36] == 4'b0111) ; // F3F4_F5D5,F3F4_F5D6 // CHECK TRACKLET INDEX
        
        assign wr_en_mem07  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F2D5,F1L1_F2D6 // CHECK TRACKLET INDEX
        assign wr_en_mem08  = (data_residuals[44:40]==5'b00001) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F3D5,F1L1_F3D6 // CHECK TRACKLET INDEX
        assign wr_en_mem09  = (data_residuals[44:40]==5'b00010) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F4D5,F1L1_F4D6 // CHECK TRACKLET INDEX
        assign wr_en_mem10  = (data_residuals[44:40]==5'b00011) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F5D5,F1L1_F5D6 // CHECK TRACKLET INDEX
        
        assign wr_en_mem11  = (data_residuals[44:40]==5'b00100) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F1D5,L1L2_F1D6 // CHECK TRACKLET INDEX // CHECK LAYERS
        assign wr_en_mem12  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F2D5,L1L2_F2D6 // CHECK TRACKLET INDEX // CHECK LAYERS       
        assign wr_en_mem13  = (data_residuals[44:40]==5'b00001) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F3D5,L1L1_F3D6 // CHECK TRACKLET INDEX
        assign wr_en_mem14  = (data_residuals[44:40]==5'b00010) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F4D5,L1L2_F4D6 // CHECK TRACKLET INDEX
        assign wr_en_mem15  = (data_residuals[44:40]==5'b00110) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F5D5,L1L2_F5D6 // CHECK TRACKLET INDEX

        assign wr_en_mem16  = (data_residuals[44:40]==5'b00100) & (data_residuals[39:36] > 4'b0010) & (data_residuals[39:36] < 4'b0110) ; // L3L4_F1D5,L3L4_F1D6 // CHECK TRACKLET INDEX // CHECK LAYERS
        assign wr_en_mem17  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] > 4'b0010) & (data_residuals[39:36] < 4'b0110) ; // L3L4_F2D5,L3L4_F2D6 // CHECK TRACKLET INDEX // CHECK LAYERS           
    end
    if(seeding == "Hybrid") begin
        assign wr_en_mem01  = (data_residuals[44:40]==5'b00100) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F1D5,L1L2_F1D6 // CHECK TRACKLET INDEX // CHECK LAYERS
        assign wr_en_mem02  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F2D5,L1L2_F2D6 // CHECK TRACKLET INDEX // CHECK LAYERS       
        assign wr_en_mem03  = (data_residuals[44:40]==5'b00001) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F3D5,L1L1_F3D6 // CHECK TRACKLET INDEX
        assign wr_en_mem04  = (data_residuals[44:40]==5'b00010) & (data_residuals[39:36] <= 4'b0010) ; // L1L2_F4D5,L1L2_F4D6 // CHECK TRACKLET INDEX
 
        assign wr_en_mem05  = (data_residuals[44:40]==5'b00100) & (data_residuals[39:36] > 4'b0010) & (data_residuals[39:36] < 4'b0110) ; // L3L4_F1D5,L3L4_F1D6 // CHECK TRACKLET INDEX // CHECK LAYERS
        assign wr_en_mem06  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] > 4'b0010) & (data_residuals[39:36] < 4'b0110) ; // L3L4_F2D5,L3L4_F2D6 // CHECK TRACKLET INDEX // CHECK LAYERS     
    
        assign wr_en_mem07  = (data_residuals[44:40]==5'b00001) & (data_residuals[39:36] == 4'b0111) ; // F1F2_F3D5,F1F2_F3D6 // CHECK TRACKLET INDEX
        assign wr_en_mem08  = (data_residuals[44:40]==5'b00010) & (data_residuals[39:36] == 4'b0111) ; // F1F2_F4D5,F1F2_F4D6 // CHECK TRACKLET INDEX
        assign wr_en_mem09  = (data_residuals[44:40]==5'b00011) & (data_residuals[39:36] == 4'b0111) ; // F1F2_F5D5,F1F2_F5D6 // CHECK TRACKLET INDEX
    
        assign wr_en_mem10  = (data_residuals[44:40]==5'b00100) & (data_residuals[39:36] == 4'b0111) ; // F3F4_F1D5,F3F4_F1D6 // CHECK TRACKLET INDEX
        assign wr_en_mem11  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] == 4'b0111) ; // F3F4_F2D5,F3F4_F2D6 // CHECK TRACKLET INDEX
        assign wr_en_mem12  = (data_residuals[44:40]==5'b00110) & (data_residuals[39:36] == 4'b0111) ; // F3F4_F5D5,F3F4_F5D6 // CHECK TRACKLET INDEX
    
        assign wr_en_mem13  = (data_residuals[44:40]==5'b00101) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F2D5,F1L1_F2D6 // CHECK TRACKLET INDEX
        assign wr_en_mem14  = (data_residuals[44:40]==5'b00001) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F3D5,F1L1_F3D6 // CHECK TRACKLET INDEX
        assign wr_en_mem15  = (data_residuals[44:40]==5'b00010) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F4D5,F1L1_F4D6 // CHECK TRACKLET INDEX
        assign wr_en_mem16  = (data_residuals[44:40]==5'b00011) & (data_residuals[39:36] == 4'b0110) ; // F1L1_F5D5,F1L1_F5D6 // CHECK TRACKLET INDEX
    end
endgenerate
    
endmodule
