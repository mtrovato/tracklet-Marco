-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: tx_pattern_generator                                           
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
entity tx_pattern_generator is
  generic (
    g_LINK_ID : integer := 0
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
end tx_pattern_generator;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture tx_pattern_generator_arch of tx_pattern_generator is

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
  signal s_bc_cycle     : integer range 0 to 6;

  signal s_txdata    : std_logic_vector (31 downto 0);
  signal s_txcharisk : std_logic_vector (3 downto 0);


  signal s_data_valid : std_logic;
  
  signal c_link_id_bits : std_logic_vector(7 downto 0) :=   std_logic_vector(to_unsigned(g_LINK_ID, 8));
  
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
        if (s_bc_cycle = 6) then
          s_bc_cycle <= 0;
        end if;
      end if;
    end if;
  end process;

  p_data_valid : process(clk240_i) is
  begin
    if (rising_edge(clk240_i)) then
      data_valid_o <= s_data_valid;
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
        if (s_pb_eng_cycle = 6) then
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
              s_txdata    <= x"000000" & x"BC";
              s_txcharisk <= x"1";
              
            when 1 =>
              s_txdata    <=  x"00000" & bcid_i(11 downto 0);
              s_txcharisk <= x"0";
              
            when 2 =>
              s_txdata    <= x"C00FFEE0";
              s_txcharisk <= x"0";
              
            when 3 =>
              s_txdata    <= x"DEADC0DE";
              s_txcharisk <= x"0";
              
            when 4 =>
              s_txdata    <= x"12345678";
              s_txcharisk <= x"0";
            
            when 5 =>
              s_txdata    <= x"87654321";
              s_txcharisk <= x"0";
              
            when others =>
                s_txdata    <= tx_user_word_i;
              s_txcharisk <= x"0";
              
          end case;

          
        when st_bc_main =>
          case s_bc_cycle is
            when 0 =>
              s_txdata    <= x"000000" & x"3C";
               s_txcharisk <= x"1";
               
            when 1 =>
              s_txdata    <=  x"00000" & bcid_i(11 downto 0);
                s_txcharisk <= x"0";
                
              when 2 =>
                s_txdata    <= x"C0DE0001";
                s_txcharisk <= x"0";
                
              when 3 =>
                s_txdata    <= x"C0DE0002";
                s_txcharisk <= x"0";
                
              when 4 =>
                s_txdata    <= x"C0DE0003";
                s_txcharisk <= x"0";
                
              when 5 =>
                s_txdata    <= x"87654321";
                s_txcharisk <= x"0";
              
              when others =>
                s_txdata    <= tx_user_word_i;
                s_txcharisk <= x"0";
                
            end case;
          
        when others =>
          s_txdata    <= x"DEAD00BC";
          s_txcharisk <= x"1";

      end case;
      
    end if;
    
  end process;

  txdata_o    <= s_txdata;
  txcharisk_o <= s_txcharisk;

end tx_pattern_generator_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
