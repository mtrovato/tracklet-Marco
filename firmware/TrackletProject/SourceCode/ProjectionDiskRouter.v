`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:14:50 PM
// Design Name: 
// Module Name: ProjRouter
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


module ProjectionDiskRouter(
    input clk,
    input reset,
    input en_proc,
    // programming interface
    // inputs
    input wire io_clk,                    // programming clock
    input wire io_sel,                    // this module has been selected for an I/O operation
    input wire io_sync,                    // start the I/O operation
    input wire [15:0] io_addr,        // slave address, memory or register. Top 16 bits already consumed.
    input wire io_rd_en,                // this is a read operation
    input wire io_wr_en,                // this is a write operation
    input wire [31:0] io_wr_data,    // data to write for write operations
    // outputs
    output wire [31:0] io_rd_data,    // data returned for read operations
    output wire io_rd_ack,                // 'read' data from this module is ready
    //clocks
    input wire [2:0] BX,
    input wire first_clk,
    input wire not_first_clk,
    
    input start,
    output reg done,
    
    input [5:0] number_in1,
    output reg [9:0] read_add1,
    input [53:0] proj1in,
    input [5:0] number_in2,
    output reg [9:0] read_add2,
    input [53:0] proj2in,
    input [5:0] number_in3,
    output reg [9:0] read_add3,
    input [53:0] proj3in,
    input [5:0] number_in4,
    output reg [9:0] read_add4,
    input [53:0] proj4in,
    input [5:0] number_in5,
    output reg [9:0] read_add5,
    input [53:0] proj5in,
    input [5:0] number_in6,
    output reg [9:0] read_add6,
    input [53:0] proj6in,
    input [5:0] number_in7,
    output reg [9:0] read_add7,
    input [53:0] proj7in,
    
    
    output reg [55:0] allprojout,
    output [12:0] vmprojoutPHI1R1,
    output [12:0] vmprojoutPHI2R1,
    output [12:0] vmprojoutPHI3R1,
    output [12:0] vmprojoutPHI4R1,
    output [12:0] vmprojoutPHI1R2,
    output [12:0] vmprojoutPHI2R2,
    output [12:0] vmprojoutPHI3R2,
    output [12:0] vmprojoutPHI4R2,
    output vmprojoutPHI1R1_wr_en,
    output vmprojoutPHI2R1_wr_en,
    output vmprojoutPHI3R1_wr_en,
    output vmprojoutPHI4R1_wr_en,
    output vmprojoutPHI1R2_wr_en,
    output vmprojoutPHI2R2_wr_en,
    output vmprojoutPHI3R2_wr_en,
    output vmprojoutPHI4R2_wr_en,
    output reg valid_data
    
    );

    // no IPbus here yet
    assign io_rd_data[31:0] = 32'h00000000;
    assign io_rd_ack = 1'b0;
    
    parameter ODD = 1'b1;
    parameter INNER = 1'b1;
    parameter [7:0] n_hold = 8'd3; 
    
    reg [3:0] BX_pipe;
    reg first_clk_pipe;
    reg pre_valid_data;
    reg [3:0] behold;
    
    reg pre_valid_fromPlus;
    reg [3:0] hold_fromPlus;
    reg valid_FromPlus;
    reg pre_valid_fromMinus;
    reg [3:0] hold_fromMinus;
    reg valid_FromMinus;

    initial begin

       BX_pipe = 4'b1111;
    end
    
    always @(posedge clk) begin
       if (reset)
           BX_pipe <= 4'b1111;
       else begin
           if(start) begin
               BX_pipe <= BX_pipe + 1'b1;
               first_clk_pipe <= 1'b1;
           end
           else begin
               first_clk_pipe <= 1'b0;
           end
       end
    end
    
    wire [55:0] proj1in_fromPlus;
    wire [55:0] proj2in_fromMinus;
    wire [55:0] proj3in_fromSector;
    
    assign proj1in_fromPlus   = {2'b01,proj1in};
    assign proj2in_fromMinus  = {2'b10,proj2in};
    assign proj3in_fromSector = {2'b11,proj3in};
      
   reg [n_hold:0] hold;
   always @(posedge clk) begin
       hold[0] <= start;
       hold[n_hold:1] <= hold[n_hold-1:0];
       done <= hold[n_hold];
   end
    
    initial begin
        read_add1 = {BX_pipe,6'h3f};
        read_add2 = {BX_pipe,6'h3f};
        read_add3 = {BX_pipe,6'h3f};
        index = 6'h0;
    end
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_data;
        behold[3:1] <= behold[2:0];
        valid_data <= behold[3];
        hold_fromPlus[0]   <= pre_valid_fromPlus;
        hold_fromPlus[3:1] <= hold_fromPlus[2:0];
        valid_FromPlus     <= hold_fromPlus[3];
        
        hold_fromMinus[0]   <= pre_valid_fromMinus;
        hold_fromMinus[3:1] <= hold_fromMinus[2:0];
        valid_FromMinus     <= hold_fromMinus[3];
        if(first_clk_pipe) begin
            read_add1 <= {BX_pipe,6'h3f};
            read_add2 <= {BX_pipe,6'h3f};
            read_add3 <= {BX_pipe,6'h3f};
            pre_valid_data      <= 1'b0;
            pre_valid_fromPlus  <= 1'b0;
            pre_valid_fromMinus <= 1'b0;
        end
        else begin
            if(read_add3[5:0] + 1'b1 < number_in3) begin
                read_add3[5:0] <= read_add3[5:0] + 1'b1;
                read_add2[5:0] <= read_add2[5:0];
                read_add1[5:0] <= read_add1[5:0];
                pre_valid_data <= 1'b1;
                pre_valid_fromPlus <= 1'b0;
                pre_valid_fromMinus <= 1'b0;
            end
            else begin
                read_add3 <= read_add3;
                if(read_add2[5:0] + 1'b1 < number_in2) begin
                    read_add2[5:0] <= read_add2[5:0] + 1'b1;
                    read_add1[5:0] <= read_add1[5:0];
                    pre_valid_data <= 1'b1;
                    pre_valid_fromPlus <= 1'b0;
                    pre_valid_fromMinus <= 1'b1;
                end
                else begin
                    read_add2 <= read_add2;
                    if(read_add1[5:0] + 1'b1 < number_in1) begin
                        read_add1[5:0] <= read_add1[5:0] + 1'b1;
                        pre_valid_data <= 1'b1;
                        pre_valid_fromPlus <= 1'b1;
                        pre_valid_fromMinus <= 1'b0;
                    end
                    else begin
                        read_add1 <= read_add1;
                        read_add2 <= read_add2;
                        read_add3 <= read_add3;
                        pre_valid_data <= 1'b0;
                        pre_valid_fromPlus <= 1'b0;
                        pre_valid_fromMinus <= 1'b0;
                    end
                end
            end
        end
    end
    ///////////////////////////////////////////////////////////////////////////
      
    reg [5:0] pre_index1;
    reg [5:0] pre_index2;
    reg [5:0] pre_index3;
    reg [5:0] index;
    reg [12:0] vmprojout;
    reg [12:0] vmprojout_dly;
    reg [55:0] pre_allprojout;
    reg [55:0] pre_allprojout_hold;
    reg pre_vmprojoutPHI1R1_en;
    reg pre_vmprojoutPHI1R2_en;
    reg pre_vmprojoutPHI2R1_en;
    reg pre_vmprojoutPHI2R2_en;
    reg pre_vmprojoutPHI3R1_en;
    reg pre_vmprojoutPHI3R2_en;
    reg pre_vmprojoutPHI4R1_en;
    reg pre_vmprojoutPHI4R2_en;
    
    assign vmprojoutPHI1R1 = vmprojout;
    assign vmprojoutPHI1R2 = vmprojout;
    assign vmprojoutPHI2R1 = vmprojout;
    assign vmprojoutPHI2R2 = vmprojout;
    assign vmprojoutPHI3R1 = vmprojout;
    assign vmprojoutPHI3R2 = vmprojout;
    assign vmprojoutPHI4R1 = vmprojout;
    assign vmprojoutPHI4R2 = vmprojout;
    assign vmprojoutPHI1R1_wr_en = pre_vmprojoutPHI1R1_en & valid_data;
    assign vmprojoutPHI1R2_wr_en = pre_vmprojoutPHI1R2_en & valid_data;
    assign vmprojoutPHI2R1_wr_en = pre_vmprojoutPHI2R1_en & valid_data;
    assign vmprojoutPHI2R2_wr_en = pre_vmprojoutPHI2R2_en & valid_data;
    assign vmprojoutPHI3R1_wr_en = pre_vmprojoutPHI3R1_en & valid_data;
    assign vmprojoutPHI3R2_wr_en = pre_vmprojoutPHI3R2_en & valid_data;
    assign vmprojoutPHI4R1_wr_en = pre_vmprojoutPHI4R1_en & valid_data;
    assign vmprojoutPHI4R2_wr_en = pre_vmprojoutPHI4R2_en & valid_data;
    
    reg [53:0] proj1in_dly;
    reg [53:0] proj2in_dly;
    reg [53:0] proj3in_dly;
    
    always @(posedge clk) begin
        proj1in_dly <= proj1in;
        proj2in_dly <= proj2in;
        proj3in_dly <= proj3in;
            
        if(proj3in != 0 && proj3in != proj3in_dly)
            pre_allprojout <= proj3in_fromSector;
        else begin
            if(proj2in != 0 && proj2in != proj2in_dly)
                pre_allprojout <= proj2in_fromMinus;
            else begin
                if(proj1in != 0 && proj1in != proj1in_dly)
                    pre_allprojout <= proj1in_fromPlus;
                else 
                    pre_allprojout <= 0; 
            end
        end
    
        pre_index1 <= read_add3 + (read_add1 + 1) + (read_add2 + 1); //FIXTHIS
        pre_index2 <= pre_index1;
        pre_index3 <= pre_index2;
        index <= pre_index3;
        //pre_allprojout <= {proj1in[53:20],proj2in[19:10],proj3in[9:0]};
        allprojout <= pre_allprojout;
        vmprojout_dly <= vmprojout;
        if(INNER) begin
            vmprojout[12:7] <= index; 
            vmprojout[6:4] <= {ODD ^ pre_allprojout[38],pre_allprojout[37:36]}; 
            vmprojout[3:0] <= pre_allprojout[23:20]; 
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b000 + ODD) |pre_allprojout[40:38] == (3'b001 + ODD)))
                pre_vmprojoutPHI1R1_en <= 1'b1;
            else
                pre_vmprojoutPHI1R1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b010 + ODD) |pre_allprojout[40:38] == (3'b011 + ODD)))
                pre_vmprojoutPHI2R1_en <= 1'b1;
            else
                pre_vmprojoutPHI2R1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b100 + ODD) |pre_allprojout[40:38] == (3'b101 + ODD)))
                pre_vmprojoutPHI3R1_en <= 1'b1;
            else
                pre_vmprojoutPHI3R1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b110 + ODD) |pre_allprojout[40:38] == 3'b111))
                pre_vmprojoutPHI4R1_en <= 1'b1;
            else
                pre_vmprojoutPHI4R1_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b000 + ODD) |pre_allprojout[40:38] == (3'b001 + ODD)))
                pre_vmprojoutPHI1R2_en <= 1'b1;
            else
                pre_vmprojoutPHI1R2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b010 + ODD) |pre_allprojout[40:38] == (3'b011 + ODD)))
                pre_vmprojoutPHI2R2_en <= 1'b1;
            else
                pre_vmprojoutPHI2R2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b100 + ODD) |pre_allprojout[40:38] == (3'b101 + ODD)))
                pre_vmprojoutPHI3R2_en <= 1'b1;
            else
                pre_vmprojoutPHI3R2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b110 + ODD) |pre_allprojout[40:38] == 3'b111))
               pre_vmprojoutPHI4R2_en <= 1'b1;
            else
               pre_vmprojoutPHI4R2_en <= 0;
        end
        else begin
            vmprojout[12:7] <= index; 
            vmprojout[6:4] <= {ODD ^ pre_allprojout[37],pre_allprojout[36:35]}; 
            vmprojout[3:0] <= pre_allprojout[19:16];            
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b000 + ODD) |pre_allprojout[39:37] == (3'b001 + ODD)))
                pre_vmprojoutPHI1R1_en <= 1'b1;
            else
                pre_vmprojoutPHI1R1_en <= 0;
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b010 + ODD) |pre_allprojout[39:37] == (3'b011 + ODD)))
                pre_vmprojoutPHI2R1_en <= 1'b1;
            else
                pre_vmprojoutPHI2R1_en <= 0;
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b100 + ODD) |pre_allprojout[39:37] == (3'b101 + ODD)))
                pre_vmprojoutPHI3R1_en <= 1'b1;
            else
                pre_vmprojoutPHI3R1_en <= 0;
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b110 + ODD) |pre_allprojout[39:37] == 3'b111))
                pre_vmprojoutPHI4R1_en <= 1'b1;
            else
                pre_vmprojoutPHI4R1_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b000 + ODD) |pre_allprojout[39:37] == (3'b001 + ODD)))
                pre_vmprojoutPHI1R2_en <= 1'b1;
            else
                pre_vmprojoutPHI1R2_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b010 + ODD) |pre_allprojout[39:37] == (3'b011 + ODD)))
                pre_vmprojoutPHI2R2_en <= 1'b1;
            else
                pre_vmprojoutPHI2R2_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b100 + ODD) |pre_allprojout[39:37] == (3'b101 + ODD)))
                pre_vmprojoutPHI3R2_en <= 1'b1;
            else
                pre_vmprojoutPHI3R2_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b110 + ODD) |pre_allprojout[39:37] == 3'b111))
               pre_vmprojoutPHI4R2_en <= 1'b1;
            else
               pre_vmprojoutPHI4R2_en <= 0;
       end
    end
    
endmodule
