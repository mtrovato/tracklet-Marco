`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2015 04:26:05 PM
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


module statem(
    input clk,
    input in,
    input reset, 
    output reg out
    );
    
    reg [1:0] state;
    
    parameter zero=0, one=1;
    
    always @ (state) begin
        case (state)
            zero:
                out = 1'b0;
            one:
                out = 1'b1;
            default:
                out = 1'b0;
        endcase
    end
    
    always @ (posedge clk or posedge reset) begin
        if (reset)
            state = zero;
        else 
            case (state)
                zero: 
                    if (in)
                        state = one;
                    else 
                        state = zero;
                one:
                    state = one;
            endcase
    end
    
endmodule
