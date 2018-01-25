
-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_utils_pkg                                          
--                                                                            
--          Author: Ales Svetek 
--                                                                            
--         Version: 1.0                                                
--                                                                            
--     Description: 
--
--      References:                                               
--                                                                            
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
use IEEE.numeric_std.all;


--============================================================================
--                                                               Package Start
--============================================================================
package ctp7_utils_pkg is

  function log2ceil (n : integer) return integer;

  function log2floor (n : integer) return integer;

  component delay_line
    generic (
      G_DELAY      : integer;
      G_DATA_WIDTH : integer;
      G_SRL_STYLE  : string
      );
    port (
      clk      : in  std_logic;
      data_in  : in  std_logic_vector (G_DATA_WIDTH - 1 downto 0);
      data_out : out std_logic_vector (G_DATA_WIDTH - 1 downto 0)
      );
  end component delay_line;

  component delay_line_adj
    generic (
      REG_LENGTH : integer := 16;
      DATA_WIDTH : integer := 1
      );
    port (
      clk      : in  std_logic;
      delay    : in  std_logic_vector (log2ceil(REG_LENGTH) - 1 downto 0);
      data_in  : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
      data_out : out std_logic_vector (DATA_WIDTH - 1 downto 0)
      );
  end component delay_line_adj;

  component edge_detect
    generic
      (
        EDGE_DETECT_TYPE : string := "RISE"
        );
    port
      (
        clk  : in  std_logic;
        sig  : in  std_logic;
        edge : out std_logic
        );
  end component;

  component synchronizer
    generic (
      N_STAGES : integer := 2
      );
    port(
      clk_i   : in  std_logic;
      async_i : in  std_logic;
      sync_o  : out std_logic
      );
  end component;

  component pulse_sync_1_way is
    generic (
      N_STAGES : integer := 2
      );
    port (
      clk1_i           : in  std_logic;
      pulse_in_clk1_i  : in  std_logic;
      clk2_i           : in  std_logic;
      pulse_out_clk2_o : out std_logic
      );
  end component pulse_sync_1_way;

  component pulse_sync_2_way
    generic (
      N_STAGES : integer := 2);
    port(
      clk1_i           : in  std_logic;
      clk2_i           : in  std_logic;
      pulse_in_clk1_i  : in  std_logic;
      pulse_out_clk2_o : out std_logic;
      pulse_out_clk1_o : out std_logic
      );
  end component;

  component gp_counter_wRE
    generic (
      COUNTER_BIT_LENGTH : integer := 8
      );
    port(
      clk_i      : in  std_logic;
      rst_i      : in  std_logic;
      count_en_i : in  std_logic;
      count_o    : out std_logic_vector(COUNTER_BIT_LENGTH-1 downto 0)
      );
  end component;



  type t_slv_4_arr is array(integer range <>) of std_logic_vector(3 downto 0);
  type t_slv_5_arr is array(integer range <>) of std_logic_vector(4 downto 0);
  type t_slv_6_arr is array(integer range <>) of std_logic_vector(5 downto 0);
  type t_slv_7_arr is array(integer range <>) of std_logic_vector(6 downto 0);
  type t_slv_8_arr is array(integer range <>) of std_logic_vector(7 downto 0);
  type t_slv_12_arr is array(integer range <>) of std_logic_vector(11 downto 0);
  type t_slv_16_arr is array(integer range <>) of std_logic_vector(15 downto 0);
  type t_slv_32_arr is array(integer range <>) of std_logic_vector(31 downto 0);

  function addr_encode(ch_base_reg_addr, ch_base_addr_offset, ch_num, addr_width : integer) return std_logic_vector;


  constant C_CH0  : integer := 0;
  constant C_CH1  : integer := 1;
  constant C_CH2  : integer := 2;
  constant C_CH3  : integer := 3;
  constant C_CH4  : integer := 4;
  constant C_CH5  : integer := 5;
  constant C_CH6  : integer := 6;
  constant C_CH7  : integer := 7;
  constant C_CH8  : integer := 8;
  constant C_CH9  : integer := 9;
  constant C_CH10 : integer := 10;
  constant C_CH11 : integer := 11;
  constant C_CH12 : integer := 12;
  constant C_CH13 : integer := 13;
  constant C_CH14 : integer := 14;
  constant C_CH15 : integer := 15;
  constant C_CH16 : integer := 16;
  constant C_CH17 : integer := 17;
  constant C_CH18 : integer := 18;
  constant C_CH19 : integer := 19;
  constant C_CH20 : integer := 20;
  constant C_CH21 : integer := 21;
  constant C_CH22 : integer := 22;
  constant C_CH23 : integer := 23;
  constant C_CH24 : integer := 24;
  constant C_CH25 : integer := 25;
  constant C_CH26 : integer := 26;
  constant C_CH27 : integer := 27;
  constant C_CH28 : integer := 28;
  constant C_CH29 : integer := 29;
  constant C_CH30 : integer := 30;
  constant C_CH31 : integer := 31;
  constant C_CH32 : integer := 32;
  constant C_CH33 : integer := 33;
  constant C_CH34 : integer := 34;
  constant C_CH35 : integer := 35;
  constant C_CH36 : integer := 36;
  constant C_CH37 : integer := 37;
  constant C_CH38 : integer := 38;
  constant C_CH39 : integer := 39;
  constant C_CH40 : integer := 40;
  constant C_CH41 : integer := 41;
  constant C_CH42 : integer := 42;
  constant C_CH43 : integer := 43;
  constant C_CH44 : integer := 44;
  constant C_CH45 : integer := 45;
  constant C_CH46 : integer := 46;
  constant C_CH47 : integer := 47;
  constant C_CH48 : integer := 48;
  constant C_CH49 : integer := 49;
  constant C_CH50 : integer := 50;
  constant C_CH51 : integer := 51;
  constant C_CH52 : integer := 52;
  constant C_CH53 : integer := 53;
  constant C_CH54 : integer := 54;
  constant C_CH55 : integer := 55;
  constant C_CH56 : integer := 56;
  constant C_CH57 : integer := 57;
  constant C_CH58 : integer := 58;
  constant C_CH59 : integer := 59;
  constant C_CH60 : integer := 60;
  constant C_CH61 : integer := 61;
  constant C_CH62 : integer := 62;
  constant C_CH63 : integer := 63;

end ctp7_utils_pkg;

--============================================================================
--                                                          Package Body Start
--============================================================================
package body ctp7_utils_pkg is
  -- purpose: computes ceil(log2(n))
  function log2ceil (n : integer) return integer is
    variable m, p : integer;
  begin
    m := 0;
    p := 1;
    for i in 0 to n loop
      if p < n then
        m := m + 1;
        p := p * 2;
      end if;
    end loop;
    return m;
  end log2ceil;

  -- purpose: computes floor(log2(n))
  function log2floor (n : integer) return integer is
    variable m, p : integer;
  begin
    m := -1;
    p := 1;
    for i in 0 to n loop
      if p <= n then
        m := m + 1;
        p := p * 2;
      end if;
    end loop;
    return m;
  end log2floor;

  function addr_encode(ch_base_reg_addr, ch_base_addr_offset, ch_num, addr_width : integer) return std_logic_vector is

    variable v_tmp_slv : std_logic_vector(0 to addr_width-1);
    variable v_tmp_int : integer;

  begin

    v_tmp_int := ch_base_reg_addr + ch_base_addr_offset * ch_num;

    v_tmp_slv := std_logic_vector(to_unsigned(v_tmp_int, addr_width));
    return v_tmp_slv;

  end function addr_encode;

end ctp7_utils_pkg;
--============================================================================
--                                                            Package Body End
--============================================================================

