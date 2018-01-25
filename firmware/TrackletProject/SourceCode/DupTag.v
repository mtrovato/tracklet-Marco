`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2016 03:29:16 PM
// Design Name: 
// Module Name: DupTag
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

// Currently supports L1L2, L3L4, L5L6 seeding

module DupTag(state,clk,track1dupOut,track2dupOut,track1dupIn,track1Seed,track2Seed,track1,track2);
    // Initialize structures
    input wire[2:0] state;
    input wire clk;
    output wire track1dupOut;
    output wire track2dupOut;
    input wire track1dupIn;
    input wire[3:0] track1Seed;
    input wire[3:0] track2Seed;
    input wire[53:0] track1;
    input wire[53:0] track2;
    
    // Iterator for ease of coding
    reg[2:0] i;
    
    // Store duplicate tag inputs
    reg track1dup = 1'b0;
    reg track2dup = 1'b0;
    always @(posedge clk) begin
        track1dup <= track1dupIn;
        if(state==3'd3) begin
            track2dup <= 1'b0;
        end else begin
            track2dup <= track2dup || (!track1dupIn && nIndStub2<3'd3 && nStub2<=nStub1);
        end
    end
    
    // Pull the stubs from the track blindly. Comparison logic will worry about which to compare.
    // [0] is the highest-bit stub, [5] is the lowest. In other words, {...,[0],[1],[2],[3],[4],[5],...}.
    wire[8:0] track1stub[5:0];
    wire[8:0] track2stub[5:0];
    genvar stub;
    generate
        for(stub=0; stub<6; stub=stub+1) begin
            assign track1stub[5-stub] = track1[8+stub*9:stub*9];
            assign track2stub[5-stub] = track2[8+stub*9:stub*9];            
        end
    endgenerate

    // Count number of hits.
    // All 1's is an empty stub (missed hit)
    reg[2:0] nStub1 = 3'd6;
    reg[2:0] nStub2 = 3'd6;
    always @(posedge clk) begin
        nStub1 <= ~&track1stub[0]+~&track1stub[1]+~&track1stub[2]+~&track1stub[3]+~&track1stub[4]+~&track1stub[5];
        nStub2 <= ~&track2stub[0]+~&track2stub[1]+~&track2stub[2]+~&track2stub[3]+~&track2stub[4]+~&track2stub[5];
    end

    // Flag stub as independent if it's neither a miss nor equal to the other track's corresponding stub.
    // Use a MUX to make the correct comparisons
    reg indStub1[5:0] = {1,1,1,1,1,1};
    reg indStub2[5:0] = {1,1,1,1,1,1};
    always @(posedge clk) begin
        case(track1Seed)
            4'd0: begin
                case(track2Seed)
                    4'd0: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd1: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[3]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[1]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[3]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[1]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd2: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[3]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[4]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[5]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[0]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[4]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[5]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[1]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[2]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[3]);
                    end
                    4'd3: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[4]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[1]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[0]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[5]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[4]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[2]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd4: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[1]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[0]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[3]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[3]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[2]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[5]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd5: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[4]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[2]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[5]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[4]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[2]);
                        indStub2[5] <= ~&track2stub[5];
                    end
                    default: begin
                        for(i=0; i<6; i=i+1) begin
                            indStub1[i] <= ~&track1stub[i];
                            indStub2[i] <= ~&track2stub[i];
                        end
                    end
                endcase
            end
            4'd1: begin
                case(track2Seed)
                    4'd0: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[3]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[1]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[3]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[1]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd1: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd2: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[4]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[0]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[4]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[5]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[0]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd3: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[5]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[1]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[0]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[5]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[4]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[3]);
                    end
                    4'd4: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd5: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[2]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[4]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[5]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5];
                    end
                    default: begin
                        for(i=0; i<6; i=i+1) begin
                            indStub1[i] <= ~&track1stub[i];
                            indStub2[i] <= ~&track2stub[i];
                        end
                    end
                endcase
            end
            4'd2: begin
                case(track2Seed)
                    4'd0: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[4]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[1]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[2]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[3]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[3]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[4]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[5]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[0]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd1: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[4]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[0]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[4]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[5]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[0]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd2: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd3: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[5]);
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5];
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[3]);
                    end
                    4'd4: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[5]);
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5];
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[3]);
                    end
                    4'd5: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5];
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5];
                    end
                    default: begin
                        for(i=0; i<6; i=i+1) begin
                            indStub1[i] <= ~&track1stub[i];
                            indStub2[i] <= ~&track2stub[i];
                        end
                    end
                endcase
            end
            4'd3: begin
                case(track2Seed)
                    4'd0: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[5]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[4]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[2]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[5]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[4]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[1]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[0]);
                    end
                    4'd1: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[5]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[4]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[3]);
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[5]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[1]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[0]);
                    end
                    4'd2: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[3]);
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[5]);
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5];
                    end
                    4'd3: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd4: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[3]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[4]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[0]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[1]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[3]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[4]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[0]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[1]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd5: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[1]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[2]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[0]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[1]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    default: begin
                        for(i=0; i<6; i=i+1) begin
                            indStub1[i] <= ~&track1stub[i];
                            indStub2[i] <= ~&track2stub[i];
                        end
                    end
                endcase
            end
            4'd4: begin
                case(track2Seed)
                    4'd0: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[3]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[2]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[5]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[1]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[5]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[1]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[0]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[3]);
                    end
                    4'd1: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[5]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[3]);
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[5]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[3]);
                    end
                    4'd2: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[3]);
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[5]);
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5];
                    end
                    4'd3: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[3]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[4]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[0]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[1]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[3]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[4]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[0]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[1]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd4: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd5: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[3]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[4]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[0]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[2]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[1]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[2]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[3]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[4]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[0]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[1]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    default: begin
                        for(i=0; i<6; i=i+1) begin
                            indStub1[i] <= ~&track1stub[i];
                            indStub2[i] <= ~&track2stub[i];
                        end
                    end
                endcase
            end
            4'd5: begin
                case(track2Seed)
                    4'd0: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[4]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[2]);
                        indStub1[5] <= ~&track1stub[5];
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[4]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[2]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd1: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[5]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[4]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5];
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[2]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[1]);
                    end
                    4'd2: begin
                        indStub1[0] <= ~&track1stub[0];
                        indStub1[1] <= ~&track1stub[1];
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3];
                        indStub1[4] <= ~&track1stub[4];
                        indStub1[5] <= ~&track1stub[5];
                        
                        indStub2[0] <= ~&track2stub[0];
                        indStub2[1] <= ~&track2stub[1];
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3];
                        indStub2[4] <= ~&track2stub[4];
                        indStub2[5] <= ~&track2stub[5];
                    end
                    4'd3: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[0]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[1]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[1]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[2]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd4: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[2]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[3]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[4]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[0]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[1]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[3]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[4]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[0]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[1]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[2]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    4'd5: begin
                        indStub1[0] <= ~&track1stub[0] && (track1stub[0] != track2stub[0]);
                        indStub1[1] <= ~&track1stub[1] && (track1stub[1] != track2stub[1]);
                        indStub1[2] <= ~&track1stub[2] && (track1stub[2] != track2stub[2]);
                        indStub1[3] <= ~&track1stub[3] && (track1stub[3] != track2stub[3]);
                        indStub1[4] <= ~&track1stub[4] && (track1stub[4] != track2stub[4]);
                        indStub1[5] <= ~&track1stub[5] && (track1stub[5] != track2stub[5]);
                        
                        indStub2[0] <= ~&track2stub[0] && (track2stub[0] != track1stub[0]);
                        indStub2[1] <= ~&track2stub[1] && (track2stub[1] != track1stub[1]);
                        indStub2[2] <= ~&track2stub[2] && (track2stub[2] != track1stub[2]);
                        indStub2[3] <= ~&track2stub[3] && (track2stub[3] != track1stub[3]);
                        indStub2[4] <= ~&track2stub[4] && (track2stub[4] != track1stub[4]);
                        indStub2[5] <= ~&track2stub[5] && (track2stub[5] != track1stub[5]);
                    end
                    default: begin
                        for(i=0; i<6; i=i+1) begin
                            indStub1[i] <= ~&track1stub[i];
                            indStub2[i] <= ~&track2stub[i];
                        end
                    end
                endcase
            end
            default: begin
            end
        endcase
    end

    // Tally number of independent stubs.
    wire[2:0] nIndStub1;
    wire[2:0] nIndStub2;
    assign nIndStub1 = indStub1[0]+indStub1[1]+indStub1[2]+indStub1[3]+indStub1[4]+indStub1[5];
    assign nIndStub2 = indStub2[0]+indStub2[1]+indStub2[2]+indStub2[3]+indStub2[4]+indStub2[5];

    // Calculate duplicate tags
    // Track n is a duplicate if it's already a duplicate, OR if both tracks are independent, track n has less than 3 independent stubs, and it has fewer stubs than the other.
    // If both tracks have the same number of stubs, track 2 is tagged as a duplicate. This automatically prefers inner-barrel tracklets.
    reg track1dupOutReg; 
    reg track2dupOutReg;
    always @(posedge clk) begin
        track1dupOutReg <= track1dupIn || (!track2dup && nIndStub1<3'd3 && nStub1<nStub2);
        track2dupOutReg <= track2dup || (!track1dupIn && nIndStub2<3'd3 && nStub2<=nStub1);
    end
    assign track1dupOut = track1dupOutReg;
    assign track2dupOut = track2dupOutReg;

endmodule
