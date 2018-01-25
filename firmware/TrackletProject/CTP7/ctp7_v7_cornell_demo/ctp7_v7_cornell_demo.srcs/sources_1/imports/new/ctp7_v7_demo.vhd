-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_v7_s1                                         
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
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

use work.ctp7_utils_pkg.all;

use work.gth_pkg.all;
use work.link_align_pkg.all;
use work.rx_capture_pkg.all;
use work.ttc_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity ctp7_v7_demo is
  generic (
    C_DATE_CODE      : std_logic_vector (31 downto 0) := x"00000000";
    C_GITHASH_CODE   : std_logic_vector (31 downto 0) := x"00000000";
    C_GIT_REPO_DIRTY : std_logic                      := '0'
    );
  port (
    clk_200_diff_in_clk_p : in std_logic;
    clk_200_diff_in_clk_n : in std_logic;

    clk_40_ttc_p_i : in std_logic;      -- TTC backplane clock signals
    clk_40_ttc_n_i : in std_logic;
    ttc_data_p_i   : in std_logic;
    ttc_data_n_i   : in std_logic;

    LEDs : out std_logic_vector (1 downto 0);

    LED_GREEN_o : out std_logic;
    LED_RED_o   : out std_logic;
    LED_BLUE_o  : out std_logic;

    axi_c2c_v7_to_zynq_data        : out std_logic_vector (14 downto 0);
    axi_c2c_v7_to_zynq_clk         : out std_logic;
    axi_c2c_zynq_to_v7_clk         : in  std_logic;
    axi_c2c_zynq_to_v7_data        : in  std_logic_vector (14 downto 0);
    axi_c2c_v7_to_zynq_link_status : out std_logic;
    axi_c2c_zynq_to_v7_reset       : in  std_logic;

    refclk_F_0_p_i : in std_logic_vector (3 downto 0);
    refclk_F_0_n_i : in std_logic_vector (3 downto 0);

    refclk_F_1_p_i : in std_logic_vector (3 downto 0);
    refclk_F_1_n_i : in std_logic_vector (3 downto 0);

    refclk_B_0_p_i : in std_logic_vector (3 downto 0);
    refclk_B_0_n_i : in std_logic_vector (3 downto 0);

    refclk_B_1_p_i : in std_logic_vector (3 downto 0);
    refclk_B_1_n_i : in std_logic_vector (3 downto 0)

-- no need to bring out the GTH TX and RX ports 

    );
end ctp7_v7_demo;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ctp7_v7_demo_arch of ctp7_v7_demo is

--============================================================================
--                                                      Constants declarations
--============================================================================  
  constant g_NUM_OF_GTH_COMMONs : integer := 16;
  constant g_NUM_OF_GTH_GTs     : integer := 64;

--============================================================================
--                                                      Component declarations
--=============================================d===============================

  component v7_bd is
    port (
      clk_out1_200mhz : out std_logic;
      clk_out2_100mhz : out std_logic;
      clk_out3_50mhz  : out std_logic;

      clk_200_diff_in_clk_p : in std_logic;
      clk_200_diff_in_clk_n : in std_logic;

      BRAM_CTRL_REG_FILE_addr : out std_logic_vector (16 downto 0);
      BRAM_CTRL_REG_FILE_clk  : out std_logic;
      BRAM_CTRL_REG_FILE_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_REG_FILE_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_REG_FILE_en   : out std_logic;
      BRAM_CTRL_REG_FILE_rst  : out std_logic;
      BRAM_CTRL_REG_FILE_we   : out std_logic_vector (3 downto 0);

      BRAM_CTRL_GTH_REG_FILE_addr : out std_logic_vector (16 downto 0);
      BRAM_CTRL_GTH_REG_FILE_clk  : out std_logic;
      BRAM_CTRL_GTH_REG_FILE_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_GTH_REG_FILE_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_GTH_REG_FILE_en   : out std_logic;
      BRAM_CTRL_GTH_REG_FILE_rst  : out std_logic;
      BRAM_CTRL_GTH_REG_FILE_we   : out std_logic_vector (3 downto 0);

      BRAM_CTRL_CAP_RAM_0_addr : out std_logic_vector (16 downto 0);
      BRAM_CTRL_CAP_RAM_0_clk  : out std_logic;
      BRAM_CTRL_CAP_RAM_0_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_CAP_RAM_0_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_CAP_RAM_0_en   : out std_logic;
      BRAM_CTRL_CAP_RAM_0_rst  : out std_logic;
      BRAM_CTRL_CAP_RAM_0_we   : out std_logic_vector (3 downto 0);

      BRAM_CTRL_CAP_RAM_1_addr : out std_logic_vector (16 downto 0);
      BRAM_CTRL_CAP_RAM_1_clk  : out std_logic;
      BRAM_CTRL_CAP_RAM_1_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_CAP_RAM_1_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_CAP_RAM_1_en   : out std_logic;
      BRAM_CTRL_CAP_RAM_1_rst  : out std_logic;
      BRAM_CTRL_CAP_RAM_1_we   : out std_logic_vector (3 downto 0);

      BRAM_CTRL_DRP_addr : out std_logic_vector (15 downto 0);
      BRAM_CTRL_DRP_clk  : out std_logic;
      BRAM_CTRL_DRP_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_DRP_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_DRP_en   : out std_logic;
      BRAM_CTRL_DRP_rst  : out std_logic;
      BRAM_CTRL_DRP_we   : out std_logic_vector (3 downto 0);

      axi_c2c_v7_to_zynq_data        : out std_logic_vector (14 downto 0);
      axi_c2c_v7_to_zynq_clk         : out std_logic;
      axi_c2c_zynq_to_v7_clk         : in  std_logic;
      axi_c2c_zynq_to_v7_data        : in  std_logic_vector (14 downto 0);
      axi_c2c_v7_to_zynq_link_status : out std_logic;
      axi_c2c_zynq_to_v7_reset       : in  std_logic
      );
  end component v7_bd;


  component link_align_ctrl
    generic (
      G_NUM_OF_LINKs : integer := 63
      );
    port (
      clk_240_i                      : in  std_logic;
      link_align_req_i               : in  std_logic;
      bx0_at_240_i                   : in  std_logic;
      link_align_o                   : out std_logic;
      link_fifo_read_o               : out std_logic;
      link_latency_ctrl_i            : in  std_logic_vector(15 downto 0);
      link_latency_err_o             : out std_logic;
      link_mask_ctrl_i               : in  std_logic_vector(G_NUM_OF_LINKs-1 downto 0);
      link_aligned_status_arr_i      : in  t_link_aligned_status_arr(G_NUM_OF_LINKs-1 downto 0);
      link_aligned_diagnostics_arr_o : out t_link_aligned_diagnostics_arr(G_NUM_OF_LINKs-1 downto 0)

      );
  end component link_align_ctrl;

  component rx_depad_cdc_align
    port (
      clk_250_i             : in  std_logic;
      clk_240_i             : in  std_logic;
      gth_rx_data_i         : in  t_gth_rx_data;
      link_8b10b_err_rst_i  : in  std_logic;
      realign_i             : in  std_logic;
      start_fifo_read_i     : in  std_logic;
      link_aligned_data_o   : out t_link_aligned_data;
      link_aligned_status_o : out t_link_aligned_status
      );
  end component rx_depad_cdc_align;

  component ila_tx_pattern_generator
    port (
      clk : in std_logic;

      probe0  : in std_logic_vector(0 downto 0);
      probe1  : in std_logic_vector(11 downto 0);
      probe2  : in std_logic_vector(31 downto 0);
      probe3  : in std_logic_vector(3 downto 0);
      probe4  : in std_logic_vector(31 downto 0);
      probe5  : in std_logic_vector(3 downto 0);
      probe6  : in std_logic_vector(3 downto 0);
      probe7  : in std_logic_vector(3 downto 0);
      probe8  : in std_logic_vector(3 downto 0);
      probe9  : in std_logic_vector(0 downto 0);
      probe10 : in std_logic_vector(0 downto 0);
      probe11 : in std_logic_vector(0 downto 0)

      );
  end component ila_tx_pattern_generator;

--============================================================================
--                                                         Signal declarations
--============================================================================

  signal s_clk_200 : std_logic;
  signal s_clk_100 : std_logic;
  signal s_clk_50  : std_logic;

  signal s_clk_240        : std_logic;
  signal s_clk_usrclk_250 : std_logic;

  signal BRAM_CTRL_REG_FILE_en   : std_logic;
  signal BRAM_CTRL_REG_FILE_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_REG_FILE_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_REG_FILE_we   : std_logic_vector (3 downto 0);
  signal BRAM_CTRL_REG_FILE_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_REG_FILE_clk  : std_logic;
  signal BRAM_CTRL_REG_FILE_rst  : std_logic;

  signal BRAM_CTRL_GTH_REG_FILE_en   : std_logic;
  signal BRAM_CTRL_GTH_REG_FILE_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_we   : std_logic_vector (3 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_clk  : std_logic;
  signal BRAM_CTRL_GTH_REG_FILE_rst  : std_logic;

  signal BRAM_CTRL_CAP_RAM_0_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_CAP_RAM_0_clk  : std_logic;
  signal BRAM_CTRL_CAP_RAM_0_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_CAP_RAM_0_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_CAP_RAM_0_en   : std_logic;
  signal BRAM_CTRL_CAP_RAM_0_rst  : std_logic;
  signal BRAM_CTRL_CAP_RAM_0_we   : std_logic_vector (3 downto 0);

  signal BRAM_CTRL_CAP_RAM_1_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_CAP_RAM_1_clk  : std_logic;
  signal BRAM_CTRL_CAP_RAM_1_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_CAP_RAM_1_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_CAP_RAM_1_en   : std_logic;
  signal BRAM_CTRL_CAP_RAM_1_rst  : std_logic;
  signal BRAM_CTRL_CAP_RAM_1_we   : std_logic_vector (3 downto 0);


  signal BRAM_CTRL_DRP_addr : std_logic_vector (15 downto 0);
  signal BRAM_CTRL_DRP_clk  : std_logic;
  signal BRAM_CTRL_DRP_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_DRP_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_DRP_en   : std_logic;
  signal BRAM_CTRL_DRP_rst  : std_logic;
  signal BRAM_CTRL_DRP_we   : std_logic_vector (3 downto 0);


  signal s_gth_common_reset : std_logic_vector(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_gt_txreset   : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_rxreset   : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_common_status_arr  : t_gth_common_status_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_drp_in_arr  : t_gth_common_drp_in_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_drp_out_arr : t_gth_common_drp_out_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);

  signal s_gth_gt_txreset_done : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_rxreset_done : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);


  signal s_gth_gt_drp_in_arr   : t_gth_gt_drp_in_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_drp_out_arr  : t_gth_gt_drp_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_ctrl_arr     : t_gth_tx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_status_arr   : t_gth_tx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_ctrl_arr     : t_gth_rx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_status_arr   : t_gth_rx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_misc_ctrl_arr   : t_gth_misc_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_misc_status_arr : t_gth_misc_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_data_arr     : t_gth_tx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_data_arr     : t_gth_rx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
-------------------------------------------------------


  signal s_pat_gen_rst        : std_logic;
  signal s_capture_rst        : std_logic;
  signal s_link_8b10b_err_rst : std_logic;

  signal s_capture_arm      : std_logic;
  signal s_capture_done_arr : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_tx_user_word : t_slv_32_arr(g_NUM_OF_GTH_GTs-1 downto 0);


  ---
  signal s_capture_start_bx_id          : std_logic_vector(11 downto 0);
  signal s_link_latency_ctrl            : std_logic_vector(15 downto 0);
  signal s_link_mask_ctrl               : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_link_aligned_diagnostics_arr : t_link_aligned_diagnostics_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_link_align_req   : std_logic;
  signal s_link_latency_err : std_logic;

  signal s_link_align              : std_logic;
  signal s_link_fifo_read          : std_logic;
  signal s_link_aligned_data_arr   : t_link_aligned_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_link_aligned_status_arr : t_link_aligned_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);


  signal s_txdata    : t_slv_32_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_txcharisk : t_slv_4_arr(g_NUM_OF_GTH_GTs-1 downto 0);
---


  signal s_rx_capture_ctrl_arr   : t_rx_capture_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_rx_capture_status_arr : t_rx_capture_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

-------

  signal s_local_timing_ref : t_timing_ref;

  signal s_led_fp : std_logic_vector(31 downto 0);

  signal s_led_cntdwn_timer  : integer range 0 to 50000000 := 50000000;
  signal s_led_cntdwn_toggle : std_logic                   := '0';
  
  signal s_ttc_mmcm_ps_clk : std_logic;
  signal s_ttc_mmcm_ps_clk_en : std_logic;

  signal s_mmcm_rst : std_logic;
  signal s_mmcm_locked : std_logic;
  
  signal s_bc0_stat_rst : std_logic;
  signal s_bc0_stat     : t_bc0_stat;

  signal s_ttc_cmd_cnt_rst : std_logic;
  signal s_ttc_cmd_cnt     : t_slv_32_arr(15 downto 0);

  signal s_tcc_err_cnt_rst : std_logic;
  signal s_tcc_sinerr_ctr  : std_logic_vector(15 downto 0);
  signal s_tcc_dberr_ctr   : std_logic_vector(15 downto 0);

  -- Debugging components
  attribute keep       : boolean;
  attribute mark_debug : boolean;

  attribute keep of s_gth_rx_data_arr, s_local_timing_ref       : signal is true;
  attribute mark_debug of s_gth_rx_data_arr, s_local_timing_ref : signal is true;

--============================================================================
--                                                          Architecture begin
--============================================================================
begin

  LED_RED_o  <= s_led_fp(0);
  LED_BLUE_o <= s_led_fp(1);

  LEDs(0) <= s_led_fp(2);
  LEDs(1) <= s_led_fp(3);
  
  s_ttc_mmcm_ps_clk <= s_clk_50;

  
    i_ctp7_ttc : entity work.ctp7_ttc
    port map(

      clk_40_ttc_p_i => clk_40_ttc_p_i,
      clk_40_ttc_n_i => clk_40_ttc_n_i,

      ttc_data_p_i => ttc_data_p_i,
      ttc_data_n_i => ttc_data_n_i,
      ttc_l1a_enable_i => '0',

      mmcm_rst_i    => s_mmcm_rst,
      mmcm_locked_o => s_mmcm_locked,

      ttc_mmcm_ps_clk_i    => s_ttc_mmcm_ps_clk,
      ttc_mmcm_ps_clk_en_i => s_ttc_mmcm_ps_clk_en,


      clk_40_bufg_o  => open,
      clk_240_bufg_o => s_clk_240,

      local_timing_ref_o => s_local_timing_ref,

      bc0_stat_rst_i    => s_bc0_stat_rst,
      bc0_stat_o        => s_bc0_stat,
      ttc_cmd_cnt_rst_i => s_ttc_cmd_cnt_rst,
      ttc_cmd_cnt_o     => s_ttc_cmd_cnt,

      ttc_cmd_o => open,
      l1a_o     => open,
      resync_o  => open,
      
      L1A_dly_i => x"00",

      bunch_ctr_o => open,
      evt_ctr_o   => open,
      orb_ctr_o   => open,

      tcc_err_cnt_rst_i => s_tcc_err_cnt_rst,
      tcc_sinerr_ctr_o  => s_tcc_sinerr_ctr,
      tcc_dberr_ctr_o   => s_tcc_dberr_ctr
      );

  

  process(s_clk_50)
  begin

    if rising_edge(s_clk_50) then

      s_led_cntdwn_timer <= s_led_cntdwn_timer -1;

      if (s_led_cntdwn_timer = 0) then

        if (s_led_cntdwn_toggle = '0') then
          s_led_cntdwn_toggle <= '1';
          LED_GREEN_o         <= '1';
          s_led_cntdwn_timer  <= 20000000;
        else
          s_led_cntdwn_toggle <= '0';
          LED_GREEN_o         <= '0';
          s_led_cntdwn_timer  <= 50000000;
        end if;
      end if;
    end if;
  end process;

  i_v7_bd : v7_bd
    port map (
      BRAM_CTRL_REG_FILE_addr => BRAM_CTRL_REG_FILE_addr,
      BRAM_CTRL_REG_FILE_clk  => BRAM_CTRL_REG_FILE_clk,
      BRAM_CTRL_REG_FILE_din  => BRAM_CTRL_REG_FILE_din,
      BRAM_CTRL_REG_FILE_dout => BRAM_CTRL_REG_FILE_dout,
      BRAM_CTRL_REG_FILE_en   => BRAM_CTRL_REG_FILE_en,
      BRAM_CTRL_REG_FILE_rst  => BRAM_CTRL_REG_FILE_rst,
      BRAM_CTRL_REG_FILE_we   => BRAM_CTRL_REG_FILE_we,

      BRAM_CTRL_GTH_REG_FILE_addr => BRAM_CTRL_GTH_REG_FILE_addr,
      BRAM_CTRL_GTH_REG_FILE_clk  => BRAM_CTRL_GTH_REG_FILE_clk,
      BRAM_CTRL_GTH_REG_FILE_din  => BRAM_CTRL_GTH_REG_FILE_din,
      BRAM_CTRL_GTH_REG_FILE_dout => BRAM_CTRL_GTH_REG_FILE_dout,
      BRAM_CTRL_GTH_REG_FILE_en   => BRAM_CTRL_GTH_REG_FILE_en,
      BRAM_CTRL_GTH_REG_FILE_rst  => BRAM_CTRL_GTH_REG_FILE_rst,
      BRAM_CTRL_GTH_REG_FILE_we   => BRAM_CTRL_GTH_REG_FILE_we,

      BRAM_CTRL_CAP_RAM_0_addr => BRAM_CTRL_CAP_RAM_0_addr,
      BRAM_CTRL_CAP_RAM_0_clk  => BRAM_CTRL_CAP_RAM_0_clk,
      BRAM_CTRL_CAP_RAM_0_din  => BRAM_CTRL_CAP_RAM_0_din,
      BRAM_CTRL_CAP_RAM_0_dout => BRAM_CTRL_CAP_RAM_0_dout,
      BRAM_CTRL_CAP_RAM_0_en   => BRAM_CTRL_CAP_RAM_0_en,
      BRAM_CTRL_CAP_RAM_0_rst  => BRAM_CTRL_CAP_RAM_0_rst,
      BRAM_CTRL_CAP_RAM_0_we   => BRAM_CTRL_CAP_RAM_0_we,

      BRAM_CTRL_CAP_RAM_1_addr => BRAM_CTRL_CAP_RAM_1_addr,
      BRAM_CTRL_CAP_RAM_1_clk  => BRAM_CTRL_CAP_RAM_1_clk,
      BRAM_CTRL_CAP_RAM_1_din  => BRAM_CTRL_CAP_RAM_1_din,
      BRAM_CTRL_CAP_RAM_1_dout => BRAM_CTRL_CAP_RAM_1_dout,
      BRAM_CTRL_CAP_RAM_1_en   => BRAM_CTRL_CAP_RAM_1_en,
      BRAM_CTRL_CAP_RAM_1_rst  => BRAM_CTRL_CAP_RAM_1_rst,
      BRAM_CTRL_CAP_RAM_1_we   => BRAM_CTRL_CAP_RAM_1_we,

      BRAM_CTRL_DRP_en   => BRAM_CTRL_DRP_en,
      BRAM_CTRL_DRP_dout => BRAM_CTRL_DRP_dout,
      BRAM_CTRL_DRP_din  => BRAM_CTRL_DRP_din,
      BRAM_CTRL_DRP_we   => BRAM_CTRL_DRP_we,
      BRAM_CTRL_DRP_addr => BRAM_CTRL_DRP_addr,
      BRAM_CTRL_DRP_clk  => BRAM_CTRL_DRP_clk,
      BRAM_CTRL_DRP_rst  => BRAM_CTRL_DRP_rst,

      axi_c2c_v7_to_zynq_clk               => axi_c2c_v7_to_zynq_clk,
      axi_c2c_v7_to_zynq_data(14 downto 0) => axi_c2c_v7_to_zynq_data(14 downto 0),
      axi_c2c_v7_to_zynq_link_status       => axi_c2c_v7_to_zynq_link_status,
      axi_c2c_zynq_to_v7_clk               => axi_c2c_zynq_to_v7_clk,
      axi_c2c_zynq_to_v7_data(14 downto 0) => axi_c2c_zynq_to_v7_data(14 downto 0),
      axi_c2c_zynq_to_v7_reset             => axi_c2c_zynq_to_v7_reset,

      clk_200_diff_in_clk_n => clk_200_diff_in_clk_n,
      clk_200_diff_in_clk_p => clk_200_diff_in_clk_p,

      clk_out1_200mhz => s_clk_200,
      clk_out2_100mhz => s_clk_100,
      clk_out3_50mhz  => s_clk_50
      );

  i_register_file : entity work.register_file
    generic map(
      C_DATE_CODE      => C_DATE_CODE,
      C_GITHASH_CODE   => C_GITHASH_CODE,
      C_GIT_REPO_DIRTY => C_GIT_REPO_DIRTY
      )
    port map (
      clk240_i => s_clk_240,

      LED_FP_o => s_led_FP,

      tx_user_word_o => s_tx_user_word,

      BRAM_CTRL_REG_FILE_addr => BRAM_CTRL_REG_FILE_addr,
      BRAM_CTRL_REG_FILE_clk  => BRAM_CTRL_REG_FILE_clk,
      BRAM_CTRL_REG_FILE_din  => BRAM_CTRL_REG_FILE_din,
      BRAM_CTRL_REG_FILE_dout => BRAM_CTRL_REG_FILE_dout,
      BRAM_CTRL_REG_FILE_en   => BRAM_CTRL_REG_FILE_en,
      BRAM_CTRL_REG_FILE_rst  => BRAM_CTRL_REG_FILE_rst,
      BRAM_CTRL_REG_FILE_we   => BRAM_CTRL_REG_FILE_we,

      ttc_mmcm_ps_clk_en_o => s_ttc_mmcm_ps_clk_en,
      
      mmcm_rst_o    => s_mmcm_rst,
      mmcm_locked_i => s_mmcm_locked,

      tcc_err_cnt_rst_o => s_tcc_err_cnt_rst,
      tcc_sinerr_ctr_i  => s_tcc_sinerr_ctr,
      tcc_dberr_ctr_i   => s_tcc_dberr_ctr,
      
      bc0_stat_rst_o    => s_bc0_stat_rst,
      bc0_stat_i        => s_bc0_stat,
      ttc_cmd_cnt_rst_o => s_ttc_cmd_cnt_rst,
      ttc_cmd_cnt_i     => s_ttc_cmd_cnt,

      link_latency_ctrl_o          => s_link_latency_ctrl,
      link_mask_ctrl_o             => s_link_mask_ctrl,
      link_aligned_diagnostics_arr => s_link_aligned_diagnostics_arr,
      link_aligned_status_arr_i    => s_link_aligned_status_arr,

      link_align_req_o   => s_link_align_req,
      link_latency_err_i => s_link_latency_err,

      gth_gt_txreset_done_i => s_gth_gt_txreset_done,
      gth_gt_rxreset_done_i => s_gth_gt_rxreset_done,

      pat_gen_rst_o        => s_pat_gen_rst,
      capture_rst_o        => s_capture_rst,
      link_8b10b_err_rst_o => s_link_8b10b_err_rst,

      rx_capture_ctrl_arr_o   => s_rx_capture_ctrl_arr,
      rx_capture_status_arr_i => s_rx_capture_status_arr

      );

-----------
  i_gth_register_file : entity work.gth_register_file
    port map (

      BRAM_CTRL_GTH_REG_FILE_addr => BRAM_CTRL_GTH_REG_FILE_addr,
      BRAM_CTRL_GTH_REG_FILE_clk  => BRAM_CTRL_GTH_REG_FILE_clk,
      BRAM_CTRL_GTH_REG_FILE_din  => BRAM_CTRL_GTH_REG_FILE_din,
      BRAM_CTRL_GTH_REG_FILE_dout => BRAM_CTRL_GTH_REG_FILE_dout,
      BRAM_CTRL_GTH_REG_FILE_en   => BRAM_CTRL_GTH_REG_FILE_en,
      BRAM_CTRL_GTH_REG_FILE_rst  => BRAM_CTRL_GTH_REG_FILE_rst,
      BRAM_CTRL_GTH_REG_FILE_we   => BRAM_CTRL_GTH_REG_FILE_we,

      gth_common_reset_o      => s_gth_common_reset,
      gth_common_status_arr_i => s_gth_common_status_arr,

      gth_gt_txreset_o => s_gth_gt_txreset,
      gth_gt_rxreset_o => s_gth_gt_rxreset,

      gth_gt_txreset_done_i => s_gth_gt_txreset_done,
      gth_gt_rxreset_done_i => s_gth_gt_rxreset_done,

      gth_tx_ctrl_arr_o   => s_gth_tx_ctrl_arr,
      gth_tx_status_arr_i => s_gth_tx_status_arr,

      gth_rx_ctrl_arr_o   => s_gth_rx_ctrl_arr,
      gth_rx_status_arr_i => s_gth_rx_status_arr,

      gth_misc_ctrl_arr_o   => s_gth_misc_ctrl_arr,
      gth_misc_status_arr_i => s_gth_misc_status_arr

      );

----------


  i_drp_controller : entity work.drp_controller
    port map (
      BRAM_CTRL_DRP_en   => BRAM_CTRL_DRP_en,
      BRAM_CTRL_DRP_dout => BRAM_CTRL_DRP_dout,
      BRAM_CTRL_DRP_din  => BRAM_CTRL_DRP_din,
      BRAM_CTRL_DRP_we   => BRAM_CTRL_DRP_we,
      BRAM_CTRL_DRP_addr => BRAM_CTRL_DRP_addr,
      BRAM_CTRL_DRP_clk  => BRAM_CTRL_DRP_clk,
      BRAM_CTRL_DRP_rst  => BRAM_CTRL_DRP_rst,

      gth_common_drp_arr_o => s_gth_common_drp_in_arr,
      gth_common_drp_arr_i => s_gth_common_drp_out_arr,

      gth_gt_drp_arr_o => s_gth_gt_drp_in_arr,
      gth_gt_drp_arr_i => s_gth_gt_drp_out_arr

      );

  i_gth_wrapper : entity work.gth_10gbps_buf_cc_gt_wrapper
    generic map
    (

      g_EXAMPLE_SIMULATION     => 0,
      g_STABLE_CLOCK_PERIOD    => 20,
      g_NUM_OF_GTH_GTs         => g_NUM_OF_GTH_GTs,
      g_NUM_OF_GTH_COMMONs     => g_NUM_OF_GTH_COMMONs,
      g_GT_SIM_GTRESET_SPEEDUP => "TRUE"

      )
    port map (
      clk_stable_i => s_clk_50,

      clk_usrclk_250_o => s_clk_usrclk_250,

      refclk_F_0_p_i => refclk_F_0_p_i,
      refclk_F_0_n_i => refclk_F_0_n_i,
      refclk_F_1_p_i => refclk_F_1_p_i,
      refclk_F_1_n_i => refclk_F_1_n_i,
      refclk_B_0_p_i => refclk_B_0_p_i,
      refclk_B_0_n_i => refclk_B_0_n_i,
      refclk_B_1_p_i => refclk_B_1_p_i,
      refclk_B_1_n_i => refclk_B_1_n_i,

      gth_common_reset_i      => s_gth_common_reset,
      gth_common_status_arr_o => s_gth_common_status_arr,
      gth_common_drp_arr_i    => s_gth_common_drp_in_arr,
      gth_common_drp_arr_o    => s_gth_common_drp_out_arr,

      gth_gt_txreset_i => s_gth_gt_txreset,
      gth_gt_rxreset_i => s_gth_gt_rxreset,

      gth_gt_txreset_done_o => s_gth_gt_txreset_done,
      gth_gt_rxreset_done_o => s_gth_gt_rxreset_done,

      gth_gt_drp_arr_i => s_gth_gt_drp_in_arr,
      gth_gt_drp_arr_o => s_gth_gt_drp_out_arr,

      gth_tx_ctrl_arr_i   => s_gth_tx_ctrl_arr,
      gth_tx_status_arr_o => s_gth_tx_status_arr,

      gth_rx_ctrl_arr_i   => s_gth_rx_ctrl_arr,
      gth_rx_status_arr_o => s_gth_rx_status_arr,

      gth_misc_ctrl_arr_i   => s_gth_misc_ctrl_arr,
      gth_misc_status_arr_o => s_gth_misc_status_arr,

      gth_tx_data_arr_i => s_gth_tx_data_arr,
      gth_rx_data_arr_o => s_gth_rx_data_arr

      );

  gen_tx_and_rx : for i in 0 to g_NUM_OF_GTH_GTs-1 generate

    i_tx_link_driver : entity work.tx_link_driver
      generic map(
        g_LINK_ID => i
        )
      port map (
        clk240_i       => s_clk_240,
        clk250_i       => s_clk_usrclk_250,
        rst_i          => s_pat_gen_rst,
        tx_user_word_i => s_tx_user_word(i),
        bc0_i          => s_local_timing_ref.bc0,
        bcid_i         => s_local_timing_ref.bcid,
        txdata_o       => s_gth_tx_data_arr(i).txdata,
        txcharisk_o    => s_gth_tx_data_arr(i).txcharisk
        );

    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align,
        start_fifo_read_i     => s_link_fifo_read,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );

  end generate;

  i_link_align_ctrl : link_align_ctrl
    generic map (
      G_NUM_OF_LINKs => g_NUM_OF_GTH_GTs
      )
    port map(
      clk_240_i                      => s_clk_240,
      link_align_req_i               => s_link_align_req,
      bx0_at_240_i                   => s_local_timing_ref.bc0,
      link_align_o                   => s_link_align,
      link_fifo_read_o               => s_link_fifo_read,
      link_latency_ctrl_i            => s_link_latency_ctrl,
      link_latency_err_o             => s_link_latency_err,
      link_mask_ctrl_i               => s_link_mask_ctrl,
      link_aligned_status_arr_i      => s_link_aligned_status_arr,
      link_aligned_diagnostics_arr_o => s_link_aligned_diagnostics_arr
      );

  i_rx_capture_buffer_ctrl : entity work.rx_capture_buffer_ctrl
    port map (
      clk_240_i => s_clk_240,

      rst_i => s_capture_rst,

      link_aligned_data_arr_i => s_link_aligned_data_arr,

      rx_capture_ctrl_arr_i   => s_rx_capture_ctrl_arr,
      rx_capture_status_arr_o => s_rx_capture_status_arr,

      bx_id_i => s_local_timing_ref.bcid,

      BRAM_CTRL_CAP_RAM_0_addr => BRAM_CTRL_CAP_RAM_0_addr,
      BRAM_CTRL_CAP_RAM_0_clk  => BRAM_CTRL_CAP_RAM_0_clk,
      BRAM_CTRL_CAP_RAM_0_din  => BRAM_CTRL_CAP_RAM_0_din,
      BRAM_CTRL_CAP_RAM_0_dout => BRAM_CTRL_CAP_RAM_0_dout,
      BRAM_CTRL_CAP_RAM_0_en   => BRAM_CTRL_CAP_RAM_0_en,
      BRAM_CTRL_CAP_RAM_0_rst  => BRAM_CTRL_CAP_RAM_0_rst,
      BRAM_CTRL_CAP_RAM_0_we   => BRAM_CTRL_CAP_RAM_0_we,

      BRAM_CTRL_CAP_RAM_1_addr => BRAM_CTRL_CAP_RAM_1_addr,
      BRAM_CTRL_CAP_RAM_1_clk  => BRAM_CTRL_CAP_RAM_1_clk,
      BRAM_CTRL_CAP_RAM_1_din  => BRAM_CTRL_CAP_RAM_1_din,
      BRAM_CTRL_CAP_RAM_1_dout => BRAM_CTRL_CAP_RAM_1_dout,
      BRAM_CTRL_CAP_RAM_1_en   => BRAM_CTRL_CAP_RAM_1_en,
      BRAM_CTRL_CAP_RAM_1_rst  => BRAM_CTRL_CAP_RAM_1_rst,
      BRAM_CTRL_CAP_RAM_1_we   => BRAM_CTRL_CAP_RAM_1_we

      );

  i_ila_tx_pattern_generator_ch10 : ila_tx_pattern_generator
    port map (
      clk        => s_clk_usrclk_250,
      probe0(0)  => s_local_timing_ref.bc0,
      probe1     => s_local_timing_ref.bcid,
      probe2     => s_gth_tx_data_arr(C_CH10).txdata,
      probe3     => s_gth_tx_data_arr(C_CH10).txcharisk,
      probe4     => s_gth_rx_data_arr(C_CH10).rxdata,
      probe5     => s_gth_rx_data_arr(C_CH10).rxchariscomma,
      probe6     => s_gth_rx_data_arr(C_CH10).rxcharisk,
      probe7     => s_gth_rx_data_arr(C_CH10).rxnotintable,
      probe8     => s_gth_rx_data_arr(C_CH10).rxdisperr,
      probe9(0)  => s_gth_rx_data_arr(C_CH10).rxbyteisaligned,
      probe10(0) => s_gth_rx_data_arr(C_CH10).rxbyterealign,
      probe11(0) => s_gth_rx_data_arr(C_CH10).rxcommadet
      );


  i_ila_tx_pattern_generator_ch20 : ila_tx_pattern_generator
    port map (
      clk        => s_clk_usrclk_250,
      probe0(0)  => s_local_timing_ref.bc0,
      probe1     => s_local_timing_ref.bcid,
      probe2     => s_gth_tx_data_arr(C_CH20).txdata,
      probe3     => s_gth_tx_data_arr(C_CH20).txcharisk,
      probe4     => s_gth_rx_data_arr(C_CH20).rxdata,
      probe5     => s_gth_rx_data_arr(C_CH20).rxchariscomma,
      probe6     => s_gth_rx_data_arr(C_CH20).rxcharisk,
      probe7     => s_gth_rx_data_arr(C_CH20).rxnotintable,
      probe8     => s_gth_rx_data_arr(C_CH20).rxdisperr,
      probe9(0)  => s_gth_rx_data_arr(C_CH20).rxbyteisaligned,
      probe10(0) => s_gth_rx_data_arr(C_CH20).rxbyterealign,
      probe11(0) => s_gth_rx_data_arr(C_CH20).rxcommadet
      );

end ctp7_v7_demo_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

