`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2015 04:43:00 PM
// Design Name: 
// Module Name: TProjMemory
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


module TProjMemory(
    input wire proc_clk,
    input wire out_clk,
    input reset,
    input [54:0] proj,
    input valid,
    output [54:0] projout
    );
    
    reg [5:0] wr_add;
    reg [8:0] read_add;
    reg [2:0] BX;
    
    reg [54:0] proj_dly;
    reg valid_dly;
    
    reg count;
    initial
      read_add = 0;
    
    always @ (posedge proc_clk) begin
        proj_dly <= proj;
        //if (proj_dly[47:0] != proj[47:0]) begin
            if (proj[54:51] == 4'hF) begin
                BX <= proj[50:48];
                wr_add <= 6'h00;
            end
            else begin
                valid_dly <= valid;
                if (count) begin
                    wr_add <= wr_add + 1'b1;
                end
            end
        //end
        
    end
    always @ (posedge proc_clk) begin // Use this to write data every 2 clk cycles
        if (BX[2:0]==3'h0) count <= 1'b0;
        else count <= ~count;
    end
    
    always @ (posedge out_clk) begin
           read_add <= read_add + 1'b1;
     end
    
    fifo_projection_out ProjToPlus_out(.wr_clk(proc_clk), .rst(reset), .din(proj[54:0]), .wr_en(valid), 
                                     .rd_clk(out_clk), .rd_en(1'b1), .dout(projout),
                                     .empty(empty), .full(full));
    
    /*
     Memory #(
        .RAM_WIDTH(48),                       // Specify RAM data width
        .RAM_DEPTH(512),                     // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) ProjToPlus (
        .addra({BX,wr_add}),    // Write address bus, width determined from RAM_DEPTH
        .addrb(read_add),    // Read address bus, width determined from RAM_DEPTH
        .dina(proj[47:0]),      // RAM input data, width determined from RAM_WIDTH
        .clka(proc_clk),         // Write clock
        .clkb(out_clk),      // Read clock
        .wea(valid),        // Write enable
        .enb(1'b1),        // Read Enable, for additional power savings, disable when not in use
        .rstb(1'b0),      // Output reset (does not affect memory contents)
        .regceb(1'b1),      // Output register enable
        .doutb(projout)     // RAM output data, width determined from RAM_WIDTH
        );
    
    */
endmodule
