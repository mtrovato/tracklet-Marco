// Mux to route data from the port that is currently selected

`timescale 1ns / 1ps

module mem_mux_MT(
    input clk,
    input [2:0] BX,
    input [4:0] sel,   // binary encoded
    input [39:0] mem_dat00,
    input [39:0] mem_dat01,
    input [39:0] mem_dat02,
    input [39:0] mem_dat03,
    input [39:0] mem_dat04,
    input [39:0] mem_dat05,
    input [39:0] mem_dat06,
    input [39:0] mem_dat07,
    input [39:0] mem_dat08,
    input [39:0] mem_dat09,
    input [39:0] mem_dat10,
    input [39:0] mem_dat11,
    
    output reg [44:0] mem_dat_stream                     
);

//////////////////////////////////////////////////////////////////////////
// Implement an 8:1 mux. This works better with with an encoded 'select'
// as compared to individual 'select' signals.
always @ (posedge clk) begin
    case (sel[4:0])
        5'b11111: mem_dat_stream <= {sel,BX,37'h00000000};
        5'b00001: mem_dat_stream <= {sel,mem_dat00};
        5'b00010: mem_dat_stream <= {sel,mem_dat01};
        5'b00011: mem_dat_stream <= {sel,mem_dat02};
        5'b00100: mem_dat_stream <= {sel,mem_dat03};
        5'b00101: mem_dat_stream <= {sel,mem_dat04};
        5'b00110: mem_dat_stream <= {sel,mem_dat05};
        5'b00111: mem_dat_stream <= {sel,mem_dat06};
        5'b01000: mem_dat_stream <= {sel,mem_dat07};
        5'b01001: mem_dat_stream <= {sel,mem_dat08};
        5'b01010: mem_dat_stream <= {sel,mem_dat09};
        5'b01011: mem_dat_stream <= {sel,mem_dat10};
        5'b01100: mem_dat_stream <= {sel,mem_dat11};
        default  mem_dat_stream <= 45'h0000000000;
    endcase
end

endmodule
