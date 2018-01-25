-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: tx_protocol_wrapper                                           
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
entity tx_protocol_wrapper is
  generic (
    --g_LINK_ID : integer := 0;
    g_TIME_MUX : integer := 6
    );
  port (
    clk240_i     : in  std_logic;
    rst_i        : in  std_logic;
    tx_user_word_i  : in std_logic_vector (31 downto 0);
    data_valid_o : out std_logic;
    bc0_i        : in  std_logic;
    bcid_i       : in  std_logic_vector (11 downto 0);
    txdata_o     : out std_logic_vector (31 downto 0);
    txcharisk_o  : out std_logic_vector (3 downto 0)
    );
end tx_protocol_wrapper;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture tx_protocol_wrapper_arch of tx_protocol_wrapper is

--============================================================================
--                                                      Component declarations
--============================================================================
  component crc
  port(
    data_in   : in  std_logic_vector (31 downto 0);
    crc_en    : in  std_logic;
    rst       : in  std_logic;
    clk       : in  std_logic;
    crc_out   : out std_logic_vector (7 downto 0)
    );
  end component;

--============================================================================
--                                                           Type declarations
--============================================================================
  type t_pb_eng_state is
    (
      st_bc_zero,
      st_bc_main
      );

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_pb_eng_cs : t_pb_eng_state;
  signal s_pb_eng_ns : t_pb_eng_state;

  signal s_pb_eng_cycle : integer range 0 to 3564*6-1;
  signal s_bc_cycle     : integer range 0 to 6*g_TIME_MUX-1;

  signal s_txdata    : std_logic_vector (31 downto 0);
  signal s_txcharisk : std_logic_vector (3 downto 0);

  signal s_data_dly  : std_logic_vector (31 downto 0);
  signal s_txcharisk_dly : std_logic_vector (31 downto 0);

  signal s_data_valid : std_logic;
  
  --signal c_link_id_bits : std_logic_vector (7 downto 0) :=   std_logic_vector(to_unsigned(g_LINK_ID, 8));
  
  signal s_crc : std_logic_vector (7 downto 0);
  signal s_crc_en : std_logic;
  signal crc_en_i : std_logic;
  signal s_crc_rst: std_logic;
  signal crc_rst_i: std_logic;
  
--============================================================================
--                                                          Architecture begin
--============================================================================
  
begin

  p_fsm_current_state : process(clk240_i) is
  begin
    if (rising_edge(clk240_i)) then
      if (bc0_i = '1') then
        s_pb_eng_cs    <= st_bc_zero;
        s_pb_eng_cycle <= 0;
        s_bc_cycle     <= 0;
      else
        s_pb_eng_cs    <= s_pb_eng_ns;
        s_pb_eng_cycle <= s_pb_eng_cycle + 1;
        s_bc_cycle     <= s_bc_cycle + 1;
        if (s_bc_cycle = 6*g_TIME_MUX-1) then
          s_bc_cycle <= 0;
        end if;
      end if;
    end if;
  end process;

  p_data_valid : process(clk240_i) is
  begin
    if (rising_edge(clk240_i)) then
      data_valid_o <= s_data_valid;
      crc_en_i <= s_data_valid;
      if (rst_i = '1') then
        s_data_valid <= '0';
      elsif (bc0_i = '1') then
        s_data_valid <= '1';
      end if;
    end if;
  end process;

  p_fsm_next_state : process(s_pb_eng_cs, s_pb_eng_cycle, s_bc_cycle) is
  begin

    s_pb_eng_ns <= s_pb_eng_cs;

    case s_pb_eng_cs is
      
      when st_bc_zero =>
        if (s_pb_eng_cycle = 6*g_TIME_MUX-1) then
          s_pb_eng_ns <= st_bc_main;
        end if;
        
      when st_bc_main =>

      when others =>
        s_pb_eng_ns <= st_bc_zero;

    end case;
    
  end process;

  p_output_asssign_and_register : process(clk240_i) is
  begin
    if (rising_edge(clk240_i)) then

      case s_pb_eng_cs is
        when st_bc_zero =>
          case s_bc_cycle is
            when 0 =>
              --s_txdata    <= bcid_i(11 downto 0) & x"000" & x"BC";
              s_txdata    <= x"000000" & x"BC";
              s_txcharisk <= x"1";
              crc_rst_i <= '0';
              
            when 6*g_TIME_MUX-1 =>
              s_txdata    <= tx_user_word_i(31 downto 0);
              s_txcharisk <= x"0";
              crc_rst_i <= '1';

            when others =>
              s_txdata    <= tx_user_word_i(31 downto 0);
              s_txcharisk <= x"0";
              crc_rst_i <= '0';
              
          end case;

          
        when st_bc_main =>
          case s_bc_cycle is
            when 0 =>
              --s_txdata    <= bcid_i(11 downto 0) & x"000" & x"3C";
              s_txdata    <= x"000000" & x"3C";
              s_txcharisk <= x"1";
              crc_rst_i <= '0';
              
            when 6*g_TIME_MUX-1 =>
              s_txdata    <= tx_user_word_i(31 downto 0);
              s_txcharisk <= x"0";
              crc_rst_i <= '1';
               
            when others =>
              s_txdata    <= tx_user_word_i(31 downto 0);
              s_txcharisk <= x"0";
              crc_rst_i <= '0';
                
          end case;
   
          
        when others =>
          s_txdata    <= x"DEAD00BC";
          s_txcharisk <= x"1";
          crc_rst_i <= '1';

      end case;
      
    end if;
    
  end process;
  
--  s_crc_rst <= crc_rst_i or bc0_i;
--  s_crc_en  <= crc_en_i or bc0_i;
  
--  i_crc_calculator : crc
--  port map (
--    data_in => s_txdata,
--    crc_en => s_crc_en,
--    rst => s_crc_rst,
--    clk => clk240_i,
--    crc_out => s_crc
--  );

--  p_data_output : process(clk240_i) is
--  begin
--    if (rising_edge(clk240_i)) then
--      case s_bc_cycle is
--        when 0 =>
--          txdata_o <= s_txdata(31 downto 8) & s_crc(7 downto 0);
--          txcharisk_o <= s_txcharisk;
--        when others =>
          txdata_o    <= s_txdata;
          txcharisk_o <= s_txcharisk;
--      end case;
--    end if;
--  end process;

end tx_protocol_wrapper_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
