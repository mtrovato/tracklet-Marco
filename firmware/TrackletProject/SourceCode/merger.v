`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2015 05:50:36 PM
// Design Name: 
// Module Name: merger
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


module merger #(
    parameter DATA_WIDTH = 12,
    parameter ACTIVE_MSB = 11,
    parameter ACTIVE_LSB = 6
)
    (
    input clk,
    input en,
    input reset,
    input [DATA_WIDTH-1:0] inputA,
    input validA_i,
    output outreadA,
    input [DATA_WIDTH-1:0] inputB,
    input validB_i,
    output outreadB,
    input inRead,
    output reg [DATA_WIDTH-1:0] out,
    output reg vout
    );
    
	reg vA;
    reg vB;
    reg sA;
    reg sB;
    //reg presA;
    //reg presB;
    reg [DATA_WIDTH-1:0] A;
    reg [DATA_WIDTH-1:0] B;
    
    wire validA;
    wire validB;
    assign validA = validA_i && en;
    assign validB = validB_i && en;
    
    assign outreadA = ((inRead || !vout) && sA || !vA) && validA;
    assign outreadB = ((inRead || !vout) && sB || !vB) && validB;
    
    always @ (posedge clk) begin
        if (reset) begin
            vA <= 0;
            vB <= 0;
            sA <= 0;
            sB <= 0;
            vout <= 0;
            out <= ~0;
        end
        else begin
            if (sA && (inRead || !vout)) begin
            //#0.1
                out <= A;
                vout <= vA;
                A <= inputA;
                vA <= validA;
                sA <= ( (inputA[ACTIVE_MSB:ACTIVE_LSB] <= B[ACTIVE_MSB:ACTIVE_LSB]) | !vB ) & validA;
                sB <= (!(inputA[ACTIVE_MSB:ACTIVE_LSB] <= B[ACTIVE_MSB:ACTIVE_LSB]) | !validA ) & vB;
            end
            
            if (sB && (inRead || !vout)) begin
            //#0.1
                out <= B;
                vout <= vB;
                B <= inputB;
                vB <= validB;
                sB <= ( (inputB[ACTIVE_MSB:ACTIVE_LSB] < A[ACTIVE_MSB:ACTIVE_LSB]) | !vA ) & validB;
                sA <= (!(inputB[ACTIVE_MSB:ACTIVE_LSB] < A[ACTIVE_MSB:ACTIVE_LSB]) | !validB ) & vA;  
            end     
                
            if ((!sA & !sB) & (validA | validB) & !vout) begin
            //#0.1
                vA <= validA;
                A <= inputA;
                vB <= validB;
                B <= inputB;
                sA <= ( (inputA[ACTIVE_MSB:ACTIVE_LSB] <= inputB[ACTIVE_MSB:ACTIVE_LSB]) & validA & validB) | (!validB & validA);
                sB <= (!(inputA[ACTIVE_MSB:ACTIVE_LSB] <= inputB[ACTIVE_MSB:ACTIVE_LSB]) & validA & validB) | (!validA & validB);
            end   
            
            if (!sB & !sA & vout & inRead) begin
                //#0.1 
                vout <= 0;
                out <= ~0;
            end
        end
        
    end
    
endmodule
