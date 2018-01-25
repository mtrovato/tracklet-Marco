`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2015 09:34:46 AM
// Design Name: 
// Module Name: statem
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


module enable_generator(
    input clk,
    input in,
    output reg out
    );
    
    reg [1:0] state;
    
    parameter zero=0, one=1;
    initial
        state = 0;
    
    always @(state) 
         begin
              case (state)
                   zero:
                        out = 1'b0;
                   one:
                        out = 1'b1;
                   
                   default:
                        out = 1'b0;
              endcase
         end
    
    always @(posedge clk) begin
        case (state)
            zero:
                if(in)
                    state = one;
                else
                    state = zero;
            one:                        
                state = one;
        endcase
    end
    
endmodule
