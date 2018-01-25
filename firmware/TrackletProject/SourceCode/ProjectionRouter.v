`timescale 1ns / 1ps
`include "constants.vh"
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


module ProjectionRouter(
    input clk,
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    
    input [5:0] number_in_proj1in,
    output reg [`MEM_SIZE+3:0] read_add_proj1in,
    input [53:0] proj1in,
    input [5:0] number_in_proj2in,
    output reg [`MEM_SIZE+3:0] read_add_proj2in,
    input [53:0] proj2in,
    input [5:0] number_in_proj3in,
    output reg [`MEM_SIZE+3:0] read_add_proj3in,
    input [53:0] proj3in,
    input [5:0] number_in_proj4in,
    output reg [`MEM_SIZE+3:0] read_add_proj4in,
    input [53:0] proj4in,
    input [5:0] number_in_proj5in,
    output reg [`MEM_SIZE+3:0] read_add_proj5in,
    input [53:0] proj5in,
    input [5:0] number_in_proj6in,
    output reg [`MEM_SIZE+3:0] read_add_proj6in,
    input [53:0] proj6in,
    input [5:0] number_in_proj7in,
    output reg [`MEM_SIZE+3:0] read_add_proj7in,
    input [53:0] proj7in,
    
    
    output reg [55:0] allprojout,
    output [13:0] vmprojoutPHI1X1,
    output [13:0] vmprojoutPHI2X1,
    output [13:0] vmprojoutPHI3X1,
    output [13:0] vmprojoutPHI4X1,
    output [13:0] vmprojoutPHI1X2,
    output [13:0] vmprojoutPHI2X2,
    output [13:0] vmprojoutPHI3X2,
    output [13:0] vmprojoutPHI4X2,
    output vmprojoutPHI1X1_wr_en,
    output vmprojoutPHI2X1_wr_en,
    output vmprojoutPHI3X1_wr_en,
    output vmprojoutPHI4X1_wr_en,
    output vmprojoutPHI1X2_wr_en,
    output vmprojoutPHI2X2_wr_en,
    output vmprojoutPHI3X2_wr_en,
    output vmprojoutPHI4X2_wr_en,
    output valid_data
    
    );

    parameter ODD = 1'b1;
    parameter INNER = 1'b1;
    parameter BARREL = 1'b1;

    //parameter [7:0] n_hold = 8'd3; 
    
    reg [3:0] BX_pipe;
    reg first_clk_pipe;
    wire pre_valid_local;
    wire pre_valid_neighbor;
    reg [3:0] behold;
    
    wire pre_valid_3;
    wire pre_valid_4;
    wire pre_valid_5;
    wire pre_valid_6;
    wire pre_valid_7;
    wire pre_valid_fromPlus;
    wire pre_valid_fromMinus;
    wire valid_local;
    wire valid_neighbor;

    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset

    initial begin

       BX_pipe = 4'b1111;
    end
    
    always @(posedge clk) begin
       if (rst_pipe)
           BX_pipe <= 4'b1111;
       else begin
           if(start[0]) begin
               BX_pipe <= BX_pipe + 1'b1;
               first_clk_pipe <= 1'b1;
           end
           else begin
               first_clk_pipe <= 1'b0;
           end
       end
    end
    
    reg [55:0] proj1in_fromPlus;
    reg [55:0] proj2in_fromMinus;
    wire [55:0] proj3in_fromSector;
    wire [55:0] proj4in_fromSector;
    wire [55:0] proj5in_fromSector;
    wire [55:0] proj6in_fromSector;
    wire [55:0] proj7in_fromSector;
    
    wire [5:0] pre_read_add1;
    wire [5:0] pre_read_add2;
    wire [5:0] pre_read_add3;
    wire [5:0] pre_read_add4;
    wire [5:0] pre_read_add5;
    wire [5:0] pre_read_add6;
    wire [5:0] pre_read_add7;
            
    
      
    pipe_delay #(.STAGES(5), .WIDTH(2))
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
    
    assign pre_valid_local = pre_valid_3 || pre_valid_4 || pre_valid_5  || pre_valid_6  || pre_valid_7;
    assign pre_valid_neighbor = pre_valid_fromPlus || pre_valid_fromMinus;
    
    reg [9:0] pre_read_add_proj1in;
    reg [9:0] pre_read_add_proj2in;
    reg [9:0] pre_read_add_proj3in;
    reg [9:0] pre_read_add_proj4in;
    reg [9:0] pre_read_add_proj5in;
    reg [9:0] pre_read_add_proj6in;
    reg [9:0] pre_read_add_proj7in;
    
    pipe_delay #(.STAGES(4), .WIDTH(1))
                valid_local_delay(.pipe_in(), .pipe_out(), .clk(clk),
                .val_in(pre_valid_local), .val_out(valid_local));
    pipe_delay #(.STAGES(3), .WIDTH(1))
                valid_neighbor_delay(.pipe_in(), .pipe_out(), .clk(clk),
                .val_in(pre_valid_neighbor), .val_out(valid_neighbor));
    wire pre_valid;
    assign pre_valid_data = valid_local || valid_neighbor;
    pipe_delay #(.STAGES(2), .WIDTH(1))
                valid_data_delay(.pipe_in(), .pipe_out(), .clk(clk),
                .val_in(pre_valid_data), .val_out(valid_data));

    
        
    reg first_clk_pipe2;
    reg [5:0] index;            
    always @(posedge clk) begin
        first_clk_pipe2 <= first_clk_pipe;
        
        if(first_clk_pipe)
            index <= 6'h3f;
        else begin 
            if(pre_valid_data)
                index <= index + 1'b1;
            else
                index <= index;
        end
        read_add_proj1in <= {BX_pipe,number_in_proj1in[`MEM_SIZE-1:0]-pre_read_add1[`MEM_SIZE-1:0]};
        read_add_proj2in <= {BX_pipe,number_in_proj2in[`MEM_SIZE-1:0]-pre_read_add2[`MEM_SIZE-1:0]};
        read_add_proj3in <= {BX_pipe,number_in_proj3in[`MEM_SIZE-1:0]-pre_read_add3[`MEM_SIZE-1:0]};
        read_add_proj4in <= {BX_pipe,number_in_proj4in[`MEM_SIZE-1:0]-pre_read_add4[`MEM_SIZE-1:0]};
        read_add_proj5in <= {BX_pipe,number_in_proj5in[`MEM_SIZE-1:0]-pre_read_add5[`MEM_SIZE-1:0]};
        read_add_proj6in <= {BX_pipe,number_in_proj6in[`MEM_SIZE-1:0]-pre_read_add6[`MEM_SIZE-1:0]};
        read_add_proj7in <= {BX_pipe,number_in_proj7in[`MEM_SIZE-1:0]-pre_read_add7[`MEM_SIZE-1:0]};
        
    end
       
    
    read_mems read_mems(
        .clk(clk),
        .reset(first_clk_pipe2),
        .number_in1(number_in_proj1in),
        .number_in2(number_in_proj2in),
        .number_in3(number_in_proj3in),
        .number_in4(number_in_proj4in),
        .number_in5(number_in_proj5in),
        .number_in6(number_in_proj6in),
        .number_in7(number_in_proj7in),
        .read_add1(pre_read_add1),
        .read_add2(pre_read_add2),
        .read_add3(pre_read_add3),
        .read_add4(pre_read_add4),
        .read_add5(pre_read_add5),
        .read_add6(pre_read_add6),
        .read_add7(pre_read_add7),
        .valid_3(pre_valid_3),
        .valid_4(pre_valid_4),
        .valid_5(pre_valid_5),
        .valid_6(pre_valid_6),
        .valid_7(pre_valid_7),
        .valid_plus(pre_valid_fromPlus),
        .valid_minus(pre_valid_fromMinus)
        
    );
    
    ///////////////////////////////////////////////////////////////////////////

    reg [13:0] vmprojout;
    reg [13:0] vmprojout_dly;
    reg [55:0] pre_allprojout;
    reg [55:0] pre_allprojout_hold;
    reg pre_vmprojoutPHI1X1_en;
    reg pre_vmprojoutPHI1X2_en;
    reg pre_vmprojoutPHI2X1_en;
    reg pre_vmprojoutPHI2X2_en;
    reg pre_vmprojoutPHI3X1_en;
    reg pre_vmprojoutPHI3X2_en;
    reg pre_vmprojoutPHI4X1_en;
    reg pre_vmprojoutPHI4X2_en;
    
    assign vmprojoutPHI1X1 = vmprojout;
    assign vmprojoutPHI1X2 = vmprojout;
    assign vmprojoutPHI2X1 = vmprojout;
    assign vmprojoutPHI2X2 = vmprojout;
    assign vmprojoutPHI3X1 = vmprojout;
    assign vmprojoutPHI3X2 = vmprojout;
    assign vmprojoutPHI4X1 = vmprojout;
    assign vmprojoutPHI4X2 = vmprojout;
    assign vmprojoutPHI1X1_wr_en = pre_vmprojoutPHI1X1_en & valid_data;
    assign vmprojoutPHI1X2_wr_en = pre_vmprojoutPHI1X2_en & valid_data;
    assign vmprojoutPHI2X1_wr_en = pre_vmprojoutPHI2X1_en & valid_data;
    assign vmprojoutPHI2X2_wr_en = pre_vmprojoutPHI2X2_en & valid_data;
    assign vmprojoutPHI3X1_wr_en = pre_vmprojoutPHI3X1_en & valid_data;
    assign vmprojoutPHI3X2_wr_en = pre_vmprojoutPHI3X2_en & valid_data;
    assign vmprojoutPHI4X1_wr_en = pre_vmprojoutPHI4X1_en & valid_data;
    assign vmprojoutPHI4X2_wr_en = pre_vmprojoutPHI4X2_en & valid_data;
    
    reg [53:0] proj1in_dly;
    reg [53:0] proj2in_dly;
    reg [53:0] proj3in_dly;
    reg [53:0] proj4in_dly;
    reg [53:0] proj5in_dly;
    reg [53:0] proj6in_dly;
    reg [53:0] proj7in_dly;
    wire valid_3;
    wire valid_4;
    wire valid_5;
    wire valid_6;
    wire valid_7;
    wire valid_fromPlus;
    wire valid_fromMinus;
        
    pipe_delay #(.STAGES(4), .WIDTH(1))
            valid3_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_3), .val_out(valid_3));
    pipe_delay #(.STAGES(4), .WIDTH(1))
            valid4_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_4), .val_out(valid_4));
    pipe_delay #(.STAGES(4), .WIDTH(1))
            valid5_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_5), .val_out(valid_5));
    pipe_delay #(.STAGES(4), .WIDTH(1))
            valid6_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_6), .val_out(valid_6));
    pipe_delay #(.STAGES(4), .WIDTH(1))
            valid7_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_7), .val_out(valid_7));
    pipe_delay #(.STAGES(3), .WIDTH(1))
            validPlus_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_fromPlus), .val_out(valid_fromPlus));
    pipe_delay #(.STAGES(3), .WIDTH(1))
            validMinus_delay(.pipe_in(), .pipe_out(), .clk(clk),
            .val_in(pre_valid_fromMinus), .val_out(valid_fromMinus));
    
    // Disk Routers combine tracklet calculators from hybrid
    // FIX THIS -- I AM WORKIN ON IT! CALM DOWN
    
    assign proj3in_fromSector = {2'b11,proj3in_dly};
    assign proj4in_fromSector = {2'b11,proj4in_dly};
    assign proj5in_fromSector = {2'b11,proj5in_dly};
    assign proj6in_fromSector = {2'b11,proj6in_dly};
    assign proj7in_fromSector = {2'b11,proj7in_dly};
    
    always @(posedge clk) begin
        proj1in_fromPlus   <= {2'b01,proj1in_dly};
        proj2in_fromMinus  <= {2'b10,proj2in_dly};        
        proj1in_dly <= proj1in;
        proj2in_dly <= proj2in;
        proj3in_dly <= proj3in;
        proj4in_dly <= proj4in;
        proj5in_dly <= proj5in;
        proj6in_dly <= proj6in;
        proj7in_dly <= proj7in;
            
        if(valid_3)
            pre_allprojout <= proj3in_fromSector;
        else if(valid_4)
            pre_allprojout <= proj4in_fromSector;
        else if(valid_5)
            pre_allprojout <= proj5in_fromSector;
        else if(valid_6)
            pre_allprojout <= proj6in_fromSector;
        else if(valid_7)
            pre_allprojout <= proj7in_fromSector;
        else if(valid_fromMinus)
            pre_allprojout <= proj2in_fromMinus;
        else if(valid_fromPlus)
            pre_allprojout <= proj1in_fromPlus;
        else 
            pre_allprojout <= 0; 
    
        //pre_allprojout <= {proj1in[53:20],proj2in[19:10],proj3in[9:0]};
        allprojout <= pre_allprojout;
        vmprojout_dly <= vmprojout;
    end
    
    
    generate
    if(INNER & BARREL) begin
        always @(posedge clk) begin
            vmprojout[13:8] <= index;
            vmprojout[7] <= 1'b0;
            vmprojout[6:4] <= {ODD ^ pre_allprojout[38],pre_allprojout[37:36]}; 
            vmprojout[3:0] <= pre_allprojout[23:20]; 
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b000 + ODD) |pre_allprojout[40:38] == (3'b001 + ODD)))
                pre_vmprojoutPHI1X1_en <= 1'b1;
            else
                pre_vmprojoutPHI1X1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b010 + ODD) |pre_allprojout[40:38] == (3'b011 + ODD)))
                pre_vmprojoutPHI2X1_en <= 1'b1;
            else
                pre_vmprojoutPHI2X1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b100 + ODD) |pre_allprojout[40:38] == (3'b101 + ODD)))
                pre_vmprojoutPHI3X1_en <= 1'b1;
            else
                pre_vmprojoutPHI3X1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[40:38] == (3'b110 + ODD) |pre_allprojout[40:38] == 3'b111))
                pre_vmprojoutPHI4X1_en <= 1'b1;
            else
                pre_vmprojoutPHI4X1_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b000 + ODD) |pre_allprojout[40:38] == (3'b001 + ODD)))
                pre_vmprojoutPHI1X2_en <= 1'b1;
            else
                pre_vmprojoutPHI1X2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b010 + ODD) |pre_allprojout[40:38] == (3'b011 + ODD)))
                pre_vmprojoutPHI2X2_en <= 1'b1;
            else
                pre_vmprojoutPHI2X2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b100 + ODD) |pre_allprojout[40:38] == (3'b101 + ODD)))
                pre_vmprojoutPHI3X2_en <= 1'b1;
            else
                pre_vmprojoutPHI3X2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[40:38] == (3'b110 + ODD) |pre_allprojout[40:38] == 3'b111))
               pre_vmprojoutPHI4X2_en <= 1'b1;
            else
               pre_vmprojoutPHI4X2_en <= 0;
        end
    end
    else if(!INNER & BARREL) begin
        always @(posedge clk) begin            
            vmprojout[13:8] <= index;
            vmprojout[7] <= 1'b0;
            vmprojout[6:4] <= {ODD ^ pre_allprojout[37],pre_allprojout[36:35]}; 
            vmprojout[3:0] <= pre_allprojout[19:16];            
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b000 + ODD) |pre_allprojout[39:37] == (3'b001 + ODD)))
                pre_vmprojoutPHI1X1_en <= 1'b1;
            else
                pre_vmprojoutPHI1X1_en <= 0;
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b010 + ODD) |pre_allprojout[39:37] == (3'b011 + ODD)))
                pre_vmprojoutPHI2X1_en <= 1'b1;
            else
                pre_vmprojoutPHI2X1_en <= 0;
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b100 + ODD) |pre_allprojout[39:37] == (3'b101 + ODD)))
                pre_vmprojoutPHI3X1_en <= 1'b1;
            else
                pre_vmprojoutPHI3X1_en <= 0;
            if(pre_allprojout[20] == 1'b0 & (pre_allprojout[39:37] == (3'b110 + ODD) |pre_allprojout[39:37] == 3'b111))
                pre_vmprojoutPHI4X1_en <= 1'b1;
            else
                pre_vmprojoutPHI4X1_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b000 + ODD) |pre_allprojout[39:37] == (3'b001 + ODD)))
                pre_vmprojoutPHI1X2_en <= 1'b1;
            else
                pre_vmprojoutPHI1X2_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b010 + ODD) |pre_allprojout[39:37] == (3'b011 + ODD)))
                pre_vmprojoutPHI2X2_en <= 1'b1;
            else
                pre_vmprojoutPHI2X2_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b100 + ODD) |pre_allprojout[39:37] == (3'b101 + ODD)))
                pre_vmprojoutPHI3X2_en <= 1'b1;
            else
                pre_vmprojoutPHI3X2_en <= 0;
            if(pre_allprojout[20] == 1'b1 & (pre_allprojout[39:37] == (3'b110 + ODD) |pre_allprojout[39:37] == 3'b111))
               pre_vmprojoutPHI4X2_en <= 1'b1;
            else
               pre_vmprojoutPHI4X2_en <= 0;
       end
    end
    else if(!BARREL) begin
        always @(posedge clk) begin
            vmprojout[13:8] <= index; 
            vmprojout[7:5] <= {!ODD ^ pre_allprojout[37],pre_allprojout[36:35]}; 
            vmprojout[4:0] <= pre_allprojout[23:19]; 
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[39:37] == (3'b000 + !ODD) |pre_allprojout[39:37] == (3'b001 + !ODD)))
                pre_vmprojoutPHI1X1_en <= 1'b1;
            else
                pre_vmprojoutPHI1X1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[39:37] == (3'b010 + !ODD) |pre_allprojout[39:37] == (3'b011 + !ODD)))
                pre_vmprojoutPHI2X1_en <= 1'b1;
            else
                pre_vmprojoutPHI2X1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[39:37] == (3'b100 + !ODD) |pre_allprojout[39:37] == (3'b101 + !ODD)))
                pre_vmprojoutPHI3X1_en <= 1'b1;
            else
                pre_vmprojoutPHI3X1_en <= 0;
            if(pre_allprojout[24] == 1'b0 & (pre_allprojout[39:37] == (3'b110 + !ODD) |pre_allprojout[39:37] == 3'b111))
                pre_vmprojoutPHI4X1_en <= 1'b1;
            else
                pre_vmprojoutPHI4X1_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[39:37] == (3'b000 + !ODD) |pre_allprojout[39:37] == (3'b001 + !ODD)))
                pre_vmprojoutPHI1X2_en <= 1'b1;
            else
                pre_vmprojoutPHI1X2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[39:37] == (3'b010 + !ODD) |pre_allprojout[39:37] == (3'b011 + !ODD)))
                pre_vmprojoutPHI2X2_en <= 1'b1;
            else
                pre_vmprojoutPHI2X2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[39:37] == (3'b100 + !ODD) |pre_allprojout[39:37] == (3'b101 + !ODD)))
                pre_vmprojoutPHI3X2_en <= 1'b1;
            else
                pre_vmprojoutPHI3X2_en <= 0;
            if(pre_allprojout[24] == 1'b1 & (pre_allprojout[39:37] == (3'b110 + !ODD) |pre_allprojout[39:37] == 3'b111))
               pre_vmprojoutPHI4X2_en <= 1'b1;
            else
               pre_vmprojoutPHI4X2_en <= 0;
        end
    end
    endgenerate
    
endmodule
