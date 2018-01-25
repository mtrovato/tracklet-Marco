//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.4 (lin64) Build 1071353 Tue Nov 18 16:47:07 MST 2014
//Date        : Tue Jun 16 17:09:27 2015
//Host        : mq154.lns.cornell.edu running 64-bit Scientific Linux release 6.6 (Carbon)
//Command     : generate_target eyescan_subsystem_wrapper.bd
//Design      : eyescan_subsystem_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module eyescan_subsystem_wrapper
   (AXI_aclk,
    gt_drp_0_daddr,
    gt_drp_0_den,
    gt_drp_0_di,
    gt_drp_0_do,
    gt_drp_0_drdy,
    gt_drp_0_dwe,
    gt_drp_1_daddr,
    gt_drp_1_den,
    gt_drp_1_di,
    gt_drp_1_do,
    gt_drp_1_drdy,
    gt_drp_1_dwe,
    gt_drp_2_daddr,
    gt_drp_2_den,
    gt_drp_2_di,
    gt_drp_2_do,
    gt_drp_2_drdy,
    gt_drp_2_dwe,
    gt_drp_3_daddr,
    gt_drp_3_den,
    gt_drp_3_di,
    gt_drp_3_do,
    gt_drp_3_drdy,
    gt_drp_3_dwe,
    reset);
  input AXI_aclk;
  output [8:0]gt_drp_0_daddr;
  output gt_drp_0_den;
  output [15:0]gt_drp_0_di;
  input [15:0]gt_drp_0_do;
  input gt_drp_0_drdy;
  output gt_drp_0_dwe;
  output [8:0]gt_drp_1_daddr;
  output gt_drp_1_den;
  output [15:0]gt_drp_1_di;
  input [15:0]gt_drp_1_do;
  input gt_drp_1_drdy;
  output gt_drp_1_dwe;
  output [8:0]gt_drp_2_daddr;
  output gt_drp_2_den;
  output [15:0]gt_drp_2_di;
  input [15:0]gt_drp_2_do;
  input gt_drp_2_drdy;
  output gt_drp_2_dwe;
  output [8:0]gt_drp_3_daddr;
  output gt_drp_3_den;
  output [15:0]gt_drp_3_di;
  input [15:0]gt_drp_3_do;
  input gt_drp_3_drdy;
  output gt_drp_3_dwe;
  input reset;

  wire AXI_aclk;
  wire [8:0]gt_drp_0_daddr;
  wire gt_drp_0_den;
  wire [15:0]gt_drp_0_di;
  wire [15:0]gt_drp_0_do;
  wire gt_drp_0_drdy;
  wire gt_drp_0_dwe;
  wire [8:0]gt_drp_1_daddr;
  wire gt_drp_1_den;
  wire [15:0]gt_drp_1_di;
  wire [15:0]gt_drp_1_do;
  wire gt_drp_1_drdy;
  wire gt_drp_1_dwe;
  wire [8:0]gt_drp_2_daddr;
  wire gt_drp_2_den;
  wire [15:0]gt_drp_2_di;
  wire [15:0]gt_drp_2_do;
  wire gt_drp_2_drdy;
  wire gt_drp_2_dwe;
  wire [8:0]gt_drp_3_daddr;
  wire gt_drp_3_den;
  wire [15:0]gt_drp_3_di;
  wire [15:0]gt_drp_3_do;
  wire gt_drp_3_drdy;
  wire gt_drp_3_dwe;
  wire reset;

eyescan_subsystem eyescan_subsystem_i
       (.AXI_aclk(AXI_aclk),
        .gt_drp_0_daddr(gt_drp_0_daddr),
        .gt_drp_0_den(gt_drp_0_den),
        .gt_drp_0_di(gt_drp_0_di),
        .gt_drp_0_do(gt_drp_0_do),
        .gt_drp_0_drdy(gt_drp_0_drdy),
        .gt_drp_0_dwe(gt_drp_0_dwe),
        .gt_drp_1_daddr(gt_drp_1_daddr),
        .gt_drp_1_den(gt_drp_1_den),
        .gt_drp_1_di(gt_drp_1_di),
        .gt_drp_1_do(gt_drp_1_do),
        .gt_drp_1_drdy(gt_drp_1_drdy),
        .gt_drp_1_dwe(gt_drp_1_dwe),
        .gt_drp_2_daddr(gt_drp_2_daddr),
        .gt_drp_2_den(gt_drp_2_den),
        .gt_drp_2_di(gt_drp_2_di),
        .gt_drp_2_do(gt_drp_2_do),
        .gt_drp_2_drdy(gt_drp_2_drdy),
        .gt_drp_2_dwe(gt_drp_2_dwe),
        .gt_drp_3_daddr(gt_drp_3_daddr),
        .gt_drp_3_den(gt_drp_3_den),
        .gt_drp_3_di(gt_drp_3_di),
        .gt_drp_3_do(gt_drp_3_do),
        .gt_drp_3_drdy(gt_drp_3_drdy),
        .gt_drp_3_dwe(gt_drp_3_dwe),
        .reset(reset));
endmodule
