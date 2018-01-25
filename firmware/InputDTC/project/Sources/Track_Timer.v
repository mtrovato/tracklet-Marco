`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2016 06:26:08 PM
// Design Name: 
// Module Name: Track_Timer
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
module Track_Timer(
    input clk,
    input io_clk,
    (* mark_debug = "true" *) input reset,
    (* mark_debug = "true" *) input start,  // start sending stubs
    (* mark_debug = "true" *) input valid_track,    // receive a valid track
    (* mark_debug = "true" *) input [4:0] track_BX, // BX of the received track
    
    (* mark_debug = "true" *) input [15:0] BRAM_TIMER_addr, 
    (* mark_debug = "true" *) output [31:0] BRAM_TIMER_dout
    );
    
    (* mark_debug = "true" *) reg [26:0] timer;
    (* mark_debug = "true" *) reg [11:0] write_add;
    reg stop;   // 1 if timer counter overflows
    (* mark_debug = "true" *) reg wr_en;
    
    reg start_dly, start_dly2, start_dly3;   
    wire start_pulse;
    
    reg [4:0] track_BX_dly;
    
    always @(posedge clk) begin
    // 2 clock latency in StubInput between track_en and first stub sent
        start_dly <= start;
        start_dly2 <= start_dly;
        start_dly3 <= start_dly2;
        
        track_BX_dly <= track_BX;
    end     
      
    assign start_pulse = start_dly2 && (!start_dly3);   // 1 if first stub sent
    
    always @(posedge clk) begin
        if (reset) begin
            timer <= 27'b0;
            stop <= 0;
            write_add <= 12'b0;
            wr_en <= 0;
        end
        else begin
            if (timer == 27'h3fffffe) stop <= 1'b1;
            if (start && !stop) timer <= timer + 1'b1;
            
            if ((start_pulse || valid_track) && write_add != 12'hffc) begin
                wr_en <= 1;
                write_add <= write_add + 3'b100;
            end
            else begin
                wr_en <= 0;
                write_add <= write_add;   
            end
            
        end
    end
    
    Memory #(
        .RAM_WIDTH(32),                  // Specify RAM data width
        .RAM_DEPTH(4096),                 // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                   // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) timer_mem (
        .addra(write_add),               // Write address bus, width determined from RAM_DEPTH
        .addrb(BRAM_TIMER_addr),                // Read address bus, width determined from RAM_DEPTH
        .dina({track_BX_dly, timer}),              // RAM input data, width determined from RAM_WIDTH
        .clka(clk),                   // Write clock
        .clkb(io_clk),                      // Read clock
        .wea(wr_en), // Write enable
        .enb(1'b1),                      // Read Enable, for additional power savings, disable when not in use
        .rstb(reset),                    // Output reset (does not affect memory contents)
        .regceb(1'b1),                   // Output register enable
        .doutb(BRAM_TIMER_dout)                 // RAM output data, width determined from RAM_WIDTH
        );
    
endmodule
