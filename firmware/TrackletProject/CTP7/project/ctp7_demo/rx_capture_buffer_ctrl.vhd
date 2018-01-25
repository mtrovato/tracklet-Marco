-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: rx_capture_buffer_ctrl                                        
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
--    Date Created: October 2014
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

library work;
use work.link_align_pkg.all;
use work.rx_capture_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity rx_capture_buffer_ctrl is
  port (
    clk_240_i : in std_logic;

    rst_i : in std_logic;

    link_aligned_data_arr_i : in t_link_aligned_data_arr(63 downto 0);

    rx_capture_ctrl_arr_i   : in  t_rx_capture_ctrl_arr(63 downto 0);
    rx_capture_status_arr_o : out t_rx_capture_status_arr(63 downto 0);

    bx_id_i    : in std_logic_vector (11 downto 0);

    BRAM_CTRL_CAP_RAM_0_addr : in  std_logic_vector (16 downto 0);
    BRAM_CTRL_CAP_RAM_0_clk  : in  std_logic;
    BRAM_CTRL_CAP_RAM_0_din  : in  std_logic_vector (31 downto 0);
    BRAM_CTRL_CAP_RAM_0_dout : out std_logic_vector (31 downto 0);
    BRAM_CTRL_CAP_RAM_0_en   : in  std_logic;
    BRAM_CTRL_CAP_RAM_0_rst  : in  std_logic;
    BRAM_CTRL_CAP_RAM_0_we   : in  std_logic_vector (3 downto 0);

    BRAM_CTRL_CAP_RAM_1_addr : in  std_logic_vector (16 downto 0);
    BRAM_CTRL_CAP_RAM_1_clk  : in  std_logic;
    BRAM_CTRL_CAP_RAM_1_din  : in  std_logic_vector (31 downto 0);
    BRAM_CTRL_CAP_RAM_1_dout : out std_logic_vector (31 downto 0);
    BRAM_CTRL_CAP_RAM_1_en   : in  std_logic;
    BRAM_CTRL_CAP_RAM_1_rst  : in  std_logic;
    BRAM_CTRL_CAP_RAM_1_we   : in  std_logic_vector (3 downto 0)

    );
end rx_capture_buffer_ctrl;

architecture rx_capture_buffer_ctrl_arch of rx_capture_buffer_ctrl is
--============================================================================
--                                                           Type declarations
--============================================================================
  type t_BRAM_dout_arr_32 is array (31 downto 0) of std_logic_vector(31 downto 0);

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_BRAM_dout_arr_32_0 : t_BRAM_dout_arr_32;
  signal s_BRAM_dout_arr_32_1 : t_BRAM_dout_arr_32;

  signal s_BRAM_CTRL_CAP_RAM_0_we : std_logic_vector(31 downto 0);
  signal s_BRAM_CTRL_CAP_RAM_1_we : std_logic_vector(31 downto 0);

  signal s_BRAM_CTRL_CAP_RAM_0_rst : std_logic_vector(31 downto 0);
  signal s_BRAM_CTRL_CAP_RAM_1_rst : std_logic_vector(31 downto 0);

--============================================================================
--                                                          Architecture begin
--============================================================================
begin

--============================================================================
--                                    Capture engine and BRAM for links 0 - 31
--============================================================================


  gen_rx_capture_buffer_0 : for i in 0 to 31 generate
    i_rx_capture_buffer_0_31 : entity work.rx_capture_buffer
      port map (
        clk_240_i => clk_240_i,
        rst_i     => rst_i,

        link_aligned_data_i => link_aligned_data_arr_i(i),

        rx_capture_ctrl_i   => rx_capture_ctrl_arr_i(i),
        rx_capture_status_o => rx_capture_status_arr_o(i),

        bx_id_i    => bx_id_i,
        
        BRAM_CTRL_CAP_RAM_addr => BRAM_CTRL_CAP_RAM_0_addr(11 downto 0),
        BRAM_CTRL_CAP_RAM_clk  => BRAM_CTRL_CAP_RAM_0_clk,
        BRAM_CTRL_CAP_RAM_din  => BRAM_CTRL_CAP_RAM_0_din,
        BRAM_CTRL_CAP_RAM_dout => s_BRAM_dout_arr_32_0(i),
        BRAM_CTRL_CAP_RAM_en   => BRAM_CTRL_CAP_RAM_0_en,
        BRAM_CTRL_CAP_RAM_rst  => s_BRAM_CTRL_CAP_RAM_0_rst(i),
        BRAM_CTRL_CAP_RAM_we   => s_BRAM_CTRL_CAP_RAM_0_we(i)
        );
  end generate;

  s_BRAM_CTRL_CAP_RAM_0_we(0)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"0") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(1)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"1") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(2)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"2") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(3)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"3") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(4)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"4") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(5)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"5") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(6)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"6") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(7)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"7") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(8)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"8") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(9)  <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"9") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(10) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"A") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(11) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"B") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(12) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"C") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(13) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"D") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(14) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"E") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(15) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '0' & x"F") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';

  s_BRAM_CTRL_CAP_RAM_0_we(16) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"0") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(17) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"1") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(18) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"2") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(19) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"3") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(20) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"4") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(21) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"5") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(22) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"6") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(23) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"7") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(24) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"8") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(25) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"9") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(26) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"A") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(27) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"B") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(28) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"C") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(29) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"D") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(30) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"E") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_0_we(31) <= '1' when ((BRAM_CTRL_CAP_RAM_0_addr(16 downto 12) = '1' & x"F") and (BRAM_CTRL_CAP_RAM_0_we = x"F")) else '0';


  process(BRAM_CTRL_CAP_RAM_0_addr(16 downto 12))
  begin

    s_BRAM_CTRL_CAP_RAM_0_rst <= (others => '1');

    case(BRAM_CTRL_CAP_RAM_0_addr(16 downto 12)) is
      when '0' & x"0" => s_BRAM_CTRL_CAP_RAM_0_rst(0) <= '0';
    when '0' & x"1" => s_BRAM_CTRL_CAP_RAM_0_rst(1)  <= '0';
    when '0' & x"2" => s_BRAM_CTRL_CAP_RAM_0_rst(2)  <= '0';
    when '0' & x"3" => s_BRAM_CTRL_CAP_RAM_0_rst(3)  <= '0';
    when '0' & x"4" => s_BRAM_CTRL_CAP_RAM_0_rst(4)  <= '0';
    when '0' & x"5" => s_BRAM_CTRL_CAP_RAM_0_rst(5)  <= '0';
    when '0' & x"6" => s_BRAM_CTRL_CAP_RAM_0_rst(6)  <= '0';
    when '0' & x"7" => s_BRAM_CTRL_CAP_RAM_0_rst(7)  <= '0';
    when '0' & x"8" => s_BRAM_CTRL_CAP_RAM_0_rst(8)  <= '0';
    when '0' & x"9" => s_BRAM_CTRL_CAP_RAM_0_rst(9)  <= '0';
    when '0' & x"A" => s_BRAM_CTRL_CAP_RAM_0_rst(10) <= '0';
    when '0' & x"B" => s_BRAM_CTRL_CAP_RAM_0_rst(11) <= '0';
    when '0' & x"C" => s_BRAM_CTRL_CAP_RAM_0_rst(12) <= '0';
    when '0' & x"D" => s_BRAM_CTRL_CAP_RAM_0_rst(13) <= '0';
    when '0' & x"E" => s_BRAM_CTRL_CAP_RAM_0_rst(14) <= '0';
    when '0' & x"F" => s_BRAM_CTRL_CAP_RAM_0_rst(15) <= '0';
    when '1' & x"0" => s_BRAM_CTRL_CAP_RAM_0_rst(16) <= '0';
    when '1' & x"1" => s_BRAM_CTRL_CAP_RAM_0_rst(17) <= '0';
    when '1' & x"2" => s_BRAM_CTRL_CAP_RAM_0_rst(18) <= '0';
    when '1' & x"3" => s_BRAM_CTRL_CAP_RAM_0_rst(19) <= '0';
    when '1' & x"4" => s_BRAM_CTRL_CAP_RAM_0_rst(20) <= '0';
    when '1' & x"5" => s_BRAM_CTRL_CAP_RAM_0_rst(21) <= '0';
    when '1' & x"6" => s_BRAM_CTRL_CAP_RAM_0_rst(22) <= '0';
    when '1' & x"7" => s_BRAM_CTRL_CAP_RAM_0_rst(23) <= '0';
    when '1' & x"8" => s_BRAM_CTRL_CAP_RAM_0_rst(24) <= '0';
    when '1' & x"9" => s_BRAM_CTRL_CAP_RAM_0_rst(25) <= '0';
    when '1' & x"A" => s_BRAM_CTRL_CAP_RAM_0_rst(26) <= '0';
    when '1' & x"B" => s_BRAM_CTRL_CAP_RAM_0_rst(27) <= '0';
    when '1' & x"C" => s_BRAM_CTRL_CAP_RAM_0_rst(28) <= '0';
    when '1' & x"D" => s_BRAM_CTRL_CAP_RAM_0_rst(29) <= '0';
    when '1' & x"E" => s_BRAM_CTRL_CAP_RAM_0_rst(30) <= '0';
    when others => s_BRAM_CTRL_CAP_RAM_0_rst(31) <= '0';

  end case;
end process;

gen_RAM_0_dout : for j in 0 to 31 generate
begin
  BRAM_CTRL_CAP_RAM_0_dout(j) <=
    s_BRAM_dout_arr_32_0(0)(j) or
    s_BRAM_dout_arr_32_0(1)(j) or
    s_BRAM_dout_arr_32_0(2)(j) or
    s_BRAM_dout_arr_32_0(3)(j) or
    s_BRAM_dout_arr_32_0(4)(j) or
    s_BRAM_dout_arr_32_0(5)(j) or
    s_BRAM_dout_arr_32_0(6)(j) or
    s_BRAM_dout_arr_32_0(7)(j) or
    s_BRAM_dout_arr_32_0(8)(j) or
    s_BRAM_dout_arr_32_0(9)(j) or
    s_BRAM_dout_arr_32_0(10)(j) or
    s_BRAM_dout_arr_32_0(11)(j) or
    s_BRAM_dout_arr_32_0(12)(j) or
    s_BRAM_dout_arr_32_0(13)(j) or
    s_BRAM_dout_arr_32_0(14)(j) or
    s_BRAM_dout_arr_32_0(15)(j) or
    s_BRAM_dout_arr_32_0(16)(j) or
    s_BRAM_dout_arr_32_0(17)(j) or
    s_BRAM_dout_arr_32_0(18)(j) or
    s_BRAM_dout_arr_32_0(19)(j) or
    s_BRAM_dout_arr_32_0(20)(j) or
    s_BRAM_dout_arr_32_0(21)(j) or
    s_BRAM_dout_arr_32_0(22)(j) or
    s_BRAM_dout_arr_32_0(23)(j) or
    s_BRAM_dout_arr_32_0(24)(j) or
    s_BRAM_dout_arr_32_0(25)(j) or
    s_BRAM_dout_arr_32_0(26)(j) or
    s_BRAM_dout_arr_32_0(27)(j) or
    s_BRAM_dout_arr_32_0(28)(j) or
    s_BRAM_dout_arr_32_0(29)(j) or
    s_BRAM_dout_arr_32_0(30)(j) or
    s_BRAM_dout_arr_32_0(31)(j);

end generate;


--============================================================================
--                                   Capture engine and BRAM for links 32 - 63
--============================================================================


  gen_rx_capture_buffer_1 : for i in 0 to 31 generate
    i_rx_capture_buffer_32_63 : entity work.rx_capture_buffer
      port map (
        clk_240_i => clk_240_i,
        rst_i     => rst_i,

        link_aligned_data_i => link_aligned_data_arr_i(i+32),

        rx_capture_ctrl_i   => rx_capture_ctrl_arr_i(i+32),
        rx_capture_status_o => rx_capture_status_arr_o(i+32),

        bx_id_i    => bx_id_i,

        BRAM_CTRL_CAP_RAM_addr => BRAM_CTRL_CAP_RAM_1_addr(11 downto 0),
        BRAM_CTRL_CAP_RAM_clk  => BRAM_CTRL_CAP_RAM_1_clk,
        BRAM_CTRL_CAP_RAM_din  => BRAM_CTRL_CAP_RAM_1_din,
        BRAM_CTRL_CAP_RAM_dout => s_BRAM_dout_arr_32_1(i),
        BRAM_CTRL_CAP_RAM_en   => BRAM_CTRL_CAP_RAM_1_en,
        BRAM_CTRL_CAP_RAM_rst  => s_BRAM_CTRL_CAP_RAM_1_rst(i),
        BRAM_CTRL_CAP_RAM_we   => s_BRAM_CTRL_CAP_RAM_1_we(i)
        );
  end generate;

  s_BRAM_CTRL_CAP_RAM_1_we(0)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"0") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(1)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"1") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(2)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"2") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(3)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"3") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(4)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"4") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(5)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"5") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(6)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"6") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(7)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"7") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(8)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"8") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(9)  <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"9") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(10) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"A") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(11) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"B") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(12) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"C") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(13) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"D") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(14) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"E") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(15) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '0' & x"F") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';

  s_BRAM_CTRL_CAP_RAM_1_we(16) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"0") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(17) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"1") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(18) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"2") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(19) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"3") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(20) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"4") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(21) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"5") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(22) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"6") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(23) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"7") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(24) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"8") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(25) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"9") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(26) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"A") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(27) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"B") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(28) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"C") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(29) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"D") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(30) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"E") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';
  s_BRAM_CTRL_CAP_RAM_1_we(31) <= '1' when ((BRAM_CTRL_CAP_RAM_1_addr(16 downto 12) = '1' & x"F") and (BRAM_CTRL_CAP_RAM_1_we = x"F")) else '0';


  process(BRAM_CTRL_CAP_RAM_1_addr(16 downto 12))
  begin

    s_BRAM_CTRL_CAP_RAM_1_rst <= (others => '1');

    case(BRAM_CTRL_CAP_RAM_1_addr(16 downto 12)) is
      when '0' & x"0" => s_BRAM_CTRL_CAP_RAM_1_rst(0) <= '0';
    when '0' & x"1" => s_BRAM_CTRL_CAP_RAM_1_rst(1)  <= '0';
    when '0' & x"2" => s_BRAM_CTRL_CAP_RAM_1_rst(2)  <= '0';
    when '0' & x"3" => s_BRAM_CTRL_CAP_RAM_1_rst(3)  <= '0';
    when '0' & x"4" => s_BRAM_CTRL_CAP_RAM_1_rst(4)  <= '0';
    when '0' & x"5" => s_BRAM_CTRL_CAP_RAM_1_rst(5)  <= '0';
    when '0' & x"6" => s_BRAM_CTRL_CAP_RAM_1_rst(6)  <= '0';
    when '0' & x"7" => s_BRAM_CTRL_CAP_RAM_1_rst(7)  <= '0';
    when '0' & x"8" => s_BRAM_CTRL_CAP_RAM_1_rst(8)  <= '0';
    when '0' & x"9" => s_BRAM_CTRL_CAP_RAM_1_rst(9)  <= '0';
    when '0' & x"A" => s_BRAM_CTRL_CAP_RAM_1_rst(10) <= '0';
    when '0' & x"B" => s_BRAM_CTRL_CAP_RAM_1_rst(11) <= '0';
    when '0' & x"C" => s_BRAM_CTRL_CAP_RAM_1_rst(12) <= '0';
    when '0' & x"D" => s_BRAM_CTRL_CAP_RAM_1_rst(13) <= '0';
    when '0' & x"E" => s_BRAM_CTRL_CAP_RAM_1_rst(14) <= '0';
    when '0' & x"F" => s_BRAM_CTRL_CAP_RAM_1_rst(15) <= '0';
    when '1' & x"0" => s_BRAM_CTRL_CAP_RAM_1_rst(16) <= '0';
    when '1' & x"1" => s_BRAM_CTRL_CAP_RAM_1_rst(17) <= '0';
    when '1' & x"2" => s_BRAM_CTRL_CAP_RAM_1_rst(18) <= '0';
    when '1' & x"3" => s_BRAM_CTRL_CAP_RAM_1_rst(19) <= '0';
    when '1' & x"4" => s_BRAM_CTRL_CAP_RAM_1_rst(20) <= '0';
    when '1' & x"5" => s_BRAM_CTRL_CAP_RAM_1_rst(21) <= '0';
    when '1' & x"6" => s_BRAM_CTRL_CAP_RAM_1_rst(22) <= '0';
    when '1' & x"7" => s_BRAM_CTRL_CAP_RAM_1_rst(23) <= '0';
    when '1' & x"8" => s_BRAM_CTRL_CAP_RAM_1_rst(24) <= '0';
    when '1' & x"9" => s_BRAM_CTRL_CAP_RAM_1_rst(25) <= '0';
    when '1' & x"A" => s_BRAM_CTRL_CAP_RAM_1_rst(26) <= '0';
    when '1' & x"B" => s_BRAM_CTRL_CAP_RAM_1_rst(27) <= '0';
    when '1' & x"C" => s_BRAM_CTRL_CAP_RAM_1_rst(28) <= '0';
    when '1' & x"D" => s_BRAM_CTRL_CAP_RAM_1_rst(29) <= '0';
    when '1' & x"E" => s_BRAM_CTRL_CAP_RAM_1_rst(30) <= '0';
    when others => s_BRAM_CTRL_CAP_RAM_1_rst(31) <= '0';

  end case;
end process;

gen_RAM_1_dout : for j in 0 to 31 generate
begin
  BRAM_CTRL_CAP_RAM_1_dout(j) <=
    s_BRAM_dout_arr_32_1(0)(j) or
    s_BRAM_dout_arr_32_1(1)(j) or
    s_BRAM_dout_arr_32_1(2)(j) or
    s_BRAM_dout_arr_32_1(3)(j) or
    s_BRAM_dout_arr_32_1(4)(j) or
    s_BRAM_dout_arr_32_1(5)(j) or
    s_BRAM_dout_arr_32_1(6)(j) or
    s_BRAM_dout_arr_32_1(7)(j) or
    s_BRAM_dout_arr_32_1(8)(j) or
    s_BRAM_dout_arr_32_1(9)(j) or
    s_BRAM_dout_arr_32_1(10)(j) or
    s_BRAM_dout_arr_32_1(11)(j) or
    s_BRAM_dout_arr_32_1(12)(j) or
    s_BRAM_dout_arr_32_1(13)(j) or
    s_BRAM_dout_arr_32_1(14)(j) or
    s_BRAM_dout_arr_32_1(15)(j) or
    s_BRAM_dout_arr_32_1(16)(j) or
    s_BRAM_dout_arr_32_1(17)(j) or
    s_BRAM_dout_arr_32_1(18)(j) or
    s_BRAM_dout_arr_32_1(19)(j) or
    s_BRAM_dout_arr_32_1(20)(j) or
    s_BRAM_dout_arr_32_1(21)(j) or
    s_BRAM_dout_arr_32_1(22)(j) or
    s_BRAM_dout_arr_32_1(23)(j) or
    s_BRAM_dout_arr_32_1(24)(j) or
    s_BRAM_dout_arr_32_1(25)(j) or
    s_BRAM_dout_arr_32_1(26)(j) or
    s_BRAM_dout_arr_32_1(27)(j) or
    s_BRAM_dout_arr_32_1(28)(j) or
    s_BRAM_dout_arr_32_1(29)(j) or
    s_BRAM_dout_arr_32_1(30)(j) or
    s_BRAM_dout_arr_32_1(31)(j);

end generate;

 end rx_capture_buffer_ctrl_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
