`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 01:01:32 PM
// Design Name: 
// Module Name: LayerRouter
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


module LayerRouter(
    input clk,
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
        
    (* mark_debug = "true" *) input [35:0] stubin,
    
    output reg wr_en1, // Layer 1 - Disk 1
    output reg wr_en2, // Layer 2 - Disk 2
    output reg wr_en3, // Layer 3 - Disk 3
    output reg wr_en4, // Layer 4 - Disk 4
    output reg wr_en5, // Layer 5 - Disk 5
    output reg wr_en6, // Layer 6
    
    output reg [35:0] stubout1, 
    output reg [35:0] stubout2,
    output reg [35:0] stubout3,
    output reg [35:0] stubout4,
    output reg [35:0] stubout5,
    output reg [35:0] stubout6
    );
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
        
    reg [6:0] stub_cnt; // Number of stubs by layer // This is the first word after the header
    reg [5:0] numberL1;
    reg [5:0] numberL2;
    reg [5:0] numberL3;
    reg [5:0] numberL4;
    reg [5:0] numberL5;
    reg [5:0] numberL6;
    reg [35:0] stubin_hold; // Delay the data for comparison with current data

    pipe_delay #(.STAGES(1), .WIDTH(2))
       done_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(start), .val_out(done));

    initial begin
        stub_cnt = 0;
        numberL1 = 0;
        numberL2 = 0;
        numberL3 = 0;
        numberL4 = 0;
        numberL5 = 0;
        numberL6 = 0;
    end

    always @(posedge clk) begin
        stubin_hold <= stubin;
        wr_en1 <= (stub_cnt < numberL1 & stubin[23:0] != 24'hffffff & stub_cnt < 6'h1f) ; // Data is not the header
        wr_en2 <= (stub_cnt < numberL2 & stub_cnt >= numberL1) ;
        wr_en3 <= (stub_cnt < numberL3 & stub_cnt >= numberL2) ;
        wr_en4 <= (stub_cnt < numberL4 & stub_cnt >= numberL3) ;
        wr_en5 <= (stub_cnt < numberL5 & stub_cnt >= numberL4) ;
        wr_en6 <= (stub_cnt < numberL6 & stub_cnt >= numberL5) ;


        if(stubin_hold[35:33] == 3'b111 & stubin_hold[24:0] == 25'h1ffffff & stubin[35:33] != 3'b111 & stubin[24:0] != 25'h1ffffff) begin // Delayed data is the header, current data is the stub count
            stub_cnt <= 0;
            numberL1 <= stubin[35:30]; // Assign the stub count for each layer
            numberL2 <= stubin[29:24];
            numberL3 <= stubin[23:18];
            numberL4 <= stubin[17:12];
            numberL5 <= stubin[11:6];
            numberL6 <= stubin[5:0];
        end
        else begin
            if(stubin_hold[24:0] != 25'h0) // If not trailer, increase the stub counter
                stub_cnt <= stub_cnt + 1;
            else
                stub_cnt <= stub_cnt;
        end
        
        if(wr_en1) // Assign the stub data to the corresponding layer
            stubout1 <= stubin_hold;
        else
            stubout1 <= 0;
        if(wr_en2)
            stubout2 <= stubin_hold;
        else
            stubout2 <= 0;
        if(wr_en3)
            stubout3 <= stubin_hold;
        else
            stubout3 <= 0;
        if(wr_en4)
            stubout4 <= stubin_hold;
        else
            stubout4 <= 0;
        if(wr_en5)
            stubout5 <= stubin_hold;
        else
            stubout5 <= 0;
        if(wr_en6)
            stubout6 <= stubin_hold;
        else

            stubout6 <= 0;        
    end
endmodule
