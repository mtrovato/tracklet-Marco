`timescale 1ns / 1ps
`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2014 04:14:20 PM
// Design Name: 
// Module Name: PurgeDuplicate
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

// To do: Start/Done is 2 bits, not 1. How to deal with this/what does that mean?

module PurgeDuplicate(
    input clk,
    input reset,
    input en_proc,
    
    input [1:0] start,
    output [1:0] done,
    
    input [125:0] trackin1,
    input [4:0] numberin1,
    output reg [`MEM_SIZE+2:0] read_add_trackin1,
    input [53:0] index_in1 [`tmux-1:0],
    input [125:0] trackin2,
    input [4:0] numberin2,
    output reg [`MEM_SIZE+2:0] read_add_trackin2,
    input [53:0] index_in2 [`tmux-1:0],
    input [125:0] trackin3,
    input [4:0] numberin3,
    output reg [`MEM_SIZE+2:0] read_add_trackin3,
    input [53:0] index_in3 [`tmux-1:0],
    input [125:0] trackin4,
    input [4:0] numberin4,
    output reg [`MEM_SIZE+2:0] read_add_trackin4,
    input [53:0] index_in4 [`tmux-1:0],
    input [125:0] trackin5,
    input [4:0] numberin5,
    output reg [`MEM_SIZE+2:0] read_add_trackin5,
    input [53:0] index_in5 [`tmux-1:0],
    input [125:0] trackin6,
    input [4:0] numberin6,
    output reg [`MEM_SIZE+2:0] read_add_trackin6,
    input [53:0] index_in6 [`tmux-1:0],
    
    output [125:0] trackout1,
    output wire valid_out_1,
    output [125:0] trackout2,
    output wire valid_out_2,
    output [125:0] trackout3,
    output wire valid_out_3,
    output [125:0] trackout4,
    output wire valid_out_4,
    output [125:0] trackout5,
    output wire valid_out_5,
    output [125:0] trackout6,
    output wire valid_out_6
    
    );
    
    pipe_delay #(.STAGES(`tmux), .WIDTH(2))
               done_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in(start), .val_out(done));
    
    pipe_delay #(.STAGES(3), .WIDTH(64))
               trackout1_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in({trackin1[117:113],trackin1[58:0]}), .val_out(trackout1[63:0]));
    pipe_delay #(.STAGES(3), .WIDTH(64))
               trackout2_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in({trackin2[117:113],trackin2[58:0]}), .val_out(trackout2[63:0]));
    pipe_delay #(.STAGES(3), .WIDTH(64))
               trackout3_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in({trackin3[117:113],trackin3[58:0]}), .val_out(trackout3[63:0]));
    pipe_delay #(.STAGES(3), .WIDTH(64))
               trackout4_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in({trackin4[117:113],trackin4[58:0]}), .val_out(trackout4[63:0]));
    pipe_delay #(.STAGES(3), .WIDTH(64))
               trackout5_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in({trackin5[117:113],trackin5[58:0]}), .val_out(trackout5[63:0]));
    pipe_delay #(.STAGES(3), .WIDTH(64))
               trackout6_delay(.pipe_in(), .pipe_out(), .clk(clk),
               .val_in({trackin6[117:113],trackin6[58:0]}), .val_out(trackout6[63:0]));
    
    reg valid_1;
    reg valid_2;
    reg valid_3;
    reg valid_4;
    reg valid_5;
    reg valid_6;
    
    
    initial begin
        read_add_trackin1 = {`MEM_SIZE+3{1'b1}};
        read_add_trackin2 = {`MEM_SIZE+3{1'b1}};
        read_add_trackin3 = {`MEM_SIZE+3{1'b1}};
        read_add_trackin4 = {`MEM_SIZE+3{1'b1}};
        read_add_trackin5 = {`MEM_SIZE+3{1'b1}};
        read_add_trackin6 = {`MEM_SIZE+3{1'b1}};
    end
    
    reg [2:0] BX_pipe;
    reg first_clk_pipe;
    
    wire rst_pipe;
    assign rst_pipe = start[1];     // use the top bit of start as pipelined reset
        
    initial begin
       BX_pipe = 3'b111;
    end
    
    always @(posedge clk) begin
        if (rst_pipe)
            BX_pipe <= 3'b111;
        else begin
            if(start[0]) begin
                BX_pipe <= BX_pipe + 1'b1;
                first_clk_pipe <= 1'b1;
            end
            else begin
                first_clk_pipe <= 1'b0;
            end
        end
        
        if(first_clk_pipe) begin
            read_add_trackin1 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_trackin2 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_trackin3 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_trackin4 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_trackin5 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
            read_add_trackin6 <= {BX_pipe,{`MEM_SIZE{1'b1}}};
        end
        else begin
            if(read_add_trackin1[`MEM_SIZE-1:0] + 1'b1 < numberin1[`MEM_SIZE-1:0]) begin
                read_add_trackin1[`MEM_SIZE-1:0] <= read_add_trackin1[`MEM_SIZE-1:0] + 1'b1;
                valid_1 <= 1'b1;
            end
            else begin
                read_add_trackin1[`MEM_SIZE-1:0] <= read_add_trackin1[`MEM_SIZE-1:0];
                valid_1 <= 1'b0;
                if(read_add_trackin2[`MEM_SIZE-1:0] + 1'b1 < numberin2[`MEM_SIZE-1:0]) begin
                    read_add_trackin2[`MEM_SIZE-1:0] <= read_add_trackin2[`MEM_SIZE-1:0] + 1'b1;
                    valid_2 <= 1'b1;
                end
                else begin
                    read_add_trackin2[`MEM_SIZE-1:0] <= read_add_trackin2[`MEM_SIZE-1:0];
                    valid_2 <= 1'b0;
                    if(read_add_trackin3[`MEM_SIZE-1:0] + 1'b1 < numberin3[`MEM_SIZE-1:0]) begin
                        read_add_trackin3[`MEM_SIZE-1:0] <= read_add_trackin3[`MEM_SIZE-1:0] + 1'b1;
                        valid_3 <= 1'b1;
                    end
                    else begin
                        read_add_trackin3[`MEM_SIZE-1:0] <= read_add_trackin3[`MEM_SIZE-1:0];
                        valid_3 <= 1'b0;
                        if(read_add_trackin4[`MEM_SIZE-1:0] + 1'b1 < numberin4[`MEM_SIZE-1:0]) begin
                            read_add_trackin4[`MEM_SIZE-1:0] <= read_add_trackin4[`MEM_SIZE-1:0] + 1'b1;
                            valid_4 <= 1'b1;
                        end
                        else begin
                            read_add_trackin4[`MEM_SIZE-1:0] <= read_add_trackin4[`MEM_SIZE-1:0];
                            valid_4 <= 1'b0;
                            if(read_add_trackin5[`MEM_SIZE-1:0] + 1'b1 < numberin5[`MEM_SIZE-1:0]) begin
                                read_add_trackin5[`MEM_SIZE-1:0] <= read_add_trackin5[`MEM_SIZE-1:0] + 1'b1;
                                valid_5 <= 1'b1;
                            end
                            else begin
                                read_add_trackin5[`MEM_SIZE-1:0] <= read_add_trackin5[`MEM_SIZE-1:0];
                                valid_5 <= 1'b0;
                                if(read_add_trackin6[`MEM_SIZE-1:0] + 1'b1 < numberin6[`MEM_SIZE-1:0]) begin
                                    read_add_trackin6[`MEM_SIZE-1:0] <= read_add_trackin6[`MEM_SIZE-1:0] + 1'b1;
                                    valid_6 <= 1'b1;
                                end
                                else begin
                                    read_add_trackin6[`MEM_SIZE-1:0] <= read_add_trackin6[`MEM_SIZE-1:0];
                                    valid_6 <= 1'b0;
                                end
                            end
                        end
                    end
                end
            end
        end
    end    

    
    
// Initialize structures
                
    // Parameters
    parameter[5:0] nMaxTracks = 6'd60; // Maximum number of tracks PD will attempt to run over
    parameter[3:0] nSeed = 4'd6; // Number of seeding layers
    parameter SCOPE = "D3D6";
    
    // States
    localparam[2:0] IDLE    = 3'd0,
                    START   = 3'd1,
                    PARSE   = 3'd2,
                    BUFFER1 = 3'd3,
                    BUFFER2 = 3'd4,
                    RUN     = 3'd5,
                    FINISH  = 3'd6;
                    
    reg[3:0] removalState = IDLE;
       
    // Stub id storage for removal
    reg[53:0] regTracks[nMaxTracks-1:0]; // Consolidating the tracks into one reg for inputs to dupTag during removal.
    
    // Parsing variables
    wire[4:0] numberin[5:0]; // Number of tracks by seed
    reg[5:0] nTracks = 6'd0; // Total number of filled tracks.
    parameter[3:0] trackSeed[nMaxTracks-1:0] = '{5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0};
    reg[6:0] markerTrack[4:0]; // The address of the last track in each seeding layer, signalling to skip primary tracks to the next seeding layer

    // Variables to keep track of the primary track number and secondary track number.
    reg[5:0] pLoad = 6'd0; // Index of primary track to load 
    reg[5:0] trkLoad = 6'd0; // Address of primary track to load
    wire[5:0] pNext; // Index of next primary track whose comparisons will be available (for deciding which state to go to)
    wire[5:0] p; // Index of primary track whose comparisons are currently available
    wire[5:0] trk; // Address of primary track whose comparisons are currently available
    wire[5:0] trkNext; // Address of next primary track whose comparisons will be available
    wire[5:0] trkLast; // Address of the previous primary track
        pipe_delay #(.STAGES(1), .WIDTH(6))
            pNext_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(pLoad), .val_out(pNext));
        pipe_delay #(.STAGES(2), .WIDTH(6))
            p_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(pLoad), .val_out(p));
        pipe_delay #(.STAGES(1), .WIDTH(6))
            trkNext_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(trkLoad), .val_out(trkNext));
        pipe_delay #(.STAGES(2), .WIDTH(6))
            trk_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(trkLoad), .val_out(trk));
        pipe_delay #(.STAGES(3), .WIDTH(6))
            trkLast_pipe(.pipe_in(), .pipe_out(), .clk(clk), .val_in(trkLoad), .val_out(trkLast));
    
    // Variables for dupTag input
    reg[53:0] primTrack; // Track stub indices for input to dupTag modules. Needed to reduce net latency
    
    // Duplicate Flags (1=duplicate, 0=good)
    reg dupFlag[nMaxTracks-1:0]; // Duplicate flags by global track number for removal
    wire[nMaxTracks-1:1] primaryDupFlagOut; // Primary duplicate flags coming out of comparison modules
    wire secondaryDupFlagOut[nMaxTracks-1:1]; // Duplicate flags coming out of comparison modules
    
    reg valid_out[5:0]; // Output flags (1=good, 0=duplicate); Connected to actual outputs
    assign valid_out_1 = valid_out[0];
    assign valid_out_2 = valid_out[1];
    assign valid_out_3 = valid_out[2];
    assign valid_out_4 = valid_out[3];
    assign valid_out_5 = valid_out[4];
    assign valid_out_6 = valid_out[5];

    // Generic variables and iterators (for loops)
    reg[5:0] m = 6'd0; // loops over nMaxTracks
    reg[5:0] n = 6'd0; // loops over nMaxTracks
    reg[3:0] s = 4'd0; // loops over nSeeds
    reg[3:0] t = 4'd0; // loops over nSeeds
    
    // Track comparison modules between a primary track and the set of secondary tracks
    generate
        genvar trk1;
        for(trk1=1; trk1<nMaxTracks; trk1=trk1+1) begin
            DupTag Compare(.state(removalState),.clk(clk),.track1dupOut(primaryDupFlagOut[trk1:trk1]),.track2dupOut(secondaryDupFlagOut[trk1]),.track1dupIn(dupFlag[trkNext] || (|pNext && secondaryDupFlagOut[trkNext])),
                .track1Seed(trackSeed[trkLoad]),.track2Seed(trackSeed[trk1]),.track1(primTrack),.track2(regTracks[trk1]));
                // Track 2 needs to start with 1 since regTracks[0] will always be the first primary. Don't need a comparison with self!
        end
    endgenerate
    
    generate
        // Wire up track counts according to scope
        case(SCOPE)
            "D3","D3D4": begin
                assign numberin[0] = numberin1;
                assign numberin[1] = numberin2;
                assign numberin[2] = numberin3;
                assign numberin[3] = 5'd0;
                assign numberin[4] = 5'd0;
                assign numberin[5] = 5'd0;
            end
            "D5","D5D6": begin
                assign numberin[0] = 5'd0;
                assign numberin[1] = 5'd0;
                assign numberin[2] = 5'd0;
                assign numberin[3] = numberin4;
                assign numberin[4] = numberin5;
                assign numberin[5] = 5'd0;
            end
            "D4D6","D3D6": begin
                assign numberin[0] = numberin1;
                assign numberin[1] = numberin2;
                assign numberin[2] = numberin3;
                assign numberin[3] = numberin4;
                assign numberin[4] = numberin5;
                assign numberin[5] = numberin6;
            end 
        endcase
    
        // Save stub ID's according to scope
        case(SCOPE)
            "D3","D3D4": begin
                always @(posedge clk) begin
                    if(removalState==PARSE) begin
                        for(n=6'd0; n<6'd10; n=n+1) begin
                            regTracks[n]    <= index_in1[n];
                            regTracks[n+10] <= index_in2[n];
                            regTracks[n+20] <= index_in3[n];
                            regTracks[n+30] <= {54{1'b1}};
                            regTracks[n+40] <= {54{1'b1}};
                            regTracks[n+50] <= {54{1'b1}};
                        end
                    end
                end
            end
                    
            "D5","D5D6": begin
                always @(posedge clk) begin
                    if(removalState==PARSE) begin
                        for(n=6'd0; n<6'd10; n=n+1) begin
                            regTracks[n]    <= {54{1'b1}};
                            regTracks[n+10] <= {54{1'b1}};
                            regTracks[n+20] <= {54{1'b1}};
                            regTracks[n+30] <= index_in4[n];
                            regTracks[n+40] <= index_in5[n];
                            regTracks[n+50] <= {54{1'b1}};
                        end
                    end
                end
            end
                    
            "D4D6","D3D6": begin
                always @(posedge clk) begin
                    if(removalState==PARSE) begin
                        for(n=6'd0; n<6'd10; n=n+1) begin
                            regTracks[n]    <= index_in1[n];
                            regTracks[n+10] <= index_in2[n];
                            regTracks[n+20] <= index_in3[n];
                            regTracks[n+30] <= index_in4[n];
                            regTracks[n+40] <= index_in5[n];
                            regTracks[n+50] <= index_in6[n];
                        end
                    end
                end
            end
        endcase
    endgenerate

    // Execution code
    
    always @(posedge clk) begin
        // Event triggers
        if(start) begin
            removalState <= START;
        end else begin

            // Duplicate Removal code
            case(removalState)
            
                START: begin // Start; Reset variables, wait for stub ID's and count to come in
                    // Reset variables
                    pLoad <= 6'd0;
                    trkLoad <= 6'd0;
                    for(m=6'd0; m<nMaxTracks; m=m+1) begin
                        dupFlag[m] <= 1'b0;
                    end
                    removalState <= PARSE;
                end
                
                PARSE: begin // Buffer; Save stub id's, set first primTrack
                
                    // Stub ID's saved in generate block above.

                    // Set first primary track
                    if(numberin[0] != 0) begin
                        primTrack <= index_in1[0];
                        trkLoad <= 6'd0;
                    end else
                    if(numberin[1] != 0) begin
                        primTrack <= index_in2[0];
                        trkLoad <= 6'd10;
                    end else
                    if(numberin[2] != 0) begin
                        primTrack <= index_in3[0];
                        trkLoad <= 6'd20;
                    end else
                    if(numberin[3] != 0) begin
                        primTrack <= index_in4[0];
                        trkLoad <= 6'd30;
                    end else
                    if(numberin[4] != 0) begin
                        primTrack <= index_in5[0];
                        trkLoad <= 6'd40;
                    end else
                    if(numberin[5] != 0) begin
                        primTrack <= index_in6[0];
                        trkLoad <= 6'd50;
                    end

                    // Figure out when the primary track address needs to skip empty tracks
                    markerTrack[0] <= numberin[0]-1;
                    markerTrack[1] <= numberin[0]+numberin[1]-1;
                    markerTrack[2] <= numberin[0]+numberin[1]+numberin[2]-1;
                    markerTrack[3] <= numberin[0]+numberin[1]+numberin[2]+numberin[3]-1;
                    markerTrack[4] <= numberin[0]+numberin[1]+numberin[2]+numberin[3]+numberin[4]-1;

                    // Count the total number of tracks
                    nTracks <= numberin[0]+numberin[1]+numberin[2]+numberin[3]+numberin[4]+numberin[5];
                    
                    removalState <= BUFFER1;
                end
                
                BUFFER1: begin // Buffer; First DupTag output variables are set
                    // If no tracks, IDLE. Otherwise, load next primary track
                    case(nTracks) // If no tracks, just go straight to IDLE
                        0: removalState <= IDLE;
                        1: removalState <= BUFFER2;
                        default: begin
                            nextPrimary;
                            pLoad <= pLoad+1;
                            removalState <= BUFFER2;
                        end
                    endcase
                end
                
                BUFFER2: begin // Buffer; First DupTag output variables are set
                    // If no tracks, IDLE. Otherwise, load next primary track
                    case(nTracks)
                        1: removalState <= FINISH;
                        default: nextState;
                    endcase
                end
                
                RUN: begin // Save; DupTag modules have their outputs updated
                    // Save duplicate tags
                    for(m=6'd1; m<nMaxTracks; m=m+1) begin
                        if(m>trk) begin // Only save relevant comparisons
                            dupFlag[m] <= secondaryDupFlagOut[m];
                        end
                    end
                    dupFlag[trk] <= |(primaryDupFlagOut>>trk); // Bitshift away irrelevant modules (primary and down)
                    valid_out[trackSeed[trkLast]] <= 1'b0;
                    valid_out[trackSeed[trk]] <= ~|(primaryDupFlagOut>>trk);

                    // Figure out next state & primary track
                    nextState;
                end

                FINISH: begin // Save duplicate tags, but don't load new tracks
                    // Save duplicate tags
                    for(m=6'd1; m<nMaxTracks; m=m+1) begin
                        if(m>trk) begin // Only save relevant comparisons
                            dupFlag[m] <= secondaryDupFlagOut[m];
                        end
                    end
                    dupFlag[trk] <= |(primaryDupFlagOut>>trk); // Bitshift away irrelevant modules
                    valid_out[trackSeed[trkLast]] <= 1'b0;
                    valid_out[trackSeed[trk]] <= ~|(primaryDupFlagOut>>trk); // Technically, this is the only line that is needed for FINISH
                    nextState;
                end

                default: begin // Includes IDLE
                    for(s=4'd0;s<nSeed;s=s+1) begin
                        valid_out[s] <= 1'b0;
                    end
                    removalState <= removalState;
                end
                
            endcase
        end
    end

    task nextPrimary;
        begin
            // Figure out next track to load
            if(pLoad==markerTrack[4]) begin
                trkLoad <= 50;
                primTrack <= regTracks[50];
            end else if(pLoad==markerTrack[3]) begin
                trkLoad <= 40;
                primTrack <= regTracks[40];
            end else if(pLoad==markerTrack[2]) begin
                trkLoad <= 30;
                primTrack <= regTracks[30];
            end else if(pLoad==markerTrack[1]) begin
                trkLoad <= 20;
                primTrack <= regTracks[20];
            end else if(pLoad==markerTrack[0]) begin
                trkLoad <= 10;
                primTrack <= regTracks[10];
            end else begin
                trkLoad <= trkLoad+1;
                primTrack <= regTracks[trkLoad+1];
            end
        end
    endtask
    
    task nextState; // Check which state to go to
        if(pLoad >= nTracks-1) begin // If we are/have loaded the last track, stop loading new tracks
            pLoad <= pLoad;
            if(p < nTracks-1) begin // Not currently outputting the last track
                removalState <= FINISH;
            end else begin // Currently outputting the last track
                removalState <= IDLE;
            end
        end else begin // Still more tracks to load
            nextPrimary;
            pLoad <= pLoad+1;
            removalState <= RUN;
        end
    endtask


endmodule