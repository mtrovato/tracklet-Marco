`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2015 03:42:38 PM
// Design Name: 
// Module Name: Track_Sink
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


module Track_Sink(
    input clk,
    input io_clk,
    input reset,
    input BC0,
    (* mark_debug = "true" *) input track_en,

    (* mark_debug = "true" *) input [15:0] BRAM_OUTPUT1_addr, 
    (* mark_debug = "true" *) output [31:0] BRAM_OUTPUT1_dout, 
    (* mark_debug = "true" *) input [15:0] BRAM_OUTPUT2_addr, 
    (* mark_debug = "true" *) output [31:0] BRAM_OUTPUT2_dout, 
    //input [15:0] BRAM_OUTPUT3_addr, 
    //output [31:0] BRAM_OUTPUT3_dout, 
        
    (* mark_debug = "true" *) input [63:0] track_output,
    
    (* mark_debug = "true" *) output valid_track,
    (* mark_debug = "true" *) output [4:0] track_BX,
    //output reg [31:0] track_reg1,
    //output reg [31:0] track_reg2,
    output reg [31:0] ecounter
    
    );
    
    (* mark_debug = "true" *) reg [11:0] write_add;
    reg [63:0] track_dly;
    //reg [63:0] track_dly2;
    //reg [63:0] track_dly3;
    //reg [63:0] track_dly4;
    (* mark_debug = "true" *) reg [31:0] track_1;
    (* mark_debug = "true" *) reg [31:0] track_2;
    (* mark_debug = "true" *) reg wr_en;
    //reg [59:0] tracks1 [0:99];
    //reg [59:0] tracks2 [0:99];
    //reg [4:0] tcounter;
    //reg [31:0] sum1;
    //reg [31:0] sum2;
    /*
    wire BC0_dly;
    wire BC0_dly2;
    wire gap;
    
    pipe_delay #(.STAGES(700), .WIDTH(1))
                   begin_gap(.pipe_in(), .pipe_out(), .clk(clk),
                   .val_in(BC0), .val_out(BC0_dly));
    
    pipe_delay #(.STAGES(780), .WIDTH(1))
                   end_gap(.pipe_in(), .pipe_out(), .clk(clk),
                   .val_in(BC0), .val_out(BC0_dly2));
    */
    /*
    // state machine (it's always 0 except when it gets GO signal combined with BC0
    statem abort_gap(
    .clk(clk),          // input (240 MHz) clock
    .reset(BC0_dly),      // reset signal
    .in(BC0_dly2), // input (bitwise and of input GO signal and BC0)
    .out(gap)       // output is register (0 or 1)
    );
    */
     
    //assign valid_track = (track_dly[31:8] != 24'h0 && track_dly[63:40] != 24'h0 && track_en) & gap;
    assign valid_track = (track_dly[31:8] != 24'h0 && track_dly[63:40] != 24'h0 && track_en);
    
    
    assign track_BX[4:0] = track_dly[63:59];

    initial begin
        write_add = 12'h0;
        /*
        tracks1[1] = 60'h73240a694072825;
        tracks1[5] = 60'h79b718cce0707e9;
        tracks1[6] = 60'h7967029760e4fec;
        tracks1[7] = 60'h63c30493408889f;
        tracks1[9] = 60'h73c901fe60f8802;
        tracks1[10] = 60'h6c6305f28107008;
        tracks1[11] = 60'h6da40b5320d3fb9;
        tracks1[15] = 60'h795a14c6c0c4855;
        tracks2[15] = 60'h795b14c700c6851;
        tracks1[16] = 60'h691107f920b683e;
        tracks1[17] = 60'h72f802b0a0457fb;
        tracks1[18] = 60'h66640226603c079;
        tracks1[19] = 60'h6b100b9c00d0801;
        tracks1[20] = 60'h787419bf210f02c;
        tracks1[23] = 60'h68e40be6602d804;
        tracks2[23] = 60'h68e30be6a02e803;
        tracks1[24] = 60'h6fb60ba580c9fcc;
        tracks1[26] = 60'h73b91536e02f82e;
        tracks2[26] = 60'h73bc1539e02f02e;
        tracks1[28] = 60'h79cd0f4b40f0032;
        tracks2[28] = 60'h79ca0f48e0f1031;
        tracks1[29] = 60'h78720bf6c01d807;
        tracks2[29] = 60'h78700bf5a01d009;
        tracks1[31] = 60'h78bd077e603401c;
        tracks1[33] = 60'h72060f24a0a8833;
        tracks2[33] = 60'h72010f2100a9032;
        tracks1[34] = 60'h78ec02b9e09c818;
        tracks1[35] = 60'h70db0c3b603f82d;
        tracks2[35] = 60'h70f40c49e03e030;
        tracks1[37] = 60'h709a16af6069051;
        tracks1[38] = 60'h78650a9020e8049;
        tracks1[39] = 60'h6c4b071de0f004f;
        tracks2[39] = 60'h6c430717e0ef850;
        tracks1[40] = 60'h78a2162660b3fa9;
        tracks1[41] = 60'h6f2d165ae06e030;
        tracks1[44] = 60'h78950912c0f3834;
        tracks1[45] = 60'h745601bfe0a280c;
        tracks1[46] = 60'h77d01687c0dbfcd;
        tracks1[50] = 60'h79a908e4202283d;
        tracks1[51] = 60'h6d3e046740ce051;
        tracks1[55] = 60'h75d109ad40cc012;
        tracks1[59] = 60'h6b320ae3a0b9032;
        tracks1[60] = 60'h79d10a62007e831;
        tracks1[62] = 60'h79f00b89003bfe2;
        tracks1[63] = 60'h680000352044836;
        tracks1[66] = 60'h77050afe603e01d;
        tracks2[66] = 60'h77040afd603d01e;
        tracks1[67] = 60'h73901704e0de828;
        tracks1[68] = 60'h77970a1d80f3087;
        tracks1[70] = 60'h756911cd8072802;
        tracks1[72] = 60'h712a0e8c40c57d7;
        tracks1[76] = 60'h78a919eac00a006;
        tracks1[77] = 60'h6fe20a8f00b1ff8;
        tracks1[78] = 60'h692f0f7c00f77cd;
        tracks1[83] = 60'h701d0fbd205b7ea;
        tracks1[89] = 60'h777612fda0b7855;
        tracks2[89] = 60'h777f130260b7857;
        tracks1[91] = 60'h76c10eea20daff1;
        tracks1[92] = 60'h785c0bd620c17e9;
        tracks1[94] = 60'h77bf021aa0e17e1;
        tracks2[94] = 60'h77bf021b00e17e2;
        tracks1[96] = 60'h6f4814a8210081d;
        tracks2[96] = 60'h6f4714a7c10101c;
        tracks1[98] = 60'h7852194600c5fed;
        
        tcounter = 5'b11111;
        ecounter = 32'h0;
        sum1 = 32'h0;
        sum2 = 32'h0;
        */
    end
   
    
    always @(posedge clk) begin
        track_dly  <= track_output;
        //track_dly2 <= track_dly;
        //track_dly3 <= track_dly2;
        //track_dly4 <= track_dly3;
        if(track_dly[31:8] != 24'h0 && track_dly[63:40] != 24'h0 && write_add != 12'hffc && track_en) begin
            wr_en <= 1'b1;
            track_1 <= track_dly[63:32];
            track_2 <= track_dly[31:0];
            write_add  <= write_add + 3'b100;           
        end
        else begin
            write_add <= write_add;
            wr_en <= 0;
        end
        
        /*         
        tcounter <= track_output[63:59];         
        if(valid_track) begin
            sum1 <= track_dly[58:0] - tracks1[tcounter];
            sum2 <= track_dly[58:0] - tracks2[tcounter];
        end
        else begin
            sum1 <= 32'h0;
            sum2 <= 32'h0;
        end
        if(sum1 == 0)
            ecounter <= ecounter;
        else begin
            if(sum2 == 0)
                ecounter <= ecounter;
            else
                ecounter <= ecounter + 1'b1;
        end
        */
    end
    
    
    
    
    
    
    Memory #(
        .RAM_WIDTH(32),                  // Specify RAM data width
        .RAM_DEPTH(4096),                 // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                   // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) track_mem1 (
        .addra(write_add),               // Write address bus, width determined from RAM_DEPTH
        .addrb(BRAM_OUTPUT1_addr),                // Read address bus, width determined from RAM_DEPTH
        .dina(track_1),              // RAM input data, width determined from RAM_WIDTH
        .clka(clk),                   // Write clock
        .clkb(io_clk),                      // Read clock
        .wea(wr_en), // Write enable
        .enb(1'b1),                      // Read Enable, for additional power savings, disable when not in use
        .rstb(reset),                    // Output reset (does not affect memory contents)
        .regceb(1'b1),                   // Output register enable
        .doutb(BRAM_OUTPUT1_dout)                 // RAM output data, width determined from RAM_WIDTH
        );
      Memory #(
        .RAM_WIDTH(32),                  // Specify RAM data width
        .RAM_DEPTH(4096),                 // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                   // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) track_mem2 (
        .addra(write_add),               // Write address bus, width determined from RAM_DEPTH
        .addrb(BRAM_OUTPUT2_addr),                // Read address bus, width determined from RAM_DEPTH
        .dina(track_2),              // RAM input data, width determined from RAM_WIDTH
        .clka(clk),                   // Write clock
        .clkb(io_clk),                      // Read clock
        .wea(wr_en), // Write enable
        .enb(1'b1),                      // Read Enable, for additional power savings, disable when not in use
        .rstb(reset),                    // Output reset (does not affect memory contents)
        .regceb(1'b1),                   // Output register enable
        .doutb(BRAM_OUTPUT2_dout)                 // RAM output data, width determined from RAM_WIDTH
        );
        
endmodule
