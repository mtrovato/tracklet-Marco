`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 10:49:27 AM
// Design Name: 
// Module Name: TrackletCombiner
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


module TrackletCalculator_old(
    input clk,
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    output [1:0] done_proj,
    
    input [5:0] number_in_stubpair1in,
    output [8:0] read_add_stubpair1in,
    input [11:0] stubpair1in,
    input [5:0] number_in_stubpair2in,
    output [8:0] read_add_stubpair2in,
    input [11:0] stubpair2in,
    input [5:0] number_in_stubpair3in,
    output [8:0] read_add_stubpair3in,
    input [11:0] stubpair3in,
    input [5:0] number_in_stubpair4in,
    output [8:0] read_add_stubpair4in,
    input [11:0] stubpair4in,
    input [5:0] number_in_stubpair5in,
    output [8:0] read_add_stubpair5in,
    input [11:0] stubpair5in,
    input [5:0] number_in_stubpair6in,
    output [8:0] read_add_stubpair6in,
    input [11:0] stubpair6in,
    input [5:0] number_in_stubpair7in,
    output [8:0] read_add_stubpair7in,
    input [11:0] stubpair7in,
    input [5:0] number_in_stubpair8in,
    output [8:0] read_add_stubpair8in,
    input [11:0] stubpair8in,
    input [5:0] number_in_stubpair9in,
    output [8:0] read_add_stubpair9in,
    input [11:0] stubpair9in,
    input [5:0] number_in_stubpair10in,
    output [8:0] read_add_stubpair10in,
    input [11:0] stubpair10in,
    input [5:0] number_in_stubpair11in,
    output [8:0] read_add_stubpair11in,
    input [11:0] stubpair11in,
    input [5:0] number_in_stubpair12in,
    output [8:0] read_add_stubpair12in,
    input [11:0] stubpair12in,
    input [5:0] number_in_stubpair13in,
    output [8:0] read_add_stubpair13in,
    input [11:0] stubpair13in,
    input [5:0] number_in_stubpair14in,
    output [8:0] read_add_stubpair14in,
    input [11:0] stubpair14in,
    input [5:0] number_in_stubpair15in,
    output [8:0] read_add_stubpair15in,
    input [11:0] stubpair15in,
    input [5:0] number_in_stubpair16in,
    output [8:0] read_add_stubpair16in,
    input [11:0] stubpair16in,
    input [5:0] number_in_stubpair17in,
    output [8:0] read_add_stubpair17in,
    input [11:0] stubpair17in,
    input [5:0] number_in_stubpair18in,
    output [8:0] read_add_stubpair18in,
    input [11:0] stubpair18in,
    input [5:0] number_in_stubpair19in,
    output [8:0] read_add_stubpair19in,
    input [11:0] stubpair19in,
    input [5:0] number_in_stubpair20in,
    output [8:0] read_add_stubpair20in,
    input [11:0] stubpair20in,
    input [5:0] number_in_stubpair21in,
    output [8:0] read_add_stubpair21in,
    input [11:0] stubpair21in,
    input [5:0] number_in_stubpair22in,
    output [8:0] read_add_stubpair22in,
    input [11:0] stubpair22in,
    input [5:0] number_in_stubpair23in,
    output [8:0] read_add_stubpair23in,
    input [11:0] stubpair23in,
    input [5:0] number_in_stubpair24in,
    output [8:0] read_add_stubpair24in,
    input [11:0] stubpair24in,
    
    output reg [10:0] read_add_innerallstubin,
    output reg [10:0] read_add_outerallstubin,
    input [35:0] innerallstubin,
    input [35:0] outerallstubin,
    
    (* mark_debug = "true" *) output reg [67:0] trackpar,
    output [53:0] projout_L1D3,
    output [53:0] projout_L2D3,
    output [53:0] projout_L3D3,
    output [53:0] projout_L4D3,
    output [53:0] projout_L5D3,
    output [53:0] projout_L6D3,
    
    output [53:0] projout_L1D4,
    output [53:0] projout_L2D4,
    output [53:0] projout_L3D4,
    output [53:0] projout_L4D4,
    output [53:0] projout_L5D4,
    output [53:0] projout_L6D4,
    
    output [53:0] projout_F1D5,
    output [53:0] projout_F1D6,
    output [53:0] projout_F2D5,
    output [53:0] projout_F2D6,
    output [53:0] projout_F3D5,
    output [53:0] projout_F3D6,
    output [53:0] projout_F4D5,
    output [53:0] projout_F4D6,
    output [53:0] projout_F5D5,
    output [53:0] projout_F5D6,
    
    output [53:0] projoutToPlus_L1,
    output [53:0] projoutToPlus_L2,
    output [53:0] projoutToPlus_L3,
    output [53:0] projoutToPlus_L4,
    output [53:0] projoutToPlus_L5,
    output [53:0] projoutToPlus_L6,
    output [53:0] projoutToPlus_F1,
    output [53:0] projoutToPlus_F2,
    output [53:0] projoutToPlus_F3,
    output [53:0] projoutToPlus_F4,
    output [53:0] projoutToPlus_F5,
    output [53:0] projoutToMinus_L1,
    output [53:0] projoutToMinus_L2,
    output [53:0] projoutToMinus_L3,
    output [53:0] projoutToMinus_L4,
    output [53:0] projoutToMinus_L5,
    output [53:0] projoutToMinus_L6,
    output [53:0] projoutToMinus_F1,
    output [53:0] projoutToMinus_F2,
    output [53:0] projoutToMinus_F3,
    output [53:0] projoutToMinus_F4,
    output [53:0] projoutToMinus_F5,
    
    output reg valid_trackpar,
    output valid_projout_L1D3,
    output valid_projout_L2D3,
    output valid_projout_L3D3,
    output valid_projout_L4D3,
    output valid_projout_L5D3,
    output valid_projout_L6D3,
    output valid_projout_L1D4,
    output valid_projout_L2D4,
    output valid_projout_L3D4,
    output valid_projout_L4D4,
    output valid_projout_L5D4,
    output valid_projout_L6D4,
    output valid_projout_F1D5,
    output valid_projout_F1D6,
    output valid_projout_F2D5,
    output valid_projout_F2D6,
    output valid_projout_F3D5,
    output valid_projout_F3D6,
    output valid_projout_F4D5,
    output valid_projout_F4D6,
    output valid_projout_F5D5,
    output valid_projout_F5D6,
    output valid_projoutToPlus_L1,
    output valid_projoutToPlus_L2,
    output valid_projoutToPlus_L3,
    output valid_projoutToPlus_L4,
    output valid_projoutToPlus_L5,
    output valid_projoutToPlus_L6,
    output valid_projoutToPlus_F1,
    output valid_projoutToPlus_F2,
    output valid_projoutToPlus_F3,
    output valid_projoutToPlus_F4,
    output valid_projoutToPlus_F5,
    output valid_projoutToMinus_L1,
    output valid_projoutToMinus_L2,
    output valid_projoutToMinus_L3,
    output valid_projoutToMinus_L4,
    output valid_projoutToMinus_L5,
    output valid_projoutToMinus_L6,
    output valid_projoutToMinus_F1,
    output valid_projoutToMinus_F2,
    output valid_projoutToMinus_F3,
    output valid_projoutToMinus_F4,
    output valid_projoutToMinus_F5
    
    );
    
    ///////////////////////////////////////////////
    reg [4:0] BX_pipe;
    reg first_clk_pipe;
    reg [4:0] BX_pipe_hold1;
    reg [4:0] BX_pipe_hold2;
    reg [4:0] BX_pipe_hold3;
    reg [4:0] BX_pipe_hold4;
    reg [4:0] BX_pipe_hold5;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
    initial begin
       BX_pipe = 5'b11111;
    end
    
    always @(posedge clk) begin
        if(rst_pipe)
           BX_pipe <= 5'b11111;
        else begin
            if(start[0]) begin
               BX_pipe <= BX_pipe + 1'b1;
               first_clk_pipe <= 1'b1;
            end
            else begin
               first_clk_pipe <= 1'b0;
            end
        end
        BX_pipe_hold1 <= BX_pipe;
        BX_pipe_hold2 <= BX_pipe_hold1;
        BX_pipe_hold3 <= BX_pipe_hold2;
        BX_pipe_hold4 <= BX_pipe_hold3;
        BX_pipe_hold5 <= BX_pipe_hold4;
    end
    
    // Done signals for Tracklets and Projections    
    pipe_delay #(.STAGES(49), .WIDTH(2))
               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done));
    
    pipe_delay #(.STAGES(66), .WIDTH(2))
               done_proj_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done_proj));
    
    
    ///////////////////////////////////////////////////
    initial begin
        read_add_innerallstubin = 11'h7ff;
        read_add_outerallstubin = 11'h7ff;
    end
    
    //////////////////////////////////////////////////////////////////
           
   wire [11:0] stubpair;
   reg first_clk_pipe_dly;
   
   wire [5:0] pre_read_add1;
   wire [5:0] pre_read_add2;
   wire [5:0] pre_read_add3;
   wire [5:0] pre_read_add4;
   wire [5:0] pre_read_add5;
   wire [5:0] pre_read_add6;
   wire [5:0] pre_read_add7;
   wire [5:0] pre_read_add8;
   wire [5:0] pre_read_add9;
   wire [5:0] pre_read_add10;
   wire [5:0] pre_read_add11;
   wire [5:0] pre_read_add12;
   wire [5:0] pre_read_add13;
   wire [5:0] pre_read_add14;
   wire [5:0] pre_read_add15;
   wire [5:0] pre_read_add16;
   wire [5:0] pre_read_add17;
   wire [5:0] pre_read_add18;
   wire [5:0] pre_read_add19;
   wire [5:0] pre_read_add20;
   wire [5:0] pre_read_add21;
   wire [5:0] pre_read_add22;
   wire [5:0] pre_read_add23;
   wire [5:0] pre_read_add24;
   
   assign read_add_stubpair1in = {BX_pipe_hold1[2:0],pre_read_add1};
   assign read_add_stubpair2in = {BX_pipe_hold1[2:0],pre_read_add2};
   assign read_add_stubpair3in = {BX_pipe_hold1[2:0],pre_read_add3};
   assign read_add_stubpair4in = {BX_pipe_hold1[2:0],pre_read_add4};
   assign read_add_stubpair5in = {BX_pipe_hold1[2:0],pre_read_add5};
   assign read_add_stubpair6in = {BX_pipe_hold1[2:0],pre_read_add6};
   assign read_add_stubpair7in = {BX_pipe_hold1[2:0],pre_read_add7};
   assign read_add_stubpair8in = {BX_pipe_hold1[2:0],pre_read_add8};
   assign read_add_stubpair9in = {BX_pipe_hold1[2:0],pre_read_add9};
   assign read_add_stubpair10in = {BX_pipe_hold1[2:0],pre_read_add10};
   assign read_add_stubpair11in = {BX_pipe_hold1[2:0],pre_read_add11};
   assign read_add_stubpair12in = {BX_pipe_hold1[2:0],pre_read_add12};
   assign read_add_stubpair13in = {BX_pipe_hold1[2:0],pre_read_add13};
   assign read_add_stubpair14in = {BX_pipe_hold1[2:0],pre_read_add14};
   assign read_add_stubpair15in = {BX_pipe_hold1[2:0],pre_read_add15};
   assign read_add_stubpair16in = {BX_pipe_hold1[2:0],pre_read_add16};
   assign read_add_stubpair17in = {BX_pipe_hold1[2:0],pre_read_add17};
   assign read_add_stubpair18in = {BX_pipe_hold1[2:0],pre_read_add18};
   assign read_add_stubpair19in = {BX_pipe_hold1[2:0],pre_read_add19};
   assign read_add_stubpair20in = {BX_pipe_hold1[2:0],pre_read_add20};
   assign read_add_stubpair21in = {BX_pipe_hold1[2:0],pre_read_add21};
   assign read_add_stubpair22in = {BX_pipe_hold1[2:0],pre_read_add22};
   assign read_add_stubpair23in = {BX_pipe_hold1[2:0],pre_read_add23};
   assign read_add_stubpair24in = {BX_pipe_hold1[2:0],pre_read_add24};


   mem_readout_top StubPairs(
      .clk(clk),
      .new_event(first_clk_pipe_dly),
      
      .items00(number_in_stubpair1in),
      .addr00(pre_read_add1),
      .mem_dat00(stubpair1in),
      .items01(number_in_stubpair2in),
      .addr01(pre_read_add2),
      .mem_dat01(stubpair2in),
      .items02(number_in_stubpair3in),
      .addr02(pre_read_add3),
      .mem_dat02(stubpair3in),
      .items03(number_in_stubpair4in),
      .addr03(pre_read_add4),
      .mem_dat03(stubpair4in),
      .items04(number_in_stubpair5in),
      .addr04(pre_read_add5),
      .mem_dat04(stubpair5in),
      .items05(number_in_stubpair6in),
      .addr05(pre_read_add6),
      .mem_dat05(stubpair6in),
      .items06(number_in_stubpair7in),
      .addr06(pre_read_add7),
      .mem_dat06(stubpair7in),
      .items07(number_in_stubpair8in),
      .addr07(pre_read_add8),
      .mem_dat07(stubpair8in),
      .items08(number_in_stubpair9in),
      .addr08(pre_read_add9),
      .mem_dat08(stubpair9in),
      .items09(number_in_stubpair10in),
      .addr09(pre_read_add10),
      .mem_dat09(stubpair10in),
      
      .items10(number_in_stubpair11in),
      .addr10(pre_read_add11),
      .mem_dat10(stubpair11in),
      .items11(number_in_stubpair12in),
      .addr11(pre_read_add12),
      .mem_dat11(stubpair12in),
      .items12(number_in_stubpair13in),
      .addr12(pre_read_add13),
      .mem_dat12(stubpair13in),
      .items13(number_in_stubpair14in),
      .addr13(pre_read_add14),
      .mem_dat13(stubpair14in),
      .items14(number_in_stubpair15in),
      .addr14(pre_read_add15),
      .mem_dat14(stubpair15in),
      .items15(number_in_stubpair16in),
      .addr15(pre_read_add16),
      .mem_dat15(stubpair16in),
      .items16(number_in_stubpair17in),
      .addr16(pre_read_add17),
      .mem_dat16(stubpair17in),
      .items17(number_in_stubpair18in),
      .addr17(pre_read_add18),
      .mem_dat17(stubpair18in),
      .items18(number_in_stubpair19in),
      .addr18(pre_read_add19),
      .mem_dat18(stubpair19in),
      .items19(number_in_stubpair20in),
      .addr19(pre_read_add20),
      .mem_dat19(stubpair20in),
      
      .items20(number_in_stubpair21in),
      .addr20(pre_read_add21),
      .mem_dat20(stubpair21in),
      .items21(number_in_stubpair22in),
      .addr21(pre_read_add22),
      .mem_dat21(stubpair22in),
      .items22(number_in_stubpair23in),
      .addr22(pre_read_add23),
      .mem_dat22(stubpair23in),
      .items23(number_in_stubpair24in),
      .addr23(pre_read_add24),
      .mem_dat23(stubpair24in),
      
      .mem_dat_stream(stubpair),
      .valid(pre_valid_trackpar),
      .none()
      );
      
    reg [44:0] behold; // valid tracklet data hold
    wire pass_cut;
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_trackpar;
        behold[44:1] <= behold[43:0];
        valid_trackpar <= behold[42] && pass_cut;

        first_clk_pipe_dly  <= first_clk_pipe;
        if(stubpair >= 0) begin
            read_add_innerallstubin <= {BX_pipe_hold3,stubpair[11:6]};
            read_add_outerallstubin <= {BX_pipe_hold3,stubpair[5:0]};
        end
   end
   
   wire [5:0] inner_stub_index;
   wire [5:0] outer_stub_index;
   
   pipe_delay #(.STAGES(42), .WIDTH(6))
          inner_index(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
          .val_in(read_add_innerallstubin), .val_out(inner_stub_index)); 
   
   pipe_delay #(.STAGES(42), .WIDTH(6))
          outer_index(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
          .val_in(read_add_outerallstubin), .val_out(outer_stub_index)); 
   
    //////////////////////////////////////////////////////////////////
//    For L1L2 seeding only.
   
//    AllStubs L1 -> L3 is 7bits for R, 12 bits for Z and 14 bits in phi.
//    AllStubs L4 -> L6 is 8bits for R, 8 bits for Z and 17 bits in phi.
   
//    Therefore going with max, 8bits for R, 12 bits for Z and 17 bits in phi. 

//***************  R  *************************       
//    R1 is from 20 to 26 cm, Ave=23
//    R2 is from 32.5 to 38.5 cm, Ave=35.5
   
//    Actual R = R_ave + ir * R_bin, 
//     Where R_bin =( +/-3 cm / 2^6) = +/-0.046875cm increments. 
       
//    R is then doubled so that the resolution matches L4-6 resolution
//     So, krA (R_Ave L1) = 981 and krB (R_Ave L2) = 1514

//***************  Z  *************************       
//   The range is from -115 to 115cm, with 12 bits that's Z = -115 + iz * 0.0561523.
//    Note that Z for some reason is NOT a signed number 
//    Therefore if we want to get a Z corresponding to Z=0, then iz is going to be 1<<(nzbits-1).
   
//***************  Phi  ***********************     
//    PHI 2 is from 0 to (2*pi/28)(4/3). Phi_bin = (2*pi/21)/2^14 =0.0000178455171131 
//    PHI 1 is from (1/8)(2*pi/21) to  (7/8)(2*pi/21)
//    Times 8, to match the resolution of L4-6   
//////////////////////////////////////////////////////////////////
    
    parameter DR_TABLE = "InvTable_TC_L1D3L2D3_hex.dat";      
    parameter krA = 12'sd981;    //R_ave L1 doubled
    parameter krB = 12'sd1515;   //R_ave L2 doubled
    parameter innerA = 1'b1;
    parameter innerB = 1'b1;
    parameter TC_index = 4'b0000;
    
    // Step 0: Define the variables
    // L1
    reg signed [7:0] r_A_0;
    reg [11:0] z_A_0;
    reg [16:0] phi_A_0;
    // L2
    reg signed [7:0] r_B_0;
    reg [11:0] z_B_0;
    reg [16:0] phi_B_0;
    
    reg signed [19:0] k_r_A;
    reg signed [19:0] k_r_B;
    
    // Why multiply these numbers???????
    // Because you want to always have the same number of bits for all layers
    // phi = 17, r = 8, z =8
    
    
    
    always @(posedge clk) begin
       k_r_A        <= krA;
       k_r_B        <= krB;
       if(innerA) begin
           r_A_0        <= innerallstubin[32:26]<<<1'b1;//times 2 to match the resolution of L4-6
           z_A_0        <= innerallstubin[25:14];
           phi_A_0      <= innerallstubin[13:0]<<<2'b11;//times 8 to match the resolution of L4-6
       end
       else begin
           r_A_0        <= innerallstubin[32:25];
           z_A_0        <= innerallstubin[24:17]<<<3'b100;//times 16 to match the resolution of L1-3
           phi_A_0      <= innerallstubin[16:0];
       end
       if(innerB) begin
           r_B_0        <= outerallstubin[32:26]<<<1'b1;//times 2 to match the resolution of L4-6
           z_B_0        <= outerallstubin[25:14];
           phi_B_0      <= outerallstubin[13:0]<<<2'b11;//times 8 to match the resolution of L4-6
        end
        else begin
           r_B_0        <= outerallstubin[32:25];
           z_B_0        <= outerallstubin[24:17]<<<3'b100;//times 16 to match the resolution of L1-3
           phi_B_0      <= outerallstubin[16:0];
        end
    end
    
    
    // Step 1: Calculate deltas and absolute radii
    // Carry over:
    wire [9:0] z_A_pipe13;
    wire [16:0] phi_A_pipe13;
    // Declare:
    reg signed [15:0] idelta_phi_1;
    reg signed [11:0] idelta_z_1;
    reg [13:0] idelta_r_1;
    reg [13:0] idelta_r_pipe;
    reg [12:0] rA_abs_1;
    reg [12:0] rB_abs_1;
    reg signed [8:0] idrrel;
    reg signed [8:0] idrrel_pipe;
    
    pipe_delay #(.STAGES(38), .WIDTH(10))//z_A_pipe13 = Z_A_0 Delayed 38 clocks for eq21 z0=z1-t12.
           z_A_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(z_A_0[9:0]), .val_out(z_A_pipe13));
    pipe_delay #(.STAGES(38), .WIDTH(17))//phi_A_pipe13 = phi_A_0 Delayed 38 clocks for eq18 phi0=phi1 + t10.
           phi_A_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(phi_A_0), .val_out(phi_A_pipe13));
    
    
    always @(posedge clk) begin
       //z_A_1             <= z_A_0;
       //phi_A_1           <= phi_A_0;
       idelta_phi_1        <= phi_B_0 - phi_A_0; // eq1. delta phi = phi2-phi1 *****idelta is 2 bits smaller than phi_N_0 // bit size mismatch here
       idelta_z_1          <= z_B_0 - z_A_0; // eq3
       idelta_r_1          <= (k_r_B-k_r_A)+(r_B_0 - r_A_0); // eq3
       idelta_r_pipe       <= idelta_r_1; // Latch Idelta
       rA_abs_1            <= k_r_A+r_A_0; //Full value of rA for later calculations.
       rB_abs_1            <= k_r_B+r_B_0; //Full value of rB for later calculations.
       idrrel              <= r_B_0-r_A_0;
       idrrel_pipe         <= idrrel;
    end
    
    wire signed [15:0] idelta_phi_pipe8;
    
    //idelta_phi_pipe8 = idelta_phi_1 Delayed 21 clocks for eq12 1/p=2deltaphi/delta.  One clock less than z, so phi can be inverted. 
    pipe_delay #(.STAGES(21), .WIDTH(16))
       idelta_phi_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(idelta_phi_1), .val_out(idelta_phi_pipe8));
    
    wire signed [11:0] idelta_z_pipe9;
    
    // idelta_z_pipe9 = idelta_z_1 Delayed 22 clocks for eq13 t6=deltaz/delta
    pipe_delay #(.STAGES(22), .WIDTH(12))
       idelta_z_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(idelta_z_1), .val_out(idelta_z_pipe9));
    
    wire signed [12:0] rA_abs_pipe10;
    
    // rA_abs_pipe10= rA_abs_1 delayed 24 clocks for eq14 t7=r1/2p
    pipe_delay #(.STAGES(24), .WIDTH(13))
                   rA_abs_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
                   .val_in(rA_abs_1), .val_out(rA_abs_pipe10));
    // Step 2: Lookup dr inverse
    // Carry over:
    reg signed [15:0] idelta_phi_2;
    // Declare:
    wire signed [15:0] idr_inv_2; //Result of eq4 1/deltaR // was 14:0
    reg [25:0] full_it1;    
    reg [25:0] full_it1_pipe;    
    wire [2:0] it1_2;// was 11
    
    //eq4 1/deltaR.  Memory contains intergers whose value is 2^20/deltaR  Rounded down. 
    Memory #(
           .RAM_WIDTH(16),                       // Specify RAM data width
           .RAM_DEPTH(512),                     // Specify RAM depth (number of entries)
           .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
           .INIT_FILE(DR_TABLE)
           //.INIT_FILE("/home/mzientek/CTP7/firmware/TrackletProject/AdditionalFiles/dr_inv.txt")    // Specify name/location of RAM initialization file if using one (leave blank if not)
         ) lookup_dr_inv (
           .addra(9'b0),    // Write address bus, width determined from RAM_DEPTH
           .addrb(idrrel_pipe),  //idelta_r_pipe   // Read address bus, width determined from RAM_DEPTH
           .dina(16'b0),      // RAM input data, width determined from RAM_WIDTH
           .clka(clk),      // Write clock
           .clkb(clk),      // Read clock
           .wea(1'b0),        // Write enable
           .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
           .rstb(rst_pipe),      // Output reset (does not affect memory contents)
           .regceb(1'b1),  // Output register enable
           .doutb(idr_inv_2)     // RAM output data, width determined from RAM_WIDTH
       );
    
    wire signed [11:0] idr_inv_pipe8;
       
    pipe_delay #(.STAGES(16), .WIDTH(12))//idr_inv_pipe8 = idr_inv_2 delayed 17 clocks for eq11
       idr_inv_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(idr_inv_2[11:0]), .val_out(idr_inv_pipe8));
    
    always @(posedge clk) begin
       idelta_phi_2     <= idelta_phi_1;// delay idelta_phi
       full_it1            <= rA_abs_1 * rB_abs_1;// eq5 t1=r1r2
       full_it1_pipe       <= full_it1;// latch t1
    end
    
    //assign it1_2 = full_it1[23:21];
    assign it1_2 = full_it1_pipe >> 5'd23;//divide t1 by 8388608  
    
    wire [2:0] it1_pipe4;
    
    pipe_delay #(.STAGES(6), .WIDTH(3))// it1_pipe4 = it1_2 delayed by 6 clocks for eq8
       it1_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(it1_2), .val_out(it1_pipe4));
    
    // Step 3: 
    // Carry over
    reg signed [15:0] idelta_phi_3;
    reg signed [15:0] idelta_phi_35;
    // Declare:
    reg signed [29:0] full_it2;
    reg signed [29:0] full_it2_pipe;
    reg signed [10:0] it2_3;
    
    always @(posedge clk) begin
       idelta_phi_3     <= idelta_phi_2;//deltaPhi delayed 1 more clock
       idelta_phi_35    <= idelta_phi_3;
       full_it2         <= idr_inv_2 * idelta_phi_35;
       full_it2_pipe    <= full_it2;
       it2_3            <= full_it2 >>> 4'd15; // divide by 32768  
    end 
       
    // Step 4: 
    // Declare:
    reg [35:0] full_it3;
    reg [35:0] full_it3_pipe;
    reg [6:0] it3_4;
    
    always @(posedge clk) begin
       full_it3            <= it2_3 * it2_3; //eq7 t3=t2^2
       full_it3_pipe       <= full_it3;
       it3_4 <= full_it3_pipe >>> 4'd13; // divide 8192
    end
    
    // Step 5: 
    // Declare:
    reg [8:0] full_idelta;
    reg [8:0] full_idelta_pipe;
    
    always @(posedge clk) begin
       full_idelta      <= (it1_pipe4 * it3_4) >>> 1'd1; //it1 is 3bits, it3 is 7 bits
       full_idelta_pipe <= full_idelta;// delay delta 1 clock, latch it

    end
    
    // Step 6:
    reg [8:0] idelta_tmp_6;
    //reg [6:0] idelta_tmp_6_pipe;
    // idelta --> ideltatmp  (cf. fpga_emulation/FPGATrackletCalculator.hh L1493)
    // 
    // kdelta ~ 0.00139875  cf. fpga_emulation/FPGAConstants.hh  L318
    // it4bits = 9
    // 
    // kdeltatmp = (kdelta * (1 << it4bits)) * (2^10)   (with kdeltashift = 10)
    // ideltatmp = round_int( idelta * kdeltatmp / 2^10 )
    // 
    localparam kdeltatmp = 10'd733;  // (kdelta * (1 << it4bits)) * (2^10)   (with kdeltashift = 10)
    reg [18:0] ideltaX;
    reg [18:0] ideltaX_pipe;
    
    always @(posedge clk) begin
       ideltaX <= full_idelta_pipe * kdeltatmp;
       ideltaX_pipe <= ideltaX;
       idelta_tmp_6 <= (ideltaX_pipe >>> 4'd10) + ideltaX_pipe[9];  // + ideltaX_pipe[4] for rounding to integar
       //idelta_tmp_6_pipe <= idelta_tmp_6[6:0];
    end
       
    // Step 7:
    reg signed [6:0] idelta_tmp_7;
    // Declare:
    reg [10:0] it4_7;
    
    always @(posedge clk) begin
       idelta_tmp_7      <= idelta_tmp_6[6:0];
       it4_7             <= (1'b1 <<< 4'd9) - 3*(idelta_tmp_6[6:0] >>> 1'b1); // eq9 t4 = 1-1.5*idelta_tmp
    end
    
    // Step 8:
    // Declare:
    wire [17:0] full_it5_test;
    reg [10:0] pre_it5_8;
    
    pipe_mult #(.STAGES(3), .AWIDTH(11), .BWIDTH(7))//full_it5_test = idelta_tmp_7*it4_7 delayed 3 clocks for eq10
           full_it5_mult(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
           .a(it4_7), .b(idelta_tmp_7), .p(full_it5_test));
    
    always @(posedge clk) begin
      pre_it5_8   <= (10'h0001 <<< 4'd9) - (full_it5_test >>> 4'd9); //eq10 t5=1-t4*delta
      //pre_it5_8   <= (10'h0001 <<< 4'd9) - ((it4_7 * idelta_tmp_7) >>> 4'd9);
    end
    
    // Step 9:
    reg signed [15:0] idelta_phi_9;
    reg signed [22:0] full_iDelta_inv;
    reg signed [22:0] full_iDelta_inv_pipe;
    reg signed [11:0] iDelta_inv_9;
    
    always @(posedge clk) begin
       idelta_phi_9         <= idelta_phi_pipe8;
       full_iDelta_inv      <= idr_inv_pipe8 * pre_it5_8; // 12 + 11 bits
       full_iDelta_inv_pipe <= full_iDelta_inv;
       iDelta_inv_9         <= full_iDelta_inv_pipe >>> 4'd9;
    end
    
    // Step 10:
    reg signed [26:0] full_irinv;
    reg signed [26:0] full_irinv_pipe;
    reg signed [27:0] it_10;
    reg signed [13:0] it_10_pipe;
    wire signed [14:0] irinv_10;
    wire signed [14:0] pre_irinv_10;
    
    always @(posedge clk) begin    
       full_irinv      <= idelta_phi_9 * iDelta_inv_9; // eq12 1/p=2deltaphi/delta
       full_irinv_pipe <= full_irinv; // latch full_irinv
       it_10           <= idelta_z_pipe9 * iDelta_inv_9; // eq13 t6=deltaz/delta // it_10 = it before shift in emulation, it6 in whitepaper
       it_10_pipe      <= it_10 >>> 4'd8;                //latch it_10 aka t6 // here is the shift that matches emulation
    end
    
    assign irinv_10 = -(full_irinv_pipe >>> 4'd11);
    assign pre_irinv_10 = -(full_irinv_pipe >>> 4'd11); //remanent from old calculator, why is this needed?
    
    wire signed [13:0] it_pipe13;
    
    pipe_delay #(.STAGES(13), .WIDTH(14))
       it_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(it_10_pipe), .val_out(it_pipe13));
    
    wire signed [14:0] irinv_pipe13;
    
    pipe_delay #(.STAGES(13), .WIDTH(15))
       irinv_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(irinv_10), .val_out(irinv_pipe13));
    
    // Step 11:
    wire signed [26:0] full_it7_test;
    wire signed [26:0] it7_11;
    wire signed [17:0] it7_tmp_11;
    wire signed [29:0] it7_tmp_11_pipe;
    reg signed [17:0] it7_tmp_sqr_11;
    reg signed [17:0] it7_tmp_sqr_11_pipe;
    reg signed [17:0] it7_tmp_sqr_11_pipe2;
    reg signed [12:0] pre_it_11;
    
    pipe_mult #(.STAGES(3), .AWIDTH(12), .BWIDTH(15)) //do rAabs>>1 * irinv
               full_it7_mult(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
               .a(rA_abs_pipe10[12:1]), .b(pre_irinv_10), .p(full_it7_test));
    
    pipe_mult #(.STAGES(3), .AWIDTH(18), .BWIDTH(12))
               it7_pretmp_mult(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
               .a(it7_tmp_11), .b(12'h3E8), .p(it7_tmp_11_pipe));   //multiply it7 * it7tmpfactor = 10'3E8
    
//    pipe_mult #(.STAGES(3), .AWIDTH(29), .BWIDTH(29))
//               it7_tmp_mult(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
//               .a(it7_tmp_11_pipe >>> 5'd20), .b(it7_tmp_11_pipe >>> 5'd20), .p(it7_tmp_sqr_11));
    
    
    always @(posedge clk) begin
       pre_it_11            <= it_10_pipe;
       //it7_tmp_11_pipe      <= it7_tmp_11; // FIND ME CHANGE TO MULTIPLICATION
       it7_tmp_sqr_11       <= (it7_tmp_11_pipe >>> 5'd20) * (it7_tmp_11_pipe >>> 5'd20);
       it7_tmp_sqr_11_pipe  <= it7_tmp_sqr_11;
       it7_tmp_sqr_11_pipe2  <= it7_tmp_sqr_11_pipe;
    end
    
    assign it7_11       = full_it7_test;
    assign it7_tmp_11   = (full_it7_test >>> 4'd8);
    
    wire signed [26:0] it7_pipe12;
    wire signed [12:0] pre_it_pipe11;
    wire signed [12:0] rA_abs_pipe11;
    
    pipe_delay #(.STAGES(7), .WIDTH(27))
           it7_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(it7_11), .val_out(it7_pipe12));
    
    pipe_delay #(.STAGES(7), .WIDTH(13))
           pre_it11_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(pre_it_11), .val_out(pre_it_pipe11));
    
    pipe_delay #(.STAGES(8), .WIDTH(13))
           rA_abs_pipe2(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(rA_abs_pipe10), .val_out(rA_abs_pipe11));
    
    // Step 12:
    reg signed [13:0] it9_12;
    reg signed [25:0] full_pre_it12;
    reg signed [25:0] full_pre_it12_pipe;
    wire signed [13:0] pre_it9_12;
    wire signed [17:0] pre_it7_12;      
    reg signed [18:0] pre_it12_12;      
    
    always @(posedge clk) begin
       it9_12             <= (14'h0001 <<< 4'd12) + (it7_tmp_sqr_11_pipe >>> 3'd6); // Top bits are constant and are trimmed during synthesis
       full_pre_it12      <= pre_it_pipe11 * rA_abs_pipe11; // this is essentially it11
       full_pre_it12_pipe <= full_pre_it12;
       pre_it12_12        <= full_pre_it12_pipe >>> 3'h5;
    end
    
    assign pre_it9_12     = it9_12;
    assign pre_it7_12     = it7_pipe12 >>> 4'd8;
    
    
    // Step 13:
    reg signed [31:0] it10_13;
    reg signed [31:0] it10_13_pipe;
    reg signed [35:0] it12_13;
    reg signed [35:0] it12_13_pipe;
    reg signed [35:0] it12_13_pipe2;
    wire signed [19:0] pre_it10_13;
    wire signed [18:0] pre_it12_13;
    
    always @(posedge clk) begin
       it10_13      <= (pre_it7_12 >>> 3'd5) * pre_it9_12; // Not fully aligned, but it works for now
       it10_13_pipe <= it10_13;
       it12_13      <= pre_it12_12 * pre_it9_12;
       it12_13_pipe <= it12_13;
       it12_13_pipe2 <= it12_13_pipe;
    end
    
    assign pre_it10_13 = it10_13_pipe >>> 3'd6; // size mismatch
    assign pre_it12_13 = it12_13_pipe >>> 5'd18; // NOT GOOD ENOUGH // size mismatch
    
    // Step 14:
    // Carry over:
    (*KEEP = "true"*) reg signed [13:0] it_14;
    (*KEEP = "true"*) reg signed [13:0] irinv_14;
    // Declare:
    (*KEEP = "true"*) reg signed [17:0] iphi0_14;
    (*KEEP = "true"*) reg signed [9:0] iz0_14;

    // pT and z0 consistency cuts taken from emulation
    // abs(irinv*krinvpars) > rinvcut 
    //      rinvcut = 0.01*0.3*3.8/ptcut   ptcut = 2.0
    //      take irinvcut = round_int(rinvcut / krinvpars)
    // abs(iz0*kzpars) > z0cuttmp
    //      z0cuttmp = 15 for L1L2, 20.0 for L3L4 and L5L6
    //      kzpars = 0.0561523
    //      take iz0cut = rount_int(z0cuttmp / kzpars)
    localparam irinvcut = 7491;
    localparam iz0cut_inner = 267;
    localparam iz0cut_outer = 356;
    
    generate
        if (innerB) begin
            assign pass_cut = ( irinv_14 < irinvcut && (-1*irinvcut) && 
                                iz0_14 < iz0cut_inner && iz0_14 > (-1*iz0cut_inner) );
        end
        else begin
            assign pass_cut = ( irinv_14 < irinvcut && (-1*irinvcut) && 
                                iz0_14 < iz0cut_outer && iz0_14 > (-1*iz0cut_outer) );
        end
    endgenerate
    
    always @(posedge clk) begin
       it_14        <= it_pipe13;
       irinv_14     <= irinv_pipe13; //>>>4'd13;
       iphi0_14     <= (phi_A_pipe13 + pre_it10_13)>>>1'b1;
       iz0_14       <= z_A_pipe13 - pre_it12_13;
       trackpar     <= {inner_stub_index,outer_stub_index,irinv_14,iphi0_14,iz0_14,it_14}; // register for now, but should be wire
    end
      
    assign projoutToPlus_L1 = projout_L1D3;
    assign projoutToMinus_L1 = projout_L1D3;
    assign projoutToPlus_L2 = projout_L2D3;
    assign projoutToMinus_L2 = projout_L2D3;
    assign projoutToPlus_L3 = projout_L3D3;
    assign projoutToMinus_L3 = projout_L3D3;
    assign projoutToPlus_L4 = projout_L4D3;
    assign projoutToMinus_L4 = projout_L4D3;
    assign projoutToPlus_L5 = projout_L5D3;
    assign projoutToMinus_L5 = projout_L5D3;
    assign projoutToPlus_L6 = projout_L6D3;
    assign projoutToMinus_L6 = projout_L6D3;
    
    genvar i;  //integer counter
    genvar j;  //integer counter
    
    wire [53:0] projections[5:0]; // Array of projections
    wire [5:0] valid_projections; // Array of valids
    wire [5:0] valid_projectionsPlus;
    wire [5:0] valid_projectionsMinus;
    wire [53:0] projectionsD[4:0]; // Array of projections to disks
    wire [4:0] valid_projectionsD; // Array of valids
    wire [4:0] valid_projectionsDPlus;
    wire [4:0] valid_projectionsDMinus;
    
    // Barrel Projections
    
    assign projout_L1D3 = projections[0];
    assign projout_L2D3 = projections[1];
    assign projout_L3D3 = projections[2];
    assign projout_L4D3 = projections[3];
    assign projout_L5D3 = projections[4];
    assign projout_L6D3 = projections[5];
    assign projout_L1D4 = projections[0];
    assign projout_L2D4 = projections[1];
    assign projout_L3D4 = projections[2];
    assign projout_L4D4 = projections[3];
    assign projout_L5D4 = projections[4];
    assign projout_L6D4 = projections[5];
    
    wire [5:0] D3;
    wire [5:0] D4;
    wire [4:0] D5;
    wire [4:0] D6; // Add more DTC Regions here
    assign D3[0] = (projections[0][`ZD_L1+`PHID_L1+`Z_L1-1:`ZD_L1+`PHID_L1+`Z_L1-2] == 2'b00);
    assign D3[1] = (projections[1][`ZD_L2+`PHID_L2+`Z_L2-1:`ZD_L2+`PHID_L2+`Z_L2-2] == 2'b00);
    assign D3[2] = (projections[2][`ZD_L3+`PHID_L3+`Z_L3-1:`ZD_L3+`PHID_L3+`Z_L3-2] == 2'b00);
    assign D3[3] = (projections[3][`ZD_L4+`PHID_L4+`Z_L4-1:`ZD_L4+`PHID_L4+`Z_L4-2] == 2'b00);
    assign D3[4] = (projections[4][`ZD_L5+`PHID_L5+`Z_L5-1:`ZD_L5+`PHID_L5+`Z_L5-2] == 2'b00);
    assign D3[5] = (projections[5][`ZD_L6+`PHID_L6+`Z_L6-1:`ZD_L6+`PHID_L6+`Z_L6-2] == 2'b00);
    assign D4[0] = (projections[0][`ZD_L1+`PHID_L1+`Z_L1-1:`ZD_L1+`PHID_L1+`Z_L1-2] == 2'b01);
    assign D4[1] = (projections[1][`ZD_L2+`PHID_L2+`Z_L2-1:`ZD_L2+`PHID_L2+`Z_L2-2] == 2'b01);
    assign D4[2] = (projections[2][`ZD_L3+`PHID_L3+`Z_L3-1:`ZD_L3+`PHID_L3+`Z_L3-2] == 2'b01);
    assign D4[3] = (projections[3][`ZD_L4+`PHID_L4+`Z_L4-1:`ZD_L4+`PHID_L4+`Z_L4-2] == 2'b01);
    assign D4[4] = (projections[4][`ZD_L5+`PHID_L5+`Z_L5-1:`ZD_L5+`PHID_L5+`Z_L5-2] == 2'b01);
    assign D4[5] = (projections[5][`ZD_L6+`PHID_L6+`Z_L6-1:`ZD_L6+`PHID_L6+`Z_L6-2] == 2'b01);
    
    // This should be R instead of Z
    assign D5[0] = (projectionsD[0][`ZD_L1+`PHID_L1+`Z_L1-1:`ZD_L1+`PHID_L1+`Z_L1-2] == 2'b00);
    assign D5[1] = (projectionsD[1][`ZD_L2+`PHID_L2+`Z_L2-1:`ZD_L2+`PHID_L2+`Z_L2-2] == 2'b00);
    assign D5[2] = (projectionsD[2][`ZD_L3+`PHID_L3+`Z_L3-1:`ZD_L3+`PHID_L3+`Z_L3-2] == 2'b00);
    assign D5[3] = (projectionsD[3][`ZD_L4+`PHID_L4+`Z_L4-1:`ZD_L4+`PHID_L4+`Z_L4-2] == 2'b00);
    assign D5[4] = (projectionsD[4][`ZD_L5+`PHID_L5+`Z_L5-1:`ZD_L5+`PHID_L5+`Z_L5-2] == 2'b00);
    assign D6[0] = (projectionsD[0][`ZD_L1+`PHID_L1+`Z_L1-1:`ZD_L1+`PHID_L1+`Z_L1-2] == 2'b01);
    assign D6[1] = (projectionsD[1][`ZD_L2+`PHID_L2+`Z_L2-1:`ZD_L2+`PHID_L2+`Z_L2-2] == 2'b01);
    assign D6[2] = (projectionsD[2][`ZD_L3+`PHID_L3+`Z_L3-1:`ZD_L3+`PHID_L3+`Z_L3-2] == 2'b01);
    assign D6[3] = (projectionsD[3][`ZD_L4+`PHID_L4+`Z_L4-1:`ZD_L4+`PHID_L4+`Z_L4-2] == 2'b01);
    assign D6[4] = (projectionsD[4][`ZD_L5+`PHID_L5+`Z_L5-1:`ZD_L5+`PHID_L5+`Z_L5-2] == 2'b01);
    
    assign valid_projout_L1D3 = valid_projections[0] && D3[0];
    assign valid_projout_L2D3 = valid_projections[1] && D3[1];
    assign valid_projout_L3D3 = valid_projections[2] && D3[2];
    assign valid_projout_L4D3 = valid_projections[3] && D3[3];
    assign valid_projout_L5D3 = valid_projections[4] && D3[4];
    assign valid_projout_L6D3 = valid_projections[5] && D3[5];
    assign valid_projout_L1D4 = valid_projections[0] && D4[0];
    assign valid_projout_L2D4 = valid_projections[1] && D4[1];
    assign valid_projout_L3D4 = valid_projections[2] && D4[2];
    assign valid_projout_L4D4 = valid_projections[3] && D4[3];
    assign valid_projout_L5D4 = valid_projections[4] && D4[4];
    assign valid_projout_L6D4 = valid_projections[5] && D4[5];
   
    assign valid_projoutToPlus_L1 = valid_projectionsPlus[0];
    assign valid_projoutToPlus_L2 = valid_projectionsPlus[1];
    assign valid_projoutToPlus_L3 = valid_projectionsPlus[2];
    assign valid_projoutToPlus_L4 = valid_projectionsPlus[3];
    assign valid_projoutToPlus_L5 = valid_projectionsPlus[4];
    assign valid_projoutToPlus_L6 = valid_projectionsPlus[5];
   
    assign valid_projoutToMinus_L1 = valid_projectionsMinus[0];
    assign valid_projoutToMinus_L2 = valid_projectionsMinus[1];
    assign valid_projoutToMinus_L3 = valid_projectionsMinus[2];
    assign valid_projoutToMinus_L4 = valid_projectionsMinus[3];
    assign valid_projoutToMinus_L5 = valid_projectionsMinus[4];
    assign valid_projoutToMinus_L6 = valid_projectionsMinus[5];
    
    // Disk Projections
    
    assign projout_F1D5 = projectionsD[0];
    assign projout_F2D5 = projectionsD[1];
    assign projout_F3D5 = projectionsD[2];
    assign projout_F4D5 = projectionsD[3];
    assign projout_F5D5 = projectionsD[4];
    assign projout_F1D6 = projectionsD[0];
    assign projout_F2D6 = projectionsD[1];
    assign projout_F3D6 = projectionsD[2];
    assign projout_F4D6 = projectionsD[3];
    assign projout_F5D6 = projectionsD[4];
    
    assign valid_projout_F1D5 = valid_projectionsD[0] && D5[0];
    assign valid_projout_F2D5 = valid_projectionsD[1] && D5[1];
    assign valid_projout_F3D5 = valid_projectionsD[2] && D5[2];
    assign valid_projout_F4D5 = valid_projectionsD[3] && D5[3];
    assign valid_projout_F5D5 = valid_projectionsD[4] && D5[4];
    assign valid_projout_F1D6 = valid_projectionsD[0] && D6[0];
    assign valid_projout_F2D6 = valid_projectionsD[1] && D6[1];
    assign valid_projout_F3D6 = valid_projectionsD[2] && D6[2];
    assign valid_projout_F4D6 = valid_projectionsD[3] && D6[3];
    assign valid_projout_F5D6 = valid_projectionsD[4] && D6[4];
   
    assign valid_projoutToPlus_F1 = valid_projectionsDPlus[0];
    assign valid_projoutToPlus_F2 = valid_projectionsDPlus[1];
    assign valid_projoutToPlus_F3 = valid_projectionsDPlus[2];
    assign valid_projoutToPlus_F4 = valid_projectionsDPlus[3];
    assign valid_projoutToPlus_F5 = valid_projectionsDPlus[4];
   
    assign valid_projoutToMinus_F1 = valid_projectionsDMinus[0];
    assign valid_projoutToMinus_F2 = valid_projectionsDMinus[1];
    assign valid_projoutToMinus_F3 = valid_projectionsDMinus[2];
    assign valid_projoutToMinus_F4 = valid_projectionsDMinus[3];
    assign valid_projoutToMinus_F5 = valid_projectionsDMinus[4];
    
    // Assign all the parameter values
    parameter [31:0] PHI_BITS[5:0] = {`PHI_L6,`PHI_L5,`PHI_L4,`PHI_L3,`PHI_L2,`PHI_L1};
    parameter [31:0] Z_BITS[5:0] = {`Z_L6,`Z_L5,`Z_L4,`Z_L3,`Z_L2,`Z_L1};
    parameter [31:0] PHID_BITS[5:0] = {`PHID_L6,`PHID_L5,`PHID_L4,`PHID_L3,`PHID_L2,`PHID_L1};
    parameter [31:0] ZD_BITS[5:0] = {`ZD_L6,`ZD_L5,`ZD_L4,`ZD_L3,`ZD_L2,`ZD_L1};
    parameter [31:0] RPROJ[5:0] = {`RPROJ_L6,`RPROJ_L5,`RPROJ_L4,`RPROJ_L3,`RPROJ_L2,`RPROJ_L1};
   
    parameter [0:0] LAYER[5:0] = {1'b0,1'b0,1'b0,1'b1,1'b1,1'b1}; // 3 outer, 3 inner
   
    // Generate the two sets of barrel projections
    generate
        for (i=0; i < 6; i = i + 1) begin
            TrackletProjections_test #(PHI_BITS[i],Z_BITS[i],PHID_BITS[i],ZD_BITS[i],LAYER[i],RPROJ[i]) projectionD3(
                // clocks and reset
                .clk(clk),                // processing clock
                .reset(rst_pipe),                        // active HI
                .en_proc(en_proc),
                
                .start(done[0]), // use the tracklet parameter done as the projection start
                
                .tracklet(trackpar),
                .projection(projections[i]),
                .valid_trackpar(valid_trackpar),
                .TC_index(TC_index),
                .valid_proj(valid_projections[i]),
                .valid_projPlus(valid_projectionsPlus[i]),
                .valid_projMinus(valid_projectionsMinus[i])
            );  
                                          
        end
    endgenerate
    
    // Generate the two sets of disk projections  
    // We should probably use the Disk Projection module here  
    generate
        for (j=0; j < 5; j = j + 1) begin
            TrackletProjections_test #() projectionD5(
                // clocks and reset
                .clk(clk),                // processing clock
                .reset(rst_pipe),                        // active HI
                .en_proc(en_proc),
                
                .start(done[0]), // use the tracklet parameter done as the projection start
                
                .tracklet(trackpar),
                .projection(projectionsD[j]),
                .valid_trackpar(valid_trackpar),
                .valid_proj(valid_projectionsD[j]),
                .valid_projPlus(valid_projectionsDPlus[j]),
                .valid_projMinus(valid_projectionsDMinus[j])
            );   
                              
        end
    endgenerate    
    
endmodule

