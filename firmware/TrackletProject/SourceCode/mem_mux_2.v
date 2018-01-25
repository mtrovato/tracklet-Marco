// Mux to route data from the port that is currently selected

`timescale 1ns / 1ps

module mem_mux_2(
    input clk,
    input [2:0] BX,
    input [4:0] sel,   // binary encoded
    input [50:0] mem_dat00,
    input [50:0] mem_dat01,
    input [50:0] mem_dat02,
    input [50:0] mem_dat03,
    input [50:0] mem_dat04,
    input [50:0] mem_dat05,
    input [50:0] mem_dat06,
    input [50:0] mem_dat07,
    input [50:0] mem_dat08,
    input [50:0] mem_dat09,
    input [50:0] mem_dat10,
    input [50:0] mem_dat11,
    input [50:0] mem_dat12,
    input [50:0] mem_dat13,
    input [50:0] mem_dat14,
    input [50:0] mem_dat15,
    input [50:0] mem_dat16,
    input [50:0] mem_dat17,
    input [50:0] mem_dat18,
    input [50:0] mem_dat19,
    
    output reg [54:0] mem_dat_stream                     
);
parameter LD_COMBINATION = "L3F3F5";
//////////////////////////////////////////////////////////////////////////
// Implement an 8:1 mux. This works better with with an encoded 'select'
// as compared to individual 'select' signals.
generate
    if(LD_COMBINATION == "L3F3F5")
        always @ (posedge clk) begin
            case (sel[4:0])
                5'b11111: mem_dat_stream <= {sel,BX,48'h000000000000};
                // DISKS
                5'b00001: mem_dat_stream <= {4'b1000,mem_dat00}; // F1D5L1D4_F5
                5'b00010: mem_dat_stream <= {4'b1000,mem_dat01}; // F1D5F2D5_F5
                5'b00011: mem_dat_stream <= {4'b1001,mem_dat02}; // F3D5F4D5_F5
                
                5'b00100: mem_dat_stream <= {4'b1010,mem_dat03}; // L1D3L2D4_F3
                5'b00101: mem_dat_stream <= {4'b1010,mem_dat04}; // L1D4L2D4_F3
                5'b00110: mem_dat_stream <= {4'b1010,mem_dat05}; // F1D5L1D4_F3
                5'b00111: mem_dat_stream <= {4'b1010,mem_dat06}; // F1D5F2D5_F3
                // LAYERS
                5'b01000: mem_dat_stream <= {4'b0100,mem_dat07}; // L1D3L2D3_L3
                5'b01001: mem_dat_stream <= {4'b0100,mem_dat08}; // L1D3L2D4_L3
                5'b01010: mem_dat_stream <= {4'b0100,mem_dat09}; // L1D4L2D4_L3
                5'b01011: mem_dat_stream <= {4'b0101,mem_dat10}; // L5D3L6D3_L3
                5'b01100: mem_dat_stream <= {4'b0101,mem_dat11}; // L5D3L6D4_L3
                5'b01101: mem_dat_stream <= {4'b0101,mem_dat12}; // L5D4L6D4_L3
                default  mem_dat_stream <= 55'h0000000000000;
            endcase
        end
    else if(LD_COMBINATION == "L2L4F2")
        always @ (posedge clk) begin
            case (sel[4:0])
                5'b11111: mem_dat_stream <= {sel,BX,48'h000000000000};
                // DISKS
                5'b00001: mem_dat_stream <= {4'b1000,mem_dat00}; // L1D3L2D4_F2
                5'b00010: mem_dat_stream <= {4'b1000,mem_dat01}; // L1D4L2D4_F2
                5'b00011: mem_dat_stream <= {4'b1000,mem_dat02}; // L3D4L4D4_F2
                5'b00100: mem_dat_stream <= {4'b1000,mem_dat03}; // F1D5L1D4_F2
                5'b00101: mem_dat_stream <= {4'b1000,mem_dat04}; // F3D5F4D5_F2
                // LAYERS 
                5'b01000: mem_dat_stream <= {4'b0010,mem_dat07}; // L1D3L2D3_L4
                5'b01001: mem_dat_stream <= {4'b0010,mem_dat08}; // L1D3L2D4_L4
                5'b01010: mem_dat_stream <= {4'b0010,mem_dat09}; // L1D4L2D4_L4
                5'b01011: mem_dat_stream <= {4'b0011,mem_dat10}; // L5D3L6D3_L4
                5'b01100: mem_dat_stream <= {4'b0011,mem_dat11}; // L5D3L6D4_L4
                5'b01101: mem_dat_stream <= {4'b0011,mem_dat12}; // L5D4L6D4_L4
                
                5'b01110: mem_dat_stream <= {4'b0100,mem_dat13}; // L3D3L4D3_L2
                5'b01111: mem_dat_stream <= {4'b0100,mem_dat14}; // L3D3L4D4_L2
                5'b10000: mem_dat_stream <= {4'b0100,mem_dat15}; // L3D4L4D4_L2
                5'b10001: mem_dat_stream <= {4'b0101,mem_dat16}; // L5D3L6D3_L2
                5'b10010: mem_dat_stream <= {4'b0101,mem_dat17}; // L5D3L6D4_L2
                5'b10011: mem_dat_stream <= {4'b0101,mem_dat18}; // L5D4L6D4_L2
                5'b10100: mem_dat_stream <= {4'b0101,mem_dat19}; // F1D5F2D5_L2
                default  mem_dat_stream <= 55'h0000000000000;
            endcase
        end
    else if(LD_COMBINATION == "F1L5")
        always @ (posedge clk) begin
            case (sel[4:0])
                5'b11111: mem_dat_stream <= {4'b1000,BX,48'h000000000000};
                // DISKS
                5'b00001: mem_dat_stream <= {4'b1000,mem_dat00}; // L1D3L2D3_F1
                5'b00010: mem_dat_stream <= {4'b1000,mem_dat01}; // L1D3L2D4_F1
                5'b00011: mem_dat_stream <= {4'b1000,mem_dat02}; // L1D4L2D4_F1
                5'b00100: mem_dat_stream <= {4'b1000,mem_dat03}; // L3D4L4D4_F1
                5'b00101: mem_dat_stream <= {4'b1000,mem_dat04}; // F3D5F4D5_F1
                // LAYERS
                5'b01000: mem_dat_stream <= {4'b0010,mem_dat07}; // L1D3L2D3_L5
                5'b01001: mem_dat_stream <= {4'b0010,mem_dat08}; // L1D3L2D4_L5
                5'b01010: mem_dat_stream <= {4'b0010,mem_dat09}; // L1D4L2D4_L5
                5'b01011: mem_dat_stream <= {4'b0011,mem_dat10}; // L3D3L4D3_L5
                5'b01100: mem_dat_stream <= {4'b0011,mem_dat11}; // L3D3L4D4_L5
                5'b01101: mem_dat_stream <= {4'b0011,mem_dat12}; // L3D4L4D4_L5
                default  mem_dat_stream <= 55'h0000000000000;
            endcase
        end
    else if(LD_COMBINATION == "L1L6F4")
        always @ (posedge clk) begin
            case (sel[4:0])
                5'b11111: mem_dat_stream <= {4'b1000,BX,48'h000000000000};
                // DISKS
                5'b00001: mem_dat_stream <= {4'b1000,mem_dat00}; // L1D3L2D4_F4
                5'b00010: mem_dat_stream <= {4'b1000,mem_dat01}; // L1D4L2D4_F4
                5'b00011: mem_dat_stream <= {4'b1000,mem_dat02}; // F1D5L1D4_F4
                5'b00100: mem_dat_stream <= {4'b1000,mem_dat03}; // F1D5F2D5_F4
                // LAYERS
                5'b01000: mem_dat_stream <= {4'b0010,mem_dat07}; // L1D3L2D3_L6
                5'b01001: mem_dat_stream <= {4'b0010,mem_dat08}; // L1D3L2D4_L6
                5'b01010: mem_dat_stream <= {4'b0010,mem_dat09}; // L1D4L2D4_L6
                5'b01011: mem_dat_stream <= {4'b0011,mem_dat10}; // L3D3L4D3_L6
                5'b01100: mem_dat_stream <= {4'b0011,mem_dat11}; // L3D3L4D4_L6
                5'b01101: mem_dat_stream <= {4'b0011,mem_dat12}; // L3D4L4D4_L6
                
                5'b01110: mem_dat_stream <= {4'b0100,mem_dat13}; // L3D3L4D3_L1
                5'b01111: mem_dat_stream <= {4'b0100,mem_dat14}; // L3D3L4D4_L1
                5'b10000: mem_dat_stream <= {4'b0100,mem_dat15}; // L3D4L4D4_L1
                5'b10001: mem_dat_stream <= {4'b0101,mem_dat16}; // L5D3L6D3_L1
                5'b10010: mem_dat_stream <= {4'b0101,mem_dat17}; // L5D3L6D4_L1
                5'b10011: mem_dat_stream <= {4'b0101,mem_dat18}; // L5D4L6D4_L1
                5'b10100: mem_dat_stream <= {4'b0101,mem_dat19}; // F1D5F2D5_L1
                default  mem_dat_stream <= 55'h0000000000000;
            endcase
        end
endgenerate

endmodule
