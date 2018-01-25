//MT Jan 22: copied from clk_wiz_0_clk_wiz.v in the synthesis of clk wizard IP core generated with the parameters below
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1___480.000______0.000______50.0_______78.403_____84.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________240.000____________0.010

`timescale 1ps/1ps

module MMCM

   (// Clock in ports
      input         clk_in1,
      // Clock out ports
      output        clk_out1,
      // Status and control signals
      input         reset,
      output        locked
    );


   wire 	    clk_in1_clk_wiz_0;

   wire clk_in2_clk_wiz_0;

   IBUF clkin1_ibufg
       (.O (clk_in1_clk_wiz_0),
	.I (clk_in1));



   // Clocking PRIMITIVE
   //------------------------------------

   // Instantiation of the MMCM PRIMITIVE
   //    * Unused inputs are tied off
   //    * Unused outputs are labeled unused

   wire clk_out1_clk_wiz_0;

   wire clk_out2_clk_wiz_0;

   wire clk_out3_clk_wiz_0;

   wire clk_out4_clk_wiz_0;

   wire clk_out5_clk_wiz_0;

   wire clk_out6_clk_wiz_0;

   wire clk_out7_clk_wiz_0;


   wire [15:0] do_unused;

   wire        drdy_unused;
   
   wire        psdone_unused;

   wire        locked_int;

   wire        clkfbout_clk_wiz_0;

   wire        clkfbout_buf_clk_wiz_0;

   wire        clkfboutb_unused;

   wire        clkout0b_unused;

   wire        clkout1_unused;

   wire        clkout1b_unused;

   wire        clkout2_unused;

   wire        clkout2b_unused;

   wire        clkout3_unused;

   wire        clkout3b_unused;

   wire        clkout4_unused;

   wire        clkout5_unused;

   wire        clkout6_unused;

   wire        clkfbstopped_unused;

   wire        clkinstopped_unused;

   wire        reset_high;


   MMCME2_ADV
     #(.BANDWIDTH            ("OPTIMIZED"),
       .CLKOUT4_CASCADE      ("FALSE"),
       .COMPENSATION         ("ZHOLD"),
       .STARTUP_WAIT         ("FALSE"),
       .DIVCLK_DIVIDE        (1),
       .CLKFBOUT_MULT_F      (4.250),
       .CLKFBOUT_PHASE       (0.000),
       .CLKFBOUT_USE_FINE_PS ("FALSE"),
       .CLKOUT0_DIVIDE_F     (2.125),
       .CLKOUT0_PHASE        (0.000),
       .CLKOUT0_DUTY_CYCLE   (0.500),
       .CLKOUT0_USE_FINE_PS  ("FALSE"),
       .CLKIN1_PERIOD        (4.166))
   mmcm_adv_inst
     // Output clocks
     (
      .CLKFBOUT            (clkfbout_clk_wiz_0),
      .CLKFBOUTB           (clkfboutb_unused),
      .CLKOUT0             (clk_out1_clk_wiz_0),
      .CLKOUT0B            (clkout0b_unused),
      .CLKOUT1             (clkout1_unused),
      .CLKOUT1B            (clkout1b_unused),
      .CLKOUT2             (clkout2_unused),
      .CLKOUT2B            (clkout2b_unused),
      .CLKOUT3             (clkout3_unused),
      .CLKOUT3B            (clkout3b_unused),
      .CLKOUT4             (clkout4_unused),
      .CLKOUT5             (clkout5_unused),
      .CLKOUT6             (clkout6_unused),
      // Input clock control
      .CLKFBIN             (clkfbout_buf_clk_wiz_0),
      .CLKIN1              (clk_in1_clk_wiz_0),
      .CLKIN2              (1'b0),
      // Tied to always select the primary input clock
      .CLKINSEL            (1'b1),
      // Ports for dynamic reconfiguration
      .DADDR               (7'h0),
      .DCLK                (1'b0),
      .DEN                 (1'b0),
      .DI                  (16'h0),
      .DO                  (do_unused),
      .DRDY                (drdy_unused),
      .DWE                 (1'b0),
      // Ports for dynamic phase shift
      .PSCLK               (1'b0),
      .PSEN                (1'b0),
      .PSINCDEC            (1'b0),
      .PSDONE              (psdone_unused),
      // Other control and status signals
      .LOCKED              (locked_int),
      .CLKINSTOPPED        (clkinstopped_unused),
      .CLKFBSTOPPED        (clkfbstopped_unused),
      .PWRDWN              (1'b0),
      .RST                 (reset_high));


   assign reset_high = reset;


   assign locked = locked_int;

   // Clock Monitor clock assigning
   //--------------------------------------
   // Output buffering
   //-----------------------------------

   BUFG clkf_buf
     (.O (clkfbout_buf_clk_wiz_0),
      .I (clkfbout_clk_wiz_0));




   BUFG clkout1_buf
     (.O   (clk_out1),
      .I   (clk_out1_clk_wiz_0));





endmodule
