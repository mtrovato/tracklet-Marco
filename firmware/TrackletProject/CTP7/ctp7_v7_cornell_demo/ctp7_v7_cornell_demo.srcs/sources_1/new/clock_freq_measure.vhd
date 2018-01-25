----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2015 12:40:12 AM
-- Design Name: 
-- Module Name: clock_freq_measure - clock_freq_measure_arch
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

entity clock_freq_measure is
    Port ( ref_clk_i : in STD_LOGIC;
           measured_clk_i : in STD_LOGIC;
           frequency_khz_o : out STD_LOGIC_VECTOR (19 downto 0));
end clock_freq_measure;

architecture clock_freq_measure_arch of clock_freq_measure is

begin


end clock_freq_measure_arch;
