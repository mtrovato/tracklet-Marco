`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2014 10:57:12 AM
// Design Name: 
// Module Name: verilog_trigger_top
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

// The current ip address assignments may introduce problems. 
// Modules/registers on the same level as Tracklet_processing require 
// tracklet_processing_sel, which depends on io_addr[29:28], in addition to 
// their own io_addr[27:24]
// Further check and updates on both here and emulation code may be needed.
//
// Tao
// 12/10/2015

module verilog_trigger_top(
    input wire clk200,
    input wire reset,
    // programming interface
    // Note: address and data bus sizes are hard coded in "ipbus_package.vhd"
    // inputs
    input wire ipb_clk,                    // programming clock
    input wire ipb_strobe,                // this ipb space is selected for an I/O operation 
    input wire [31:0] ipb_addr,        // slave address, memory or register
    input wire ipb_write,                // this is a write operation
    input wire [31:0] ipb_wdata,        // data to write for write operations
    // outputs
    output wire [31:0] ipb_rdata,    // data returned for read operations
    output wire ipb_ack,                // 'write' data has been stored, 'read' data is ready
    output wire ipb_err,                    // '1' if error, '0' if OK?
    input wire en_proc_switch,
    // links
    output wire txn_pphi,
    output wire txp_pphi,
    input  wire rxn_pphi,
    input  wire rxp_pphi,
    output wire txn_mphi,
    output wire txp_mphi,
    input  wire rxn_mphi,
    input  wire rxp_mphi,
    //gt reference clock
    input wire gt_refclk,
    //initial clock
    input wire init_clk
    );
    
    // Convert the 200 MHz clock to something representing 10 MHz bunch crossing clock,
    // and something representing the faster processing clock, maybe 600 MHz.
    // This is a ratio of 15:1
    // The timing constraint file needs to match
    // 10/24/2014: 'cross_clk' = 10 MHz, 'proc_clk' = 150 MHz
    // 03/19/2015: 'cross_clk' = 10 MHz, 'proc_clk' = 250 MHz (This is set in the trigger_clock_synth module)
    
     trigger_clock_synth trigger_clock_synth (
        // Clock in ports
        .clk_in1(clk200),           // input clk_in1
        // Clock out ports
        .cross_clk(cross_clk),       // bunch crossing clock
        .proc_clk(proc_clk),        // processing clock
        // Status and control signals
        .reset(reset),              // input reset
        .locked(locked)             // output locked
    );      
    
    // Address decoding to select modules below this level.
    // "ipb_addr[31:30] = 2'b01" have already been used above this point to get here.
    wire tracklet_processing_sel;
    assign tracklet_processing_sel = (ipb_addr[29:28]==2'b01);
    
    wire [31:0] tracklet_processing_io_rd_data;
    wire [31:0] tracklet_processing1_io_rd_data;
    wire [31:0] tracklet_processing2_io_rd_data;
    wire [31:0] tracklet_processing3_io_rd_data;
    wire Reader_io_sel_rd_ack;
    wire tracklet_processing_io_rd_ack;
    wire tracklet_processing1_io_rd_ack;
    wire tracklet_processing2_io_rd_ack;
    wire tracklet_processing3_io_rd_ack;
    wire io_sync;
    wire io_rd_en;
    wire io_wr_en;
   
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // create the BX clocks,
    reg [6:0] clk_cnt;      // clock counter that determines how long the BX is
    reg [2:0] BX;           // Bunch Crossing counter
    reg first_clk;
    reg not_first_clk;
   
    reg [31:0] en_input;
    initial begin
        clk_cnt = 7'b0;
        BX = 3'b111;
    end
    
//    wire io_sel_en;
//    wire en_proc_bufg;
    
//    //BUFG enable(.O(en_proc_bufg),.I(en_proc_2)); // Force the enable signal to be a BUFG
    
    assign io_sel_en = tracklet_processing_sel & (ipb_addr[27:24] == 4'b0101);
    
    always @(posedge ipb_clk) begin
        if (io_wr_en && io_sel_en) 
            en_input <= ipb_wdata;       // enable comes from IPbus if add == 32'h5500000
    end    
    
//    always @(posedge proc_clk) begin 
//        //en_proc_1 <= en_proc_switch;
//        en_proc_1 <= en_proc[0];
//        en_proc_2 <= en_proc_1;         // synchronize enable since it comes from IPbus clock domain
//        if(en_proc_2)
//        //if(en_proc)
//            clk_cnt <= clk_cnt + 1'b1;
//        else begin
//            clk_cnt <= 7'b0;
//            BX <= 3'b111;
//        end
//        if(clk_cnt == 7'b1) begin
//            BX <= BX + 1'b1;
//            first_clk <= 1'b1;
//            not_first_clk <= 1'b0;
//        end
//        else begin
//            first_clk <= 1'b0;
//            not_first_clk <= 1'b1;
//        end
//    end
    parameter [7:0] n_hold = 8'd60;
    reg [n_hold:0] hold;
    reg proc_reset; // The processing reset is delayed until the processing clock is generated
    
    always @(posedge clk200) begin // This shift register runs with the 200 MHz clock
       hold[0] <= reset;
       hold[n_hold:1] <= hold[n_hold-1:0];
       proc_reset <= hold[n_hold];
    end
    
    wire [31:0] input_link1_reg1;
    wire [31:0] input_link1_reg2;
    wire [31:0] input_link2_reg1;
    wire [31:0] input_link2_reg2;
    wire [31:0] input_link3_reg1;
    wire [31:0] input_link3_reg2;
    wire InputLink_R1Link1_io_sel;
    wire InputLink_R1Link2_io_sel;
    wire InputLink_R1Link3_io_sel;
    wire Stubin1_io_sel;
    wire Stubin2_io_sel;
    wire Reader_io_sel;
    wire OutputLink_R1Link1_io_sel;
    wire OutputLink_R1Link2_io_sel;
    wire OutputLink_R1Link3_io_sel;
    wire Trackout1_io_sel;
    wire Trackout2_io_sel;
    wire Trackout3_io_sel;
    wire Trackout4_io_sel;
    wire [31:0] trackout_L1L2_1;
    wire [31:0] trackout_L1L2_2;
    wire [31:0] trackout_L1L2_3;
    wire [31:0] trackout_L1L2_4;
    
    wire [125:0] TF_L1L2;
    wire [125:0] CT_L1L2;
    
    assign InputLink_R1Link1_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b0001);
    assign InputLink_R1Link2_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b0010);
    assign InputLink_R1Link3_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b0011);
    assign Stubin1_io_sel = tracklet_processing_sel && (ipb_addr[2:0] == 3'b011);
    assign Stubin2_io_sel = tracklet_processing_sel && (ipb_addr[2:0] == 3'b111);
    assign Reader_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b1000);
    assign OutputLink_R1Link1_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b1001);
    assign OutputLink_R1Link2_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b1010);
    assign OutputLink_R1Link3_io_sel = tracklet_processing_sel && (ipb_addr[27:24] == 4'b1011);
    assign Trackout1_io_sel = tracklet_processing_sel && (ipb_addr[2:0] == 3'b001);
    assign Trackout2_io_sel = tracklet_processing_sel && (ipb_addr[2:0] == 3'b010);
    assign Trackout3_io_sel = tracklet_processing_sel && (ipb_addr[2:0] == 3'b011);
    assign Trackout4_io_sel = tracklet_processing_sel && (ipb_addr[2:0] == 3'b100);
    
//    always @(posedge ipb_clk) begin
//        if(io_wr_en && InputLink_R1Link1_io_sel && (ipb_addr[2:0] == 3'b011)) input_link1_reg1 <= ipb_wdata;
//        if(io_wr_en && InputLink_R1Link1_io_sel && (ipb_addr[2:0] == 3'b111)) input_link1_reg2 <= ipb_wdata;
//    end
    
    // Input FIFOs
    stubin_fifo input_link1_in1 (
        .full(),
        .din(ipb_wdata),
        .wr_en(io_wr_en && InputLink_R1Link1_io_sel && Stubin1_io_sel),
        .empty(),
        .dout(input_link1_reg1),
        .rd_en(en_input),
        .rst(proc_reset),
        .wr_clk(ipb_clk),
        .rd_clk(proc_clk)
    );
    
    stubin_fifo input_link1_in2 (
        .full(),
        .din(ipb_wdata),
        .wr_en(io_wr_en && InputLink_R1Link1_io_sel && Stubin2_io_sel),
        .empty(),
        .dout(input_link1_reg2),
        .rd_en(en_input),
        .rst(proc_reset),
        .wr_clk(ipb_clk),
        .rd_clk(proc_clk)
    );
    
    stubin_fifo input_link2_in1 (
        .full(),
        .din(ipb_wdata),
        .wr_en(io_wr_en && InputLink_R1Link2_io_sel && Stubin1_io_sel),
        .empty(),
        .dout(input_link2_reg1),
        .rd_en(en_input),
        .rst(proc_reset),
        .wr_clk(ipb_clk),
        .rd_clk(proc_clk)
    );
   
    stubin_fifo input_link2_in2 (
        .full(),
        .din(ipb_wdata),
        .wr_en(io_wr_en && InputLink_R1Link2_io_sel && Stubin2_io_sel),
        .empty(),
        .dout(input_link2_reg2),
        .rd_en(en_input),
        .rst(proc_reset),
        .wr_clk(ipb_clk),
        .rd_clk(proc_clk)
    );
    
    stubin_fifo input_link3_in1 (
        .full(),
        .din(ipb_wdata),
        .wr_en(io_wr_en && InputLink_R1Link3_io_sel && Stubin1_io_sel),
        .empty(),
        .dout(input_link3_reg1),
        .rd_en(en_input),
        .rst(proc_reset),
        .wr_clk(ipb_clk),
        .rd_clk(proc_clk)
    );
    
    stubin_fifo input_link3_in2 (
        .full(),
        .din(ipb_wdata),
        .wr_en(io_wr_en && InputLink_R1Link3_io_sel && Stubin2_io_sel),
        .empty(),
        .dout(input_link3_reg2),
        .rd_en(en_input),
        .rst(proc_reset),
        .wr_clk(ipb_clk),
        .rd_clk(proc_clk)
    );
    
    // Output FIFOs
    ///////////////////////////////////////////////////
    // temporary solution for wr_en
    // fix this when TF MEM is implemented 
    wire trkout_wr_en;
    assign trkout_wr_en = (TF_L1L2[31:0] != 32'b0);
    ///////////////////////////////////////////////////
    
    trackout_fifo CT_L1L2_out1 (
        .full(),
        .din(CT_L1L2[31:0]),
        .wr_en(trkout_wr_en),
        .empty(),
        .dout(trackout_L1L2_1),
        .rd_en(io_rd_en && OutputLink_R1Link1_io_sel && Trackout1_io_sel),
        .rst(proc_reset),
        .wr_clk(proc_clk),
        .rd_clk(ipb_clk)
    );

    trackout_fifo CT_L1L2_out2 (
        .full(),
        .din(CT_L1L2[63:32]),
        .wr_en(trkout_wr_en),
        .empty(),
        .dout(trackout_L1L2_2),
        .rd_en(io_rd_en && OutputLink_R1Link1_io_sel && Trackout2_io_sel),
        .rst(proc_reset),
        .wr_clk(proc_clk),
        .rd_clk(ipb_clk)
    );

    trackout_fifo CT_L1L2_out3 (
        .full(),
        .din(CT_L1L2[95:64]),
        .wr_en(trkout_wr_en),
        .empty(),
        .dout(trackout_L1L2_3),
        .rd_en(io_rd_en && OutputLink_R1Link1_io_sel && Trackout3_io_sel),
        .rst(proc_reset),
        .wr_clk(proc_clk),
        .rd_clk(ipb_clk)
    );
    
    trackout_fifo CT_L1L2_out4 (
        .full(),
        .din({2'b0,CT_L1L2[125:96]}),
        .wr_en(trkout_wr_en),
        .empty(),
        .dout(trackout_L1L2_4),
        .rd_en(io_rd_en && OutputLink_R1Link1_io_sel && Trackout4_io_sel),
        .rst(proc_reset),
        .wr_clk(proc_clk),
        .rd_clk(ipb_clk)
    );
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // generate en_proc based on data header detection 
    reg en_proc;
    
    initial begin
        en_proc <= 1'b0;
    end
     
    always @ (posedge proc_clk) begin
        if (reset) 
            en_proc <= 1'b0;
        else if (input_link1_reg1[31:29] == 3'b111 && {input_link1_reg1[20:14], input_link1_reg2[31:14]} == 25'h1ffffff)
            en_proc <= 1'b1;
    end
    
    // connect each sector
         
    Tracklet_processingD3 tracklet_processing(
        // clocks and reset
        .reset(proc_reset),                        // active HI
        .clk(proc_clk),                // processing clock at a multiple of the crossing clock
        .en_proc(en_proc),
        // programming interface
        // inputs
        .io_clk(ipb_clk),                    // programming clock
        .io_sel(tracklet_processing_sel),    // this module has been selected for an I/O operation
        .io_sync(io_sync),                // start the I/O operation
        .io_addr(ipb_addr[15:0]),        // slave address, memory or register. Top 16 bits already consumed.  
        .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
        .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
        .io_wr_data(ipb_wdata),    // data to write for write operations
        // ipbus outputs
        .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
        .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
        // inputs
        .input_link1_reg1(input_link1_reg1),
        .input_link1_reg2(input_link1_reg2),
        .input_link2_reg1(input_link2_reg1),
        .input_link2_reg2(input_link2_reg2),
        .input_link3_reg1(input_link3_reg1),
        .input_link3_reg2(input_link3_reg2),
        
        .PT_L1L2_Plus_To_DataStream(Proj_L1L2_ToPlus),
        .PT_L1L2_Plus_To_DataStream_en(Proj_L1L2_ToPlus_en),
        .PT_L1L2_Minus_To_DataStream(Proj_L1L2_ToMinus),
        .PT_L1L2_Minus_To_DataStream_en(Proj_L1L2_ToMinus_en),
        .PT_L1L2_Plus_From_DataStream(Proj_L1L2_FromPlus),
        .PT_L1L2_Plus_From_DataStream_en(Proj_L1L2_FromPlus_en),
        .PT_L1L2_Minus_From_DataStream(Proj_L1L2_FromMinus),
        .PT_L1L2_Minus_From_DataStream_en(Proj_L1L2_FromMinus_en),
        
        .MT_L1L2_Plus_To_DataStream(Match_L1L2_ToPlus),
        .MT_L1L2_Plus_To_DataStream_en(Match_L1L2_ToPlus_en),
        .MT_L1L2_Minus_To_DataStream(Match_L1L2_ToMinus),
        .MT_L1L2_Minus_To_DataStream_en(Match_L1L2_ToMinus_en),
        .MT_L1L2_Plus_From_DataStream(Match_L1L2_FromPlus),
        .MT_L1L2_Plus_From_DataStream_en(Match_L1L2_FromPlus_en),
        .MT_L1L2_Minus_From_DataStream(Match_L1L2_FromMinus),
        .MT_L1L2_Minus_From_DataStream_en(Match_L1L2_FromMinus_en),

        .MT_L3L4_Plus_To_DataStream(Match_L3L4_ToPlus),
        .MT_L3L4_Plus_To_DataStream_en(Match_L3L4_ToPlus_en),
        .MT_L3L4_Minus_To_DataStream(Match_L3L4_ToMinus),
        .MT_L3L4_Minus_To_DataStream_en(Match_L3L4_ToMinus_en),
        .MT_L3L4_Plus_From_DataStream(Match_L3L4_FromPlus),
        .MT_L3L4_Plus_From_DataStream_en(Match_L3L4_FromPlus_en),
        .MT_L3L4_Minus_From_DataStream(Match_L3L4_FromMinus),
        .MT_L3L4_Minus_From_DataStream_en(Match_L3L4_FromMinus_en),

        .MT_L5L6_Plus_To_DataStream(Match_L5L6_ToPlus),
        .MT_L5L6_Plus_To_DataStream_en(Match_L5L6_ToPlus_en),
        .MT_L5L6_Minus_To_DataStream(Match_L5L6_ToMinus),
        .MT_L5L6_Minus_To_DataStream_en(Match_L5L6_ToMinus_en),
        .MT_L5L6_Plus_From_DataStream(Match_L5L6_FromPlus),
        .MT_L5L6_Plus_From_DataStream_en(Match_L5L6_FromPlus_en),
        .MT_L5L6_Minus_From_DataStream(Match_L5L6_FromMinus),
        .MT_L5L6_Minus_From_DataStream_en(Match_L5L6_FromMinus_en),
        
        .CT_L1L2_DataStream(CT_L1L2),
        .CT_L3L4_DataStream(CT_L3L4),
        .CT_L5L6_DataStream(CT_L5L6),
        .CT_F1F2_DataStream(),
        .CT_F3F4_DataStream(),    
        
        // clocks
        .BX(BX),
        .first_clk(first_clk),
        .not_first_clk(not_first_clk)
        
        );   
         
//       Tracklet_Layer_Router layer_router(
//        // clocks and reset
//        .reset(proc_reset),                        // active HI
//        .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//        .en_proc(en_proc_2),
//        //.en_proc(en_proc),
//        // programming interface
//        // inputs
//        .io_clk(ipb_clk),                    // programming clock
//        .io_sel(tracklet_processing_sel),    // this module has been selected for an I/O operation
//        .io_sync(io_sync),                // start the I/O operation
////        .io_addr(ipb_addr[27:0]),        // slave address, memory or register. Top 4 bits already consumed.
//        .io_addr(ipb_addr[15:0]),        // slave address, memory or register. Top 4 bits already consumed.
//        .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//        .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//        .io_wr_data(ipb_wdata),    // data to write for write operations
//        .input_link1_reg1(input_link1_reg1),
//        .input_link1_reg2(input_link1_reg2),
////        .input_link2_reg1(input_link2_reg1),
////        .input_link2_reg2(input_link2_reg2),
////        .input_link3_reg1(input_link3_reg1),
////        .input_link3_reg2(input_link3_reg2),
//        // outputs
//        .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//        .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//        // clocks
//        .BX(BX),
//        .first_clk(first_clk),
//        .not_first_clk(not_first_clk)
        
//        );    
        
//     Tracklet_VM_Router vm_router(
//        // clocks and reset
//       .reset(proc_reset),                        // active HI
//       .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//       .en_proc(en_proc_2),
//       //.en_proc(en_proc),
//       // programming interface
//       // inputs
//       .io_clk(ipb_clk),                    // programming clock
//       .io_sel(tracklet_processing_sel),    // this module has been selected for an I/O operation
//       .io_sync(io_sync),                // start the I/O operation
//       .io_addr(ipb_addr[15:0]),        // slave address, memory or register. Top 4 bits already consumed.
//       .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//       .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//       .io_wr_data(ipb_wdata),    // data to write for write operations
////       .input_link1_reg1(input_link1_reg1),
////       .input_link1_reg2(input_link1_reg2),
//       // outputs
//       .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//       .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//       // clocks
//       .BX(BX),
//       .first_clk(first_clk),
//       .not_first_clk(not_first_clk)
   
//       );
       
//      Disk_Tracklet_VM_Router_A vm_router(
//    // clocks and reset
//   .reset(proc_reset),                        // active HI
//   .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//   .en_proc(en_proc_2),
//   //.en_proc(en_proc),
//   // programming interface
//   // inputs
//   .io_clk(ipb_clk),                    // programming clock
//   .io_sel(Reader_io_sel),    // this module has been selected for an I/O operation
//   .io_sync(io_sync),                // start the I/O operation
//   .io_addr(ipb_addr[15:0]),        // slave address, memory or register. Top 4 bits already consumed.
//   .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//   .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//   .io_wr_data(ipb_wdata),    // data to write for write operations
//   .input_link1_reg1(input_link1_reg1),
//   .input_link1_reg2(input_link1_reg2),
//   // outputs
//   .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//   .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//   // clocks
//   .BX(BX),
//   .first_clk(first_clk),
//   .not_first_clk(not_first_clk)

//   );


//      Disk_Tracklet_VM_Router_B vm_router(
//          // clocks and reset
//         .reset(proc_reset),                        // active HI
//         .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//         .en_proc(en_proc_2),
//         //.en_proc(en_proc),
//         // programming interface
//         // inputs
//         .io_clk(ipb_clk),                    // programming clock
//         .io_sel(Reader_io_sel),    // this module has been selected for an I/O operation
//         .io_sync(io_sync),                // start the I/O operation
//         .io_addr(ipb_addr[15:0]),        // slave address, memory or register. Top 4 bits already consumed.
//         .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//         .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//         .io_wr_data(ipb_wdata),    // data to write for write operations
//         .input_link1_reg1(input_link1_reg1),
//         .input_link1_reg2(input_link1_reg2),
//         // outputs
//         .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//         .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//         // clocks
//         .BX(BX),
//         .first_clk(first_clk),
//         .not_first_clk(not_first_clk)
     
//         );


//    Barrel_Tracklet_Tracklet_Engine TEngine(
//    // clocks and reset
//   .reset(proc_reset),                        // active HI
//   .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//   .en_proc(en_proc_2),
//   //.en_proc(en_proc),
//   // programming interface
//   // inputs
//   .io_clk(ipb_clk),                    // programming clock
//   .io_sel(Reader_io_sel),    // this module has been selected for an I/O operation
//   .io_sync(io_sync),                // start the I/O operation
//   .io_addr(ipb_addr[15:0]),        // slave address, memory or register. Top 4 bits already consumed.
//   .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//   .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//   .io_wr_data(ipb_wdata),    // data to write for write operations
//   .input_link1_reg1(input_link1_reg1),
//   .input_link1_reg2(input_link1_reg2),
//   // outputs
//   .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//   .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//   // clocks
//   .BX(BX),
//   .first_clk(first_clk),
//   .not_first_clk(not_first_clk)

//   );
        
//    Tracklet_TrackletCalculator TC(
//       //clocks and reset
//        .reset(proc_reset),                        // active HI
//        .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//        .en_proc(en_proc_2),
//        //.en_proc(en_proc),
//        // programming interface
//        // inputs
//        .io_clk(ipb_clk),                    // programming clock
//        .io_sel(tracklet_processing_sel),    // this module has been selected for an I/O operation
//        .io_sync(io_sync),                // start the I/O operation
//        .io_addr(ipb_addr[27:0]),        // slave address, memory or register. Top 4 bits already consumed.
//        .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//        .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//        .io_wr_data(ipb_wdata),    // data to write for write operations
//        // outputs
//        .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//        .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//        // clocks
//        .BX(BX),
//        .first_clk(first_clk),
//        .not_first_clk(not_first_clk)
//    );
     
//     Tracklet_Communication commy(
//         //clocks and reset
//         .reset(proc_reset),                        // active HI
//         .clk(proc_clk),                // processing clock at a multiple of the crossing clock
//         .en_proc(en_proc_2),
//         //.en_proc(en_proc),
//         // programming interface
//         // inputs
//         .io_clk(ipb_clk),                    // programming clock
//         .io_sel(tracklet_processing_sel),    // this module has been selected for an I/O operation
//         .io_sync(io_sync),                // start the I/O operation
//         .io_addr(ipb_addr[27:0]),        // slave address, memory or register. Top 4 bits already consumed.
//         .io_rd_en(io_rd_en),                // this is a read operation, enable readback logic
//         .io_wr_en(io_wr_en),                // this is a write operation, enable target for one clock
//         .io_wr_data(ipb_wdata),    // data to write for write operations
//         // outputs
//         .io_rd_data(tracklet_processing_io_rd_data),    // data returned for read operations
//         .io_rd_ack(tracklet_processing_io_rd_ack),        // 'read' data from this module is ready
//         // clocks
//         .BX(BX),
//         .first_clk(first_clk),
//         .not_first_clk(not_first_clk),
//         //Links
//         .txn_pphi(txn_pphi),
//         .txp_pphi(txp_pphi),
//         .rxn_pphi(rxn_pphi),
//         .rxp_pphi(rxp_pphi),
//         .txn_mphi(txn_mphi),
//         .txp_mphi(txp_mphi),
//         .rxn_mphi(rxn_mphi),
//         .rxp_mphi(rxp_mphi),
//         //gt reference clock
//         .gt_refclk(gt_refclk),
//         //initial clock
//         .init_clk(init_clk)
//     );
        
    
        
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // connect a state machine to handle the IPbus transactions, wait states and drive 'ipb_ack'
     IPB_IO_interface IPB_IO_interface(
         // inputs
         .clk(ipb_clk),               // IPbus clock
         .res(proc_reset),                // Global reset
         .ipb_strobe(ipb_strobe),    // IPbus strobe
         .ipb_write(ipb_write),     // IPbus write
         .io_rd_ack(io_rd_ack),    // verilog ack
         // outputs
         .io_sync(io_sync),           // An operation is in progress
         .io_rd_en(io_rd_en),            // this is a read operation, enable readback logic
         .io_wr_en(io_wr_en),          // one cycle long write enable
         .ipb_ack(ipb_ack)            // one cycle long ack back to IPbus
     );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // connect a mux to steer the readback data from one of the segments to the ipbus
    reg [31:0] io_rd_data_reg;
    assign ipb_rdata = io_rd_data_reg;
    // Assert 'io_rd_ack' if any modules below this function assert their 'io_rd_ack'.
    reg io_rd_ack_reg;
    assign io_rd_ack = io_rd_ack_reg;
    always @(posedge ipb_clk) begin
        io_rd_ack_reg <= io_sync & io_rd_en & (tracklet_processing_io_rd_ack | io_sel_en | InputLink_R1Link1_io_sel | Reader_io_sel_rd_ack | OutputLink_R1Link1_io_sel);
    end

    always @(posedge ipb_clk) begin
        if (Reader_io_sel_rd_ack)   io_rd_data_reg <= tracklet_processing_io_rd_data;
        if (tracklet_processing_io_rd_ack)      io_rd_data_reg <= tracklet_processing_io_rd_data;
        if (io_rd_en & io_sel_en)               io_rd_data_reg <= en_input;
        //if (io_rd_en & InputLink_R1Link1_io_sel) io_rd_data_reg <= input_link1_reg1;
        if (io_rd_en & OutputLink_R1Link1_io_sel & Trackout1_io_sel) io_rd_data_reg <= trackout_L1L2_1;
        if (io_rd_en & OutputLink_R1Link1_io_sel & Trackout2_io_sel) io_rd_data_reg <= trackout_L1L2_2;
        if (io_rd_en & OutputLink_R1Link1_io_sel & Trackout3_io_sel) io_rd_data_reg <= trackout_L1L2_3;
        if (io_rd_en & OutputLink_R1Link1_io_sel & Trackout4_io_sel) io_rd_data_reg <= trackout_L1L2_4;
    end
    
         
endmodule
