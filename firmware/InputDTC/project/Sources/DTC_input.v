`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2015 12:29:04 PM
// Design Name: 
// Module Name: DTC_input
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


module DTC_input(

    input clk,
    input io_clk,
    input reset,
    input BC0,
    (* mark_debug = "true" *) output track_en, 

    input BRAM_INPUT1_en,
    output [31:0] BRAM_INPUT1_dout,
    input [31:0] BRAM_INPUT1_din,
    input [3:0] BRAM_INPUT1_we,
    input [15:0] BRAM_INPUT1_addr,
    input BRAM_INPUT1_clk,
    input BRAM_INPUT1_rst,

    input BRAM_INPUT2_en,
    output [31:0] BRAM_INPUT2_dout,
    input [31:0] BRAM_INPUT2_din,
    input [3:0] BRAM_INPUT2_we,
    input [15:0] BRAM_INPUT2_addr,
    input BRAM_INPUT2_clk,
    input BRAM_INPUT2_rst,

    input BRAM_INPUT3_en,
    output [31:0] BRAM_INPUT3_dout,
    input [31:0] BRAM_INPUT3_din,
    input [3:0] BRAM_INPUT3_we,
    input [15:0] BRAM_INPUT3_addr,
    input BRAM_INPUT3_clk,
    input BRAM_INPUT3_rst,

    input BRAM_INPUT4_en,
    output [31:0] BRAM_INPUT4_dout,
    input [31:0] BRAM_INPUT4_din,
    input [3:0] BRAM_INPUT4_we,
    input [15:0] BRAM_INPUT4_addr,
    input BRAM_INPUT4_clk,
    input BRAM_INPUT4_rst,

    input BRAM_INPUT5_en,
    output [31:0] BRAM_INPUT5_dout,
    input [31:0] BRAM_INPUT5_din,
    input [3:0] BRAM_INPUT5_we,
    input [15:0] BRAM_INPUT5_addr,
    input BRAM_INPUT5_clk,
    input BRAM_INPUT5_rst,

    input BRAM_INPUT6_en,
    output [31:0] BRAM_INPUT6_dout,
    input [31:0] BRAM_INPUT6_din,
    input [3:0] BRAM_INPUT6_we,
    input [15:0] BRAM_INPUT6_addr,
    input BRAM_INPUT6_clk,
    input BRAM_INPUT6_rst,

    input [31:0] input_link1_reg1,
    input [31:0] input_link1_reg2,
    input [31:0] input_link2_reg1,
    input [31:0] input_link2_reg2,
    input [31:0] input_link3_reg1,
    input [31:0] input_link3_reg2,
     
    output [35:0] input_link1,
    output [35:0] input_link2,
    output [35:0] input_link3

    );
    
    reg enable;
    reg enable1;
    reg enable2;
    
    assign track_en = read_en;
    
    // on the io_clk (= link clock?), if it gets the input "GO" signal (= deadbeef), set enable signal to 1 else 0
    always @ (posedge io_clk) begin
        if (input_link1_reg1 == 32'hdeadbeef)
            enable <= 1'b1;
        else
            enable <= 1'b0;
    end
    
    // delay enable signal with one (240 MHz) clock cycle
    always @ (posedge clk) begin
        enable1 <= enable;
        enable2 <= enable1;
    end
    
    // state machine (it's always 0 except when it gets GO signal combined with BC0
    statem read_enable(
    .clk(clk),          // input (240 MHz) clock
    .reset(reset),      // reset signal
    .in(enable2 & BC0), // input (bitwise and of input GO signal and BC0)
    .out(read_en)       // output is register (0 or 1)
    );
     
    
    // 36-bit memory for the input stubs
    StubInput StubInput_link1(
    .clk(clk),
    .io_clk(io_clk),
    .reset(reset),
    .BC0(BC0),
    .read_en(read_en),
    .BRAM_INPUT1_en(BRAM_INPUT1_en),
    .BRAM_INPUT1_dout(BRAM_INPUT1_dout),
    .BRAM_INPUT1_din(BRAM_INPUT1_din),
    .BRAM_INPUT1_we(BRAM_INPUT1_we),
    .BRAM_INPUT1_addr(BRAM_INPUT1_addr),
    .BRAM_INPUT1_clk(BRAM_INPUT1_clk),
    .BRAM_INPUT1_rst(BRAM_INPUT1_rst),
    .BRAM_INPUT2_en(BRAM_INPUT2_en),
    .BRAM_INPUT2_dout(BRAM_INPUT2_dout),
    .BRAM_INPUT2_din(BRAM_INPUT2_din),
    .BRAM_INPUT2_we(BRAM_INPUT2_we),
    .BRAM_INPUT2_addr(BRAM_INPUT2_addr),
    .BRAM_INPUT2_clk(BRAM_INPUT2_clk),
    .BRAM_INPUT2_rst(BRAM_INPUT2_rst),
    .input_reg1(input_link1_reg1),
    .input_reg2(input_link1_reg2),
    .data_out(input_link1)
    );
    
    StubInput StubInput_link2(
    .clk(clk),
    .io_clk(io_clk),
    .reset(reset),
    .BC0(BC0),
    .read_en(read_en),
    .BRAM_INPUT1_en(BRAM_INPUT3_en),
    .BRAM_INPUT1_dout(BRAM_INPUT3_dout),
    .BRAM_INPUT1_din(BRAM_INPUT3_din),
    .BRAM_INPUT1_we(BRAM_INPUT3_we),
    .BRAM_INPUT1_addr(BRAM_INPUT3_addr),
    .BRAM_INPUT1_clk(BRAM_INPUT3_clk),
    .BRAM_INPUT1_rst(BRAM_INPUT3_rst),
    .BRAM_INPUT2_en(BRAM_INPUT4_en),
    .BRAM_INPUT2_dout(BRAM_INPUT4_dout),
    .BRAM_INPUT2_din(BRAM_INPUT4_din),
    .BRAM_INPUT2_we(BRAM_INPUT4_we),
    .BRAM_INPUT2_addr(BRAM_INPUT4_addr),
    .BRAM_INPUT2_clk(BRAM_INPUT4_clk),
    .BRAM_INPUT2_rst(BRAM_INPUT4_rst),
    .input_reg1(input_link2_reg1),
    .input_reg2(input_link2_reg2),
    .data_out(input_link2)
    );
    
    StubInput StubInput_link3(
    .clk(clk),
    .io_clk(io_clk),
    .reset(reset),
    .BC0(BC0),
    .read_en(read_en),
    .BRAM_INPUT1_en(BRAM_INPUT5_en),
    .BRAM_INPUT1_dout(BRAM_INPUT5_dout),
    .BRAM_INPUT1_din(BRAM_INPUT5_din),
    .BRAM_INPUT1_we(BRAM_INPUT5_we),
    .BRAM_INPUT1_addr(BRAM_INPUT5_addr),
    .BRAM_INPUT1_clk(BRAM_INPUT5_clk),
    .BRAM_INPUT1_rst(BRAM_INPUT5_rst),
    .BRAM_INPUT2_en(BRAM_INPUT6_en),
    .BRAM_INPUT2_dout(BRAM_INPUT6_dout),
    .BRAM_INPUT2_din(BRAM_INPUT6_din),
    .BRAM_INPUT2_we(BRAM_INPUT6_we),
    .BRAM_INPUT2_addr(BRAM_INPUT6_addr),
    .BRAM_INPUT2_clk(BRAM_INPUT6_clk),
    .BRAM_INPUT2_rst(BRAM_INPUT6_rst),
    .input_reg1(input_link3_reg1),
    .input_reg2(input_link3_reg2),
    .data_out(input_link3)
    );
           
       
endmodule
