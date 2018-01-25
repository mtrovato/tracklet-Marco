`timescale 1ns / 1ps
`include "constants.vh"

module setup_mem_type #(
    parameter MEM_WIDTH = 16,
    parameter MEM_TYPE = "StubsByLayer",
    parameter ADD_SIZE = `MEM_SIZE
)(
    input clk,
    input reset,
    input en_proc,
    input [1:0] start,
    output [1:0] done,
    
    input  enable,
    output [5:0] number_out,
    input  [ADD_SIZE:0] read_add,
    input  [MEM_WIDTH-1:0] data_in,
    output [MEM_WIDTH-1:0] data_out,
    
    input [`MEM_SIZE+4:0] read_add_MC,  // only for AS mem
    output [MEM_WIDTH-1:0] data_out_MC, // only for AS mem
    output [53:0] index_out [`tmux-1:0] // only for TF mem
);
        
    //---------------------------------------------------
    // Use a custom memory
    //---------------------------------------------------
    generate
        if (MEM_TYPE=="CustomIn") begin: CustomIn
            input_mem #(MEM_WIDTH) mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done), 
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    
    generate
       if (MEM_TYPE=="CustomOut") begin: CustomOut
            output_mem #(MEM_WIDTH) mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done), 
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    
    //---------------------------------------------------
    // Use the default memories from main SourceCode
    // these have fixed sizes for input/output data
    //---------------------------------------------------
    generate
        if (MEM_TYPE=="StubsByLayer") begin: SL
            StubsByLayer mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="AllStubs") begin: AS
            AllStubs mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .read_add(read_add), .data_out(data_out), 
            .read_add_MC(read_add_MC), .data_out_MC(data_out_MC)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="VMStubs") begin: VS
            VMStubs mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="StubPairs") begin: SP
            StubPairs mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="TrackletParameters") begin: TR
            TrackletParameters mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="TrackletProjections") begin: TP
            TrackletProjections mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="VMProjections") begin: VP
            VMProjections mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="AllProj") begin: AP
            AllProj mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="CandidateMatch") begin: CM
            CandidateMatch mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="FullMatch") begin: FM
            FullMatch mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .number_out(number_out), .read_add(read_add), .data_out(data_out)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="TrackFit") begin: TF
            TrackFit mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .read_add(read_add), .data_out(data_out), .index_out(TF_index)
            );
        end
    endgenerate
    generate
        if (MEM_TYPE=="CleanTrack") begin: CT
            CleanTrack mem( .clk(clk), .reset(reset), .en_proc(en_proc), .start(start), .done(done),
            .data_in(data_in), .enable(enable), .data_out(data_out)
            );
        end
    endgenerate
    
endmodule