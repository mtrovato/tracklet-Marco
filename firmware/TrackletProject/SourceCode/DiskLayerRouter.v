//////////////////////////////////////////////////////////////////////////////////
// Module Name: LayerRouter
// Note: First event takes one extra clock.
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module DiskLayerRouter(
	input 		   clk,
	input 		   reset,
	input 		   en_proc,
	// programming interface
	// inputs
	input wire 	   io_clk,// programming clock
	input wire 	   io_sel,// this module has been selected for an I/O operation
	input wire 	   io_sync,// start the I/O operation
	input wire [23:0]  io_addr,// slave address, memory or register. Top 16 bits already consumed.
	input wire 	   io_rd_en,// this is a read operation
	input wire 	   io_wr_en,// this is a write operation
	input wire [31:0]  io_wr_data,// data to write for write operations
	// outputs
	output wire [31:0] io_rd_data,// data returned for read operations
	output wire 	   io_rd_ack,// 'read' data from this module is ready
	//clocks
	input wire [2:0]   BX,
	input wire 	   first_clk,
	input wire 	   not_first_clk,
	
	input 		   start,
	output reg 	   done,
	
	output 		   read_en,
	
	input [35:0] 	   stubin,
	output reg 	   wr_en1,
	output reg 	   wr_en2,
	output reg 	   wr_en3,
	output reg 	   wr_en4,
	output reg 	   wr_en5,
	output reg 	   wr_en6,
		   
	output reg [35:0]  stuboutL1, 
	output reg [35:0]  stuboutL2,
	output reg [35:0]  stuboutL3,
	output reg [35:0]  stuboutL4,
	output reg [35:0]  stuboutL5,
	output reg [35:0]  stuboutL6
	);
	parameter BARREL =1'b1;
	////////////////////////////////////////////////////////////////////////////////////////////////////
	assign io_rd_data[31:0] = 32'h00000000;
	assign io_rd_ack = 1'b0;

	reg [35:0] stubin1;	
	reg [6:0] stub_cnt;
	reg [5:0] numberL1;
	reg [5:0] numberL2;
	reg [5:0] numberL3;
	reg [5:0] numberL4;
	reg [5:0] numberL5;
	reg [5:0] numberL6;
	reg [35:0] stubin_hold;
	reg [7:0] BX_read;
	
	reg [6:0] clk_cnt;
	reg [2:0] BX_pipe;
	reg first_clk_pipe;
	reg [2:0] BX_hold;
	reg Iwr_en1;
    reg Iwr_en2;
    reg Iwr_en3;
    reg Iwr_en4;
    reg Iwr_en5;
    reg Iwr_en6;

	//*******************
	//Added reg - EHB
	//reg [7:0] BX_readT;
	//reg [7:0] BX_readH;
	//reg activeS;
	
	reg Active;// Router is active
    parameter HEAD=0,CNTS=1,STUBS=2,TRAIL=3;
    reg [1:0] RouterState;// Header Detected
	reg [6:0] Active_cnt; //Effectively is Stub_cnt + 1
	
	//*******************
	
//Init Bx_pipe (local event number) and clock counter.
	initial begin
		clk_cnt = 7'b0;
		BX_pipe = 3'b111;
		RouterState = HEAD;
		Active <= 1'b0;
		stub_cnt = 0;
		BX_read = 0; //Bunch crossing register
		numberL1 = 0;//Initialize stub counts
		numberL2 = 0;
		numberL3 = 0;
		numberL4 = 0;
		numberL5 = 0;
        if(BARREL) numberL6 = 0;
	end

//*******************************************************************
//Check This

//If en_proc increment Clk_cnt otherwise init bx_pipe and clock counter
	always @(posedge clk) begin
	    if(read_en) stubin1 <= stubin;
	        
		if(en_proc) clk_cnt <= clk_cnt + 1'b1;
		else begin
			clk_cnt <= 7'b0;
			BX_pipe <= 3'b111;
		end

		//If Start, increment bx_pipe, first_clk_pipe is true, Clr active_cnt,else first_clk_pipe is false
		if(start) begin
			BX_pipe <= BX_pipe + 1'b1;
			first_clk_pipe <= 1'b1;
		end
		else begin
			first_clk_pipe <= 1'b0;
		end
		// Store last bx_pipe in bx_hold
		BX_hold <= BX_pipe;
		//Start-> Active=1; If stubs are finisted Active=0;
        //if(start || (Active_cnt == numberL6))Active <=!Active;
        if(BARREL) begin
         if(start)Active <= 1'b1;
           else if ((Active_cnt == numberL6)&&(RouterState == STUBS))Active <= 1'b0;
             else Active <= Active;
             end
         else begin
         if(start)Active <= 1'b1;
               else if ((Active_cnt == numberL5)&&(RouterState == STUBS))Active <= 1'b0;
                 else Active <= Active;
                 end

	end
//*******************************************************************

//*******************************************************************
//  Router State Description
//  Head: Waiting for Header
//  Cnts: Load Stub count registers
//  Stubs: Route Stubs into layer memories.
//  Trail: Update Bunch Counter Number for next event. Setup for next header.
//*******************************************************************

	always @(posedge clk) begin: Machine
	
		if(!en_proc) RouterState = HEAD;
		
		if(start) Active_cnt = 0;
		
		case (RouterState)
		HEAD:
			begin
			   if(stubin1[35:33] == 3'b111 & stubin1[24:0] == 25'h1ffffff) RouterState = CNTS; 
			   else RouterState = HEAD;
			end
		CNTS:
			begin
			   Active_cnt <= Active_cnt + 1;
			   if(BARREL)
			     begin
			     numberL1 <= stubin1[35:30];
			     numberL2 <= stubin1[29:24];
			     numberL3 <= stubin1[23:18];
			     numberL4 <= stubin1[17:12];
			     numberL5 <= stubin1[11:6];
			     numberL6 <= stubin1[5:0];
			     end
			   else
                   begin
                   numberL1 <= stubin1[29:24];
                   numberL2 <= stubin1[23:18];
                   numberL3 <= stubin1[17:12];
                   numberL4 <= stubin1[11:6];
                   numberL5 <= stubin1[5:0];
                   end			   
			   RouterState = STUBS;
			end
 
		STUBS:
		   begin
			   // Active_cnt gives is used to indicate when the last stub is about to be processed.
			   Active_cnt <= Active_cnt + 1;
			   stub_cnt <= stub_cnt + 1;
			   stubin_hold <= stubin1;
			   Iwr_en1 <= (stub_cnt < numberL1);
			   Iwr_en2 <= (stub_cnt < numberL2 & stub_cnt >= numberL1);
			   Iwr_en3 <= (stub_cnt < numberL3 & stub_cnt >= numberL2);
			   Iwr_en4 <= (stub_cnt < numberL4 & stub_cnt >= numberL3);
			   Iwr_en5 <= (stub_cnt < numberL5 & stub_cnt >= numberL4);
			   if(BARREL)Iwr_en6 <= (stub_cnt < numberL6 & stub_cnt >= numberL5);
			   
			   // Active_cnt is used to indicate when the last stub is about to be processed.
			   if(BARREL && (Active_cnt == numberL6))RouterState = TRAIL;
			   if(!BARREL && (Active_cnt == numberL5))RouterState = TRAIL;
			end
		  
		TRAIL:
			begin
			   //If Trailer, read BX number and increment it
			   if(stubin1[35:33] == 3'b111 & stubin1[24:0] == 25'h0) begin
			      BX_read <= stubin1[32:25] + 1'b1;
			      stub_cnt = 0;
			      if(BARREL)Iwr_en6 <= 1'b0;
			      else Iwr_en5 <= 1'b0;
			      RouterState = HEAD;
			   end
			end
		endcase
	end// End Process.
	
// Delay of 3 clocks between Start coming in, and done going out.
// Why this delay? Why is it set to 3?  Is it header/stubcount/trailer or something else?
	parameter [7:0] n_hold = 8'd2;
	reg [n_hold:0] hold;
	always @(posedge clk) begin
		hold[0] <= start;
		hold[n_hold:1] <= hold[n_hold-1:0];
		done <= hold[n_hold];
	end


	always @(posedge clk) begin
		//If write enable, send stub register to appropriate output bus, else set it to 0.  Why bother to set to 0?
		if(Iwr_en1) stuboutL1 <= stubin_hold;
		if(Iwr_en2) stuboutL2 <= stubin_hold;
		if(Iwr_en3) stuboutL3 <= stubin_hold;
		if(Iwr_en4) stuboutL4 <= stubin_hold;
		if(Iwr_en5) stuboutL5 <= stubin_hold;
		if(BARREL) if(Iwr_en6) stuboutL6 <= stubin_hold;
	end

	always @(posedge clk) begin
        //If write enable, send stub register to appropriate output bus, else set it to 0.  Why bother to set to 0?
        wr_en1 <= (Iwr_en1);        
        wr_en2 <= (Iwr_en2);
        wr_en3 <= (Iwr_en3);
        wr_en4 <= (Iwr_en4);
        wr_en5 <= (Iwr_en5);
        if(BARREL) wr_en6 <= Iwr_en6;
    end
	
//Read_en if BX_pipe equals incoming bx number.
	assign read_en = (BX_read%8) == BX_pipe && Active; 
	//assign read_en = (BX_read%8) == BX_pipe;
	//assign read_en = ((BX_readT == BX_readH) && ((BX_readT%8) == BX_pipe) || ((BX_readT != BX_readH)&& activeS)); //EHB

endmodule
