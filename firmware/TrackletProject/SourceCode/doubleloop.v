`timescale 1ns / 1ps

// Created by fizzim.pl version $Revision: 5.0 on 2015:11:25 at 10:45:32 (www.fizzim.com)

module double_loop (
  output reg [5:0] readadd1,
  output reg [5:0] readadd2,
  output wire valid,
  input wire clk,
  input wire [5:0] number1in,
  input wire [5:0] number2in,
  input wire reset 
);

  // state bits
  parameter 
  IDLE  = 3'b000, // extra=00 valid=0 
  DONE  = 3'b010, // extra=01 valid=0 
  READ1 = 3'b101, // extra=10 valid=0 
  READ2 = 3'b001; // extra=00 valid=1 

  reg [2:0] state;
  reg [2:0] nextstate;

  // comb always block
  always @* begin
    // Warning I2: Neither implied_loopback nor default_state_is_x attribute is set on state machine - defaulting to implied_loopback to avoid latches being inferred 
    nextstate = state; // default to hold value because implied_loopback is set
    case (state)
      IDLE : begin
        if (number1in==0 || number2in ==0) begin
          nextstate = IDLE;
        end
        else begin
          nextstate = READ1;
        end
      end
      DONE : begin
      end
      READ1: begin
        if (readadd1==(number1in-1'b1) && readadd2==(number2in-1'b1)) begin
          nextstate = DONE;
        end  
        else if (number2in ==1) begin
          nextstate = READ1;
        end
        else begin
          nextstate = READ2;
        end
      end
      READ2: begin
        if (readadd1==(number1in-1'b1) && readadd2==(number2in-1'b1)) begin
          nextstate = DONE;
        end
        else if (readadd2==(number2in-1'b1)) begin
          nextstate = READ1;
        end        
        else begin
          nextstate = READ2;
        end
      end
    endcase
  end

  // Assign reg'd outputs to state bits
  assign valid = state[0];

  // sequential always block
  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= IDLE;
    else
      state <= nextstate;
  end

  // datapath sequential always block
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      readadd1[5:0] <= 6'b111111;
      readadd2[5:0] <= 6'b111111;
    end
    else begin
      readadd1[5:0] <= 0; // default
      readadd2[5:0] <= 0; // default
      case (nextstate)
        IDLE : begin
          readadd1[5:0] <= 6'b111111;
          readadd2[5:0] <= 6'b111111;
        end
        DONE : begin
          readadd1[5:0] <= readadd1;
          readadd2[5:0] <= readadd2;
        end
        READ1: begin
          readadd1[5:0] <= readadd1[5:0] + 1;
          readadd2[5:0] <= 6'b0;
        end
        READ2: begin
          readadd1[5:0] <= readadd1;
          readadd2[5:0] <= readadd2 + 1'b1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [39:0] statename;
  always @* begin
    case (state)
      IDLE :
        statename = "IDLE";
      DONE :
        statename = "DONE";
      READ1:
        statename = "READ1";
      READ2:
        statename = "READ2";
      default:
        statename = "XXXXX";
    endcase
  end
  `endif

endmodule

