----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2015 12:40:12 AM
-- Design Name: 
-- Module Name: timing_pulse_gen - timing_pulse_gen_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timing_pulse_gen is
    Port ( ref_clk_i : in STD_LOGIC;
           timing_pulse_o : out STD_LOGIC);
end timing_pulse_gen;

architecture timing_pulse_gen_arch of timing_pulse_gen is

begin


end timing_pulse_gen_arch;
