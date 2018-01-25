`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:16:22 PM
// Design Name: 
// Module Name: MatchDiskCalculator
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


module MatchDiskCalculator(
    input clk,
    input reset,
    input en_proc,
        
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in_match1in,
    input [5:0] number_in_match2in,
    input [5:0] number_in_match3in,
    input [5:0] number_in_match4in,
    input [5:0] number_in_match5in,
    input [5:0] number_in_match6in,
    input [5:0] number_in_match7in,
    input [5:0] number_in_match8in,
    output [8:0] read_add_match1in,
    output [8:0] read_add_match2in,
    output [8:0] read_add_match3in,
    output [8:0] read_add_match4in,
    output [8:0] read_add_match5in,
    output [8:0] read_add_match6in,
    output [8:0] read_add_match7in,
    output [8:0] read_add_match8in,
    input [11:0] match1in,
    input [11:0] match2in,
    input [11:0] match3in,
    input [11:0] match4in,
    input [11:0] match5in,
    input [11:0] match6in,
    input [11:0] match7in,
    input [11:0] match8in,
    
    output reg [10:0] read_add_allstubin,
    output reg [9:0] read_add_allprojin,
    input [35:0] allstubin,
    input [55:0] allprojin,
    
    output reg [39:0] matchout1,
    output [39:0] matchout2,
    output [39:0] matchout3,
    output [39:0] matchout4,
    output reg valid_match,
    output reg [39:0] matchoutminus,
    output reg valid_matchminus,
    output reg [39:0] matchoutplus,
    output reg valid_matchplus
    );
    
    ///////////////////////////////////////////////
    reg [4:0] BX_pipe;
    reg first_clk_pipe;
    reg first_clk_dly;
    wire first_clk_dly2;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
    initial begin
       BX_pipe = 5'b11111;
    end
    
    always @(posedge clk) begin
        if (rst_pipe)
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

        first_clk_dly <= first_clk_pipe;
    end
    ///////////////////////////////////////////////////
    parameter INNER = 1'b1;
    parameter PHI_BITS 	= 14;
    parameter Z_BITS    = 12;
    parameter R_BITS    = 7;
    parameter PHID_BITS = 7;
    parameter ZD_BITS   = 8;
    parameter k1ABC     = 2;
    parameter k2ABC     = 4;
    parameter [11:0] phicut = 12'd868;
    parameter [5:0] zcut = 6'd9;
    parameter [4:0] zfactor = 5'd0;
    
    initial begin
        read_add_allstubin = {11'hfff};
        read_add_allprojin = {10'hfff};
    end
    
    wire [11:0] matchpair;
    wire [5:0] pre_read_add1;
    wire [5:0] pre_read_add2;
    wire [5:0] pre_read_add3;
    wire [5:0] pre_read_add4;
    wire [5:0] pre_read_add5;
    wire [5:0] pre_read_add6;
    wire [5:0] pre_read_add7;
    wire [5:0] pre_read_add8;
    
    assign read_add_match1in = {BX_pipe[2:0],pre_read_add1};
    assign read_add_match2in = {BX_pipe[2:0],pre_read_add2};
    assign read_add_match3in = {BX_pipe[2:0],pre_read_add3};
    assign read_add_match4in = {BX_pipe[2:0],pre_read_add4};
    assign read_add_match5in = {BX_pipe[2:0],pre_read_add5};
    assign read_add_match6in = {BX_pipe[2:0],pre_read_add6};
    assign read_add_match7in = {BX_pipe[2:0],pre_read_add7};
    assign read_add_match8in = {BX_pipe[2:0],pre_read_add8};
           
    merge_readout_top #(12, 11, 6)
    StubPairs(
        .clk(clk),
        .rst(first_clk_pipe),
        //.new_event(first_clk_dly),
        
        .number_in1(number_in_match1in),
        .addr_out1(pre_read_add1),
        .data_in1(match1in),
        .number_in2(number_in_match2in),
        .addr_out2(pre_read_add2),
        .data_in2(match2in),
        .number_in3(number_in_match3in),
        .addr_out3(pre_read_add3),
        .data_in3(match3in),
        .number_in4(number_in_match4in),
        .addr_out4(pre_read_add4),
        .data_in4(match4in),
        .number_in5(number_in_match5in),
        .addr_out5(pre_read_add5),
        .data_in5(match5in),
        .number_in6(number_in_match6in),
        .addr_out6(pre_read_add6),
        .data_in6(match6in),
        .number_in7(number_in_match7in),
        .addr_out7(pre_read_add7),
        .data_in7(match7in),
        .number_in8(number_in_match8in),
        .addr_out8(pre_read_add8),
        .data_in8(match8in),
        
        .data_out(matchpair),
        .valid_out(pre_valid_match)    
    );
    

    pipe_delay #(.STAGES(16), .WIDTH(2))
           done_delay(.pipe_in(), .pipe_out(), .clk(clk),
           .val_in(start), .val_out(done));

    assign first_clk_dly2 = done[0];
    
    always @(posedge clk) begin
        if(matchpair >= 0) begin   // FIXME: valid_match?
            read_add_allprojin <= {BX_pipe[3:0],matchpair[11:6]};
            read_add_allstubin <= {BX_pipe,matchpair[5:0]};
        end
    end

    reg [16:0] behold; // valid tracklet data hold
    reg hold_valid;
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_match;
        behold[16:1] <= behold[15:0];  
        hold_valid <= behold[7];
      
    end

    //////////////////////////////////////////////////////////////////
    
    reg [PHI_BITS-1:0] iphi_proj_0;
    reg [PHI_BITS-1:0] iphi_stub_0;
    reg signed [Z_BITS-1:0] iz_stub_0;
    reg signed [Z_BITS-1:0] iz_proj_0;
    reg signed [PHID_BITS-1:0] iphi_der_0;
    reg signed [ZD_BITS-1:0] iz_der_0;
    reg signed [R_BITS-1:0] ir_stub_0;
    reg [5:0] pre_stub_index;
    reg [5:0] stub_index_0;
    reg [5:0] stub_index_0_pipe;
    
    // Step 0: Get the positions
    always @(posedge clk) begin
        if(INNER) begin
            iphi_stub_0     <= allstubin[13:0];
            iphi_proj_0     <= allprojin[40:27];
            iz_stub_0       <= allstubin[25:14];
            iz_proj_0       <= allprojin[26:15];
            iphi_der_0      <= allprojin[14:8];
            iz_der_0        <= allprojin[7:0];
            ir_stub_0       <= allstubin[32:26];
        end
        else begin
            iphi_stub_0     <= allstubin[16:0];
            iphi_proj_0     <= allprojin[39:23];
            iz_stub_0       <= allstubin[24:17];
            iz_proj_0       <= allprojin[22:15];
            iphi_der_0      <= allprojin[14:7];
            iz_der_0        <= allprojin[6:0];
            ir_stub_0       <= allstubin[32:25];
        end
    end
    
    wire [1:0] hold_fromWhere;
    wire validFromWhere;
    
    //pipe_delay #(.STAGES(9), .WIDTH(2))
    pipe_delay #(.STAGES(5), .WIDTH(2))//MZIENTEK
        fromWhere_pipe(.pipe_in(en_proc), .pipe_out(validFromWhere), .clk(clk),
        .val_in(allprojin[55:54]), .val_out(hold_fromWhere));
        
    always @(posedge clk) begin
        pre_stub_index <= read_add_allstubin;
        stub_index_0_pipe <= pre_stub_index;
        stub_index_0 <= stub_index_0_pipe;
    end
    
    // Step 1: Calculate the true radial position
    // Carry Over:
    (*KEEP = "true"*) reg [PHI_BITS-1:0] iphi_stub_1;
    (*KEEP = "true"*) reg signed [Z_BITS-1:0] iz_stub_1;
    (*KEEP = "true"*) reg signed [PHID_BITS-1:0] iphi_der_1;
    (*KEEP = "true"*) reg signed [ZD_BITS-1:0] iz_der_1;    
    (*KEEP = "true"*) reg signed [PHI_BITS:0] iphi_proj_1;
    (*KEEP = "true"*) reg signed [Z_BITS-1:0] iz_proj_1;
    
    (*KEEP = "true"*) reg [PHI_BITS-1:0] iphi_stub_1_pipe;
    (*KEEP = "true"*) reg signed [Z_BITS-1:0] iz_stub_1_pipe;
    (*KEEP = "true"*) reg signed [PHID_BITS-1:0] iphi_der_1_pipe;
    (*KEEP = "true"*) reg signed [ZD_BITS-1:0] iz_der_1_pipe;    
    (*KEEP = "true"*) reg signed [PHI_BITS:0] iphi_proj_1_pipe;
    (*KEEP = "true"*) reg signed [Z_BITS-1:0] iz_proj_1_pipe;

    // Declare:
    reg signed [15:0] full_ir_corr_1;
    reg signed [15:0] full_ir_corr_pipe1;
    reg signed [15:0] full_iz_corr_1;
    reg signed [15:0] full_iz_corr_pipe1;
    wire signed [11:0] ir_corr_1;
    wire signed [10:0] iz_corr_1;
    reg [5:0] stub_index_1;
    reg [9:0] proj_index_1;
    reg [5:0] stub_index_1_pipe;
    reg [9:0] proj_index_1_pipe;
    
    always @(posedge clk) begin
        iphi_stub_1_pipe    <= iphi_stub_0;
        iz_stub_1_pipe    <= iz_stub_0;
        iphi_der_1_pipe    <= iphi_der_0;
        iz_der_1_pipe        <= iz_der_0;
        iphi_proj_1_pipe    <= {1'b0,iphi_proj_0};
        iz_proj_1_pipe    <= iz_proj_0;
        
        iphi_stub_1    <= iphi_stub_1_pipe;
        iz_stub_1    <= iz_stub_1_pipe;
        iphi_der_1    <= iphi_der_1_pipe;
        iz_der_1        <= iz_der_1_pipe;
        iphi_proj_1    <= iphi_proj_1_pipe;
        iz_proj_1    <= iz_proj_1_pipe;
        
        full_ir_corr_1    <= ir_stub_0 * iphi_der_0;
        full_ir_corr_pipe1 <= full_ir_corr_1;
        full_iz_corr_1    <= ir_stub_0 * iz_der_0;
        full_iz_corr_pipe1 <= full_iz_corr_1;
        stub_index_1_pipe <= stub_index_0;
        if(INNER)
            proj_index_1_pipe <= allprojin[50:41];
        else
            proj_index_1_pipe <= allprojin[49:40];
        stub_index_1 <= stub_index_1_pipe;
        proj_index_1 <= proj_index_1_pipe;
    end
    
    assign ir_corr_1 = full_ir_corr_pipe1 >>> k1ABC;
    assign iz_corr_1 = full_iz_corr_pipe1 >>> k2ABC;
    
    // Step 2: Calculate the "better" positions
    // Carry Over:
    reg signed [PHI_BITS:0] iphi_stub_2;
    reg signed [Z_BITS-1:0] iz_stub_2;
    // Declare:
    reg signed [17:0] iphi_2;
    reg signed [12:0] iz_2;
    //reg signed [14:0] pre_iphi_2;
    //reg signed [12:0] pre_iz_2;
    reg [5:0] stub_index_2;
    reg [9:0] proj_index_2;
    
    always @(posedge clk) begin
        iphi_stub_2    <= iphi_stub_1;
        iz_stub_2    <= iz_stub_1;
        iphi_2         <= iphi_proj_1 + ir_corr_1;
        iz_2             <= iz_proj_1 + iz_corr_1;
        stub_index_2 <= stub_index_1;
        proj_index_2 <= proj_index_1;
    end
    
    //assign iphi_2     = iphi_proj_1 + (pre_iphi_2 >>> 1'b1);
    //assign iz_2     = iz_proj_1 + (pre_iz_2 >>> 2'h3);

    // Step 3: Calculate Residuals
    // Declare
    reg signed [9:0] full_iphi_res_3;
    reg signed [8:0] iz_res_3;
    reg signed [15:0] iphi_res_3;
    reg [5:0] stub_index_3;
    reg [9:0] proj_index_3;
    reg [5:0] stub_index_4;
    reg [9:0] proj_index_4;
    
    always @(posedge clk) begin
        if(INNER)
            iphi_res_3     <= (iphi_stub_2 <<< 3'd3) - (iphi_2 <<< 3'd3);
        else
            iphi_res_3     <= iphi_stub_2 - iphi_2;
        iz_res_3                 <= iz_stub_2 - iz_2;
        stub_index_3 <= stub_index_2;
        proj_index_3 <= proj_index_2;
        stub_index_4 <= stub_index_3;
        proj_index_4 <= proj_index_3;
    end
    
    wire [45:0] pre_matchout1;
    reg [45:0] min_matchout1;
    
    assign pre_matchout1[8:0]     = iz_res_3;
    assign pre_matchout1[24:9]    = iphi_res_3;
    assign pre_matchout1[33:25]   = {3'b000,stub_index_4}; // AllStub index has to be added before Duplicate Removal D3D4
    assign pre_matchout1[43:34]   = proj_index_4; // Added TC index
    assign pre_matchout1[45:44]   = hold_fromWhere;// keeps track of FromPlus/FromMinus sector

    wire [8:0] abs_iz;
    wire[15:0] abs_iphi;
    wire [15:0] abs_min_iphi;
    reg [15:0] min_iphi;

    assign abs_iz = (iz_res_3[8] == 1'b1) ? -iz_res_3 : iz_res_3;
    assign abs_iphi = (iphi_res_3[15] == 1'b1) ? -iphi_res_3 : iphi_res_3;
    assign abs_min_iphi = (min_iphi[15] == 1'b1) ? -min_iphi : min_iphi;
    //assign min_iphi = (proj_index_5 != proj_index_4) ? 16'h7fff : min_matchout1[24:9];

    always @(posedge clk) begin
        if(first_clk_dly2) // Reset the value of min_matchout right before the first calculation goes through
            min_matchout1 <= 46'h00fffeffffff;
        if(!hold_valid) // Only consider valid data from the Match Engines
            min_matchout1 <= 46'h00fffeffffff;
        else begin
            if(abs_iphi < abs_min_iphi & proj_index_4[5:0] != 6'h3f & (abs_iz<<zfactor) < zcut) begin
                min_matchout1 <= pre_matchout1;
            end
            else begin
                min_matchout1 <= min_matchout1;
            end
        end
        if(proj_index_4[5:0] != proj_index_3[5:0] | first_clk_dly2) // Reset minphi when a new projection or a new event comes
            min_iphi <= phicut;
        else begin
            if(abs_iphi < abs_min_iphi & (abs_iz<<zfactor) < zcut) // If calculated phi is better, then update
                min_iphi <= iphi_res_3;
            else
                min_iphi <= min_iphi;
        end             
    end    
  
    wire valid_match_pre;
    
    best_match best_mc(
        .clk(clk),
        .reset(first_clk_dly2),
        .pre_valid(hold_valid),
        .new_tracklet(min_matchout1[39:34] != matchout1_pre[35:30]),
        .valid(valid_match_pre)
    );
    

    reg valid_matchorig_pre;
    reg valid_matchplus_pre;
    reg valid_matchminus_pre;
    reg [1:0] fromWhereBits;
    reg [41:0] matchout1_pre;
    reg [39:0] matchout1_pre2;
    reg valid_match_pre_dly;
    
    always @(posedge clk) begin
            matchout1_pre <= {min_matchout1[43:25],min_matchout1[20:0]}; // Remove extra bits of phi residual;
            matchout1     <= matchout1_pre;
            //valid_match_pre_dly <= valid_match_pre;
            //matchout1_pre <= min_matchout1;
            //matchout1 <= matchout1_pre[35:0];
            fromWhereBits <= min_matchout1[45:44];
            if (fromWhereBits==2'b11) begin
                valid_matchorig_pre <= 1'b1;
                valid_matchplus_pre <= 1'b0;
                valid_matchminus_pre <= 1'b0;
            end
            else if (fromWhereBits==2'b01) begin
                valid_matchorig_pre <= 1'b0;
                valid_matchplus_pre <= 1'b1;
                valid_matchminus_pre <= 1'b0;
            end
            else if (fromWhereBits==2'b10) begin
                valid_matchorig_pre <= 1'b0;
                valid_matchplus_pre <= 1'b0;
                valid_matchminus_pre <= 1'b1;
            end
            else begin
                valid_matchorig_pre <= 1'b0;
                valid_matchplus_pre <= 1'b0;
                valid_matchminus_pre <= 1'b0;
            end     
    
    
        matchoutminus <= matchout1_pre;
        matchoutplus <= matchout1_pre;
        valid_match <= (valid_match_pre && valid_matchorig_pre);
        valid_matchplus <= (valid_match_pre && valid_matchplus_pre);
        valid_matchminus <= (valid_match_pre && valid_matchminus_pre);
    
                              
    //        else if (fromWhereBits==2'b01) valid_matchplus_pre <= 1'b1;
    //        else if (fromWhereBits==2'b10) valid_matchminus_pre <= 1'b1;
    //        else begin
    //            valid_matchorig_pre <= 1'b0;
    //            valid_matchplus_pre <= 1'b0;
    //            valid_matchminus_pre <= 1'b0;
    //        end
    
            
    //        matchout1 <= min_matchout1; //Jorge
    ////        if(min_matchout1 != matchout1 & matchout1[35:30] != 6'h3f & min_matchout1[35:30] != matchout1[35:30] & hold_valid)
    ////            valid_match <= 1'b1;
    ////       else
    ////            valid_match <= 1'b0; 
    end
    
    

    /////////////////////////////////////////////////////////
    
    
    
    
endmodule
