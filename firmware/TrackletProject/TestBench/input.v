`timescale 1 ns / 1 ps

//---------------------------------------------------
// Get inputs from text files
//---------------------------------------------------

module input_sim #(
parameter INPUT_SIZE1 = 36,
parameter INPUT_SIZE2 = 36,
parameter USER = "/home/mzientek/firmware/TrackletProject/TestBench/InFiles/"
)(
    input clk,
    input reset,
    input BC0,
    // outputs w/ size = INPUT_SIZE1
    output reg [INPUT_SIZE1-1:0] input_1_1,
    output reg [INPUT_SIZE1-1:0] input_1_2,
    output reg [INPUT_SIZE1-1:0] input_1_3,
    // outputs w/ size = INPUT_SIZE2
    output reg [INPUT_SIZE2-1:0] input_2_1,
    output reg [INPUT_SIZE2-1:0] input_2_2,
    output reg [INPUT_SIZE2-1:0] input_2_3
);

    //---------------------------------------------------
    // Inputs
    //---------------------------------------------------
    `define NULL 0
    `define SIZE INPUT_SIZE

    // file handlers
    integer fdi1, fdi2, fdi3, fdi4, fdi5, fdi6;
    integer val1, val2, val3, val4, val5, val6;
    integer dum1, dum2, dum3, dum4, dum5, dum6;
    reg [50*20:1] str1, str2, str3, str4, str5, str6;
    
    // these objects are currently not used, but are extra info from the memories
    reg [127:0] bx_1, bx_2, bx_3, bx_4, bx_5, bx_6;
    reg [127:0] event_1, event_2, event_3, event_4, event_5, event_6;
    reg [127:0] num_1, num_2, num_3, num_4, num_5, num_6;
    
    initial begin // start processing
   
        // initialize inputs
        #2  
        input_1_1 = 128'h1; 
        input_1_2 = 128'h1; 
        input_1_3 = 128'h1; 
        input_2_1 = 128'h1; 
        input_2_2 = 128'h1; 
        input_2_3 = 128'h1;
        #98 
        input_1_1 = 128'h0; 
        input_1_2 = 128'h0; 
        input_1_3 = 128'h0; 
        input_2_1 = 128'h0; 
        input_2_2 = 128'h0; 
        input_2_3 = 128'h0;
        #310;
        
        // input file handling
        fdi1 = $fopen({USER,"Input_1.dat"},"r");
        fdi2 = $fopen({USER,"Input_2.dat"},"r");
        fdi3 = $fopen({USER,"Input_3.dat"},"r");
        fdi4 = $fopen({USER,"Input_4.dat"},"r");
        fdi5 = $fopen({USER,"Input_5.dat"},"r");
        fdi6 = $fopen({USER,"Input_6.dat"},"r");
        
        if (fdi1 == `NULL) $display("Warning ... Input File 1_1 was NULL");
        if (fdi2 == `NULL) $display("Warning ... Input File 1_2 was NULL");
        if (fdi3 == `NULL) $display("Warning ... Input File 1_3 was NULL");
        if (fdi4 == `NULL) $display("Warning ... Input File 2_1 was NULL");
        if (fdi5 == `NULL) $display("Warning ... Input File 2_2 was NULL");
        if (fdi6 == `NULL) $display("Warning ... Input File 2_3 was NULL");
        
        #900
        
        while (!$feof(fdi1)) begin
            val1 = $fgets(str1, fdi1);
            dum1 = $sscanf(str1, "%x %x %x %b", bx_1, event_1, num_1, input_1_1);
            
            val2 = $fgets(str2, fdi2);
            dum2 = $sscanf(str2, "%x %x %x %b", bx_2, event_2, num_2, input_1_2);
            
            val3 = $fgets(str3, fdi3);
            dum3 = $sscanf(str3, "%x %x %x %b", bx_3, event_3, num_3, input_1_3);
            
            val4 = $fgets(str4, fdi4);
            dum4 = $sscanf(str4, "%x %x %x %b", bx_4, event_4, num_4, input_2_1); 
                       
            val5 = $fgets(str5, fdi5);
            dum5 = $sscanf(str5, "%x %x %x %b", bx_5, event_5, num_5, input_2_2);   
                     
            val6 = $fgets(str6, fdi6);
            dum6 = $sscanf(str6, "%x %x %x %b", bx_6, event_6, num_6, input_2_3);
            #5;
        end
        
        // go signal
        #2 input_1_1 = 128'hACE;
    
    end
    
endmodule