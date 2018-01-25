`timescale 1ns / 1ps
`include "constants.vh"
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

module mem_readin_top(
    input clk,                      // main clock
    input reset,                // start over
    input [54:0] data_residuals,    // data out from neighboring sector, from FIFO (would be residuals)
    input datanull,                  // when FIFO is empty data is not valid
    
    output reg [3:0] output_BX,
    output reg send_BX,
    
    output reg [53:0] output1,
    output reg [53:0] output2,
    output reg [53:0] output3,
    output reg [53:0] output4,
    output reg [53:0] output5,
    output reg [53:0] output6,
    output reg [53:0] output7,
    output reg [53:0] output8,
    output reg [53:0] output9,
    output reg [53:0] output10,
    output reg [53:0] output11,
    output reg [53:0] output12,
    output reg [53:0] output13,
    output reg [53:0] output14,
        
    output [7:0] wr_en_layer,
    output [7:0] wr_en_disk

);

parameter LD_COMBINATION = "L3F3F5";

    reg [54:0] data_residuals_dly;
    wire [2:0] layer_index;

    always @ (posedge clk) begin
        data_residuals_dly <= data_residuals;
        output1 <= {layer_index,data_residuals_dly[50:0]};
        output2 <= {layer_index,data_residuals_dly[50:0]};
        output3 <= {layer_index,data_residuals_dly[50:0]};
        output4 <= {layer_index,data_residuals_dly[50:0]};
        output5 <= {layer_index,data_residuals_dly[50:0]};
        output6 <= {layer_index,data_residuals_dly[50:0]};
        output7 <= {layer_index,data_residuals_dly[50:0]};
        output8 <= {layer_index,data_residuals_dly[50:0]};
        output9 <= {layer_index,data_residuals_dly[50:0]};
        output10 <= {layer_index,data_residuals_dly[50:0]};
        output11 <= {layer_index,data_residuals_dly[50:0]};
        output12 <= {layer_index,data_residuals_dly[50:0]};
        output13 <= {layer_index,data_residuals_dly[50:0]};
        output14 <= {layer_index,data_residuals_dly[50:0]};
    end
    
    reg D3_inner; // store if projection from neighboring sector goes to D3 region
    reg D3_outer; // store if projection from neighboring sector goes to D3 region
    reg D4_inner; // store if projection from neighboring sector goes to D4 region
    reg D4_outer; // store if projection from neighboring sector goes to D4 region
    reg D5; // store if projection from neighboring sector goes to D5 region
    reg D6; // store if projection from neighboring sector goes to D6 region
    always @ (posedge clk) begin
        // look at projection for each layer if in D3 region
        D3_inner <= (data_residuals[`ZD_L1+`PHID_L1+`Z_L1-2] == 1'b0)&(data_residuals[54] == 1'b0);
        D3_outer <= (data_residuals[`ZD_L4+`PHID_L4+`Z_L4-2] == 1'b0)&(data_residuals[54] == 1'b0);
        // look at projection for each layer if in D4 region
        D4_inner <= (data_residuals[`ZD_L1+`PHID_L1+`Z_L1-2] == 1'b1)&(data_residuals[54] == 1'b0);
        D4_outer <= (data_residuals[`ZD_L4+`PHID_L4+`Z_L4-2] == 1'b1)&(data_residuals[54] == 1'b0);
        // look at projection for each disk if in D5 region
        D5 <= (data_residuals[25]==1'b0)&(data_residuals[54] == 1'b1);
        // look at projection for each disk if in D6 region
        D6 <= (data_residuals[25]==1'b1)&(data_residuals[54] == 1'b1);
    end
    
    // final logic that combines both disk and layer logic
generate
    if(LD_COMBINATION == "L3F3F5") begin
        assign layer_index = 3'b111;
        // LAYERS
        assign wr_en_layer[0]  = D3_inner & (data_residuals_dly[53:51]==3'b100); // L3D3_L1L2
        assign wr_en_layer[1]  = D4_inner & (data_residuals_dly[53:51]==3'b100); // L3D4_L1L2
        assign wr_en_layer[2]  = D3_inner & (data_residuals_dly[53:51]==3'b101); // L3D3_L5L6
        assign wr_en_layer[3]  = D4_inner & (data_residuals_dly[53:51]==3'b101); // L3D4_L5L6
        // DISKS
        assign wr_en_disk[0]  = D5 & (data_residuals_dly[53:51]==3'b010); // F3D5_F1F2,F3D5_F1L1,F3D5_L1L2
        assign wr_en_disk[1]  = D6 & (data_residuals_dly[53:51]==3'b010); // F3D6_F1F2,F3D6_F1L1,F3D6_L1L2
        
        assign wr_en_disk[2]  = D5 & (data_residuals_dly[53:51]==3'b000); // F5D5_F1F2,F5D5_F1L1
        assign wr_en_disk[3]  = D6 & (data_residuals_dly[53:51]==3'b000); // F5D6_F1F2,F5D6_F1L1
        assign wr_en_disk[4]  = D5 & (data_residuals_dly[53:51]==3'b001); // F5D5_F3F4
        assign wr_en_disk[5]  = D6 & (data_residuals_dly[53:51]==3'b001); // F5D6_F3F4
    end
    if(LD_COMBINATION == "L2L4F2") begin
        assign layer_index = (data_residuals_dly[54:51]==4'b1011) ? 3'b101 : 3'b111; // Seeding in L1L2 or L3L4
        // LAYERS
        assign wr_en_layer[0]  = D3_inner & (data_residuals_dly[53:51]==3'b100); // L2D3_L3L4
        assign wr_en_layer[1]  = D4_inner & (data_residuals_dly[53:51]==3'b100); // L2D4_L3L4
        assign wr_en_layer[2]  = D3_outer & (data_residuals_dly[53:51]==3'b010); // L4D3_L1L2
        assign wr_en_layer[3]  = D4_outer & (data_residuals_dly[53:51]==3'b010); // L4D4_L1L2
        
        assign wr_en_layer[4]  = D3_inner & (data_residuals_dly[53:51]==3'b101); // L2D3_L5L6,L2D3_F1F2
        assign wr_en_layer[5]  = D3_outer & (data_residuals_dly[53:51]==3'b011); // L4D3_L5L6
        assign wr_en_layer[6]  = D4_inner & (data_residuals_dly[53:51]==3'b101); // L2D4_L5L6,L2D4_F1F2
        assign wr_en_layer[7]  = D4_outer & (data_residuals_dly[53:51]==3'b011); // L4D4_L5L6
        // DISKS
        assign wr_en_disk[0]  = D5 & (data_residuals_dly[53:53]==1'b0); // F2D5_F3F4,F2D5_F1L1,F2D5_L1L2,F2D5_L3L4
        assign wr_en_disk[1]  = D6 & (data_residuals_dly[53:53]==1'b0); // F2D6_F3F4,F2D6_F1L1,F2D6_L1L2,F2D6_L3L4
    end
    if(LD_COMBINATION == "F1L5") begin
        assign layer_index = (data_residuals_dly[54:51]==4'b1010) ? 3'b101 : 3'b111; // Seeding in L1L2 or L3L4
        // LAYERS
        assign wr_en_layer[0]  = D3_outer & (data_residuals_dly[53:51]==3'b011); // L5D3_L3L4
        assign wr_en_layer[1]  = D4_outer & (data_residuals_dly[53:51]==3'b011); // L5D4_L3L4
        assign wr_en_layer[2]  = D3_outer & (data_residuals_dly[53:51]==3'b010); // L5D3_L1L2
        assign wr_en_layer[3]  = D4_outer & (data_residuals_dly[53:51]==3'b010); // L5D4_L1L2
        // DISKS
        assign wr_en_disk[0]  = D5 & (data_residuals_dly[53:53]==1'b0); // F1D5_F3F4,F1D5_L3L4,F1D5_L1L2
        assign wr_en_disk[1]  = D6 & (data_residuals_dly[53:53]==1'b0); // F1D6_F3F4,F1D6_L3L4,F1D6_L1L2
    end
    if(LD_COMBINATION == "L1L6F4") begin
        assign layer_index = 3'b111;
        // LAYERS
        assign wr_en_layer[0]  = D3_inner & (data_residuals_dly[53:51]==3'b100); // L1D3_L3L4
        assign wr_en_layer[1]  = D3_outer & (data_residuals_dly[53:51]==3'b011); // L6D3_L3L4
        assign wr_en_layer[2]  = D4_inner & (data_residuals_dly[53:51]==3'b100); // L1D4_L3L4
        assign wr_en_layer[3]  = D4_outer & (data_residuals_dly[53:51]==3'b011); // L6D4_L3L4
        
        assign wr_en_layer[4]  = D3_outer & (data_residuals_dly[53:51]==3'b010); // L6D3_L1L2
        assign wr_en_layer[5]  = D4_outer & (data_residuals_dly[53:51]==3'b010); // L6D4_L1L2
        assign wr_en_layer[6]  = D3_inner & (data_residuals_dly[53:51]==3'b101); // L1D3_L5L6,L1D3_F1F2
        assign wr_en_layer[7]  = D4_inner & (data_residuals_dly[53:51]==3'b101); // L1D4_L5L6,L1D4_F1F2
        // DISKS
        assign wr_en_disk[0]  = D5 & (data_residuals_dly[53:53]==1'b0); // F4D5_F1F2,F4D5_F1L1,F4D5_L1L2
        assign wr_en_disk[1]  = D6 & (data_residuals_dly[53:53]==1'b0); // F4D6_F1F2,F4D6_F1L1,F4D6_L1L2
    end
endgenerate
endmodule
