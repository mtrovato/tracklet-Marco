`timescale 1 ns / 1 ps 
`include "constants.vh"

module input_mem #(
parameter INPUT_SIZE = 18
)(
    input clk,
    input reset,
    input en_proc,
    input [1:0] start,
    input [1:0] done,
        
    input [INPUT_SIZE-1:0] data_in, 
    input enable,
    
    input [`MEM_SIZE:0] read_add,
    output reg [5:0] number_out,
    output reg [INPUT_SIZE-1:0] data_out
    
    );
 
    //---------------------------------------------------
    // Deal w/ clocks & resets
    //---------------------------------------------------      
    reg [2:0] BX_pipe;
    reg [2:0] BX_hold;
    reg [2:0] rd_BX_pipe;
    reg first_clk_pipe;
    
    wire rst_pipe;
    assign rst_pipe = start[1];
    
    initial begin
        BX_pipe = 3'b111;
    end
    
    always @(posedge clk) begin
        if (rst_pipe) begin
            BX_pipe <= 3'b111;
        end
        else begin
            if (start[0]) begin
                BX_pipe <= BX_pipe + 1'b1;
                first_clk_pipe <= 1'b1;
            end
            else begin
                first_clk_pipe <= 1'b0;
            end
        end
        BX_hold <= BX_pipe;
    end
    
    // delay start to be done signal by #STAGES
    pipe_delay #(.STAGES(`tmux), .WIDTH(2)) 
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
        
    //---------------------------------------------------
    // Save to memory
    //---------------------------------------------------   
    reg [INPUT_SIZE-1:0] data_in_dly[3:0];
    wire [INPUT_SIZE-1:0] pre_data_out;
    reg enable_dly [3:0];
    reg [`MEM_SIZE:0]  wr_add;
    reg wr_en;
        
    initial begin
        data_in_dly[0] = 128'h0;
        data_in_dly[1] = 128'h0;
        data_in_dly[2] = 128'h0;
        data_in_dly[3] = 128'h0;
    end
    
    always @(posedge clk) begin
        data_in_dly[0] <= data_in;
        data_in_dly[1] <= data_in_dly[0];
        data_in_dly[2] <= data_in_dly[1];
        data_in_dly[3] <= data_in_dly[2];
        enable_dly[0]  <= enable;
        enable_dly[1]  <= enable_dly[0];
        enable_dly[2]  <= enable_dly[1];
        enable_dly[3]  <= enable_dly[2];
        if (first_clk_pipe) begin
            wr_add <= {`MEM_SIZE+1{1'b1}};
            //wr_en <= 1'b0;
            number_out <= wr_add + 1'b1;
        end
        else begin
            if (enable_dly[0]) begin
                wr_add <= wr_add + 1'b1;
                wr_en  <= 1'b1;
            end
            else begin
                wr_add <= wr_add;
                wr_en  <= 1'b0;
            end
        end
        data_out <= pre_data_out;
        BX_hold  <= BX_pipe;
    end
    
//    reg_array #( // use this to store number out
//        .RAM_WIDTH(6),
//        .RAM_DEPTH(16),
//        .INIT_FILE("")
//    ) Number_out (
//        .addra(BX_pipe),
//        .addrb(read_add[8:5]),
//        .dina(wr_add+1'b1),
//        .clka(clk),
//        .clkb(clk),
//        .wea(1'b1),
//        .rstb(rst_pipe),
//        .regceb(1'b1),
//        .doutb(number_out)
//    );
    
    reg_array#(
    //Memory #( // actual data memory
        .RAM_WIDTH(INPUT_SIZE),                     // Specify RAM data width
        .RAM_DEPTH(2**(`MEM_SIZE+1)),               // Specify RAM depth (# of entries) -- currently 64
        .RAM_PERFORMANCE("HIGH_PERFORMANCE"),       // HIGH_PERFORMANCE or LOW_LATENCY
        .INIT_FILE("")                              // Specify name/location of RAM initilization
    ) Input_Memory (
        .addra({BX_hold[0],wr_add[`MEM_SIZE-1:0]}), // Write address
        .addrb(read_add[`MEM_SIZE:0]),              // Read address
        .dina(data_in_dly[0]),                      // RAM input data
        .clka(clk),                                 // Write clock
        .clkb(clk),                                 // Read clock
        .wea(wr_en),                                // Write enable
        //.enb(1'b1),                                 // Read Enable
        .rstb(rst_pipe),                            // Output reset (does not affect memory contents)
        .regceb(1'b1),                              // Output register enable
        .doutb(pre_data_out)                        // RAM output data
    );
        
    
endmodule