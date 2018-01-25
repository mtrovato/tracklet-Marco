`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 11:13:04 AM
// Design Name: 
// Module Name: InputLink
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


module InputLink(
    input clk,
    input reset,
    input en_proc,    
    input start,
    output done,
    
    input [31:0] data_in1,
    input [31:0] data_in2,
    input read_en,
    output empty,
    output reg [35:0] data_out
    );
    
      
    always @(posedge clk) begin
        data_out <= {data_in1[31:14], data_in2[31:14]};
    end

endmodule
