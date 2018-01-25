`timescale 1ns / 1ps
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


module TrackletDiskCalculator(
    input clk,
    input reset,
    input en_proc,
    // programming interface
    // inputs
    input wire io_clk,                    // programming clock
    input wire io_sel,                    // this module has been selected for an I/O operation
    input wire io_sync,                    // start the I/O operation
    input wire [15:0] io_addr,        // slave address, memory or register. Top 16 bits already consumed.
    input wire io_rd_en,                // this is a read operation
    input wire io_wr_en,                // this is a write operation
    input wire [31:0] io_wr_data,    // data to write for write operations
    // outputs
    output wire [31:0] io_rd_data,    // data returned for read operations
    output wire io_rd_ack,                // 'read' data from this module is ready
    //clocks
    input wire [2:0] BX,
    input wire first_clk,
    input wire not_first_clk,
    
    input start,
    output reg done,
    output reg done_proj,
    
    input [5:0] number_in1,
    output [8:0] read_add1,
    input [11:0] stubpair1in,
    input [5:0] number_in2,
    output [8:0] read_add2,
    input [11:0] stubpair2in,
    input [5:0] number_in3,
    output [8:0] read_add3,
    input [11:0] stubpair3in,
    input [5:0] number_in4,
    output [8:0] read_add4,
    input [11:0] stubpair4in,
    input [5:0] number_in5,
    output [8:0] read_add5,
    input [11:0] stubpair5in,
    input [5:0] number_in6,
    output [8:0] read_add6,
    input [11:0] stubpair6in,
    input [5:0] number_in7,
    output [8:0] read_add7,
    input [11:0] stubpair7in,
    input [5:0] number_in8,
    output [8:0] read_add8,
    input [11:0] stubpair8in,
    input [5:0] number_in9,
    output [8:0] read_add9,
    input [11:0] stubpair9in,
    input [5:0] number_in10,
    output [8:0] read_add10,
    input [11:0] stubpair10in,
    input [5:0] number_in11,
    output [8:0] read_add11,
    input [11:0] stubpair11in,
    input [5:0] number_in12,
    output [8:0] read_add12,
    input [11:0] stubpair12in,
    input [5:0] number_in13,
    output [8:0] read_add13,
    input [11:0] stubpair13in,
    input [5:0] number_in14,
    output [8:0] read_add14,
    input [11:0] stubpair14in,
    input [5:0] number_in15,
    output [8:0] read_add15,
    input [11:0] stubpair15in,
    input [5:0] number_in16,
    output [8:0] read_add16,
    input [11:0] stubpair16in,
    input [5:0] number_in17,
    output [8:0] read_add17,
    input [11:0] stubpair17in,
    input [5:0] number_in18,
    output [8:0] read_add18,
    input [11:0] stubpair18in,
    input [5:0] number_in19,
    output [8:0] read_add19,
    input [11:0] stubpair19in,
    input [5:0] number_in20,
    output [8:0] read_add20,
    input [11:0] stubpair20in,
    input [5:0] number_in21,
    output [8:0] read_add21,
    input [11:0] stubpair21in,
    input [5:0] number_in22,
    output [8:0] read_add22,
    input [11:0] stubpair22in,
    input [5:0] number_in23,
    output [8:0] read_add23,
    input [11:0] stubpair23in,
    input [5:0] number_in24,
    output [8:0] read_add24,
    input [11:0] stubpair24in,
    
    output reg [10:0] read_add_innerall,
    output reg [10:0] read_add_outerall,
    input [35:0] innerallstubin,
    input [35:0] outerallstubin,
    
    (* mark_debug = "true" *) output reg [55:0] trackpar,
    output [53:0] projout_L1D4,
    output [53:0] projout_L2D4,
    
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
    output [53:0] projoutToPlus_F1,
    output [53:0] projoutToPlus_F2,
    output [53:0] projoutToPlus_F3,
    output [53:0] projoutToPlus_F4,
    output [53:0] projoutToPlus_F5,
    output [53:0] projoutToPlus_F6,
    
    output [53:0] projoutToMinus_L1,
    output [53:0] projoutToMinus_L2,
    output [53:0] projoutToMinus_F1,
    output [53:0] projoutToMinus_F2,
    output [53:0] projoutToMinus_F3,
    output [53:0] projoutToMinus_F4,
    output [53:0] projoutToMinus_F5,
    output [53:0] projoutToMinus_F6,
    
    output reg valid_trackpar,
    output valid_projout_L1D4,
    output valid_projout_L2D4,
    
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
    output valid_projoutToPlus_F1,
    output valid_projoutToPlus_F2,
    output valid_projoutToPlus_F3,
    output valid_projoutToPlus_F4,
    output valid_projoutToPlus_F5,
    output valid_projoutToPlus_F6,
    output valid_projoutToMinus_L1,
    output valid_projoutToMinus_L2,
    output valid_projoutToMinus_F1,
    output valid_projoutToMinus_F2,
    output valid_projoutToMinus_F3,
    output valid_projoutToMinus_F4,
    output valid_projoutToMinus_F5,
    output valid_projoutToMinus_F6
    
    );
    
    ///////////////////////////////////////////////
    reg [4:0] BX_pipe;
    reg first_clk_pipe;
    reg [4:0] BX_pipe_hold1;
    reg [4:0] BX_pipe_hold2;
    reg [4:0] BX_pipe_hold3;
    reg [4:0] BX_pipe_hold4;
    reg [4:0] BX_pipe_hold5;
    
    initial begin
       BX_pipe = 5'b11111;
    end
    
    always @(posedge clk) begin
        if(reset)
           BX_pipe <= 5'b11111;
        else begin
            if(start) begin
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
    
    parameter [7:0] n_hold = 8'd47;  
    parameter [7:0] p_hold = 8'd17;
    reg [n_hold:0] hold;
    reg [p_hold:0] hold_proj;
    
    always @(posedge clk) begin
        hold[0] <= start;
        hold[n_hold:1] <= hold[n_hold-1:0];
        done <= hold[n_hold];
        hold_proj[0] <= done;
        hold_proj[p_hold:1] <= hold_proj[p_hold-1:0];
        done_proj <= hold_proj[p_hold];
    end
    ///////////////////////////////////////////////////
    initial begin
        read_add_innerall = {BX_pipe_hold5,6'h3f};
        read_add_outerall = {BX_pipe_hold5,6'h3f};
    end
    
    //////////////////////////////////////////////////////////////////
           
   wire [11:0] stubpair;
   reg first_clk_pipe_dly;
   reg first_clk_pipe_dly2;
   
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
   
   assign read_add1 = {BX_pipe_hold1[2:0],pre_read_add1};
   assign read_add2 = {BX_pipe_hold1[2:0],pre_read_add2};
   assign read_add3 = {BX_pipe_hold1[2:0],pre_read_add3};
   assign read_add4 = {BX_pipe_hold1[2:0],pre_read_add4};
   assign read_add5 = {BX_pipe_hold1[2:0],pre_read_add5};
   assign read_add6 = {BX_pipe_hold1[2:0],pre_read_add6};
   assign read_add7 = {BX_pipe_hold1[2:0],pre_read_add7};
   assign read_add8 = {BX_pipe_hold1[2:0],pre_read_add8};
   assign read_add9 = {BX_pipe_hold1[2:0],pre_read_add9};
   assign read_add10 = {BX_pipe_hold1[2:0],pre_read_add10};
   assign read_add11 = {BX_pipe_hold1[2:0],pre_read_add11};
   assign read_add12 = {BX_pipe_hold1[2:0],pre_read_add12};
   assign read_add13 = {BX_pipe_hold1[2:0],pre_read_add13};
   assign read_add14 = {BX_pipe_hold1[2:0],pre_read_add14};
   assign read_add15 = {BX_pipe_hold1[2:0],pre_read_add15};
   assign read_add16 = {BX_pipe_hold1[2:0],pre_read_add16};
   assign read_add17 = {BX_pipe_hold1[2:0],pre_read_add17};
   assign read_add18 = {BX_pipe_hold1[2:0],pre_read_add18};


   mem_readout_top StubPairs(
      .clk(clk),
      .new_event(first_clk_pipe_dly),
      
      .items00(number_in1),
      .addr00(pre_read_add1),
      .mem_dat00(stubpair1in),
      .items01(number_in2),
      .addr01(pre_read_add2),
      .mem_dat01(stubpair2in),
      .items02(number_in3),
      .addr02(pre_read_add3),
      .mem_dat02(stubpair3in),
      .items03(number_in4),
      .addr03(pre_read_add4),
      .mem_dat03(stubpair4in),
      .items04(number_in5),
      .addr04(pre_read_add5),
      .mem_dat04(stubpair5in),
      .items05(number_in6),
      .addr05(pre_read_add6),
      .mem_dat05(stubpair6in),
      .items06(number_in7),
      .addr06(pre_read_add7),
      .mem_dat06(stubpair7in),
      .items07(number_in8),
      .addr07(pre_read_add8),
      .mem_dat07(stubpair8in),
      .items08(number_in9),
      .addr08(pre_read_add9),
      .mem_dat08(stubpair9in),
      .items09(number_in10),
      .addr09(pre_read_add10),
      .mem_dat09(stubpair10in),
      
      .items10(number_in11),
      .addr10(pre_read_add11),
      .mem_dat10(stubpair11in),
      .items11(number_in12),
      .addr11(pre_read_add12),
      .mem_dat11(stubpair12in),
      .items12(number_in13),
      .addr12(pre_read_add13),
      .mem_dat12(stubpair13in),
      .items13(number_in14),
      .addr13(pre_read_add14),
      .mem_dat13(stubpair14in),
      .items14(number_in15),
      .addr14(pre_read_add15),
      .mem_dat14(stubpair15in),
      .items15(number_in16),
      .addr15(pre_read_add16),
      .mem_dat15(stubpair16in),
      .items16(number_in17),
      .addr16(pre_read_add17),
      .mem_dat16(stubpair17in),
      .items17(number_in18),
      .addr17(pre_read_add18),
      .mem_dat17(stubpair18in),
      
      .mem_dat_stream(stubpair),
      .valid(pre_valid_trackpar),
      .none()
      );
      
    reg [44:0] behold; // valid tracklet data hold
    wire pass_cut;
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_trackpar;
        behold[44:1] <= behold[43:0];
        valid_trackpar <= behold[44] && pass_cut;

        first_clk_pipe_dly  <= first_clk_pipe;
        first_clk_pipe_dly2 <= first_clk_pipe_dly;
        if(stubpair >= 0) begin
            read_add_innerall <= {BX_pipe_hold5,stubpair[11:6]};
            read_add_outerall <= {BX_pipe_hold5,stubpair[5:0]};
        end
   end
   
   
    
//////////////////////////////////////////////////////////////////
    parameter DR_LUT = "";  
    parameter krA = 12'sd981;
    parameter krB = 12'sd1515; //Margaret changed from 1514 to match emulation
    parameter kzA = 12'sd981;
    parameter kzB = 12'sd1515; //Margaret changed from 1514 to match emulation
    parameter innerA = 1'b1;
    parameter innerB = 1'b1;
    
    // Step 0: Define the variables
    reg signed [11:0] r_A_0;
    reg [7:0] z_A_0;
    reg [16:0] phi_A_0;
    reg signed [11:0] r_B_0;
    reg [7:0] z_B_0;
    reg [16:0] phi_B_0;
    
    reg signed [19:0] k_r_A;
    reg signed [19:0] k_r_B;
    reg signed [19:0] k_z_A;
    reg signed [19:0] k_z_B;
    
    // Why multiply these numbers???????
    // Because you want to always have the same number of bits for all layers
    // phi = 17, r = 8, z =8
    
    
    
    always @(posedge clk) begin
       k_r_A        <= krA;
       k_r_B        <= krB;
       k_z_A        <= kzA;
       k_z_B        <= kzB;
        if(innerA) begin
            r_A_0        <= innerallstubin[32:21];//times 2 to match the resolution of L4-6
            z_A_0        <= innerallstubin[20:14];
            phi_A_0      <= innerallstubin[13:0]<<<2'b11;//times 8 to match the resolution of L4-6
        end
        else begin
            r_A_0        <= innerallstubin[27:21];
            z_A_0        <= innerallstubin[20:14];//times 16 to match the resolution of L1-3
            phi_A_0      <= innerallstubin[13:0]<<<2'b11;
        end
        if(innerB) begin
            r_B_0        <= outerallstubin[32:21];//times 2 to match the resolution of L4-6
            z_B_0        <= outerallstubin[20:14];
            phi_B_0      <= outerallstubin[13:0]<<<2'b11;//times 8 to match the resolution of L4-6
        end
        else begin
            r_B_0        <= outerallstubin[27:21];
            z_B_0        <= outerallstubin[20:14];//times 16 to match the resolution of L1-3
            phi_B_0      <= outerallstubin[13:0]<<<2'b11;
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
    reg [8:0] idrrel;
    reg [8:0] idrrel_pipe;
    
    pipe_delay #(.STAGES(38), .WIDTH(8))
           z_A_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(z_A_0), .val_out(z_A_pipe13));
    pipe_delay #(.STAGES(38), .WIDTH(17))
           phi_A_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
           .val_in(phi_A_0), .val_out(phi_A_pipe13));
    
    
    always @(posedge clk) begin
       idelta_phi_1        <= phi_B_0 - phi_A_0; // bit size mismatch here
       idelta_z_1          <= (k_z_B-k_z_A) + (z_B_0 - z_A_0);
       idelta_r_1          <= r_B_0 - r_A_0;
       rA_abs_1            <= k_r_A+r_A_0;
       rB_abs_1            <= k_r_B+r_B_0;
       idrrel              <= r_B_0-r_A_0;
    end
    
    wire signed [15:0] idelta_phi_pipe8;
    
    pipe_delay #(.STAGES(21), .WIDTH(16))
       idelta_phi_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(idelta_phi_1), .val_out(idelta_phi_pipe8));
    
    wire signed [11:0] idelta_z_pipe9;
    
    pipe_delay #(.STAGES(22), .WIDTH(12))
       idelta_z_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(idelta_z_1), .val_out(idelta_z_pipe9));
    
    wire signed [12:0] rA_abs_pipe10;
    
    pipe_delay #(.STAGES(24), .WIDTH(13))
                   rA_abs_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
                   .val_in(rA_abs_1), .val_out(rA_abs_pipe10));
    // Step 2: Lookup dr inverse
    // Carry over:
    reg signed [14:0] idelta_phi_2;
    // Declare:
    wire signed [11:0] idr_inv_2; // was 14:0
    reg [25:0] full_it1;    
    reg [25:0] full_it1_pipe;    
    wire [2:0] it1_2;// was 11
    
    Memory #(
           .RAM_WIDTH(16),                       // Specify RAM data width
           .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
           .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
           .INIT_FILE("InvTable_TC_F3D5F3D6_hex.dat")
           //.INIT_FILE("/home/mzientek/CTP7/firmware/TrackletProject/AdditionalFiles/dr_inv.txt")    // Specify name/location of RAM initialization file if using one (leave blank if not)
         ) lookup_dr_inv (
           .addra(11'b0),    // Write address bus, width determined from RAM_DEPTH
           .addrb({2'b0,idrrel_pipe[8:0]}),  //idelta_r_pipe   // Read address bus, width determined from RAM_DEPTH
           .dina(16'b0),      // RAM input data, width determined from RAM_WIDTH
           .clka(clk),      // Write clock
           .clkb(clk),      // Read clock
           .wea(1'b0),        // Write enable
           .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
           .rstb(reset),      // Output reset (does not affect memory contents)
           .regceb(1'b1),  // Output register enable
           .doutb(idr_inv_2)     // RAM output data, width determined from RAM_WIDTH
       );
    
    wire signed [11:0] idr_inv_pipe8;
       
    pipe_delay #(.STAGES(17), .WIDTH(12))
       idr_inv_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(idr_inv_2), .val_out(idr_inv_pipe8));
    
    always @(posedge clk) begin
       idelta_phi_2     <= idelta_phi_1;
       full_it1         <= rA_abs_1 * rB_abs_1;
       full_it1_pipe    <= full_it1;
    end
    
    //assign it1_2 = full_it1[23:21];
    assign it1_2 = full_it1_pipe >> 5'd23;
    
    wire [2:0] it1_pipe4;
    
    pipe_delay #(.STAGES(6), .WIDTH(3))
       it1_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
       .val_in(it1_2), .val_out(it1_pipe4));
    
    // Step 3: 
    // Carry over
    reg [11:0] idr_inv_3;
    reg signed [14:0] idelta_phi_3;
    // Declare:
    reg signed [29:0] full_it2;
    reg signed [29:0] full_it2_pipe;
    reg signed [10:0] it2_3;
    
    always @(posedge clk) begin
       idr_inv_3        <= idr_inv_2;
       idelta_phi_3     <= idelta_phi_2;
       full_it2         <= idr_inv_2 * idelta_phi_3;
       full_it2_pipe    <= full_it2;
       it2_3            <= full_it2_pipe >>> 4'd15; //8
    end 
       
    // Step 4: 
    // Declare:
    reg [35:0] full_it3;
    reg [35:0] full_it3_pipe;
    reg [6:0] it3_4;
    
    always @(posedge clk) begin
       full_it3            <= it2_3 * it2_3;
       full_it3_pipe       <= full_it3;
       it3_4 <= full_it3_pipe >>> 4'd13;
    end
    
    // Step 5: 
    // Declare:
    reg [8:0] full_idelta;
    reg [8:0] full_idelta_pipe;
    reg [8:0] pre_idelta_tmp_5;
    
    always @(posedge clk) begin
       full_idelta      <= (it1_pipe4 * it3_4) >>> 1'd1; //it1 is 3bits, it3 is 7 bits
       full_idelta_pipe <= full_idelta;
       pre_idelta_tmp_5 <= full_idelta_pipe;
    end
    
    // Step 6:
    reg [8:0] full_idelta_tmp;
    reg [8:0] full_idelta_tmp_pipe;
    reg [6:0] idelta_tmp_6; // WHY DO WE DO THIS????
    
    always @(posedge clk) begin
       full_idelta_tmp      <= full_idelta_pipe; //full_idelta_pipe * 28'd48060778; //FINDME
       full_idelta_tmp_pipe <= full_idelta_tmp;
       idelta_tmp_6         <= full_idelta_tmp_pipe[8:3];//take top 7 bits of full_idelta
    end
       
    // Step 7:
    reg signed [6:0] idelta_tmp_7;
    // Declare:
    reg [10:0] it4_7;
    
    always @(posedge clk) begin
       idelta_tmp_7      <= idelta_tmp_6; // bit size mismatch fixed
       it4_7             <= (10'h0001 <<< 4'd9) - 3*(idelta_tmp_6 >>> 1'b1); // 1<<it4shift - 1.5 *delta
    end
    
    // Step 8:
    // Declare:
    wire [17:0] full_it5_test;
    reg [10:0] pre_it5_8;
    
    pipe_mult #(.STAGES(3), .AWIDTH(11), .BWIDTH(7))
           full_it5_mult(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
           .a(it4_7), .b(idelta_tmp_7), .p(full_it5_test));
    
    always @(posedge clk) begin
      pre_it5_8   <= (10'h0001 <<< 4'd9) - (full_it5_test >>> 4'd9);
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
       full_irinv      <= idelta_phi_9 * iDelta_inv_9;
       full_irinv_pipe <= full_irinv;
       it_10           <= idelta_z_pipe9 * iDelta_inv_9; // it_10 = it before shift in emulation, it6 in whitepaper
       it_10_pipe      <= it_10 >>> 4'd8;                // here is the shift that matches emulation
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
    wire signed [28:0] it7_tmp_11_pipe;
    reg signed [17:0] it7_tmp_sqr_11;
    reg signed [17:0] it7_tmp_sqr_11_pipe;
    reg signed [17:0] it7_tmp_sqr_11_pipe2;
    reg signed [12:0] pre_it_11;
    
    pipe_mult #(.STAGES(3), .AWIDTH(12), .BWIDTH(15)) //do rAabs>>1 * irinv
               full_it7_mult(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
               .a(rA_abs_pipe10[12:1]), .b(pre_irinv_10), .p(full_it7_test));
    
    pipe_mult #(.STAGES(3), .AWIDTH(17), .BWIDTH(12))
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
    assign pass_cut = (irinv_14 < 7491 && irinv_14 > -7491 && iz0_14 < 267 && iz0_14 > -267);
    
    always @(posedge clk) begin
       it_14        <= it_pipe13;
       irinv_14     <= irinv_pipe13; //>>>4'd13;
       iphi0_14     <= (phi_A_pipe13 + pre_it10_13)>>>1'b1;
       iz0_14       <= z_A_pipe13 - pre_it12_13;
       trackpar     <= {irinv_14,iphi0_14,iz0_14,it_14}; // register for now, but should be wire
    end
      
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    // readback mux
    // If a particular register or memory is addressed, connect that register's or memory's signals
    // to the 'io_rd_data' output. At the same time, assert 'io_rd_ack' to tell downstream muxes to
    // use the 'io_rd_data' from this module as their source of data.
    reg [31:0] io_rd_data_reg;
    assign io_rd_data[31:0] = io_rd_data_reg[31:0];
    // Assert 'io_rd_ack' if chip select for this module is asserted during a 'read' operation.
    reg io_rd_ack_reg;
    assign io_rd_ack = io_rd_ack_reg;
    always @(posedge io_clk) begin
        io_rd_ack_reg <= io_sync & io_sel & io_rd_en;
    end
    // Route the selected memory to the 'rdbk' output.
    always @(posedge io_clk) begin
        if (io_sel) io_rd_data_reg <= trackpar[31:0];
    end
    
    assign projoutToPlus_F1 = projout_F3D5;
    assign projoutToMinus_F1 = projout_F3D5;
    assign projoutToPlus_F2 = projout_F3D6;
    assign projoutToMinus_F2 = projout_F3D6;
    assign projoutToPlus_F3 = projout_F4D5;
    assign projoutToMinus_F3 = projout_F4D5;
    assign projoutToPlus_F4 = projout_F4D6;
    assign projoutToMinus_F4 = projout_F4D6;
    assign projoutToPlus_F5 = projout_F5D5;
    assign projoutToMinus_F5 = projout_F5D5;
    assign projoutToPlus_F6 = projout_F5D6;
    assign projoutToMinus_F6 = projout_F5D6;
    
    TrackletProjections_test #(14,12,7,8,1'b1,16'h86a) projection_F3D5(
    // clocks and reset
        .clk(clk),                // processing clock
        .reset(reset),                        // active HI
        .en_proc(en_proc),
                
        .tracklet(trackpar),
        .projection(projout_F3D5),
        .valid_trackpar(valid_trackpar),
        .valid_proj(valid_projout_F3D5),
        .valid_projPlus(valid_projoutToPlus_F1),
        .valid_projMinus(valid_projoutToMinus_F1)
    );
    
    TrackletProjections_test #(14,12,7,8,1'b1,16'hb66) projection_F3D6(
    // clocks and reset
        .clk(clk),                // processing clock
        .reset(reset),                        // active HI
        .en_proc(en_proc),
                
        .tracklet(trackpar),
        .projection(projout_F3D6),
        .valid_trackpar(valid_trackpar),
        .valid_proj(valid_projout_F3D6),
        .valid_projPlus(valid_projoutToPlus_F2),
        .valid_projMinus(valid_projoutToMinus_F2)
    );
    
    TrackletProjections_test #(14,12,7,8,1'b1,16'h86a) projection_F4D5(
    // clocks and reset
        .clk(clk),                // processing clock
        .reset(reset),                        // active HI
        .en_proc(en_proc),
                
        .tracklet(trackpar),
        .projection(projout_F4D5),
        .valid_trackpar(valid_trackpar),
        .valid_proj(valid_projout_F4D5),
        .valid_projPlus(valid_projoutToPlus_F3),
        .valid_projMinus(valid_projoutToMinus_F3)
    );
    
    TrackletProjections_test #(17,8,8,7,1'b0,16'hb66) projection_F4D6(
    // clocks and reset
        .clk(clk),                // processing clock
        .reset(reset),                        // active HI
        .en_proc(en_proc),
                
        .tracklet(trackpar),
        .projection(projout_F4D6),
        .valid_trackpar(valid_trackpar),
        .valid_proj(valid_projout_F4D6),
        .valid_projPlus(valid_projoutToPlus_F4),
        .valid_projMinus(valid_projoutToMinus_F4)
    );
    
    TrackletProjections_test #(17,8,8,7,1'b0,16'hebb) projection_F5D5(
    // clocks and reset
        .clk(clk),                // processing clock
        .reset(reset),                        // active HI
        .en_proc(en_proc),
                
        .tracklet(trackpar),
        .projection(projout_F5D5),
        .valid_trackpar(valid_trackpar),
        .valid_proj(valid_projout_F5D5),
        .valid_projPlus(valid_projoutToPlus_F5),
        .valid_projMinus(valid_projoutToMinus_F5)
    );
    
    TrackletProjections_test #(17,8,8,7,1'b0,16'h11f7) projection_F5D6(
    // clocks and reset
        .clk(clk),                // processing clock
        .reset(reset),                        // active HI
        .en_proc(en_proc),
                
        .tracklet(trackpar),
        .projection(projout_F5D6),
        .valid_trackpar(valid_trackpar),
        .valid_proj(valid_projout_F5D6),
        .valid_projPlus(valid_projoutToPlus_F6),
        .valid_projMinus(valid_projoutToMinus_F6)
    );
    
endmodule

