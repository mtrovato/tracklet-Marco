-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_ttc                                       
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

library UNISIM;
use UNISIM.VComponents.all;

use work.ctp7_utils_pkg.all;
use work.ttc_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity ctp7_ttc is
  port(

    clk_40_ttc_p_i : in std_logic;      -- TTC backplane clock signals
    clk_40_ttc_n_i : in std_logic;

    ttc_data_p_i : in std_logic;        -- TTC protocol backplane signals
    ttc_data_n_i : in std_logic;

    ttc_mmcm_ps_clk_i    : in std_logic;
    ttc_mmcm_ps_clk_en_i : in std_logic;

    mmcm_rst_i    : in  std_logic;
    mmcm_locked_o : out std_logic;
    
    ttc_l1a_enable_i : in std_logic;

    clk_40_bufg_o  : out std_logic;
    clk_240_bufg_o : out std_logic;
    clk_new_bufg_o : out std_logic;     --MT

    bc0_stat_rst_i : in  std_logic;
    bc0_stat_o     : out t_bc0_stat;

    local_timing_ref_o : out t_timing_ref;

  ttc_cmd_cnt_rst_i : in std_logic;
  ttc_cmd_cnt_o : out t_slv_32_arr(15 downto 0);
 
    ttc_cmd_o : out std_logic_vector(3 downto 0);
    l1a_o     : out std_logic;
    resync_o  : out std_logic;
    
    L1A_dly_i : in std_logic_vector(7 downto 0);


    bunch_ctr_o : out std_logic_vector(11 downto 0);
    evt_ctr_o   : out std_logic_vector(23 downto 0);
    orb_ctr_o   : out std_logic_vector(15 downto 0);

    tcc_err_cnt_rst_i : in  std_logic;  -- Err ctr reset           
    tcc_sinerr_ctr_o  : out std_logic_vector(15 downto 0);
    tcc_dberr_ctr_o   : out std_logic_vector(15 downto 0)
    );

end ctp7_ttc;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ctp7_ttc_arch of ctp7_ttc is

  component local_timing_ref_gen
    port (
      clk_240_i : in std_logic;
      bc0_i     : in std_logic;

      bc0_stat_rst_i : in  std_logic;
      bc0_stat_o     : out t_bc0_stat;

      local_timing_ref_o : out t_timing_ref
      );
  end component local_timing_ref_gen;

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_clk_40  : std_logic;
  signal s_clk_240 : std_logic;
  signal s_clk_new : std_logic;         --MT

  signal s_ttc_cmd, s_ttc_cmd_d1 : std_logic_vector(3 downto 0);
  signal s_ttc_l1a               : std_logic;

  signal s_l1a_event_cnt : std_logic_vector(23 downto 0);
  signal s_orbit_cnt     : std_logic_vector(15 downto 0);

  signal s_bc0_40, s_bc0_240       : std_logic;
  signal s_resync_40, s_resync_240 : std_logic;
  signal s_ec0_40, s_ec0_240       : std_logic;
  signal s_oc0_40, s_oc0_240       : std_logic;
  signal s_l1a_40, s_l1a_40_dX, s_l1a_240       : std_logic;
  
  signal s_local_timing_ref :  t_timing_ref;
  signal s_ttc_cmd_cnt :  t_slv_32_arr(15 downto 0);
  


--============================================================================
--                                                          Architecture begin
--============================================================================
begin

  i_ctp7_ttc_clocks : entity work.ctp7_ttc_clocks
    port map(
      clk_40_ttc_p_i       => clk_40_ttc_p_i,
      clk_40_ttc_n_i       => clk_40_ttc_n_i,
      mmcm_rst_i           => mmcm_rst_i,
      mmcm_locked_o        => mmcm_locked_o,
      ttc_mmcm_ps_clk_i    => ttc_mmcm_ps_clk_i,
      ttc_mmcm_ps_clk_en_i => ttc_mmcm_ps_clk_en_i,
      clk_40_bufg_o        => s_clk_40,
      clk_240_bufg_o       => s_clk_240,
      --MT
      clk_new_bufg_o       => s_clk_new       
      );

  i_ttc_cmd : entity work.ttc_cmd
    port map(
      clk_40_i             => s_clk_40,
      ttc_data_p_i         => ttc_data_p_i,
      ttc_data_n_i         => ttc_data_n_i,
      ttc_cmd_o            => s_ttc_cmd,
      ttc_l1a_o            => s_ttc_l1a,
      tcc_err_cnt_rst_i    => tcc_err_cnt_rst_i,
      ttc_err_single_cnt_o => tcc_sinerr_ctr_o,
      ttc_err_double_cnt_o => tcc_dberr_ctr_o
      );


  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (s_ttc_cmd = C_TTC_BGO_BC0) then
        s_bc0_40 <= '1';
      else
        s_bc0_40 <= '0';
      end if;

      if (s_ttc_cmd = C_TTC_BGO_RESYNC) then
        s_resync_40 <= '1';
      else
        s_resync_40 <= '0';
      end if;

      if (s_ttc_cmd = C_TTC_BGO_EC0_a or s_ttc_cmd = C_TTC_BGO_EC0_b) then
        s_ec0_40 <= '1';
      else
        s_ec0_40 <= '0';
      end if;

      if (s_ttc_cmd = C_TTC_BGO_OC0) then
        s_oc0_40 <= '1';
      else
        s_oc0_40 <= '0';
      end if;

      s_l1a_40     <= s_ttc_l1a and ttc_l1a_enable_i;
      s_ttc_cmd_d1 <= s_ttc_cmd;

    end if;
  end process;
  
  
    i_l1a_dly : delay_line_adj
    generic map (
      REG_LENGTH => 256,
      DATA_WIDTH => 1
      )
    port map(
      clk         => s_clk_40,
      delay       => L1A_dly_i,
      data_in(0)  => s_l1a_40,
      data_out(0) => s_l1a_40_dX
      );

  i_edge_detect_bc0 : edge_detect
    port map
    (
      clk  => s_clk_240,
      sig  => s_bc0_40,
      edge => s_bc0_240
      );

  i_edge_detect_resync : edge_detect
    port map
    (
      clk  => s_clk_240,
      sig  => s_resync_40,
      edge => s_resync_240
      );

  i_edge_detect_ec0 : edge_detect
    port map
    (
      clk  => s_clk_240,
      sig  => s_ec0_40,
      edge => s_ec0_240
      );

  i_edge_detect_oc0 : edge_detect
    port map
    (
      clk  => s_clk_240,
      sig  => s_oc0_40,
      edge => s_oc0_240
      );

  i_edge_detect_l1a : edge_detect
    port map
    (
      clk  => s_clk_240,
      sig  => s_l1a_40_dX,
      edge => s_l1a_240
      );

  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (s_oc0_40 = '1') then
        s_orbit_cnt <= (others => '0');
      elsif (s_bc0_40 = '1') then
        s_orbit_cnt <= std_logic_vector(unsigned(s_orbit_cnt) + 1);
      end if;

    end if;
  end process;

  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (s_ec0_40 = '1') then
        s_l1a_event_cnt <= (others => '0');
      elsif (s_l1a_40_dX = '1') then
        s_l1a_event_cnt <= std_logic_vector(unsigned(s_l1a_event_cnt) + 1);
      end if;

    end if;
  end process;

  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (ttc_cmd_cnt_rst_i = '1') then
        s_ttc_cmd_cnt(0) <= (others => '0');
      elsif (s_l1a_40_dX = '1') then
         s_ttc_cmd_cnt(0) <= std_logic_vector(unsigned( s_ttc_cmd_cnt(0)) + 1);
      end if;

    end if;
  end process;

  gen_ttc_cmd_cnt : for i in 1 to 15 generate
  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (ttc_cmd_cnt_rst_i = '1') then
        s_ttc_cmd_cnt(i) <= (others => '0');
      elsif (to_integer(unsigned(s_ttc_cmd_d1)) = i) then
         s_ttc_cmd_cnt(i) <= std_logic_vector(unsigned( s_ttc_cmd_cnt(i)) + 1);
      end if;

    end if;
  end process;
end generate;


  i_local_timing_ref_gen : local_timing_ref_gen
    port map (
      clk_240_i          => s_clk_240,
      bc0_i              => s_bc0_240,
      bc0_stat_rst_i     => bc0_stat_rst_i,
      bc0_stat_o         => bc0_stat_o,
      local_timing_ref_o => s_local_timing_ref
      );

  bunch_ctr_o        <= s_local_timing_ref.bcid;
  evt_ctr_o          <= s_l1a_event_cnt;
  orb_ctr_o          <= s_orbit_cnt;
  local_timing_ref_o <= s_local_timing_ref;
  ttc_cmd_o          <= s_ttc_cmd_d1;
  
  l1a_o              <= s_l1a_240 ;
  
  resync_o           <= s_resync_40;
  
  clk_40_bufg_o      <= s_clk_40;
  clk_240_bufg_o     <= s_clk_240;
  clk_new_bufg_o     <= s_clk_new; --MT
  ttc_cmd_cnt_o <= s_ttc_cmd_cnt;

end ctp7_ttc_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

