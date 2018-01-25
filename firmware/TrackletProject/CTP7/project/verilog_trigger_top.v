`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 10:57:12 AM
// Design Name: 
// Module Name: verilog_trigger_top
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


module verilog_trigger_top(
    input wire proc_clk,
    input wire proc_clk_new, //MT			   
    input wire io_clk,
    input wire reset,
    // inputs
    input [31:0] input_link1_reg1,
    input [31:0] input_link1_reg2,
    input [31:0] input_link2_reg1,
    input [31:0] input_link2_reg2,
    input [31:0] input_link3_reg1,
    input [31:0] input_link3_reg2,
    input [31:0] input_link4_reg1,
    input [31:0] input_link4_reg2,
    input [31:0] input_link5_reg1,
    input [31:0] input_link5_reg2,
    input [31:0] input_link6_reg1,
    input [31:0] input_link6_reg2,
    input [31:0] input_link7_reg1,
    input [31:0] input_link7_reg2,    
    input [31:0] input_link8_reg1,
    input [31:0] input_link8_reg2,
    input [31:0] input_link9_reg1,
    input [31:0] input_link9_reg2,    
    // outputs
    input [15:0] BRAM_OUTPUT_addr,
    input BRAM_OUTPUT_clk,
    input [31:0] BRAM_OUTPUT_din,
    output [31:0] BRAM_OUTPUT_dout,
    input BRAM_OUTPUT_en,
    input BRAM_OUTPUT_rst,
    input [3:0] BRAM_OUTPUT_we,
        
    output wire [54:0] Proj_L3F3F5_ToPlus,
    output wire Proj_L3F3F5_ToPlus_en,
    output wire [54:0] Proj_L3F3F5_ToMinus,
    output wire Proj_L3F3F5_ToMinus_en,
    input wire [54:0] Proj_L3F3F5_FromPlus,
    input wire Proj_L3F3F5_FromPlus_en,
    input wire [54:0] Proj_L3F3F5_FromMinus,
    input wire Proj_L3F3F5_FromMinus_en,
    
    output wire [54:0] Proj_L2L4F2_ToPlus,
    output wire Proj_L2L4F2_ToPlus_en,
    output wire [54:0] Proj_L2L4F2_ToMinus,
    output wire Proj_L2L4F2_ToMinus_en,
    input wire [54:0] Proj_L2L4F2_FromPlus,
    input wire Proj_L2L4F2_FromPlus_en,
    input wire [54:0] Proj_L2L4F2_FromMinus,
    input wire Proj_L2L4F2_FromMinus_en,
    
    output wire [54:0] Proj_F1L5_ToPlus,
    output wire Proj_F1L5_ToPlus_en,
    output wire [54:0] Proj_F1L5_ToMinus,
    output wire Proj_F1L5_ToMinus_en,
    input wire [54:0] Proj_F1L5_FromPlus,
    input wire Proj_F1L5_FromPlus_en,
    input wire [54:0] Proj_F1L5_FromMinus,
    input wire Proj_F1L5_FromMinus_en,
    
    output wire [54:0] Proj_L1L6F4_ToPlus,
    output wire Proj_L1L6F4_ToPlus_en,
    output wire [54:0] Proj_L1L6F4_ToMinus,
    output wire Proj_L1L6F4_ToMinus_en,
    input wire [54:0] Proj_L1L6F4_FromPlus,
    input wire Proj_L1L6F4_FromPlus_en,
    input wire [54:0] Proj_L1L6F4_FromMinus,
    input wire Proj_L1L6F4_FromMinus_en,
    
    output wire [44:0] Match_Layer_ToPlus,
    output wire Match_Layer_ToPlus_en,
    output wire [44:0] Match_Layer_ToMinus,
    output wire Match_Layer_ToMinus_en,
    input wire [44:0] Match_Layer_FromPlus,
    input wire Match_Layer_FromPlus_en,
    input wire [44:0] Match_Layer_FromMinus,
    input wire Match_Layer_FromMinus_en,
    
    output wire [44:0] Match_FDSK_ToPlus,
    output wire Match_FDSK_ToPlus_en,
    output wire [44:0] Match_FDSK_ToMinus,
    output wire Match_FDSK_ToMinus_en,
    input wire [44:0] Match_FDSK_FromPlus,
    input wire Match_FDSK_FromPlus_en,
    input wire [44:0] Match_FDSK_FromMinus,
    input wire Match_FDSK_FromMinus_en,
        
    output wire [125:0] CT_L1L2,
    output wire [125:0] CT_L3L4,
    output wire [125:0] CT_L5L6,
    output wire [125:0] CT_F1F2,
    output wire [125:0] CT_F3F4,
    output wire [125:0] CT_F1L1
    
    );
         
    
    // Address decoding to select modules below this level.
    // "ipb_addr[31:30] = 2'b01" have already been used above this point to get here.
    wire tracklet_processing_sel;
    assign tracklet_processing_sel = 1'b1;
    
    wire [31:0] tracklet_processing_io_rd_data;
    wire [31:0] tracklet_processing1_io_rd_data;
    wire [31:0] tracklet_processing2_io_rd_data;
    wire [31:0] tracklet_processing3_io_rd_data;
    wire tracklet_processing_io_rd_ack;
    wire tracklet_processing1_io_rd_ack;
    wire tracklet_processing2_io_rd_ack;
    wire tracklet_processing3_io_rd_ack;
    wire io_sync;
    wire io_rd_en;
    wire io_wr_en;
   
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // create the BX clocks,
    reg [2:0] BX;           // Bunch Crossing counter
    reg first_clk;
    reg not_first_clk;
   
    reg en_proc;
//    reg en_proc_1;
//    reg en_proc_2;
    initial begin
        BX = 3'b111;
    end
    
    wire io_sel_en;
    
    initial begin
        en_proc <= 1'b0;
    end
    
    //BUFG reset_bufg(.I(reset), .O(reset_proc));
    
    always @ (posedge io_clk) begin
        if (reset) 
            en_proc <= 1'b0;
        else if (input_link1_reg1[31:29] == 3'b111 && {input_link1_reg1[20:14], input_link1_reg2[31:14]} == 25'h1ffffff)
            en_proc <= 1'b1;
    end
           
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // connect each sector
         
//    Tracklet_processingD5 tracklet_processing(   // disk PS modules
//    Tracklet_processingD5D6 tracklet_processing( // disk PS and 2S modules
//    Tracklet_processingD4D5 tracklet_processing( // hybrid development
//    Tracklet_processingD4D6 tracklet_processing( // hybrid region
    Tracklet_processingD3D4 tracklet_processing(   // 1/2 barrel
//    Tracklet_processingD3 tracklet_processing( // Only 1/4 barrel = 1 DTC region
//    Tracklet_processingD3D6 tracklet_processing( // 1/2 sector
        // clocks and reset
        .reset(reset),                        // active HI
        .clk(proc_clk),                // processing clock at a multiple of the crossing clock
        .clk_new(proc_clk_new), //MT: used only by FT 						   
        .en_proc(en_proc),
        // input
        .input_link1_reg1(input_link1_reg1),
        .input_link1_reg2(input_link1_reg2),
        .input_link2_reg1(input_link2_reg1),
        .input_link2_reg2(input_link2_reg2),
        .input_link3_reg1(input_link3_reg1),
        .input_link3_reg2(input_link3_reg2),
        .input_link4_reg1(input_link4_reg1),
        .input_link4_reg2(input_link4_reg2),
        .input_link5_reg1(input_link5_reg1),
        .input_link5_reg2(input_link5_reg2),
        .input_link6_reg1(input_link6_reg1),
        .input_link6_reg2(input_link6_reg2),
        .input_link7_reg1(input_link7_reg1),
        .input_link7_reg2(input_link7_reg2),
        .input_link8_reg1(input_link8_reg1),
        .input_link8_reg2(input_link8_reg2),
        .input_link9_reg1(input_link9_reg1),
        .input_link9_reg2(input_link9_reg2),
        // output
        .BRAM_OUTPUT_addr(BRAM_OUTPUT_addr),
        .BRAM_OUTPUT_clk(BRAM_OUTPUT_clk),
        .BRAM_OUTPUT_dout(BRAM_OUTPUT_dout),
        .BRAM_OUTPUT_rst(BRAM_OUTPUT_rst),
        .BRAM_OUTPUT_en(BRAM_OUTPUT_en),
        
        .PT_L3F3F5_Plus_To_DataStream(Proj_L3F3F5_ToPlus),
        .PT_L3F3F5_Plus_To_DataStream_en(Proj_L3F3F5_ToPlus_en),
        .PT_L3F3F5_Minus_To_DataStream(Proj_L3F3F5_ToMinus),
        .PT_L3F3F5_Minus_To_DataStream_en(Proj_L3F3F5_ToMinus_en),
        .PT_L3F3F5_Plus_From_DataStream(Proj_L3F3F5_FromPlus),
        .PT_L3F3F5_Plus_From_DataStream_en(Proj_L3F3F5_FromPlus_en),
        .PT_L3F3F5_Minus_From_DataStream(Proj_L3F3F5_FromMinus),
        .PT_L3F3F5_Minus_From_DataStream_en(Proj_L3F3F5_FromMinus_en),
        
        .PT_L2L4F2_Plus_To_DataStream(Proj_L2L4F2_ToPlus),
        .PT_L2L4F2_Plus_To_DataStream_en(Proj_L2L4F2_ToPlus_en),
        .PT_L2L4F2_Minus_To_DataStream(Proj_L2L4F2_ToMinus),
        .PT_L2L4F2_Minus_To_DataStream_en(Proj_L2L4F2_ToMinus_en),
        .PT_L2L4F2_Plus_From_DataStream(Proj_L2L4F2_FromPlus),
        .PT_L2L4F2_Plus_From_DataStream_en(Proj_L2L4F2_FromPlus_en),
        .PT_L2L4F2_Minus_From_DataStream(Proj_L2L4F2_FromMinus),
        .PT_L2L4F2_Minus_From_DataStream_en(Proj_L2L4F2_FromMinus_en),
        
        .PT_F1L5_Plus_To_DataStream(Proj_F1L5_ToPlus),
        .PT_F1L5_Plus_To_DataStream_en(Proj_F1L5_ToPlus_en),
        .PT_F1L5_Minus_To_DataStream(Proj_F1L5_ToMinus),
        .PT_F1L5_Minus_To_DataStream_en(Proj_F1L5_ToMinus_en),
        .PT_F1L5_Plus_From_DataStream(Proj_F1L5_FromPlus),
        .PT_F1L5_Plus_From_DataStream_en(Proj_F1L5_FromPlus_en),
        .PT_F1L5_Minus_From_DataStream(Proj_F1L5_FromMinus),
        .PT_F1L5_Minus_From_DataStream_en(Proj_F1L5_FromMinus_en),
        
        .PT_L1L6F4_Plus_To_DataStream(Proj_L1L6F4_ToPlus),
        .PT_L1L6F4_Plus_To_DataStream_en(Proj_L1L6F4_ToPlus_en),
        .PT_L1L6F4_Minus_To_DataStream(Proj_L1L6F4_ToMinus),
        .PT_L1L6F4_Minus_To_DataStream_en(Proj_L1L6F4_ToMinus_en),
        .PT_L1L6F4_Plus_From_DataStream(Proj_L1L6F4_FromPlus),
        .PT_L1L6F4_Plus_From_DataStream_en(Proj_L1L6F4_FromPlus_en),
        .PT_L1L6F4_Minus_From_DataStream(Proj_L1L6F4_FromMinus),
        .PT_L1L6F4_Minus_From_DataStream_en(Proj_L1L6F4_FromMinus_en),        
        
        .MT_Layr_Plus_To_DataStream(Match_Layer_ToPlus),
        .MT_Layr_Plus_To_DataStream_en(Match_Layer_ToPlus_en),
        .MT_Layr_Minus_To_DataStream(Match_Layer_ToMinus),
        .MT_Layr_Minus_To_DataStream_en(Match_Layer_ToMinus_en),
        .MT_Layr_Plus_From_DataStream(Match_Layer_FromPlus),
        .MT_Layr_Plus_From_DataStream_en(Match_Layer_FromPlus_en),
        .MT_Layr_Minus_From_DataStream(Match_Layer_FromMinus),
        .MT_Layr_Minus_From_DataStream_en(Match_Layer_FromMinus_en),

        .MT_FDSK_Plus_To_DataStream(Match_FDSK_ToPlus),
        .MT_FDSK_Plus_To_DataStream_en(Match_FDSK_ToPlus_en),
        .MT_FDSK_Minus_To_DataStream(Match_FDSK_ToMinus),
        .MT_FDSK_Minus_To_DataStream_en(Match_FDSK_ToMinus_en),
        .MT_FDSK_Plus_From_DataStream(Match_FDSK_FromPlus),
        .MT_FDSK_Plus_From_DataStream_en(Match_FDSK_FromPlus_en),
        .MT_FDSK_Minus_From_DataStream(Match_FDSK_FromMinus),
        .MT_FDSK_Minus_From_DataStream_en(Match_FDSK_FromMinus_en),
        
        .CT_L1L2_DataStream(CT_L1L2),
        .CT_L3L4_DataStream(CT_L3L4),
        .CT_L5L6_DataStream(CT_L5L6),
        .CT_F1F2_DataStream(CT_F1F2),
        .CT_F3F4_DataStream(CT_F3F4),
        .CT_F1L1_DataStream(CT_F1L1),
        // clocks
        .BX(BX),
        .first_clk(first_clk),
        .not_first_clk(not_first_clk)
        
        );   
         
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // connect a mux to steer the readback data from one of the segments to the ipbus
    reg [31:0] io_rd_data_reg;
    assign ipb_rdata = io_rd_data_reg;
//    // Assert 'io_rd_ack' if any modules below this function assert their 'io_rd_ack'.
//    reg io_rd_ack_reg;
//    assign io_rd_ack = io_rd_ack_reg;
//    always @(posedge ipb_clk) begin
//        io_rd_ack_reg <= io_sync & io_rd_en & (tracklet_processing_io_rd_ack | io_sel_en);
//    end

    always @(posedge proc_clk) begin
        if (tracklet_processing_io_rd_ack)      io_rd_data_reg <= tracklet_processing_io_rd_data;
//        if (io_rd_en & io_sel_en)               io_rd_data_reg <= en_proc;
    end
    
         
endmodule
