-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: tx_link_driver                                           
--                                                                            
--          Author: Ales Svetek  
-- 
--         Company: University of Wisconsin - Madison High Energy Physics
--
--                                                                            
--                                                                            
--     Description: 
--
--      References:                                               
--                                                                            
-------------------------------------------------------------------------------
--    Date Created: June 2014
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
entity tx_link_driver is
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
end tx_link_driver;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture tx_link_driver_arch of tx_link_driver is

--============================================================================
--                                                      Component declarations
--============================================================================
  component tx_protocol_wrapper
    generic (
      --g_LINK_ID : integer := 0
      g_TIME_MUX : integer := 6
      );
    port(
      clk240_i       : in  std_logic;
      bc0_i          : in  std_logic;
      rst_i          : in  std_logic;
      tx_user_word_i : in  std_logic_vector (31 downto 0);
      data_valid_o   : out std_logic;
      bcid_i         : in  std_logic_vector(11 downto 0);
      txdata_o       : out std_logic_vector(31 downto 0);
      txcharisk_o    : out std_logic_vector(3 downto 0)
      );
  end component;

  component upclock_link_fifo is
    port (
      wr_clk : in  std_logic;
      rd_clk : in  std_logic;
      rst    : in  std_logic;
      wr_en  : in  std_logic;
      rd_en  : in  std_logic;
      din    : in  std_logic_vector(35 downto 0);
      dout   : out std_logic_vector(35 downto 0);
      full   : out std_logic;
      empty  : out std_logic
      );
  end component;

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_data_valid         : std_logic;
  signal s_upclock_fifo_empty : std_logic;
  signal s_upclock_fifo_rd    : std_logic;

  signal s_upclock_fifo_in  : std_logic_vector(35 downto 0);
  signal s_upclock_fifo_out : std_logic_vector(35 downto 0);

  signal s_pb_txdata    : std_logic_vector(31 downto 0);
  signal s_pb_txcharisk : std_logic_vector(3 downto 0);

--============================================================================
--                                                          Architecture begin
--============================================================================

begin

  i_tx_protocol_wrapper : tx_protocol_wrapper
    port map (
      clk240_i       => clk240_i,
      bc0_i          => bc0_i,
      rst_i          => rst_i,
      tx_user_word_i => tx_user_word_i,
      bcid_i         => bcid_i,
      data_valid_o   => s_data_valid,
      txdata_o       => s_pb_txdata,
      txcharisk_o    => s_pb_txcharisk
      );

  s_upclock_fifo_in(31 downto 0)  <= s_pb_txdata    when rising_edge(clk240_i);
  s_upclock_fifo_in(35 downto 32) <= s_pb_txcharisk when rising_edge(clk240_i);

  i_upclock_link_fifo : upclock_link_fifo
    port map (
      wr_clk => clk240_i,
      rd_clk => clk250_i,
      rst    => rst_i,
      wr_en  => s_data_valid,
      rd_en  => s_upclock_fifo_rd,
      din    => s_upclock_fifo_in,
      dout   => s_upclock_fifo_out,
      full   => open,
      empty  => s_upclock_fifo_empty
      );

  s_upclock_fifo_rd <= not s_upclock_fifo_empty;

  process(clk250_i) is
  begin
    if rising_edge(clk250_i) then

      if (s_upclock_fifo_empty = '1') then
        txdata_o    <= x"F7F7F7F7";     -- padding/filler word
        txcharisk_o <= x"F";            -- padding/filler k-char bits
      else
        txdata_o    <= s_upclock_fifo_out(31 downto 0);
        txcharisk_o <= s_upclock_fifo_out(35 downto 32);
      end if;

    end if;
  end process;

end tx_link_driver_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

