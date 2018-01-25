// Priority encoder to choose the next memory block that contains data. It
// skips over empty blocks.

`timescale 1ns / 1ps

module prio_encoder_2(
    // Inputs:
    input clk,
    input first_dat,
    input has_dat00,
    input has_dat01,
    input has_dat02,
    input has_dat03,
    input has_dat04,
    input has_dat05,
    input has_dat06,
    input has_dat07,
    input has_dat08,
    input has_dat09,
    input has_dat10,
    input has_dat11,
    input has_dat12,
    input has_dat13,
    input has_dat14,
    input has_dat15,
    input has_dat16,
    input has_dat17,
    input has_dat18,
    input has_dat19,
    // Outputs:
    //output reg first,
    output reg sel00,
    output reg sel01,
    output reg sel02,
    output reg sel03,
    output reg sel04,
    output reg sel05,
    output reg sel06,
    output reg sel07,
    output reg sel08,
    output reg sel09,
    output reg sel10,
    output reg sel11,
    output reg sel12,
    output reg sel13,
    output reg sel14,
    output reg sel15,
    output reg sel16,
    output reg sel17,
    output reg sel18,
    output reg sel19,
    output reg [4:0] sel,   // binary encoded
    output reg none
);

reg first;

//////////////////////////////////////////////////////////////////////////
// Implement a registered priority encoder
// The '00' input has the highest priority
always @ (posedge clk) begin
    if (first_dat) begin
        first <= 1'b1;
        sel00 <= 1'b0;
        sel01 <= 1'b0;
        sel02 <= 1'b0;
        sel03 <= 1'b0;
        sel04 <= 1'b0;
        sel05 <= 1'b0;
        sel06 <= 1'b0;
        sel07 <= 1'b0;
        sel08 <= 1'b0;
        sel09 <= 1'b0;
        sel10 <= 1'b0;
        sel11 <= 1'b0;
        sel12 <= 1'b0;
        sel13 <= 1'b0;
        sel14 <= 1'b0;
        sel15 <= 1'b0;
        sel16 <= 1'b0;
        sel17 <= 1'b0;
        sel18 <= 1'b0;
        sel19 <= 1'b0;
        none  <= 1'b0;
    end
    else begin
        first <= 1'b0;
        sel00 <= has_dat00;
        sel01 <= has_dat01 & !has_dat00;
        sel02 <= has_dat02 & !has_dat00 & !has_dat01;
        sel03 <= has_dat03 & !has_dat00 & !has_dat01 & !has_dat02;
        sel04 <= has_dat04 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03;
        sel05 <= has_dat05 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04;
        sel06 <= has_dat06 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05;
        sel07 <= has_dat07 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06;
        sel08 <= has_dat08 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07;
        sel09 <= has_dat09 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08;
        sel10 <= has_dat10 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09;
        sel11 <= has_dat11 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10;
        sel12 <= has_dat12 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11;
        sel13 <= has_dat13 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12;
        sel14 <= has_dat14 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13;
        sel15 <= has_dat15 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14;
        sel16 <= has_dat16 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15;
        sel17 <= has_dat17 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16;
        sel18 <= has_dat18 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17;
        sel19 <= has_dat19 & !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 & !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18;
       // assert 'none' when all inputs are false
        none <= !has_dat00 & !has_dat01 & !has_dat02 & !has_dat03 & !has_dat04 & !has_dat05 & !has_dat06 & !has_dat07 & !has_dat08 & !has_dat09 &
                !has_dat10 & !has_dat11 & !has_dat12 & !has_dat13 & !has_dat14 & !has_dat15 & !has_dat16 & !has_dat17 & !has_dat18 & !has_dat19;
    end

end 

//////////////////////////////////////////////////////////////////////////
// Implement an 8:3 encoder. The final mux that combines the memory streams
// works better with with an encoded select as compared to individual select signals.
always @ (posedge clk) begin
    if (first) sel <= 5'b11111;
    if (sel00) sel <= 5'b00001;
    if (sel01) sel <= 5'b00010;
    if (sel02) sel <= 5'b00011;
    if (sel03) sel <= 5'b00100;
    if (sel04) sel <= 5'b00101;
    if (sel05) sel <= 5'b00110;
    if (sel06) sel <= 5'b00111;
    if (sel07) sel <= 5'b01000;
    if (sel08) sel <= 5'b01001;
    if (sel09) sel <= 5'b01010;
    if (sel10) sel <= 5'b01011;
    if (sel11) sel <= 5'b01100;
    if (sel12) sel <= 5'b01101;
    if (sel13) sel <= 5'b01110;
    if (sel14) sel <= 5'b01111;
    if (sel15) sel <= 5'b10000;
    if (sel16) sel <= 5'b10001;
    if (sel17) sel <= 5'b10010;
    if (sel18) sel <= 5'b10011;
    if (sel19) sel <= 5'b10100;
end
           
endmodule