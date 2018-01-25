`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:16:22 PM
// Design Name: 
// Module Name: MatchCombiner
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


module DiskMatchCalculator(
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
    output [`MEM_SIZE+2:0] read_add_match1in,
    output [`MEM_SIZE+2:0] read_add_match2in,
    output [`MEM_SIZE+2:0] read_add_match3in,
    output [`MEM_SIZE+2:0] read_add_match4in,
    output [`MEM_SIZE+2:0] read_add_match5in,
    output [`MEM_SIZE+2:0] read_add_match6in,
    output [`MEM_SIZE+2:0] read_add_match7in,
    output [`MEM_SIZE+2:0] read_add_match8in,
    input [11:0] match1in,
    input [11:0] match2in,
    input [11:0] match3in,
    input [11:0] match4in,
    input [11:0] match5in,
    input [11:0] match6in,
    input [11:0] match7in,
    input [11:0] match8in,
    
    output reg [`MEM_SIZE+4:0] read_add_allstubin,
    output reg [`MEM_SIZE+3:0] read_add_allprojin,
    input [35:0] allstubin,
    input [55:0] allprojin,
    
    output reg [39:0] matchout1,
    output [39:0] matchout2,
    output [39:0] matchout3,
    output [39:0] matchout4,
    output reg [39:0] matchoutminus1,
    output reg [39:0] matchoutplus1,
    
    output wire valid_matchout1,
    output wire valid_matchout2,
    output wire valid_matchout3, 
    output wire valid_matchout4,
    output wire valid_matchoutminus1,
    output wire valid_matchoutplus1
    );
    
    ///////////////////////////////////////////////
    reg [5:0] BX_pipe;
    reg [5:0] BX_pipe2;
    reg first_clk_pipe;
    reg first_clk_dly;
    reg first_clk_dly2;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
    initial begin
       BX_pipe = 5'b11111;
    end
    
    always @(posedge clk) begin
        BX_pipe2 <= BX_pipe;
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
  
    parameter DTC_INDEX = 3'b010;
    parameter INNER     = 1'b1;
    parameter PHICUT        = 467281; // phi cut for PS modules
    //parameter phicut_outer  = 700921; // phi cut for 2S modules
    parameter RCUT          = 32;     //   r cut for PS modules
    //parameter rcut_outer    = 128;    //   r cut for 2S modules
    parameter F1F2SEED	= 1'b1;
    
    initial begin
        read_add_allstubin = {`MEM_SIZE+5{1'b1}};
        read_add_allprojin = {`MEM_SIZE+4{1'b1}};
    end
    
    wire [11:0] matchpair;
    wire [`MEM_SIZE-1:0] pre_read_add1;
    wire [`MEM_SIZE-1:0] pre_read_add2;
    wire [`MEM_SIZE-1:0] pre_read_add3;
    wire [`MEM_SIZE-1:0] pre_read_add4;
    wire [`MEM_SIZE-1:0] pre_read_add5;
    wire [`MEM_SIZE-1:0] pre_read_add6;
    wire [`MEM_SIZE-1:0] pre_read_add7;
    wire [`MEM_SIZE-1:0] pre_read_add8;
    reg [7:0] ir_stub0asindex;
    
    
    assign read_add_match1in = {BX_pipe2[2:0],pre_read_add1[`MEM_SIZE-1:0]};
    assign read_add_match2in = {BX_pipe2[2:0],pre_read_add2[`MEM_SIZE-1:0]};
    assign read_add_match3in = {BX_pipe2[2:0],pre_read_add3[`MEM_SIZE-1:0]};
    assign read_add_match4in = {BX_pipe2[2:0],pre_read_add4[`MEM_SIZE-1:0]};
    assign read_add_match5in = {BX_pipe2[2:0],pre_read_add5[`MEM_SIZE-1:0]};
    assign read_add_match6in = {BX_pipe2[2:0],pre_read_add6[`MEM_SIZE-1:0]};
    assign read_add_match7in = {BX_pipe2[2:0],pre_read_add7[`MEM_SIZE-1:0]};
    assign read_add_match8in = {BX_pipe2[2:0],pre_read_add8[`MEM_SIZE-1:0]};
           
    merge_readout_top #(12, 11, 6)
    CandidateMatches(
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
  

    pipe_delay #(.STAGES(17), .WIDTH(2))
           done_delay(.pipe_in(), .pipe_out(), .clk(clk),
           .val_in(start), .val_out(done));
           
   wire [4:0] BX_dly;
   pipe_delay #(.STAGES(5), .WIDTH(5))
        BX_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(BX_pipe2), .val_out(BX_dly));
    
    always @(posedge clk) begin
        first_clk_dly2 <= done[0];
        if(matchpair >= 0) begin   // FIXME: valid_match?
            read_add_allprojin <= {BX_dly[3:0],matchpair[6+(`MEM_SIZE-1):6]};
            read_add_allstubin <= {BX_dly,matchpair[`MEM_SIZE-1:0]};
        end
    end

    reg [16:0] behold; // valid tracklet data hold
    reg hold_valid;
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_match;
        behold[16:1] <= behold[15:0];  
        hold_valid <= behold[9];
      
    end

    //////////////////////////////////////////////////////////////////

    //Input Variables

    reg [5:0] stub_index_0;
    reg [5:0] proj_index_0;
    reg [5:0] stub_index_0_pipe;
    reg [5:0] proj_index_0_pipe;
    
    reg  signed [14:0] ir_proj_0; 
    reg  signed [16:0] iphi_proj_0;
    
    reg  signed  [7:0]  ir_der_0; 
    reg  signed [5:0]  iphi_der_0; 
    
    reg  signed [12:0] ir_stub_0;    
    reg [13:0] iphi_stub_0;
    reg signed [6:0] iz_stub_0;
      
      
    reg  signed [5:0]   ia_stub_0;
    wire signed [5:0]   ia_stub_5; 
    reg  signed [19:0]   ia_stub_cor;  
    wire signed [19:0]   ia_stub_3;   


    //Get the positions and derivatives
    always @(posedge clk) begin
    if(INNER) begin
        iphi_stub_0     <= allstubin[13:0];
        iz_stub_0       <= allstubin[20:14];
        ir_stub_0       <= allstubin[32:21];
        ia_stub_0       <= 6'b000000;
        
        iphi_proj_0     <= allprojin[39:26];
        ir_proj_0       <= allprojin[25:14];
        iphi_der_0      <= allprojin[13:8];
        ir_der_0        <= allprojin[7:0];
    end
    else begin
        case(allstubin[24:21])
            4'b0000: ir_stub_0 <= 13'h870;
            4'b0001: ir_stub_0 <= 13'h946;
            4'b0010: ir_stub_0 <= 13'h99a;
            4'b0011: ir_stub_0 <= 13'ha70;
            4'b0100: ir_stub_0 <= 13'hb5b;
            4'b0101: ir_stub_0 <= 13'hc31;
            4'b1000: ir_stub_0 <= 13'hc65;
            4'b1001: ir_stub_0 <= 13'hd3b;
            4'b1010: ir_stub_0 <= 13'he2a;
            4'b1011: ir_stub_0 <= 13'hf00;
            4'b1100: ir_stub_0 <= 13'hf15;
            4'b1101: ir_stub_0 <= 13'hfea;
            default: ir_stub_0 <= 0;
        endcase     
    
            if (allstubin[30:0] == 31'b0) ir_stub_0 <= 13'b0;
        
            iphi_stub_0     <= allstubin[13:0];
            iz_stub_0       <= allstubin[20:14];
            ia_stub_0       <= allstubin[30:25];
             
            iphi_proj_0     <= allprojin[39:26];
            ir_proj_0       <= allprojin[25:14];
            iphi_der_0      <= allprojin[13:8];
            ir_der_0        <= allprojin[7:0];
        end   
    end
    
    wire [1:0] hold_fromWhere;
    wire validFromWhere;
    
    //pipe_delay #(.STAGES(9), .WIDTH(2))
    pipe_delay #(.STAGES(5), .WIDTH(2))//MZIENTEK
        fromWhere_pipe(.pipe_in(en_proc), .pipe_out(validFromWhere), .clk(clk),
        .val_in(allprojin[55:54]), .val_out(hold_fromWhere));
          
    
     reg signed [19:0] phi_der_rho_1; 
                         
     reg  signed [16:0] r_der_rho_1;
     wire signed [16:0] r_der_rho_3;    
     wire [5:0] stub_index_5;                  
                         
     reg signed [20:0]phi_res_1;
     reg signed [20:0] phi_res_2; 
     wire signed [20:0] phi_res_4;
                         
     reg signed [16:0] phi_a_rho_3; 
     reg signed [14:0] r_res_1;           
                         
     reg signed [12:0] r_abs_1;  
     wire signed [12:0] r_abs_5;
             
     reg signed [20:0] r_stub_a_4;   
     reg  signed [17:0] resD_r_2;
     reg  signed [17:0] resD_r_halved_2;
           
     wire signed  [17:0] resD_r_4; 
     wire signed  [17:0] resD_r_5; 

     reg signed [21:0] resD_phi_4;
     reg signed [21:0] resD_phi_5;
     
     reg signed [19:0] alpha_cor_3;
                
     reg [9:0] proj_index_1;
     wire [9:0] proj_index_5;
     reg [9:0] proj_index_6;
     reg [9:0] proj_index_7;
      
     reg signed [11:0] r_stub_a_6; 

     //Pipe delays for input variables
     pipe_delay #(.STAGES(1),.WIDTH(21)) phi_res_pipe(.clk(clk),.val_in(phi_res_2),.val_out(phi_res_4));
     pipe_delay #(.STAGES(1),.WIDTH(20)) a_stub_pipe(.clk(clk),.val_in(ia_stub_cor),.val_out(ia_stub_3));          
     pipe_delay #(.STAGES(3),.WIDTH(13)) abs_r_pipe(.clk(clk),.val_in(r_abs_1),.val_out(r_abs_5));
     pipe_delay #(.STAGES(4),.WIDTH(6)) a_stub_pipeforout(.clk(clk),.val_in(ia_stub_0),.val_out(ia_stub_5));  
            
     //Pipe delays for calculation res.            
     pipe_delay #(.STAGES(3),.WIDTH(18)) resD_r_pipe(.clk(clk),.val_in(resD_r_2),.val_out(resD_r_5));
     pipe_delay #(.STAGES(2),.WIDTH(18)) resD_r_outpipe(.clk(clk),.val_in(resD_r_2),.val_out(resD_r_4));     
     pipe_delay #(.STAGES(1),.WIDTH(40)) matchout_pipe(.clk(clk),.val_in(matchout1),.val_out(matchout_1));
               
     //INDICES          
     always @(posedge clk)begin 
        stub_index_0 <= {1'b0,read_add_allstubin[`MEM_SIZE-1:0]};
        //if(INNER)
        //    proj_index_1 <= allprojin[46:41];
        //else
        proj_index_1 <= allprojin[49:40];
        proj_index_6 <= proj_index_5;
        proj_index_7 <= proj_index_6;
    end        
       
    pipe_delay  #(.STAGES(7),.WIDTH(6)) stub_index_pipe(.clk(clk),.val_in(stub_index_0),.val_out(stub_index_5));
    pipe_delay  #(.STAGES(4),.WIDTH(10)) proj_index_pipe(.clk(clk),.val_in(proj_index_1),.val_out(proj_index_5));
       
    reg signed [10:0] par1 = 11'd57;
    reg signed [21:0] resD_phi_5_pipe;      

    always @(posedge clk) begin 
        // step 1
        r_res_1        <= ir_stub_0 - ir_proj_0;      
        ia_stub_cor    <= (ia_stub_0*par1);            
        phi_res_1      <= iphi_stub_0 - iphi_proj_0;             
        phi_der_rho_1  <= (iz_stub_0*iphi_der_0)>>>2;  
        r_der_rho_1    <= (iz_stub_0*ir_der_0)>>>5;             
        r_abs_1        <= ir_stub_0 + $signed(13'd512); 
              
        // step 2          
        phi_res_2      <= phi_res_1 - phi_der_rho_1;
        resD_r_2       <= r_res_1 - r_der_rho_1;
            
        // step 3
        alpha_cor_3    <= (ia_stub_3*resD_r_2)>>>10;
             
        // step 4 
        resD_phi_4     <= phi_res_4 + alpha_cor_3; 
        
        // step 5
        resD_phi_5     <= resD_phi_4*r_abs_5;
        resD_phi_5_pipe <= resD_phi_5;
    end
           
    wire [41:0] pre_matchout1;
    reg [41:0] pre_matchout2;
    reg [41:0] pre_matchout3;
    reg [41:0] min_matchout1;
    
    assign pre_matchout1[7:0]   = resD_r_4; 
    assign pre_matchout1[8]     = (~ia_stub_5[5] && ~INNER); 
    assign pre_matchout1[20:9]  = resD_phi_4; 
    assign pre_matchout1[29:21] = {DTC_INDEX,stub_index_5}; 
    assign pre_matchout1[39:30] = proj_index_5; 
    assign pre_matchout1[41:40] = hold_fromWhere; 

    wire [17:0] abs_ir;
    reg [17:0] abs_ir_pipe;
    wire [21:0] abs_iphi;
    wire [21:0] abs_min_iphi;
    reg  [21:0] min_iphi;

    assign abs_ir = (resD_r_5[17] == 1'b1) ? -resD_r_5 : resD_r_5;
    assign abs_iphi = (resD_phi_5_pipe[21] == 1'b1) ? -resD_phi_5_pipe : resD_phi_5_pipe;
    assign abs_min_iphi = (min_iphi[21] == 1'b1) ? -min_iphi : min_iphi;

    // choose which cuts to apply -- different cuts for INNER (PS) and OUTER (2S) parts of the disks
    // parameter rcut_toapply   = (INNER == 1'b1) ? rcut : rcut_outer;
    // parameter phicut_toapply = (INNER == 1'b1) ? phicut : phicut_outer; 

    reg [1:0] fromWhere_Dly1; 
    reg [1:0] fromWhere_Dly2;

    always @(posedge clk) begin
        abs_ir_pipe <= abs_ir;
        pre_matchout2 <= pre_matchout1;
        pre_matchout3 <= pre_matchout2;
        fromWhere_Dly1 <= hold_fromWhere;
        fromWhere_Dly2 <= fromWhere_Dly1;
        if(first_clk_dly2) // Reset the value of min_matchout right before the first calculation goes through
            min_matchout1 <= 46'h0fffeffffff;
        else if(!hold_valid) // Only consider valid data from the Match Engines
            min_matchout1 <= 46'h0fffeffffff;
        else begin
            if(abs_iphi < abs_min_iphi & proj_index_7[5:0] != 6'h3f & abs_ir_pipe < RCUT) begin
                min_matchout1 <= pre_matchout3;
            end
            else begin
                min_matchout1 <= min_matchout1;
            end
        end
        if (proj_index_7[9:0] != proj_index_6[9:0] || fromWhere_Dly2 != fromWhere_Dly1 || first_clk_dly2)
            min_iphi <= PHICUT;
        else begin
            if(abs_iphi < abs_min_iphi & abs_ir_pipe < RCUT) // If calculated phi is better, then update
                min_iphi <= resD_phi_5_pipe;
            else
                min_iphi <= min_iphi;
        end             
    end 
    
    wire valid_match_pre;
    
    best_match best_mc(
        .clk(clk),
        .reset(first_clk_dly2),
        .pre_valid(hold_valid),
        .new_tracklet(min_matchout1[41:30] != matchout1_pre[41:30]),
        .valid(valid_match_pre)
    );
    

    reg valid_matchorig_pre;
    reg valid_matchplus_pre;
    reg valid_matchminus_pre;
    reg [1:0] fromWhereBits;
    reg [41:0] matchout1_pre;
    
    assign matchout2 = matchout1;
    assign matchout3 = matchout1;
    assign matchout4 = matchout1;
    assign matchoutminus2 = matchoutminus1;
    assign matchoutplus2  = matchoutplus1;
    
    // store the TC index from the projection stored in the match
    // do not use allprojin index directly because proj order not preserved in best match logic
    reg [3:0] TCindex;
    always @ (posedge clk) begin
        TCindex <= matchout1[39:36];
    end
    
    wire [3:0] Seeding;
    assign Seeding[0] = (TCindex==4'b0111); // D5D5 (disk seeding)
    assign Seeding[1] = (TCindex==4'b0110); // D5D4 (F1L1 seeding)
    assign Seeding[2] = (TCindex==4'b0010); // D4D4 (L1L2 seeding)
    assign Seeding[3] = (TCindex==4'b0101); // D4D4 (L3L4 seeding)

    reg valid_matchout;
    reg valid_matchoutplus;
    reg valid_matchoutminus;

    // matchout1 is always disk seeding
    assign valid_matchout1       = (valid_matchout && Seeding[0]); // disk seeding (either F1F2 or F3F4)
    assign valid_matchoutplus1   = valid_matchoutplus; 
    assign valid_matchoutminus1  = valid_matchoutminus;
    // valid_matchout4 logic only used for F3F4_F2 (no wires connected for these outputs in other disk MC)
    assign valid_matchout3       = (valid_matchout && Seeding[3]); // barrel seeding (L3L4)
    
    generate
        if (F1F2SEED) begin  // logic works for all but F3F4_F1 
            //assign valid_matchout3       = (valid_matchout && Seeding[1]); // hybrid seeding (F1L1)
            assign valid_matchout2       = (valid_matchout && Seeding[2]); // barrel seeding (L1L2)
	end
        else begin // logic for F3F4_F1
            assign valid_matchout2       = (valid_matchout && Seeding[2]); // barrel seeding (L1L2) 
            //assign valid_matchout3       = (valid_matchout && Seeding[3]); // barrel seeding (L3L4)
        end
    endgenerate 

    always @(posedge clk) begin
        matchout1_pre           <= min_matchout1[41:0]; 
        matchout1               <= matchout1_pre[39:0];
        fromWhereBits           <= min_matchout1[41:40];
        
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
    
        matchoutminus1 <= matchout1_pre[39:0];
        matchoutplus1 <= matchout1_pre[39:0];
        valid_matchout <= (valid_match_pre && valid_matchorig_pre);
        valid_matchoutplus <= (valid_match_pre && valid_matchplus_pre);
        valid_matchoutminus <= (valid_match_pre && valid_matchminus_pre);
    end

    /////////////////////////////////////////////////////////
    
    
    
    
endmodule
