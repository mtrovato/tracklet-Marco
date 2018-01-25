`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2015 09:56:40 AM
// Design Name: 
// Module Name: ctp7_simulation
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


module ctp7_simulation(

		       );
   
   parameter USER_DIR = "/scratch/tracklet/";   // full path of the directory in which firmware/ sits
   
   // Inputs
   reg clk;
   reg BC0;
   reg reset;
   wire [31:0] link1_reg1_minus;
   wire [31:0] link1_reg2_minus;
   wire [31:0] link2_reg1_minus;
   wire [31:0] link2_reg2_minus;
   wire [31:0] link3_reg1_minus;
   wire [31:0] link3_reg2_minus;
   wire [31:0] link1_reg1_central;
   wire [31:0] link1_reg2_central;
   wire [31:0] link2_reg1_central;
   wire [31:0] link2_reg2_central;
   wire [31:0] link3_reg1_central;
   wire [31:0] link3_reg2_central;
   wire [31:0] link1_reg1_plus;
   wire [31:0] link1_reg2_plus;
   wire [31:0] link2_reg1_plus;
   wire [31:0] link2_reg2_plus;
   wire [31:0] link3_reg1_plus;
   wire [31:0] link3_reg2_plus;
   
   // additional inputs for D3D4 project
   wire [31:0] link4_reg1_minus;
   wire [31:0] link4_reg2_minus;
   wire [31:0] link5_reg1_minus;
   wire [31:0] link5_reg2_minus;
   wire [31:0] link6_reg1_minus;
   wire [31:0] link6_reg2_minus;
   wire [31:0] link4_reg1_central;
   wire [31:0] link4_reg2_central;
   wire [31:0] link5_reg1_central;
   wire [31:0] link5_reg2_central;
   wire [31:0] link6_reg1_central;
   wire [31:0] link6_reg2_central;
   wire [31:0] link4_reg1_plus;
   wire [31:0] link4_reg2_plus;
   wire [31:0] link5_reg1_plus;
   wire [31:0] link5_reg2_plus;
   wire [31:0] link6_reg1_plus;
   wire [31:0] link6_reg2_plus;
   
   // additional inputs for D4D6 project (3 DTC regions)
   wire [31:0] link7_reg1_minus;
   wire [31:0] link7_reg2_minus;
   wire [31:0] link8_reg1_minus;
   wire [31:0] link8_reg2_minus;
   wire [31:0] link9_reg1_minus;
   wire [31:0] link9_reg2_minus;
   wire [31:0] link7_reg1_central;
   wire [31:0] link7_reg2_central;
   wire [31:0] link8_reg1_central;
   wire [31:0] link8_reg2_central;
   wire [31:0] link9_reg1_central;
   wire [31:0] link9_reg2_central;
   wire [31:0] link7_reg1_plus;
   wire [31:0] link7_reg2_plus;
   wire [31:0] link8_reg1_plus;
   wire [31:0] link8_reg2_plus;
   wire [31:0] link9_reg1_plus;
   wire [31:0] link9_reg2_plus;   
   
   // MINUS BOARD -> To CENTRAL BOARD
   wire [54:0] Proj_L3F3F5_ToPlus_minus;
   wire        Proj_L3F3F5_ToPlus_en_minus;
   wire [44:0] Match_Layer_ToPlus_minus;
   wire        pre_Match_Layer_ToPlus_en_minus;
   reg         Match_Layer_ToPlus_en_minus;
   wire [54:0] Proj_L2L4F2_ToPlus_minus;
   wire        Proj_L2L4F2_ToPlus_en_minus;
   wire [44:0] Match_FDSK_ToPlus_minus;
   wire        Match_FDSK_ToPlus_en_minus;
   wire [54:0] Proj_F1L5_ToPlus_minus;
   wire        Proj_F1L5_ToPlus_en_minus;
   wire [54:0] Proj_L3F3F5_FromMinus_central;
   wire        Proj_L3F3F5_FromMinus_en_central;
   wire [44:0] Match_Layer_FromMinus_central;
   wire        Match_Layer_FromMinus_en_central;
   wire [54:0] Proj_L2L4F2_FromMinus_central;
   wire        Proj_L2L4F2_FromMinus_en_central;
   wire [44:0] Match_FDSK_FromMinus_central;
   wire        Match_FDSK_FromMinus_en_central;
   wire [54:0] Proj_F1L5_FromMinus_central;
   wire        Proj_F1L5_FromMinus_en_central;
   wire [54:0] Proj_L1L6F4_ToPlus_minus;
   wire        Proj_L1L6F4_ToPlus_en_minus;
   wire [54:0] Proj_L1L6F4_FromMinus_central;
   wire        Proj_L1L6F4_FromMinus_en_central;
   
   // CENTRAL BOARD -> To PLUS BOARD
   wire [54:0] Proj_L3F3F5_ToPlus_central;
   wire        Proj_L3F3F5_ToPlus_en_central;
   wire [44:0] Match_Layer_ToPlus_central;
   wire        pre_Match_Layer_ToPlus_en_central;
   reg         Match_Layer_ToPlus_en_central;
   wire [54:0] Proj_L2L4F2_ToPlus_central;
   wire        Proj_L2L4F2_ToPlus_en_central;
   wire [44:0] Match_FDSK_ToPlus_central;
   wire        Match_FDSK_ToPlus_en_central;
   wire [54:0] Proj_F1L5_ToPlus_central;
   wire        Proj_F1L5_ToPlus_en_central;
   wire [54:0] Proj_L3F3F5_FromMinus_plus;
   wire        Proj_L3F3F5_FromMinus_en_plus;
   wire [44:0] Match_Layer_FromMinus_plus;
   wire        Match_Layer_FromMinus_en_plus;
   wire [54:0] Proj_L2L4F2_FromMinus_plus;
   wire        Proj_L2L4F2_FromMinus_en_plus;
   wire [44:0] Match_FDSK_FromMinus_plus;
   wire        Match_FDSK_FromMinus_en_plus;
   wire [54:0] Proj_F1L5_FromMinus_plus;
   wire        Proj_F1L5_FromMinus_en_plus;
   wire [54:0] Proj_L1L6F4_ToPlus_central;
   wire        Proj_L1L6F4_ToPlus_en_central;
   wire [54:0] Proj_L1L6F4_FromMinus_plus;
   wire        Proj_L1L6F4_FromMinus_en_plus;
   
   // CENTRAL BOARD -> To MINUS BOARD
   wire [54:0] Proj_L3F3F5_ToMinus_central;
   wire        Proj_L3F3F5_ToMinus_en_central;
   wire [44:0] Match_Layer_ToMinus_central;
   wire        pre_Match_Layer_ToMinus_en_central;
   reg         Match_Layer_ToMinus_en_central;
   wire [54:0] Proj_L2L4F2_ToMinus_central;
   wire        Proj_L2L4F2_ToMinus_en_central;
   wire [44:0] Match_FDSK_ToMinus_central;
   wire        Match_FDSK_ToMinus_en_central;
   wire [54:0] Proj_F1L5_ToMinus_central;
   wire        Proj_F1L5_ToMinus_en_central;
   wire [54:0] Proj_L3F3F5_FromPlus_minus;
   wire        Proj_L3F3F5_FromPlus_en_minus;
   wire [44:0] Match_Layer_FromPlus_minus;
   wire        Match_Layer_FromPlus_en_minus;
   wire [54:0] Proj_L2L4F2_FromPlus_minus;
   wire        Proj_L2L4F2_FromPlus_en_minus;
   wire [44:0] Match_FDSK_FromPlus_minus;
   wire        Match_FDSK_FromPlus_en_minus;
   wire [54:0] Proj_F1L5_FromPlus_minus;
   wire        Proj_F1L5_FromPlus_en_minus;
   wire [54:0] Proj_L1L6F4_ToMinus_central;
   wire        Proj_L1L6F4_ToMinus_en_central;
   wire [54:0] Proj_L1L6F4_FromPlus_minus;
   wire        Proj_L1L6F4_FromPlus_en_minus;
   
   // PLUS BOARD -> To CENTRAL BOARD
   wire [54:0] Proj_L3F3F5_ToMinus_plus;
   wire        Proj_L3F3F5_ToMinus_en_plus;
   wire [44:0] Match_Layer_ToMinus_plus;
   wire        pre_Match_Layer_ToMinus_en_plus;
   reg         Match_Layer_ToMinus_en_plus;
   wire [54:0] Proj_L2L4F2_ToMinus_plus;
   wire        Proj_L2L4F2_ToMinus_en_plus;
   wire [44:0] Match_FDSK_ToMinus_plus;
   wire        Match_FDSK_ToMinus_en_plus;
   wire [54:0] Proj_F1L5_ToMinus_plus;
   wire        Proj_F1L5_ToMinus_en_plus;
   wire [54:0] Proj_L3F3F5_FromPlus_central;
   wire        Proj_L3F3F5_FromPlus_en_central;
   wire [44:0] Match_Layer_FromPlus_central;
   wire        Match_Layer_FromPlus_en_central;
   wire [44:0] Match_FDSK_FromPlus_central;
   wire        Match_FDSK_FromPlus_en_central;
   wire [54:0] Proj_L1L6F4_ToMinus_plus;
   wire        Proj_L1L6F4_ToMinus_en_plus;
   wire [54:0] Proj_L1L6F4_FromPlus_central;
   wire        Proj_L1L6F4_FromPlus_en_central;
   
   always @(posedge clk) begin
      Match_Layer_ToPlus_en_central <= pre_Match_Layer_ToPlus_en_central;
      Match_Layer_ToMinus_en_central <= pre_Match_Layer_ToMinus_en_central;
      Match_Layer_ToPlus_en_minus <= pre_Match_Layer_ToPlus_en_minus;
      Match_Layer_ToMinus_en_plus <= pre_Match_Layer_ToMinus_en_plus;      
   end
   
   wire [54:0] Proj_L2L4F2_FromPlus_central;
   wire        Proj_L2L4F2_FromPlus_en_central;
   wire [54:0] Proj_F1L5_FromPlus_central;
   wire        Proj_F1L5_FromPlus_en_central;
   
   verilog_trigger_top uut_minus(
				 .proc_clk(clk),
				 .io_clk(clk),
				 .reset(BC0),
				 //.bc0(BC0),
				 // inputs
				 .input_link1_reg1(link1_reg1_minus),
				 .input_link1_reg2(link1_reg2_minus),
				 .input_link2_reg1(link2_reg1_minus),
				 .input_link2_reg2(link2_reg2_minus),
				 .input_link3_reg1(link3_reg1_minus),
				 .input_link3_reg2(link3_reg2_minus),

				 .input_link4_reg1(link4_reg1_minus),
				 .input_link4_reg2(link4_reg2_minus),
				 .input_link5_reg1(link5_reg1_minus),
				 .input_link5_reg2(link5_reg2_minus),
				 .input_link6_reg1(link6_reg1_minus),
				 .input_link6_reg2(link6_reg2_minus),

                 .input_link7_reg1(link7_reg1_minus),
                 .input_link7_reg2(link7_reg2_minus),
                 .input_link8_reg1(link8_reg1_minus),
                 .input_link8_reg2(link8_reg2_minus),
                 .input_link9_reg1(link9_reg1_minus),
                 .input_link9_reg2(link9_reg2_minus),
      
				 .Proj_L3F3F5_ToPlus(Proj_L3F3F5_ToPlus_minus),
				 .Proj_L3F3F5_ToPlus_en(Proj_L3F3F5_ToPlus_en_minus),
				 .Proj_L3F3F5_ToMinus(Proj_L3F3F5_ToMinus_minus),
				 .Proj_L3F3F5_ToMinus_en(Proj_L3F3F5_ToMinus_en_minus),
				 .Proj_L3F3F5_FromPlus(Proj_L3F3F5_FromPlus_minus),
				 .Proj_L3F3F5_FromPlus_en(Proj_L3F3F5_FromPlus_en_minus),
				 .Proj_L3F3F5_FromMinus(Proj_L3F3F5_FromMinus_minus),
				 .Proj_L3F3F5_FromMinus_en(Proj_L3F3F5_FromMinus_en_minus),
				 .Match_Layer_ToPlus(Match_Layer_ToPlus_minus),
				 .Match_Layer_ToPlus_en(pre_Match_Layer_ToPlus_en_minus),
				 .Match_Layer_ToMinus(Match_Layer_ToMinus_minus),
				 .Match_Layer_ToMinus_en(pre_Match_Layer_ToMinus_en_minus),
				 .Match_Layer_FromPlus(Match_Layer_FromPlus_minus),
				 .Match_Layer_FromPlus_en(Match_Layer_FromPlus_en_minus),
				 .Match_Layer_FromMinus(Match_Layer_FromMinus_minus),
				 .Match_Layer_FromMinus_en(Match_Layer_FromMinus_en_minus),
      
				 .Proj_L2L4F2_ToPlus(Proj_L2L4F2_ToPlus_minus),
				 .Proj_L2L4F2_ToPlus_en(Proj_L2L4F2_ToPlus_en_minus),
				 .Proj_L2L4F2_ToMinus(Proj_L2L4F2_ToMinus_minus),
				 .Proj_L2L4F2_ToMinus_en(Proj_L2L4F2_ToMinus_en_minus),
				 .Proj_L2L4F2_FromPlus(Proj_L2L4F2_FromPlus_minus),
				 .Proj_L2L4F2_FromPlus_en(Proj_L2L4F2_FromPlus_en_minus),
				 .Proj_L2L4F2_FromMinus(Proj_L2L4F2_FromMinus_minus),
				 .Proj_L2L4F2_FromMinus_en(Proj_L2L4F2_FromMinus_en_minus),
				 .Match_FDSK_ToPlus(Match_FDSK_ToPlus_minus),
				 .Match_FDSK_ToPlus_en(Match_FDSK_ToPlus_en_minus),
				 .Match_FDSK_ToMinus(Match_FDSK_ToMinus_minus),
				 .Match_FDSK_ToMinus_en(Match_FDSK_ToMinus_en_minus),
				 .Match_FDSK_FromPlus(Match_FDSK_FromPlus_minus),
				 .Match_FDSK_FromPlus_en(Match_FDSK_FromPlus_en_minus),
				 .Match_FDSK_FromMinus(Match_FDSK_FromMinus_minus),
				 .Match_FDSK_FromMinus_en(Match_FDSK_FromMinus_en_minus),
      
				 .Proj_F1L5_ToPlus(Proj_F1L5_ToPlus_minus),
				 .Proj_F1L5_ToPlus_en(Proj_F1L5_ToPlus_en_minus),
				 .Proj_F1L5_ToMinus(Proj_F1L5_ToMinus_minus),
				 .Proj_F1L5_ToMinus_en(Proj_F1L5_ToMinus_en_minus),
				 .Proj_F1L5_FromPlus(Proj_F1L5_FromPlus_minus),
				 .Proj_F1L5_FromPlus_en(Proj_F1L5_FromPlus_en_minus),
				 .Proj_F1L5_FromMinus(Proj_F1L5_FromMinus_minus),
				 .Proj_F1L5_FromMinus_en(Proj_F1L5_FromMinus_en_minus),
				 
				 .Proj_L1L6F4_ToPlus(Proj_L1L6F4_ToPlus_minus),
				 .Proj_L1L6F4_ToPlus_en(Proj_L1L6F4_ToPlus_en_minus),
				 .Proj_L1L6F4_ToMinus(Proj_L1L6F4_ToMinus_minus),
				 .Proj_L1L6F4_ToMinus_en(Proj_L1L6F4_ToMinus_en_minus),
				 .Proj_L1L6F4_FromPlus(Proj_L1L6F4_FromPlus_minus),
				 .Proj_L1L6F4_FromPlus_en(Proj_L1L6F4_FromPlus_en_minus),
				 .Proj_L1L6F4_FromMinus(Proj_L1L6F4_FromMinus_minus),
				 .Proj_L1L6F4_FromMinus_en(Proj_L1L6F4_FromMinus_en_minus)

				 );
   
   verilog_trigger_top uut_central(
				   .proc_clk(clk),
				   .io_clk(clk),
				   .reset(BC0),
				   //.bc0(BC0),
				   // inputs
				   .input_link1_reg1(link1_reg1_central),
				   .input_link1_reg2(link1_reg2_central),
				   .input_link2_reg1(link2_reg1_central),
				   .input_link2_reg2(link2_reg2_central),
				   .input_link3_reg1(link3_reg1_central),
				   .input_link3_reg2(link3_reg2_central),

				   .input_link4_reg1(link4_reg1_central),
				   .input_link4_reg2(link4_reg2_central),
				   .input_link5_reg1(link5_reg1_central),
				   .input_link5_reg2(link5_reg2_central),
				   .input_link6_reg1(link6_reg1_central),
				   .input_link6_reg2(link6_reg2_central),

				   .input_link7_reg1(link7_reg1_central),
				   .input_link7_reg2(link7_reg2_central),
				   .input_link8_reg1(link8_reg1_central),
				   .input_link8_reg2(link8_reg2_central),
				   .input_link9_reg1(link9_reg1_central),
				   .input_link9_reg2(link9_reg2_central),
      
				   .Proj_L3F3F5_ToPlus(Proj_L3F3F5_ToPlus_central),
				   .Proj_L3F3F5_ToPlus_en(Proj_L3F3F5_ToPlus_en_central),
				   .Proj_L3F3F5_ToMinus(Proj_L3F3F5_ToMinus_central),
				   .Proj_L3F3F5_ToMinus_en(Proj_L3F3F5_ToMinus_en_central),
				   .Proj_L3F3F5_FromPlus(Proj_L3F3F5_FromPlus_central),
				   .Proj_L3F3F5_FromPlus_en(Proj_L3F3F5_FromPlus_en_central),
				   .Proj_L3F3F5_FromMinus(Proj_L3F3F5_FromMinus_central),
				   .Proj_L3F3F5_FromMinus_en(Proj_L3F3F5_FromMinus_en_central),
				   .Match_Layer_ToPlus(Match_Layer_ToPlus_central),
				   .Match_Layer_ToPlus_en(pre_Match_Layer_ToPlus_en_central),
				   .Match_Layer_ToMinus(Match_Layer_ToMinus_central),
				   .Match_Layer_ToMinus_en(pre_Match_Layer_ToMinus_en_central),
				   .Match_Layer_FromPlus(Match_Layer_FromPlus_central),
				   .Match_Layer_FromPlus_en(Match_Layer_FromPlus_en_central),
				   .Match_Layer_FromMinus(Match_Layer_FromMinus_central),
				   .Match_Layer_FromMinus_en(Match_Layer_FromMinus_en_central),
      
				   .Proj_L2L4F2_ToPlus(Proj_L2L4F2_ToPlus_central),
				   .Proj_L2L4F2_ToPlus_en(Proj_L2L4F2_ToPlus_en_central),
				   .Proj_L2L4F2_ToMinus(Proj_L2L4F2_ToMinus_central),
				   .Proj_L2L4F2_ToMinus_en(Proj_L2L4F2_ToMinus_en_central),
				   .Proj_L2L4F2_FromPlus(Proj_L2L4F2_FromPlus_central),
				   .Proj_L2L4F2_FromPlus_en(Proj_L2L4F2_FromPlus_en_central),
				   .Proj_L2L4F2_FromMinus(Proj_L2L4F2_FromMinus_central),
				   .Proj_L2L4F2_FromMinus_en(Proj_L2L4F2_FromMinus_en_central),
				   .Match_FDSK_ToPlus(Match_FDSK_ToPlus_central),
				   .Match_FDSK_ToPlus_en(Match_FDSK_ToPlus_en_central),
				   .Match_FDSK_ToMinus(Match_FDSK_ToMinus_central),
				   .Match_FDSK_ToMinus_en(Match_FDSK_ToMinus_en_central),
				   .Match_FDSK_FromPlus(Match_FDSK_FromPlus_central),
				   .Match_FDSK_FromPlus_en(Match_FDSK_FromPlus_en_central),
				   .Match_FDSK_FromMinus(Match_FDSK_FromMinus_central),
				   .Match_FDSK_FromMinus_en(Match_FDSK_FromMinus_en_central),
      
				   .Proj_F1L5_ToPlus(Proj_F1L5_ToPlus_central),
				   .Proj_F1L5_ToPlus_en(Proj_F1L5_ToPlus_en_central),
				   .Proj_F1L5_ToMinus(Proj_F1L5_ToMinus_central),
				   .Proj_F1L5_ToMinus_en(Proj_F1L5_ToMinus_en_central),
				   .Proj_F1L5_FromPlus(Proj_F1L5_FromPlus_central),
				   .Proj_F1L5_FromPlus_en(Proj_F1L5_FromPlus_en_central),
				   .Proj_F1L5_FromMinus(Proj_F1L5_FromMinus_central),
				   .Proj_F1L5_FromMinus_en(Proj_F1L5_FromMinus_en_central),
				   
				   .Proj_L1L6F4_ToPlus(Proj_L1L6F4_ToPlus_central),
				   .Proj_L1L6F4_ToPlus_en(Proj_L1L6F4_ToPlus_en_central),
				   .Proj_L1L6F4_ToMinus(Proj_L1L6F4_ToMinus_central),
				   .Proj_L1L6F4_ToMinus_en(Proj_L1L6F4_ToMinus_en_central),
				   .Proj_L1L6F4_FromPlus(Proj_L1L6F4_FromPlus_central),
				   .Proj_L1L6F4_FromPlus_en(Proj_L1L6F4_FromPlus_en_central),
				   .Proj_L1L6F4_FromMinus(Proj_L1L6F4_FromMinus_central),
				   .Proj_L1L6F4_FromMinus_en(Proj_L1L6F4_FromMinus_en_central)
				   );
   
   verilog_trigger_top uut_plus(
				.proc_clk(clk),
				.io_clk(clk),
				.reset(BC0),
				//.bc0(BC0),
				// inputs
				.input_link1_reg1(link1_reg1_plus),
				.input_link1_reg2(link1_reg2_plus),
				.input_link2_reg1(link2_reg1_plus),
				.input_link2_reg2(link2_reg2_plus),
				.input_link3_reg1(link3_reg1_plus),
				.input_link3_reg2(link3_reg2_plus),

				.input_link4_reg1(link4_reg1_plus),
				.input_link4_reg2(link4_reg2_plus),
				.input_link5_reg1(link5_reg1_plus),
				.input_link5_reg2(link5_reg2_plus),
				.input_link6_reg1(link6_reg1_plus),
				.input_link6_reg2(link6_reg2_plus),
 
                .input_link7_reg1(link7_reg1_plus),
                .input_link7_reg2(link7_reg2_plus),
                .input_link8_reg1(link8_reg1_plus),
                .input_link8_reg2(link8_reg2_plus),
                .input_link9_reg1(link9_reg1_plus),
                .input_link9_reg2(link9_reg2_plus),
      
				.Proj_L3F3F5_ToPlus(Proj_L3F3F5_ToPlus_plus),
				.Proj_L3F3F5_ToPlus_en(Proj_L3F3F5_ToPlus_en_plus),
				.Proj_L3F3F5_ToMinus(Proj_L3F3F5_ToMinus_plus),
				.Proj_L3F3F5_ToMinus_en(Proj_L3F3F5_ToMinus_en_plus),
				.Proj_L3F3F5_FromPlus(Proj_L3F3F5_FromPlus_plus),
				.Proj_L3F3F5_FromPlus_en(Proj_L3F3F5_FromPlus_en_plus),
				.Proj_L3F3F5_FromMinus(Proj_L3F3F5_FromMinus_plus),
				.Proj_L3F3F5_FromMinus_en(Proj_L3F3F5_FromMinus_en_plus),
				.Match_Layer_ToPlus(Match_Layer_ToPlus_plus),
				.Match_Layer_ToPlus_en(pre_Match_Layer_ToPlus_en_plus),
				.Match_Layer_ToMinus(Match_Layer_ToMinus_plus),
				.Match_Layer_ToMinus_en(pre_Match_Layer_ToMinus_en_plus),
				.Match_Layer_FromPlus(Match_Layer_FromPlus_plus),
				.Match_Layer_FromPlus_en(Match_Layer_FromPlus_en_plus),
				.Match_Layer_FromMinus(Match_Layer_FromMinus_plus),
				.Match_Layer_FromMinus_en(Match_Layer_FromMinus_en_plus),
      
				.Proj_L2L4F2_ToPlus(Proj_L2L4F2_ToPlus_plus),
				.Proj_L2L4F2_ToPlus_en(Proj_L2L4F2_ToPlus_en_plus),
				.Proj_L2L4F2_ToMinus(Proj_L2L4F2_ToMinus_plus),
				.Proj_L2L4F2_ToMinus_en(Proj_L2L4F2_ToMinus_en_plus),
				.Proj_L2L4F2_FromPlus(Proj_L2L4F2_FromPlus_plus),
				.Proj_L2L4F2_FromPlus_en(Proj_L2L4F2_FromPlus_en_plus),
				.Proj_L2L4F2_FromMinus(Proj_L2L4F2_FromMinus_plus),
				.Proj_L2L4F2_FromMinus_en(Proj_L2L4F2_FromMinus_en_plus),
				.Match_FDSK_ToPlus(Match_FDSK_ToPlus_plus),
				.Match_FDSK_ToPlus_en(Match_FDSK_ToPlus_en_plus),
				.Match_FDSK_ToMinus(Match_FDSK_ToMinus_plus),
				.Match_FDSK_ToMinus_en(Match_FDSK_ToMinus_en_plus),
				.Match_FDSK_FromPlus(Match_FDSK_FromPlus_plus),
				.Match_FDSK_FromPlus_en(Match_FDSK_FromPlus_en_plus),
				.Match_FDSK_FromMinus(Match_FDSK_FromMinus_plus),
				.Match_FDSK_FromMinus_en(Match_FDSK_FromMinus_en_plus),
      
				.Proj_F1L5_ToPlus(Proj_F1L5_ToPlus_plus),
				.Proj_F1L5_ToPlus_en(Proj_F1L5_ToPlus_en_plus),
				.Proj_F1L5_ToMinus(Proj_F1L5_ToMinus_plus),
				.Proj_F1L5_ToMinus_en(Proj_F1L5_ToMinus_en_plus),
				.Proj_F1L5_FromPlus(Proj_F1L5_FromPlus_plus),
				.Proj_F1L5_FromPlus_en(Proj_F1L5_FromPlus_en_plus),
				.Proj_F1L5_FromMinus(Proj_F1L5_FromMinus_plus),
				.Proj_F1L5_FromMinus_en(Proj_F1L5_FromMinus_en_plus),
				
				.Proj_L1L6F4_ToPlus(Proj_L1L6F4_ToPlus_plus),
				.Proj_L1L6F4_ToPlus_en(Proj_L1L6F4_ToPlus_en_plus),
				.Proj_L1L6F4_ToMinus(Proj_L1L6F4_ToMinus_plus),
				.Proj_L1L6F4_ToMinus_en(Proj_L1L6F4_ToMinus_en_plus),
				.Proj_L1L6F4_FromPlus(Proj_L1L6F4_FromPlus_plus),
				.Proj_L1L6F4_FromPlus_en(Proj_L1L6F4_FromPlus_en_plus),
				.Proj_L1L6F4_FromMinus(Proj_L1L6F4_FromMinus_plus),
				.Proj_L1L6F4_FromMinus_en(Proj_L1L6F4_FromMinus_en_plus)
				);
   
   wire [47:0] sim_TPROJ_FromPlus;
   
   wire [54:0] pre_Proj_L3F3F5_FromPlus_minus;
   wire [54:0] pre_Proj_L3F3F5_FromMinus_plus;
   wire [54:0] pre_Proj_L3F3F5_FromPlus_central;
   wire [54:0] pre_Proj_L3F3F5_FromMinus_central;
   wire [54:0] pre_Proj_L2L4F2_FromPlus_minus;
   wire [54:0] pre_Proj_L2L4F2_FromMinus_plus;
   wire [54:0] pre_Proj_L2L4F2_FromPlus_central;
   wire [54:0] pre_Proj_L2L4F2_FromMinus_central;
   wire [54:0] pre_Proj_F1L5_FromPlus_minus;
   wire [54:0] pre_Proj_F1L5_FromMinus_plus;
   wire [54:0] pre_Proj_F1L5_FromPlus_central;
   wire [54:0] pre_Proj_F1L5_FromMinus_central;
   wire [54:0] pre_Proj_L1L6F4_FromPlus_minus;
   wire [54:0] pre_Proj_L1L6F4_FromMinus_plus;
   wire [54:0] pre_Proj_L1L6F4_FromPlus_central;
   wire [54:0] pre_Proj_L1L6F4_FromMinus_central;
   
   wire [44:0] pre_Match_Layer_FromPlus_minus;
   wire [44:0] pre_Match_Layer_FromMinus_plus;
   wire [44:0] pre_Match_Layer_FromPlus_central;
   wire [44:0] pre_Match_Layer_FromMinus_central;
   wire [44:0] pre_Match_FDSK_FromPlus_minus;
   wire [44:0] pre_Match_FDSK_FromMinus_plus;
   wire [44:0] pre_Match_FDSK_FromPlus_central;
   wire [44:0] pre_Match_FDSK_FromMinus_central;     
   
   ////////////////////////////////////////// 
     ////////////////////////////////////////// 
     // MINUS BOARD
   //////////////////////////////////////////
   //////////////////////////////////////////
   // PROJECTIONS
   //////////////////////////////////////////
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_L3F3F5_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				 .val_in(Proj_L3F3F5_ToMinus_central), .val_out(Proj_L3F3F5_FromPlus_minus)
				 );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_L2L4F2_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				 .val_in(Proj_L2L4F2_ToMinus_central), .val_out(Proj_L2L4F2_FromPlus_minus)
				 );

   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_F1L5_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
			       .val_in(Proj_F1L5_ToMinus_central), .val_out(Proj_F1L5_FromPlus_minus)
			       );

   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_L1L6F4_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				 .val_in(Proj_L1L6F4_ToMinus_central), .val_out(Proj_L1L6F4_FromPlus_minus)
				 );
   
   //////////////////////////////////////////
   // MATCHES
   //////////////////////////////////////////   
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_Layer_Minus_pipe_plus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Match_Layer_ToMinus_central), .val_out(Match_Layer_FromPlus_minus)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_FDSK_Minus_pipe_plus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Match_FDSK_ToMinus_central), .val_out(Match_FDSK_FromPlus_minus)
			      );
   
   ////////////////////////////////////////// 
   ////////////////////////////////////////// 
   // CENTRAL BOARD
   //////////////////////////////////////////
   //////////////////////////////////////////
   // PROJECTIONS
   //////////////////////////////////////////
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_L3F3F5_pipe_minus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_L3F3F5_ToPlus_minus), .val_out(Proj_L3F3F5_FromMinus_central)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_L3F3F5_pipe_plus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_L3F3F5_ToMinus_plus), .val_out(Proj_L3F3F5_FromPlus_central)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_L2L4F2_pipe_minus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_L2L4F2_ToPlus_minus), .val_out(Proj_L2L4F2_FromMinus_central)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_L2L4F2_pipe_plus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_L2L4F2_ToMinus_plus), .val_out(Proj_L2L4F2_FromPlus_central)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_F1L5_pipe_minus(.pipe_in(), .pipe_out(), .clk(clk),
			    .val_in(Proj_F1L5_ToPlus_minus), .val_out(Proj_F1L5_FromMinus_central)
			    );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_F1L5_pipe_plus(.pipe_in(), .pipe_out(), .clk(clk),
			    .val_in(Proj_F1L5_ToMinus_plus), .val_out(Proj_F1L5_FromPlus_central)
			    );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_L1L6F4_pipe_minus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_L1L6F4_ToPlus_minus), .val_out(Proj_L1L6F4_FromMinus_central)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjMinus_L1L6F4_pipe_plus(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_L1L6F4_ToMinus_plus), .val_out(Proj_L1L6F4_FromPlus_central)
			      );

   //////////////////////////////////////////
   // MATCHES
   //////////////////////////////////////////
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_Layer_Plus_pipe_minus_central(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Match_Layer_ToPlus_minus), .val_out(Match_Layer_FromMinus_central)
			      );
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_Layer_Minus_pipe_plus_central(.pipe_in(), .pipe_out(), .clk(clk),
			.val_in(Match_Layer_ToMinus_plus), .val_out(Match_Layer_FromPlus_central)
			);
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_FDSK_Plus_pipe_minus_central(.pipe_in(), .pipe_out(), .clk(clk),
			   .val_in(Match_FDSK_ToPlus_minus), .val_out(Match_FDSK_FromMinus_central)
			   );
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_FDSK_Minus_pipe_plus_central(.pipe_in(), .pipe_out(), .clk(clk),
			  .val_in(Match_FDSK_ToMinus_plus), .val_out(Match_FDSK_FromPlus_central)
			  );
   
   
   ////////////////////////////////////////// 
   ////////////////////////////////////////// 
   // PLUS BOARD
   //////////////////////////////////////////
   //////////////////////////////////////////
   // PROJECTIONS
   //////////////////////////////////////////
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_L3F3F5_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				.val_in(Proj_L3F3F5_ToPlus_central), .val_out(Proj_L3F3F5_FromMinus_plus)
				);
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_L2L4F2_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				.val_in(Proj_L2L4F2_ToPlus_central), .val_out(Proj_L2L4F2_FromMinus_plus)
				);
   
   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_F1L5_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
			      .val_in(Proj_F1L5_ToPlus_central), .val_out(Proj_F1L5_FromMinus_plus)
			      );

   pipe_delay #(.STAGES(76), .WIDTH(55))
   ProjPlus_L1L6F4_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				.val_in(Proj_L1L6F4_ToPlus_central), .val_out(Proj_L1L6F4_FromMinus_plus)
				);

   //////////////////////////////////////////
   // MATCHES
   //////////////////////////////////////////
   
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_Layer_Plus_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				.val_in(Match_Layer_ToPlus_central), .val_out(Match_Layer_FromMinus_plus)
				);
   pipe_delay #(.STAGES(76), .WIDTH(45))
   Match_FDSK_Plus_pipe_central(.pipe_in(), .pipe_out(), .clk(clk),
				.val_in(Match_FDSK_ToPlus_central), .val_out(Match_FDSK_FromMinus_plus)
				);
   
   
   initial begin
      // Initialize Inputs
      reset = 0;
      clk = 1;    
      BC0 = 0;    
      // Wait 100 ns for global reset to finish
      #100;
   end
   
   initial begin
      // Initialize Inputs
      reset = 0;
      clk = 1;    
      BC0 = 0;    
      // Wait 100 ns for global reset to finish
      #100;
   end
   
   // Add stimulus here
   // clocks
   //always begin
   //#4 ipb_clk = ~ipb_clk;   // 125 MHz
   //end
   always begin
      #2.5 clk = ~clk;        // 200 MHZ (wrong comment 250 MHz)
      //#2.083 clk = ~clk;      //~240 MHZ
   end
   always begin
      //#20950 BC0 = ~BC0;    // Fake orbit clock
      #106920 BC0 = ~BC0;     // Fake orbit clock: 3564*6 (clk) * 5 ns/clk
      #2.5 BC0 = ~BC0;
   end
   // reset
   initial begin
      #110
        reset = 1'b1;
      #10
        reset = 1'b0;
   end
   
   input_sim simulate_inputs(
			     .clk(clk),
			     .reset(reset),
			     .BC0(BC0),
			     .link1_reg1_minus(link1_reg1_minus),
			     .link1_reg2_minus(link1_reg2_minus),
			     .link2_reg1_minus(link2_reg1_minus),
			     .link2_reg2_minus(link2_reg2_minus),
			     .link3_reg1_minus(link3_reg1_minus),
			     .link3_reg2_minus(link3_reg2_minus),
			     .link1_reg1_central(link1_reg1_central),
			     .link1_reg2_central(link1_reg2_central),
			     .link2_reg1_central(link2_reg1_central),
			     .link2_reg2_central(link2_reg2_central),
			     .link3_reg1_central(link3_reg1_central),
			     .link3_reg2_central(link3_reg2_central),
			     .link1_reg1_plus(link1_reg1_plus),
			     .link1_reg2_plus(link1_reg2_plus),
			     .link2_reg1_plus(link2_reg1_plus),
			     .link2_reg2_plus(link2_reg2_plus),
			     .link3_reg1_plus(link3_reg1_plus),
			     .link3_reg2_plus(link3_reg2_plus),

			     // additional inputs for D3D4 project
			     .link4_reg1_minus(link4_reg1_minus),
			     .link4_reg2_minus(link4_reg2_minus),
			     .link5_reg1_minus(link5_reg1_minus),
			     .link5_reg2_minus(link5_reg2_minus),
			     .link6_reg1_minus(link6_reg1_minus),
			     .link6_reg2_minus(link6_reg2_minus),
			     .link4_reg1_central(link4_reg1_central),
			     .link4_reg2_central(link4_reg2_central),
			     .link5_reg1_central(link5_reg1_central),
			     .link5_reg2_central(link5_reg2_central),
			     .link6_reg1_central(link6_reg1_central),
			     .link6_reg2_central(link6_reg2_central),
			     .link4_reg1_plus(link4_reg1_plus),
			     .link4_reg2_plus(link4_reg2_plus),
			     .link5_reg1_plus(link5_reg1_plus),
			     .link5_reg2_plus(link5_reg2_plus),
			     .link6_reg1_plus(link6_reg1_plus),
			     .link6_reg2_plus(link6_reg2_plus),
			     
			     // additional inputs for D4D6 project (3 DTC regions)
                 .link7_reg1_minus(link7_reg1_minus),
                 .link7_reg2_minus(link7_reg2_minus),
                 .link8_reg1_minus(link8_reg1_minus),
                 .link8_reg2_minus(link8_reg2_minus),
                 .link9_reg1_minus(link9_reg1_minus),
                 .link9_reg2_minus(link9_reg2_minus),
                 .link7_reg1_central(link7_reg1_central),
                 .link7_reg2_central(link7_reg2_central),
                 .link8_reg1_central(link8_reg1_central),
                 .link8_reg2_central(link8_reg2_central),
                 .link9_reg1_central(link9_reg1_central),
                 .link9_reg2_central(link9_reg2_central),
                 .link7_reg1_plus(link7_reg1_plus),
                 .link7_reg2_plus(link7_reg2_plus),
                 .link8_reg1_plus(link8_reg1_plus),
                 .link8_reg2_plus(link8_reg2_plus),
                 .link9_reg1_plus(link9_reg1_plus),
                 .link9_reg2_plus(link9_reg2_plus)		     
			     
      			     );
      			     
   output_sim #({USER_DIR,"firmware/"}) write_outputs(
			    .clk(clk),
			    .reset(reset),
			    .BC0(BC0)

			    );

   
   
endmodule
