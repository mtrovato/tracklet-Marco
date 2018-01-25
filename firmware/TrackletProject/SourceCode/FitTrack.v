`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:16:38 PM
// Design Name: 
// Module Name: TrackFit
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


module FitTrack #(
    parameter SEEDING = "L1L2",
    //parameter NRESIN = 12,    // number of residual input ports (determined by seedings)
    parameter RESDWIDTH = 40  // residual data width: 40 for barrel, 37 for disk
) (
    input clk,
    input clk_new, //MT   
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number1in1,
    output [`MEM_SIZE+3:0] read_add1in1,
    output       read_en1in1,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch1in1,
    input [5:0] number2in1,
    output [`MEM_SIZE+3:0] read_add2in1,
    output       read_en2in1,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch2in1,
    input [5:0] number3in1,
    output [`MEM_SIZE+3:0] read_add3in1,
    output       read_en3in1,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch3in1,
    input [5:0] number4in1,
    output [`MEM_SIZE+3:0] read_add4in1,
    output       read_en4in1,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch4in1,
    input [5:0] number5in1,
    output [`MEM_SIZE+3:0] read_add5in1,
    output       read_en5in1,
    input [RESDWIDTH-1:0] fullmatch5in1,
    input [5:0] number6in1,
    output [`MEM_SIZE+3:0] read_add6in1,
    output       read_en6in1,
    input [RESDWIDTH-1:0] fullmatch6in1,
    input [5:0] number7in1,
    output [`MEM_SIZE+3:0] read_add7in1,
    output       read_en7in1,
    input [RESDWIDTH-1:0] fullmatch7in1,
    input [5:0] number8in1,
    output [`MEM_SIZE+3:0] read_add8in1,
    output       read_en8in1,
    input [RESDWIDTH-1:0] fullmatch8in1,
            
    input [5:0] number1in2,
    output [`MEM_SIZE+3:0] read_add1in2,
    output       read_en1in2,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch1in2,
    input [5:0] number2in2,
    output [`MEM_SIZE+3:0] read_add2in2,
    output       read_en2in2,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch2in2,
    input [5:0] number3in2,
    output [`MEM_SIZE+3:0] read_add3in2,
    output       read_en3in2,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch3in2,
    input [5:0] number4in2,
    output [`MEM_SIZE+3:0] read_add4in2,
    output       read_en4in2,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch4in2,
    input [5:0] number5in2,
    output [`MEM_SIZE+3:0] read_add5in2,
    output       read_en5in2,
    input [RESDWIDTH-1:0] fullmatch5in2,
    input [5:0] number6in2,
    output [`MEM_SIZE+3:0] read_add6in2,
    output       read_en6in2,
    input [RESDWIDTH-1:0] fullmatch6in2,
    input [5:0] number7in2,
    output [`MEM_SIZE+3:0] read_add7in2,
    output       read_en7in2,
    input [RESDWIDTH-1:0] fullmatch7in2,
    input [5:0] number8in2,
    output [`MEM_SIZE+3:0] read_add8in2,
    output       read_en8in2,
    input [RESDWIDTH-1:0] fullmatch8in2,    
        
    input [5:0] number1in3,
    output [`MEM_SIZE+3:0] read_add1in3,
    output       read_en1in3,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch1in3,
    input [5:0] number2in3,
    output [`MEM_SIZE+3:0] read_add2in3,
    output       read_en2in3,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch2in3,
    input [5:0] number3in3,
    output [`MEM_SIZE+3:0] read_add3in3,
    output       read_en3in3,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch3in3,
    input [5:0] number4in3,
    output [`MEM_SIZE+3:0] read_add4in3,
    output       read_en4in3,
    (* mark_debug = "true" *) input [RESDWIDTH-1:0] fullmatch4in3,
    input [5:0] number5in3,
    output [`MEM_SIZE+3:0] read_add5in3,
    output       read_en5in3,
    input [RESDWIDTH-1:0] fullmatch5in3,
    input [5:0] number6in3,
    output [`MEM_SIZE+3:0] read_add6in3,
    output       read_en6in3,
    input [RESDWIDTH-1:0] fullmatch6in3,
    input [5:0] number7in3,
    output [`MEM_SIZE+3:0] read_add7in3,
    output       read_en7in3,
    input [RESDWIDTH-1:0] fullmatch7in3,
    input [5:0] number8in3,
    output [`MEM_SIZE+3:0] read_add8in3,
    output       read_en8in3,
    input [RESDWIDTH-1:0] fullmatch8in3,

    input [5:0] number1in4,
    output [`MEM_SIZE+3:0] read_add1in4,
    output       read_en1in4,
    input [RESDWIDTH-1:0] fullmatch1in4,
    input [5:0] number2in4,
    output [`MEM_SIZE+3:0] read_add2in4,
    output       read_en2in4,
    input [RESDWIDTH-1:0] fullmatch2in4,
    input [5:0] number3in4,
    output [`MEM_SIZE+3:0] read_add3in4,
    output       read_en3in4,
    input [RESDWIDTH-1:0] fullmatch3in4,
    input [5:0] number4in4,
    output [`MEM_SIZE+3:0] read_add4in4,
    output       read_en4in4,
    input [RESDWIDTH-1:0] fullmatch4in4,
    input [5:0] number5in4,
    output [`MEM_SIZE+3:0] read_add5in4,
    output       read_en5in4,
    input [RESDWIDTH-1:0] fullmatch5in4,
    input [5:0] number6in4,
    output [`MEM_SIZE+3:0] read_add6in4,
    output       read_en6in4,
    input [RESDWIDTH-1:0] fullmatch6in4,
    input [5:0] number7in4,
    output [`MEM_SIZE+3:0] read_add7in4,
    output       read_en7in4,
    input [RESDWIDTH-1:0] fullmatch7in4,
    input [5:0] number8in4,
    output [`MEM_SIZE+3:0] read_add8in4,
    output       read_en8in4,
    input [RESDWIDTH-1:0] fullmatch8in4,

    output reg [`MEM_SIZE+4:0] read_add_pars1,
    input [67:0] tpar1in,
    output reg [`MEM_SIZE+4:0] read_add_pars2,
    input [67:0] tpar2in,
    output reg [`MEM_SIZE+4:0] read_add_pars3,
    input [67:0] tpar3in,
    output reg [`MEM_SIZE+4:0] read_add_pars4,
    input [67:0] tpar4in,    
    
    output [125:0] trackout,
    output valid_fit
    );
    
    // Residual bit assignment (put into header?) 
    // L: lowest bit; H: highest bit;
    // assume phi bits are same for barrel and disk layers
    // for convenience, assume residuals from barrel or disk are of the same width
    // and tracklet/stub index are of same position
    localparam TKLTINDEX_H = 39;
    localparam TKLTINDEX_L = 30;
    localparam STUBINDEX_H = 29;
    localparam STUBINDEX_L = 21;
    localparam STUBINDEX_NBITS = STUBINDEX_H - STUBINDEX_L + 1;
    localparam PHIRES_H = 20;
    localparam PHIRES_L = 9;
    localparam PHIRES_WIDTH = PHIRES_H - PHIRES_L + 1;
    localparam ZRES_H = 8;
    localparam ZRES_L = 0;
    localparam ZRES_WIDTH = ZRES_H - ZRES_L + 1;
    localparam RRES_H = 7;
    localparam RRES_L = 0; 
    localparam RRES_WIDTH = RRES_H - RRES_L + 1;   
    localparam ALPHA_H = 8;
    localparam ALPHA_NBITS = 1;
    
    // Derivatives
    localparam DERWIDTH_PHI = 14;
    localparam DERWIDTH_ZR = 16;
    
    localparam TABLE_RINV_DPHI = {"FitDerTableNewer_Rinvdphi_", SEEDING, ".txt"};
    localparam TABLE_PHI0_DPHI = {"FitDerTableNewer_Phi0dphi_", SEEDING, ".txt"};
    localparam TABLE_T_DPHI = {"FitDerTableNewer_Tdphi_", SEEDING, ".txt"};
    localparam TABLE_Z0_DPHI = {"FitDerTableNewer_Z0dphi_", SEEDING, ".txt"};
    localparam TABLE_RINV_DZORDR = {"FitDerTableNewer_Rinvdzordr_", SEEDING, ".txt"};
    localparam TABLE_PHI0_DZORDR = {"FitDerTableNewer_Phi0dzordr_", SEEDING, ".txt"};
    localparam TABLE_T_DZORDR = {"FitDerTableNewer_Tdzordr_", SEEDING, ".txt"};
    localparam TABLE_Z0_DZORDR = {"FitDerTableNewer_Z0dzordr_", SEEDING, ".txt"};
    
    
    reg [6:0] BX_pipe;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
    
    initial begin
       BX_pipe = 7'b1111111;
    end
     
    always @(posedge clk) begin
        if (rst_pipe)
            BX_pipe <= 7'b1111111;
        else begin
            if(start[0]) begin
               BX_pipe <= BX_pipe + 1'b1;
            end
        end
    end    

    pipe_delay #(.STAGES(26), .WIDTH(2))
           done_delay(.pipe_in(), .pipe_out(), .clk(clk),
           .val_in(start), .val_out(done));
    
    /////////////////////////////////////////////////////////////////////////////
    // Read residuals
    // ASSUME residuals from 2S and PS modules of the same disk are stored in seperate memories 
    // Top 10 bits of residual is Tracklet index
    // The higher 4 bits indicating which 2 DTC regions the tracklet is 
    // The lower 6 bits are actual index that is used in the merger      

    wire read_en1, read_en2, read_en3, read_en4, read_en5, read_en6, read_en7, read_en8;
    wire valid_fm1,valid_fm2, valid_fm3, valid_fm4, valid_fm5, valid_fm6, valid_fm7, valid_fm8;

    wire [RESDWIDTH-1:0] fullmatch1_i, fullmatch2_i, fullmatch3_i, fullmatch4_i, fullmatch5_i, fullmatch6_i, fullmatch7_i, fullmatch8_i;
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader1 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch1in1),
        .numberin_1(number1in1),
        .read_addr_1(read_add1in1),
        .read_enable_1(read_en1in1),
        .fullmatchin_2(fullmatch1in2),
        .numberin_2(number1in2),
        .read_addr_2(read_add1in2),
        .read_enable_2(read_en1in2),
        .fullmatchin_3(fullmatch1in3),
        .numberin_3(number1in3),
        .read_addr_3(read_add1in3),
        .read_enable_3(read_en1in3),
        .fullmatchin_4(fullmatch1in4),
        .numberin_4(number1in4),
        .read_addr_4(read_add1in4),
        .read_enable_4(read_en1in4),
        
        .inRead(read_en1),   // input, read enable for the merger
        .fullmatchout(fullmatch1_i),    // output
        .valid_o(valid_fm1)  // output
    );
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader2 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch2in1),
        .numberin_1(number2in1),
        .read_addr_1(read_add2in1),
        .read_enable_1(read_en2in1),
        .fullmatchin_2(fullmatch2in2),
        .numberin_2(number2in2),
        .read_addr_2(read_add2in2),
        .read_enable_2(read_en2in2),
        .fullmatchin_3(fullmatch2in3),
        .numberin_3(number2in3),
        .read_addr_3(read_add2in3),
        .read_enable_3(read_en2in3),
        .fullmatchin_4(fullmatch2in4),
        .numberin_4(number2in4),
        .read_addr_4(read_add2in4),
        .read_enable_4(read_en2in4),
        
        .inRead(read_en2),   // input, read enable for the merger
        .fullmatchout(fullmatch2_i),    // output
        .valid_o(valid_fm2)  // output
    );
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader3 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch3in1),
        .numberin_1(number3in1),
        .read_addr_1(read_add3in1),
        .read_enable_1(read_en3in1),
        .fullmatchin_2(fullmatch3in2),
        .numberin_2(number3in2),
        .read_addr_2(read_add3in2),
        .read_enable_2(read_en3in2),
        .fullmatchin_3(fullmatch3in3),
        .numberin_3(number3in3),
        .read_addr_3(read_add3in3),
        .read_enable_3(read_en3in3),
        .fullmatchin_4(fullmatch3in4),
        .numberin_4(number3in4),
        .read_addr_4(read_add3in4),
        .read_enable_4(read_en3in4),
        
        .inRead(read_en3),   // input, read enable for the merger
        .fullmatchout(fullmatch3_i),    // output
        .valid_o(valid_fm3)  // output
    );
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader4 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch4in1),
        .numberin_1(number4in1),
        .read_addr_1(read_add4in1),
        .read_enable_1(read_en4in1),
        .fullmatchin_2(fullmatch4in2),
        .numberin_2(number4in2),
        .read_addr_2(read_add4in2),
        .read_enable_2(read_en4in2),
        .fullmatchin_3(fullmatch4in3),
        .numberin_3(number4in3),
        .read_addr_3(read_add4in3),
        .read_enable_3(read_en4in3),
        .fullmatchin_4(fullmatch4in4),
        .numberin_4(number4in4),
        .read_addr_4(read_add4in4),
        .read_enable_4(read_en4in4),
        
        .inRead(read_en4),   // input, read enable for the merger
        .fullmatchout(fullmatch4_i),    // output
        .valid_o(valid_fm4)  // output
    );    
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader5 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch5in1),
        .numberin_1(number5in1),
        .read_addr_1(read_add5in1),
        .read_enable_1(read_en5in1),
        .fullmatchin_2(fullmatch5in2),
        .numberin_2(number5in2),
        .read_addr_2(read_add5in2),
        .read_enable_2(read_en5in2),
        .fullmatchin_3(fullmatch5in3),
        .numberin_3(number5in3),
        .read_addr_3(read_add5in3),
        .read_enable_3(read_en5in3),
        .fullmatchin_4(fullmatch5in4),
        .numberin_4(number5in4),
        .read_addr_4(read_add5in4),
        .read_enable_4(read_en5in4),
        
        .inRead(read_en5),   // input, read enable for the merger
        .fullmatchout(fullmatch5_i),    // output
        .valid_o(valid_fm5)  // output
    );
   
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader6 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch6in1),
        .numberin_1(number6in1),
        .read_addr_1(read_add6in1),
        .read_enable_1(read_en6in1),
        .fullmatchin_2(fullmatch6in2),
        .numberin_2(number6in2),
        .read_addr_2(read_add6in2),
        .read_enable_2(read_en6in2),
        .fullmatchin_3(fullmatch6in3),
        .numberin_3(number6in3),
        .read_addr_3(read_add6in3),
        .read_enable_3(read_en6in3),
        .fullmatchin_4(fullmatch6in4),
        .numberin_4(number6in4),
        .read_addr_4(read_add6in4),
        .read_enable_4(read_en6in4),
        
        .inRead(read_en6),   // input, read enable for the merger
        .fullmatchout(fullmatch6_i),    // output
        .valid_o(valid_fm6)  // output
    );
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader7 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch7in1),
        .numberin_1(number7in1),
        .read_addr_1(read_add7in1),
        .read_enable_1(read_en7in1),
        .fullmatchin_2(fullmatch7in2),
        .numberin_2(number7in2),
        .read_addr_2(read_add7in2),
        .read_enable_2(read_en7in2),
        .fullmatchin_3(fullmatch7in3),
        .numberin_3(number7in3),
        .read_addr_3(read_add7in3),
        .read_enable_3(read_en7in3),
        .fullmatchin_4(fullmatch7in4),
        .numberin_4(number7in4),
        .read_addr_4(read_add7in4),
        .read_enable_4(read_en7in4),
        
        .inRead(read_en7),   // input, read enable for the merger
        .fullmatchout(fullmatch7_i),    // output
        .valid_o(valid_fm7)  // output
    );
    
    FMReaderByLayer #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L) fullmatch_reader8 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(fullmatch8in1),
        .numberin_1(number8in1),
        .read_addr_1(read_add8in1),
        .read_enable_1(read_en8in1),
        .fullmatchin_2(fullmatch8in2),
        .numberin_2(number8in2),
        .read_addr_2(read_add8in2),
        .read_enable_2(read_en8in2),
        .fullmatchin_3(fullmatch8in3),
        .numberin_3(number8in3),
        .read_addr_3(read_add8in3),
        .read_enable_3(read_en8in3),
        .fullmatchin_4(fullmatch8in4),
        .numberin_4(number8in4),
        .read_addr_4(read_add8in4),
        .read_enable_4(read_en8in4),
        
        .inRead(read_en8),   // input, read enable for the merger
        .fullmatchout(fullmatch8_i),    // output
        .valid_o(valid_fm8)  // output
    );

    ///////////////////////////////////////////////////////////////////////
    // Merge residuals from different layers into four input ports

    wire [RESDWIDTH-1:0] m_fullmatch_input1, m_fullmatch_input2, m_fullmatch_input3, m_fullmatch_input4;
    wire read_input1, read_input2, read_input3, read_input4;
    wire m_valid_input1, m_valid_input2, m_valid_input3, m_valid_input4;
    wire [1:0] m_index_input1, m_index_input2, m_index_input3, m_index_input4;
    wire [RESDWIDTH-1:0] fullmatch_input1, fullmatch_input2, fullmatch_input3, fullmatch_input4;
    wire valid_input1, valid_input2, valid_input3, valid_input4;
    //wire [1:0] index_input1, index_input2, index_input3, index_input4;
    reg [2:0] hitpat_1, hitpat_2, hitpat_3, hitpat_4;
    wire fifo_reset_done;

    // Data merger for input1
    wire [RESDWIDTH-1:0] fullmatch_input1in1, fullmatch_input1in2;
    wire valid_input1in1, valid_input1in2;
    wire outread_input1in1, outread_input1in2;
    merger #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L)
    input1_i
    (
        .clk(clk),
        .en(1'b1),
        .reset(start[0]),
        .inputA(fullmatch_input1in1),
        .validA_i(valid_input1in1),
        .outreadA(outread_input1in1),
        .inputB(fullmatch_input1in2),
        .validB_i(valid_input1in2),
        .outreadB(outread_input1in2),
        .inRead(fifo_reset_done),
        .out(m_fullmatch_input1),
        .vout(m_valid_input1)
        //.input_index(m_index_input1)
    );

    // Data merger for input2
    wire [RESDWIDTH-1:0] fullmatch_input2in1, fullmatch_input2in2;
    wire valid_input2in1, valid_input2in2;
    wire outread_input2in1, outread_input2in2;
    merger #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L)
    input2_i
    (
        .clk(clk),
        .en(1'b1),
        .reset(start[0]),
        .inputA(fullmatch_input2in1),
        .validA_i(valid_input2in1),
        .outreadA(outread_input2in1),
        .inputB(fullmatch_input2in2),
        .validB_i(valid_input2in2),
        .outreadB(outread_input2in2),
        .inRead(fifo_reset_done),
        .out(m_fullmatch_input2),
        .vout(m_valid_input2)
        //.input_index(m_index_input2)
    );

    // Data merger for input3
    wire [RESDWIDTH-1:0] fullmatch_input3in1, fullmatch_input3in2;
    wire valid_input3in1, valid_input3in2;
    wire outread_input3in1, outread_input3in2;
    merger #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L)
    input3_i
    (
        .clk(clk),
        .en(1'b1),
        .reset(start[0]),
        .inputA(fullmatch_input3in1),
        .validA_i(valid_input3in1),
        .outreadA(outread_input3in1),
        .inputB(fullmatch_input3in2),
        .validB_i(valid_input3in2),
        .outreadB(outread_input3in2),
        .inRead(fifo_reset_done),
        .out(m_fullmatch_input3),
        .vout(m_valid_input3)
        //.input_index(m_index_input3)
    );
         
    // Data merger for input4
    wire [RESDWIDTH-1:0] fullmatch_input4in1, fullmatch_input4in2;
    wire valid_input4in1, valid_input4in2;
    wire outread_input4in1, outread_input4in2;
    merger #(RESDWIDTH,TKLTINDEX_H,TKLTINDEX_L)
    input4_i
    (
        .clk(clk),
        .en(1'b1),
        .reset(start[0]),
        .inputA(fullmatch_input4in1),
        .validA_i(valid_input4in1),
        .outreadA(outread_input4in1),
        .inputB(fullmatch_input4in2),
        .validB_i(valid_input4in2),
        .outreadB(outread_input4in2),
        .inRead(fifo_reset_done),
        .out(m_fullmatch_input4),
        .vout(m_valid_input4)
        //.input_index(m_index_input4)
    );

    // FIFOs
    // use synchronous reset for smaller latency 
    assign fifo_reset_done = ~start[0];
    
    post_merge_fifo merged_input1 (
        .clk(clk),
        .srst(start[0]),
        .din(m_fullmatch_input1),
        .full(),
        .wr_en(m_valid_input1),
        .dout(fullmatch_input1),
        .valid(valid_input1),
        .rd_en(read_input1),
        .empty()
    );

    post_merge_fifo merged_input2 (
        .clk(clk),
        .srst(start[0]),
        .din(m_fullmatch_input2),
        .full(),
        .wr_en(m_valid_input2),
        .dout(fullmatch_input2),
        .valid(valid_input2),
        .rd_en(read_input2),
        .empty()
    );

    post_merge_fifo merged_input3 (
        .clk(clk),
        .srst(start[0]),
        .din(m_fullmatch_input3),
        .full(),
        .wr_en(m_valid_input3),
        .dout(fullmatch_input3),
        .valid(valid_input3),
        .rd_en(read_input3),
        .empty()
    );
    
    post_merge_fifo merged_input4 (
        .clk(clk),
        .srst(start[0]),
        .din(m_fullmatch_input4),
        .full(),
        .wr_en(m_valid_input4),
        .dout(fullmatch_input4),
        .valid(valid_input4),
        .rd_en(read_input4),
        .empty()
    );    

    // read enable logic from the FIFOs of four inputs
    assign read_input1 = valid_input1 &&
                         ({~valid_input1,fullmatch_input1[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input2,fullmatch_input2[TKLTINDEX_H:TKLTINDEX_L]}) &&
                         ({~valid_input1,fullmatch_input1[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input3,fullmatch_input3[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input1,fullmatch_input1[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input4,fullmatch_input4[TKLTINDEX_H:TKLTINDEX_L]});
    assign read_input2 = valid_input2 &&
                         ({~valid_input2,fullmatch_input2[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input1,fullmatch_input1[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input2,fullmatch_input2[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input3,fullmatch_input3[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input2,fullmatch_input2[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input4,fullmatch_input4[TKLTINDEX_H:TKLTINDEX_L]});
    assign read_input3 = valid_input3 &&
                         ({~valid_input3,fullmatch_input3[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input1,fullmatch_input1[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input3,fullmatch_input3[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input2,fullmatch_input2[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input3,fullmatch_input3[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input4,fullmatch_input4[TKLTINDEX_H:TKLTINDEX_L]});
    assign read_input4 = valid_input4 &&
                         ({~valid_input4,fullmatch_input4[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input1,fullmatch_input1[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input4,fullmatch_input4[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input2,fullmatch_input2[TKLTINDEX_H:TKLTINDEX_L]}) && 
                         ({~valid_input4,fullmatch_input4[TKLTINDEX_H:TKLTINDEX_L]} <= {~valid_input3,fullmatch_input3[TKLTINDEX_H:TKLTINDEX_L]});
                      
    reg [RESDWIDTH-1:0] fullmatch_input1_pipe, fullmatch_input2_pipe, fullmatch_input3_pipe, fullmatch_input4_pipe;
    //reg [1:0] index_input1_pipe, index_input2_pipe, index_input3_pipe, index_input4_pipe;
    reg hit_input1, hit_input2, hit_input3, hit_input4;
    
    always @(posedge clk) begin
        fullmatch_input1_pipe <= fullmatch_input1;
        fullmatch_input2_pipe <= fullmatch_input2;
        fullmatch_input3_pipe <= fullmatch_input3;
        fullmatch_input4_pipe <= fullmatch_input4;
        //index_input1_pipe <= index_input1;
        //index_input2_pipe <= index_input2;
        //index_input3_pipe <= index_input3;
        //index_input4_pipe <= index_input4;
        hit_input1 <= read_input1;
        hit_input2 <= read_input2;
        hit_input3 <= read_input3;
        hit_input4 <= read_input4;
    end
        
    // Determine hit patterns as well as merger inputs based on the seeding layers
    wire [5:0] hitpat_barrel;  // {L1, L2, L3, L4, L5, L6}
    wire [9:0] hitpat_disk;    // {D1PS,D12S,D2PS,D22S,D3PS,D32S,D4PS,D42S,D5PS,D52S}
    wire [5*ALPHA_NBITS-1:0] pre_alphas;  // n bits x 5   {D12S, D22S, D32S, D42S, D52S}

    // dtc region of residuals
    wire [2:0] dtc_index_input1, dtc_index_input2, dtc_index_input3, dtc_index_input4;
    assign dtc_index_input1 = fullmatch_input1_pipe[STUBINDEX_H:STUBINDEX_H-2];
    assign dtc_index_input2 = fullmatch_input2_pipe[STUBINDEX_H:STUBINDEX_H-2];
    assign dtc_index_input3 = fullmatch_input3_pipe[STUBINDEX_H:STUBINDEX_H-2];
    assign dtc_index_input4 = fullmatch_input4_pipe[STUBINDEX_H:STUBINDEX_H-2];
    
    // CHECK DTC INDEX!!
    always @* begin
        case (dtc_index_input1)
            4: hitpat_1 <= (hit_input1) ? 3'b010 : 3'b000;  // D5 PS
            5: hitpat_1 <= (hit_input1) ? 3'b100 : 3'b000;  // D6 2S
            6: hitpat_1 <= (hit_input1) ? 3'b010 : 3'b000;  // D7 PS
            7: hitpat_1 <= (hit_input1) ? 3'b100 : 3'b000;  // D8 2S
            default: hitpat_1 <= (hit_input1) ? 3'b001 : 3'b000;  // D3 or D4  layer hit
        endcase
        case (dtc_index_input2)
            4: hitpat_2 <= (hit_input2) ? 3'b010 : 3'b000;  // D5 PS
            5: hitpat_2 <= (hit_input2) ? 3'b100 : 3'b000;  // D6 2S
            6: hitpat_2 <= (hit_input2) ? 3'b010 : 3'b000;  // D7 PS
            7: hitpat_2 <= (hit_input2) ? 3'b100 : 3'b000;  // D8 2S
            default: hitpat_2 <= (hit_input2) ? 3'b001 : 3'b000;  // D3 or D4  layer hit
        endcase
        case (dtc_index_input3)
            4: hitpat_3 <= (hit_input3) ? 3'b010 : 3'b000;  // D5 PS
            5: hitpat_3 <= (hit_input3) ? 3'b100 : 3'b000;  // D6 2S
            6: hitpat_3 <= (hit_input3) ? 3'b010 : 3'b000;  // D7 PS
            7: hitpat_3 <= (hit_input3) ? 3'b100 : 3'b000;  // D8 2S
            default: hitpat_3 <= (hit_input3) ? 3'b001 : 3'b000;  // D3 or D4  layer hit
        endcase   
        case (dtc_index_input4)
            4: hitpat_4 <= (hit_input4) ? 3'b010 : 3'b000;  // D5 PS
            5: hitpat_4 <= (hit_input4) ? 3'b100 : 3'b000;  // D6 2S
            6: hitpat_4 <= (hit_input4) ? 3'b010 : 3'b000;  // D7 PS
            7: hitpat_4 <= (hit_input4) ? 3'b100 : 3'b000;  // D8 2S
            default: hitpat_4 <= (hit_input4) ? 3'b001 : 3'b000;  // D3 or D4  layer hit
        endcase              
    end

    generate
    
        if (SEEDING=="L1L2") begin
            // Input port assignments:
            // 1inX: L3; 2inX: L4; 3inX: L5; 4inX: L6; 
            // 5inX: F1 or B1; 6inX: F2 or B2; 
            // 7inX: F3 or B3; 8inX: F4 or B4;

            // Input1
            // from L3 or D4
            assign fullmatch_input1in1 = fullmatch1_i;
            assign valid_input1in1 = valid_fm1;
            assign read_en1 = outread_input1in1;
            
            assign fullmatch_input1in2 = fullmatch8_i;
            assign valid_input1in2 = valid_fm8;
            assign read_en8 = outread_input1in2;
            
            // Input2
            // from L4 or D3
            assign fullmatch_input2in1 = fullmatch2_i;
            assign valid_input2in1 = valid_fm2;
            assign read_en2 = outread_input2in1;
            
            assign fullmatch_input2in2 = fullmatch7_i;
            assign valid_input2in2 = valid_fm7;
            assign read_en7 = outread_input2in2;        

            // Input3
            // from L5 or D2
            assign fullmatch_input3in1 = fullmatch3_i;
            assign valid_input3in1 = valid_fm3;
            assign read_en3 = outread_input3in1;
            
            assign fullmatch_input3in2 = fullmatch6_i;
            assign valid_input3in2 = valid_fm6;
            assign read_en6 = outread_input3in2;           

            // Input4
            // from L6 or D1 
            assign fullmatch_input4in1 = fullmatch4_i;
            assign valid_input4in1 = valid_fm4;
            assign read_en4 = outread_input4in1;
            
            assign fullmatch_input4in2 = fullmatch5_i;
            assign valid_input4in2 = valid_fm5;
            assign read_en5 = outread_input4in2;
            
            // hit pattern
            assign hitpat_barrel = {1'b1,1'b1,hitpat_1[0],hitpat_2[0],hitpat_3[0],hitpat_4[0]};
            assign hitpat_disk = {hitpat_4[1],hitpat_4[2],hitpat_3[1],hitpat_3[2],hitpat_2[1],hitpat_2[2],hitpat_1[1],hitpat_1[2],1'b0, 1'b0};
            // alpha
            assign pre_alphas = {fullmatch_input4_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input3_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input2_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input1_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 {ALPHA_NBITS{1'b0}}};
                                 
        end
        else if (SEEDING=="L3L4") begin
            // Input port assignments:
            // 1inX: L1; 2inX: L2; 3inX: L5; 4inX: L6;
            // 5inX: F1 or B1; 6inX: F2 or B2;
            // 7 - 8 inX not used
            
            // Input1: L1 only
            assign fullmatch_input1in1 = fullmatch1_i;
            assign valid_input1in1 = valid_fm1;
            assign read_en1 = outread_input1in1;

            // tie unused ports to ground
            assign fullmatch_input1in2 = {RESDWIDTH{1'b0}};
            assign valid_input1in2 = 1'b0;
                
            // Input2: L2 only
            assign fullmatch_input2in1 = fullmatch2_i;
            assign valid_input2in1 = valid_fm2;
            assign read_en2 = outread_input2in1;
            
            // tie unused ports to ground
            assign fullmatch_input2in2 = {RESDWIDTH{1'b0}};
            assign valid_input2in2 = 1'b0;
            
            // Input3
            // from L5 or D2
            assign fullmatch_input3in1 = fullmatch3_i;
            assign valid_input3in1 = valid_fm3;
            assign read_en3 = outread_input3in1;
            
            assign fullmatch_input3in2 = fullmatch6_i;
            assign valid_input3in2 = valid_fm6;
            assign read_en6 = outread_input3in2;                                
            
            // Input4
            // from L6 or D1
            assign fullmatch_input4in1 = fullmatch4_i;
            assign valid_input4in1 = valid_fm4;
            assign read_en4 = outread_input4in1;
            
            assign fullmatch_input4in2 = fullmatch5_i;
            assign valid_input4in2 = valid_fm5;
            assign read_en5 = outread_input4in2;         

            // hit pattern
            assign hitpat_barrel = {hitpat_1[0],hitpat_2[0],1'b1,1'b1,hitpat_3[0],hitpat_4[0]};
            assign hitpat_disk = {hitpat_4[1],hitpat_4[2],hitpat_3[1],hitpat_3[2], 6'b0}; 
            // alpha
            assign pre_alphas = {fullmatch_input4_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input3_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 {3*ALPHA_NBITS{1'b0}}};                               
                               
        end
        else if (SEEDING=="L5L6") begin
            // Input port assignments:
            // 1inX: L1; 2inX: L2; 3inX: L3; 4inX: L4;
            // 5-8 inX not used

            // Input1: L1 only 
            assign fullmatch_input1in1 = fullmatch1_i;
            assign valid_input1in1 = valid_fm1;
            assign read_en1 = outread_input1in1;
            
            // tie unused ports to ground
            assign fullmatch_input1in2 = {RESDWIDTH{1'b0}};
            assign valid_input1in2 = 1'b0;

            // Input2: L2 only
            assign fullmatch_input2in1 = fullmatch2_i;
            assign valid_input2in1 = valid_fm2;
            assign read_en2 = outread_input2in1;
            
            // tie unused ports to ground
            assign fullmatch_input2in2 = {RESDWIDTH{1'b0}};
            assign valid_input2in2 = 1'b0;
            
            // Input3: L3 only
            assign fullmatch_input3in1 = fullmatch3_i;
            assign valid_input3in1 = valid_fm3;
            assign read_en3 = outread_input3in1;
            
            // tie unused ports to ground
            assign fullmatch_input3in2 = {RESDWIDTH{1'b0}};
            assign valid_input3in2 = 1'b0;

            // Input4: L4 only
            assign fullmatch_input4in1 = fullmatch4_i;
            assign valid_input4in1 = valid_fm4;
            assign read_en4 = outread_input4in1;
            
            // tie unused ports to ground
            assign fullmatch_input4in2 = {RESDWIDTH{1'b0}};
            assign valid_input4in2 = 1'b0;
            
            // hit pattern
            assign hitpat_barrel = {hitpat_1[0],hitpat_2[0],hitpat_3[0],hitpat_4[0],1'b1,1'b1};
            assign hitpat_disk = 10'b0;
            // alpha
            assign pre_alphas = {15'b0};

        end
        else if (SEEDING=="F1F2" || SEEDING=="B1B2") begin
            // Input port assignments:
            // 1inX: L1; 2inX: L2; 
            // 3inX: D3; 4inX: D4; 7inX: D5;
            // 5,6,8 inX not used 
            
            // Input1: L1 only
            assign fullmatch_input1in1 = fullmatch1_i;
            assign valid_input1in1 = valid_fm1;
            assign read_en1 = outread_input1in1;
            
            // tie unused ports to ground
            assign fullmatch_input1in2 = {RESDWIDTH{1'b0}};
            assign valid_input1in2 = 1'b0;
            
            // Input2: D3
            assign fullmatch_input2in1 = fullmatch3_i;
            assign valid_input2in1 = valid_fm3;
            assign read_en3 = outread_input2in1;
            
            // tie unused ports to ground
            assign fullmatch_input2in2 = {RESDWIDTH{1'b0}};
            assign valid_input2in2 = 1'b0;                 

            // Input3: D4
            assign fullmatch_input3in1 = fullmatch4_i;
            assign valid_input3in1 = valid_fm4;
            assign read_en4 = outread_input3in1;

            // tie unused ports to ground
            assign fullmatch_input3in2 = {RESDWIDTH{1'b0}};
            assign valid_input3in2 = 1'b0;
 
            // Input4: L2 or D5
            assign fullmatch_input4in1 = fullmatch2_i;
            assign valid_input4in1 = valid_fm2;
            assign read_en2 = outread_input4in1;
            
            assign fullmatch_input4in2 = fullmatch7_i;
            assign valid_input4in2 = valid_fm7;
            assign read_en7 = outread_input4in2;          
                                   
            // hit pattern
            assign hitpat_barrel = {hitpat_1[0],hitpat_4[0],4'b0};
            assign hitpat_disk = {4'b1010, hitpat_2[1],hitpat_2[2],hitpat_3[1],hitpat_3[2],hitpat_4[1],hitpat_4[2]};               
            // alpha
            assign pre_alphas = {{2*ALPHA_NBITS{1'b0}},
                                 fullmatch_input2_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input3_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input4_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1]};                          

        end
        else if (SEEDING=="F3F4" || SEEDING=="B3B4") begin
            // Input port assignments:
            // 1inX: L1; 2inX: L2;
            // 3inX: D1; 4inX: D2; 7inX: D5;
            // 5,6,8inX not used
            
            // Input1: L1 only
            assign fullmatch_input1in1 = fullmatch1_i;
            assign valid_input1in1 = valid_fm1;
            assign read_en1 = outread_input1in1; 
            
            // tie unused ports to ground
            assign fullmatch_input1in2 = {RESDWIDTH{1'b0}};
            assign valid_input1in2 = 1'b0;           
                        
            // Input2: D1
            assign fullmatch_input2in1 = fullmatch3_i;
            assign valid_input2in1 = valid_fm3;
            assign read_en3 = outread_input2in1;

            // tie unused ports to ground
            assign fullmatch_input2in2 = {RESDWIDTH{1'b0}};
            assign valid_input2in2 = 1'b0; 
            
            // Input3: D2
            assign fullmatch_input3in1 = fullmatch4_i;
            assign valid_input3in1 = valid_fm4;
            assign read_en4 = outread_input3in1;         
            
            // tie unused ports to ground
            assign fullmatch_input3in2 = {RESDWIDTH{1'b0}};
            assign valid_input3in2 = 1'b0; 
            
            // Input4: L2 or D5
            assign fullmatch_input4in1 = fullmatch2_i;
            assign valid_input4in1 = valid_fm2;
            assign read_en2 = outread_input4in1;
            
            assign fullmatch_input4in2 = fullmatch7_i;
            assign valid_input4in2 = valid_fm7;
            assign read_en7 = outread_input4in2;                                     
            
            // hit pattern
            assign hitpat_barrel = {hitpat_1[0],hitpat_4[0],4'b0};
            assign hitpat_disk = {hitpat_2[1],hitpat_2[2],hitpat_3[1],hitpat_3[2],4'b1010,hitpat_4[1],hitpat_4[2]};
            // alpha
            assign pre_alphas = {fullmatch_input2_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input3_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 {2*ALPHA_NBITS{1'b0}},
                                 fullmatch_input4_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1]};  
       
        end
        else if (SEEDING=="F1L1" || SEEDING=="B1L1") begin
            // Input port assignments:
            // 1inX: D2; 2inX: D3; 3inX: D4; 4inX: D5;
            // 5-8inX not used
            
            // Input1: D2
            assign fullmatch_input1in1 = fullmatch1_i;
            assign valid_input1in1 = valid_fm1;
            assign read_en1 = outread_input1in1;
    
            // tie unused ports to ground
            assign fullmatch_input1in2 = {RESDWIDTH{1'b0}};
            assign valid_input1in2 = 1'b0; 
            
            // Input2: D3
            assign fullmatch_input2in1 = fullmatch2_i;
            assign valid_input2in1 = valid_fm2;
            assign read_en2 = outread_input2in1;
            
            // tie unused ports to ground
            assign fullmatch_input2in2 = {RESDWIDTH{1'b0}};
            assign valid_input2in2 = 1'b0; 
            
            // Input3: D4
            assign fullmatch_input3in1 = fullmatch3_i;
            assign valid_input3in1 = valid_fm3;
            assign read_en3 = outread_input3in1;   
            
            // tie unused ports to ground
            assign fullmatch_input3in2 = {RESDWIDTH{1'b0}};
            assign valid_input3in2 = 1'b0;                    

            // Input4: D5
            assign fullmatch_input4in1 = fullmatch4_i;
            assign valid_input4in1 = valid_fm4;
            assign read_en4 = outread_input4in1;
            
            // tie unused ports to ground
            assign fullmatch_input4in2 = {RESDWIDTH{1'b0}};
            assign valid_input4in2 = 1'b0;       
                        
            // hit pattern
            assign hitpat_barrel = {1'b1, 5'b0};
            assign hitpat_disk = {2'b10, hitpat_1[1],hitpat_1[2],hitpat_2[1],hitpat_2[2],hitpat_3[1],hitpat_3[2],hitpat_4[1],hitpat_4[2]};
            // alpha
            assign pre_alphas = {{ALPHA_NBITS{1'b0}},
                                 fullmatch_input1_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input2_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input3_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1],
                                 fullmatch_input4_pipe[ALPHA_H:ALPHA_H-ALPHA_NBITS+1]};                            
        end
     
    endgenerate


    // valid track
    wire [2:0] sum_test;
    reg pre_valid_fit;       
    // require at least 4 hits including seedings to be a valid track
    assign sum_test = hit_input1 + hit_input2 + hit_input3 + hit_input4;
    always @(posedge clk) begin
        if(sum_test > 3'b001)
            pre_valid_fit <= 1'b1;
        else
            pre_valid_fit <= 1'b0;        
    end
    
    pipe_delay #(.STAGES(16), .WIDTH(1))
       valid_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(pre_valid_fit), .val_out(valid_fit)); 

    // Put together residuals
    reg  [83:0] track_matches;
    wire [83:0] track_matches_dly;
    reg  [4*STUBINDEX_NBITS-1:0] stub_indices;
    wire [4*STUBINDEX_NBITS-1:0] stub_indices_dly;
    
    always @(posedge clk) begin
        // residuals
        if (hitpat_1[0]) begin  // barrel hit
            track_matches[83:63] <= fullmatch_input1_pipe[PHIRES_H:ZRES_L];
            stub_indices[4*STUBINDEX_NBITS-1:3*STUBINDEX_NBITS] <= fullmatch_input1_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else if (hitpat_1[1] | hitpat_1[2]) begin  // disk hit
        // assume ALPHA_NBITS = ZRES_H - RRES_H
            track_matches[83:63] <= {fullmatch_input1_pipe[PHIRES_H:PHIRES_L],{(ZRES_WIDTH-RRES_WIDTH){fullmatch_input1_pipe[RRES_H]}},fullmatch_input1_pipe[RRES_H:RRES_L]};
            stub_indices[4*STUBINDEX_NBITS-1:3*STUBINDEX_NBITS] <= fullmatch_input1_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else begin
            track_matches[83:63] <= 21'b0;
            stub_indices[4*STUBINDEX_NBITS-1:3*STUBINDEX_NBITS] <= {STUBINDEX_NBITS{1'b1}};
        end
        if (hitpat_2[0]) begin  // barrel hit
            track_matches[62:42] <= fullmatch_input2_pipe[PHIRES_H:ZRES_L];
            stub_indices[3*STUBINDEX_NBITS-1:2*STUBINDEX_NBITS] <= fullmatch_input2_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else if (hitpat_2[1] | hitpat_2[2]) begin  // disk hit
            track_matches[62:42] <= {fullmatch_input2_pipe[PHIRES_H:PHIRES_L],{(ZRES_WIDTH-RRES_WIDTH){fullmatch_input2_pipe[RRES_H]}},fullmatch_input2_pipe[RRES_H:RRES_L]};
            stub_indices[3*STUBINDEX_NBITS-1:2*STUBINDEX_NBITS] <= fullmatch_input2_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else begin
            track_matches[62:42] <= 21'b0;
            stub_indices[3*STUBINDEX_NBITS-1:2*STUBINDEX_NBITS] <= {STUBINDEX_NBITS{1'b1}};
        end
        if (hitpat_3[0]) begin  // barrel hit
            track_matches[41:21] <= fullmatch_input3_pipe[PHIRES_H:ZRES_L];
            stub_indices[2*STUBINDEX_NBITS-1:STUBINDEX_NBITS] <= fullmatch_input3_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else if (hitpat_3[1] | hitpat_3[2]) begin
            track_matches[41:21] <= {fullmatch_input3_pipe[PHIRES_H:PHIRES_L],{(ZRES_WIDTH-RRES_WIDTH){fullmatch_input3_pipe[RRES_H]}},fullmatch_input3_pipe[RRES_H:RRES_L]};
            stub_indices[2*STUBINDEX_NBITS-1:STUBINDEX_NBITS] <= fullmatch_input3_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else begin
            track_matches[41:21] <= 21'b0;
            stub_indices[2*STUBINDEX_NBITS-1:STUBINDEX_NBITS] <= {STUBINDEX_NBITS{1'b1}};
        end
        if (hitpat_4[0]) begin
            track_matches[20:0] <= fullmatch_input4_pipe[PHIRES_H:ZRES_L];
            stub_indices[STUBINDEX_NBITS-1:0] <= fullmatch_input4_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else if (hitpat_4[1] | hitpat_4[2]) begin
            track_matches[20:0] <= {fullmatch_input4_pipe[PHIRES_H:PHIRES_L],{(ZRES_WIDTH-RRES_WIDTH){fullmatch_input4_pipe[RRES_H]}},fullmatch_input4_pipe[RRES_H:RRES_L]};
            stub_indices[STUBINDEX_NBITS-1:0] <= fullmatch_input4_pipe[STUBINDEX_H:STUBINDEX_L];
        end
        else begin
            track_matches[20:0] <= 21'b0;
            stub_indices[STUBINDEX_NBITS-1:0] <= {STUBINDEX_NBITS{1'b1}};
        end
    end

    // delay residuals to wait for derivative loop-up    
    pipe_delay #(.STAGES(8), .WIDTH(84))
       residual_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(track_matches), .val_out(track_matches_dly));
    // delay stub indices until trackout is ready
    pipe_delay #(.STAGES(16), .WIDTH(4*STUBINDEX_NBITS))
       stubindex_delay(.pipe_in(13), .pipe_out(), .clk(clk),
       .val_in(stub_indices), .val_out(stub_indices_dly));
              
    // Get tracklet index and read tracklet parameters
    reg [9:0] tracklet_index;           
    always @(posedge clk) begin
        
        // Get tracklet index
        if (hit_input1)
            tracklet_index <= fullmatch_input1_pipe[TKLTINDEX_H:TKLTINDEX_L];
        else if (hit_input2)
            tracklet_index <= fullmatch_input2_pipe[TKLTINDEX_H:TKLTINDEX_L];
        else if (hit_input3)
            tracklet_index <= fullmatch_input3_pipe[TKLTINDEX_H:TKLTINDEX_L];
        else if (hit_input4)
            tracklet_index <= fullmatch_input4_pipe[TKLTINDEX_H:TKLTINDEX_L];
        else 
            tracklet_index <= 10'h3f; 
     
     end     
     
    // Delay BX_pipe for tracklet address
    wire [4:0] BX_pipe_tpar;
    pipe_delay #(.STAGES(14), .WIDTH(5))
       bx_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(BX_pipe[4:0]), .val_out(BX_pipe_tpar));
       
    // ASSUME top 4 bits of tracklet index pointing to the TrackletCalculator as follows:      
    reg [3:0] pick_tpar;
    wire [3:0] pick_tpar_dly;
    reg [2:0] DTC_index_inner;
    reg [2:0] DTC_index_outer;
    
    always @(posedge clk) begin
        if (tracklet_index[9:6] == 4'b0000 || tracklet_index[9:6] == 4'b0011 || tracklet_index[9:6] == 4'b0110) begin // D3D3 or D5D4
            read_add_pars1 <= {BX_pipe_tpar, tracklet_index[`MEM_SIZE-1:0]};
            read_add_pars2 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars3 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars4 <= {`MEM_SIZE+5{1'b1}};
            pick_tpar <= 4'b0001;
            DTC_index_inner <= 3'b010;
            DTC_index_outer <= 3'b010;
        end
        else if (tracklet_index[9:6] == 4'b0111) begin // D5D5
            read_add_pars1 <= {BX_pipe_tpar, tracklet_index[`MEM_SIZE-1:0]};
            read_add_pars2 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars3 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars4 <= {`MEM_SIZE+5{1'b1}};
            pick_tpar <= 4'b0001;
            DTC_index_inner <= 3'b100;
            DTC_index_outer <= 3'b100;
        end
        else if (tracklet_index[9:6] == 4'b0001 || tracklet_index[9:6] == 4'b0100) begin // D3D4 seeding
            read_add_pars1 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars2 <= {BX_pipe_tpar, tracklet_index[`MEM_SIZE-1:0]};
            read_add_pars3 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars4 <= {`MEM_SIZE+5{1'b1}};
            pick_tpar <= 4'b0010;
            DTC_index_inner <= 3'b010;
            DTC_index_outer <= 3'b011;
        end
        else if (tracklet_index[9:6] == 4'b0010 || tracklet_index[9:6] == 4'b0101) begin // D4D4 seeding
            read_add_pars1 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars2 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars3 <= {BX_pipe_tpar, tracklet_index[`MEM_SIZE-1:0]};
            read_add_pars4 <= {`MEM_SIZE+5{1'b1}};
            pick_tpar <= 4'b0100;
            DTC_index_inner <= 3'b011;
            DTC_index_outer <= 3'b011;
        end
        else begin
            read_add_pars1 <= {BX_pipe_tpar, tracklet_index[`MEM_SIZE-1:0]};//{`MEM_SIZE+5{1'b1}};
            read_add_pars2 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars3 <= {`MEM_SIZE+5{1'b1}};
            read_add_pars4 <= {`MEM_SIZE+5{1'b1}};
            pick_tpar <= 4'b1111;
            DTC_index_inner <= 3'b000;
            DTC_index_outer <= 3'b000;
        end
    end

    pipe_delay #(.STAGES(2), .WIDTH(4))
        pick_tpar_pipe(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(pick_tpar), .val_out(pick_tpar_dly));

    wire [2:0] DTC_index_inner_dly;
    wire [2:0] DTC_index_outer_dly;

    pipe_delay #(.STAGES(13), .WIDTH(3))
        inner_stub_index_pipe(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(DTC_index_inner), .val_out(DTC_index_inner_dly));
    pipe_delay #(.STAGES(13), .WIDTH(3))
        outer_stub_index_pipe(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(DTC_index_outer), .val_out(DTC_index_outer_dly));

    reg [67:0] tpar_in; 
    wire [67:0] trackparsin_pipe;
    wire [67:0] trackparsin_pipe_MT;   
    always @(posedge clk) begin
        if (pick_tpar_dly == 4'b0001)
            tpar_in <= tpar1in;
        else if (pick_tpar_dly == 4'b0010)
            tpar_in <= tpar2in;
        else if (pick_tpar_dly == 4'b0100)
            tpar_in <= tpar3in;
        else if (pick_tpar_dly == 4'b1000)
            tpar_in <= tpar4in;
        else
            tpar_in <= 67'b0;
    end

    // pipelining tpar
    pipe_delay #(.STAGES(10), .WIDTH(68))
        tracklet_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
        .val_in(tpar_in), .val_out(trackparsin_pipe)); 

   //MT Jan 19 2018
    pipe_delay #(.STAGES(4), .WIDTH(68))
        tracklet_pipe_MT(.pipe_in(en_proc), .pipe_out(en5b_MT), .clk(clk),
        .val_in(tpar_in), .val_out(trackparsin_pipe_MT)); 
   

    // Reduce 16 bits address to 13 bits base address
    wire [5:0] reduced_addr_layer;
    wire [6:0] reduced_addr_disk;
    
    Memory #(
            .RAM_WIDTH(6),                       // Specify RAM data width
            .RAM_DEPTH(64),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE("FitDerTableNew_LayerMem.txt"),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_layer_addr (
            .addra(6'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(hitpat_barrel),    // Read address bus, width determined from RAM_DEPTH
            .dina(6'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(reduced_addr_layer)     // RAM output data, width determined from RAM_WIDTH
        );

    Memory #(
            .RAM_WIDTH(7),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE("FitDerTableNew_DiskMem.txt"),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_disk_addr (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(hitpat_disk),    // Read address bus, width determined from RAM_DEPTH
            .dina(7'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(reduced_addr_disk)     // RAM output data, width determined from RAM_WIDTH
        );
        
    // Get base address for derivative lookup
    wire [9:0] base_der_addr;
    
    Memory #(
            .RAM_WIDTH(10),                       // Specify RAM data width
            .RAM_DEPTH(8192),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE("FitDerTableNew_LayerDiskMem.txt"),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_base_addr (
            .addra(13'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb({reduced_addr_disk,reduced_addr_layer}),    // Read address bus, width determined from RAM_DEPTH
            .dina(10'b0),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(base_der_addr)     // RAM output data, width determined from RAM_WIDTH
        );    
  
    // Apply alpha correction to the base address  
    // address bit size depends on ALPHA_NBITS too
    reg [9:0] der_addr;
    reg [9:0] base_der_addr_pipe1;
    reg [9:0] base_der_addr_pipe2;
    
    reg [(3*ALPHA_NBITS-1):0] alpha_corr;
    reg [(3*ALPHA_NBITS-1):0] alpha_corr1;
    reg [(3*ALPHA_NBITS-1):0] alpha_corr2;
    reg [(3*ALPHA_NBITS-1):0] alpha_corr3;
    reg [(3*ALPHA_NBITS-1):0] alpha_corr4;

    // alpha correction to base address
    reg [4:0] disk2s_pattern_pipe1;
    reg [4:0] disk2s_pattern_pipe2;
    reg [4:0] disk2s_pattern_pipe3;
    reg [4:0] disk2s_pattern_pipe4;
    reg [4:0] disk2s_pattern_pipe5;
    
    reg [5*ALPHA_NBITS-1:0] alpha_pipe1;
    reg [5*ALPHA_NBITS-1:0] alpha_pipe2;
    reg [5*ALPHA_NBITS-1:0] alpha_pipe3;
    reg [5*ALPHA_NBITS-1:0] alpha_pipe4;
    reg [5*ALPHA_NBITS-1:0] alpha_pipe5; 
    
    always @(posedge clk) begin
        // pipelining
        disk2s_pattern_pipe1 <= {hitpat_disk[8],hitpat_disk[6],hitpat_disk[4],hitpat_disk[2],hitpat_disk[0]};
        disk2s_pattern_pipe2 <= disk2s_pattern_pipe1;
        disk2s_pattern_pipe3 <= disk2s_pattern_pipe2;
        disk2s_pattern_pipe4 <= disk2s_pattern_pipe3;
        disk2s_pattern_pipe5 <= disk2s_pattern_pipe4;

        alpha_pipe1[5*ALPHA_NBITS-1:0] <= pre_alphas[5*ALPHA_NBITS-1:0];
        alpha_pipe2[5*ALPHA_NBITS-1:0] <= alpha_pipe1[5*ALPHA_NBITS-1:0];
        alpha_pipe3[5*ALPHA_NBITS-1:0] <= alpha_pipe2[5*ALPHA_NBITS-1:0];
        alpha_pipe4[5*ALPHA_NBITS-1:0] <= alpha_pipe3[5*ALPHA_NBITS-1:0];
        alpha_pipe5[5*ALPHA_NBITS-1:0] <= alpha_pipe4[5*ALPHA_NBITS-1:0];
        
        if (disk2s_pattern_pipe1[0]) // 2S hit in D5
            alpha_corr1[3*ALPHA_NBITS-1:0] <= {{2*ALPHA_NBITS{1'b0}}, alpha_pipe1[(ALPHA_NBITS-1):0]};
        else
            alpha_corr1[3*ALPHA_NBITS-1:0] <= {3*ALPHA_NBITS{1'b0}};
        
        if (disk2s_pattern_pipe2[1]) // 2S hit in D4
            alpha_corr2[3*ALPHA_NBITS-1:0] <= alpha_corr1 <<< ALPHA_NBITS | alpha_pipe2[(2*ALPHA_NBITS-1):(ALPHA_NBITS)];
        else
            alpha_corr2 <= alpha_corr1;
            
        if (disk2s_pattern_pipe3[2]) // 2S hit in D3
            alpha_corr3[3*ALPHA_NBITS-1:0] <= alpha_corr2 <<< ALPHA_NBITS | alpha_pipe3[(3*ALPHA_NBITS-1):(2*ALPHA_NBITS)];
        else
            alpha_corr3 <= alpha_corr2;
            
        if (disk2s_pattern_pipe4[3]) // 2S hit in D2
            alpha_corr4[3*ALPHA_NBITS-1:0] <= alpha_corr3 <<< ALPHA_NBITS | alpha_pipe4[(4*ALPHA_NBITS-1):(3*ALPHA_NBITS)];
        else
            alpha_corr4 <= alpha_corr3;
            
        if (disk2s_pattern_pipe5[4]) // 2S hit in D1
            alpha_corr[3*ALPHA_NBITS-1:0] <= alpha_corr4 <<< ALPHA_NBITS | alpha_pipe5[(5*ALPHA_NBITS-1):(4*ALPHA_NBITS)];
        else
            alpha_corr <= alpha_corr4;
        
        base_der_addr_pipe1 <= base_der_addr;
        base_der_addr_pipe2 <= base_der_addr_pipe1;
        
        der_addr <= base_der_addr_pipe2 + alpha_corr[3*ALPHA_NBITS-1:0];

    end
        
    ///////////////////////////////////////////////////////////////////// 
    // Read derivative LUT using der_addr
    //
    wire [(4*DERWIDTH_PHI-1):0] der_Rinv_dphi;
    wire [(4*DERWIDTH_PHI-1):0] der_Phi0_dphi;
    wire [(4*DERWIDTH_PHI-1):0] der_T_dphi;
    wire [(4*DERWIDTH_PHI-1):0] der_Z0_dphi;
    wire [(4*DERWIDTH_ZR-1):0] der_Rinv_dzordr;
    wire [(4*DERWIDTH_ZR-1):0] der_Phi0_dzordr;
    wire [(4*DERWIDTH_ZR-1):0] der_T_dzordr;
    wire [(4*DERWIDTH_ZR-1):0] der_Z0_dzordr;
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_PHI),                       // Specify RAM data width
            .RAM_DEPTH(1024),   //19710                  // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_RINV_DPHI),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_Rinv_dphi (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_PHI{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_Rinv_dphi)     // RAM output data, width determined from RAM_WIDTH
        );
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_PHI),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_PHI0_DPHI),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_Phi0_dphi (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_PHI{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_Phi0_dphi)     // RAM output data, width determined from RAM_WIDTH
        );
   
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_PHI),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_T_DPHI),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_T_dphi (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_PHI{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_T_dphi)     // RAM output data, width determined from RAM_WIDTH
        );
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_PHI),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_Z0_DPHI),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_Z0_dphi (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_PHI{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_Z0_dphi)     // RAM output data, width determined from RAM_WIDTH
        );
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_ZR),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_RINV_DZORDR),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_Rinv_dzordr (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_ZR{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_Rinv_dzordr)     // RAM output data, width determined from RAM_WIDTH
        );
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_ZR),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_PHI0_DZORDR),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_Phi0_dzordr (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_ZR{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_Phi0_dzordr)     // RAM output data, width determined from RAM_WIDTH
        );
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_ZR),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_T_DZORDR),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_T_dzordr (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_ZR{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_T_dzordr)     // RAM output data, width determined from RAM_WIDTH
        );
    
    Memory #(
            .RAM_WIDTH(4*DERWIDTH_ZR),                       // Specify RAM data width
            .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
            .INIT_FILE(TABLE_Z0_DZORDR),                        // Specify name/location of RAM initialization file if using one (leave blank if not)
            .HEX(0)
          ) lookup_Z0_dzordr (
            .addra(10'b0),    // Write address bus, width determined from RAM_DEPTH
            .addrb(der_addr[9:0]),    // Read address bus, width determined from RAM_DEPTH
            .dina({4*DERWIDTH_ZR{1'b0}}),      // RAM input data, width determined from RAM_WIDTH
            .clka(clk),      // Write clock
            .clkb(clk),      // Read clock
            .wea(1'b0),        // Write enable
            .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use // Maybe don't read add = 6'h3f?
            .rstb(rst_pipe),      // Output reset (does not affect memory contents)
            .regceb(1'b1),  // Output register enable
            .doutb(der_Z0_dzordr)     // RAM output data, width determined from RAM_WIDTH
        );
    
    // Step 0: Read the residuals from track_matches_dly
    // Declare:
    reg signed [11:0] iphi_res_a[0:3];   // Input1,2,3,4
    reg signed [8:0]   izor_res_a[0:3];  // Input1,2,3,4
    wire       [11:0] iphi_res_sh_a[0:3];   // shifted
    wire       [8:0]   izor_res_sh_a[0:3];  // shifted


   wire [13:0] 	       irinv_tpar_new;   
   wire [13:0] 	       irinv_tpar_sh;
   wire [13:0] 	       irinv_tpar_sh2; //just to debug   
   wire [17:0] 	       iphi0_tpar_new;   
   wire [17:0] 	       iphi0_tpar_sh;
   wire [17:0] 	       iphi0_tpar_sh2; //just to debug   
   wire [13:0] 	       it_tpar_new;   
   wire [13:0] 	       it_tpar_sh;
   wire [13:0] 	       it_tpar_sh2; //just to debug   
   wire [9:0] 	       iz0_tpar_new;   
   wire [9:0] 	       iz0_tpar_sh;
   wire [9:0] 	       iz0_tpar_sh2; //just to debug   
   

//    reg signed [11:0] iphi_res_1;   // Input1   
//    reg signed [8:0]  izor_res_1;   // Input1
//    reg signed [11:0] iphi_res_2;   // Input2
//    reg signed [8:0]  izor_res_2;   // Input2
//    reg signed [11:0] iphi_res_3;   // Input3
//    reg signed [8:0]  izor_res_3;   // Input3
//    reg signed [11:0] iphi_res_4;   // Input4
//   reg signed [8:0]  izor_res_4;   // Input4
        
    always @(posedge clk) begin
        iphi_res_a[0] <= track_matches_dly[83:72];
        iphi_res_a[1] <= track_matches_dly[62:51];
        iphi_res_a[2] <= track_matches_dly[41:30];
        iphi_res_a[3] <= track_matches_dly[20:9];
        izor_res_a[0] <= track_matches_dly[71:63];
        izor_res_a[1] <= track_matches_dly[50:42];
        izor_res_a[2] <= track_matches_dly[29:21];
        izor_res_a[3] <= track_matches_dly[8:0];   
//        iphi_res_1 <= track_matches_dly[83:72];
//        iphi_res_2 <= track_matches_dly[62:51];
//        iphi_res_3 <= track_matches_dly[41:30];
//        iphi_res_4 <= track_matches_dly[20:9];
        // izor_res_1 <= track_matches_dly[71:63];
        // izor_res_2 <= track_matches_dly[50:42];
        // izor_res_3 <= track_matches_dly[29:21];
        // izor_res_4 <= track_matches_dly[8:0];
       
    end

   
    // Step 1: Calculate corrections from each residual
    // Declare:
    
    // CHECK DATA WIDTH 
    // CURRENTLY: dphi_res - 12 bits; dzdr_res - 9 bits; dphi_der - 16 bits; dzdr_der - 14 bits
    
    //MT Nov 13 2017
    wire [47:0] irinv_corr_dsp_a[0:7]  ; //using full precision allowed by dsp;
    wire [47:0] iphi0_corr_dsp_a[0:7]  ;  
    wire [47:0] it_corr_dsp_a[0:7]     ;     
    wire [47:0] iz0_corr_dsp_a[0:7]    ;    
    	  
    wire [47:0] irinv_corr_dspdebug_a[0:7] ; 
    wire [47:0] iphi0_corr_dspdebug_a[0:7]  ;  
    wire [47:0] it_corr_dspdebug_a[0:7]     ;     
    wire [47:0] iz0_corr_dspdebug_a[0:7]    ;

    //MT Jan 9 2018
    wire [47:0] ipt_a; //using full precision allowed by dsp;
    wire [47:0] iphi0_a; //using full precision allowed by dsp;
    wire [47:0] it_a; //using full precision allowed by dsp;
    wire [47:0] iz0_a; //using full precision allowed by dsp;           
  


   
    reg signed [21:0] irinv_corr_dphi_a[0:3];    // correction to rinv,phi0,t,z0 from phi residual of Input1,2,3,4
    reg signed [21:0] iphi0_corr_dphi_a[0:3];  
    reg signed [21:0] it_corr_dphi_a[0:3]   ;     
    reg signed [21:0] iz0_corr_dphi_a[0:3]  ;    

    reg signed [21:0] irinv_corr_dzordr_a[0:3];  // correction to rinv,phi0,t,z0 from z (or r) residual of Input1,2,3,4
    reg signed [21:0] iphi0_corr_dzordr_a[0:3];  
    reg signed [21:0] it_corr_dzordr_a[0:3]   ;     
    reg signed [21:0] iz0_corr_dzordr_a[0:3]  ;    
   
   
    // reg signed [21:0] irinv_corr_dphi_1;    // correction to rinv from phi residual of Input1
    // reg signed [21:0] iphi0_corr_dphi_1;  
    // reg signed [21:0] it_corr_dphi_1;     
    // Reg signed [21:0] iz0_corr_dphi_1;    
    // reg signed [21:0] irinv_corr_dphi_2;
    // reg signed [21:0] iphi0_corr_dphi_2;    // correction to phi0 from phi residual of Input2
    // reg signed [21:0] it_corr_dphi_2;
    // reg signed [21:0] iz0_corr_dphi_2;     
    // reg signed [21:0] irinv_corr_dphi_3;
    // reg signed [21:0] iphi0_corr_dphi_3;
    // reg signed [21:0] it_corr_dphi_3;       // correction to t from phi residual of Input3
    // reg signed [21:0] iz0_corr_dphi_3;     
    // reg signed [21:0] irinv_corr_dphi_4;
    // reg signed [21:0] iphi0_corr_dphi_4;
    // reg signed [21:0] it_corr_dphi_4;
    // reg signed [21:0] iz0_corr_dphi_4;      // correction to z0 from phi residual of Input1
    // reg signed [21:0] irinv_corr_dzordr_1;  
    // reg signed [21:0] iphi0_corr_dzordr_1;  
    // reg signed [21:0] it_corr_dzordr_1;     
    // reg signed [21:0] iz0_corr_dzordr_1;    // correction to z0 from z (or r) residual of Input1
    // reg signed [21:0] irinv_corr_dzordr_2;
    // reg signed [21:0] iphi0_corr_dzordr_2;
    // reg signed [21:0] it_corr_dzordr_2;     // correction to t from z (or r) residual of Input2
    // reg signed [21:0] iz0_corr_dzordr_2;     
    // reg signed [21:0] irinv_corr_dzordr_3;
    // reg signed [21:0] iphi0_corr_dzordr_3;  // correction to phi0 from z (or r) residual of Input3
    // reg signed [21:0] it_corr_dzordr_3;
    // reg signed [21:0] iz0_corr_dzordr_3;     
    // reg signed [21:0] irinv_corr_dzordr_4;  // correction to rinv from z (or r) residual of Input4
    // reg signed [21:0] iphi0_corr_dzordr_4;
    // reg signed [21:0] it_corr_dzordr_4;
    // reg signed [21:0] iz0_corr_dzordr_4;
    
    reg signed [DERWIDTH_PHI-1:0] der_Rinv_dphi_a[0:3];
    reg signed [DERWIDTH_PHI-1:0] der_Phi0_dphi_a[0:3];
    reg signed [DERWIDTH_PHI-1:0] der_T_dphi_a[0:3];
    reg signed [DERWIDTH_PHI-1:0] der_Z0_dphi_a[0:3];
    reg signed [DERWIDTH_ZR-1:0] der_Rinv_dzordr_a[0:3];
    reg signed [DERWIDTH_ZR-1:0] der_Phi0_dzordr_a[0:3];
    reg signed [DERWIDTH_ZR-1:0] der_T_dzordr_a[0:3];
    reg signed [DERWIDTH_ZR-1:0] der_Z0_dzordr_a[0:3];

    wire [DERWIDTH_PHI-1:0] der_Rinv_dphi_sh_a[0:3]; //shifted
    wire [DERWIDTH_ZR-1:0] der_Rinv_dzordr_sh_a[0:3];
    wire [DERWIDTH_PHI-1:0] der_Phi0_dphi_sh_a[0:3]; //shifted
    wire [DERWIDTH_ZR-1:0] der_Phi0_dzordr_sh_a[0:3];
    wire [DERWIDTH_PHI-1:0] der_T_dphi_sh_a[0:3]; //shifted
    wire [DERWIDTH_ZR-1:0] der_T_dzordr_sh_a[0:3];
    wire [DERWIDTH_PHI-1:0] der_Z0_dphi_sh_a[0:3]; //shifted
    wire [DERWIDTH_ZR-1:0] der_Z0_dzordr_sh_a[0:3];

    
   
    // reg signed [DERWIDTH_PHI-1:0] der_Rinv_dphi_1;
    // reg signed [DERWIDTH_PHI-1:0] der_Rinv_dphi_2;
    // reg signed [DERWIDTH_PHI-1:0] der_Rinv_dphi_3;
    // reg signed [DERWIDTH_PHI-1:0] der_Rinv_dphi_4;
    // reg signed [DERWIDTH_PHI-1:0] der_Phi0_dphi_1;
    // reg signed [DERWIDTH_PHI-1:0] der_Phi0_dphi_2;
    // reg signed [DERWIDTH_PHI-1:0] der_Phi0_dphi_3;
    // reg signed [DERWIDTH_PHI-1:0] der_Phi0_dphi_4;
    // reg signed [DERWIDTH_PHI-1:0] der_T_dphi_1;
    // reg signed [DERWIDTH_PHI-1:0] der_T_dphi_2;
    // reg signed [DERWIDTH_PHI-1:0] der_T_dphi_3;
    // reg signed [DERWIDTH_PHI-1:0] der_T_dphi_4;
    // reg signed [DERWIDTH_PHI-1:0] der_Z0_dphi_1;
    // reg signed [DERWIDTH_PHI-1:0] der_Z0_dphi_2;
    // reg signed [DERWIDTH_PHI-1:0] der_Z0_dphi_3;
    // reg signed [DERWIDTH_PHI-1:0] der_Z0_dphi_4;
    // reg signed [DERWIDTH_ZR-1:0] der_Rinv_dzordr_1;
    // reg signed [DERWIDTH_ZR-1:0] der_Rinv_dzordr_2;
    // reg signed [DERWIDTH_ZR-1:0] der_Rinv_dzordr_3;
    // reg signed [DERWIDTH_ZR-1:0] der_Rinv_dzordr_4;
    // reg signed [DERWIDTH_ZR-1:0] der_Phi0_dzordr_1;
    // reg signed [DERWIDTH_ZR-1:0] der_Phi0_dzordr_2;
    // reg signed [DERWIDTH_ZR-1:0] der_Phi0_dzordr_3;
    // reg signed [DERWIDTH_ZR-1:0] der_Phi0_dzordr_4;
    // reg signed [DERWIDTH_ZR-1:0] der_T_dzordr_1;
    // reg signed [DERWIDTH_ZR-1:0] der_T_dzordr_2;
    // reg signed [DERWIDTH_ZR-1:0] der_T_dzordr_3;
    // reg signed [DERWIDTH_ZR-1:0] der_T_dzordr_4;
    // reg signed [DERWIDTH_ZR-1:0] der_Z0_dzordr_1;
    // reg signed [DERWIDTH_ZR-1:0] der_Z0_dzordr_2;
    // reg signed [DERWIDTH_ZR-1:0] der_Z0_dzordr_3;
    // reg signed [DERWIDTH_ZR-1:0] der_Z0_dzordr_4;
    
    always @(posedge clk) begin

        der_Rinv_dphi_a[0]   <= der_Rinv_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        der_Rinv_dphi_a[1]   <= der_Rinv_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        der_Rinv_dphi_a[2]   <= der_Rinv_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        der_Rinv_dphi_a[3]   <= der_Rinv_dphi[DERWIDTH_PHI-1:0];
        der_Phi0_dphi_a[0]   <= der_Phi0_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        der_Phi0_dphi_a[1]   <= der_Phi0_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        der_Phi0_dphi_a[2]   <= der_Phi0_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        der_Phi0_dphi_a[3]   <= der_Phi0_dphi[DERWIDTH_PHI-1:0];
        der_T_dphi_a[0]      <= der_T_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        der_T_dphi_a[1]      <= der_T_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        der_T_dphi_a[2]      <= der_T_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        der_T_dphi_a[3]      <= der_T_dphi[DERWIDTH_PHI-1:0];
        der_Z0_dphi_a[0]     <= der_Z0_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        der_Z0_dphi_a[1]     <= der_Z0_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        der_Z0_dphi_a[2]     <= der_Z0_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        der_Z0_dphi_a[3]     <= der_Z0_dphi[DERWIDTH_PHI-1:0];
        der_Rinv_dzordr_a[0] <= der_Rinv_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        der_Rinv_dzordr_a[1] <= der_Rinv_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        der_Rinv_dzordr_a[2] <= der_Rinv_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        der_Rinv_dzordr_a[3] <= der_Rinv_dzordr[DERWIDTH_ZR-1:0];
        der_Phi0_dzordr_a[0] <= der_Phi0_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        der_Phi0_dzordr_a[1] <= der_Phi0_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        der_Phi0_dzordr_a[2] <= der_Phi0_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        der_Phi0_dzordr_a[3] <= der_Phi0_dzordr[DERWIDTH_ZR-1:0];
        der_T_dzordr_a[0]    <= der_T_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        der_T_dzordr_a[1]    <= der_T_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        der_T_dzordr_a[2]    <= der_T_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        der_T_dzordr_a[3]    <= der_T_dzordr[DERWIDTH_ZR-1:0];
        der_Z0_dzordr_a[0]   <= der_Z0_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        der_Z0_dzordr_a[1]   <= der_Z0_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        der_Z0_dzordr_a[2]   <= der_Z0_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        der_Z0_dzordr_a[3]   <= der_Z0_dzordr[DERWIDTH_ZR-1:0];



        // der_Rinv_dphi_1 <= der_Rinv_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        // der_Rinv_dphi_2 <= der_Rinv_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        // der_Rinv_dphi_3 <= der_Rinv_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        // der_Rinv_dphi_4 <= der_Rinv_dphi[DERWIDTH_PHI-1:0];
        // der_Phi0_dphi_1 <= der_Phi0_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        // der_Phi0_dphi_2 <= der_Phi0_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        // der_Phi0_dphi_3 <= der_Phi0_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        // der_Phi0_dphi_4 <= der_Phi0_dphi[DERWIDTH_PHI-1:0];
        // der_T_dphi_1 <= der_T_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        // der_T_dphi_2 <= der_T_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        // der_T_dphi_3 <= der_T_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        // der_T_dphi_4 <= der_T_dphi[DERWIDTH_PHI-1:0];
        // der_Z0_dphi_1 <= der_Z0_dphi[4*DERWIDTH_PHI-1:3*DERWIDTH_PHI];
        // der_Z0_dphi_2 <= der_Z0_dphi[3*DERWIDTH_PHI-1:2*DERWIDTH_PHI];
        // der_Z0_dphi_3 <= der_Z0_dphi[2*DERWIDTH_PHI-1:DERWIDTH_PHI];
        // der_Z0_dphi_4 <= der_Z0_dphi[DERWIDTH_PHI-1:0];
        // der_Rinv_dzordr_1 <= der_Rinv_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        // der_Rinv_dzordr_2 <= der_Rinv_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        // der_Rinv_dzordr_3 <= der_Rinv_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        // der_Rinv_dzordr_4 <= der_Rinv_dzordr[DERWIDTH_ZR-1:0];
        // der_Phi0_dzordr_1 <= der_Phi0_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        // der_Phi0_dzordr_2 <= der_Phi0_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        // der_Phi0_dzordr_3 <= der_Phi0_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        // der_Phi0_dzordr_4 <= der_Phi0_dzordr[DERWIDTH_ZR-1:0];
        // der_T_dzordr_1 <= der_T_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        // der_T_dzordr_2 <= der_T_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        // der_T_dzordr_3 <= der_T_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        // der_T_dzordr_4 <= der_T_dzordr[DERWIDTH_ZR-1:0];
        // der_Z0_dzordr_1 <= der_Z0_dzordr[4*DERWIDTH_ZR-1:3*DERWIDTH_ZR];
        // der_Z0_dzordr_2 <= der_Z0_dzordr[3*DERWIDTH_ZR-1:2*DERWIDTH_ZR];
        // der_Z0_dzordr_3 <= der_Z0_dzordr[2*DERWIDTH_ZR-1:DERWIDTH_ZR];
        // der_Z0_dzordr_4 <= der_Z0_dzordr[DERWIDTH_ZR-1:0];
        

        irinv_corr_dphi_a[0]   <= iphi_res_a[0] * der_Rinv_dphi_a[0];
        irinv_corr_dphi_a[1]   <= iphi_res_a[1] * der_Rinv_dphi_a[1];
        irinv_corr_dphi_a[2]   <= iphi_res_a[2] * der_Rinv_dphi_a[2];
        irinv_corr_dphi_a[3]   <= iphi_res_a[3] * der_Rinv_dphi_a[3];
		       	       
        iphi0_corr_dphi_a[0]   <= iphi_res_a[0] * der_Phi0_dphi_a[0];
        iphi0_corr_dphi_a[1]   <= iphi_res_a[1] * der_Phi0_dphi_a[1];
        iphi0_corr_dphi_a[2]   <= iphi_res_a[2] * der_Phi0_dphi_a[2];
        iphi0_corr_dphi_a[3]   <= iphi_res_a[3] * der_Phi0_dphi_a[3];
        		       
        it_corr_dphi_a[0]      <= iphi_res_a[0] * der_T_dphi_a[0];
        it_corr_dphi_a[1]      <= iphi_res_a[1] * der_T_dphi_a[1];
        it_corr_dphi_a[2]      <= iphi_res_a[2] * der_T_dphi_a[2];
        it_corr_dphi_a[3]      <= iphi_res_a[3] * der_T_dphi_a[3]; 
        	               
        iz0_corr_dphi_a[0]     <= iphi_res_a[0] * der_Z0_dphi_a[0];
        iz0_corr_dphi_a[1]     <= iphi_res_a[1] * der_Z0_dphi_a[1];
        iz0_corr_dphi_a[2]     <= iphi_res_a[2] * der_Z0_dphi_a[2];
        iz0_corr_dphi_a[3]     <= iphi_res_a[3] * der_Z0_dphi_a[3];

        irinv_corr_dzordr_a[0] <= izor_res_a[0] * der_Rinv_dzordr_a[0];
        irinv_corr_dzordr_a[1] <= izor_res_a[1] * der_Rinv_dzordr_a[1];
        irinv_corr_dzordr_a[2] <= izor_res_a[2] * der_Rinv_dzordr_a[2];
        irinv_corr_dzordr_a[3] <= izor_res_a[3] * der_Rinv_dzordr_a[3];
        
        iphi0_corr_dzordr_a[0] <= izor_res_a[0] * der_Phi0_dzordr_a[0];
        iphi0_corr_dzordr_a[1] <= izor_res_a[1] * der_Phi0_dzordr_a[1];
        iphi0_corr_dzordr_a[2] <= izor_res_a[2] * der_Phi0_dzordr_a[2];
        iphi0_corr_dzordr_a[3] <= izor_res_a[3] * der_Phi0_dzordr_a[3];
        
        it_corr_dzordr_a[0]    <= izor_res_a[0] * der_T_dzordr_a[0];
        it_corr_dzordr_a[1]    <= izor_res_a[1] * der_T_dzordr_a[1];
        it_corr_dzordr_a[2]    <= izor_res_a[2] * der_T_dzordr_a[2];
        it_corr_dzordr_a[3]    <= izor_res_a[3] * der_T_dzordr_a[3]; 
        		       
        iz0_corr_dzordr_a[0]   <= izor_res_a[0] * der_Z0_dzordr_a[0];
        iz0_corr_dzordr_a[1]   <= izor_res_a[1] * der_Z0_dzordr_a[1];
        iz0_corr_dzordr_a[2]   <= izor_res_a[2] * der_Z0_dzordr_a[2];
        iz0_corr_dzordr_a[3]   <= izor_res_a[3] * der_Z0_dzordr_a[3];     
       
       
        // irinv_corr_dphi_1 <= iphi_res_1 * der_Rinv_dphi_1;
        // irinv_corr_dphi_2 <= iphi_res_2 * der_Rinv_dphi_2;
        // irinv_corr_dphi_3 <= iphi_res_3 * der_Rinv_dphi_3;
        // irinv_corr_dphi_4 <= iphi_res_4 * der_Rinv_dphi_4;
       
        
        // iphi0_corr_dphi_1 <= iphi_res_1 * der_Phi0_dphi_1;
        // iphi0_corr_dphi_2 <= iphi_res_2 * der_Phi0_dphi_2;
        // iphi0_corr_dphi_3 <= iphi_res_3 * der_Phi0_dphi_3;
        // iphi0_corr_dphi_4 <= iphi_res_4 * der_Phi0_dphi_4;
        
        // it_corr_dphi_1 <= iphi_res_1 * der_T_dphi_1;
        // it_corr_dphi_2 <= iphi_res_2 * der_T_dphi_2;
        // it_corr_dphi_3 <= iphi_res_3 * der_T_dphi_3;
        // it_corr_dphi_4 <= iphi_res_4 * der_T_dphi_4; 
        
        // iz0_corr_dphi_1 <= iphi_res_1 * der_Z0_dphi_1;
        // iz0_corr_dphi_2 <= iphi_res_2 * der_Z0_dphi_2;
        // iz0_corr_dphi_3 <= iphi_res_3 * der_Z0_dphi_3;
        // iz0_corr_dphi_4 <= iphi_res_4 * der_Z0_dphi_4;
        
        // irinv_corr_dzordr_1 <= izor_res_1 * der_Rinv_dzordr_1;
        // irinv_corr_dzordr_2 <= izor_res_2 * der_Rinv_dzordr_2;
        // irinv_corr_dzordr_3 <= izor_res_3 * der_Rinv_dzordr_3;
        // irinv_corr_dzordr_4 <= izor_res_4 * der_Rinv_dzordr_4;
        
        // iphi0_corr_dzordr_1 <= izor_res_1 * der_Phi0_dzordr_1;
        // iphi0_corr_dzordr_2 <= izor_res_2 * der_Phi0_dzordr_2;
        // iphi0_corr_dzordr_3 <= izor_res_3 * der_Phi0_dzordr_3;
        // iphi0_corr_dzordr_4 <= izor_res_4 * der_Phi0_dzordr_4;
        
        // it_corr_dzordr_1 <= izor_res_1 * der_T_dzordr_1;
        // it_corr_dzordr_2 <= izor_res_2 * der_T_dzordr_2;
        // it_corr_dzordr_3 <= izor_res_3 * der_T_dzordr_3;
        // it_corr_dzordr_4 <= izor_res_4 * der_T_dzordr_4; 
        
        // iz0_corr_dzordr_1 <= izor_res_1 * der_Z0_dzordr_1;
        // iz0_corr_dzordr_2 <= izor_res_2 * der_Z0_dzordr_2;
        // iz0_corr_dzordr_3 <= izor_res_3 * der_Z0_dzordr_3;
        // iz0_corr_dzordr_4 <= izor_res_4 * der_Z0_dzordr_4;     
    end


   //MT Jan 17 crossing clk domains
   //wire clk_new;
   
   wire               almostempty_iphi_res_a[0:3];
   wire 	      almostfull_iphi_res_a[0:3];   
   wire 	      empty_iphi_res_a[0:3];
   wire 	      full_iphi_res_a[0:3];
   wire 	      rderr_iphi_res_a[0:3];
   wire 	      wrerr_iphi_res_a[0:3];         
   wire [9:0] 	      rdcount_iphi_res_a[0:3];
   wire [9:0] 	      wrcount_iphi_res_a[0:3];
   wire 	      rden_iphi_res_a[0:3];
   wire 	      wren_iphi_res_a[0:3];
   wire 	      rst_iphi_res_a[0:3];   
   wire signed [11:0] iphi_res_a_new[0:3];

   wire 	      almostempty_izor_res_a[0:3];
   wire 	      almostfull_izor_res_a[0:3];   
   wire 	      empty_izor_res_a[0:3];
   wire 	      full_izor_res_a[0:3];
   wire 	      rderr_izor_res_a[0:3];
   wire 	      wrerr_izor_res_a[0:3];         
   wire 	      rden_izor_res_a[0:3];
   wire 	      wren_izor_res_a[0:3];
   wire 	      rst_izor_res_a[0:3];   
   wire signed [8:0] izor_res_a_new[0:3];
   
   wire 	                  almostempty_der_Rinv_dphi_a[0:3];
   wire 			  almostfull_der_Rinv_dphi_a[0:3];   
   wire 			  empty_der_Rinv_dphi_a[0:3];
   wire 			  full_der_Rinv_dphi_a[0:3];
   wire 			  rderr_der_Rinv_dphi_a[0:3];
   wire 			  wrerr_der_Rinv_dphi_a[0:3];         
   wire 			  rden_der_Rinv_dphi_a[0:3];
   wire 			  wren_der_Rinv_dphi_a[0:3];
   wire 			  rst_der_Rinv_dphi_a[0:3];      
   wire signed [DERWIDTH_PHI-1:0] der_Rinv_dphi_a_new[0:3];   

   wire 			  almostempty_der_Rinv_dzordr_a[0:3];
   wire 			  almostfull_der_Rinv_dzordr_a[0:3];   
   wire 			  empty_der_Rinv_dzordr_a[0:3];
   wire 			  full_der_Rinv_dzordr_a[0:3];
   wire 			  rderr_der_Rinv_dzordr_a[0:3];
   wire 			  wrerr_der_Rinv_dzordr_a[0:3];         
   wire 			  rden_der_Rinv_dzordr_a[0:3];
   wire 			  wren_der_Rinv_dzordr_a[0:3];
   wire 			  rst_der_Rinv_dzordr_a[0:3];         
   wire signed [DERWIDTH_ZR-1:0] der_Rinv_dzordr_a_new[0:3];   
   
   wire 	                  almostempty_der_Phi0_dphi_a[0:3];
   wire 			  almostfull_der_Phi0_dphi_a[0:3];   
   wire 			  empty_der_Phi0_dphi_a[0:3];
   wire 			  full_der_Phi0_dphi_a[0:3];
   wire 			  rderr_der_Phi0_dphi_a[0:3];
   wire 			  wrerr_der_Phi0_dphi_a[0:3];         
   wire 			  rden_der_Phi0_dphi_a[0:3];
   wire 			  wren_der_Phi0_dphi_a[0:3];
   wire 			  rst_der_Phi0_dphi_a[0:3];      
   wire signed [DERWIDTH_PHI-1:0] der_Phi0_dphi_a_new[0:3];   

   wire 			  almostempty_der_Phi0_dzordr_a[0:3];
   wire 			  almostfull_der_Phi0_dzordr_a[0:3];   
   wire 			  empty_der_Phi0_dzordr_a[0:3];
   wire 			  full_der_Phi0_dzordr_a[0:3];
   wire 			  rderr_der_Phi0_dzordr_a[0:3];
   wire 			  wrerr_der_Phi0_dzordr_a[0:3];         
   wire 			  rden_der_Phi0_dzordr_a[0:3];
   wire 			  wren_der_Phi0_dzordr_a[0:3];
   wire 			  rst_der_Phi0_dzordr_a[0:3];         
   wire signed [DERWIDTH_ZR-1:0] der_Phi0_dzordr_a_new[0:3];   
   
   wire 	                  almostempty_der_T_dphi_a[0:3];
   wire 			  almostfull_der_T_dphi_a[0:3];   
   wire 			  empty_der_T_dphi_a[0:3];
   wire 			  full_der_T_dphi_a[0:3];
   wire 			  rderr_der_T_dphi_a[0:3];
   wire 			  wrerr_der_T_dphi_a[0:3];         
   wire 			  rden_der_T_dphi_a[0:3];
   wire 			  wren_der_T_dphi_a[0:3];
   wire 			  rst_der_T_dphi_a[0:3];      
   wire signed [DERWIDTH_PHI-1:0] der_T_dphi_a_new[0:3];   

   wire 			  almostempty_der_T_dzordr_a[0:3];
   wire 			  almostfull_der_T_dzordr_a[0:3];   
   wire 			  empty_der_T_dzordr_a[0:3];
   wire 			  full_der_T_dzordr_a[0:3];
   wire 			  rderr_der_T_dzordr_a[0:3];
   wire 			  wrerr_der_T_dzordr_a[0:3];         
   wire 			  rden_der_T_dzordr_a[0:3];
   wire 			  wren_der_T_dzordr_a[0:3];
   wire 			  rst_der_T_dzordr_a[0:3];         
   wire signed [DERWIDTH_ZR-1:0] der_T_dzordr_a_new[0:3];   
   
   wire 	                  almostempty_der_Z0_dphi_a[0:3];
   wire 			  almostfull_der_Z0_dphi_a[0:3];   
   wire 			  empty_der_Z0_dphi_a[0:3];
   wire 			  full_der_Z0_dphi_a[0:3];
   wire 			  rderr_der_Z0_dphi_a[0:3];
   wire 			  wrerr_der_Z0_dphi_a[0:3];         
   wire 			  rden_der_Z0_dphi_a[0:3];
   wire 			  wren_der_Z0_dphi_a[0:3];
   wire 			  rst_der_Z0_dphi_a[0:3];      
   wire signed [DERWIDTH_PHI-1:0] der_Z0_dphi_a_new[0:3];   

   wire 			  almostempty_der_Z0_dzordr_a[0:3];
   wire 			  almostfull_der_Z0_dzordr_a[0:3];   
   wire 			  empty_der_Z0_dzordr_a[0:3];
   wire 			  full_der_Z0_dzordr_a[0:3];
   wire 			  rderr_der_Z0_dzordr_a[0:3];
   wire 			  wrerr_der_Z0_dzordr_a[0:3];         
   wire 			  rden_der_Z0_dzordr_a[0:3];
   wire 			  wren_der_Z0_dzordr_a[0:3];
   wire 			  rst_der_Z0_dzordr_a[0:3];         
   wire signed [DERWIDTH_ZR-1:0] der_Z0_dzordr_a_new[0:3];   
   

   //MT Jan 22 2018
   wire 			 CLKFBIN;   
   wire 			 CLKFBOUT;
   wire 			 locked;  
   wire 			 clkout_bufg;
   wire 			 rst;
   assign rst = 1'b0;


   //MT Jan 22 2018
   //MT: coming from top file
   // MMCM mmcm_inst
   //   (
   //    .clk_in1(clk),      
   //    // Clock out ports
   //    .clk_out1(clk_new),    
   //    .reset(rst), 
   //    .locked(locked)
   //    );
         




   genvar 	     ip;
   for ( ip = 0; ip < 4; ip = ip + 1 ) begin   
      assign rst_iphi_res_a[ip] = 1'b0;
      assign wren_iphi_res_a[ip] = 1'b1; //always writing
      assign rden_iphi_res_a[ip] = 1'b1; //always reading

      assign rst_izor_res_a[ip] = 1'b0;
      assign wren_izor_res_a[ip] = 1'b1; //always writing
      assign rden_izor_res_a[ip] = 1'b1; //always reading

      assign rst_der_Rinv_dphi_a[ip] = 1'b0;
      assign wren_der_Rinv_dphi_a[ip] = 1'b1; //always writing
      assign rden_der_Rinv_dphi_a[ip] = 1'b1; //always reading

      assign rst_der_Rinv_dzordr_a[ip] = 1'b0;
      assign wren_der_Rinv_dzordr_a[ip] = 1'b1; //always writing
      assign rden_der_Rinv_dzordr_a[ip] = 1'b1; //always reading
      
      assign rst_der_Phi0_dphi_a[ip] = 1'b0;
      assign wren_der_Phi0_dphi_a[ip] = 1'b1; //always writing
      assign rden_der_Phi0_dphi_a[ip] = 1'b1; //always reading

      assign rst_der_Phi0_dzordr_a[ip] = 1'b0;
      assign wren_der_Phi0_dzordr_a[ip] = 1'b1; //always writing
      assign rden_der_Phi0_dzordr_a[ip] = 1'b1; //always reading

      assign rst_der_T_dphi_a[ip] = 1'b0;
      assign wren_der_T_dphi_a[ip] = 1'b1; //always writing
      assign rden_der_T_dphi_a[ip] = 1'b1; //always reading

      assign rst_der_T_dzordr_a[ip] = 1'b0;
      assign wren_der_T_dzordr_a[ip] = 1'b1; //always writing
      assign rden_der_T_dzordr_a[ip] = 1'b1; //always reading

      assign rst_der_Z0_dphi_a[ip] = 1'b0;
      assign wren_der_Z0_dphi_a[ip] = 1'b1; //always writing
      assign rden_der_Z0_dphi_a[ip] = 1'b1; //always reading

      assign rst_der_Z0_dzordr_a[ip] = 1'b0;
      assign wren_der_Z0_dzordr_a[ip] = 1'b1; //always writing
      assign rden_der_Z0_dzordr_a[ip] = 1'b1; //always reading
   end
   
   
   //check how to tweak the latency: at the moment is 6 clks when wrclk=rdclk=clk. 26 is rdclk=clk_new, even though clk_new and clk have the same frequency -> why???
   
   //check if I can lower FIFO_SIZE
   //if it works move it to a different file and call only the object
   for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(12),                          // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_iphi_res_a (
         .ALMOSTEMPTY(almostempty_iphi_res_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_iphi_res_a[ip]),   // 1-bit output almost full
         .DO(iphi_res_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_iphi_res_a[ip]),             // 1-bit output empty
         .FULL(full_iphi_res_a[ip]),               // 1-bit output full
         .RDCOUNT(rdcount_iphi_res_a[ip]),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_iphi_res_a[ip]),             // 1-bit output read error
         .WRCOUNT(wrcount_iphi_res_a[ip]),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_iphi_res_a[ip]),             // 1-bit output write error
         .DI(iphi_res_a[ip]),                      // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                          // 1-bit input read clock
         .RDEN(rden_iphi_res_a[ip]),               // 1-bit input read enable
         .RST(rst_iphi_res_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                              // 1-bit input write clock
         .WREN(wren_iphi_res_a[ip])                // 1-bit input write enable
      );

      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(9),                          // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_izor_res_a (
         .ALMOSTEMPTY(almostempty_izor_res_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_izor_res_a[ip]),   // 1-bit output almost full
         .DO(izor_res_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_izor_res_a[ip]),             // 1-bit output empty
         .FULL(full_izor_res_a[ip]),               // 1-bit output full
         .RDCOUNT(), //rdcount_izor_res_a[ip]),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_izor_res_a[ip]),             // 1-bit output read error
         .WRCOUNT(),//wrcount_izor_res_a[ip]),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_izor_res_a[ip]),             // 1-bit output write error
         .DI(izor_res_a[ip]),                      // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                          // 1-bit input read clock
         .RDEN(rden_izor_res_a[ip]),               // 1-bit input read enable
         .RST(rst_izor_res_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                              // 1-bit input write clock
         .WREN(wren_izor_res_a[ip])                // 1-bit input write enable
      );
      
      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_PHI),                          // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_Rinv_dphi_a (
         .ALMOSTEMPTY(almostempty_der_Rinv_dphi_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_Rinv_dphi_a[ip]),   // 1-bit output almost full
         .DO(der_Rinv_dphi_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_Rinv_dphi_a[ip]),             // 1-bit output empty
         .FULL(full_der_Rinv_dphi_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_Rinv_dphi_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_Rinv_dphi_a[ip]),             // 1-bit output write error
         .DI(der_Rinv_dphi_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_Rinv_dphi_a[ip]),               // 1-bit input read enable
         .RST(rst_der_Rinv_dphi_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_Rinv_dphi_a[ip])                // 1-bit input write enable
      );

      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_ZR),                 // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_Rinv_dzordr_a (
         .ALMOSTEMPTY(almostempty_der_Rinv_dzordr_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_Rinv_dzordr_a[ip]),   // 1-bit output almost full
         .DO(der_Rinv_dzordr_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_Rinv_dzordr_a[ip]),             // 1-bit output empty
         .FULL(full_der_Rinv_dzordr_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_Rinv_dzordr_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_Rinv_dzordr_a[ip]),             // 1-bit output write error
         .DI(der_Rinv_dzordr_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_Rinv_dzordr_a[ip]),               // 1-bit input read enable
         .RST(rst_der_Rinv_dzordr_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_Rinv_dzordr_a[ip])                // 1-bit input write enable
      );
      
      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_PHI),                          // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_Phi0_dphi_a (
         .ALMOSTEMPTY(almostempty_der_Phi0_dphi_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_Phi0_dphi_a[ip]),   // 1-bit output almost full
         .DO(der_Phi0_dphi_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_Phi0_dphi_a[ip]),             // 1-bit output empty
         .FULL(full_der_Phi0_dphi_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_Phi0_dphi_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_Phi0_dphi_a[ip]),             // 1-bit output write error
         .DI(der_Phi0_dphi_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_Phi0_dphi_a[ip]),               // 1-bit input read enable
         .RST(rst_der_Phi0_dphi_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_Phi0_dphi_a[ip])                // 1-bit input write enable
      );

      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_ZR),                 // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_Phi0_dzordr_a (
         .ALMOSTEMPTY(almostempty_der_Phi0_dzordr_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_Phi0_dzordr_a[ip]),   // 1-bit output almost full
         .DO(der_Phi0_dzordr_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_Phi0_dzordr_a[ip]),             // 1-bit output empty
         .FULL(full_der_Phi0_dzordr_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_Phi0_dzordr_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_Phi0_dzordr_a[ip]),             // 1-bit output write error
         .DI(der_Phi0_dzordr_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_Phi0_dzordr_a[ip]),               // 1-bit input read enable
         .RST(rst_der_Phi0_dzordr_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_Phi0_dzordr_a[ip])                // 1-bit input write enable
      );
      
      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_PHI),                          // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_T_dphi_a (
         .ALMOSTEMPTY(almostempty_der_T_dphi_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_T_dphi_a[ip]),   // 1-bit output almost full
         .DO(der_T_dphi_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_T_dphi_a[ip]),             // 1-bit output empty
         .FULL(full_der_T_dphi_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_T_dphi_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_T_dphi_a[ip]),             // 1-bit output write error
         .DI(der_T_dphi_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_T_dphi_a[ip]),               // 1-bit input read enable
         .RST(rst_der_T_dphi_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_T_dphi_a[ip])                // 1-bit input write enable
      );

      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_ZR),                 // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_T_dzordr_a (
         .ALMOSTEMPTY(almostempty_der_T_dzordr_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_T_dzordr_a[ip]),   // 1-bit output almost full
         .DO(der_T_dzordr_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_T_dzordr_a[ip]),             // 1-bit output empty
         .FULL(full_der_T_dzordr_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_T_dzordr_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_T_dzordr_a[ip]),             // 1-bit output write error
         .DI(der_T_dzordr_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_T_dzordr_a[ip]),               // 1-bit input read enable
         .RST(rst_der_T_dzordr_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_T_dzordr_a[ip])                // 1-bit input write enable
      );
      
      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_PHI),                          // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_Z0_dphi_a (
         .ALMOSTEMPTY(almostempty_der_Z0_dphi_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_Z0_dphi_a[ip]),   // 1-bit output almost full
         .DO(der_Z0_dphi_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_Z0_dphi_a[ip]),             // 1-bit output empty
         .FULL(full_der_Z0_dphi_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_Z0_dphi_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_Z0_dphi_a[ip]),             // 1-bit output write error
         .DI(der_Z0_dphi_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_Z0_dphi_a[ip]),               // 1-bit input read enable
         .RST(rst_der_Z0_dphi_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_Z0_dphi_a[ip])                // 1-bit input write enable
      );

      FIFO_DUALCLOCK_MACRO  #( //from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo
         .ALMOST_EMPTY_OFFSET(9'h080),             // Sets the almost empty threshold
         .ALMOST_FULL_OFFSET(9'h080),              // Sets almost full threshold
         .DATA_WIDTH(DERWIDTH_ZR),                 // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
         .DEVICE("7SERIES"),                       // Target device: "7SERIES" 
         .FIFO_SIZE ("18Kb"),                      // Target BRAM: "18Kb" or "36Kb" 
         .FIRST_WORD_FALL_THROUGH ("FALSE")        // Sets the FIFO FWFT to "TRUE" or "FALSE" 
      ) FIFO_DUALCLOCK_MACRO_der_Z0_dzordr_a (
         .ALMOSTEMPTY(almostempty_der_Z0_dzordr_a[ip]), // 1-bit output almost empty
         .ALMOSTFULL(almostfull_der_Z0_dzordr_a[ip]),   // 1-bit output almost full
         .DO(der_Z0_dzordr_a_new[ip]),                  // Output data, width defined by DATA_WIDTH parameter
         .EMPTY(empty_der_Z0_dzordr_a[ip]),             // 1-bit output empty
         .FULL(full_der_Z0_dzordr_a[ip]),               // 1-bit output full
         .RDCOUNT(),         // Output read count, width determined by FIFO depth
         .RDERR(rderr_der_Z0_dzordr_a[ip]),             // 1-bit output read error
         .WRCOUNT(),         // Output write count, width determined by FIFO depth
         .WRERR(wrerr_der_Z0_dzordr_a[ip]),             // 1-bit output write error
         .DI(der_Z0_dzordr_a[ip]),                   // Input data, width defined by DATA_WIDTH parameter
         .RDCLK(clk_new),                               // 1-bit input read clock
         .RDEN(rden_der_Z0_dzordr_a[ip]),               // 1-bit input read enable
         .RST(rst_der_Z0_dzordr_a[ip]),                 // 1-bit input reset
         .WRCLK(clk),                                   // 1-bit input write clock
         .WREN(wren_der_Z0_dzordr_a[ip])                // 1-bit input write enable
      );
   end
//


   
//    genvar ip;
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_iphi shift_ram_iphi (
	 .A(ip),               // input wire [3 : 0] A
	 .D(iphi_res_a_new[ip]),    // Input wire [8 : 0] D
	 .CLK(clk_new),             // input wire CLK
	 .Q(iphi_res_sh_a[ip])  // output wire [8 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_izorr shift_ram_izorr (
	 .A(ip+4),             // input wire [3 : 0] A
	 .D(izor_res_a_new[ip]),    // Input wire [8 : 0] D
	 .CLK(clk_new),             // input wire CLK
	  .Q(izor_res_sh_a[ip]) // output wire [8 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdphi shift_ram_derdphi (
	 .A(ip),                    // input wire [3 : 0] A
	 .D(der_Rinv_dphi_a_new[ip]),    // Input wire [13 : 0] D
	 .CLK(clk_new),                  // input wire CLK
	 .Q(der_Rinv_dphi_sh_a[ip])  // output wire [13 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdzordr shift_ram_derdzordr (
	 .A(ip+4),                    // input wire [3 : 0] A
	 .D(der_Rinv_dzordr_a_new[ip]),    // Input wire [15 : 0] D
	 .CLK(clk_new),                    // input wire CLK
	  .Q(der_Rinv_dzordr_sh_a[ip]) // output wire [15 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdphi shift_ram_derdphi (
	 .A(ip),                    // input wire [3 : 0] A
	 .D(der_Phi0_dphi_a_new[ip]),    // Input wire [13 : 0] D
	 .CLK(clk_new),                  // input wire CLK
	 .Q(der_Phi0_dphi_sh_a[ip])  // output wire [13 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdzordr shift_ram_derdzordr (
	 .A(ip+4),                    // input wire [3 : 0] A
	 .D(der_Phi0_dzordr_a_new[ip]),    // Input wire [15 : 0] D
	 .CLK(clk_new),                    // input wire CLK
	  .Q(der_Phi0_dzordr_sh_a[ip]) // output wire [15 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdphi shift_ram_derdphi (
	 .A(ip),                    // input wire [3 : 0] A
	 .D(der_T_dphi_a_new[ip]),    // Input wire [13 : 0] D
	 .CLK(clk_new),                  // input wire CLK
	 .Q(der_T_dphi_sh_a[ip])  // output wire [13 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdzordr shift_ram_derdzordr (
	 .A(ip+4),                    // input wire [3 : 0] A
	 .D(der_T_dzordr_a_new[ip]),    // Input wire [15 : 0] D
	 .CLK(clk_new),                    // input wire CLK
	  .Q(der_T_dzordr_sh_a[ip]) // output wire [15 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdphi shift_ram_derdphi (
	 .A(ip),                    // input wire [3 : 0] A
	 .D(der_Z0_dphi_a_new[ip]),    // Input wire [13 : 0] D
	 .CLK(clk_new),                  // input wire CLK
	 .Q(der_Z0_dphi_sh_a[ip])  // output wire [13 : 0] Q
      );
    end
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
      c_shift_ram_derdzordr shift_ram_derdzordr (
	 .A(ip+4),                    // input wire [3 : 0] A
	 .D(der_Z0_dzordr_a_new[ip]),    // Input wire [15 : 0] D
	 .CLK(clk_new),                    // input wire CLK
	  .Q(der_Z0_dzordr_sh_a[ip]) // output wire [15 : 0] Q
      );
    end   
    //



   
    //MT Nov 13 2017
    ////irinv_corr////
    //dphi
    xbip_dsp48_macro_0 dsp_rinv_corr_dphi_0 ( //first in the column
	  .CLK(clk_new),                          // input wire CLK
          .A(iphi_res_sh_a[0]),                 // input wire [11 : 0] A
          .B(der_Rinv_dphi_sh_a[0]),            // input wire [13 : 0] B
          .PCOUT(irinv_corr_dsp_a[0]),  // output wire [47 : 0] PCOUT
          .P(irinv_corr_dspdebug_a[0]) // output wire [47 : 0] P
       );
    for ( ip = 1; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_1 dsp_rinv_corr_dphi (
	  .CLK(clk_new),                // input wire CLK
          .A(iphi_res_sh_a[ip]),           // input wire [11 : 0] A
          .B(der_Rinv_dphi_sh_a[ip]),      // input wire [13 : 0] B
          .PCIN(irinv_corr_dsp_a[ip-1]),											      
          .PCOUT(irinv_corr_dsp_a[ip]),  // output wire [47 : 0] PCOUT
          .P(irinv_corr_dspdebug_a[ip]) // output wire [47 : 0] P
       );
    end 
    //dzordr
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_2 dsp_rinv_corr_dzordr (
	  .CLK(clk_new),                // input wire CLK
          .A(izor_res_sh_a[ip]),           // input wire [8 : 0] A
          .B(der_Rinv_dzordr_sh_a[ip]),      // input wire [15 : 0] B
          .PCIN(irinv_corr_dsp_a[ip+4-1]),  // output wire [47 : 0] PCOUT											
          .PCOUT(irinv_corr_dsp_a[ip+4]),  // output wire [47 : 0] PCOUT					
          .P(irinv_corr_dspdebug_a[ip+4]) // output wire [47 : 0] P
       );
    end
       
    ////iphi0_corr////
    //dphi
    xbip_dsp48_macro_0 dsp_phi0_corr_dphi_0 ( //first in the column
	  .CLK(clk_new),                          // input wire CLK
          .A(iphi_res_sh_a[0]),                 // input wire [11 : 0] A
          .B(der_Phi0_dphi_sh_a[0]),            // input wire [13 : 0] B
          .PCOUT(iphi0_corr_dsp_a[0]),  // output wire [47 : 0] PCOUT
          .P(iphi0_corr_dspdebug_a[0]) // output wire [47 : 0] P
       );
    for ( ip = 1; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_1 dsp_phi0_corr_dphi (
	  .CLK(clk_new),                // input wire CLK
          .A(iphi_res_sh_a[ip]),           // input wire [11 : 0] A
          .B(der_Phi0_dphi_sh_a[ip]),      // input wire [13 : 0] B
          .PCIN(iphi0_corr_dsp_a[ip-1]),											      
          .PCOUT(iphi0_corr_dsp_a[ip]),  // output wire [47 : 0] PCOUT
          .P(iphi0_corr_dspdebug_a[ip]) // output wire [47 : 0] P
       );
    end 
    //dzordr
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_2 dsp_phi0_corr_dzordr (
	  .CLK(clk_new),                // input wire CLK
          .A(izor_res_sh_a[ip]),           // input wire [8 : 0] A
          .B(der_Phi0_dzordr_sh_a[ip]),      // input wire [15 : 0] B
          .PCIN(iphi0_corr_dsp_a[ip+4-1]),  // output wire [47 : 0] PCOUT											
          .PCOUT(iphi0_corr_dsp_a[ip+4]),  // output wire [47 : 0] PCOUT					
          .P(iphi0_corr_dspdebug_a[ip+4]) // output wire [47 : 0] P
       );
    end

    ////it_corr////
    //dphi
    xbip_dsp48_macro_0 dsp_t_corr_dphi_0 ( //first in the column
	  .CLK(clk_new),                          // input wire CLK
          .A(iphi_res_sh_a[0]),                 // input wire [11 : 0] A
          .B(der_T_dphi_sh_a[0]),            // input wire [13 : 0] B
          .PCOUT(it_corr_dsp_a[0]),  // output wire [47 : 0] PCOUT
          .P(it_corr_dspdebug_a[0]) // output wire [47 : 0] P
       );
    for ( ip = 1; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_1 dsp_t_corr_dphi (
	  .CLK(clk_new),                // input wire CLK
          .A(iphi_res_sh_a[ip]),           // input wire [11 : 0] A
          .B(der_T_dphi_sh_a[ip]),      // input wire [13 : 0] B
          .PCIN(it_corr_dsp_a[ip-1]),											      
          .PCOUT(it_corr_dsp_a[ip]),  // output wire [47 : 0] PCOUT
          .P(it_corr_dspdebug_a[ip]) // output wire [47 : 0] P
       );
    end 
    //dzordr
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_2 dsp_t_corr_dzordr (
	  .CLK(clk_new),                // input wire CLK
          .A(izor_res_sh_a[ip]),           // input wire [8 : 0] A
          .B(der_T_dzordr_sh_a[ip]),      // input wire [15 : 0] B
          .PCIN(it_corr_dsp_a[ip+4-1]),  // output wire [47 : 0] PCOUT											
          .PCOUT(it_corr_dsp_a[ip+4]),  // output wire [47 : 0] PCOUT					
          .P(it_corr_dspdebug_a[ip+4]) // output wire [47 : 0] P
       );
    end

    ////iz0_corr////
    //dphi
    xbip_dsp48_macro_0 dsp_z0_corr_dphi_0 ( //first in the column
	  .CLK(clk_new),                          // input wire CLK
          .A(iphi_res_sh_a[0]),                 // input wire [11 : 0] A
          .B(der_Z0_dphi_sh_a[0]),            // input wire [13 : 0] B
          .PCOUT(iz0_corr_dsp_a[0]),  // output wire [47 : 0] PCOUT
          .P(iz0_corr_dspdebug_a[0]) // output wire [47 : 0] P
       );
    for ( ip = 1; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_1 dsp_z0_corr_dphi (
	  .CLK(clk_new),                // input wire CLK
          .A(iphi_res_sh_a[ip]),           // input wire [11 : 0] A
          .B(der_Z0_dphi_sh_a[ip]),      // input wire [13 : 0] B
          .PCIN(iz0_corr_dsp_a[ip-1]),											      
          .PCOUT(iz0_corr_dsp_a[ip]),  // output wire [47 : 0] PCOUT
          .P(iz0_corr_dspdebug_a[ip]) // output wire [47 : 0] P
       );
    end 
    //dzordr
    for ( ip = 0; ip < 4; ip = ip + 1 ) begin
       xbip_dsp48_macro_2 dsp_z0_corr_dzordr (
	  .CLK(clk_new),                // input wire CLK
          .A(izor_res_sh_a[ip]),           // input wire [8 : 0] A
          .B(der_Z0_dzordr_sh_a[ip]),      // input wire [15 : 0] B
          .PCIN(iz0_corr_dsp_a[ip+4-1]),  // output wire [47 : 0] PCOUT											
          .PCOUT(iz0_corr_dsp_a[ip+4]),  // output wire [47 : 0] PCOUT					
          .P(iz0_corr_dspdebug_a[ip+4]) // output wire [47 : 0] P
       );       
    end
   

   wire [24:0] irinv_corr_dspdebug_a7;
   wire [24:0] irinv_corr_dspdebug_a7_shift;
   wire [24:0] iphi0_corr_dspdebug_a7;
   wire [24:0] iphi0_corr_dspdebug_a7_shift;
   wire [24:0] it_corr_dspdebug_a7;
   wire [24:0] it_corr_dspdebug_a7_shift;
   wire [24:0] iz0_corr_dspdebug_a7;
   wire [24:0] iz0_corr_dspdebug_a7_shift;


   assign irinv_corr_dspdebug_a7 = irinv_corr_dspdebug_a[7][24:0];
   assign irinv_corr_dspdebug_a7_shift = {{10{irinv_corr_dspdebug_a7[24]}}, irinv_corr_dspdebug_a7[24:10]}; 
   assign iphi0_corr_dspdebug_a7 = iphi0_corr_dspdebug_a[7][24:0];
   assign iphi0_corr_dspdebug_a7_shift = {{6{iphi0_corr_dspdebug_a7[24]}}, iphi0_corr_dspdebug_a7[24:6]}; 
   assign it_corr_dspdebug_a7 = it_corr_dspdebug_a[7][24:0];
   assign it_corr_dspdebug_a7_shift = {{6{it_corr_dspdebug_a7[24]}}, it_corr_dspdebug_a7[24:6]}; 
   assign iz0_corr_dspdebug_a7 = iz0_corr_dspdebug_a[7][24:0];
   assign iz0_corr_dspdebug_a7_shift = {{8{iz0_corr_dspdebug_a7[24]}}, iz0_corr_dspdebug_a7[24:8]}; 
      

    // Step 2: Combine corrections from dphi and dz(dr) of each input 
    // declare
    reg signed [22:0] irinv_corr_a[0:3];
    reg signed [22:0] iphi0_corr_a[0:3];
    reg signed [22:0] it_corr_a[0:3]   ;
    reg signed [22:0] iz0_corr_a[0:3]  ;

    reg signed [22:0] irinv_corr_pipe_a[0:3];
    reg signed [22:0] iphi0_corr_pipe_a[0:3];
    reg signed [22:0] it_corr_pipe_a[0:3]   ;
    reg signed [22:0]  iz0_corr_pipe_a[0:3] ;
   
   
    reg signed [22:0] irinv_corr_pipe2_a[0:3];
    reg signed [22:0] iphi0_corr_pipe2_a[0:3];
    reg signed [22:0] it_corr_pipe2_a[0:3]   ;
    reg signed [22:0] iz0_corr_pipe2_a[0:3]  ;



    // reg signed [22:0] irinv_corr_1;
    // reg signed [22:0] irinv_corr_2;
    // reg signed [22:0] irinv_corr_3;
    // reg signed [22:0] irinv_corr_4;
    // reg signed [22:0] iphi0_corr_1;
    // reg signed [22:0] iphi0_corr_2;
    // reg signed [22:0] iphi0_corr_3;
    // reg signed [22:0] iphi0_corr_4;
    // reg signed [22:0] it_corr_1;
    // reg signed [22:0] it_corr_2;
    // reg signed [22:0] it_corr_3;
    // reg signed [22:0] it_corr_4;
    // reg signed [22:0] iz0_corr_1;
    // reg signed [22:0] iz0_corr_2;
    // reg signed [22:0] iz0_corr_3;
    // reg signed [22:0] iz0_corr_4;

    // reg signed [22:0] irinv_corr_1_pipe;
    // reg signed [22:0] irinv_corr_2_pipe;
    // reg signed [22:0] irinv_corr_3_pipe;
    // reg signed [22:0] irinv_corr_4_pipe;
    // reg signed [22:0] iphi0_corr_1_pipe;
    // reg signed [22:0] iphi0_corr_2_pipe;
    // reg signed [22:0] iphi0_corr_3_pipe;
    // reg signed [22:0] iphi0_corr_4_pipe;
    // reg signed [22:0] it_corr_1_pipe;
    // reg signed [22:0] it_corr_2_pipe;
    // reg signed [22:0] it_corr_3_pipe;
    // reg signed [22:0] it_corr_4_pipe;
    // reg signed [22:0] iz0_corr_1_pipe;
    // reg signed [22:0] iz0_corr_2_pipe;
    // reg signed [22:0] iz0_corr_3_pipe;
    // reg signed [22:0] iz0_corr_4_pipe;
   
    // reg signed [22:0] irinv_corr_1_pipe2;
    // reg signed [22:0] irinv_corr_2_pipe2;
    // reg signed [22:0] irinv_corr_3_pipe2;
    // reg signed [22:0] irinv_corr_4_pipe2;
    // reg signed [22:0] iphi0_corr_1_pipe2;
    // reg signed [22:0] iphi0_corr_2_pipe2;
    // reg signed [22:0] iphi0_corr_3_pipe2;
    // reg signed [22:0] iphi0_corr_4_pipe2;
    // reg signed [22:0] it_corr_1_pipe2;
    // reg signed [22:0] it_corr_2_pipe2;
    // reg signed [22:0] it_corr_3_pipe2;
    // reg signed [22:0] it_corr_4_pipe2;
    // reg signed [22:0] iz0_corr_1_pipe2;
    // reg signed [22:0] iz0_corr_2_pipe2;
    // reg signed [22:0] iz0_corr_3_pipe2;
    // reg signed [22:0] iz0_corr_4_pipe2;

    always @(posedge clk) begin
        irinv_corr_a[0] <= irinv_corr_dphi_a[0] + irinv_corr_dzordr_a[0];
        irinv_corr_a[1] <= irinv_corr_dphi_a[1] + irinv_corr_dzordr_a[1];
        irinv_corr_a[2] <= irinv_corr_dphi_a[2] + irinv_corr_dzordr_a[2];
        irinv_corr_a[3] <= irinv_corr_dphi_a[3] + irinv_corr_dzordr_a[3];
        iphi0_corr_a[0] <= iphi0_corr_dphi_a[0] + iphi0_corr_dzordr_a[0];
        iphi0_corr_a[1] <= iphi0_corr_dphi_a[1] + iphi0_corr_dzordr_a[1];
        iphi0_corr_a[2] <= iphi0_corr_dphi_a[2] + iphi0_corr_dzordr_a[2];
        iphi0_corr_a[3] <= iphi0_corr_dphi_a[3] + iphi0_corr_dzordr_a[3];
        it_corr_a[0]    <= it_corr_dphi_a[0]    + it_corr_dzordr_a[0];
        it_corr_a[1]    <= it_corr_dphi_a[1]    + it_corr_dzordr_a[1];
        it_corr_a[2]    <= it_corr_dphi_a[2]    + it_corr_dzordr_a[2];
        it_corr_a[3]    <= it_corr_dphi_a[3]    + it_corr_dzordr_a[3];
        iz0_corr_a[0]   <= iz0_corr_dphi_a[0]   + iz0_corr_dzordr_a[0];
        iz0_corr_a[1]   <= iz0_corr_dphi_a[1]   + iz0_corr_dzordr_a[1];
        iz0_corr_a[2]   <= iz0_corr_dphi_a[2]   + iz0_corr_dzordr_a[2];
        iz0_corr_a[3]   <= iz0_corr_dphi_a[3]   + iz0_corr_dzordr_a[3];
        
        //pipeline
        irinv_corr_pipe_a[0] <= irinv_corr_a[0];
        irinv_corr_pipe_a[1] <= irinv_corr_a[1];
        irinv_corr_pipe_a[2] <= irinv_corr_a[2];
        irinv_corr_pipe_a[3] <= irinv_corr_a[3];
        iphi0_corr_pipe_a[0] <= iphi0_corr_a[0];
        iphi0_corr_pipe_a[1] <= iphi0_corr_a[1];
        iphi0_corr_pipe_a[2] <= iphi0_corr_a[2];
        iphi0_corr_pipe_a[3] <= iphi0_corr_a[3];
        it_corr_pipe_a[0] <= it_corr_a[0];
        it_corr_pipe_a[1] <= it_corr_a[1];
        it_corr_pipe_a[2] <= it_corr_a[2];
        it_corr_pipe_a[3] <= it_corr_a[3];
        iz0_corr_pipe_a[0] <= iz0_corr_a[0];
        iz0_corr_pipe_a[1] <= iz0_corr_a[1];
        iz0_corr_pipe_a[2] <= iz0_corr_a[2];
        iz0_corr_pipe_a[3] <= iz0_corr_a[3];   
        irinv_corr_pipe2_a[0] <= irinv_corr_pipe_a[0];
        irinv_corr_pipe2_a[1] <= irinv_corr_pipe_a[1];
        irinv_corr_pipe2_a[2] <= irinv_corr_pipe_a[2];
        irinv_corr_pipe2_a[3] <= irinv_corr_pipe_a[3];
        iphi0_corr_pipe2_a[0] <= iphi0_corr_pipe_a[0];
        iphi0_corr_pipe2_a[1] <= iphi0_corr_pipe_a[1];
        iphi0_corr_pipe2_a[2] <= iphi0_corr_pipe_a[2];
        iphi0_corr_pipe2_a[3] <= iphi0_corr_pipe_a[3];
        it_corr_pipe2_a[0]   <= it_corr_pipe_a[0];
        it_corr_pipe2_a[1]   <= it_corr_pipe_a[1];
        it_corr_pipe2_a[2]   <= it_corr_pipe_a[2];
        it_corr_pipe2_a[3]   <= it_corr_pipe_a[3];
        iz0_corr_pipe2_a[0] <= iz0_corr_pipe_a[0];
        iz0_corr_pipe2_a[1] <= iz0_corr_pipe_a[1];
        iz0_corr_pipe2_a[2] <= iz0_corr_pipe_a[2];
        iz0_corr_pipe2_a[3] <= iz0_corr_pipe_a[3];   




        // irinv_corr_1 <= irinv_corr_dphi_1 + irinv_corr_dzordr_1;
        // irinv_corr_2 <= irinv_corr_dphi_2 + irinv_corr_dzordr_2;
        // irinv_corr_3 <= irinv_corr_dphi_3 + irinv_corr_dzordr_3;
        // irinv_corr_4 <= irinv_corr_dphi_4 + irinv_corr_dzordr_4;
        // iphi0_corr_1 <= iphi0_corr_dphi_1 + iphi0_corr_dzordr_1;
        // iphi0_corr_2 <= iphi0_corr_dphi_2 + iphi0_corr_dzordr_2;
        // iphi0_corr_3 <= iphi0_corr_dphi_3 + iphi0_corr_dzordr_3;
        // iphi0_corr_4 <= iphi0_corr_dphi_4 + iphi0_corr_dzordr_4;
        // it_corr_1 <= it_corr_dphi_1 + it_corr_dzordr_1;
        // it_corr_2 <= it_corr_dphi_2 + it_corr_dzordr_2;
        // it_corr_3 <= it_corr_dphi_3 + it_corr_dzordr_3;
        // it_corr_4 <= it_corr_dphi_4 + it_corr_dzordr_4;
        // iz0_corr_1 <= iz0_corr_dphi_1 + iz0_corr_dzordr_1;
        // iz0_corr_2 <= iz0_corr_dphi_2 + iz0_corr_dzordr_2;
        // iz0_corr_3 <= iz0_corr_dphi_3 + iz0_corr_dzordr_3;
        // iz0_corr_4 <= iz0_corr_dphi_4 + iz0_corr_dzordr_4;
        
        // //pipeline
        // irinv_corr_1_pipe <= irinv_corr_1;
        // irinv_corr_2_pipe <= irinv_corr_2;
        // irinv_corr_3_pipe <= irinv_corr_3;
        // irinv_corr_4_pipe <= irinv_corr_4;
        // iphi0_corr_1_pipe <= iphi0_corr_1;
        // iphi0_corr_2_pipe <= iphi0_corr_2;
        // iphi0_corr_3_pipe <= iphi0_corr_3;
        // iphi0_corr_4_pipe <= iphi0_corr_4;
        // it_corr_1_pipe <= it_corr_1;
        // it_corr_2_pipe <= it_corr_2;
        // it_corr_3_pipe <= it_corr_3;
        // it_corr_4_pipe <= it_corr_4;
        // iz0_corr_1_pipe <= iz0_corr_1;
        // iz0_corr_2_pipe <= iz0_corr_2;
        // iz0_corr_3_pipe <= iz0_corr_3;
        // iz0_corr_4_pipe <= iz0_corr_4;   
        // irinv_corr_1_pipe2 <= irinv_corr_1_pipe;
        // irinv_corr_2_pipe2 <= irinv_corr_2_pipe;
        // irinv_corr_3_pipe2 <= irinv_corr_3_pipe;
        // irinv_corr_4_pipe2 <= irinv_corr_4_pipe;
        // iphi0_corr_1_pipe2 <= iphi0_corr_1_pipe;
        // iphi0_corr_2_pipe2 <= iphi0_corr_2_pipe;
        // iphi0_corr_3_pipe2 <= iphi0_corr_3_pipe;
        // iphi0_corr_4_pipe2 <= iphi0_corr_4_pipe;
        // it_corr_1_pipe2 <= it_corr_1_pipe;
        // it_corr_2_pipe2 <= it_corr_2_pipe;
        // it_corr_3_pipe2 <= it_corr_3_pipe;
        // it_corr_4_pipe2 <= it_corr_4_pipe;
        // iz0_corr_1_pipe2 <= iz0_corr_1_pipe;
        // iz0_corr_2_pipe2 <= iz0_corr_2_pipe;
        // iz0_corr_3_pipe2 <= iz0_corr_3_pipe;
        // iz0_corr_4_pipe2 <= iz0_corr_4_pipe;   
    end
    

    // Step 3: Combine corrections from input 1 and 2, input 3 and 4
    // declare
    reg signed [23:0] irinv_corr_12;
    reg signed [23:0] irinv_corr_34;
    reg signed [23:0] iphi0_corr_12;
    reg signed [23:0] iphi0_corr_34;
    reg signed [23:0] it_corr_12;
    reg signed [23:0] it_corr_34;
    reg signed [23:0] iz0_corr_12;
    reg signed [23:0] iz0_corr_34;
    
    always @(posedge clk) begin
        irinv_corr_12 <= irinv_corr_pipe2_a[0] + irinv_corr_pipe2_a[1];
        irinv_corr_34 <= irinv_corr_pipe2_a[2] + irinv_corr_pipe2_a[3];
        iphi0_corr_12 <= iphi0_corr_pipe2_a[0] + iphi0_corr_pipe2_a[1];
        iphi0_corr_34 <= iphi0_corr_pipe2_a[2] + iphi0_corr_pipe2_a[3];
        it_corr_12 <= it_corr_pipe2_a[0] + it_corr_pipe2_a[1];
        it_corr_34 <= it_corr_pipe2_a[2] + it_corr_pipe2_a[3];
        iz0_corr_12 <= iz0_corr_pipe2_a[0] + iz0_corr_pipe2_a[1];
        iz0_corr_34 <= iz0_corr_pipe2_a[2] + iz0_corr_pipe2_a[3];

        // irinv_corr_12 <= irinv_corr_1_pipe2 + irinv_corr_2_pipe2;
        // irinv_corr_34 <= irinv_corr_3_pipe2 + irinv_corr_4_pipe2;
        // iphi0_corr_12 <= iphi0_corr_1_pipe2 + iphi0_corr_2_pipe2;
        // iphi0_corr_34 <= iphi0_corr_3_pipe2 + iphi0_corr_4_pipe2;
        // it_corr_12 <= it_corr_1_pipe2 + it_corr_2_pipe2;
        // it_corr_34 <= it_corr_3_pipe2 + it_corr_4_pipe2;
        // iz0_corr_12 <= iz0_corr_1_pipe2 + iz0_corr_2_pipe2;
        // iz0_corr_34 <= iz0_corr_3_pipe2 + iz0_corr_4_pipe2;

    end    

    // Step 4.0: Get final corrections 
    // declare
    reg signed [24:0] irinv_corr;
    reg signed [24:0] iphi0_corr;
    reg signed [24:0] it_corr;
    reg signed [24:0] iz0_corr;
        
    always @(posedge clk) begin
        irinv_corr <= irinv_corr_12 + irinv_corr_34;
        iphi0_corr <= iphi0_corr_12 + iphi0_corr_34;
        it_corr <= it_corr_12 + it_corr_34;
        iz0_corr <= iz0_corr_12 + iz0_corr_34;
    end            
  
    // Step 4.1: Get tracklet parameters
    reg signed [13:0] it_tpar;
    reg signed [13:0] irinv_tpar;
    reg signed [17:0] iphi0_tpar;
    reg signed [9:0] iz0_tpar;    
    reg [8:0] pre_stub_index_seed1;
    reg [8:0] pre_stub_index_seed2;

    reg signed [13:0] irinv_tpar_MT;
    reg signed [17:0] iphi0_tpar_MT;   
    reg signed [13:0] it_tpar_MT;   
    reg signed [9:0]  iz0_tpar_MT;      
    
    always @(posedge clk) begin
        pre_stub_index_seed1 <= {DTC_index_inner_dly,trackparsin_pipe[67:62]};
        pre_stub_index_seed2 <= {DTC_index_outer_dly,trackparsin_pipe[61:56]};
        irinv_tpar <= trackparsin_pipe[55:42];
        iphi0_tpar <= trackparsin_pipe[41:24];
        it_tpar    <= trackparsin_pipe[13:0];
        iz0_tpar   <= trackparsin_pipe[23:14];

       
       //MT Jan 19 2018
        irinv_tpar_MT <= trackparsin_pipe_MT[55:42];
        iphi0_tpar_MT <= trackparsin_pipe_MT[41:24];       
        it_tpar_MT <= trackparsin_pipe_MT[13:0];       
        iz0_tpar_MT <= trackparsin_pipe_MT[23:14];              

    end

    // Step 5: SUBSTRACT corrections from tracklet parameters
    reg signed [14:0] ipt;
    reg signed [18:0] iphi0;
    reg signed [13:0] it;
    reg signed [10:0] iz0;
    reg [8:0] stub_index_seed1;
    reg [8:0] stub_index_seed2;
    
    // NEED TO DOUBLE CHECK SIGN
    always @(posedge clk) begin
        stub_index_seed1 <= pre_stub_index_seed1;
        stub_index_seed2 <= pre_stub_index_seed2;
        //ipt   <= irinv_tpar + (irinv_corr >>> 4'd10);
        //iphi0 <= iphi0_tpar + (iphi0_corr >>> 4'd6);
        //it    <= it_tpar + (it_corr >>> 4'd6);
        //iz0   <= iz0_tpar + (iz0_corr >>> 4'd8);
        ipt   <= irinv_tpar + (irinv_corr >>> 4'd10);
        iphi0 <= iphi0_tpar + (iphi0_corr >>> 4'd6);
        it    <= it_tpar + (it_corr >>> 4'd6);
        iz0   <= iz0_tpar + (iz0_corr >>> 4'd8);
    end


   wire [14:0] ipt_a_14to0;
   wire [18:0] iphi0_a_18to0;
   wire [13:0] it_a_13to0;
   wire [10:0] iz0_a_10to0;   

   reg signed [14:0] ipt_a_14to0_infer;
   reg signed [18:0] iphi0_a_18to0_infer;
   reg signed [13:0] it_a_13to0_infer;
   reg signed [10:0] iz0_a_10to0_infer;   


   //MT jan 17 2018 crossing clk domains
//from Language Template->verilog->Virtex-7->ram->Dual Clock Fifo   
   FIFO_DUALCLOCK_MACRO  #( 
         .ALMOST_EMPTY_OFFSET(9'h080),             
         .ALMOST_FULL_OFFSET(9'h080),              
         .DATA_WIDTH(14),                          
         .DEVICE("7SERIES"),                       
         .FIFO_SIZE ("18Kb"),                      
         .FIRST_WORD_FALL_THROUGH ("FALSE")        
      ) FIFO_DUALCLOCK_MACRO_irinv_tpar (
         .ALMOSTEMPTY(),                           
         .ALMOSTFULL(),                            
         .DO(irinv_tpar_new),                      
         .EMPTY(),                                 
         .FULL(),                                  
         .RDCOUNT(),                               
         .RDERR(),                                 
         .WRCOUNT(),                               
         .WRERR(),                                 
         .DI(irinv_tpar_MT),                          
         .RDCLK(clk_new),                          
         .RDEN(1'b1),         
         .RST(1'b0),          
         .WRCLK(clk),         
         .WREN(1'b1)         
      );

   FIFO_DUALCLOCK_MACRO  #( 
         .ALMOST_EMPTY_OFFSET(9'h080),             
         .ALMOST_FULL_OFFSET(9'h080),              
         .DATA_WIDTH(18),                          
         .DEVICE("7SERIES"),                       
         .FIFO_SIZE ("18Kb"),                      
         .FIRST_WORD_FALL_THROUGH ("FALSE")        
      ) FIFO_DUALCLOCK_MACRO_phi0_tpar (
         .ALMOSTEMPTY(),                           
         .ALMOSTFULL(),                            
         .DO(iphi0_tpar_new),                      
         .EMPTY(),                                 
         .FULL(),                                  
         .RDCOUNT(),                               
         .RDERR(),                                 
         .WRCOUNT(),                               
         .WRERR(),                                 
         .DI(iphi0_tpar_MT),                          
         .RDCLK(clk_new),                          
         .RDEN(1'b1),         
         .RST(1'b0),          
         .WRCLK(clk),         
         .WREN(1'b1)         
      );

   FIFO_DUALCLOCK_MACRO  #( 
         .ALMOST_EMPTY_OFFSET(9'h080),             
         .ALMOST_FULL_OFFSET(9'h080),              
         .DATA_WIDTH(14),                          
         .DEVICE("7SERIES"),                       
         .FIFO_SIZE ("18Kb"),                      
         .FIRST_WORD_FALL_THROUGH ("FALSE")        
      ) FIFO_DUALCLOCK_MACRO_it_tpar (
         .ALMOSTEMPTY(),                           
         .ALMOSTFULL(),                            
         .DO(it_tpar_new),                      
         .EMPTY(),                                 
         .FULL(),                                  
         .RDCOUNT(),                               
         .RDERR(),                                 
         .WRCOUNT(),                               
         .WRERR(),                                 
         .DI(it_tpar_MT),                          
         .RDCLK(clk_new),                          
         .RDEN(1'b1),         
         .RST(1'b0),          
         .WRCLK(clk),         
         .WREN(1'b1)         
      );

   FIFO_DUALCLOCK_MACRO  #( 
         .ALMOST_EMPTY_OFFSET(9'h080),             
         .ALMOST_FULL_OFFSET(9'h080),              
         .DATA_WIDTH(10),                          
         .DEVICE("7SERIES"),                       
         .FIFO_SIZE ("18Kb"),                      
         .FIRST_WORD_FALL_THROUGH ("FALSE")        
      ) FIFO_DUALCLOCK_MACRO_iz0_tpar (
         .ALMOSTEMPTY(),                           
         .ALMOSTFULL(),                            
         .DO(iz0_tpar_new),                      
         .EMPTY(),                                 
         .FULL(),                                  
         .RDCOUNT(),                               
         .RDERR(),                                 
         .WRCOUNT(),                               
         .WRERR(),                                 
         .DI(iz0_tpar_MT),                          
         .RDCLK(clk_new),                          
         .RDEN(1'b1),         
         .RST(1'b0),          
         .WRCLK(clk),         
         .WREN(1'b1)         
      );
   
   
   //MT Jan 9 2018
   c_shift_ram_derdphi shift_ram_irinv_tpar (
	 .A(8),                            
	 .D(irinv_tpar_new),               
	 .CLK(clk_new),                    
	  .Q(irinv_tpar_sh)                
   );
   c_shift_ram_derdphi shift_ram_irinv_tpar2 (
	 .A(11), 
	 .D(irinv_tpar_new),    
	 .CLK(clk_new),         
	  .Q(irinv_tpar_sh2) 
   );

   c_shift_ram_18b shift_ram_iphi0_tpar (
	 .A(8),                            
	 .D(iphi0_tpar_new),               
	 .CLK(clk_new),                    
	  .Q(iphi0_tpar_sh)                
   );
   c_shift_ram_18b shift_ram_iphi0_tpar2 (
	 .A(11), 
	 .D(iphi0_tpar_new),    
	 .CLK(clk_new),         
	  .Q(iphi0_tpar_sh2) 
   );

   c_shift_ram_derdphi shift_ram_it_tpar (
	 .A(8),                            
	 .D(it_tpar_new),               
	 .CLK(clk_new),                    
	  .Q(it_tpar_sh)                
   );
   c_shift_ram_derdphi shift_ram_it_tpar2 (
	 .A(11), 
	 .D(it_tpar_new),    
	 .CLK(clk_new),         
	  .Q(it_tpar_sh2) 
   );

   c_shift_ram_10b shift_ram_iz0_tpar (
	 .A(8),                            
	 .D(iz0_tpar_new),               
	 .CLK(clk_new),                    
	  .Q(iz0_tpar_sh)                
   );
   c_shift_ram_10b shift_ram_iz0_tpar2 (
	 .A(11), 
	 .D(iz0_tpar_new),    
	 .CLK(clk_new),         
	  .Q(iz0_tpar_sh2) 
   );
   
   
   wire [14:0] 	     irinv_tpar_sh_ext;
   wire [18:0] 	     iphi0_tpar_sh_ext;
   wire [14:0] 	     it_tpar_sh_ext;
   wire [9:0] 	     iz0_tpar_sh_ext;   

   //extend by one bit
   assign irinv_tpar_sh_ext = {1'b0,irinv_tpar_sh};
   assign iphi0_tpar_sh_ext = {1'b0,iphi0_tpar_sh};
   assign it_tpar_sh_ext = {1'b0,it_tpar_sh};
   assign iz0_tpar_sh_ext = {1'b0,iz0_tpar_sh};         
   
   
   xbip_dsp48_macro_3 dsp_ip_a (
    	  .CLK(clk_new),                // input wire CLK
          .A(irinv_tpar_sh_ext),           // input wire [14 : 0] A (was 13:0)
          .B(2'b01),      // input wire [1 : 0] B
          .PCIN({{23{1'b0}},{1'b0},irinv_corr_dspdebug_a7_shift[13:0]}), //13=22-10+1 (10 is from >>>10, +1 is to keep info on the sign)
          .P(ipt_a) // output wire [47 : 0] P
    );

   xbip_dsp48_macro_19btimes2 dsp_iphi0_a (
    	  .CLK(clk_new),                
          .A(iphi0_tpar_sh_ext),           //[18:0]
          .B(2'b01),      
          .PCIN({{29{1'b0}},{1'b0},iphi0_corr_dspdebug_a7_shift[17:0]}),
          .P(iphi0_a) 
    );

   xbip_dsp48_macro_3 dsp_it_a (
    	  .CLK(clk_new),                
          .A(it_tpar_sh_ext),           //[14:0]
          .B(2'b01),      
          .PCIN({{23{1'b0}},{1'b0},it_corr_dspdebug_a7_shift[13:0]}),
          .P(it_a) 
    );

   xbip_dsp48_macro_10btimes2 dsp_iz0_a (
    	  .CLK(clk_new),                
          .A(iz0_tpar_sh_ext),           //[9:0]
          .B(2'b01),      
          .PCIN({{22{1'b0}},{1'b0},iz0_corr_dspdebug_a7_shift[14:0]}),
          .P(iz0_a) 
    );

   
   //MT: just to check whether the dsp48 macros are computing things correctly
   always @(posedge clk_new) begin  
      ipt_a_14to0_infer   <= irinv_tpar_sh2 + 2'b01 * irinv_corr_dspdebug_a7_shift[13:0];
      iphi0_a_18to0_infer <= iphi0_tpar_sh2 + 2'b01 * iphi0_corr_dspdebug_a7_shift[17:0]; 
      it_a_13to0_infer    <= it_tpar_sh2    + 2'b01 * it_corr_dspdebug_a7_shift[13:0]; 
      iz0_a_10to0_infer   <= iz0_tpar_sh2   + 2'b01 * iz0_corr_dspdebug_a7_shift[14:0];       
   end
   
   assign ipt_a_14to0   = ipt_a[14:0];
   assign iphi0_a_18to0 = iphi0_a[18:0];
   assign it_a_13to0    = it_a[13:0];
   assign iz0_a_10to0   = iz0_a[10:0];   

   //place here fifos to return to clk domain
   
    wire [6:0] BX_counter;
    pipe_delay #(.STAGES(30), .WIDTH(7))
        BX_counter_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
        .val_in(BX_pipe[6:0]), .val_out(BX_counter));    
      
    assign trackout = {BX_counter,stub_index_seed1,stub_index_seed2,stub_indices_dly,ipt,iphi0,it,iz0};


   
   
endmodule


