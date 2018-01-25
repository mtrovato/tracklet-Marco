`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2015 04:43:00 PM
// Design Name: 
// Module Name: TProjMemory
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


module TProjRecMemory(
    input wire proc_clk, //out clk
    input wire out_clk,  //in clk
    input wire reset,
    input [54:0] proj,
    output reg valid,
    output [54:0] projout
    );
    
//    always @ (posedge proc_clk) begin
//        if ( proj[47:44] != 4'h0 ) valid <= 1'b1;  
//        else valid <= 1'b0;
//        projout <= proj;
//    end
    
    wire FIFO_FULL, FIFO_EMPTY;
    reg FIFO_RST, FIFO_rd_en;
    wire FIFO_wr_en;
    
    assign FIFO_wr_en = (proj[54:51] != 4'h0) ? 1'b1:1'b0;
    
    initial 
    FIFO_RST <= 1'b1;
    
    always @ (posedge proc_clk) begin
       FIFO_RST <= 1'b0;
       FIFO_rd_en <= 1'b1;
       valid <= !FIFO_EMPTY;
    end
   
    fifo_projection_out rec_fifo(
       .rst(reset),                     // input wire rst
       .wr_clk(out_clk),                   // input wire wr_clk
       .rd_clk(proc_clk),                  // input wire rd_clk
       .din(proj[54:0]),                   // input wire [47 : 0] din
       .wr_en(FIFO_wr_en),                 // input wire wr_en
       .rd_en(FIFO_rd_en),                 // input wire rd_en
       .dout(projout),                     // output wire [47 : 0] dout
       .full(FIFO_FULL),                   // output wire full
       .empty(FIFO_EMPTY)                  // output wire empty
    );
    
endmodule
