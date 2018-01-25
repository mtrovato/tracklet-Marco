`timescale 1ns / 1ps

module prep_mem #(
parameter INPUT_SIZE = 16
)(
    input clk, 
    input reset, 
    input en_proc, 
    input [1:0] start, 
    output [1:0] done,
    input [INPUT_SIZE-1:0] data_in, 
    output reg [INPUT_SIZE-1:0] data_out, 
    output reg wr_en
    );
        
    pipe_delay #(.STAGES(1), .WIDTH(2)) 
        done_delay(.pipe_in(), .pipe_out(), .clk(clk),
        .val_in(start), .val_out(done));
        
    initial wr_en = 1'b0;
    
    reg [INPUT_SIZE-1:0] data_in_dly1, data_in_dly2, data_in_dly3;
    reg pre1_wr_en, pre2_wr_en, pre3_wr_en;
    
    always @(posedge clk) begin
        data_in_dly1 <= data_in;
        data_in_dly2 <= data_in_dly1;
        data_in_dly3 <= data_in_dly2;
        data_out     <= data_in_dly3;
        pre1_wr_en   <= (data_in[INPUT_SIZE-1:0] != 128'hFFFFFFFFF && data_in[INPUT_SIZE-1:0] != 128'h000000000);
        pre2_wr_en   <= pre1_wr_en;
        pre3_wr_en   <= pre2_wr_en;
        wr_en        <= pre2_wr_en;
    end
    
endmodule
