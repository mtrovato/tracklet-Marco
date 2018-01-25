`timescale 1ns / 1ps

// Created by fizzim.pl version $Revision: 5.0 on 2016:05:17 at 14:52:19 (www.fizzim.com)

module read_mems (
  output reg [5:0] read_add1,
  output reg [5:0] read_add2,
  output reg [5:0] read_add3,
  output reg [5:0] read_add4,
  output reg [5:0] read_add5,
  output reg [5:0] read_add6,
  output reg [5:0] read_add7,
  output reg valid_3,
  output reg valid_4,
  output reg valid_5,
  output reg valid_6,
  output reg valid_7,
  output reg valid_minus,
  output reg valid_plus,
  input wire clk,
  input wire [5:0] number_in1,
  input wire [5:0] number_in2,
  input wire [5:0] number_in3,
  input wire [5:0] number_in4,
  input wire [5:0] number_in5,
  input wire [5:0] number_in6,
  input wire [5:0] number_in7,
  input wire reset 
);

  // state bits
  parameter 
  IDLE      = 4'b0000, 
  DONE      = 4'b0001, 
  READ_MEM1 = 4'b0010, 
  READ_MEM2 = 4'b0011, 
  READ_MEM3 = 4'b0100, 
  READ_MEM4 = 4'b0101, 
  READ_MEM5 = 4'b0110, 
  READ_MEM6 = 4'b0111, 
  READ_MEM7 = 4'b1000; 

  reg [3:0] state;
  reg [3:0] nextstate;

  // comb always block
  always @* begin
    // Warning I2: Neither implied_loopback nor default_state_is_x attribute is set on state machine - defaulting to implied_loopback to avoid latches being inferred 
    nextstate = state; // default to hold value because implied_loopback is set
    case (state)
      IDLE     : begin
        if (read_add3 != 0) begin
          nextstate = READ_MEM3;
        end
        else if (read_add4 != 0) begin
          nextstate = READ_MEM4;
        end
        else if (read_add5 != 0) begin
          nextstate = READ_MEM5;
        end
        else if (read_add6 != 0) begin
          nextstate = READ_MEM6;
        end
        else if (read_add7 != 0) begin
          nextstate = READ_MEM7;
        end
        else if (read_add2 != 0) begin
          nextstate = READ_MEM2;
        end
        else if (read_add1 != 0) begin
          nextstate = READ_MEM1;
        end
        else begin
          nextstate = IDLE;
        end
      end
      DONE     : begin
        if (read_add4 !=0) begin
          nextstate = READ_MEM4;
        end
        else if (read_add5 != 0) begin
          nextstate = READ_MEM5;
        end
        else if (read_add6 != 0) begin
          nextstate = READ_MEM6;
        end
        else if (read_add7 != 0) begin
          nextstate = READ_MEM7;
        end
        else if (read_add2 != 0) begin
          nextstate = READ_MEM2;
        end
        else if (read_add1 != 0) begin
          nextstate = READ_MEM1;
        end
        else begin
          nextstate = DONE;
        end
      end
      READ_MEM1: begin
        if (read_add1 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM1;
        end
      end
      READ_MEM2: begin
        if (read_add2 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM2;
        end
      end
      READ_MEM3: begin
        if (read_add3 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM3;
        end
      end
      READ_MEM4: begin
        if (read_add4 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM4;
        end
      end
      READ_MEM5: begin
        if (read_add5 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM5;
        end
      end
      READ_MEM6: begin
        if (read_add6 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM6;
        end
      end
      READ_MEM7: begin
        if (read_add7 == 0) begin
          nextstate = DONE;
        end
        else begin
          nextstate = READ_MEM7;
        end
      end
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(posedge clk) begin
    if (reset)
      state <= IDLE;
    else
      state <= nextstate;
  end

  // datapath sequential always block
  always @(posedge clk) begin
    if (reset) begin
      // Warning R18: No reset value set for datapath output read_add1[5:0].   Assigning a reset value of number_in1 based on value in reset state IDLE 
      read_add1[5:0] <= number_in1;
      // Warning R18: No reset value set for datapath output read_add2[5:0].   Assigning a reset value of number_in2 based on value in reset state IDLE 
      read_add2[5:0] <= number_in2;
      // Warning R18: No reset value set for datapath output read_add3[5:0].   Assigning a reset value of number_in3 based on value in reset state IDLE 
      read_add3[5:0] <= number_in3;
      // Warning R18: No reset value set for datapath output read_add4[5:0].   Assigning a reset value of number_in4 based on value in reset state IDLE 
      read_add4[5:0] <= number_in4;
      // Warning R18: No reset value set for datapath output read_add5[5:0].   Assigning a reset value of number_in5 based on value in reset state IDLE 
      read_add5[5:0] <= number_in5;
      // Warning R18: No reset value set for datapath output read_add5[5:0].   Assigning a reset value of number_in5 based on value in reset state IDLE 
      read_add6[5:0] <= number_in6;
      // Warning R18: No reset value set for datapath output read_add5[5:0].   Assigning a reset value of number_in5 based on value in reset state IDLE 
      read_add7[5:0] <= number_in7;
      // Warning R18: No reset value set for datapath output valid_3.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_3 <= 0;
      // Warning R18: No reset value set for datapath output valid_4.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_4 <= 0;
      // Warning R18: No reset value set for datapath output valid_5.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_5 <= 0;
      // Warning R18: No reset value set for datapath output valid_5.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_6 <= 0;
      // Warning R18: No reset value set for datapath output valid_5.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_7 <= 0;
      // Warning R18: No reset value set for datapath output valid_minus.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_minus <= 0;
      // Warning R18: No reset value set for datapath output valid_plus.   Assigning a reset value of 0 based on value in reset state IDLE 
      valid_plus <= 0;
    end
    else begin
//      read_add1[5:0] <= number_in1; // default
//      read_add2[5:0] <= number_in2; // default
//      read_add3[5:0] <= number_in3; // default
//      read_add4[5:0] <= number_in4; // default
//      read_add5[5:0] <= number_in5; // default
//      read_add6[5:0] <= number_in6; // default
//      read_add7[5:0] <= number_in7; // default
      valid_3 <= 0; // default
      valid_4 <= 0; // default
      valid_5 <= 0; // default
      valid_6 <= 0; // default
      valid_7 <= 0; // default
      valid_minus <= 0; // default
      valid_plus <= 0; // default
      case (nextstate)
        DONE     : begin
          read_add1[5:0] <= read_add1;
          read_add2[5:0] <= read_add2;
          read_add3[5:0] <= read_add3;
          read_add4[5:0] <= read_add4;
          read_add5[5:0] <= read_add5;
          read_add6[5:0] <= read_add6;
          read_add7[5:0] <= read_add7;
        end
        READ_MEM1: begin
          read_add1[5:0] <= read_add1-1;
          valid_plus <= 1;
        end
        READ_MEM2: begin
          read_add2[5:0] <= read_add2-1;
          valid_minus <= 1;
        end
        READ_MEM3: begin
          read_add3[5:0] <= read_add3-1;
          valid_3 <= 1;
        end
        READ_MEM4: begin
          read_add4[5:0] <= read_add4-1;
          valid_4 <= 1;
        end
        READ_MEM5: begin
          read_add5[5:0] <= read_add5 -1;
          valid_5 <= 1;
        end
        READ_MEM6: begin
          read_add6[5:0] <= read_add6 -1;
          valid_6 <= 1;
        end
        READ_MEM7: begin
          read_add7[5:0] <= read_add7 -1;
          valid_7 <= 1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [71:0] statename;
  always @* begin
    case (state)
      IDLE     :
        statename = "IDLE";
      DONE     :
        statename = "DONE";
      READ_MEM1:
        statename = "READ_MEM1";
      READ_MEM2:
        statename = "READ_MEM2";
      READ_MEM3:
        statename = "READ_MEM3";
      READ_MEM4:
        statename = "READ_MEM4";
      READ_MEM5:
        statename = "READ_MEM5";
      READ_MEM6:
        statename = "READ_MEM6";
      READ_MEM7:
        statename = "READ_MEM7";
      default  :
        statename = "XXXXXXXXX";
    endcase
  end
  `endif

endmodule

