`timescale 1 ns / 1 ps
`include "constants.vh"

module output_mem #(
parameter INPUT_SIZE = 18
)(
    input clk,
    input reset,
    input en_proc,
    input [1:0] start,
    input [1:0] done,
        
    input [INPUT_SIZE-1:0] data_in, 
    input enable,   
    output [5:0] number_out,
    input [4+`MEM_SIZE:0] read_add,
    output [INPUT_SIZE-1:0] data_out
    
    );
 
    //---------------------------------------------------
    // Deal w/ clocks & resets
    //---------------------------------------------------      
    reg [4:0] BX_pipe;
    reg first_clk_pipe;
    
    wire rst_pipe;
    assign rst_pipe = start[1];
    
    initial BX_pipe = 5'b11111;
    
    always @(posedge clk) begin
        if (rst_pipe) BX_pipe <= 5'b11111;
        else begin
            if (start[0]) begin
                BX_pipe <= BX_pipe + 1'b1;
                first_clk_pipe <= 1'b1;
            end
            else begin
                first_clk_pipe <= 1'b0;
            end
        end
    end
    
    // delay start by # STAGES
    pipe_delay #(.STAGES(`tmux+2), .WIDTH(3)) 
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
        
    //---------------------------------------------------
    // Save to memory
    //---------------------------------------------------   
    reg [INPUT_SIZE-1:0] data_in_dly;
    reg [`MEM_SIZE-1:0]  wr_add;
    reg wr_en;
    wire [4:0] BX_hold_1;
    wire [4:0] BX_hold_2;
    
    reg [3:0] hold;
    reg enable_dly;
    
    always @(posedge clk) begin
        data_in_dly <= data_in;
        enable_dly  <= enable;
        
        if (first_clk_pipe) begin 
            wr_add <= {`MEM_SIZE{1'b0}};
            if (enable) wr_en <= 1'b1;
        end
        else begin
            if (enable && wr_add < 5'b11111) begin
                wr_add <= wr_add + 1'b1;
                wr_en  <= 1'b1;
            end
            else begin
                wr_add <= wr_add;
                wr_en  <= 1'b0;
            end
        end
    end
    
    Memory #(
        .RAM_WIDTH(INPUT_SIZE),                     // Specify RAM data width
        .RAM_DEPTH(2**(`MEM_SIZE+5)),               // Specify RAM depth (# of entries)
        .RAM_PERFORMANCE("HIGH_PERFORMANCE"),       // HIGH_PERFORMANCE or LOW_LATENCY
        .INIT_FILE("")                              // Specify name/location of RAM initilization
    ) Input_Memory (
        .addra({BX_pipe,wr_add[`MEM_SIZE-1:0]}),    // Write address
        .addrb(read_add[(`MEM_SIZE+5)-1:0]),        // Read address
        .dina(data_in_dly),                         // RAM input data
        .clka(clk),                                 // Write clock
        .clkb(clk),                                 // Read clock
        .wea(wr_en),                                // Write enable
        .enb(1'b1),                                 // Read Enable
        .rstb(rst_pipe),                            // Output reset (does not affect memory contents)
        .regceb(1'b1),                              // Output register enable
        .doutb(data_out)                            // RAM output data
    );
        
    
endmodule