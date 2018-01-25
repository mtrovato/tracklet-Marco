`timescale 1ns / 1ps 

//---------------------------------------------------
//------------------- SUMMARY -----------------------
//---------------------------------------------------
//
// This test bench is setup to take input files, fill these into input memories,
// and then call these inputs from the memories into the processing module to be 
// tested (UUT_PROCESS). The outputs of the processing module are sent to output
// memories which are also printed to output text files.
//
//---------------------------------------------------
//-------------- PARAMETERS TO SET ------------------
//---------------------------------------------------
//
//      USER         : With the path to your directory
//      *_TYPE       : Type of memory to use (see below for allowed types)
//      *_SIZE       : Width of memories of each type
//      *_NUM        : Number of each type
//
//---------------------------------------------------
//---------------- WHAT TO MODIFY -------------------
//---------------------------------------------------
//
// processingmodule.v   : Use this as a development processing module
// or use another, by changing NAME_UUT and adding your UUT to the project 
// Use prep_processing.v as a interface between your new module & test bench framework
// The outputs should be the data_out to be sent to output memory
// in time with a valid signal to write to the output memory
//
// You will have to manually add additional wires/reg 
// for adding more inputs/outputs -- but should be easy to follow examples here
//
//---------------------------------------------------

module simulation( );
    
    //------------ PARAMETERS TO SET --------------------
    parameter USER = "/home/mzientek/firmware/TrackletProject/TestBench/";
    // Parameters for Inputs
    parameter INPUT_TYPE1     = "StubsByLayer";
    parameter NUM_INPUT_TYPE1 = 3;
    parameter INPUT_SIZE1     = 36;
    parameter INPUT_TYPE2     = "CustomIn";
    parameter NUM_INPUT_TYPE2 = 3;
    parameter INPUT_SIZE2     = 36;
    // Parameters for Outputs
    parameter OUTPUT_TYPE1    = "AllStubs";
    parameter OUTPUT_NUM1     = 3;
    parameter OUTPUT_SIZE1    = 36;
    parameter OUTPUT_TYPE2    = "CustomOut";
    parameter OUTPUT_NUM2     = 3;
    parameter OUTPUT_SIZE2    = 36;
    // Parameter for which UUT wanted (only Custom_UUT is defined currently)
    parameter NAME_UUT        = "Custom_UUT";
    //---------------------------------------------------
    //---------------------------------------------------
    // Allowed Input/Output "TYPES" :
    //      CustomIn   -- EXAMPLE MEMORY IN very similar to StubsByLayer
    //      CustomOut  -- EXAMPLE MEMORY OUT
    //      StubsByLayer
    //      AllStubs   -- NOTE: Additional input: read_add_MC, output: data_out_MC
    //      VMStubs
    //      StubPairs
    //      TrackletParameters
    //      TrackletProjections
    //      VMProjections
    //      AllProj
    //      CandidateMatch
    //      FullMatch
    //      TrackFit   -- NOTE: Additional output: index_out
    //      CleanTrack -- NOTE: Not actually a mem (don't use it for input)
    //---------------------------------------------------
    //---------------------------------------------------
    // NOTES: 
    // 1) If you want to use any of the additional inputs/outputs mentioned, you will have to add them to tracklet_processing
    // 2) "SIZE" variables should match the sizes of the memories. I.e. StubsByLayer requires 36 bits, so put param INPUT_SIZE1 = 36.   
    //    The size will not overwrite the size in the memories that are carried over from the main project
    //---------------------------------------------------
    
    
    // Inputs
    reg clk;
    reg BC0;
    reg reset;
    
    // Default setup: 
    // -- 3 inputs w/ size INPUT_SIZE1   
    // -- 3 inputs w/ size INPUT_SIZE2 
    wire [INPUT_SIZE1-1:0] input1_1;
    wire [INPUT_SIZE1-1:0] input1_2;
    wire [INPUT_SIZE1-1:0] input1_3;
    wire [INPUT_SIZE2-1:0] input2_1;
    wire [INPUT_SIZE2-1:0] input2_2;
    wire [INPUT_SIZE2-1:0] input2_3;

    //---------------------------------------------------
    // Initialize inputs
    //---------------------------------------------------

    initial begin
        reset = 0;
        clk   = 1;
        BC0   = 0;
        #100; // wait 100ns for global reset to finish
    end
    
    initial begin
        reset = 0;
        clk   = 1;
        BC0   = 0;
        #100; // wait 100ns for global reset to finish
    end
    
    //---------------------------------------------------    
    // Add stimulus here
    //---------------------------------------------------

    always begin // make clock
        #2.5 clk = ~clk; // 250 MHz
    end
    
    always begin // orbit clock
        #106920 BC0 = ~BC0; // Fake orbit clock: 3564*6 (clk) * 5 ns/clk
        #2.5 BC0 = ~BC0;
    end

    always begin // reset
        #110
        reset = 1'b1;
        #10 
        reset = 1'b0;
    end
    
    //---------------------------------------------------
    // Get Inputs from text files
    //---------------------------------------------------
    input_sim #(INPUT_SIZE1,INPUT_SIZE2,{USER,"InFiles/"}) simulate_inputs(
        .clk(clk),
        .reset(reset),
        .BC0(BC0),
        .input_1_1(input1_1),
        .input_1_2(input1_2),
        .input_1_3(input1_3),
        .input_2_1(input2_1),
        .input_2_2(input2_2),
        .input_2_3(input2_3)
    );

    //---------------------------------------------------
    // Run main processing
    //---------------------------------------------------  
    top_process #(INPUT_TYPE1,INPUT_SIZE1,INPUT_TYPE2,INPUT_SIZE2,OUTPUT_TYPE1,OUTPUT_SIZE1,OUTPUT_TYPE2,OUTPUT_SIZE2,OUTPUT_NUM1,OUTPUT_NUM2,NAME_UUT) 
    top_process(    
        .proc_clk(clk),
        .io_clk(clk),
        .reset(BC0),
        .input1_1(input1_1),
        .input1_2(input1_2),
        .input1_3(input1_3),
        .input2_1(input2_1),
        .input2_2(input2_2),
        .input2_3(input2_3)
    );
    
    //---------------------------------------------------
    // Write outputs to text files
    //---------------------------------------------------    
    genvar n1,n2;
    generate
        for (n1=0; n1 < OUTPUT_NUM1; n1 = n1 + 1) begin
            output_sim #(n1+1,1,OUTPUT_TYPE1,{USER,"OutFiles/"}) simulate_outputs(
                .clk(clk),
                .reset(reset),
                .BC0(BC0)
            );
        end
    endgenerate
    generate
        for (n2=0; n2 < OUTPUT_NUM2; n2 = n2 + 1) begin
            output_sim #(n2+1,2,OUTPUT_TYPE2,{USER,"OutFiles/"}) simulate_outputs(
                .clk(clk),
                .reset(reset),
                .BC0(BC0)
            );
        end
    endgenerate    

endmodule