`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 03:16:21 PM
// Design Name: 
// Module Name: VMRouters
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


module DiskVMRouter(
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
    output reg [5:0] read_add1,
    input [35:0] stubinLink1,
    input [5:0] number_in2,
    output reg [5:0] read_add2,
    input [35:0] stubinLink2,
    input [5:0] number_in3,
    output reg [5:0] read_add3,
    input [35:0] stubinLink3,
    
    output reg [35:0] allstuboutn1,
    output [35:0] allstuboutn2,
    output [35:0] allstuboutn3,
    
    output [17:0] vmstuboutPHI1X1n1,
    output [17:0] vmstuboutPHI1X1n2,
    output [17:0] vmstuboutPHI1X1n3,
    output [17:0] vmstuboutPHI1X1n4,
    output [17:0] vmstuboutPHI1X1n5,
    output [17:0] vmstuboutPHI1X1n6,
    output [17:0] vmstuboutPHI1X2n1,
    output [17:0] vmstuboutPHI1X2n2,
    output [17:0] vmstuboutPHI1X2n3,
    output [17:0] vmstuboutPHI1X2n4,
    
    output [17:0] vmstuboutPHI2X1n1,
    output [17:0] vmstuboutPHI2X1n2,
    output [17:0] vmstuboutPHI2X1n3,
    output [17:0] vmstuboutPHI2X1n4,
    output [17:0] vmstuboutPHI2X1n5,
    output [17:0] vmstuboutPHI2X1n6,
    output [17:0] vmstuboutPHI2X2n1,
    output [17:0] vmstuboutPHI2X2n2,
    output [17:0] vmstuboutPHI2X2n3,
    output [17:0] vmstuboutPHI2X2n4,
    output [17:0] vmstuboutPHI2X2n5,
    output [17:0] vmstuboutPHI2X2n6,
    
    output [17:0] vmstuboutPHI3X1n1,
    output [17:0] vmstuboutPHI3X1n2,
    output [17:0] vmstuboutPHI3X1n3,
    output [17:0] vmstuboutPHI3X1n4,
    output [17:0] vmstuboutPHI3X1n5,
    output [17:0] vmstuboutPHI3X1n6,
    output [17:0] vmstuboutPHI3X2n1,
    output [17:0] vmstuboutPHI3X2n2,
    output [17:0] vmstuboutPHI3X2n3,
    output [17:0] vmstuboutPHI3X2n4,
    output [17:0] vmstuboutPHI3X2n5,
    output [17:0] vmstuboutPHI3X2n6,
        
    output [17:0] vmstuboutPHI4X1n1,
    output [17:0] vmstuboutPHI4X1n2,
    output [17:0] vmstuboutPHI4X1n3,
    output [17:0] vmstuboutPHI4X2n1,
    output [17:0] vmstuboutPHI4X2n2,
    output [17:0] vmstuboutPHI4X2n3,
    output [17:0] vmstuboutPHI4X2n4,
    
    output vmstuboutPHI1X1_en,
    output vmstuboutPHI1X2_en,
    output vmstuboutPHI2X1_en,
    output vmstuboutPHI2X2_en,
    output vmstuboutPHI3X1_en,
    output vmstuboutPHI3X2_en,
    output vmstuboutPHI4X1_en,
    output vmstuboutPHI4X2_en,
    
    output reg valid_data
    
    );
    
    // no IPbus here yet
    assign io_rd_data[31:0] = 32'h00000000;
    assign io_rd_ack = 1'b0;

	/////////////////////////////////////////////// 
	// Usual BX stuff.
    reg [2:0] BX_pipe;
    reg first_clk_pipe;
    
    initial begin
       BX_pipe = 3'b111;
    end
    
    always @(posedge clk) begin
        if(start) begin
           BX_pipe <= BX_pipe + 1'b1;
           first_clk_pipe <= 1'b1;
        end
        else begin
           first_clk_pipe <= 1'b0;
        end
    end
    
 // Default parameters are for the inner barrel odd layers.   
    parameter INNER = 1'b1;
    parameter ODD = 1'b1;
    parameter BARREL =1'b1;
    
    // Delay of 3 clocks between Start coming in, and done going out.
    // Why this delay? Why is it set to 3?    
    parameter [7:0] n_hold = 8'd3;  
    reg [n_hold:0] hold;
    always @(posedge clk) begin
        hold[0] <= start;
        hold[n_hold:1] <= hold[n_hold-1:0];
        done <= hold[n_hold];
    end
    
    ///////////////////////////////////////////////////
    
    reg [5:0] index;
    reg [17:0] vmstubout;
    reg pre_valid_data;
    reg index_valid_data;
    reg [3:0] behold;
    
    //Input States.  Select which layer router data is being read.
    parameter WAIT=0,LR1=1,LR2=2,LR3=3;
    reg [1:0] InputState, InputState1, InputState2, InputState3;
    
    initial begin
        read_add1 = 6'h3f;
        read_add2 = 6'h3f;
        read_add3 = 6'h3f;
        index = 6'h0;
    end
    
    always @(posedge clk) begin
    
    //Delay input state changes to match data output delay from stubsbylayer.
        InputState1<=InputState;                
        InputState2<=InputState1;                
        InputState3<=InputState2;

        behold[0] <= pre_valid_data;
        behold[3:1] <= behold[2:0];
        valid_data <= behold[3];
        index_valid_data <= behold[2];

//Read all data from first input, then second, then third.        
        if(first_clk_pipe) begin
            read_add1 <= 6'h3f;
            read_add2 <= 6'h3f;
            read_add3 <= 6'h3f;
            InputState = WAIT;    
        end
        else begin
            if(read_add1 + 1'b1 < number_in1) begin
                InputState = LR1;
                read_add1 <= read_add1 + 1'b1;
                pre_valid_data <= 1'b1;
            end
            else begin
                read_add1 <= read_add1;
                if(read_add2 + 1'b1 < number_in2) begin
                    InputState = LR2;
                    read_add2 <= read_add2 + 1'b1;
                    pre_valid_data <= 1'b1;
                end
                else begin
                    read_add2 <= read_add2;
                    if(read_add3 + 1'b1 < number_in3) begin
                        InputState = LR3;
                        read_add3 <= read_add3 + 1'b1;
                        pre_valid_data <= 1'b1;
                    end
                    else begin
                        read_add3 <= read_add3;
                        InputState = WAIT;
                        pre_valid_data <= 1'b0;
                    end
                end
            end
        end
    end
    
    ///////////////////////////////////////////////////////////////////////////
    //Data in state machine.
    reg [35:0] stubin;
    reg [35:0] stubin1;
            
    always @(posedge clk) begin
        stubin1 <= stubin;
        case (InputState3)
          WAIT:
            begin
                end  
              
          LR1:
            begin
                      stubin <= stubinLink1;
                end
          LR2:
            begin
                      stubin <= stubinLink2;
                end
          LR3:
            begin
                      stubin <= stubinLink3;
                end
          endcase

//Copy full stub over, moving PT from LSB to MSB
        if(index_valid_data)
            index <= index + 1'b1;
        else
//            index <= index;
            index <= 6'b0;
            
//        if(INNER&&BARREL) begin        
//            allstuboutn1[35:33] <= stubin[2:0];               // Stub pt      
//            allstuboutn1[32:26] <= stubin[35:29];             // r
//            allstuboutn1[25:14] <= stubin[28:17];             // z
//            allstuboutn1[13:0]  <= stubin[16:3];              // phi
//        end
//        if(!INNER&&BARREL) begin
//            allstuboutn1[35:33] <= stubin[2:0];               // Stub pt
//            allstuboutn1[32:25] <= stubin[35:28];             // r
//            allstuboutn1[24:17] <= stubin[27:20];             // z
//            allstuboutn1[16:0]  <= stubin[19:3];              // phi
//        end
//        if(INNER&&!BARREL) begin        
//            allstuboutn1[35:33] <= stubin[2:0];               // Stub pt      
//            allstuboutn1[32:26] <= stubin[35:29];             // r
//            allstuboutn1[25:14] <= stubin[28:17];             // z
//            allstuboutn1[13:0]  <= stubin[16:3];              // phi
//        end
//        if(!INNER&&!BARREL) begin
//            allstuboutn1[35:33] <= stubin[2:0];               // Stub pt
//            allstuboutn1[32:25] <= stubin[35:28];             // r
//            allstuboutn1[24:17] <= stubin[27:20];             // z
//            allstuboutn1[16:0]  <= stubin[19:3];              // phi
//        end
            allstuboutn1[35:33] <= stubin[2:0];               // Stub pt
            allstuboutn1[32:0] <= stubin[35:3];               // Everything else
    end
    
    ///////////////////////////////////////////////////////////////////////////
    reg [17:0] vmstubout_dly;

//Create multiple output buses.  These are actually one bus, but
// get multiple names outside the file.
    assign allstuboutn2 = allstuboutn1;
    assign allstuboutn3 = allstuboutn1;
    
    assign vmstuboutPHI1X1n1 = vmstubout_dly;
    assign vmstuboutPHI1X1n2 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n3 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n4 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n5 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X1n6 = vmstuboutPHI1X1n1;
    assign vmstuboutPHI1X2n1 = vmstubout_dly;
    assign vmstuboutPHI1X2n2 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n3 = vmstuboutPHI1X2n1;
    assign vmstuboutPHI1X2n4 = vmstuboutPHI1X2n1;
        
    assign vmstuboutPHI2X1n1 = vmstubout_dly;
    assign vmstuboutPHI2X1n2 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n3 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n4 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n5 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X1n6 = vmstuboutPHI2X1n1;
    assign vmstuboutPHI2X2n1 = vmstubout_dly;
    assign vmstuboutPHI2X2n2 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n3 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n4 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n5 = vmstuboutPHI2X2n1;
    assign vmstuboutPHI2X2n6 = vmstuboutPHI2X2n1;

    assign vmstuboutPHI3X1n1 = vmstubout_dly;        
    assign vmstuboutPHI3X1n2 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n3 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n4 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n5 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X1n6 = vmstuboutPHI3X1n1;
    assign vmstuboutPHI3X2n1 = vmstubout_dly;
    assign vmstuboutPHI3X2n2 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n3 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n4 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n5 = vmstuboutPHI3X2n1;
    assign vmstuboutPHI3X2n6 = vmstuboutPHI3X2n1;
            
    assign vmstuboutPHI4X1n1 = vmstubout_dly;
    assign vmstuboutPHI4X1n2 = vmstuboutPHI4X1n1;
    assign vmstuboutPHI4X1n3 = vmstuboutPHI4X1n1;
    assign vmstuboutPHI4X2n1 = vmstubout_dly;
    assign vmstuboutPHI4X2n2 = vmstuboutPHI4X2n1;
    assign vmstuboutPHI4X2n3 = vmstuboutPHI4X2n1;
    assign vmstuboutPHI4X2n4 = vmstuboutPHI4X2n1;
    
    ////////////////////////////////////////////////////////////////////////////
    //Output data enables.
    reg valid_data_dly;
    reg pre_vmstuboutPHI1X1_en;
    reg pre_vmstuboutPHI1X2_en;
    reg pre_vmstuboutPHI2X1_en;
    reg pre_vmstuboutPHI2X2_en;
    reg pre_vmstuboutPHI3X1_en;
    reg pre_vmstuboutPHI3X2_en;
    reg pre_vmstuboutPHI4X1_en;
    reg pre_vmstuboutPHI4X2_en;
    
    assign vmstuboutPHI1X1_en = pre_vmstuboutPHI1X1_en & valid_data_dly;
    assign vmstuboutPHI1X2_en = pre_vmstuboutPHI1X2_en & valid_data_dly;
    assign vmstuboutPHI2X1_en = pre_vmstuboutPHI2X1_en & valid_data_dly;
    assign vmstuboutPHI2X2_en = pre_vmstuboutPHI2X2_en & valid_data_dly;
    assign vmstuboutPHI3X1_en = pre_vmstuboutPHI3X1_en & valid_data_dly;
    assign vmstuboutPHI3X2_en = pre_vmstuboutPHI3X2_en & valid_data_dly;
    assign vmstuboutPHI4X1_en = pre_vmstuboutPHI4X1_en & valid_data_dly;
    assign vmstuboutPHI4X2_en = pre_vmstuboutPHI4X2_en & valid_data_dly;


//Create VMdata for output and output data.  Dependent on barrel/inner/odd setting
    always @(posedge clk) begin
        valid_data_dly <= valid_data;
        vmstubout_dly <= vmstubout;
        //Inner barrel output, ODD helps define which phi goes to which module.  Odd has 6 modules, even 8.
        if(INNER && BARREL) begin        
            vmstubout[17:15] <= stubin[2:0];     
            vmstubout[14:9]  <= index;
            vmstubout[8:5]   <= stubin[25:22];
            vmstubout[4:2]   <= {ODD ^ stubin[14],stubin[13:12]};
            vmstubout[1:0]   <= stubin[35:34];
            if(stubin1 != 0 & stubin1[26] == 1'b0 & (stubin1[16:14] == (3'b000 + ODD) | stubin1[16:14] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0; 
            if(stubin1[26] == 1'b0 & (stubin1[16:14] == (3'b010 + ODD) | stubin1[16:14] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(stubin1[26] == 1'b0 & (stubin1[16:14] == (3'b100 + ODD) | stubin1[16:14] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(stubin1[26] == 1'b0 & (stubin1[16:14] == (3'b110 + ODD) | stubin1[16:14] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(stubin1[26] == 1'b1 & (stubin1[16:14] == (3'b000 + ODD) | stubin1[16:14] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(stubin1[26] == 1'b1 & (stubin1[16:14] == (3'b010 + ODD) | stubin1[16:14] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(stubin1[26] == 1'b1 & (stubin1[16:14] == (3'b100 + ODD) | stubin1[16:14] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(stubin1[26] == 1'b1 & (stubin1[16:14] == (3'b110 + ODD) | stubin1[16:14] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
        //Outer barrel output, ODD helps define which phi goes to which module. Odd has 6 modules, even 8.
        if(!INNER && BARREL) begin
            vmstubout[17:15] <= stubin[2:0];
            vmstubout[14:9]  <= index;
            vmstubout[8:5]   <= stubin[24:21];
            vmstubout[4:2]   <= {ODD ^ stubin[17],stubin[16:15]};
            vmstubout[1:0]   <= stubin[35:34];
            if(stubin1 != 0 & stubin1[25] == 1'b0 & (stubin1[19:17] == (3'b000 + ODD) | stubin1[19:17] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0;
            if(stubin1[25] == 1'b0 & (stubin1[19:17] == (3'b010 + ODD) | stubin1[19:17] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(stubin1[25] == 1'b0 & (stubin1[19:17] == (3'b100 + ODD) | stubin1[19:17] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(stubin1[25] == 1'b0 & (stubin1[19:17] == (3'b110 + ODD) | stubin1[19:17] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(stubin1[25] == 1'b1 & (stubin1[19:17] == (3'b000 + ODD) | stubin1[19:17] == (3'b001 + ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(stubin1[25] == 1'b1 & (stubin1[19:17] == (3'b010 + ODD) | stubin1[19:17] == (3'b011 + ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(stubin1[25] == 1'b1 & (stubin1[19:17] == (3'b100 + ODD) | stubin1[19:17] == (3'b101 + ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(stubin1[25] == 1'b1 & (stubin1[19:17] == (3'b110 + ODD) | stubin1[19:17] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
        //Inner disk output, ODD helps define which phi goes to which module, opposite of Barrel. Odd has 8 modules, even 6.
        if(INNER && !BARREL) begin        
            vmstubout[17:15] <= stubin[2:0];     
            vmstubout[14:9]  <= index;
            vmstubout[8:7]   <= stubin[23:22];
            vmstubout[6:4]   <= {!ODD ^ stubin[14],stubin[13:12]};
            vmstubout[3:0]   <= stubin[32:29];
            if(stubin1 != 0 & stubin1[33] == 1'b0 & (stubin1[16:14] == (3'b000 + !ODD) | stubin1[16:14] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0; 
            if(stubin1[33] == 1'b0 & (stubin1[16:14] == (3'b010 + !ODD) | stubin1[16:14] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(stubin1[33] == 1'b0 & (stubin1[16:14] == (3'b100 + !ODD) | stubin1[16:14] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(stubin1[33] == 1'b0 & (stubin1[16:14] == (3'b110 + !ODD) | stubin1[16:14] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(stubin1[33] == 1'b1 & (stubin1[16:14] == (3'b000 + !ODD) | stubin1[16:14] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(stubin1[33] == 1'b1 & (stubin1[16:14] == (3'b010 + !ODD) | stubin1[16:14] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(stubin1[33] == 1'b1 & (stubin1[16:14] == (3'b100 + !ODD) | stubin1[16:14] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(stubin1[33] == 1'b1 & (stubin1[16:14] == (3'b110 + !ODD) | stubin1[16:14] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
        //Outer disk output, ODD helps define which phi goes to which module, opposite of Barrel. Odd has 8 modules, even 6.
        if(!INNER && !BARREL) begin
            vmstubout[17:15] <= stubin[2:0];
            vmstubout[14:9]  <= index;
            vmstubout[8:7]   <= stubin[26:25];
            vmstubout[6:4]   <= {!ODD ^ stubin[17],stubin[16:15]};
            vmstubout[3:0]   <= stubin[34:31];
            if(stubin1 != 0 & stubin1[35] == 1'b0 & (stubin1[19:17] == (3'b000 + !ODD) | stubin1[19:17] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X1_en <= 0;
            if(stubin1[35] == 1'b0 & (stubin1[19:17] == (3'b010 + !ODD) | stubin1[19:17] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X1_en <= 0;
            if(stubin1[35] == 1'b0 & (stubin1[19:17] == (3'b100 + !ODD) | stubin1[19:17] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X1_en <= 0;
            if(stubin1[35] == 1'b0 & (stubin1[19:17] == (3'b110 + !ODD) | stubin1[19:17] == 3'b111))
                pre_vmstuboutPHI4X1_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X1_en <= 0;
            if(stubin1[35] == 1'b1 & (stubin1[19:17] == (3'b000 + !ODD) | stubin1[19:17] == (3'b001 + !ODD)))
                pre_vmstuboutPHI1X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI1X2_en <= 0;
            if(stubin1[35] == 1'b1 & (stubin1[19:17] == (3'b010 + !ODD) | stubin1[19:17] == (3'b011 + !ODD)))
                pre_vmstuboutPHI2X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI2X2_en <= 0;
            if(stubin1[35] == 1'b1 & (stubin1[19:17] == (3'b100 + !ODD) | stubin1[19:17] == (3'b101 + !ODD)))
                pre_vmstuboutPHI3X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI3X2_en <= 0;
            if(stubin1[35] == 1'b1 & (stubin1[19:17] == (3'b110 + !ODD) | stubin1[19:17] == 3'b111))
                pre_vmstuboutPHI4X2_en <= 1'b1;
            else 
                pre_vmstuboutPHI4X2_en <= 0;
        end
    end
    
    
endmodule
