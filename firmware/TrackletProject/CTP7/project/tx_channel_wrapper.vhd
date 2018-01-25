-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: tx_channel_wrapper_proj                                           
--                                                                            
--
--                                                                            
--                                                                            
--     Description: 
--
--      References:                                               
--                                                                            
-------------------------------------------------------------------------------
--    Date Created: August 2015
-------------------------------------------------------------------------------                                                                      
--  
--    Last Changes:                                                           
--                                                                            
-------------------------------------------------------------------------------
--                                                                            
--           Notes:                                                           
--                                                                            
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
--                                                          Entity declaration
--============================================================================  
entity tx_channel_wrapper is
  port (
    clk240_i       : in  std_logic;
    clk250_i       : in  std_logic;
    rst_i          : in  std_logic;
    bc0_i          : in  std_logic;
    bcid_i         : in  std_logic_vector (11 downto 0);
    tx_datastream_i    : in  std_logic_vector (63 downto 0);
    txdata_H_o     : out std_logic_vector(31 downto 0);
    txcharisk_H_o  : out std_logic_vector(3 downto 0);
    txdata_L_o     : out std_logic_vector(31 downto 0);
    txcharisk_L_o  : out std_logic_vector(3 downto 0)
    );
end tx_channel_wrapper;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture tx_channel_wrapper_arch of tx_channel_wrapper is

--============================================================================
--                                                      Component declarations
--============================================================================
component tx_link_driver 
  port (
    clk240_i       : in  std_logic;
    clk250_i       : in  std_logic;
    rst_i          : in  std_logic;
    bc0_i          : in  std_logic;
    tx_user_word_i : in  std_logic_vector (31 downto 0);
    bcid_i         : in  std_logic_vector (11 downto 0);
    txdata_o       : out std_logic_vector(31 downto 0);
    txcharisk_o    : out std_logic_vector(3 downto 0)
  );
end component;

--============================================================================
--                                                         Signal declarations
--============================================================================


--============================================================================
--                                                          Architecture begin
--============================================================================

begin

  i_tx_link_driver_1 : entity work.tx_link_driver
    port map (
      clk240_i       => clk240_i,
      clk250_i       => clk250_i,
      rst_i          => rst_i,
      tx_user_word_i => tx_datastream_i(63 downto 32),
      bc0_i          => bc0_i,
      bcid_i         => bcid_i,
      txdata_o       => txdata_H_o,
      txcharisk_o    => txcharisk_H_o
      );
      
  i_tx_link_driver_2 : entity work.tx_link_driver
    port map (
      clk240_i       => clk240_i,
      clk250_i       => clk250_i,
      rst_i          => rst_i,
      tx_user_word_i => tx_datastream_i(31 downto 0),
      bc0_i          => bc0_i,
      bcid_i         => bcid_i,
      txdata_o       => txdata_L_o,
      txcharisk_o    => txcharisk_L_o
      ); 

end tx_channel_wrapper_arch;
--============================================================================
--                                                            Architecture end
--============================================================================