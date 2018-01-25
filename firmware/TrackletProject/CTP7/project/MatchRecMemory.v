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


module MatchRecMemory(
    input wire proc_clk, //out clk
    input wire out_clk,  //in clk
    input wire reset,
    input [43:0] match,
    output reg valid,
    output [43:0] matchout
);

//    always @ (posedge proc_clk) begin
//        if ( proj[47:44] != 4'h0 ) valid <= 1'b1;  
//        else valid <= 1'b0;
//        projout <= proj;
//    end

wire FIFO_wr_en, FIFO_FULL, FIFO_EMPTY;
reg FIFO_RST, FIFO_rd_en;

initial 
FIFO_RST <= 1'b1;

always @ (posedge proc_clk) begin
   FIFO_RST <= 1'b0;
   FIFO_rd_en <= 1'b1;
   valid <= !FIFO_EMPTY;
end

assign FIFO_wr_en = (match[43:40] != 4'h0) ? 1'b1:1'b0;

fifo_match_out rec_match_fifo(
   .rst(reset),                     // input wire rst
   .wr_clk(out_clk),                   // input wire wr_clk
   .rd_clk(proc_clk),                  // input wire rd_clk
   .din(match[43:0]),                   // input wire [43 : 0] din
   .wr_en(FIFO_wr_en),                 // input wire wr_en
   .rd_en(FIFO_rd_en),                 // input wire rd_en
   .dout(matchout),                     // output wire [43 : 0] dout
   .full(FIFO_FULL),                   // output wire full
   .empty(FIFO_EMPTY)                  // output wire empty
);

endmodule
 
    /*
     Memory #(
        .RAM_WIDTH(48),                       // Specify RAM data width
        .RAM_DEPTH(512),                     // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) ProjToPlus (
        .addra({BX,wr_add}),    // Write address bus, width determined from RAM_DEPTH
        .addrb(read_add),    // Read address bus, width determined from RAM_DEPTH
        .dina(proj[47:0]),      // RAM input data, width determined from RAM_WIDTH
        .clka(proc_clk),         // Write clock
        .clkb(out_clk),      // Read clock
        .wea(valid),        // Write enable
        .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use
        .rstb(1'b0),      // Output reset (does not affect memory contents)
        .regceb(1'b1),      // Output register enable
        .doutb(projout)     // RAM output data, width determined from RAM_WIDTH
        );
    
    */