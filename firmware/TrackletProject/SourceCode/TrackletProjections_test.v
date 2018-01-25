`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 11:53:00 AM
// Design Name: 
// Module Name: TrackletProjections
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


module TrackletProjections_test(
   // clocks and reset
    input wire reset,					// active HI
    input wire clk,				// processing clock at a multiple of the crossing clock
    input wire en_proc,
    
    input start,
       
    input wire [55:0] tracklet,            
    output reg [53:0] projection,
    input valid_trackpar,
    input [3:0] TC_index,
    output reg valid_proj,
    output reg valid_projPlus,
    output reg valid_projMinus
    );
    
    parameter PHI_BITS = 14;
    parameter Z_BITS = 12;
    parameter PHID_BITS = 7;
    parameter ZD_BITS = 8;
    parameter layer = 1'b1;
    parameter rproj = 16'h86a;
     
    // Step 0: Read the parameters and Constants
    reg signed [13:0] irinv_0;
    reg signed [17:0] iphi0_0;
    reg signed [9:0] iz0_0;
    reg signed [13:0] it_0;
    reg signed [15:0] ir_0;
    
    always @(posedge clk) begin
        irinv_0     <= tracklet[55:42];
        iphi0_0     <= tracklet[41:24];
        iz0_0       <= tracklet[23:14];
        it_0        <= tracklet[13:0];
        ir_0        <= rproj;
    end
    wire signed [17:0] iphi0_pipe3;
    wire signed [9:0] iz0_pipe3;
    wire en2_5;
    wire en5b;
        
    pipe_delay #(.STAGES(13), .WIDTH(18))
        iphi0_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
        .val_in(iphi0_0), .val_out(iphi0_pipe3));
    
   pipe_delay #(.STAGES(12), .WIDTH(10))
        iz0_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
        .val_in(iz0_0), .val_out(iz0_pipe3)); 
    
    // Step 1:
    // Declare:
    wire signed [29:0] full_is1;
    wire signed [29:0] full_is5;
    reg signed [15:0] is1_1;
    reg signed [14:0] is5_1;
    wire signed [15:0] pre_is1_pipe25;
    wire signed [14:0] pre_is5_pipe25;
    reg signed [13:0] full_iphider_1;
    reg signed [13:0] iz_der_1;
    wire [ZD_BITS-1:0] iz_der_5;

    always @(posedge clk) begin
        iz_der_1 <= it_0 >>> 6'd6;
        is1_1 <= full_is1 >>> 5'd10;
        is5_1 <= full_is5 >>> 5'd9;
        full_iphider_1 <= -irinv_0;
    end
    
    pipe_delay #(.STAGES(14), .WIDTH(8))
            iz_der_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
            .val_in(iz_der_1[7:0]), .val_out(iz_der_5));
            
    pipe_mult #(.STAGES(2), .AWIDTH(16), .BWIDTH(14))
            full_is1_test(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
            .a(ir_0), .b(irinv_0), .p(full_is1));
          
    pipe_mult #(.STAGES(2), .AWIDTH(16), .BWIDTH(14))
            full_is5_test(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
            .a(ir_0), .b(it_0), .p(full_is5));
          
    pipe_delay #(.STAGES(5), .WIDTH(16))
            pre_is1_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
            .val_in(is1_1), .val_out(pre_is1_pipe25)); 
                               
    pipe_delay #(.STAGES(5), .WIDTH(15))
            pre_is5_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
            .val_in(is5_1), .val_out(pre_is5_pipe25)); 
                               
    // Step 2:
    // Declare:
    wire signed [31:0] full_is2_2;
    reg signed [7:0] is2_2;
    reg signed [PHID_BITS-1:0] iphi_der_2;
    wire signed [PHID_BITS-1:0] iphi_der_5;
            
    pipe_mult #(.STAGES(2), .AWIDTH(16), .BWIDTH(16))
        is2_test(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
        .a(is1_1), .b(is1_1), .p(full_is2_2));
        
    
    always @(posedge clk) begin
        is2_2       <= full_is2_2 >>> 6'd23;
        iphi_der_2  <= full_iphider_1 >>> 6'd8;
    end
    
    pipe_delay #(.STAGES(13), .WIDTH(PHID_BITS))
        iphi_der_pipe(.pipe_in(en_proc), .pipe_out(en5b), .clk(clk),
        .val_in(iphi_der_2), .val_out(iphi_der_5));
    
    // Step 2.5 Calculate s3:
    // Declare:
    reg signed [11:0] is3_2_5;
    
    always @(posedge clk) begin
        is3_2_5 <= 12'h400 + (is2_2 >>> 6'd3); // Can this be done in the same clock?
    end
   
   // Step 3:
    wire signed [27:0] full_is4;
    reg signed [17:0] is4_3;
    wire signed [26:0] pre_iz_proj;
    reg signed [26:0] iz_proj_3;
    
    pipe_mult #(.STAGES(2), .AWIDTH(16), .BWIDTH(12))
        is4_test(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
        .a(pre_is1_pipe25), .b(is3_2_5), .p(full_is4));
    
    pipe_mult #(.STAGES(2), .AWIDTH(15), .BWIDTH(12))
        iz0_test(.pipe_in(en_proc), .pipe_out(pipe), .clk(clk),
        .a(pre_is5_pipe25), .b(is3_2_5), .p(pre_iz_proj));
    
    always @(posedge clk) begin
        is4_3        <= full_is4 >>> 6'd9;
        iz_proj_3 <= ((iz0_pipe3 <<< 5'd12 ) + pre_iz_proj) >>> 5'd12;
    end
    
    
    // Step 4:
    reg signed [17:0] iphi_proj_4;
    reg signed [11:0] iz_proj_4;

    
    always @(posedge clk) begin
        iphi_proj_4     <= iphi0_pipe3 - is4_3;
        if(layer)
            iz_proj_4 <= iz_proj_3;
        else
            iz_proj_4 <= iz_proj_3 >>> 5'd4;
    end

    // Step 5:
    reg [PHI_BITS-1:0] iphi_proj_5;
    reg signed [Z_BITS-1:0] iz_proj_5;
    reg [15:0] behold;
    reg local_valid, minus_valid, plus_valid;
    reg pre_valid, pre_minus_valid, pre_plus_valid;
    reg pre_valid2, pre_minus_valid2, pre_plus_valid2;

    //if in inner layers (layer==1) phi of proj is 14 bits 
    //if in outer laters (layer==0) phi of proj is 17 bits only relevant are 16 though
    //compare the phi_proj4 with the 1/2 of the bounds before shifting to do computation in one step
    //and then shift by the number of bits needed for each of the different layers
    always @(posedge clk) begin
        iz_proj_5 <= iz_proj_4;
        behold[0] <= valid_trackpar;
        behold[15:1] <= behold[14:0];
        valid_proj  <=(behold[15] & local_valid);
        valid_projMinus  <= (behold[15] & minus_valid);
        valid_projPlus  <= (behold[15] & plus_valid);
               
        if(layer) begin
            if(iphi_proj_4 < $signed(18'd8192)) begin
                iphi_proj_5    <= (iphi_proj_4 + 20'd49152) >>> 2'b10;
                minus_valid <= 1'b1;
                local_valid <= 1'b0;
                plus_valid <= 1'b0;
            end
            else begin 
                if(iphi_proj_4 < $signed(18'd57344)) begin
                    iphi_proj_5    <= iphi_proj_4 >>> 2'b10;
                    minus_valid <= 1'b0;
                    local_valid <= 1'b1;
                    plus_valid <= 1'b0;
                end
                else begin
                    iphi_proj_5    <= (iphi_proj_4 - 20'd49152) >>> 2'b10;
                    minus_valid <= 1'b0;
                    local_valid <= 1'b0;
                    plus_valid <= 1'b1;
                end
            end
        end
        else begin
            if(iphi_proj_4 < $signed(18'd8192)) begin
                iphi_proj_5    <= (iphi_proj_4 + 20'd49152) <<< 1'b1;
                minus_valid <= 1'b1;
                local_valid <= 1'b0;
                plus_valid <= 1'b0;
            end
            else begin 
                if(iphi_proj_4 < $signed(18'd57344)) begin
                    iphi_proj_5    <= iphi_proj_4 <<< 1'b1;
                    minus_valid <= 1'b0;
                    local_valid <= 1'b1;
                    plus_valid <= 1'b0;
                end
                else begin
                    iphi_proj_5    <= (iphi_proj_4 - 20'd49152) <<< 1'b1;
                    minus_valid <= 1'b0;
                    local_valid <= 1'b0;
                    plus_valid <= 1'b1;
                end
            end
        end
    end
    
    wire [5:0] index;  
    reg [5:0] pre_index;  
                      
   pipe_delay #(.STAGES(16), .WIDTH(6))
       index_delay(.pipe_in(), .pipe_out(), .clk(clk),
       .val_in(pre_index), .val_out(index));
                                                                
    always @(posedge clk) begin
        if(start)
            pre_index <= 6'b0;
        else begin
            if(valid_trackpar)
                pre_index <= pre_index + 1'b1;
            else
                pre_index <= pre_index;
        end
        
        projection <= {TC_index,index,iphi_proj_5,iz_proj_5,iphi_der_5,iz_der_5};
    end
        
endmodule
