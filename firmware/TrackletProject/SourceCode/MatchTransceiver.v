`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 03:16:21 PM
// Design Name: 
// Module Name: MatchTranceiver
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


module MatchTransceiver(
    input clk,
    input reset,
    input en_proc,
        
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in1,
    input [5:0] number_in2,
    input [5:0] number_in3,
    input [5:0] number_in4,
    input [5:0] number_in5,
    input [5:0] number_in6,
    input [5:0] number_in7,
    input [5:0] number_in8,
    input [5:0] number_in9,
    input [5:0] number_in10,
    input [5:0] number_in11,
    input [5:0] number_in12,
    input [5:0] number_in13,
    input [5:0] number_in14,
    input [5:0] number_in15,
    input [5:0] number_in16,
    input [5:0] number_in17,
    input [5:0] number_in18,
    input [5:0] number_in19,
    input [5:0] number_in20,
    input [5:0] number_in21,
    input [5:0] number_in22,
    input [5:0] number_in23,
    input [5:0] number_in24,
        
    output [`MEM_SIZE+3:0] read_add1,
    output [`MEM_SIZE+3:0] read_add2,
    output [`MEM_SIZE+3:0] read_add3,
    output [`MEM_SIZE+3:0] read_add4,
    output [`MEM_SIZE+3:0] read_add5,
    output [`MEM_SIZE+3:0] read_add6,
    output [`MEM_SIZE+3:0] read_add7,
    output [`MEM_SIZE+3:0] read_add8,
    output [`MEM_SIZE+3:0] read_add9,
    output [`MEM_SIZE+3:0] read_add10,
    output [`MEM_SIZE+3:0] read_add11,
    output [`MEM_SIZE+3:0] read_add12,
    output [`MEM_SIZE+3:0] read_add13,
    output [`MEM_SIZE+3:0] read_add14,
    output [`MEM_SIZE+3:0] read_add15,
    output [`MEM_SIZE+3:0] read_add16,
    output [`MEM_SIZE+3:0] read_add17,
    output [`MEM_SIZE+3:0] read_add18,
    output [`MEM_SIZE+3:0] read_add19,
    output [`MEM_SIZE+3:0] read_add20,
    output [`MEM_SIZE+3:0] read_add21,
    output [`MEM_SIZE+3:0] read_add22,
    output [`MEM_SIZE+3:0] read_add23,
    output [`MEM_SIZE+3:0] read_add24,
    
    output read_en1,
    output read_en2,
    output read_en3,
    output read_en4,
    output read_en5,
    output read_en6,
    output read_en7,
    output read_en8,
    output read_en9,
    output read_en10,
    output read_en11,
    output read_en12,
    output read_en13,
    output read_en14,
    output read_en15,
    output read_en16,
    output read_en17,
    output read_en18,
    output read_en19,
    output read_en20,
    output read_en21,
    output read_en22,
    output read_en23,
    output read_en24,
    
    input [39:0] matchin1,
    input [39:0] matchin2,
    input [39:0] matchin3,
    input [39:0] matchin4,
    input [39:0] matchin5,
    input [39:0] matchin6,
    input [39:0] matchin7,
    input [39:0] matchin8,
    input [39:0] matchin9,
    input [39:0] matchin10,
    input [39:0] matchin11,
    input [39:0] matchin12,
    input [39:0] matchin13,
    input [39:0] matchin14,
    input [39:0] matchin15,
    input [39:0] matchin16,
    input [39:0] matchin17,
    input [39:0] matchin18,
    input [39:0] matchin19,
    input [39:0] matchin20,
    input [39:0] matchin21,
    input [39:0] matchin22,
    input [39:0] matchin23,
    input [39:0] matchin24,
    output reg [44:0] match_data_stream,
    output wire valid_match_data_stream,

    input [44:0] incomming_match_data_stream,     
    input valid_incomming_match_data_stream,
    output wire [39:0] matchout1,
    output wire [39:0] matchout2,
    output wire [39:0] matchout3,
    output wire [39:0] matchout4,
    output wire [39:0] matchout5,
    output wire [39:0] matchout6,
    output wire [39:0] matchout7,
    output wire [39:0] matchout8,
    output wire [39:0] matchout9,
    output wire [39:0] matchout10,
    output wire [39:0] matchout11,
    output wire [39:0] matchout12,
    output wire [39:0] matchout13,
    output wire [39:0] matchout14,
    output wire [39:0] matchout15,
    output wire [39:0] matchout16,
    output wire [39:0] matchout17,
    
    output reg valid_matchout1,
    output reg valid_matchout2,
    output reg valid_matchout3,
    output reg valid_matchout4,
    output reg valid_matchout5,
    output reg valid_matchout6,
    output reg valid_matchout7,
    output reg valid_matchout8,
    output reg valid_matchout9,
    output reg valid_matchout10,
    output reg valid_matchout11,
    output reg valid_matchout12,
    output reg valid_matchout13,
    output reg valid_matchout14,
    output reg valid_matchout15,
    output reg valid_matchout16,
    output reg valid_matchout17
     
);

    parameter seeding = "Layer";

//    pipe_delay #(.STAGES(`LINK_LATENCY-6), .WIDTH(2)) // The FullMatch memories are reg_arrays and we need extra delays to compensate
//               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
//               .val_in(start), .val_out(done));
               
    generate
        if (seeding=="Layer") begin
            pipe_delay #(.STAGES(`LINK_LATENCY-5), .WIDTH(2)) // The FullMatch memories are reg_arrays and we need extra delays to compensate
               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done));    
        end
        else begin // disk needs to be one clk cycle early because it has an extra delay in the DiskMC
            pipe_delay #(.STAGES(`LINK_LATENCY-6), .WIDTH(2)) // The FullMatch memories are reg_arrays and we need extra delays to compensate
                done_delay(.pipe_in(), .pipe_out(), .clk(clk),
                .val_in(start), .val_out(done));            
        end
    endgenerate

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset

    reg startdly1,startdly2,startdly3,startdly4,startdly5;
     
    always @ (posedge clk) begin
        //add delays here if needed (start & valid signals)
        startdly1 <= start[0];
        startdly2 <= startdly1;
        startdly3 <= startdly2;
        startdly4 <= startdly3;
        startdly5 <= startdly4;
    end
    
    reg [3:0] BX_pipe;
    reg [39:0] data_out;
    wire send_BX;
    wire done_sending;
    
    wire read_enable_m1;
    wire read_enable_m2;
    wire read_enable_m3;
    wire read_enable_m4;
    wire read_enable_m5;
    wire read_enable_m6;
    wire read_enable_m7;
    wire read_enable_m8;
    wire read_enable_m9;
    wire read_enable_m10;
    wire read_enable_m11;
    wire read_enable_m12;
    
    reg [6:0] number_in_fm1;
    reg [6:0] number_in_fm2;
    reg [6:0] number_in_fm3;
    reg [6:0] number_in_fm4;
    reg [6:0] number_in_fm5;
    reg [6:0] number_in_fm6;
    reg [6:0] number_in_fm7;
    reg [6:0] number_in_fm8;
    reg [6:0] number_in_fm9;
    reg [6:0] number_in_fm10;
    reg [6:0] number_in_fm11;
    reg [6:0] number_in_fm12;   
    wire [6:0] number_in_fm1_pipe;
    wire [6:0] number_in_fm2_pipe;
    wire [6:0] number_in_fm3_pipe;
    wire [6:0] number_in_fm4_pipe;
    wire [6:0] number_in_fm5_pipe;
    wire [6:0] number_in_fm6_pipe;
    wire [6:0] number_in_fm7_pipe;
    wire [6:0] number_in_fm8_pipe;
    wire [6:0] number_in_fm9_pipe;
    wire [6:0] number_in_fm10_pipe;
    wire [6:0] number_in_fm11_pipe;
    wire [6:0] number_in_fm12_pipe;
        
    wire pre_valid1_1;
    wire pre_valid2_1;
    wire pre_valid3_1;
    wire pre_valid4_1;
    wire pre_valid5_1;
    wire pre_valid6_1;
    wire pre_valid7_1;
    wire pre_valid8_1;
    wire pre_valid9_1;
    wire pre_valid10_1;
    wire pre_valid11_1;
    wire pre_valid12_1;
    wire pre_valid13_1;
    wire pre_valid14_1;
    wire pre_valid15_1;
    wire pre_valid16_1;
    wire pre_valid17_1;
    
    wire [39:0] fullmatch1_i;
    wire [39:0] fullmatch2_i;
    wire [39:0] fullmatch3_i;
    wire [39:0] fullmatch4_i;
    wire [39:0] fullmatch5_i;
    wire [39:0] fullmatch6_i;
    wire [39:0] fullmatch7_i;
    wire [39:0] fullmatch8_i;
    wire [39:0] fullmatch9_i;
    wire [39:0] fullmatch10_i;
    wire [39:0] fullmatch11_i;
    wire [39:0] fullmatch12_i;
 
    // merge matches from different detector regions of the same layer
    FMReaderMT #(40,39,30) fullmatch_1 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin1),
        .numberin_1(number_in1),
        .read_addr_1(read_add1),
        .read_enable_1(read_en1),
        .fullmatchin_2(matchin13),
        .numberin_2(number_in13),
        .read_addr_2(read_add13),
        .read_enable_2(read_en13),
        
        .inRead(read_enable_m1),   // input, read enable for the merger
        .fullmatchout(fullmatch1_i),    // output
        .valid_o(valid_fm1)  // output
    );
    
    FMReaderMT #(40,39,30) fullmatch_2 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin2),
        .numberin_1(number_in2),
        .read_addr_1(read_add2),
        .read_enable_1(read_en2),
        .fullmatchin_2(matchin14),
        .numberin_2(number_in14),
        .read_addr_2(read_add14),
        .read_enable_2(read_en14),
        
        .inRead(read_enable_m2),   // input, read enable for the merger
        .fullmatchout(fullmatch2_i),    // output
        .valid_o(valid_fm2)  // output
    );

    FMReaderMT #(40,39,30) fullmatch_3 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin3),
        .numberin_1(number_in3),
        .read_addr_1(read_add3),
        .read_enable_1(read_en3),
        .fullmatchin_2(matchin15),
        .numberin_2(number_in15),
        .read_addr_2(read_add15),
        .read_enable_2(read_en15),
        
        .inRead(read_enable_m3),   // input, read enable for the merger
        .fullmatchout(fullmatch3_i),    // output
        .valid_o(valid_fm3)  // output
    );

    FMReaderMT #(40,39,30) fullmatch_4 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin4),
        .numberin_1(number_in4),
        .read_addr_1(read_add4),
        .read_enable_1(read_en4),
        .fullmatchin_2(matchin16),
        .numberin_2(number_in16),
        .read_addr_2(read_add16),
        .read_enable_2(read_en16),
        
        .inRead(read_enable_m4),   // input, read enable for the merger
        .fullmatchout(fullmatch4_i),    // output
        .valid_o(valid_fm4)  // output
    );
    
    FMReaderMT #(40,39,30) fullmatch_5 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin5),
        .numberin_1(number_in5),
        .read_addr_1(read_add5),
        .read_enable_1(read_en5),
        .fullmatchin_2(matchin17),
        .numberin_2(number_in17),
        .read_addr_2(read_add17),
        .read_enable_2(read_en17),
        
        .inRead(read_enable_m5),   // input, read enable for the merger
        .fullmatchout(fullmatch5_i),    // output
        .valid_o(valid_fm5)  // output
    );
 
    FMReaderMT #(40,39,30) fullmatch_6 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin6),
        .numberin_1(number_in6),
        .read_addr_1(read_add6),
        .read_enable_1(read_en6),
        .fullmatchin_2(matchin18),
        .numberin_2(number_in18),
        .read_addr_2(read_add18),
        .read_enable_2(read_en18),
        
        .inRead(read_enable_m6),   // input, read enable for the merger
        .fullmatchout(fullmatch6_i),    // output
        .valid_o(valid_fm6)  // output
    ); 

    FMReaderMT #(40,39,30) fullmatch_7 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin7),
        .numberin_1(number_in7),
        .read_addr_1(read_add7),
        .read_enable_1(read_en7),
        .fullmatchin_2(matchin19),
        .numberin_2(number_in19),
        .read_addr_2(read_add19),
        .read_enable_2(read_en19),
        
        .inRead(read_enable_m7),   // input, read enable for the merger
        .fullmatchout(fullmatch7_i),    // output
        .valid_o(valid_fm7)  // output
    ); 

    FMReaderMT #(40,39,30) fullmatch_8 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin8),
        .numberin_1(number_in8),
        .read_addr_1(read_add8),
        .read_enable_1(read_en8),
        .fullmatchin_2(matchin20),
        .numberin_2(number_in20),
        .read_addr_2(read_add20),
        .read_enable_2(read_en20),
        
        .inRead(read_enable_m8),   // input, read enable for the merger
        .fullmatchout(fullmatch8_i),    // output
        .valid_o(valid_fm8)  // output
    ); 

    FMReaderMT #(40,39,30) fullmatch_9 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin9),
        .numberin_1(number_in9),
        .read_addr_1(read_add9),
        .read_enable_1(read_en9),
        .fullmatchin_2(matchin21),
        .numberin_2(number_in21),
        .read_addr_2(read_add21),
        .read_enable_2(read_en21),
        
        .inRead(read_enable_m9),   // input, read enable for the merger
        .fullmatchout(fullmatch9_i),    // output
        .valid_o(valid_fm9)  // output
    ); 

    FMReaderMT #(40,39,30) fullmatch_10 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin10),
        .numberin_1(number_in10),
        .read_addr_1(read_add10),
        .read_enable_1(read_en10),
        .fullmatchin_2(matchin22),
        .numberin_2(number_in22),
        .read_addr_2(read_add22),
        .read_enable_2(read_en22),
        
        .inRead(read_enable_m10),   // input, read enable for the merger
        .fullmatchout(fullmatch10_i),    // output
        .valid_o(valid_fm10)  // output
    );

    FMReaderMT #(40,39,30) fullmatch_11 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin11),
        .numberin_1(number_in11),
        .read_addr_1(read_add11),
        .read_enable_1(read_en11),
        .fullmatchin_2(matchin23),
        .numberin_2(number_in23),
        .read_addr_2(read_add23),
        .read_enable_2(read_en23),
        
        .inRead(read_enable_m11),   // input, read enable for the merger
        .fullmatchout(fullmatch11_i),    // output
        .valid_o(valid_fm11)  // output
    );

    FMReaderMT #(40,39,30) fullmatch_12 (
        .clk(clk),
        .rst(rst_pipe),
        .new_bx(start[0]),
        .BX_pipe(BX_pipe[3:0]),
        
        .fullmatchin_1(matchin12),
        .numberin_1(number_in12),
        .read_addr_1(read_add12),
        .read_enable_1(read_en12),
        .fullmatchin_2(matchin24),
        .numberin_2(number_in24),
        .read_addr_2(read_add24),
        .read_enable_2(read_en24),
        
        .inRead(read_enable_m12),   // input, read enable for the merger
        .fullmatchout(fullmatch12_i),    // output
        .valid_o(valid_fm12)  // output
    );
    
 
    // add number_in for merged inputs
    always @(posedge clk) begin
        number_in_fm1  <= number_in1 + number_in13;
        number_in_fm2  <= number_in2 + number_in14;
        number_in_fm3  <= number_in3 + number_in15;
        number_in_fm4  <= number_in4 + number_in16;
        number_in_fm5  <= number_in5 + number_in17;
        number_in_fm6  <= number_in6 + number_in18;
        number_in_fm7  <= number_in7 + number_in19;
        number_in_fm8  <= number_in8 + number_in20;
        number_in_fm9  <= number_in9 + number_in21;
        number_in_fm10 <= number_in10 + number_in22;
        number_in_fm11 <= number_in11 + number_in23;
        number_in_fm12 <= number_in12 + number_in24;
    end

    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin1_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm1), .val_out(number_in_fm1_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin2_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm2), .val_out(number_in_fm2_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin3_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm3), .val_out(number_in_fm3_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin4_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm4), .val_out(number_in_fm4_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin5_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm5), .val_out(number_in_fm5_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin6_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm6), .val_out(number_in_fm6_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin7_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm7), .val_out(number_in_fm7_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin8_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm8), .val_out(number_in_fm8_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin9_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm9), .val_out(number_in_fm9_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin10_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm10), .val_out(number_in_fm10_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin11_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm11), .val_out(number_in_fm11_pipe));
    pipe_delay #(.STAGES(3), .WIDTH(7))
        numberin12_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(number_in_fm12), .val_out(number_in_fm12_pipe));

    
    // The valid signal is 2 clk cycles ahead of the data
    // compared with the MatchCalculator.
    // Add 2 delays to synchronize the enables.
    wire [44:0] pre_match_data_stream;

    always @(posedge clk) begin
        valid_matchout1 <= pre_valid1_1;
        valid_matchout2 <= pre_valid2_1;
        valid_matchout3 <= pre_valid3_1;
        valid_matchout4 <= pre_valid4_1;
        valid_matchout5 <= pre_valid5_1;
        valid_matchout6 <= pre_valid6_1;
        valid_matchout7 <= pre_valid7_1;
        valid_matchout8 <= pre_valid8_1;
        valid_matchout9 <= pre_valid9_1;
        valid_matchout10 <= pre_valid10_1;
        valid_matchout11 <= pre_valid11_1;
        valid_matchout12 <= pre_valid12_1;
        valid_matchout13 <= pre_valid13_1;
        valid_matchout14 <= pre_valid14_1;
        valid_matchout15 <= pre_valid15_1;
        valid_matchout16 <= pre_valid16_1;
        valid_matchout17 <= pre_valid17_1;
    
        if(valid_match_data_stream)
            match_data_stream <= pre_match_data_stream;
        else
            match_data_stream <= 44'b0; 
        
    end
    
    
    mem_readout_top_MT #(seeding) send_match(
        .clk(clk),                  // main clock
        .reset(startdly5),              // synchronously negated active-hi reset
        .BX(BX_pipe),
 
        .number_in1(number_in_fm1_pipe),          // starting number of items for this memory
        .number_in2(number_in_fm2_pipe),          // starting number of items for this memory
        .number_in3(number_in_fm3_pipe),          // starting number of items for this memory
        .number_in4(number_in_fm4_pipe),          // starting number of items for this memory
        .number_in5(number_in_fm5_pipe),          // starting number of items for this memory
        .number_in6(number_in_fm6_pipe),          // starting number of items for this memory
        .number_in7(number_in_fm7_pipe),          // starting number of items for this memory
        .number_in8(number_in_fm8_pipe),          // starting number of items for this memory
        .number_in9(number_in_fm9_pipe),          // starting number of items for this memory
        .number_in10(number_in_fm10_pipe),          // starting number of items for this memory
        .number_in11(number_in_fm11_pipe),          // starting number of items for this memory
        .number_in12(number_in_fm12_pipe),          // starting number of items for this memory
        
        .input1(fullmatch1_i),     
        .input2(fullmatch2_i),     
        .input3(fullmatch3_i),     
        .input4(fullmatch4_i),     
        .input5(fullmatch5_i),     
        .input6(fullmatch6_i),     
        .input7(fullmatch7_i),     
        .input8(fullmatch8_i),     
        .input9(fullmatch9_i),     
        .input10(fullmatch10_i),     
        .input11(fullmatch11_i),     
        .input12(fullmatch12_i),         
        
        .read_en1(read_enable_m1),
        .read_en2(read_enable_m2),
        .read_en3(read_enable_m3),
        .read_en4(read_enable_m4),
        .read_en5(read_enable_m5),
        .read_en6(read_enable_m6),
        .read_en7(read_enable_m7),
        .read_en8(read_enable_m8),
        .read_en9(read_enable_m9),
        .read_en10(read_enable_m10),
        .read_en11(read_enable_m11),
        .read_en12(read_enable_m12),
        
        .mem_dat_stream(pre_match_data_stream),
        .valid(valid_match_data_stream),
        .send_BX(send_BX),
        .none(done_sending)                 // no more items
    );

    wire output_BX;
    wire BX_sent;
    
    
    // add a pipeline of incomming match
    reg [44:0] incomming_match_dly;    
    always @(posedge clk) begin
        incomming_match_dly <= incomming_match_data_stream;
    end

    mem_readin_top_MT #(seeding) get_matches(
        .clk(clk),
        .reset(rst_pipe),
        .data_residuals(incomming_match_dly),
        .valid(en_proc & (incomming_match_dly[43:40] != 4'h0)),
        //.data_residuals(incomming_match_data_stream),      // pulls this signal down from top level
        //.valid(en_proc & valid_incomming_match_data_stream),     // i.e. when FIFO ready from is empty
        //.valid(en_proc & (incomming_match_data_stream[43:40] != 4'h0)),     // i.e. when FIFO ready from is empty
        

        .output_BX(output_BX),
        .send_BX(BX_sent),

        .output_match_1(matchout1), //returning residuals for this memory
        .output_match_2(matchout2), //returning residuals for this memory
        .output_match_3(matchout3), //returning residuals for this memory
        .output_match_4(matchout4), //returning residuals for this memory 
        .output_match_5(matchout5), //returning residuals for this memory
        .output_match_6(matchout6), //returning residuals for this memory
        .output_match_7(matchout7), //returning residuals for this memory
        .output_match_8(matchout8), //returning residuals for this memory 
        .output_match_9(matchout9), //returning residuals for this memory 
        .output_match_10(matchout10), //returning residuals for this memory 
        .output_match_11(matchout11), //returning residuals for this memory 
        .output_match_12(matchout12), //returning residuals for this memory 
        .output_match_13(matchout13), //returning residuals for this memory 
        .output_match_14(matchout14), //returning residuals for this memory 
        .output_match_15(matchout15), //returning residuals for this memory 
        .output_match_16(matchout16), //returning residuals for this memory 
        .output_match_17(matchout17), //returning residuals for this memory 

        .wr_en_mem01(pre_valid1_1), //valid signal for writing to memory
        .wr_en_mem02(pre_valid2_1), //valid signal for writing to memory
        .wr_en_mem03(pre_valid3_1), //valid signal for writing to memory 
        .wr_en_mem04(pre_valid4_1), //valid signal for writing to memory
        .wr_en_mem05(pre_valid5_1), //valid signal for writing to memory
        .wr_en_mem06(pre_valid6_1), //valid signal for writing to memory
        .wr_en_mem07(pre_valid7_1), //valid signal for writing to memory 
        .wr_en_mem08(pre_valid8_1), //valid signal for writing to memory 
        .wr_en_mem09(pre_valid9_1), //valid signal for writing to memory 
        .wr_en_mem10(pre_valid10_1), //valid signal for writing to memory 
        .wr_en_mem11(pre_valid11_1), //valid signal for writing to memory 
        .wr_en_mem12(pre_valid12_1), //valid signal for writing to memory 
        .wr_en_mem13(pre_valid13_1), //valid signal for writing to memory 
        .wr_en_mem14(pre_valid14_1), //valid signal for writing to memory 
        .wr_en_mem15(pre_valid15_1), //valid signal for writing to memory 
        .wr_en_mem16(pre_valid16_1), //valid signal for writing to memory 
        .wr_en_mem17(pre_valid17_1) //valid signal for writing to memory 
        
    );

    parameter [7:0] n_hold = 8'd3;
 
    reg first_clk_pipe;
    
    initial begin
       BX_pipe = 4'b1111;
    end
    
    always @(posedge clk) begin
       if(rst_pipe)
           BX_pipe <= 4'b1111;
       else begin
           if(start[0]) begin
               BX_pipe <= BX_pipe + 1'b1;
               first_clk_pipe <= 1'b1;
           end
           else begin
               first_clk_pipe <= 1'b0;
           end
       end
    end

endmodule
