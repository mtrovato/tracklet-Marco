`timescale 1ns / 1ps
// Created by fizzim.pl version $Revision: 5.0 on 2015:12:02 at 10:29:25 (www.fizzim.com)

module best_match (
  output wire valid,
  input wire clk,
  input wire new_tracklet,
  input wire pre_valid,
  input wire reset,
  input wire start 
);

  // state bits
  parameter 
  IDLE  = 2'b00, // extra=0 valid=0 
  PROC  = 2'b10, // extra=1 valid=0 
  VALID = 2'b01; // extra=0 valid=1 

  reg [1:0] state;
  reg [1:0] nextstate;

  // comb always block
  always @* begin
    // Warning I2: Neither implied_loopback nor default_state_is_x attribute is set on state machine - defaulting to implied_loopback to avoid latches being inferred 
    nextstate = state; // default to hold value because implied_loopback is set
    case (state)
      IDLE : begin
        if (new_tracklet) begin
          nextstate = PROC;
        end
        else begin
          nextstate = IDLE;
        end
      end
      PROC : begin
        if (new_tracklet) begin
          nextstate = VALID;
        end
        else begin
          nextstate = PROC;
        end
      end
      VALID: begin
        if (new_tracklet) begin
          nextstate = VALID;
        end
        else begin
          nextstate = PROC;
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

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [39:0] statename;
  always @* begin
    case (state)
      IDLE :
        statename = "IDLE";
      PROC :
        statename = "PROC";
      VALID:
        statename = "VALID";
      default:
        statename = "XXXXX";
    endcase
  end
  `endif

endmodule

