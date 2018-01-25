`timescale 1ns / 1ps                                                                                                   
                                                                                                                       
////////////////////////////////////////////////////////////////////////////////                                       
// Company:                                                                                                            
// Engineer:                                                                                                           
//                                                                                                                     
// Create Date:   09:47:38 08/12/2013                                                                                  
// Design Name:   verilog_trigger_top                                                                                  
// Module Name:   C:/USER_LOCAL/crs/CMS_trigger/Xilinx/glib/prj/sim1/verilog_trigger_top_test1.v                       
// Project Name:  sim1                                                                                                 
// Target Device:                                                                                                      
// Tool versions:                                                                                                      
// Description:                                                                                                        
//                                                                                                                     
// Verilog Test Fixture created by ISE for module: verilog_trigger_top                                                 
//                                                                                                                     
// Dependencies:                                                                                                       
//                                                                                                                     
// Revision:                                                                                                           
// Revision 0.01 - File Created                                                                                        
// Additional Comments:                                                                                                
//                                                                                                                     
////////////////////////////////////////////////////////////////////////////////                                       
                                                                                                                       
module verilog_trigger_top_tb;                                                                                      
                                                                                                                       
	// Inputs                                                                                                      
	reg reset;                                                                                                     
	reg cross_clk;                                                                                                 
	reg ipb_clk;                                                                                                   
	reg ipb_strobe;                                                                                                
	reg [31:0] ipb_addr;                                                                                           
	reg ipb_write;                                                                                                 
	reg [31:0] ipb_wdata;                                                                                          
	reg en_proc;                                                                                                   
                                                                                                                       
	// Outputs                                                                                                     
	wire [31:0] ipb_rdata;                                                                                         
	wire ipb_ack;                                                                                                  
	wire ipb_err;                                                                                                  
		                                                                                                       
                                                                                                                       
	// Instantiate the Unit Under Test (UUT)                                                                       
	verilog_trigger_top uut(                                                                                       
		.reset(reset),                                                                                         
		.clk200(cross_clk),                                                                                    
		.en_proc_switch(en_proc),                                                                              
		.ipb_clk(ipb_clk),                                                                                     
		.ipb_strobe(ipb_strobe),                                                                               
		.ipb_addr(ipb_addr),                                                                                   
		.ipb_write(ipb_write),                                                                                 
		.ipb_wdata(ipb_wdata),                                                                                 
		.ipb_rdata(ipb_rdata),                                                                                 
		.ipb_ack(ipb_ack),                                                                                     
		.ipb_err(ipb_err)                                                                                      
	);                                                                                                             
                                                                                                                       
	                                                                                                               
	                                                                                                               
	initial begin                                                                                                  
		// Initialize Inputs                                                                                   
		reset = 0;                                                                                             
		cross_clk = 0;                                                                                         
		en_proc = 0;                                                                                           
		ipb_clk = 0;                                                                                           
		ipb_strobe = 0;                                                                                        
		ipb_addr = 0;                                                                                          
		ipb_write = 0;                                                                                         
		ipb_wdata = 0;                                                                                         
                                                                                                                       
		// Wait 100 ns for global reset to finish                                                              
		#100;                                                                                                  
                                                                                                                       
		// Add stimulus here                                                                                   
                                                                                                                       
	end                                                                                                            
                                                                                                                       
	// Add stimulus here                                                                                           
	// clocks                                                                                                      
	always begin                                                                                                   
		#4 ipb_clk = ~ipb_clk;   // 125 MHz                                                                    
	end                                                                                                            
	always begin                                                                                                   
		//#3 cross_clk = ~cross_clk;   	// 166 MHz                                                             
		#2.5 cross_clk = ~cross_clk;		// 250 MHz                                                     
	end                                                                                                            
                                                                                                                       
	// reset                                                                                                       
	initial begin                                                                                                  
	   #110                                                                                                        
		reset = 1'b1;                                                                                          
	   #10                                                                                                         
		reset = 1'b0;                                                                                          
	end                                                                                                            
                                                                                                                       
	reg [50*20:1] str;
	integer fdi;
	integer fdi1;
	integer fdi2;
	integer fdi3;
	integer fdo;
	integer dummy;
	integer val;
	reg [31:0] data_in0;                                                                                           
	reg [31:0] add_0;                                                                                              
    reg [31:0] data_in1;                                                                                               
    reg [31:0] add_1;                                                                                                  
	// start processing                                                                                            
	initial begin                                                                                                  
        // Write the data                                                                                              
        #310;   
        
// Code commented out below were from disk-vc709 branch 
// Only one input link is used for module testing.      
/*                                                                                                             
        ////////////////////////////////////////                                                                       
        // Input from a file                                                                                           
	// fdi = $fopen("/home/Margaret/MargaretVC709/CombinedVC709/VC709_IPbus_trigger/project_2/data_in.dat","r");   
        fdi = $fopen("D:/bartz/Documents/Tracklet/firmware/TrackletProject/AdditionalFiles/data_in2.dat","r");         
        fdo = $fopen("D:/bartz/Documents/Tracklet/firmware/TrackletProject/AdditionalFiles/data_out2.dat","r");    
                                                                                                                       
//        fdi = $fopen("/home/jchavesb/work/firmware/TrackletProject/AdditionalFiles/data_in2.dat","r");               
        //fdo = $fopen("/mnt/Ddrive/GLIB Firmware/python_scripts/stubs_out.dat","w");                                  
        //fdo2 = $fopen("/mnt/Ddrive/GLIB Firmware/python_scripts/data_out.dat","w");                                  
        //fdo3 = $fopen("/mnt/Ddrive/GLIB Firmware/python_scripts/proj_out.dat","w");                                  
        //fdo4 = $fopen("/mnt/Ddrive/GLIB Firmware/python_scripts/res_out.dat","w");                                   
                                                                                                                       
        # 900                                                                                                          
        #2  ipb_addr = 32'h55000000;                                                                                   
            ipb_wdata=32'h0; ipb_write = 1'b1;                                                                         
        #4  ipb_strobe = 1'b1;                                                                                         
            while (ipb_ack == 1'b0) begin #4; end                                                                      
        #2  ipb_strobe=1'b0; ipb_write=1'b0;                                                                           
                                                                                                                       
        while (!$feof(fdi)) begin                                                                                      
            val = $fgets(str, fdi);                                                                                    
            dummy = $sscanf(str, "%x %x %x %x", data_in0, data_in1, add_0, add_1);                                     
            #2  ipb_addr = add_0;                                                                                      
                ipb_wdata= data_in0; ipb_write = 1'b1;                                                                 
            #4  ipb_strobe = 1'b1;                                                                                     
                while (ipb_ack == 1'b0) begin #4; end                                                                  
            #2  ipb_strobe=1'b0; ipb_write=1'b0;                                                                       
                                                                                                                       
            #2  ipb_addr = add_1;                                                                                      
                ipb_wdata=data_in1; ipb_write = 1'b1;                                                                  
            #4  ipb_strobe = 1'b1;                                                                                     
                while (ipb_ack == 1'b0) begin #4; end                                                                  
            #2  ipb_strobe=1'b0; ipb_write=1'b0;                                                                       
            @(posedge cross_clk);                                                                                      
        end                                                                                                            
        //$fclose(fdo);                                                                                                
        $fclose(fdi);                                                                                                  
                                                                                                                       
//        #2  ipb_addr = 32'h59000000;                                                                                 
//            ipb_wdata= 32'hbabababa; ipb_write = 1'b1;                                                               
//        #4  ipb_strobe = 1'b1;                                                                                       
//            while (ipb_ack == 1'b0) begin #4; end                                                                    
//        #2  ipb_strobe=1'b0; ipb_write=1'b0;                                                                         
*/
                       
        // Three link inputs from emulation files 
        // Input stub files are generated from skim_D3/evlist_skim.txt WITH paddings for 10 events
        // Make sure rd_en is off before writing input stubs to fifo
        #2  ipb_addr = 32'h55000000;                                                                                   
            ipb_wdata=32'h0; ipb_write = 1'b1;                                                                         
        #4  ipb_strobe = 1'b1;                                                                                         
            while (ipb_ack == 1'b0) begin #4; end                                                                      
        #2  ipb_strobe=1'b0; ipb_write=1'b0;   
                               
        // input files for three links  
        // input_link1                                           
        //fdi1 = $fopen("InputStubs_IL1_D3_02_in2.dat","r");
        fdi1 = $fopen("/home/lefeld.17/CMS/L1TrackFirmware/InputFiles/InputStubs_IL1_D3_02_in2.dat","r");
        while (!$feof(fdi1)) begin
            val = $fgets(str, fdi1);
            dummy = $sscanf(str, "%x %x %x %x", data_in0, data_in1, add_0, add_1);
            // lowest 16 bits of data_in0 and lowest 20 bits of data_in1 are meaningful stub inputs
            // Combine the 36-bit stub inputs and split them into two 18-bit pieces. 
            // Write each 18-bit piece into top 18 bits of a 32-bit wide fifo.
            #2  ipb_addr = add_0;
                ipb_wdata= {data_in0[15:0],data_in1[19:18],14'b0}; ipb_write = 1'b1;
            #4  ipb_strobe = 1'b1;
                while (ipb_ack == 1'b0) begin #4; end
            #2  ipb_strobe=1'b0; ipb_write=1'b0;
                                                                                                                       
            #2  ipb_addr = add_1;
                ipb_wdata={data_in1[17:0],14'b0}; ipb_write = 1'b1;
            #4  ipb_strobe = 1'b1;
                while (ipb_ack == 1'b0) begin #4; end
            #2  ipb_strobe=1'b0; ipb_write=1'b0;
            @(posedge cross_clk);
        end                                                                                                                                                                                                           
        $fclose(fdi1);
        
        // input_link2
        fdi2 = $fopen("/home/lefeld.17/CMS/L1TrackFirmware/InputFiles/InputStubs_IL2_D3_02_in2.dat","r");
        while (!$feof(fdi2)) begin
            val = $fgets(str, fdi2);
            dummy = $sscanf(str, "%x %x %x %x", data_in0, data_in1, add_0, add_1);
            #2  ipb_addr = add_0+32'h1000000;
                ipb_wdata= {data_in0[15:0],data_in1[19:18],14'b0}; ipb_write = 1'b1;
            #4  ipb_strobe = 1'b1;
                while (ipb_ack == 1'b0) begin #4; end
            #2  ipb_strobe=1'b0; ipb_write=1'b0;
                                                                                                                       
            #2  ipb_addr = add_1+32'h1000000;
                ipb_wdata={data_in1[17:0],14'b0}; ipb_write = 1'b1;
            #4  ipb_strobe = 1'b1;
                while (ipb_ack == 1'b0) begin #4; end
            #2  ipb_strobe=1'b0; ipb_write=1'b0;
            @(posedge cross_clk);
        end                                                                                                                                                                                                           
        $fclose(fdi2);
        
        // input_link3
        fdi3 = $fopen("/home/lefeld.17/CMS/L1TrackFirmware/InputFiles/InputStubs_IL3_D3_02_in2.dat","r");
        while (!$feof(fdi3)) begin
            val = $fgets(str, fdi3);
            dummy = $sscanf(str, "%x %x %x %x", data_in0, data_in1, add_0, add_1);
            #2  ipb_addr = add_0+32'h2000000;
                ipb_wdata= {data_in0[15:0],data_in1[19:18],14'b0}; ipb_write = 1'b1;
            #4  ipb_strobe = 1'b1;
                while (ipb_ack == 1'b0) begin #4; end
            #2  ipb_strobe=1'b0; ipb_write=1'b0;
                                                                                                                       
            #2  ipb_addr = add_1+32'h2000000;
                ipb_wdata={data_in1[17:0],14'b0}; ipb_write = 1'b1;
            #4  ipb_strobe = 1'b1;
                while (ipb_ack == 1'b0) begin #4; end
            #2  ipb_strobe=1'b0; ipb_write=1'b0;
            @(posedge cross_clk);
        end
        $fclose(fdi3);
                                                                                                                       
        //////////////////////////////////////////////////////////////////////////////                                 
		                                                                                                       
        #10	en_proc = 1'b1;
        
        // Turn on fifo rd_en
        #2  ipb_addr = 32'h55000000;
            ipb_wdata=32'h1; ipb_write = 1'b1;
        #4  ipb_strobe = 1'b1;
            while (ipb_ack == 1'b0) begin #4; end
        #2  ipb_strobe=1'b0; ipb_write=1'b0;
                                                                                                                       
        #1950;
//        #2  ipb_addr = 32'h5d00000e;                                                                                 
//            ipb_wdata=32'h1; ipb_write = 1'b1;                                                                       
//        #4  ipb_strobe = 1'b1;                                                                                       
//            while (ipb_ack == 1'b0) begin #4; end                                                                    
//        #2  ipb_strobe=1'b0; ipb_write=1'b0;                                                                         
              
//        // Output                                                                                                               
//        while (!$feof(fdo)) begin                                                                                      
//            val = $fgets(str, fdo);                                                                                            
//            dummy = $sscanf(str, "%x", add_0);                                                                    
//            #2  ipb_addr = add_0;                                                                                              
//                ipb_wdata= data_in0; ipb_write = 1'b0;                                                                         
//            #4  ipb_strobe = 1'b1;                                                                                             
//            while (ipb_ack == 1'b0) begin #4; end                                                                          
//            #2  ipb_strobe=1'b0; ipb_write=1'b0;                                                                               
//            @(posedge cross_clk);                                                                                              
//        end                                                                                                                    
//        $fclose(fdo);
        fdo = $fopen("sim_output_test.dat","w");
    end

	always @(posedge cross_clk) begin                                                                              
        $fwrite(fdo, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
            // stub pairs
            uut.tracklet_processing.AS_L1D3n1.enable,
            uut.tracklet_processing.AS_L1D3n1.BX_pipe-1'b1,
            uut.tracklet_processing.AS_L1D3n1.data_in,        
            uut.tracklet_processing.AS_L2D3n1.enable,
            uut.tracklet_processing.AS_L2D3n1.BX_pipe-1'b1,
            uut.tracklet_processing.AS_L2D3n1.data_in,        
            // tracklet parameters
            uut.tracklet_processing.TPAR_L1D3L2D3.enable,
            uut.tracklet_processing.TPAR_L1D3L2D3.BX_pipe-3'b011,
            uut.tracklet_processing.TPAR_L1D3L2D3.data_in,
            // track fit
            uut.tracklet_processing.FT_L1L2.valid_fit,
            uut.tracklet_processing.FT_L1L2.BX_pipe-3'b111,
            uut.tracklet_processing.FT_L1L2.trackout
            );
    end                                                                                                                
                                                                                                                       
                                                                                                                       
                                                                                                                       
endmodule                                                                                                      