`timescale 1ns / 1ps
`include "constants.vh"

module tracklet_processing #(
parameter INPUT_TYPE1  = "StubsByLayer",
parameter INPUT_SIZE1  = 36,
parameter INPUT_TYPE2  = "StubsByLayer",
parameter INPUT_SIZE2  = 36,
parameter OUTPUT_TYPE1 = "AllStubs",
parameter OUTPUT_SIZE1 = 36,
parameter OUTPUT_TYPE2 = "AllStubs",
parameter OUTPUT_SIZE2 = 36,
parameter OUTPUT_NUM1  = 3,
parameter OUTPUT_NUM2  = 3,
parameter UUT_NAME     = "Custom_UUT"
)(
    input clk, 
    input reset,
    input en_proc,
    input [2:0] BX,
    input first_clk,
    input not_first_clk,
    // inputs
    input [INPUT_SIZE1-1:0] input1_1,
    input [INPUT_SIZE1-1:0] input1_2,
    input [INPUT_SIZE1-1:0] input1_3,
    input [INPUT_SIZE2-1:0] input2_1,
    input [INPUT_SIZE2-1:0] input2_2,
    input [INPUT_SIZE2-1:0] input2_3
    // outputs
);

    reg [5:0] clk_cnt;
    initial clk_cnt = 6'b0;
    
    always @(posedge clk) begin
        if (en_proc) clk_cnt <= clk_cnt + 1'b1;
        else clk_cnt <= 6'b0;
        if (clk_cnt == (`tmux - 1'b1)) clk_cnt <= 6'b0;
    end
   
    // start signals
    wire [1:0] start1; // starts processing text files to prep for writing to mems
    wire [1:0] start2; // starts writing to input memories
    wire [1:0] start3; // starts processing module under test
    wire [1:0] start4; // starts writing to output memories
    wire [1:0] start5_1 [OUTPUT_NUM1-1:0]; // done writing to type1 output memories 
    wire [1:0] start5_2 [OUTPUT_NUM2-1:0]; // done writing to type2 output memories        
    assign start1[1] = reset; // use top bit of start as reset
    assign start1[0] = (clk_cnt == 6'd0 && en_proc);  
    
    // Input wires fed into processing module
    wire wr_en_1_1;
    wire wr_en_1_2;
    wire wr_en_1_3;
    wire wr_en_2_1;
    wire wr_en_2_2;
    wire wr_en_2_3;
    wire [INPUT_SIZE1-1:0] data_tmp_1_1;
    wire [INPUT_SIZE1-1:0] data_tmp_1_2;
    wire [INPUT_SIZE1-1:0] data_tmp_1_3;
    wire [INPUT_SIZE2-1:0] data_tmp_2_1;
    wire [INPUT_SIZE2-1:0] data_tmp_2_2;
    wire [INPUT_SIZE2-1:0] data_tmp_2_3;
    wire [INPUT_SIZE1-1:0] data_in_1_1;
    wire [INPUT_SIZE1-1:0] data_in_1_2;
    wire [INPUT_SIZE1-1:0] data_in_1_3;
    wire [INPUT_SIZE2-1:0] data_in_2_1;
    wire [INPUT_SIZE2-1:0] data_in_2_2;
    wire [INPUT_SIZE2-1:0] data_in_2_3;
        
    // Number of entries in input memories
    wire [5:0] number1_1;
    wire [5:0] number1_2;
    wire [5:0] number1_3;
    wire [5:0] number2_1;
    wire [5:0] number2_2;
    wire [5:0] number2_3;

    //---------------------------------------------------
    // Function to get the correct size of the read_add
    //---------------------------------------------------
    function integer address;
        input [127:0] name;
        begin
            address = `MEM_SIZE;
            if (name=="CustomIn")            address = `ADD_SIZE_Cu;
            if (name=="CustomOut")           address = `ADD_SIZE_Cu;
            if (name=="StubsByLayer")        address = `ADD_SIZE_SL;
            if (name=="AllStubs")            address = `ADD_SIZE_AS;
            if (name=="VMStubs")             address = `ADD_SIZE_VS;
            if (name=="StubPairs")           address = `ADD_SIZE_SP;
            if (name=="TrackletParameters")  address = `ADD_SIZE_TR;
            if (name=="TrackletProjections") address = `ADD_SIZE_TP;
            if (name=="VMProjections")       address = `ADD_SIZE_VP;
            if (name=="AllProj")             address = `ADD_SIZE_AP;
            if (name=="CandidateMatch")      address = `ADD_SIZE_CM;
            if (name=="FullMatch")           address = `ADD_SIZE_FM;
            if (name=="TrackFit")            address = `ADD_SIZE_TF;
        end
    endfunction
    
    // get read_add size
    parameter read_add_type1in  = address(INPUT_TYPE1);
    parameter read_add_type2in  = address(INPUT_TYPE2);
    parameter read_add_type1out = address(OUTPUT_TYPE1); // not really needed
    parameter read_add_type2out = address(OUTPUT_TYPE2); // not really needed
    //always @ (posedge clk) $display("Read address1 width = %d",read_add_type1in);
    //always @ (posedge clk) $display("Read address2 width = %d",read_add_type2in);
    
    wire [read_add_type1in:0] read_1_1;
    wire [read_add_type1in:0] read_1_2;
    wire [read_add_type1in:0] read_1_3;
    wire [read_add_type2in:0] read_2_1;
    wire [read_add_type2in:0] read_2_2; 
    wire [read_add_type2in:0] read_2_3; 
    
    // Output wires from the processing module
    wire [OUTPUT_SIZE1-1:0] data_out_type1[OUTPUT_NUM1-1:0];
    wire [OUTPUT_SIZE2-1:0] data_out_type2[OUTPUT_NUM2-1:0];
    wire valid_out_type1[OUTPUT_NUM1-1:0];
    wire valid_out_type2[OUTPUT_NUM2-1:0];
    // Output wires from final memories -- not actually needed
    wire [OUTPUT_SIZE1-1:0] outputs1 [OUTPUT_NUM1-1:0]; 
    wire [OUTPUT_SIZE2-1:0] outputs2 [OUTPUT_NUM2-1:0];   
    
    //---------------------------------------------------
    // DEVELOPMENT PROCESSING MODULE
    //---------------------------------------------------
    prep_processing #(INPUT_SIZE1,read_add_type1in,INPUT_SIZE2,read_add_type2in,OUTPUT_SIZE1,OUTPUT_SIZE2,UUT_NAME) prep_UUT(
        .clk(clk),
        .reset(reset),
        .en_proc(en_proc),
        .start(start3),
        .done(start4),
        // inputs
        .number_in_1_1(number1_1),
        .number_in_1_2(number1_2),
        .number_in_1_3(number1_3),
        .number_in_2_1(number2_1),
        .number_in_2_2(number2_2),
        .number_in_2_3(number2_3),
        .read_add_1_1(read_1_1),
        .read_add_1_2(read_1_2),
        .read_add_1_3(read_1_3),
        .read_add_2_1(read_2_1),
        .read_add_2_2(read_2_2),
        .read_add_2_3(read_2_3),
        .input_1_1(data_in_1_1),
        .input_1_2(data_in_1_2),
        .input_1_3(data_in_1_3),
        .input_2_1(data_in_2_1),
        .input_2_2(data_in_2_2),
        .input_2_3(data_in_2_3),
        // outputs
        .output_1_1(data_out_type1[0]),
        .output_1_2(data_out_type1[1]),
        .output_1_3(data_out_type1[2]),
        .output_2_1(data_out_type2[0]),
        .output_2_2(data_out_type2[1]),
        .output_2_3(data_out_type2[2]),
        .valid_1_1(valid_out_type1[0]),
        .valid_1_2(valid_out_type1[1]),
        .valid_1_3(valid_out_type1[2]),
        .valid_2_1(valid_out_type2[0]),
        .valid_2_2(valid_out_type2[1]),
        .valid_2_3(valid_out_type2[2])
    );
 
    //---------------------------------------------------
    // Write all inputs to input memories
    //---------------------------------------------------
 
    // makes timing right for writing into mems
    // only first memory (prepmem1_1) makes the done signal for these modules
    prep_mem #(INPUT_SIZE1) prepmem1_1(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start1), .done(start2),
        .data_in(input1_1), .data_out(data_tmp_1_1), .wr_en(wr_en_1_1));
    
    prep_mem #(INPUT_SIZE1) prepmem1_2(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start1), .done(),
        .data_in(input1_2), .data_out(data_tmp_1_2), .wr_en(wr_en_1_2));
    
    prep_mem #(INPUT_SIZE1) prepmem1_3(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start1), .done(),
        .data_in(input1_3), .data_out(data_tmp_1_3), .wr_en(wr_en_1_3));
    
    prep_mem #(INPUT_SIZE2) prepmem2_1(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start1), .done(),
        .data_in(input2_1), .data_out(data_tmp_2_1), .wr_en(wr_en_2_1));    
    
    prep_mem #(INPUT_SIZE2) prepmem2_2(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start1), .done(),
        .data_in(input2_2), .data_out(data_tmp_2_2), .wr_en(wr_en_2_2));    
    
    prep_mem #(INPUT_SIZE2) prepmem2_3(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start1), .done(),
        .data_in(input2_3), .data_out(data_tmp_2_3), .wr_en(wr_en_2_3));        
 
    //---------------------------------------------------
    // CHOOSE WHICH MEMORY YOU WANT! (Can do the same for output memories) 
    // ----  Use format:
    // ----  setup_mem_type #(size, "Name", read_add_size) ...
    //---------------------------------------------------    
    // Additional optional outputs (see setup_mem_type for sizes etc.):
    // -- For AS mem: read_add_MC, data_out_MC
    // -- For TF mem: index_out
    //---------------------------------------------------           

    setup_mem_type #(INPUT_SIZE1,INPUT_TYPE1,read_add_type1in) setup1_1in(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start2), .done(start3),
        .data_in(data_tmp_1_1), .enable(wr_en_1_1), .number_out(number1_1),
        .read_add(read_1_1), .data_out(data_in_1_1)
    );
    
    setup_mem_type #(INPUT_SIZE1,INPUT_TYPE1,read_add_type1in) setup1_2in(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start2), .done(),
        .data_in(data_tmp_1_2), .enable(wr_en_1_2), .number_out(number1_2),
        .read_add(read_1_2), .data_out(data_in_1_2)
    );
    
    setup_mem_type #(INPUT_SIZE1,INPUT_TYPE1,read_add_type1in) setup1_3in(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start2), .done(),
        .data_in(data_tmp_1_3), .enable(wr_en_1_3), .number_out(number1_3),
        .read_add(read_1_3), .data_out(data_in_1_3)    
    );
    
    setup_mem_type #(INPUT_SIZE2,INPUT_TYPE2,read_add_type2in) setup2_1in(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start2), .done(),
        .data_in(data_tmp_2_1), .enable(wr_en_2_1), .number_out(number2_1),
        .read_add(read_2_1), .data_out(data_in_2_1)    
    );

    setup_mem_type #(INPUT_SIZE2,INPUT_TYPE2,read_add_type2in) setup2_2in(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start2), .done(),
        .data_in(data_tmp_2_2), .enable(wr_en_2_2), .number_out(number2_2),
        .read_add(read_2_2), .data_out(data_in_2_2)    
    );
    
    setup_mem_type #(INPUT_SIZE2,INPUT_TYPE2,read_add_type2in) setup2_3in(
        .clk(clk), .reset(reset), .en_proc(en_proc), .start(start2), .done(),
        .data_in(data_tmp_2_3), .enable(wr_en_2_3), .number_out(number2_3),
        .read_add(read_2_3), .data_out(data_in_2_3)    
    );
            
    //---------------------------------------------------
    // Write all outputs to output memories
    //---------------------------------------------------     
    genvar n1,n2;
    generate
        for (n1 = 0; n1 < OUTPUT_NUM1; n1 = n1 + 1'b1) begin: gen_outmem1
            setup_mem_type #(OUTPUT_SIZE1,OUTPUT_TYPE1) memout(
                .clk(clk), .reset(reset), .en_proc(en_proc), .start(start4), .done(start5_1[n1]),
                .data_in(data_out_type1[n1]), .enable(valid_out_type1[n1]), .data_out(outputs1[n1])
            );
        end
    endgenerate
    generate
        for (n2 = 0; n2 < OUTPUT_NUM2; n2 = n2 + 1'b1) begin: gen_outmem2
            setup_mem_type #(OUTPUT_SIZE2,OUTPUT_TYPE2) memout(
                .clk(clk), .reset(reset), .en_proc(en_proc), .start(start4), .done(start5_2[n2]),
                .data_in(data_out_type2[n2]), .enable(valid_out_type2[n2]), .data_out(outputs2[n2])
            );
        end
    endgenerate
    
endmodule