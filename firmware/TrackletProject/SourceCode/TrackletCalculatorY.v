`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 10:49:27 AM
// Design Name: 
// Module Name: TrackletDiskCalculator
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

module TrackletCalculator #(
parameter BARREL = 1'b0,
parameter InvR_FILE = "InvRTable_TC_L1D4L2D4.dat",
parameter InvT_FILE = "InvTTable_TC_L1D4L2D4.dat",
parameter TC_index = 4'b0000,				
parameter R1MEAN = 14'sd981,        //For Layers
parameter R2MEAN = 14'sd1515,       //For Layers
parameter Z1MEAN = 14'sd2341,       //For Disks
parameter Z2MEAN = 14'sd2778,       //For Disks
parameter RMIN = 11'sd512,          //For Disks
parameter IsInner1 = 1'b1,          //For Layers
parameter IsInner2 = 1'b1           //For Layers
)(
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
    
    input [1:0]     start,
    output [1:0]    done,
    output [1:0]    done_proj,   
 
    input [5:0]     number_in_stubpair1in,
    output [`MEM_SIZE+2:0]    read_add_stubpair1in,
    input [11:0]    stubpair1in,
    input [5:0]     number_in_stubpair2in,
    output [`MEM_SIZE+2:0]    read_add_stubpair2in,
    input [11:0]    stubpair2in,
    input [5:0]     number_in_stubpair3in,
    output [`MEM_SIZE+2:0]    read_add_stubpair3in,
    input [11:0]    stubpair3in,
    input [5:0]     number_in_stubpair4in,
    output [`MEM_SIZE+2:0]    read_add_stubpair4in,
    input [11:0]    stubpair4in,
    input [5:0]     number_in_stubpair5in,
    output [`MEM_SIZE+2:0]    read_add_stubpair5in,
    input [11:0]    stubpair5in,
    input [5:0]     number_in_stubpair6in,
    output [`MEM_SIZE+2:0]    read_add_stubpair6in,
    input [11:0]    stubpair6in,
    input [5:0]     number_in_stubpair7in,
    output [`MEM_SIZE+2:0]    read_add_stubpair7in,
    input [11:0]    stubpair7in,
    input [5:0]     number_in_stubpair8in,
    output [`MEM_SIZE+2:0]    read_add_stubpair8in,
    input [11:0]    stubpair8in,
    input [5:0]     number_in_stubpair9in,
    output [`MEM_SIZE+2:0]    read_add_stubpair9in,
    input [11:0]    stubpair9in,
    input [5:0]     number_in_stubpair10in,
    output [`MEM_SIZE+2:0]    read_add_stubpair10in,
    input [11:0]    stubpair10in,
    input [5:0]     number_in_stubpair11in,
    output [`MEM_SIZE+2:0]    read_add_stubpair11in,
    input [11:0]    stubpair11in,   
    input [5:0]     number_in_stubpair12in,
    output [`MEM_SIZE+2:0]    read_add_stubpair12in,
    input [11:0]    stubpair12in,
    input [5:0]     number_in_stubpair13in,
    output [`MEM_SIZE+2:0]    read_add_stubpair13in,
    input [11:0]    stubpair13in,      
    input [5:0]     number_in_stubpair14in,
    output [`MEM_SIZE+2:0]    read_add_stubpair14in,
    input [11:0]    stubpair14in,
    input [5:0]     number_in_stubpair15in,
    output [`MEM_SIZE+2:0]    read_add_stubpair15in,
    input [11:0]    stubpair15in,      
    input [5:0]     number_in_stubpair16in,
    output [`MEM_SIZE+2:0]    read_add_stubpair16in,
    input [11:0]    stubpair16in,
    input [5:0]     number_in_stubpair17in,
    output [`MEM_SIZE+2:0]    read_add_stubpair17in,
    input [11:0]    stubpair17in,      
    input [5:0]     number_in_stubpair18in,
    output [`MEM_SIZE+2:0]    read_add_stubpair18in,
    input [11:0]    stubpair18in,
    input [5:0]     number_in_stubpair19in,
    output [`MEM_SIZE+2:0]    read_add_stubpair19in,
    input [11:0]    stubpair19in,
    input [5:0]     number_in_stubpair20in,
    output [`MEM_SIZE+2:0]    read_add_stubpair20in,
    input [11:0]    stubpair20in,
    input [5:0]     number_in_stubpair21in,
    output [`MEM_SIZE+2:0]    read_add_stubpair21in,
    input [11:0]    stubpair21in,
    input [5:0]     number_in_stubpair22in,
    output [`MEM_SIZE+2:0]    read_add_stubpair22in,
    input [11:0]    stubpair22in,
    input [5:0]     number_in_stubpair23in,
    output [`MEM_SIZE+2:0]    read_add_stubpair23in,
    input [11:0]    stubpair23in,
    input [5:0]     number_in_stubpair24in,
    output [`MEM_SIZE+2:0]    read_add_stubpair24in,
    input [11:0]    stubpair24in,
    
    
    output reg [`MEM_SIZE+4:0]   read_add_innerallstubin,
    output reg [`MEM_SIZE+4:0]   read_add_outerallstubin,
    input [35:0]        innerallstubin,
    input [35:0]        outerallstubin,
    
//    (* mark_debug = "true" *) output reg [55:0] trackpar,
    output reg [67:0] trackpar,
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

    output [53:0] projoutToPlus_L1,
    output [53:0] projoutToPlus_L2,
    output [53:0] projoutToPlus_L3,
    output [53:0] projoutToPlus_L4,
    output [53:0] projoutToPlus_L5,
    output [53:0] projoutToPlus_L6,
    output [53:0] projoutToMinus_L1,
    output [53:0] projoutToMinus_L2,
    output [53:0] projoutToMinus_L3,
    output [53:0] projoutToMinus_L4,
    output [53:0] projoutToMinus_L5,
    output [53:0] projoutToMinus_L6,
    
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
    
    output [53:0] projoutToPlus_F1,
    output [53:0] projoutToPlus_F2,
    output [53:0] projoutToPlus_F3,
    output [53:0] projoutToPlus_F4,
    output [53:0] projoutToPlus_F5,
    output [53:0] projoutToMinus_F1,
    output [53:0] projoutToMinus_F2,
    output [53:0] projoutToMinus_F3,
    output [53:0] projoutToMinus_F4,
    output [53:0] projoutToMinus_F5,
    
    output reg valid_trackpar,
    output reg valid_projout_L1D3,
    output reg valid_projout_L2D3,
    output reg valid_projout_L3D3,
    output reg valid_projout_L4D3,
    output reg valid_projout_L5D3,
    output reg valid_projout_L6D3,
    output reg valid_projout_L1D4,
    output reg valid_projout_L2D4,
    output reg valid_projout_L3D4,
    output reg valid_projout_L4D4,
    output reg valid_projout_L5D4,
    output reg valid_projout_L6D4,
    output reg valid_projoutToPlus_L1,
    output reg valid_projoutToPlus_L2,
    output reg valid_projoutToPlus_L3,
    output reg valid_projoutToPlus_L4,
    output reg valid_projoutToPlus_L5,
    output reg valid_projoutToPlus_L6,
    output reg valid_projoutToMinus_L1,
    output reg valid_projoutToMinus_L2,
    output reg valid_projoutToMinus_L3,
    output reg valid_projoutToMinus_L4,
    output reg valid_projoutToMinus_L5,
    output reg valid_projoutToMinus_L6,
    
    output reg valid_projout_F1D5,
    output reg valid_projout_F1D6,
    output reg valid_projout_F2D5,
    output reg valid_projout_F2D6,
    output reg valid_projout_F3D5,
    output reg valid_projout_F3D6,
    output reg valid_projout_F4D5,
    output reg valid_projout_F4D6,
    output reg valid_projout_F5D5,
    output reg valid_projout_F5D6,
    output reg valid_projoutToPlus_F1,
    output reg valid_projoutToPlus_F2,
    output reg valid_projoutToPlus_F3,
    output reg valid_projoutToPlus_F4,
    output reg valid_projoutToPlus_F5,
    output reg valid_projoutToMinus_F1,
    output reg valid_projoutToMinus_F2,
    output reg valid_projoutToMinus_F3,
    output reg valid_projoutToMinus_F4,
    output reg valid_projoutToMinus_F5
    );
    
    localparam INVDR_WIDTH = 18;// -2*BARREL;  // 18 bits for disk, 16 bits for barrel
    
    ///////////////////////////////////////////////
  
    reg [4:0] BX_pipe;
    reg first_clk_pipe;
    reg [4:0] BX_pipe_hold1;
    reg [4:0] BX_pipe_hold2;
    reg [4:0] BX_pipe_hold3;
    reg [4:0] BX_pipe_hold4;
    reg [4:0] BX_pipe_hold5;
    reg [4:0] BX_pipe_hold6;

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
        BX_pipe_hold6 <= BX_pipe_hold5;
    end
    
    //initial begin
    //   BX_pipe = 3'b111;
    //end
    //
    //always @(posedge clk) begin
    //    if(reset)
    //       BX_pipe <= 3'b111;
    //    else begin
    //        if(start[0]) begin
    //           BX_pipe <= BX_pipe + 1'b1;
    //           first_clk_pipe <= 1'b1;
    //        end
    //        else begin
    //           first_clk_pipe <= 1'b0;
    //        end
    //    end
    //end
    
    // Done signals for Tracklets and Projections
    wire [1:0] pre_done;
    pipe_delay #(.STAGES(31), .WIDTH(2))
        pre_done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(pre_done));
    pipe_delay #(.STAGES(33), .WIDTH(2))
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
    
    pipe_delay #(.STAGES(43), .WIDTH(2)) 
        done_proj_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done_proj));    
    
//    parameter [7:0] n_hold = 8'd17;  
//    reg [n_hold:0] hold;
//    always @(posedge clk) begin
//        hold[0] <= start[0];
//        hold[n_hold:1] <= hold[n_hold-1:0];
//        done <= {0,hold[n_hold]};
//    end

    ///////////////////////////////////////////////////
    initial begin
        read_add_innerallstubin = {`MEM_SIZE+5{1'b1}};
        read_add_outerallstubin = {`MEM_SIZE+5{1'b1}};
    end
    
    //////////////////////////////////////////////////////////////////
           
   wire [11:0] stubpair;
   reg first_clk_pipe_dly;
   reg first_clk_pipe_dly2;

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
   wire [`MEM_SIZE-1:0] pre_read_add21;
   wire [`MEM_SIZE-1:0] pre_read_add22;
   wire [`MEM_SIZE-1:0] pre_read_add23;
   wire [`MEM_SIZE-1:0] pre_read_add24;
   
   assign read_add_stubpair1in = {BX_pipe_hold4[2:0],pre_read_add1};
   assign read_add_stubpair2in = {BX_pipe_hold4[2:0],pre_read_add2};
   assign read_add_stubpair3in = {BX_pipe_hold4[2:0],pre_read_add3};
   assign read_add_stubpair4in = {BX_pipe_hold4[2:0],pre_read_add4};
   assign read_add_stubpair5in = {BX_pipe_hold4[2:0],pre_read_add5};
   assign read_add_stubpair6in = {BX_pipe_hold4[2:0],pre_read_add6};
   assign read_add_stubpair7in = {BX_pipe_hold4[2:0],pre_read_add7};
   assign read_add_stubpair8in = {BX_pipe_hold4[2:0],pre_read_add8};
   assign read_add_stubpair9in = {BX_pipe_hold4[2:0],pre_read_add9};
   assign read_add_stubpair10in = {BX_pipe_hold4[2:0],pre_read_add10};
   assign read_add_stubpair11in = {BX_pipe_hold4[2:0],pre_read_add11};
   assign read_add_stubpair12in = {BX_pipe_hold4[2:0],pre_read_add12};
   assign read_add_stubpair13in = {BX_pipe_hold4[2:0],pre_read_add13};
   assign read_add_stubpair14in = {BX_pipe_hold4[2:0],pre_read_add14};
   assign read_add_stubpair15in = {BX_pipe_hold4[2:0],pre_read_add15};
   assign read_add_stubpair16in = {BX_pipe_hold4[2:0],pre_read_add16};
   assign read_add_stubpair17in = {BX_pipe_hold4[2:0],pre_read_add17};
   assign read_add_stubpair18in = {BX_pipe_hold4[2:0],pre_read_add18};
   assign read_add_stubpair19in = {BX_pipe_hold4[2:0],pre_read_add19};
   assign read_add_stubpair20in = {BX_pipe_hold4[2:0],pre_read_add20};
   assign read_add_stubpair21in = {BX_pipe_hold4[2:0],pre_read_add21};
   assign read_add_stubpair22in = {BX_pipe_hold4[2:0],pre_read_add22};
   assign read_add_stubpair23in = {BX_pipe_hold4[2:0],pre_read_add23};
   assign read_add_stubpair24in = {BX_pipe_hold4[2:0],pre_read_add24};

   wire pre_valid_trackpar;
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
    reg valid_trackpar1;
    wire valid_trackpar_pipe;
    wire pass_cut; 
    
    pipe_delay #(.STAGES(9), .WIDTH(1))
              valid_tracklet_pipe(.clk(clk),.val_in(valid_trackpar), .val_out(valid_trackpar_pipe));     
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_trackpar & (stubpair[`MEM_SIZE-1:0] < (2**`MEM_SIZE - 1)) & (stubpair[6+(`MEM_SIZE-1):6] < (2**`MEM_SIZE - 1));
        behold[44:1] <= behold[43:0];
        valid_trackpar1 <= behold[25]; // Margaret changed to match timing of whole project
        valid_trackpar <= behold[26] && pass_cut;
        //valid_trackpar <= behold[19];
        //valid_trackpar <= behold[20];
       // valid_trackpar <= behold[42] && pass_cut;

        first_clk_pipe_dly  <= first_clk_pipe;
        first_clk_pipe_dly2 <= first_clk_pipe_dly;
        //if(stubpair >= 0) begin
            //read_add_innerallstubin <= stubpair[11:6];
            //read_add_outerallstubin <= stubpair[5:0];
            read_add_innerallstubin <= {BX_pipe_hold6,stubpair[6+(`MEM_SIZE-1):6]};
            read_add_outerallstubin <= {BX_pipe_hold6,stubpair[`MEM_SIZE-1:0]};
        //end
   end

   wire [5:0] inner_stub_index;
   wire [5:0] outer_stub_index;
   
   pipe_delay #(.STAGES(26), .WIDTH(6))
          inner_index(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
          .val_in({1'b0,read_add_innerallstubin[`MEM_SIZE-1:0]}), .val_out(inner_stub_index)); 
   
   pipe_delay #(.STAGES(26), .WIDTH(6))
          outer_index(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
          .val_in({1'b0,read_add_outerallstubin[`MEM_SIZE-1:0]}), .val_out(outer_stub_index)); 


    // Store tracklet index for projection
    wire [5:0] index;
    reg [5:0] pre_index;
    //assign index = pre_index; // right now no delay needed, but can put one here if needed 
   pipe_delay #(.STAGES(10), .WIDTH(6)) index_pipe(.clk(clk),.val_in(pre_index), .val_out(index));
   
    always @ (posedge clk) begin
        if (pre_done[0])
            pre_index <= 6'b000000;
        else begin
            if (valid_trackpar1 && pass_cut)
                pre_index <= pre_index + 1'b1;
            else 
                pre_index <= pre_index;
        end
    end
   
    
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

//    14 bits    kr =42.6666667 
//    rmeanL1	22.992	981 
//    rmeanL2	35.507  1515
//    rmeanL3	50.5    2155
//    rmeanL4	68.4    2918
//    rmeanL5	88.4    3772
//    rmeanL6	107.8   4599    

//      15 bits   kz   	17.80869565
//      zmeanD1	131.5   2342       
//      zmeanD2	156.0   2778       
//      zmeanD3	185.0   3295       
//      zmeanD4	220.0   3918       
//      zmeanD5	261.2   4652        

////////////////////////////////////////////////////////////////
    // Step 0: Define the variables
reg signed [12:0] r1;
reg signed [12:0] r2;
reg signed [13:0] z1abs;
reg signed [13:0] z2abs;          //For Layers
reg signed [13:0] z1rel;       //For Disks
reg signed [13:0] z2rel;       //For Disks
reg signed [17:0] phi1;
reg signed [17:0] phi2;
wire [35:0] ias;
wire [35:0] oas;
reg [13:0] zX;

assign ias = innerallstubin;
assign oas = outerallstubin;


// Step0:  Setup 
always @(posedge clk) begin
	if(BARREL)
	  begin
        //R in barrel is signed, In disk R is unsigned.
       		
        if (IsInner1) begin            
         	r1     <= {ias[32],ias[32],ias[32],ias[32],ias[32],ias[32:26],1'b0};//times 2 to match the resolution of L4-6 
         	z1abs  <= {ias[25],ias[25],ias[25:14]};
         	phi1   <= ias[13:0]<<<2'd3;//times 8 to match the resolution of L4-6
        end
        else begin
            r1     <= {ias[32],ias[32],ias[32],ias[32],ias[32],ias[32:25]};
            z1abs  <= {ias[24],ias[24],ias[24:17],4'b0000};//times 16 to match the resolution of L1-3
            phi1   <= ias[16:0];
        end
        
        if (IsInner2) begin
            r2     <= {oas[32],oas[32],oas[32],oas[32],oas[32],oas[32:26],1'b0};// times 2 to match the resolution of L4-6
            z2abs  <= {oas[25],oas[25],oas[25:14]};
            phi2   <= oas[13:0]<<<2'd3;//times 8 to match the resolution of L4-6
        end
        else begin
            r2     <= {oas[32],oas[32],oas[32],oas[32],oas[32],oas[32:25]};
            z2abs  <= {oas[24],oas[24],oas[24:17],4'b0000};//times 16 to match the resolution of L1-3
            phi2   <= oas[16:0];
        end
         	
        zX <=  z1abs;
	  end
	else
	  begin
        r1   <= {1'b0,ias[32:21]};    //Disk             
        r2   <= {1'b0,oas[32:21]};    //Disk    
   		z1rel   <= {ias[20],ias[20],ias[20],ias[20],ias[20],ias[20],ias[20],ias[20:14]};        //For Disks
   		z2rel   <= {oas[20],oas[20],oas[20],oas[20],oas[20],oas[20],oas[20],oas[20:14]};        //For Disks
        z1abs <= z1rel + Z1MEAN;
        zX  <= z1rel + Z1MEAN;
        phi1   <= ias[13:0]<<<2'd3;//times 8 to match the resolution of L4-6
        phi2   <= oas[13:0]<<<2'd3;//times 8 to match the resolution of L4-6
	  end    

end


wire signed [13:0] z1_step6;
	//z1_step6 = z1 Delayed 5/4 clocks step 6 for eq delta_0 = (dphi * invdr)   
	pipe_delay #(.STAGES(8), .WIDTH(14))        //For Layers
        z1_pipe(
    	//           .pipe_in(start), .pipe_out(test4), 
           .clk(clk), .val_in(zX), .val_out(z1_step6));

    wire signed [17:0] phi1_step10;
           //phi1_step10 = phi1 Delayed 9 clocks step 9 for eq phi0 = phi1 + (phi0a<<6);    
           pipe_delay #(.STAGES(17), .WIDTH(18))
              phi1_pipe( 
              .clk(clk), .val_in(phi1), .val_out(phi1_step10));
    
// Step 1: Calculate deltas and absolute radii

    reg signed [13:0] dr;
    wire signed [13:0] dr_fin;
    reg signed [17:0] dphi;
    reg signed [13:0] dz;
    reg signed [13:0] dzA;
    reg signed [13:0] rsum;
    reg signed [13:0] r1abs;
    reg signed [13:0] r2abs;
    reg signed [14:0] dzrel;
    reg signed [14:0] dz12;
    reg signed [14:0] r12;

    always @(posedge clk) begin
        dr        <= r2 - r1;  
        dphi      <= phi2 - phi1;
         
	  if(BARREL)
	   begin
        dz      <= z2abs - z1abs;
        dzA      <= dz;
        rsum    <= r2 + r1;
        r12     <= R1MEAN + R2MEAN;
		r1abs   <=  r1 + R1MEAN;
        r2abs   <=  r2 + R2MEAN;
       end
	  else
	   begin
        dzrel <= z2rel - z1rel;   
        dz12 <= Z2MEAN - Z1MEAN;
        r1abs <= r1 + RMIN;    
        r2abs <= r2 + RMIN;
        dz      <=  dzrel + dz12;         //For Disks         
        dzA      <=  dzrel + dz12;         //For Disks 
//        z1abs <= z1rel + Z1MEAN;
       end
     end
     

    wire signed [16:0] dphi_step4;

    pipe_delay #(.STAGES(22), .WIDTH(14))
        dr_pipe(.clk(clk), .val_in(dr), .val_out(dr_fin));

//dphi_step5 = dphi Delayed 2 clocks step 4 for eq delta_0 = (dphi * invdr)   
    pipe_delay #(.STAGES(2), .WIDTH(17))
         dphi_pipe(
//           .pipe_in(start), .pipe_out(test4), 
           .clk(clk), .val_in(dphi), .val_out(dphi_step4));
           
    wire signed [11:0] dz_step4;
    //dz_step5 = dz Delayed 2/1 clocks step 4 for eq delta_z = (dz * invdr)   
    pipe_delay #(.STAGES(1), .WIDTH(12))          //For Disks
           dz_pipe(.clk(clk), .val_in(dzA), .val_out(dz_step4));

    wire signed [13:0] r1abs_step5;
//r1abs_step5 = r1abs Delayed 3 clocks step 5 for eq delta_1 = r1abs * delta_0   
            pipe_delay #(.STAGES(5), .WIDTH(14))
                   r1abs_pipe(.clk(clk), .val_in(r1abs), .val_out(r1abs_step5));

    wire signed [13:0] r2abs_step5;
//r1abs_step5 = r1abs Delayed 3 clocks step 5 for eq delta_1 = r1abs * delta_0   
            pipe_delay #(.STAGES(5), .WIDTH(14))
                   r2abs_pipe(.clk(clk), .val_in(r2abs), .val_out(r2abs_step5)); 
//Step 2 1/dr, rabs

    wire signed [INVDR_WIDTH-1:0] invdr;
//  Memory contains intergers which take dr as an address
//  and return (2^25)/(dr + (r2mean-r1mean)) into invdr in 2 clocks for disks
//  and return (2^23)/(dr) into invdr in 2 clocks for disks

    Memory #(
           .RAM_WIDTH(INVDR_WIDTH),            // Specify RAM data width
           .RAM_DEPTH(512),                     // Specify RAM depth (number of entries)
           .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" = 2 clks or "LOW_LATENCY" = 1 clks
           .INIT_FILE(InvR_FILE)
         ) lookup_dr_inv (
           .addra(9'b0),    // Write address bus, width determined from RAM_DEPTH
           .addrb(dr[8:0]),  //idelta_r_pipe   // Read address bus, width determined from RAM_DEPTH
           .dina(16'b0),      // RAM input data, width determined from RAM_WIDTH
           .clka(clk),      // Write clock
           .clkb(clk),      // Read clock
           .wea(1'b0),        // Write enable
           .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
           .rstb(reset),      // Output reset (does not affect memory contents)
           .regceb(1'b1),  // Output register enable
           .doutb(invdr)     // RAM output data, width determined from RAM_WIDTH
       );

       reg signed [15:0] rabs;

    always @(posedge clk) begin
	if(BARREL)
  	  begin
           	rabs    <=  (rsum + r12);       //For Layers
	  end
	else
	  begin
        	rabs    <=  r1abs + r2abs;        //For Disks
//        	dz      <=  dzrel + dz12;         //For Disks 
          end
        end

//Step 3 r6=rabs/6
       reg signed [24:0] r6a;
       reg signed [24:0] r6a_pipe;
       wire signed [12:0]r6;
    always @(posedge clk) begin
        r6a  <= (11'd682 * rabs);  //r6=rabs/6 (division completed by >>>10
        r6a_pipe <= r6a;
    end
    assign r6   =    r6a_pipe>>>12; //r6 = (10'd682 * rabs)>>>12
   
    wire signed [12:0] r6_step5;
    //r1abs_step5 = r1abs Delayed 1 clocks step 5 for eq delta_1 = r1abs * delta_0   
            pipe_delay #(.STAGES(2), .WIDTH(13))
                   r6_pipe(.clk(clk), .val_in(r6), .val_out(r6_step5));

//Step 4
        reg signed [33:0] delta_0a;
        reg signed [33:0] delta_0a_pipe;
        reg signed [27:0] delta_za;
        reg signed [27:0] delta_za_pipe;
        wire signed [16:0] delta_0;
        reg signed [16:0] delta_0_pipe;
        wire signed [16:0] delta_z;
        reg signed [16:0] delta_z_pipe;
        wire signed [15:0] x2;
          
    always @(posedge clk) begin
        delta_0a     <=  dphi_step4 * invdr; // delta_0 = (dphi * invdr)
        delta_0a_pipe <= delta_0a;
        delta_za     <=  dz_step4 * invdr;   // delta_z = (dz * invdr)
        delta_za_pipe <= delta_za;
    end
        
	if(BARREL)
  	  begin
    		assign delta_0  =   delta_0a_pipe>>>16; //delta_0 = (dphi * invdr)>>>16; 
    		assign delta_z  =   delta_za_pipe>>>11; //delta_z = (dz * invdr)>>>12;
    	  end
    	else
    	  begin
    		assign delta_0  =   delta_0a_pipe>>>14; //delta_0 = (dphi * invdr)>>>14; 
    		assign delta_z  =   delta_za_pipe>>>10; //delta_z = (dz * invdr)>>>10;    	  
    	  end
    assign x2       =   delta_0>>>1; // x2 = (delta_0)/2;

    wire signed [16:0] delta_0_step9;
    //delta_0_step8 = delta_0 Delayed 4 clocks step 8 for eq inv_rho = (delta_0 * a2m) 
            pipe_delay #(.STAGES(10), .WIDTH(17))
                   delta_0_dly(.clk(clk), .val_in(delta_0), .val_out(delta_0_step9));
                   
    wire signed [15:0] x3_step9;   
    //x3_step8 = delta_z/2 Delayed 3 clocks step 8 for eq t = (x3 * a2)
            pipe_delay #(.STAGES(10), .WIDTH(16))
                   x3_pipe(.clk(clk), .val_in(delta_z[16:1]), .val_out(x3_step9));
                   
    //This pipe is redundent, as delta_0 is also delayed until step 8
    //But it makes modification later, a little easier.               
    wire signed [15:0] x2_step9;   
    //x2_step9 = x2 Delayed 4 clocks step 8 for eq x8 = (x1 * a2m)
            pipe_delay #(.STAGES(10), .WIDTH(16))
                   x2_pipe(.clk(clk), .val_in(x2), .val_out(x2_step9));

    //This pipe is redundent, as delta_0 is also delayed until step 8
    //But it makes modification later, a little easier.               
    wire signed [15:0] x2_step8;   
    //x2_step8 = x2 Delayed 3 clocks step 8 for eq x1 = (x2 * rp)>>>12;
            pipe_delay #(.STAGES(10), .WIDTH(16))
                   x2_pipe2(.clk(clk), .val_in(x2), .val_out(x2_step8));



//Step 5
        reg signed [30:0] delta_1a;
        reg signed [30:0] delta_1a_pipe;
        reg signed [31:0] delta_2a;
        reg signed [31:0] delta_2a_pipe;
        reg signed [29:0] x4a;
        reg signed [29:0] x4a_pipe;
        reg signed [30:0] z0aa;
        reg signed [30:0] z0aa_pipe;
        reg signed [30:0] z0aa_pipe2;
        wire signed [16:0] delta_1;
        reg signed [16:0] delta_1_pipe;
        wire signed [16:0] delta_2;
        reg signed [16:0] delta_2_pipe;
        wire signed [16:0] x4;
        reg signed [16:0] x4_pipe;
        wire signed [16:0] z0a;


    always @(posedge clk) begin
        delta_0_pipe <= delta_0;
        delta_z_pipe <= delta_z;
        delta_1a <= (delta_0_pipe * r1abs_step5);
        delta_1a_pipe <= delta_1a;
        delta_2a <= (delta_0_pipe * r2abs_step5);
        delta_2a_pipe <= delta_2a;
        x4a <= (delta_0_pipe * r6_step5);
        x4a_pipe <= x4a;
        z0aa <= (delta_z_pipe * r1abs_step5);
        z0aa_pipe <= z0aa;
        z0aa_pipe2 <= z0aa_pipe;
        x4_pipe <= x4;
    end
        
    assign delta_1  =   delta_1a_pipe>>>14; //delta_1 = (delta_0 * r1abs)>>>14;
    assign delta_2  =   delta_2a_pipe>>>14; //delta_2 = (delta_0 * r2abs)>>>14;
    assign x4       =   x4a_pipe>>>13; //x4 = (delta_0 * R6)>>>13;
    if (BARREL) begin
        assign z0a  =   z0aa_pipe2>>>14;//z0a = (delta_z * r1abs)>>>14;
    end
    else begin
        assign z0a  =   z0aa_pipe2>>>13;//z0a = (delta_z * r1abs)>>>13;
    end

    wire signed [16:0] delta_1_step9;
    //delta_1_step8 = delta_1 Delayed 2 clocks step 8 for eq phi0a = (delta_1 * x6m)>>>14;
            pipe_delay #(.STAGES(7), .WIDTH(17))
                   delta_1_dly(.clk(clk), .val_in(delta_1), .val_out(delta_1_step9));

//Step 6
        reg signed [10:0] pre_z0;
        reg signed [10:0] z0;
        reg signed [33:0] a2aa;
        reg signed [33:0] a2aa_pipe;
        reg signed [33:0] x6aa;
        reg signed [33:0] x6aa_pipe;
        wire signed [16:0] a2a;
        reg signed [16:0] a2a_pipe;
        wire signed [16:0] x6a;
        reg signed [16:0] x6a_pipe;

    always @(posedge clk) begin
        delta_1_pipe <= delta_1;       
        delta_2_pipe <= delta_2;       
        pre_z0       <=  z1_step6 - z0a;  // z0 = z1 - z0a;
        z0           <= pre_z0; 
        a2aa         <= (delta_1_pipe * delta_2_pipe);
        a2aa_pipe    <= a2aa; 
        x6aa         <= (delta_2_pipe * x4_pipe);
        x6aa_pipe    <= x6aa;
    end

    assign a2a      =   a2aa_pipe>>>17; //a2a = (delta_1 * delta_2)>>>17; 
    assign x6a      =   x6aa_pipe>>>17; //x6a = (delta_2 * x4)>>>17; 
        
    wire signed [10:0] z0_step8;
    wire signed [10:0] z0_step14;
    wire signed [10:0] z0_fin;
    //z0_step8 = z0 Delayed 1 clocks step 14 Layer Projection for eq. zL = z0 + x23;
            pipe_delay #(.STAGES(5), .WIDTH(11))
                   z0_pipe0(.clk(clk), .val_in(z0), .val_out(z0_step8));

    //z0_step14 = z0_step8 Delayed 6 clocks step 14 Layer Projection for eq. zL = z0 + x23;
           pipe_delay #(.STAGES(5), .WIDTH(11))
                   z0_pipe1(.clk(clk), .val_in(z0_step8), .val_out(z0_step14));
                   
    //z0_step15 = z0 Delayed 3 more clocks for outputing at step 15
            pipe_delay #(.STAGES(7), .WIDTH(11))
                   z0_pipe2(.clk(clk), .val_in(z0_step8), .val_out(z0_fin));

//Step 7
        reg signed [28:0] a2mb;
        reg signed [28:0] a2mb_pipe;
        reg signed [28:0] x6mb;
        reg signed [28:0] x6mb_pipe;
        wire signed [16:0] a2ma;
        wire signed [16:0] x6ma;


    always @(posedge clk) begin
        a2a_pipe <= a2a;
        x6a_pipe <= x6a;
        a2mb     <= (a2a_pipe * 12'sd1466);
        a2mb_pipe <= a2mb; 
        x6mb     <= (x6a_pipe * 12'sd1466);
        x6mb_pipe <= x6mb;
    end

    assign a2ma      =   a2mb_pipe>>>12; //a2ma = (a2a*1466)>>>12;    
    assign x6ma      =   x6mb_pipe>>>12; //x6ma = (x6a*1466)>>>12;
        
//Step 8
        reg signed [16:0] a2mc;        
        reg signed [16:0] x6mc;
        reg signed [16:0] a2b;
        wire signed [11:0] a2m;
        reg signed [11:0] a2m_pipe;
        wire signed [11:0] x6m;
        wire signed [11:0] a2;

    always @(posedge clk) begin
        a2mc     <=  a2ma - 17'sd1024;
        x6mc     <=  x6ma - 17'sd1024;
        a2b      <=  17'sd1024 - a2ma;
         end

    assign a2m      =  a2mc[11:0]; //a2m = a2ma -1024; 12 LSB
    assign x6m      =  x6mc[11:0]; //x6m = -1024 + x6a; 12 LSB
    assign a2       =  a2b[11:0]; //a2= 1024 - a2a;  12 LSB
        
//Step 9
            reg signed [30:0] inv_rhoa;
            reg signed [30:0] inv_rhoa_pipe;
            reg signed [29:0] ta;
            reg signed [29:0] ta_pipe;
            reg signed [30:0] phi0aa;
            reg signed [30:0] phi0aa_pipe;
            reg signed [29:0] der_phiLa;
            reg signed [29:0] der_phiLa_pipe;
            wire signed [14:0] inv_rho;
            wire signed [13:0] t;
            wire signed [17:0] phi0a;
            wire signed [6:0] der_zL;
            wire signed [5:0] pre_der_phiL;
            reg signed [5:0] der_phiL;
            wire signed [16:0] pre_x7;
            wire signed [16:0] x7;
            reg signed [16:0] x7_pipe;
            reg signed [16:0] x7_pipe2;
            wire signed [13:0] tD;
            wire signed [13:0] tL;
    
        always @(posedge clk) begin
            a2m_pipe    <= a2m;
            ta          <=  (x3_step9 * a2);
            ta_pipe     <= ta;
            phi0aa      <=  (delta_1_step9 * x6m);
            phi0aa_pipe <= phi0aa;
            der_phiLa    <=  (x2_step9 * a2);
            der_phiLa_pipe    <=  der_phiLa;
            inv_rhoa    <= (delta_0_step9 * a2m);
            inv_rhoa_pipe     <= inv_rhoa;
            der_phiL    <= pre_der_phiL;
            x7_pipe     <= x7;
            x7_pipe2    <= x7_pipe;
        end
    
        assign inv_rho      =   inv_rhoa_pipe>>>11;   //inv_rho = (delta_0 * a2m)>>>11;
        if (BARREL) begin
            assign t        =   ta_pipe>>>12;         //t = (x3 * a2)>>>12;
        end 
        else begin
            assign t        =   ta_pipe>>>11;         //t = (x3 * a2)>>>11;
        end
        assign phi0a        =   phi0aa_pipe>>>5;     //phi0a = (delta_1 * x6m)>>>14; 
        assign pre_der_phiL     =   der_phiLa_pipe>>>18;  //der_phiL = (x2 * a2)>>>18;
        assign pre_x7           =   der_phiLa_pipe>>>7;       //x7 = (x2 * a2)>>>7; Used in Disk Projections
        assign tD           =   t;              //t for Disk Projections
        assign tL           =   t;              //t for Layer Projections

        pipe_delay #(.STAGES(1), .WIDTH(17))
                           pre_x7_pipe(.clk(clk), .val_in(pre_x7), .val_out(x7));
                           

        wire signed [16:0] x7_step11;             
        //x7_step11 = x7 Delayed 1 clocks for eq. der_phiD = (invt * x7)>>29;
                    pipe_delay #(.STAGES(1), .WIDTH(17))
                           x7_pipe_dly(.clk(clk), .val_in(x7), .val_out(x7_step11));

        wire signed [14:0] inv_rho_fin;
        //inv_rho_fin = inv_rho Delayed 5 clocks for outputing at step 15
                pipe_delay #(.STAGES(6), .WIDTH(15))
                       inv_rho_pipe(.clk(clk), .val_in(inv_rho), .val_out(inv_rho_fin));

        reg signed [7:0] pre_der_zL_fin;
        wire signed [7:0] der_zL_fin;
        wire signed [13:0] t_fin;
               //t_fin = t Delayed 5 clocks for outputing at step 15
                pipe_delay #(.STAGES(6), .WIDTH(14))
                       t_fin_pipe(.clk(clk), .val_in(t), .val_out(t_fin));
                               
        wire signed [5:0] der_phiL_fin;
               //der_phiL_fin = der_phiL Delayed 5 clocks for outputing at step 15
        pipe_delay #(.STAGES(15), .WIDTH(6))
                   der_phiL_pipe(.clk(clk), .val_in(der_phiL), .val_out(der_phiL_fin));
                       
        pipe_delay #(.STAGES(9), .WIDTH(8))
                   der_zL_pipe(.clk(clk), .val_in(pre_der_zL_fin), .val_out(der_zL_fin));

//Step 10
        reg signed [18:0] phi0s;

        always @(posedge clk) begin
            pre_der_zL_fin   <=   t_fin>>>6;                //der_zL = t>>>6;
            phi0s        <=   (phi1_step10 + phi0a);    //phi0s = phi1 + phi0a;
        end
            
       
    wire signed [18:0] phi0_step12;
    wire signed [18:0] phi0_step14;
    wire signed [18:0] phi0_fin;
    //phi0_step12 = phi0 Delayed 1 clocks step 12 Layer Projection for eq. phi0 = phi1 + (phi0a<<6); 
            pipe_delay #(.STAGES(2), .WIDTH(19))
                   phi0_pipe0(.clk(clk), .val_in(phi0s), .val_out(phi0_step12));
 
    //phi0_step14 = phi0_step12 Delayed 2 clocks step 14 Layer Projection for eq. phiL = phi0 - x22; 
            pipe_delay #(.STAGES(3), .WIDTH(19))
                   phi0_pipe1(.clk(clk), .val_in(phi0s), .val_out(phi0_step14));

    //phi0_fin = phi0 Delayed 2 more clocks for outputing at step 15
            pipe_delay #(.STAGES(2), .WIDTH(19))
                   phi0_pipe2(.clk(clk), .val_in(phi0_step14>>>1), .val_out(phi0_fin)); //Phi0 = Phi0s>>1 

    // tracklet parameter cuts
    //assign pass_cut = (inv_rho_fin < 7491 && inv_rho_fin > -7491 && z0_fin <= 267 && z0_fin >= -267);i
    generate
        if (BARREL)
            assign pass_cut = (inv_rho_fin < 4994 && inv_rho_fin > -4994 && z0_fin <= 267 && z0_fin >= -267);
        else
            assign pass_cut = (inv_rho_fin < 4994 && inv_rho_fin > -4994 && z0_fin <= 267 && z0_fin >= -267 && dr_fin >= 83);
    endgenerate

    wire pass_cut_dly;

    pipe_delay #(.STAGES(10), .WIDTH(1))
                   pass_cut_pipe(.clk(clk), .val_in(pass_cut), .val_out(pass_cut_dly)); //Phi0 = Phi0s>>1 

        always @(posedge clk) begin
            trackpar  <= {inner_stub_index,outer_stub_index,inv_rho_fin[13:0],phi0_fin[17:0],z0_fin[9:0],t_fin}; // register for now, but should be wire 
        end    

    wire signed [19:0] invt;  //Only Needed for disk projection
    reg signed [19:0] invt_pipe;
    
	if(BARREL)
        begin
        //  Memory contains intergers which take t as an address
        //  and return (2^28)/(t) into invdr in 1 clock
        Memory #(
            .RAM_WIDTH(20),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" = 2 clks or "LOW_LATENCY" = 1 clks
            .INIT_FILE(InvT_FILE)
         ) lookup_t_inv (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            //           t[11:2] for layers
            //           t[12:3] for disks
            .addrb(t>>2),  //idelta_r_pipe   // Read address bus, width determined from RAM_DEPTH
            .dina(16'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(reset),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(invt)     // RAM output data, width determined from RAM_WIDTH
        );
        end
    else
        begin
        //  Memory contains intergers which take t as an address
        //  and return (2^28)/(t) into invdr in 1 clock
        Memory #(
            .RAM_WIDTH(20),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" = 2 clks or "LOW_LATENCY" = 1 clks
            .INIT_FILE(InvT_FILE)
        ) lookup_t_inv (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            //           t[11:2] for layers
            //           t[12:3] for disks
            .addrb(t>>>3),  //idelta_r_pipe   // Read address bus, width determined from RAM_DEPTH
            .dina(16'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(reset),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(invt)     // RAM output data, width determined from RAM_WIDTH
        );
        end


//Step 11: //Only for disk Projections
         reg signed [7:0] der_rD;
         reg signed [37:0] der_phiDa;
         wire signed [5:0] der_phiD;
                       
        always @(posedge clk) begin
            invt_pipe   <= invt;
            der_rD      <= invt_pipe>>>12;
            der_phiDa   <=  (invt_pipe * x7_step11);
            end
            
        assign der_phiD =   der_phiDa>>>29; //der_phiD = (invt * x7)>>29;    
        
        wire signed [5:0] der_phiD_fin;
        //der_phiD_fin = der_phiD Delayed 4 clocks step 15 for outputing at step 16
                pipe_delay #(.STAGES(13), .WIDTH(6))
                       der_phiD_pipe(.clk(clk), .val_in(der_phiD), .val_out(der_phiD_fin));

        wire signed [7:0] der_rD_fin;
        //der_rD_fin = der_rD Delayed 4 clocks step 15 for outputing at step 16
                pipe_delay #(.STAGES(13), .WIDTH(8))
                       der_rD_pipe(.clk(clk), .val_in(der_rD), .val_out(der_rD_fin));
                           

//    14 bits    kr =42.6666667 
//    rmeanL1	22.992	981 
//    rmeanL2	35.507  1515
//    rmeanL3	50.5    2155
//    rmeanL4	68.4    2918
//    rmeanL5	88.4    3772
//    rmeanL6	107.8   4599

//    ps/2s Disk boundry R=2560  
//    ((108-12)/2 + 12) * kr = 2560  

//      15 bits   kz   	17.80869565
//      zmeanD1	131.5   2342       
//      zmeanD2	156.0   2778       
//      zmeanD3	185.0   3295       
//      zmeanD4	220.0   3918       
//      zmeanD5	261.2   4652        

    wire signed [5:0] der_phiD_D1;
    wire signed [7:0] der_rD_D1;
    wire signed [16:0] phiD_fin_D1;
    wire signed [13:0] rD_fin_D1;
    reg [53:0] ProjD1;
    wire vpD1;
    wire vpD1p;
    wire vpD1m;
    
    wire signed [5:0] der_phiD_D2;
    wire signed [7:0] der_rD_D2;
    wire signed [16:0] phiD_fin_D2;
    wire signed [13:0] rD_fin_D2;
    reg [53:0] ProjD2;
    wire vpD2;
    wire vpD2p;
    wire vpD2m;

    wire signed [5:0] der_phiD_D3;
    wire signed [7:0] der_rD_D3;
    wire signed [16:0] phiD_fin_D3;
    wire signed [13:0] rD_fin_D3;
    reg [53:0] ProjD3;
    wire vpD3;
    wire vpD3p;
    wire vpD3m;
    
    wire signed [5:0] der_phiD_D4;
    wire signed [7:0] der_rD_D4;
    wire signed [16:0] phiD_fin_D4;
    wire signed [13:0] rD_fin_D4;
    reg [53:0] ProjD4;
    wire vpD4;
    wire vpD4p;
    wire vpD4m;

    wire signed [5:0] der_phiD_D5;
    wire signed [7:0] der_rD_D5;
    wire signed [16:0] phiD_fin_D5;
    wire signed [13:0] rD_fin_D5;
    reg [53:0] ProjD5;
    wire vpD5;
    wire vpD5p;
    wire vpD5m;
    

    DiskProjY #(.ZP(`ZPROJ_F1)) F1_proj(
        .clk(clk),                // processing clock
        .x7(x7),
        .invt(invt_pipe),
        .z0(z0_step8),
        .phi0(phi0_step12),
        .phiD(phiD_fin_D1),
        .rD(rD_fin_D1),
        .valid_proj(vpD1),
        .valid_projPlus(vpD1p),
        .valid_projMinus(vpD1m)
    );   

    DiskProjY #(.ZP(`ZPROJ_F2)) F2_proj(
        .clk(clk),                // processing clock
        .x7(x7),
        .invt(invt_pipe),
        .z0(z0_step8),
        .phi0(phi0_step12),
        .phiD(phiD_fin_D2),
        .rD(rD_fin_D2),
        .valid_proj(vpD2),
        .valid_projPlus(vpD2p),
        .valid_projMinus(vpD2m)
    );
   
    DiskProjY #(.ZP(`ZPROJ_F3)) F3_proj(
        .clk(clk),                // processing clock
        .x7(x7),
        .invt(invt_pipe),
        .z0(z0_step8),
        .phi0(phi0_step12),
        .phiD(phiD_fin_D3),
        .rD(rD_fin_D3),
        .valid_proj(vpD3),
        .valid_projPlus(vpD3p),
        .valid_projMinus(vpD3m)
    );
    
     DiskProjY #(.ZP(`ZPROJ_F4)) F4_proj(
           .clk(clk),                // processing clock
           .x7(x7),
           .invt(invt_pipe),
           .z0(z0_step8),
           .phi0(phi0_step12),
           .phiD(phiD_fin_D4),
           .rD(rD_fin_D4),
           .valid_proj(vpD4),
           .valid_projPlus(vpD4p),
           .valid_projMinus(vpD4m)
       );
      
     DiskProjY #(.ZP(`ZPROJ_F5)) F5_proj(
             .clk(clk),                // processing clock
             .x7(x7),
             .invt(invt_pipe),
             .z0(z0_step8),
             .phi0(phi0_step12),
             .phiD(phiD_fin_D5),
             .rD(rD_fin_D5),
             .valid_proj(vpD5),
             .valid_projPlus(vpD5p),
             .valid_projMinus(vpD5m)
         );      
       

    always @(posedge clk) begin

        ProjD1 <= {2'b00, vpD1m, vpD1p,TC_index, index,phiD_fin_D1[13:0],rD_fin_D1[11:0],der_phiD_fin[5:0],der_rD_fin[7:0]};
            
        //if (valid_trackpar == 1'b1 && vpD1==1'b1 && rD_fin_D1[11:0] < $signed(12'd2560)) begin
        if (valid_trackpar_pipe == 1'b1 && vpD1==1'b1 && rD_fin_D1[11] == 1'b0) begin
            valid_projout_F1D5 <= pass_cut_dly;
            valid_projout_F1D6 <= 1'b0;
            valid_projoutToPlus_F1 <= 1'b0;
            valid_projoutToMinus_F1 <= 1'b0;
        end
        //else if (valid_trackpar_pipe == 1'b1 && vpD1==1'b1 && rD_fin_D1[11:0] >= $signed(12'd2560)) begin
        else if (valid_trackpar_pipe == 1'b1 && vpD1==1'b1 && rD_fin_D1[11] == 1'b1) begin
            valid_projout_F1D5 <= 1'b0;
            valid_projout_F1D6 <= pass_cut_dly;
            valid_projoutToPlus_F1 <= 1'b0;
            valid_projoutToMinus_F1 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD1p==1'b1) begin
            valid_projout_F1D5 <= 1'b0;
            valid_projout_F1D6 <= 1'b0;
            valid_projoutToPlus_F1 <= pass_cut_dly;
            valid_projoutToMinus_F1 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD1m==1'b1) begin
            valid_projout_F1D5 <= 1'b0;
            valid_projout_F1D6 <= 1'b0;
            valid_projoutToPlus_F1 <= 1'b0;
            valid_projoutToMinus_F1 <= pass_cut_dly;
        end
        else begin
            valid_projout_F1D5 <= 1'b0;
            valid_projout_F1D6 <= 1'b0;
            valid_projoutToPlus_F1 <= 1'b0;
            valid_projoutToMinus_F1 <= 1'b0;
        end
    end
    
    assign projout_F1D5      = ProjD1;
    assign projout_F1D6      = ProjD1;
    assign projoutToPlus_F1  = ProjD1;
    assign projoutToMinus_F1 = ProjD1;
    
    
    always @(posedge clk) begin
        ProjD2 <= {2'b00, vpD2m, vpD2p,TC_index, index,phiD_fin_D2[13:0],rD_fin_D2[11:0],der_phiD_fin[5:0],der_rD_fin[7:0]};
            
        //if(valid_trackpar_pipe == 1'b1 && vpD2==1'b1 && rD_fin_D2[11:0] < $signed(12'd2560)) begin
        if(valid_trackpar_pipe == 1'b1 && vpD2==1'b1 && rD_fin_D2[11] == 1'b0) begin
            valid_projout_F2D5 <= pass_cut_dly;
            valid_projout_F2D6 <= 1'b0;
            valid_projoutToPlus_F2 <= 1'b0;
            valid_projoutToMinus_F2 <= 1'b0;
        end
        //else if (valid_trackpar_pipe == 1'b1 && vpD2==1'b1 && rD_fin_D2[11:0] >= $signed(12'd2560)) begin            
        else if (valid_trackpar_pipe == 1'b1 && vpD2==1'b1 && rD_fin_D2[11] == 1'b1) begin            
            valid_projout_F2D5 <= 1'b0;
            valid_projout_F2D6 <= pass_cut_dly;
            valid_projoutToPlus_F2 <= 1'b0;
            valid_projoutToMinus_F2 <= 1'b0;
        end            
        else if (valid_trackpar_pipe == 1'b1 && vpD2p==1'b1)begin
            valid_projout_F2D5 <= 1'b0;
            valid_projout_F2D6 <= 1'b0;
            valid_projoutToPlus_F2 <= pass_cut_dly;
            valid_projoutToMinus_F2 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD2m==1'b1)begin
            valid_projout_F2D5 <= 1'b0;
            valid_projout_F2D6 <= 1'b0;
            valid_projoutToPlus_F2 <= 1'b0;
            valid_projoutToMinus_F2 <= pass_cut_dly;
        end
        else begin
            valid_projout_F2D5 <= 1'b0;
            valid_projout_F2D6 <= 1'b0;
            valid_projoutToPlus_F2 <= 1'b0;
            valid_projoutToMinus_F2 <= 1'b0;
        end
    end
        
    assign projout_F2D5      = ProjD2;
    assign projout_F2D6      = ProjD2;
    assign projoutToPlus_F2  = ProjD2;
    assign projoutToMinus_F2 = ProjD2;

    always @(posedge clk) begin

        ProjD3 <= {2'b00, vpD3m, vpD3p,TC_index, index,phiD_fin_D3[13:0],rD_fin_D3[11:0],der_phiD_fin[5:0],der_rD_fin[7:0]};
//        if (rD_fin_D3 >= $signed(12'd2560)) begin
//            ProjD3 <= {vpD3m,vpD3p,10'h3ff,phiD_fin_D3[16:0],rD_fin_D3[11:4],der_phiD_fin[5],der_phiD_fin[5],der_phiD_fin,der_rD_fin};
//        end
//        else begin
//            //ProjD3 <= {vpD3m,vpD3p,10'h3ff,phiD_fin_D3[16:0],rD_fin_D3[11:4],der_phiD_fin[5],der_phiD_fin[5],der_phiD_fin,der_rD_fin};
//            ProjD3 <= {vpD3m,vpD3p,10'h3ff,phiD_fin_D3[16:3],rD_fin_D3,der_phiD_fin[5],der_phiD_fin,der_rD_fin[6],der_rD_fin};
//        end
            
        //if (valid_trackpar_pipe == 1'b1 && vpD3==1'b1 && rD_fin_D3[11:0] < $signed(12'd2560)) begin
        if (valid_trackpar_pipe == 1'b1 && vpD3==1'b1 && rD_fin_D3[11] == 1'b0) begin
            valid_projout_F3D5 <= pass_cut_dly;
            valid_projout_F3D6 <= 1'b0;
            valid_projoutToPlus_F3 <= 1'b0;
            valid_projoutToMinus_F3 <= 1'b0;
        end
        //else if (valid_trackpar_pipe == 1'b1 && vpD3==1'b1 && rD_fin_D3[11:0] >= $signed(12'd2560)) begin
        else if (valid_trackpar_pipe == 1'b1 && vpD3==1'b1 && rD_fin_D3[11] == 1'b1) begin
            valid_projout_F3D5 <= 1'b0;
            valid_projout_F3D6 <= pass_cut_dly;
            valid_projoutToPlus_F3 <= 1'b0;
            valid_projoutToMinus_F3 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD3p==1'b1) begin
            valid_projout_F3D5 <= 1'b0;
            valid_projout_F3D6 <= 1'b0;
            valid_projoutToPlus_F3 <= pass_cut_dly;
            valid_projoutToMinus_F3 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD3m==1'b1) begin
            valid_projout_F3D5 <= 1'b0;
            valid_projout_F3D6 <= 1'b0;
            valid_projoutToPlus_F3 <= 1'b0;
            valid_projoutToMinus_F3 <= pass_cut_dly;
        end
        else begin
            valid_projout_F3D5 <= 1'b0;
            valid_projout_F3D6 <= 1'b0;
            valid_projoutToPlus_F3 <= 1'b0;
            valid_projoutToMinus_F3 <= 1'b0;
        end
    end
    
    assign projout_F3D5      = ProjD3;
    assign projout_F3D6      = ProjD3;
    assign projoutToPlus_F3  = ProjD3;
    assign projoutToMinus_F3 = ProjD3;
    
    
    always @(posedge clk) begin
        ProjD4 <= {2'b00, vpD4m, vpD4p,TC_index, index,phiD_fin_D4[13:0],rD_fin_D4[11:0],der_phiD_fin[5:0],der_rD_fin[7:0]};
//        if (rD_fin_D4 >= $signed(12'd2560)) begin
//            ProjD4 <= {vpD4m,vpD4p,10'h3ff,phiD_fin_D4[16:0],rD_fin_D4[11:4],der_phiD_fin[5],der_phiD_fin[5],der_phiD_fin,der_rD_fin};
//            end
//        else begin
//            ProjD4 <= {vpD4m,vpD4p,10'h3ff,phiD_fin_D4[16:3],rD_fin_D4,der_phiD_fin[5],der_phiD_fin,der_rD_fin[6],der_rD_fin};
//            end
            
        //if(valid_trackpar_pipe == 1'b1 && vpD4==1'b1 && rD_fin_D4[11:0] < $signed(12'd2560)) begin
        if(valid_trackpar_pipe == 1'b1 && vpD4==1'b1 && rD_fin_D4[11] == 1'b0) begin
            valid_projout_F4D5 <= pass_cut_dly;
            valid_projout_F4D6 <= 1'b0;
            valid_projoutToPlus_F4 <= 1'b0;
            valid_projoutToMinus_F4 <= 1'b0;
        end
        //else if (valid_trackpar_pipe == 1'b1 && vpD4==1'b1 && rD_fin_D4[11:0] >= $signed(12'd2560)) begin            
        else if (valid_trackpar_pipe == 1'b1 && vpD4==1'b1 && rD_fin_D4[11] == 1'b1) begin            
            valid_projout_F4D5 <= 1'b0;
            valid_projout_F4D6 <= pass_cut_dly;
            valid_projoutToPlus_F4 <= 1'b0;
            valid_projoutToMinus_F4 <= 1'b0;
        end            
        else if (valid_trackpar_pipe == 1'b1 && vpD4p==1'b1)begin
            valid_projout_F4D5 <= 1'b0;
            valid_projout_F4D6 <= 1'b0;
            valid_projoutToPlus_F4 <= pass_cut_dly;
            valid_projoutToMinus_F4 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD4m==1'b1)begin
            valid_projout_F4D5 <= 1'b0;
            valid_projout_F4D6 <= 1'b0;
            valid_projoutToPlus_F4 <= 1'b0;
            valid_projoutToMinus_F4 <= pass_cut_dly;
        end
        else begin
            valid_projout_F4D5 <= 1'b0;
            valid_projout_F4D6 <= 1'b0;
            valid_projoutToPlus_F4 <= 1'b0;
            valid_projoutToMinus_F4 <= 1'b0;
        end
    end
        
    assign projout_F4D5      = ProjD4;
    assign projout_F4D6      = ProjD4;
    assign projoutToPlus_F4  = ProjD4;
    assign projoutToMinus_F4 = ProjD4;
    
    always @(posedge clk) begin
        ProjD5 <= {2'b00, vpD5m, vpD5p,TC_index, index,phiD_fin_D5[13:0],rD_fin_D5[11:0],der_phiD_fin[5:0],der_rD_fin[7:0]};
//        if (rD_fin_D5 >= $signed(12'd2560)) begin
//            ProjD5 <= {vpD5m,vpD5p,10'h3ff,phiD_fin_D5[16:0],rD_fin_D5[11:4],der_phiD_fin[5],der_phiD_fin[5],der_phiD_fin,der_rD_fin};
//        end
//        else begin
//            ProjD5 <= {vpD5m,vpD5p,10'h3ff,phiD_fin_D5[16:3],rD_fin_D5,der_phiD_fin[5],der_phiD_fin,der_rD_fin[6],der_rD_fin};
//        end
            
        //if (valid_trackpar_pipe == 1'b1 && vpD5==1'b1 && rD_fin_D5[11:0] < $signed(12'd2560)) begin
        if (valid_trackpar_pipe == 1'b1 && vpD5==1'b1 && rD_fin_D5[11] == 1'b0) begin
            valid_projout_F5D5 <= pass_cut_dly;
            valid_projout_F5D6 <= 1'b0;
            valid_projoutToPlus_F5 <= 1'b0;
            valid_projoutToMinus_F5 <= 1'b0;
        end
        //else if (valid_trackpar_pipe == 1'b1 && vpD5==1'b1 && rD_fin_D5[11:0] >= $signed(12'd2560)) begin
        else if (valid_trackpar_pipe == 1'b1 && vpD5==1'b1 && rD_fin_D5[11] == 1'b1) begin
            valid_projout_F5D5 <= 1'b0;
            valid_projout_F5D6 <= pass_cut_dly;
            valid_projoutToPlus_F5 <= 1'b0;
            valid_projoutToMinus_F5 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD5p==1'b1)begin
            valid_projout_F5D5 <= 1'b0;
            valid_projout_F5D6 <= 1'b0;
            valid_projoutToPlus_F5 <= pass_cut_dly;
            valid_projoutToMinus_F5 <= 1'b0;
        end
        else if (valid_trackpar_pipe == 1'b1 && vpD5m==1'b1)begin
            valid_projout_F5D5 <= 1'b0;
            valid_projout_F5D6 <= 1'b0;
            valid_projoutToPlus_F5 <= 1'b0;
            valid_projoutToMinus_F5 <= pass_cut_dly;
        end
        else begin
            valid_projout_F5D5 <= 1'b0;
            valid_projout_F5D6 <= 1'b0;
            valid_projoutToPlus_F5 <= 1'b0;
            valid_projoutToMinus_F5 <= 1'b0;
        end
    end
            
    assign projout_F5D5      = ProjD5;
    assign projout_F5D6      = ProjD5;
    assign projoutToPlus_F5  = ProjD5;
    assign projoutToMinus_F5 = ProjD5;    



    wire signed [18:0] phiL_fin_L1;
    wire signed [11:0] zL_fin_L1;
    //(* mark_debug = "true" *) 
    reg [52:0] ProjL1;
    //(* mark_debug = "true" *) 
    wire vp1;
    wire vp1p;
    wire vp1m;

    LayerProjY #(.RP(`RPROJ_L1)) L1_proj(
        .clk(clk),                // processing clock
        .x2(x2_step8),
        .a2m(a2m_pipe),
        .t(t),
        .phi0(phi0_step14),
        .z0(z0_step14),
        .phiL(phiL_fin_L1),
        .zL(zL_fin_L1),
        .valid_proj(vp1),
        .valid_projPlus(vp1p),
        .valid_projMinus(vp1m)
    );

//       Assign ProjL1 = {vp1m,vp1p,10'h3ff,phiL_fin_L1[16:3],zL_fin_L1,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
    always @(posedge clk) begin
        //ProjL1 <= {vp1m,vp1p,TC_index, index,phiL_fin_L1[16:3],zL_fin_L1,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
        ProjL1 <= {vp1m,vp1p,TC_index, index,phiL_fin_L1[16:3],zL_fin_L1,der_phiL_fin[5],der_phiL_fin,der_zL_fin};

        
        if(valid_trackpar_pipe == 1'b1 && vp1==1'b1 && zL_fin_L1[11:10]==1'b00) begin
            valid_projout_L1D3 <= pass_cut_dly;
            valid_projout_L1D4 <= 1'b0;
            valid_projoutToPlus_L1 <= 1'b0;
            valid_projoutToMinus_L1 <= 1'b0;
        end
        else if(valid_trackpar_pipe == 1'b1 && vp1==1'b1 && zL_fin_L1[11:10]==1'b01) begin
                valid_projout_L1D3 <= 1'b0;
                valid_projout_L1D4 <= pass_cut_dly;//1'b1;
                valid_projoutToPlus_L1 <= 1'b0;
                valid_projoutToMinus_L1 <= 1'b0;
                end            
        else if (valid_trackpar_pipe==1'b1 && vp1p==1'b1)begin
            valid_projout_L1D3 <= 1'b0;
            valid_projout_L1D4 <= 1'b0;
            valid_projoutToPlus_L1 <= pass_cut_dly;//1'b1;
            valid_projoutToMinus_L1 <= 1'b0;
            end
        else if (valid_trackpar_pipe==1'b1 && vp1m==1'b1)begin
            valid_projout_L1D3 <= 1'b0;
            valid_projout_L1D4 <= 1'b0;
            valid_projoutToPlus_L1 <= 1'b0;
            valid_projoutToMinus_L1 <= pass_cut_dly;//1'b1;
            end
        else begin
             valid_projout_L1D3 <= 1'b0;
             valid_projout_L1D4 <= 1'b0;
             valid_projoutToPlus_L1 <= 1'b0;
             valid_projoutToMinus_L1 <= 1'b0;
             end
    end
    
        assign projout_L1D3 =   ProjL1;
        assign projout_L1D4 =   ProjL1;
        assign projoutToPlus_L1 =   ProjL1;
        assign projoutToMinus_L1 =   ProjL1;


    wire signed [18:0] phiL_fin_L2;
    wire signed [11:0] zL_fin_L2;
    // (* mark_debug = "true" *) 
    reg [52:0] ProjL2;
    //(* mark_debug = "true" *) 
    wire vp2;
    // (* mark_debug = "true" *)
    wire vp2p;
    wire vp2m;

    LayerProjY #(.RP(`RPROJ_L2)) L2_proj(
        .clk(clk),                // processing clock
        .x2(x2_step8),
        .a2m(a2m_pipe),
        .t(t),
        .phi0(phi0_step14),
        .z0(z0_step14),
        .phiL(phiL_fin_L2),
        .zL(zL_fin_L2),
        .valid_proj(vp2),
        .valid_projPlus(vp2p),
        .valid_projMinus(vp2m)
    );

//       Assign ProjL2 = {vp2m,vp2p,10'h3ff,phiL_fin_L2[16:3],zL_fin_L2,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
    always @(posedge clk) begin
        //ProjL2 <= {vp2m,vp2p,TC_index, index,phiL_fin_L2[16:3],zL_fin_L2,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
        ProjL2 <= {vp2m,vp2p,TC_index, index,phiL_fin_L2[16:3],zL_fin_L2,der_phiL_fin[5],der_phiL_fin,der_zL_fin};

        
        if(valid_trackpar_pipe == 1'b1 && vp2==1'b1 && zL_fin_L2[11:10]==2'b00) begin
            valid_projout_L2D3 <= pass_cut_dly;//1'b1;
            valid_projout_L2D4 <= 1'b0;
            valid_projoutToPlus_L2 <= 1'b0;
            valid_projoutToMinus_L2 <= 1'b0;
            end
        else if(valid_trackpar_pipe == 1'b1 && vp2==1'b1 && zL_fin_L2[11:10]==2'b01) begin
                valid_projout_L2D3 <= 1'b0;
                valid_projout_L2D4 <= pass_cut_dly;//1'b1;
                valid_projoutToPlus_L2 <= 1'b0;
                valid_projoutToMinus_L2 <= 1'b0;
                end            
        else if (valid_trackpar_pipe==1'b1 && vp2p==1'b1)begin
            valid_projout_L2D3 <= 1'b0;
            valid_projout_L2D4 <= 1'b0;
            valid_projoutToPlus_L2 <= pass_cut_dly;//1'b1;
            valid_projoutToMinus_L2 <= 1'b0;
            end
        else if (valid_trackpar_pipe==1'b1 && vp2m==1'b1)begin
            valid_projout_L2D3 <= 1'b0;
            valid_projout_L2D4 <= 1'b0;
            valid_projoutToPlus_L2 <= 1'b0;
            valid_projoutToMinus_L2 <= pass_cut_dly;//1'b1;
            end
        else begin
             valid_projout_L2D3 <= 1'b0;
             valid_projout_L2D4 <= 1'b0;
             valid_projoutToPlus_L2 <= 1'b0;
             valid_projoutToMinus_L2 <= 1'b0;
             end
    end
    
        assign projout_L2D3 =   ProjL2;
        assign projout_L2D4 =   ProjL2;
        assign projoutToPlus_L2 =   ProjL2;
        assign projoutToMinus_L2 =   ProjL2;

    wire signed [18:0] phiL_fin_L3;
    wire signed [11:0] zL_fin_L3;
   // (* mark_debug = "true" *) 
    reg [52:0] ProjL3;
   // (* mark_debug = "true" *) 
    wire vp3;
    //(* mark_debug = "true" *) 
    wire vp3p;
    wire vp3m;

    LayerProjY #(.RP(`RPROJ_L3)) L3_proj(
        .clk(clk),                // processing clock
        .x2(x2_step8),
        .a2m(a2m_pipe),
        .t(t),
        .phi0(phi0_step14),
        .z0(z0_step14),
        .phiL(phiL_fin_L3),
        .zL(zL_fin_L3),
        .valid_proj(vp3),
        .valid_projPlus(vp3p),
        .valid_projMinus(vp3m)
    );

//       Assign ProjL3 = {vp3m,vp3p,10'h3ff,phiL_fin_L3[16:3],zL_fin_L3,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
    always @(posedge clk) begin
        //ProjL3 <= {vp3m,vp3p,TC_index, index, phiL_fin_L3[16:3],zL_fin_L3,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
        ProjL3 <= {vp3m,vp3p,TC_index, index, phiL_fin_L3[16:3],zL_fin_L3,der_phiL_fin[5],der_phiL_fin,der_zL_fin};
        
        if(valid_trackpar_pipe == 1'b1 && vp3==1'b1 && zL_fin_L3[11:10]==2'b00) begin
            valid_projout_L3D3 <= pass_cut_dly;//1'b1;
            valid_projout_L3D4 <= 1'b0;
            valid_projoutToPlus_L3 <= 1'b0;
            valid_projoutToMinus_L3 <= 1'b0;
            end
        else if(valid_trackpar_pipe == 1'b1 && vp3==1'b1 && zL_fin_L3[11:10]==2'b01) begin
                valid_projout_L3D3 <= 1'b0;
                valid_projout_L3D4 <= pass_cut_dly;//1'b1;
                valid_projoutToPlus_L3 <= 1'b0;
                valid_projoutToMinus_L3 <= 1'b0;
                end
        else if (valid_trackpar_pipe==1'b1 && vp3p==1'b1)begin
            valid_projout_L3D3 <= 1'b0;
            valid_projout_L3D4 <= 1'b0;
            valid_projoutToPlus_L3 <= pass_cut_dly;//1'b1;
            valid_projoutToMinus_L3 <= 1'b0;
            end
        else if (valid_trackpar_pipe==1'b1 && vp3m==1'b1)begin
            valid_projout_L3D3 <= 1'b0;
            valid_projout_L3D4 <= 1'b0;
            valid_projoutToPlus_L3 <= 1'b0;
            valid_projoutToMinus_L3 <= pass_cut_dly;//1'b1;
            end
        else begin
             valid_projout_L3D3 <= 1'b0;
             valid_projout_L3D4 <= 1'b0;
             valid_projoutToPlus_L3 <= 1'b0;
             valid_projoutToMinus_L3 <= 1'b0;
             end
    end
    
        assign projout_L3D3 =   ProjL3;
        assign projout_L3D4 =   ProjL3;
        assign projoutToPlus_L3 =   ProjL3;
        assign projoutToMinus_L3 =   ProjL3;

    wire signed [18:0] phiL_fin_L4;
    wire signed [11:0] zL_fin_L4;
    reg [52:0] ProjL4;
    wire vp4;
    wire vp4p;
    wire vp4m;

    LayerProjY #(.RP(`RPROJ_L4)) L4_proj(
        .clk(clk),                // processing clock
        .x2(x2_step8),
        .a2m(a2m_pipe),
        .t(t),
        .phi0(phi0_step14),
        .z0(z0_step14),
        .phiL(phiL_fin_L4),
        .zL(zL_fin_L4),
        .valid_proj(vp4),
        .valid_projPlus(vp4p),
        .valid_projMinus(vp4m)
    );
    always @(posedge clk) begin
        //ProjL4 <= {vp4m,vp4p,TC_index, index, phiL_fin_L4[16:0],zL_fin_L4[11:4],der_phiL_fin[5],der_phiL_fin[5],der_phiL_fin,der_zL_fin};
        ProjL4 <= {vp4m,vp4p,TC_index, index, phiL_fin_L4[16:0],zL_fin_L4[11:4],der_phiL_fin[5],der_phiL_fin[5],der_phiL_fin,der_zL_fin[6:0]};

        
        if(valid_trackpar_pipe == 1'b1 && vp4==1'b1 && zL_fin_L4[11:10]==2'b00) begin
            valid_projout_L4D3 <= pass_cut_dly;//1'b1;
            valid_projout_L4D4 <= 1'b0;
            valid_projoutToPlus_L4 <= 1'b0;
            valid_projoutToMinus_L4 <= 1'b0;
            end
        else if(valid_trackpar_pipe == 1'b1 && vp4==1'b1 && zL_fin_L4[11:10]==2'b01) begin
                valid_projout_L4D3 <= 1'b0;
                valid_projout_L4D4 <= pass_cut_dly;//1'b1;
                valid_projoutToPlus_L4 <= 1'b0;
                valid_projoutToMinus_L4 <= 1'b0;
                end
        else if (valid_trackpar_pipe==1'b1 && vp4p==1'b1)begin
            valid_projout_L4D3 <= 1'b0;
            valid_projout_L4D4 <= 1'b0;
            valid_projoutToPlus_L4 <= pass_cut_dly;//1'b1;
            valid_projoutToMinus_L4 <= 1'b0;
            end
        else if (valid_trackpar_pipe==1'b1 && vp4m==1'b1)begin
            valid_projout_L4D3 <= 1'b0;
            valid_projout_L4D4 <= 1'b0;
            valid_projoutToPlus_L4 <= 1'b0;
            valid_projoutToMinus_L4 <= pass_cut_dly;//1'b1;
            end
        else begin
             valid_projout_L4D3 <= 1'b0;
             valid_projout_L4D4 <= 1'b0;
             valid_projoutToPlus_L4 <= 1'b0;
             valid_projoutToMinus_L4 <= 1'b0;
             end
    end
    
    assign projout_L4D3 =   ProjL4;
    assign projout_L4D4 =   ProjL4;
    assign projoutToPlus_L4 =   ProjL4;
    assign projoutToMinus_L4 =   ProjL4;
    
    
//    wire signed [18:0] phiL_fin_L5;
//    wire signed [11:0] zL_fin_L5;

//    LayerProjY #(.RP(14'sd3772)) L5_proj(
//        .clk(clk),                // processing clock
//        .x2(x2_step8),
//        .a2m(a2m_pipe),
//        .t(t),
//        .phi0(phi0_step14),
//        .z0(z0_step14),
//        .phiL(phiL_fin_L5),
//        .zL(zL_fin_L5),
//        .valid_proj(),
//        .valid_projPlus(),
//        .valid_projMinus()
//    );

    wire signed [18:0] phiL_fin_L5;
    wire signed [11:0] zL_fin_L5;
    reg [52:0] ProjL5;
    wire vp5;
    wire vp5p;
    wire vp5m;

    LayerProjY #(.RP(`RPROJ_L5)) L5_proj(
        .clk(clk),                // processing clock
        .x2(x2_step8),
        .a2m(a2m_pipe),
        .t(t),
        .phi0(phi0_step14),
        .z0(z0_step14),
        .phiL(phiL_fin_L5),
        .zL(zL_fin_L5),
        .valid_proj(vp5),
        .valid_projPlus(vp5p),
        .valid_projMinus(vp5m)
    );

    always @(posedge clk) begin
        //ProjL5 <= {vp5m,vp5p, TC_index, index, phiL_fin_L5[16:0],zL_fin_L5[11:4],der_phiL_fin[5],der_phiL_fin[5],der_phiL_fin,der_zL_fin};
        ProjL5 <= {vp5m,vp5p, TC_index, index, phiL_fin_L5[16:0],zL_fin_L5[11:4],der_phiL_fin[5],der_phiL_fin[5],der_phiL_fin,der_zL_fin[6:0]};
        
        if(valid_trackpar_pipe == 1'b1 && vp5==1'b1 && zL_fin_L5[11:10]==2'b00) begin
            valid_projout_L5D3 <= pass_cut_dly;//1'b1;
            valid_projout_L5D4 <= 1'b0;
            valid_projoutToPlus_L5 <= 1'b0;
            valid_projoutToMinus_L5 <= 1'b0;
            end
        else if(valid_trackpar_pipe == 1'b1 && vp5==1'b1 && zL_fin_L5[11:10]==2'b01) begin
                valid_projout_L5D3 <= 1'b0;
                valid_projout_L5D4 <= pass_cut_dly;//1'b1;
                valid_projoutToPlus_L5 <= 1'b0;
                valid_projoutToMinus_L5 <= 1'b0;
                end
        else if (valid_trackpar_pipe==1'b1 && vp5p==1'b1)begin
            valid_projout_L5D3 <= 1'b0;
            valid_projout_L5D4 <= 1'b0;
            valid_projoutToPlus_L5 <= pass_cut_dly;//1'b1;
            valid_projoutToMinus_L5 <= 1'b0;
            end
        else if (valid_trackpar_pipe==1'b1 && vp5m==1'b1)begin
            valid_projout_L5D3 <= 1'b0;
            valid_projout_L5D4 <= 1'b0;
            valid_projoutToPlus_L5 <= 1'b0;
            valid_projoutToMinus_L5 <= pass_cut_dly;//1'b1;
            end
        else begin
             valid_projout_L5D3 <= 1'b0;
             valid_projout_L5D4 <= 1'b0;
             valid_projoutToPlus_L5 <= 1'b0;
             valid_projoutToMinus_L5 <= 1'b0;
             end
    end
    
    assign projout_L5D3 =   ProjL5;
    assign projout_L5D4 =   ProjL5;
    assign projoutToPlus_L5 =   ProjL5;
    assign projoutToMinus_L5 =   ProjL5;

    wire signed [18:0] phiL_fin_L6;
    wire signed [11:0] zL_fin_L6;
    reg [52:0] ProjL6;
    wire vp6;
    wire vp6p;
    wire vp6m;

    LayerProjY #(.RP(`RPROJ_L6)) L6_proj(
        .clk(clk),                // processing clock
        .x2(x2_step8),
        .a2m(a2m_pipe),
        .t(t),
        .phi0(phi0_step14),
        .z0(z0_step14),
        .phiL(phiL_fin_L6),
        .zL(zL_fin_L6),
        .valid_proj(vp6),
        .valid_projPlus(vp6p),
        .valid_projMinus(vp6m)
    );

//       Assign ProjL6 = {vp6m,vp6p,10'h3ff,phiL_fin_L6[16:3],zL_fin_L6,der_phiL_fin[5],der_phiL_fin,der_zL_fin[6],der_zL_fin};
    always @(posedge clk) begin
        //ProjL6 <= {vp6m,vp6p, TC_index, index, phiL_fin_L6[16:0],zL_fin_L6[11:4],der_phiL_fin[5],der_phiL_fin[5],der_phiL_fin,der_zL_fin};
        ProjL6 <= {vp6m,vp6p, TC_index, index, phiL_fin_L6[16:0],zL_fin_L6[11:4],der_phiL_fin[5],der_phiL_fin[5],der_phiL_fin,der_zL_fin[6:0]};
         
        if(valid_trackpar_pipe == 1'b1 && vp6==1'b1 && zL_fin_L6[11:10]==2'b00) begin
            valid_projout_L6D3 <= pass_cut_dly;//1'b1;
            valid_projout_L6D4 <= 1'b0;
            valid_projoutToPlus_L6 <= 1'b0;
            valid_projoutToMinus_L6 <= 1'b0;
            end
        else if(valid_trackpar_pipe == 1'b1 && vp6==1'b1 && zL_fin_L6[11:10]==2'b01) begin
                valid_projout_L6D3 <= 1'b0;
                valid_projout_L6D4 <= pass_cut_dly;//1'b1;
                valid_projoutToPlus_L6 <= 1'b0;
                valid_projoutToMinus_L6 <= 1'b0;
                end
        else if (valid_trackpar_pipe==1'b1 && vp6p==1'b1)begin
            valid_projout_L6D3 <= 1'b0;
            valid_projout_L6D4 <= 1'b0;
            valid_projoutToPlus_L6 <= pass_cut_dly;//1'b1;
            valid_projoutToMinus_L6 <= 1'b0;
            end
        else if (valid_trackpar_pipe==1'b1 && vp6m==1'b1)begin
            valid_projout_L6D3 <= 1'b0;
            valid_projout_L6D4 <= 1'b0;
            valid_projoutToPlus_L6 <= 1'b0;
            valid_projoutToMinus_L6 <= pass_cut_dly;//1'b1;
            end
        else begin
             valid_projout_L6D3 <= 1'b0;
             valid_projout_L6D4 <= 1'b0;
             valid_projoutToPlus_L6 <= 1'b0;
             valid_projoutToMinus_L6 <= 1'b0;
             end
    end
    
    assign projout_L6D3 =   ProjL6;
    assign projout_L6D4 =   ProjL6;
    assign projoutToPlus_L6 =   ProjL6;
    assign projoutToMinus_L6 =   ProjL6;

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

endmodule
