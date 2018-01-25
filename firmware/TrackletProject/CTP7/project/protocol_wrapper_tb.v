`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2015 12:14:02 PM
// Design Name: 
// Module Name: protocol_wrapper_tb
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

module protocol_wrapper_tb(

);
	
	// inputs
	reg clk240_i;
  reg rst_i;
  reg [23:0] tx_user_word_i;
  reg bc0_i;
  reg [11:0] bcid_i;
  // outputs
  wire data_valid_o;
  wire [31:0] txdata_o;
  wire [3:0] txcharisk_o;
  
  // Instantiate the Unit Under Test (UUT)
  tx_protocol_wrapper uut (
    .clk240_i(clk240_i),
    .rst_i(rst_i),
    .tx_user_word_i(tx_user_word_i),
    .bc0_i(bc0_i),
    .bcid_i(bcid_i),
    .data_valid_o(data_valid_o),
    .txdata_o(txdata_o),
    .txcharisk_o(txcharisk_o)
  );
  
  initial begin
    // Initialize input
    clk240_i <= 0;
    rst_i <= 0;
    tx_user_word_i <= 0;
    bc0_i <= 0;
    bcid_i <= 0;
    
    // Wait 100 ns for global reset to finish
    #100;
    
    // Add stimulus here
    rst_i <= 1;
    #10
    rst_i <= 0;
    
    #4
    bc0_i <= 1;
    bcid_i <= 12'd0;
    
    #4
    bc0_i <= 0; 
    
       
    tx_user_word_i <= 24'hde0001;
    
    #4
    tx_user_word_i <= 24'hde0002;
    
    #4
    tx_user_word_i <= 24'hde0003;
    
    #4
    tx_user_word_i <= 24'hde0004;
    
    #4
    tx_user_word_i <= 24'hde0005;
    
    #4
    tx_user_word_i <= 24'hde0006;
    
    #4
    tx_user_word_i <= 24'hde0007;
    
    #4
    tx_user_word_i <= 24'hde0008;
    
    #4
    tx_user_word_i <= 24'hde0009;
    
    #4
    tx_user_word_i <= 24'hde0010;
    
    #4
    tx_user_word_i <= 24'hde0011;
    
    #4
    tx_user_word_i <= 24'hde0012;
    
    #4
    tx_user_word_i <= 24'hde0013;
    
    #4
    tx_user_word_i <= 24'hde0014;
    
    #4
    tx_user_word_i <= 24'hde0015;
    
    #4
    tx_user_word_i <= 24'hde0016;
    
    #4
    tx_user_word_i <= 24'hde0017;
    
    #4
    tx_user_word_i <= 24'hde0018;
    
    #4
    tx_user_word_i <= 24'hde0019;
    
    #4
    tx_user_word_i <= 24'hde0020;
    
    #4
    tx_user_word_i <= 24'hde0021; 
    
    #4
    tx_user_word_i <= 24'hde0022;
    
    #4
    tx_user_word_i <= 24'hde0023; 
    
    #4
    tx_user_word_i <= 24'hde0024; 
    
    // next BX
    #4
    bc0_i <= 0;
    bcid_i <= 12'd4;
    
    tx_user_word_i <= 24'hde0001;
    
    #4
    tx_user_word_i <= 24'hde0002;
    
    #4
    tx_user_word_i <= 24'hde0003;
    
    #4
    tx_user_word_i <= 24'hde0004;
    
    #4
    tx_user_word_i <= 24'hde0005;
    
    #4
    tx_user_word_i <= 24'hde0006;
    
    #4
    tx_user_word_i <= 24'hde0007;
    
    #4
    tx_user_word_i <= 24'hde0008;
    
    #4
    tx_user_word_i <= 24'hde0009;
    
    #4
    tx_user_word_i <= 24'hde0010;
    
    #4
    tx_user_word_i <= 24'hde0011;
    
    #4
    tx_user_word_i <= 24'hde0012;
    
    #4
    tx_user_word_i <= 24'hde0013;
    
    #4
    tx_user_word_i <= 24'hde0014;
    
    #4
    tx_user_word_i <= 24'hde0015;
    
    #4
    tx_user_word_i <= 24'hde0016;
    
    #4
    tx_user_word_i <= 24'hde0017;
    
    #4
    tx_user_word_i <= 24'hde0018;
    
    #4
    tx_user_word_i <= 24'hde0019;
    
    #4
    tx_user_word_i <= 24'hde0020;
    
    #4
    tx_user_word_i <= 24'hde0021; 
    
    #4
    tx_user_word_i <= 24'hde0022;
    
    #4
    tx_user_word_i <= 24'hde0023;   
    
    #4
    tx_user_word_i <= 24'hde0024;       
    
  end
  
  always 
    #2 clk240_i = !clk240_i;
    


endmodule
