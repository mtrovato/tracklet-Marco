`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2015 04:46:20 PM
// Design Name: 
// Module Name: LayerProjY
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
//  15 bits   kz   	17.80869565
//  zmeanD1	131.5   2342       
//  zmeanD2	156.0   2778       
//  zmeanD3	185.0   3295       
//  zmeanD4	220.0   3918       
//  zmeanD5	261.2   4652       
//////////////////////////////////////////////////////////////////////////////////

module DiskProjY#(
  parameter ZP = 15'sd2342                         // Specify Disk Z offset.
)(
    input clk,
    input wire signed[16:0] x7,
    input wire signed[19:0] invt,
    input wire signed[10:0] z0,
    input wire signed[18:0] phi0,
    output reg signed[13:0] phiD,
    output reg [11:0]rD,
    output wire valid_proj,
    output wire valid_projPlus,
    output wire valid_projMinus
    );

//    reg signed [13:0] zp;
           
//    always @(posedge clk) begin
//      zp      <= ZP;  
//     end    
    
// Step 8: 
    
        reg signed [14:0] x5;
               
        always @(posedge clk) begin
          x5     <= (ZP - z0);  //x5 = zp - z0
         end


        wire signed [14:0] x5_step10;
         //x5_step10 = x5 Delayed 1 clocks step 11 for eq x13 = (x5 * x7)>>13;
                 pipe_delay #(.STAGES(1), .WIDTH(15))
                        x5_pipe(.clk(clk), .val_in(x5), .val_out(x5_step10));

// Step 9: 
    
        reg signed [32:0] x9a;
        reg signed [32:0] x9a_pipe;
        wire signed [16:0] x9;  //updated bias fixes size from 13 to 17
    
        always @(posedge clk) begin
       //updated bias fixes
       //   x9a   <=  (11'sd682 * x5);  
            x9a   <=  (17'sd21845 * x5);
            x9a_pipe <= x9a;  
        end
       // updated bias fixes
       // assign x9   =   x9a>>>12; //x8 = (x1 * a2m)>>>10; 
        assign x9   =   x9a_pipe>>>11; //x8 = (x1 * a2m)>>>10; 

        wire signed [16:0] x9_step11;
        //x9_step13 = x9 Delayed 1 clocks step 11 for eq x24 = (x9 * invt)>>16;;
                pipe_delay #(.STAGES(2), .WIDTH(17))
                       x11_pipe(.clk(clk), .val_in(x9), .val_out(x9_step11));
    
//Step 10:


            reg signed [31:0] x13a;
            reg signed [31:0] x13a_pipe;
            wire signed [16:0] x13;           
            reg signed [16:0] x13_pipe;           

        always @(posedge clk) begin
            x13a     <= (x5_step10 * x7);
            x13a_pipe <= x13a; 
        end
            
        assign x13  =   x13a_pipe>>>13; //x13 = (x5 * x7)>>13;
 
//Step 11:
         reg signed [36:0] x24a;
         reg signed [36:0] x24a_pipe;
         reg signed [32:0] x25a;
         reg signed [32:0] x25a_pipe;
         wire signed [16:0] x24;
         wire signed [16:0] x25;
         reg signed [16:0] x25_pipe;
         reg signed[19:0] invt_pipe;
         reg signed[19:0] invt_pipe2;
                       
        always @(posedge clk) begin
            invt_pipe   <= invt;
            invt_pipe2  <= invt_pipe;
            x13_pipe    <= x13;
            x24a        <=  (x9_step11 * invt_pipe2);
            x24a_pipe   <=  x24a;
            x25a        <=  (x13_pipe * invt_pipe2);
            x25a_pipe   <= x25a;
        end
            

   //updated bias fixes
   //   assign x24      =   x24a>>>16; //x24 = (x9 * invt)>>16;  
        assign x24      =   x24a_pipe>>>20; //x24 = (x9 * invt)>>20;  
        assign x25      =   x25a_pipe>>>18; //x25 = (x13 * invt)>>18; 
        
        wire signed [16:0] x24_step15;
        //x24_step15 = x24 Delayed 3 clocks step 15 for eq rD = (x24 * x27m)>>9;
                pipe_delay #(.STAGES(7), .WIDTH(17))
                       x24_pipe(.clk(clk), .val_in(x24), .val_out(x24_step15));
    
//Step 12:
          reg signed [33:0] x26a;
          reg signed [33:0] x26a_pipe;
          reg signed [18:0] phiDs;
          wire signed [19:0] x25sp;
          wire signed [9:0] x26;
          wire signed[18:0] phi0_pipe;
         
       
       pipe_delay #(.STAGES(4), .WIDTH(19))
                 phi0_in_pipe(.clk(clk), .val_in(phi0), .val_out(phi0_pipe));
         
        assign x25sp  =   x25<<3;                         
        always @(posedge clk) begin
           x25_pipe     <= x25;
           x26a         <= x25_pipe * x25_pipe; //x26 = (x25 * x25)
           x26a_pipe    <= x26a;  
//           phiDs     <= phi0 + x25sp; 
           phiDs     <= (phi0_pipe + (x25_pipe<<<3))>>>3; 
        end
                                            
        assign x26  =   x26a_pipe>>>24; //x26 = (x25 * x25)>>24;
 
        wire signed [18:0] phiD_step15;
               pipe_delay #(.STAGES(7), .WIDTH(19))
                      phiD_pipe(.clk(clk), .val_in(phiDs), .val_out(phiD_step15));    
   
//Step 13:
         reg signed [21:0] x27b;
         reg signed [21:0] x27b_pipe;
         reg signed [21:0] x27b_pipe2;
         wire signed [9:0] x27a;
                                                                           
       always @(posedge clk) begin
             x27b       <= (x26 * 12'sd1466);
             x27b_pipe  <= x27b;  
             x27b_pipe2 <= x27b_pipe;  
       end
                                                                         
       assign x27a  =   x27b_pipe2>>>12; //x27a = (x26*1466)>>12;

//Step 14:
           reg signed [10:0] x27;
           reg signed [21:0] x27_pipe;
           
       always @(posedge clk) begin
           x27      <=  11'sd384 - x27a; //x27 = 384 - x27a; 
       end
           
//Step 15:
        reg [11:0] rDa;
        reg pass_cut;
                                                                  
        always @(posedge clk) begin
            x27_pipe <= (x24_step15 * x27);
            rDa      <= (x27_pipe>>>9) - 20'd509;
            rD       <= rDa;
            pass_cut <= (rDa < 4096 && rDa >= 512);
            
        end
        //updated bias fixes                                                              
        //assign rD  = (rDa>>>7) - 20'd512; //rD = (x24 * x27)>>7 - 20'd512;
       // assign pre_rD  = (rDa_pipe>>>9) - 20'd509; //rD = (x24 * x27)>>9 - 20'd509; // this includes Yuri's hack (+3)
        
        //wire pass_cut;
        //assign pass_cut = (rDa >= 4096 || rDa < 512)? 1'b0 : 1'b1; // check that rD falls within rmin,rmax of disks
   
    reg pre_valid_proj;
    reg pre_valid_projMinus;
    reg pre_valid_projPlus;
    
    assign valid_proj = (pass_cut & pre_valid_proj);
    assign valid_projMinus = (pass_cut & pre_valid_projMinus);
    assign valid_projPlus = (pass_cut & pre_valid_projPlus);

   
    //if in inner layers (ZP<2918) phi of proj is 14 bits
    //if in outer laters (ZP>2155) phi of proj is 17 bits
    //is the following true about outer layers? ---only relevant are 16 though
    //compare the phiLa with the 1/2 of the bounds before shifting to do computation in one step
    //and then shift by the number of bits needed for each of the different layers
    always @(posedge clk) begin
        //if(phiD_step15 < $signed(18'd16384)) begin  //Why not? phiD_step16[16:14] == 3'b000 
        if(phiD_step15 < $signed(18'd2048)) begin  //Why not? phiD_step16[16:14] == 3'b000 
            phiD    <= (phiD_step15 + $signed(18'd12288));//Add Sector width to phi to map to adjecent sector
            pre_valid_projMinus <= 1'b1;
            pre_valid_proj <= 1'b0;
            pre_valid_projPlus <= 1'b0;
        end
        else if(phiD_step15 >= $signed(18'd14336)) begin //Why not? phiD_step16[16:14] == 3'b111 
        //else if(phiD_step15 >= $signed(18'd114688)) begin //Why not? phiD_step16[16:14] == 3'b111 
            //phiD    <= (phiD_step15 - $signed(18'd98304));//Subtract Sector width from phi to map to adjecent sector
            phiD    <= (phiD_step15 - $signed(18'd12288));//Subtract Sector width from phi to map to adjecent sector
            pre_valid_projMinus <= 1'b0;
            pre_valid_proj <= 1'b0;
            pre_valid_projPlus <= 1'b1;
        end
        else begin
            phiD    <= phiD_step15;
            pre_valid_projMinus <= 1'b0;
            pre_valid_proj <= 1'b1;
            pre_valid_projPlus <= 1'b0;
        end
    end

endmodule
