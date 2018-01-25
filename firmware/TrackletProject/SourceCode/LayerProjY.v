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
//    14 bits            kr =42.6666667 
//    rmeanL1	22.992	981 
//    rmeanL2	35.507  1515
//    rmeanL3	50.5    2155
//    rmeanL4	68.4    2918
//    rmeanL5	88.4    3772
//    rmeanL6	107.8   4599    
//////////////////////////////////////////////////////////////////////////////////
module LayerProjY#(
  parameter RP = 14'sd981                         // Specify Layer R offset.
)(
    input clk,
    input wire signed[15:0] x2,
    input wire signed[11:0] a2m,
    input wire signed[13:0] t,
    input wire signed[18:0] phi0,
    input wire signed[10:0] z0,
    output reg signed[18:0] phiL,
    output reg [11:0] zL,
    output reg valid_proj,
    output reg valid_projPlus,
    output reg valid_projMinus
    );
    
    
    reg signed [13:0] rp;
           
    always @(posedge clk) begin
        rp      <= RP;  
    end    
    
// Step 8: 
    
    reg signed [28:0] x1a;
    reg signed [28:0] x1a_pipe;
    wire signed [16:0] x1;
    reg signed [16:0] x1_pipe;
    
    always @(posedge clk) begin
        x1a      <= (RP * x2);
        x1a_pipe <= x1a;  
    end
    
        assign x1   =   x1a_pipe>>>12; // x1 = (x2 * rp)>>>12;

// Step 9: 
    
        reg signed [28:0] x8a;
        reg signed [28:0] x8a_pipe;
        wire signed [16:0] x8;
        reg signed [16:0] x8_pipe;
        reg signed[11:0] a2m_pipe;
        reg signed[11:0] pre_a2m;
    
        always @(posedge clk) begin
            x1_pipe <= x1;
            pre_a2m <= a2m;
            a2m_pipe <= pre_a2m;
            x8a      <= (x1_pipe * a2m_pipe);
            x8a_pipe <= x8a;
        end
    
        assign x8   =   x8a_pipe>>>8; //x8 = (x1 * a2m)>>>10; 
    
//Step 10:
        reg signed [33:0] x12a;
        reg signed [33:0] x12a_pipe;
        reg signed [30:0] x11a;
        reg signed [30:0] x11a_pipe;
        reg signed [26:0] x20a;
        reg signed [26:0] x20a_pipe;
        wire signed [9:0] x12;
        reg signed [9:0] x12_pipe;
        wire signed [16:0] x11;
        wire signed [14:0] x20;
        reg signed[13:0] t_pipe;
        reg signed[13:0] t_pipe2;
                          
        always @(posedge clk) begin
            x8_pipe <= x8;
            t_pipe <= t;
            t_pipe2 <= t_pipe;
            x12a     <=  (x8_pipe * x8_pipe);
            x12a_pipe <= x12a;
            x11a     <=  t_pipe2 * RP;
            x11a_pipe <= x11a; 
            
            x20a     <=  11'sd682 * x8_pipe;
            x20a_pipe <= x20a;
        end
            
        assign x12  =   x12a_pipe>>>24; //x12 = (x8 * x8)>>>24; 
        assign x11  =   x11a_pipe>>>7; //x11 = (rp * t)>>>7;
        assign x20  =   x20a_pipe>>>12; // x20 = (10'd682 * x8)>>>12;
    
        wire signed [16:0] x11_step12;
        //x11_step12 = x11 Delayed 1 clocks step 12 for eq x21 = (10'd682 * x11)>>>12;
                pipe_delay #(.STAGES(2), .WIDTH(17))
                       x11_pipe(.clk(clk),  .val_in(x11), .val_out(x11_step12));
                       
        wire signed [14:0] x20_step13;
        //x20_step13 = x20 Delayed 2 clocks step 13 for eq x22 = (x20 * x10)>>>6; 
                 pipe_delay #(.STAGES(5), .WIDTH(15))
                       x20_pipe(.clk(clk), .val_in(x20), .val_out(x20_step13));
    
//Step 11:
         reg signed [21:0] x10aa;
         reg signed [21:0] x10aa_pipe;
         wire signed [9:0] x10a;
                       
        always @(posedge clk) begin
            x12_pipe  <= x12;
            x10aa     <= x12_pipe*12'sd1466;
            x10aa_pipe <= x10aa; 
            end
            
        assign x10a  =   x10aa_pipe>>>12; //x10a = (x12*1466)>>>12;    
    
//Step 12:
          reg signed [11:0] x10;
          reg signed [11:0] x10_pipe;
          reg signed [27:0] x21a;
          reg signed [27:0] x21a_pipe;
          wire signed [15:0] x21;
          wire signed [15:0] x21_pipe;
                                 
        always @(posedge clk) begin
           x10     <= x10a + 11'd1536; //x10 = 1536 + x10a;
           x10_pipe <= x10;   
           x21a     <= x11_step12 * 11'sd682;
           x21a_pipe <= x21a; 
        end
                                            
        assign x21  =   x21a_pipe>>>12; //x21 = (10'd682 * x11)>>>12; 
   
//Step 13:
         reg signed [26:0] x22a;
         reg signed [26:0] x22a_pipe;
         reg signed [26:0] x23a;
         reg signed [26:0] x23a_pipe;
         wire signed [20:0] x22;
         wire signed [14:0] x23;
        
        pipe_delay #(.STAGES(3), .WIDTH(16))
            x21_dly(.clk(clk), .val_in(x21), .val_out(x21_pipe));
                                                                           
        always @(posedge clk) begin
            x22a     <= (x20_step13 * x10_pipe);  
            x23a     <= (x21_pipe * x10_pipe);
            x22a_pipe <= x22a;
            x23a_pipe <= x23a;
       end
                                                                         
       assign x22  =   x22a_pipe>>>6; //x22 = (x20 * x10)>>>6;
       assign x23  =   x23a_pipe>>>12; //x23 = (x21 * x10)>>>12; 

//Step 14:
    reg signed [18:0] phiLb;
    reg signed [18:0] phiLb_pipe;
    reg signed [15:0] zLa;
    reg [11:0] zLb;
    wire signed[18:0] phi0_pipe;
    wire signed[10:0] z0_pipe;
           
    pipe_delay #(.STAGES(9), .WIDTH(19)) phi0_pipe_dly(.clk(clk), .val_in(phi0), .val_out(phi0_pipe));
    pipe_delay #(.STAGES(9), .WIDTH(11)) z0_pipe_dly(.clk(clk), .val_in(z0), .val_out(z0_pipe));
           
           
    always @(posedge clk) begin
        phiLb       <=  phi0_pipe - x22; //phiL = phi0 - x22;
        phiLb_pipe  <=  phiLb;
        zLa         <=  z0_pipe + x23;   //zL = z0 + x23;
        zLb         <=  zLa[11:0];
        zL          <=  zLb;
    end                      
//       //Final output of zL delayed by one.
//                pipe_delay #(.STAGES(2), .WIDTH(12))
//                     zL_pipe(.clk(clk), .val_in(zLa), .val_out(zL));    

//Step 15:
    //if in inner layers (RP<2918) phi of proj is 14 bits
    //if in outer laters (RP>2155) phi of proj is 17 bits
    //is the following true about outer layers? ---only relevant are 16 though
    //compare the phiLa with the 1/2 of the bounds before shifting to do computation in one step
    //and then shift by the number of bits needed for each of the different layers
    always @(posedge clk) begin
        if(zLb > 2047 | zLb[10:4] == 7'b1111111) begin
            valid_projMinus <= 1'b0;
            valid_proj <= 1'b0;
            valid_projPlus <= 1'b0;
        end
        else if(phiLb_pipe < $signed(18'd16384)) begin  //Why not? phiLb[16:14] == 3'b000 
            phiL    <= (phiLb_pipe + 18'd98304);//Add Sector width to phi to map to adjecent sector
            valid_projMinus <= 1'b1;
            valid_proj <= 1'b0;
            valid_projPlus <= 1'b0;
        end
        else if(phiLb_pipe > $signed(18'd114687)) begin //Why not? phiLb[16:14] == 3'b111 
            phiL    <= (phiLb_pipe - 18'd98304);//Subtract Sector width from phi to map to adjecent sector
            valid_projMinus <= 1'b0;
            valid_proj <= 1'b0;
            valid_projPlus <= 1'b1;
        end
        else begin
            phiL    <= phiLb_pipe;
            valid_projMinus <= 1'b0;
            valid_proj <= 1'b1;
            valid_projPlus <= 1'b0;
        end
    end

endmodule
