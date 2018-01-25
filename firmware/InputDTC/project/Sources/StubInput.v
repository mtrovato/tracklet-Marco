`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2015 05:21:00 PM
// Design Name: 
// Module Name: StubInput
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


module StubInput(
    input clk,
    input io_clk,
    input reset,
    input BC0,
    input read_en,
    
    input BRAM_INPUT1_en,
    output [31:0] BRAM_INPUT1_dout,
    input [31:0] BRAM_INPUT1_din,
    input [3:0] BRAM_INPUT1_we,
    input [15:0] BRAM_INPUT1_addr,
    input BRAM_INPUT1_clk,
    input BRAM_INPUT1_rst,
    input BRAM_INPUT2_en,
    output [31:0] BRAM_INPUT2_dout,
    input [31:0] BRAM_INPUT2_din,
    input [3:0] BRAM_INPUT2_we,
    input [15:0] BRAM_INPUT2_addr,
    input BRAM_INPUT2_clk,
    input BRAM_INPUT2_rst,
    
    input [31:0] input_reg1,
    input [31:0] input_reg2,
    (* mark_debug = "true" *) output [35:0] data_out
    );
    
    reg [35:0] data_in;     // 36-bit input data
    reg [35:0] data_in_dly; // ???
    reg [11:0] write_add;    // write address
    reg [15:0] read_add;     // read address
    
    wire [31:0] pre_dout_1;
    wire [31:0] pre_dout_2;
    
    
    assign data_out = {pre_dout_1[15:0],pre_dout_2[19:0]};
    
    initial begin
        write_add = 12'h0;  // how are these addresses set ???
        read_add = 16'hfffc; // -"-
    end
    
    always @ (posedge io_clk) begin
        data_in_dly <= data_in;

        // if bits 28-31 are identical on input links 1&2, then stitch 16+20 bit data to 36 bit word
        if (input_reg1[31:28] == input_reg2[31:28])
            data_in <= {input_reg1[15:0],input_reg2[19:0]};
        else
            data_in <= 0;
        
        // if data_in was filled and one clock cycle passed (?) -- this is "write enable", increase write address
        if (data_in != data_in_dly & data_in_dly != 0)
            write_add <= write_add + 1'b1;
        else 
            write_add <= write_add;
    end
    
    always @ (posedge clk) begin
        /*
        if (read_add == 16'h23fc)
            read_add <= 16'h0;
        else begin     
            if(read_en) begin
                if(BC0)
                    read_add <= 16'h0;
                else
                    read_add <= read_add + 3'b100;
            end
            else
                read_add <= read_add;
        end
        */
        //if(read_en & read_add != 16'hfff8)
        if(read_en & read_add != 16'h3844)  // read first 100 BXs
            read_add <= read_add + 3'b100;
        else  
            read_add <= read_add;
    end
    
//    Memory #(
//        .RAM_WIDTH(36),                  // Specify RAM data width
//        .RAM_DEPTH(4096),                 // Specify RAM depth (number of entries)
//        .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
//        .INIT_FILE("")                   // Specify name/location of RAM initialization file if using one (leave blank if not)
//      ) stubs (
//        .addra(write_add),               // Write address bus, width determined from RAM_DEPTH
//        .addrb(read_add),                // Read address bus, width determined from RAM_DEPTH
//        .dina(data_in_dly),              // RAM input data, width determined from RAM_WIDTH
//        .clka(io_clk),                   // Write clock
//        .clkb(clk),                      // Read clock
//        .wea(data_in != data_in_dly & data_in_dly != 0), // Write enable
//        .enb(1'b1),                      // Read Enable, for additional power savings, disable when not in use
//        .rstb(reset),                    // Output reset (does not affect memory contents)
//        .regceb(1'b1),                   // Output register enable
//        .doutb(data_out)                 // RAM output data, width determined from RAM_WIDTH
//        );
        
  Memory #(
        .RAM_WIDTH(32),                  // Specify RAM data width
        .RAM_DEPTH(16384),                 // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                   // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) test_rpc1 (
        .addra(BRAM_INPUT1_addr),               // Write address bus, width determined from RAM_DEPTH
        .addrb(read_add),                // Read address bus, width determined from RAM_DEPTH
        .dina(BRAM_INPUT1_din),              // RAM input data, width determined from RAM_WIDTH
        .clka(BRAM_INPUT1_clk),                   // Write clock
        .clkb(clk),                      // Read clock
        .wea(BRAM_INPUT1_we), // Write enable
        .enb(1'b1),                      // Read Enable, for additional power savings, disable when not in use
        .rstb(BRAM_INPUT1_rst),                    // Output reset (does not affect memory contents)
        .regceb(1'b1),                   // Output register enable
        .doutb(pre_dout_1)                 // RAM output data, width determined from RAM_WIDTH
        );
    Memory #(
        .RAM_WIDTH(32),                  // Specify RAM data width
        .RAM_DEPTH(16384),                 // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                   // Specify name/location of RAM initialization file if using one (leave blank if not)
      ) test_rpc2 (
        .addra(BRAM_INPUT2_addr),               // Write address bus, width determined from RAM_DEPTH
        .addrb(read_add),                // Read address bus, width determined from RAM_DEPTH
        .dina(BRAM_INPUT2_din),              // RAM input data, width determined from RAM_WIDTH
        .clka(BRAM_INPUT2_clk),                   // Write clock
        .clkb(clk),                      // Read clock
        .wea(BRAM_INPUT2_we), // Write enable
        .enb(1'b1),                      // Read Enable, for additional power savings, disable when not in use
        .rstb(BRAM_INPUT2_rst),                    // Output reset (does not affect memory contents)
        .regceb(1'b1),                   // Output register enable
        .doutb(pre_dout_2)                 // RAM output data, width determined from RAM_WIDTH
        );
    
endmodule
