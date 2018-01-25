`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:14:50 PM
// Design Name: 
// Module Name: DiskProjectionRouter
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


module DiskProjectionRouter(
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
    
    input  [1:0]        start,
    output [1:0]        done,
    
    input [5:0]         number_in_proj1in,
    output reg [5:0]    read_add_proj1in,
    input [53:0]        proj1in,
    input [5:0]         number_in_proj2in,
    output reg [5:0]    read_add_proj2in,
    input [53:0]        proj2in,
    input [5:0]         number_in_proj3in,
    output reg [5:0]    read_add_proj3in,
    input [53:0]        proj3in,
    
    output reg [53:0]   allprojout,
    output [12:0]       vmprojoutPHI1X1,
    output [12:0]       vmprojoutPHI2X1,
    output [12:0]       vmprojoutPHI3X1,
    output [12:0]       vmprojoutPHI4X1,
    output [12:0]       vmprojoutPHI1X2,
    output [12:0]       vmprojoutPHI2X2,
    output [12:0]       vmprojoutPHI3X2,
    output [12:0]       vmprojoutPHI4X2,
    output              vmprojoutPHI1X1_wr_en,
    output              vmprojoutPHI2X1_wr_en,
    output              vmprojoutPHI3X1_wr_en,
    output              vmprojoutPHI4X1_wr_en,
    output              vmprojoutPHI1X2_wr_en,
    output              vmprojoutPHI2X2_wr_en,
    output              vmprojoutPHI3X2_wr_en,
    output              vmprojoutPHI4X2_wr_en,
    output reg          valid_data
    
    );

    // no IPbus here yet
    assign io_rd_data[31:0] = 32'h00000000;
    assign io_rd_ack = 1'b0;
    
    parameter INNER  = 1'b1;
    parameter BARREL = 1'b0;
    parameter ODD = 1'b0;
    parameter zbit = 29;
    parameter [7:0] n_hold = 8'd3; 
    
    reg [6:0] clk_cnt;
    reg [2:0] BX_pipe;
    reg first_clk_pipe;
    reg pre_valid_data;
    reg [3:0] behold;

    initial begin
       BX_pipe = 3'b111;
    end
    
    always @(posedge clk) begin
       if(start[0]) begin
           BX_pipe <= BX_pipe + 1'b1;
           first_clk_pipe <= 1'b1;
       end
       else begin
           first_clk_pipe <= 1'b0;
       end
    end

	pipe_delay #(.STAGES(5), .WIDTH(2))
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
    
//   reg [n_hold:0] hold;
//   always @(posedge clk) begin
//       hold[0] <= start[0];
//       hold[n_hold:1] <= hold[n_hold-1:0];
//       done <= {0,hold[n_hold]};
//   end
    
    initial begin
        read_add_proj1in = 6'h3f;
        read_add_proj2in = 6'h3f;
        read_add_proj3in = 6'h3f;
        index = 6'h0;
    end
    
    always @(posedge clk) begin
        behold[0] <= pre_valid_data;
        behold[3:1] <= behold[2:0];
        valid_data <= behold[3];
        if(first_clk_pipe) begin
            read_add_proj1in <= 6'h3f;
            read_add_proj2in <= 6'h3f;
            read_add_proj3in <= 6'h3f;    
        end
        else begin
            if(read_add_proj1in + 1'b1 < number_in_proj1in) begin
                read_add_proj1in <= read_add_proj1in + 1'b1;
                pre_valid_data <= 1'b1;
            end
            else begin
                read_add_proj1in <= read_add_proj1in;
                if(read_add_proj2in + 1'b1 < number_in_proj2in) begin
                    read_add_proj2in <= read_add_proj2in + 1'b1;
                    pre_valid_data <= 1'b1;
                end
                else begin
                    read_add_proj2in <= read_add_proj2in;
                    if(read_add_proj3in + 1'b1 < number_in_proj3in) begin
                        read_add_proj3in <= read_add_proj3in + 1'b1;
                        pre_valid_data <= 1'b1;
                    end
                    else
                        read_add_proj3in <= read_add_proj3in;
                        pre_valid_data <= 1'b0;
                end
            end
        end
    end
    ///////////////////////////////////////////////////////////////////////////
      
    reg [5:0] pre_index1;
    reg [5:0] pre_index2;
    reg [5:0] index;
    reg [12:0] vmprojout;
    reg [12:0] vmprojout_dly;
    reg [53:0] pre_allprojout;
    reg pre_vmprojoutPHI1X1_en;
    reg pre_vmprojoutPHI1X2_en;
    reg pre_vmprojoutPHI2X1_en;
    reg pre_vmprojoutPHI2X2_en;
    reg pre_vmprojoutPHI3X1_en;
    reg pre_vmprojoutPHI3X2_en;
    reg pre_vmprojoutPHI4X1_en;
    reg pre_vmprojoutPHI4X2_en;
    
    assign vmprojoutPHI1X1 = vmprojout_dly;
    assign vmprojoutPHI1X2 = vmprojout_dly;
    assign vmprojoutPHI2X1 = vmprojout_dly;
    assign vmprojoutPHI2X2 = vmprojout_dly;
    assign vmprojoutPHI3X1 = vmprojout_dly;
    assign vmprojoutPHI3X2 = vmprojout_dly;
    assign vmprojoutPHI4X1 = vmprojout_dly;
    assign vmprojoutPHI4X2 = vmprojout_dly;
    assign vmprojoutPHI1X1_en = pre_vmprojoutPHI1X1_en & valid_data;
    assign vmprojoutPHI1X2_en = pre_vmprojoutPHI1X2_en & valid_data;
    assign vmprojoutPHI2X1_en = pre_vmprojoutPHI2X1_en & valid_data;
    assign vmprojoutPHI2X2_en = pre_vmprojoutPHI2X2_en & valid_data;
    assign vmprojoutPHI3X1_en = pre_vmprojoutPHI3X1_en & valid_data;
    assign vmprojoutPHI3X2_en = pre_vmprojoutPHI3X2_en & valid_data;
    assign vmprojoutPHI4X1_en = pre_vmprojoutPHI4X1_en & valid_data;
    assign vmprojoutPHI4X2_en = pre_vmprojoutPHI4X2_en & valid_data;
    
    always @(posedge clk) begin
        pre_index1 <= read_add_proj1in;
        pre_index2 <= pre_index1;
        index <= pre_index2;
        pre_allprojout <= {proj1in[53:20],proj2in[19:10],proj3in[9:0]};
        allprojout <= pre_allprojout;
        vmprojout_dly <= vmprojout;
        
        if(!BARREL) begin        
            vmprojout[12:7] <= index;
            vmprojout[6:4]  <= {!ODD ^ proj1in[38],proj1in[37:36]};
            vmprojout[3:0]  <= proj1in[23:20];
            
            //should be [40:38]
            
            
          if(proj1in[25] == 1'b0 & (proj1in[41:39] == (3'b000 + !ODD ) | proj1in[41:39] == (3'b001 + !ODD) ))
            pre_vmprojoutPHI1X1_en <= 1'b1;
          else
            pre_vmprojoutPHI1X1_en <= 0;
          if(proj1in[25] == 1'b0 & (proj1in[41:39] == (3'b010 + !ODD ) | proj1in[41:39] == (3'b011 + !ODD )))
            pre_vmprojoutPHI2X1_en <= 1'b1;
          else
            pre_vmprojoutPHI2X1_en <= 0;
          if(proj1in[25] == 1'b0 & (proj1in[41:39] == (3'b100 +!ODD) | proj1in[41:39] == (3'b101 + !ODD)))
            pre_vmprojoutPHI3X1_en <= 1'b1;
          else
            pre_vmprojoutPHI3X1_en <= 0;
          if(proj1in[25] == 1'b0 & (proj1in[41:39] == (3'b110 + !ODD) | proj1in[41:39] == 3'b111))
            pre_vmprojoutPHI4X1_en <= 1'b1;
          else
            pre_vmprojoutPHI4X1_en <= 0;

          if(proj1in[25] == 1'b1 & (proj1in[41:39] == (3'b000 + !ODD ) | proj1in[41:39] == (3'b001 + !ODD)))
            pre_vmprojoutPHI1X2_en <= 1'b1;
          else
            pre_vmprojoutPHI1X2_en <= 0;
          if(proj1in[25] == 1'b1 & (proj1in[41:39] == (3'b010 + !ODD) | proj1in[41:39] == (3'b011 + !ODD)))
            pre_vmprojoutPHI2X2_en <= 1'b1;
          else
            pre_vmprojoutPHI2X2_en <= 0;
          if(proj1in[25] == 1'b1 & (proj1in[41:39] == (3'b100 + !ODD ) | proj1in[41:39] == (3'b101+ !ODD)))
            pre_vmprojoutPHI3X2_en <= 1'b1;
          else
            pre_vmprojoutPHI3X2_en <= 0;
          if(proj1in[25] == 1'b1 & (proj1in[41:39] == (3'b110 +!ODD ) | proj1in[41:39] == 3'b111))
            pre_vmprojoutPHI4X2_en <= 1'b1;
          else
            pre_vmprojoutPHI4X2_en <= 0;
        end
        
    end
    
endmodule
