-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gth_10gbps_buf_cc_gt_wrapper                                           
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
use UNISIM.VCOMPONENTS.all;

library work;
use work.gth_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity gth_10gbps_buf_cc_gt_wrapper is
  generic
    (
      g_EXAMPLE_SIMULATION     : integer                := 1;
      g_STABLE_CLOCK_PERIOD    : integer range 4 to 250 := 20;  --Period of the stable clock driving this state-machine, unit is [ns]
      g_NUM_OF_GTH_GTs         : integer                := 64;
      g_NUM_OF_GTH_COMMONs     : integer                := 16;
      g_GT_SIM_GTRESET_SPEEDUP : string                 := "TRUE"  -- Set to "TRUE" to speed up sim reset

      );
  port (

    clk_stable_i : in std_logic;

    refclk_F_0_p_i : in std_logic_vector (3 downto 0);
    refclk_F_0_n_i : in std_logic_vector (3 downto 0);

    refclk_F_1_p_i : in std_logic_vector (3 downto 0);
    refclk_F_1_n_i : in std_logic_vector (3 downto 0);

    refclk_B_0_p_i : in std_logic_vector (3 downto 0);
    refclk_B_0_n_i : in std_logic_vector (3 downto 0);

    refclk_B_1_p_i : in std_logic_vector (3 downto 0);
    refclk_B_1_n_i : in std_logic_vector (3 downto 0);

    clk_usrclk_250_o : out std_logic;

    ------------------------
    -- GTH common

    gth_common_reset_i      : in  std_logic_vector(g_NUM_OF_GTH_COMMONs-1 downto 0);
    gth_common_status_arr_o : out t_gth_common_status_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);

    gth_common_drp_arr_i : in  t_gth_common_drp_in_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
    gth_common_drp_arr_o : out t_gth_common_drp_out_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
    ------------------------

    gth_gt_txreset_i : in std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_gt_rxreset_i : in std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

    gth_gt_txreset_done_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_gt_rxreset_done_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

    gth_gt_drp_arr_i : in  t_gth_gt_drp_in_arr(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_gt_drp_arr_o : out t_gth_gt_drp_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);

    gth_tx_ctrl_arr_i   : in  t_gth_tx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_tx_status_arr_o : out t_gth_tx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

    gth_rx_ctrl_arr_i   : in  t_gth_rx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_rx_status_arr_o : out t_gth_rx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

    gth_misc_ctrl_arr_i   : in  t_gth_misc_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_misc_status_arr_o : out t_gth_misc_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

    gth_tx_data_arr_i : in  t_gth_tx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_rx_data_arr_o : out t_gth_rx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0)

    );
end gth_10gbps_buf_cc_gt_wrapper;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture gth_10gbps_buf_cc_gt_wrapper_arch of gth_10gbps_buf_cc_gt_wrapper is

--============================================================================
--                                                         Signal declarations
--============================================================================
  attribute syn_noclockbuf : boolean;

  signal s_refclk_F_1 : std_logic_vector (3 downto 0);
  signal s_refclk_B_1 : std_logic_vector (3 downto 0);

  attribute syn_noclockbuf of s_refclk_F_1 : signal is true;
  attribute syn_noclockbuf of s_refclk_B_1 : signal is true;

  signal s_clk_usrclk_250_bufg : std_logic;

  signal s_gth_gt_clk_in_arr  : t_gth_gt_clk_in_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_clk_out_arr : t_gth_gt_clk_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_drp_in_arr  : t_gth_gt_drp_in_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_drp_out_arr : t_gth_gt_drp_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_tx_ctrl_arr   : t_gth_tx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_init_arr   : t_gth_tx_init_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_status_arr : t_gth_tx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_rx_ctrl_arr : t_gth_rx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_init_arr : t_gth_rx_init_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_rx_status_arr : t_gth_rx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_misc_ctrl_arr   : t_gth_misc_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_misc_status_arr : t_gth_misc_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_tx_data_arr : t_gth_tx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_data_arr : t_gth_rx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  ---------------------

  signal s_gth_common_clk_in_arr  : t_gth_common_clk_in_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_clk_out_arr : t_gth_common_clk_out_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);

  signal s_gth_common_ctrl_arr   : t_gth_common_ctrl_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_status_arr : t_gth_common_status_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);

  signal s_gth_common_drp_in_arr  : t_gth_common_drp_in_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_drp_out_arr : t_gth_common_drp_out_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);

--============================================================================
--                                                          Architecture begin
--============================================================================

begin

  gen_ibufds : for i in 0 to 3 generate
    --IBUFDS_GTE2
    i_ibufds_refclk_F : IBUFDS_GTE2
      port map
      (
        O     => s_refclk_F_1(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_F_1_p_i(i),
        IB    => refclk_F_1_n_i(i)
        );

    --IBUFDS_GTE2
    i_ibufds_refclk_B : IBUFDS_GTE2
      port map
      (
        O     => s_refclk_B_1(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_B_1_p_i(i),
        IB    => refclk_B_1_n_i(i)
        );
  end generate;

  i_bufg_txoutclk_gt0 : BUFG
    port map
    (
      I => s_gth_gt_clk_out_arr(0).txoutclk,
      O => s_clk_usrclk_250_bufg
      );

  clk_usrclk_250_o <= s_clk_usrclk_250_bufg;



------------------------

  s_gth_tx_data_arr   <= gth_tx_data_arr_i;
  gth_rx_data_arr_o   <= s_gth_rx_data_arr;
  s_gth_gt_drp_in_arr <= gth_gt_drp_arr_i;
  gth_gt_drp_arr_o    <= s_gth_gt_drp_out_arr;

  s_gth_tx_ctrl_arr     <= gth_tx_ctrl_arr_i;
  gth_tx_status_arr_o   <= s_gth_tx_status_arr;
  s_gth_rx_ctrl_arr     <= gth_rx_ctrl_arr_i;
  gth_rx_status_arr_o   <= s_gth_rx_status_arr;
  s_gth_misc_ctrl_arr   <= gth_misc_ctrl_arr_i;
  gth_misc_status_arr_o <= s_gth_misc_status_arr;


  gen_qpll_refclk_assign_0 : for i in 0 to 1 generate
  begin
    gen_qpll_inner_0 : for j in 0 to 3 generate
    begin
      s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_F_1(3);
      s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
      s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
    end generate;
  end generate;

  gen_if_qpll_refclk_assign_1 : if (g_NUM_OF_GTH_GTs > 12) generate
    gen_qpll_refclk_assign_1 : for i in 2 to 4 generate
    begin
      gen_qpll_inner_1 : for j in 0 to 3 generate
      begin
        s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_F_1(2);
        s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
        s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
      end generate;
    end generate;
  end generate;

  gen_if_qpll_refclk_assign_2 : if (g_NUM_OF_GTH_GTs > 20) generate

    gen_qpll_refclk_assign_2 : for i in 5 to 7 generate
    begin
      gen_qpll_inner_2 : for j in 0 to 3 generate
      begin
        s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_F_1(1);
        s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
        s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
      end generate;
    end generate;
  end generate;

  gen_if_qpll_refclk_assign_3 : if (g_NUM_OF_GTH_GTs > 32) generate

    gen_qpll_refclk_assign_3 : for i in 8 to 9 generate
    begin
      gen_qpll_inner_3 : for j in 0 to 3 generate
      begin
        s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_F_1(0);
        s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
        s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
      end generate;
    end generate;
  end generate;


  gen_qpll_refclk_assign_4 : for i in 10 to 11 generate
  begin
    gen_qpll_inner_3 : for j in 0 to 3 generate
    begin
      s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_B_1(3);
      s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
      s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
    end generate;
  end generate;

  gen_qpll_refclk_assign_5 : for i in 12 to 14 generate
  begin
    gen_qpll_inner_3 : for j in 0 to 3 generate
    begin
      s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_B_1(2);
      s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
      s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
    end generate;
  end generate;

  gen_qpll_refclk_assign_6 : for i in 15 to 15 generate
  begin
    gen_qpll_inner_3 : for j in 0 to 3 generate
    begin
      s_gth_gt_clk_in_arr(i*4+j).GTREFCLK0  <= s_refclk_B_1(1);
      s_gth_gt_clk_in_arr(i*4+j).qpllclk    <= s_gth_common_clk_out_arr(i).QPLLOUTCLK;
      s_gth_gt_clk_in_arr(i*4+j).qpllrefclk <= s_gth_common_clk_out_arr(i).QPLLOUTREFCLK;
    end generate;
  end generate;

  gen_gth_10gbps_buf_cc_gt : for n in 0 to (g_NUM_OF_GTH_GTs-1) generate
  begin

    s_gth_gt_clk_in_arr(n).rxusrclk  <= s_clk_usrclk_250_bufg;
    s_gth_gt_clk_in_arr(n).rxusrclk2 <= s_clk_usrclk_250_bufg;
    s_gth_gt_clk_in_arr(n).txusrclk  <= s_clk_usrclk_250_bufg;
    s_gth_gt_clk_in_arr(n).txusrclk2 <= s_clk_usrclk_250_bufg;

    i_gth_10gbps_buf_cc_gt : entity work.gth_10gbps_buf_cc_gt
      generic map
      (
                                        -- Simulation attributes
        g_GT_SIM_GTRESET_SPEEDUP => g_GT_SIM_GTRESET_SPEEDUP
        )
      port map
      (
        gth_gt_clk_i      => s_gth_gt_clk_in_arr(n),
        gth_gt_clk_o      => s_gth_gt_clk_out_arr(n),
        gth_gt_drp_i      => s_gth_gt_drp_in_arr(n),
        gth_gt_drp_o      => s_gth_gt_drp_out_arr(n),
        gth_tx_ctrl_i     => s_gth_tx_ctrl_arr(n),
        gth_tx_init_i     => s_gth_tx_init_arr(n),
        gth_tx_status_o   => s_gth_tx_status_arr(n),
        gth_rx_ctrl_i     => s_gth_rx_ctrl_arr(n),
        gth_rx_init_i     => s_gth_rx_init_arr(n),
        gth_rx_status_o   => s_gth_rx_status_arr(n),
        gth_misc_ctrl_i   => s_gth_misc_ctrl_arr(n),
        gth_misc_status_o => s_gth_misc_status_arr(n),
        gth_tx_data_i     => s_gth_tx_data_arr(n),
        gth_rx_data_o     => s_gth_rx_data_arr(n)
        );
  end generate;


  s_gth_common_drp_in_arr <= gth_common_drp_arr_i;
  gth_common_drp_arr_o    <= s_gth_common_drp_out_arr;

  s_gth_common_clk_in_arr(0).GTREFCLK0  <= s_refclk_F_1(3);
  s_gth_common_clk_in_arr(1).GTREFCLK0  <= s_refclk_F_1(3);
  s_gth_common_clk_in_arr(2).GTREFCLK0  <= s_refclk_F_1(2);
  s_gth_common_clk_in_arr(3).GTREFCLK0  <= s_refclk_F_1(2);
  s_gth_common_clk_in_arr(4).GTREFCLK0  <= s_refclk_F_1(2);
  s_gth_common_clk_in_arr(5).GTREFCLK0  <= s_refclk_F_1(1);
  s_gth_common_clk_in_arr(6).GTREFCLK0  <= s_refclk_F_1(1);
  s_gth_common_clk_in_arr(7).GTREFCLK0  <= s_refclk_F_1(1);
  s_gth_common_clk_in_arr(8).GTREFCLK0  <= s_refclk_F_1(0);
  s_gth_common_clk_in_arr(9).GTREFCLK0  <= s_refclk_F_1(0);
  s_gth_common_clk_in_arr(10).GTREFCLK0 <= s_refclk_B_1(3);
  s_gth_common_clk_in_arr(11).GTREFCLK0 <= s_refclk_B_1(3);
  s_gth_common_clk_in_arr(12).GTREFCLK0 <= s_refclk_B_1(2);
  s_gth_common_clk_in_arr(13).GTREFCLK0 <= s_refclk_B_1(2);
  s_gth_common_clk_in_arr(14).GTREFCLK0 <= s_refclk_B_1(2);
  s_gth_common_clk_in_arr(15).GTREFCLK0 <= s_refclk_B_1(1);

  gth_common_status_arr_o <= s_gth_common_status_arr;

  gen_gth_10gbps_buf_cc_common : for n in 0 to (g_NUM_OF_GTH_COMMONs-1) generate
  begin

    s_gth_common_ctrl_arr(n).QPLLRESET <= gth_common_reset_i(n);

    inst_gth_10gbps_buf_cc_common : entity work.gth_10gbps_buf_cc_common
      generic map
      (
                                        -- Simulation attributes
        g_GT_SIM_GTRESET_SPEEDUP => g_GT_SIM_GTRESET_SPEEDUP,  -- Set to "true" to speed up sim reset
        g_STABLE_CLOCK_PERIOD    => g_STABLE_CLOCK_PERIOD  -- Period of the stable clock driving this state-machine, unit is [ns]

        )
      port map
      (

        clk_stable_i        => clk_stable_i,
        gth_common_clk_i    => s_gth_common_clk_in_arr(n),
        gth_common_clk_o    => s_gth_common_clk_out_arr(n),
        gth_common_ctrl_i   => s_gth_common_ctrl_arr(n),
        gth_common_status_o => s_gth_common_status_arr(n),
        gth_common_drp_i    => s_gth_common_drp_in_arr(n),
        gth_common_drp_o    => s_gth_common_drp_out_arr(n)
        );
  end generate;

  gen_gt_resetfsm : for i in 0 to (g_NUM_OF_GTH_GTs/4-1) generate
  begin
    gen_txresetfsm_inner : for j in 0 to 3 generate
    begin

      inst_gt_txresetfsm : entity work.gth_10gbps_buf_cc_TX_STARTUP_FSM

        generic map(
          EXAMPLE_SIMULATION     => g_EXAMPLE_SIMULATION,
          STABLE_CLOCK_PERIOD    => g_STABLE_CLOCK_PERIOD,  -- Period of the stable clock driving this state-machine, unit is [ns]
          RETRY_COUNTER_BITWIDTH => 2,
          TX_QPLL_USED           => true,  -- the TX and RX Reset FSMs must
          RX_QPLL_USED           => true,  -- share these two generic values
          PHASE_ALIGNMENT_MANUAL => false  -- Decision if a manual phase-alignment is necessary or the automatic
                                           -- is enough. For single-lane applications the automatic alignment is
                                           -- sufficient
          )
        port map (
          STABLE_CLOCK      => clk_stable_i,
          TXUSERCLK         => s_clk_usrclk_250_bufg,
          SOFT_RESET        => gth_gt_txreset_i(i*4+j),
          QPLLREFCLKLOST    => s_gth_common_status_arr(i).QPLLREFCLKLOST,
          CPLLREFCLKLOST    => '0',
          QPLLLOCK          => s_gth_common_status_arr(i).QPLLLOCK,
          CPLLLOCK          => '1',
          TXRESETDONE       => s_gth_tx_status_arr(i*4+j).txresetdone,
          MMCM_LOCK         => '1',
          GTTXRESET         => s_gth_tx_init_arr(i*4+j).gttxreset,
          MMCM_RESET        => open,
          QPLL_RESET        => open,
          CPLL_RESET        => open,
          TX_FSM_RESET_DONE => gth_gt_txreset_done_o(i*4+j),
          TXUSERRDY         => s_gth_tx_init_arr(i*4+j).txuserrdy,
          RUN_PHALIGNMENT   => open,
          RESET_PHALIGNMENT => open,
          PHALIGNMENT_DONE  => '1',
          RETRY_COUNTER     => open
          );

      inst_gt_rxresetfsm : entity work.gth_10gbps_buf_cc_RX_STARTUP_FSM

        generic map(
          EXAMPLE_SIMULATION     => g_EXAMPLE_SIMULATION,
          EQ_MODE                => "LPM",  --Rx Equalization Mode - Set to DFE or LPM
          STABLE_CLOCK_PERIOD    => g_STABLE_CLOCK_PERIOD,  --Period of the stable clock driving this state-machine, unit is [ns]
          RETRY_COUNTER_BITWIDTH => 2,
          TX_QPLL_USED           => true,  -- the TX and RX Reset FSMs must
          RX_QPLL_USED           => true,  -- share these two generic values
          PHASE_ALIGNMENT_MANUAL => false  -- Decision if a manual phase-alignment is necessary or the automatic
                                           -- is enough. For single-lane applications the automatic alignment is
                                           -- sufficient
          )
        port map (
          STABLE_CLOCK             => clk_stable_i,
          RXUSERCLK                => s_clk_usrclk_250_bufg,
          SOFT_RESET               => gth_gt_rxreset_i(i*4+j),
          DONT_RESET_ON_DATA_ERROR => '1',
          RXPMARESETDONE           => s_gth_rx_status_arr(i*4+j).RXPMARESETDONE,
--        RXOUTCLK                 => s_gth_gt_clk_out_arr(i*4+j).rxoutclk,
          RXOUTCLK                 => s_clk_usrclk_250_bufg,
          TXPMARESETDONE           => s_gth_tx_status_arr(i*4+j).TXPMARESETDONE,
--        TXOUTCLK                 => s_gth_gt_clk_out_arr(i*4+j).txoutclk,
          TXOUTCLK                 => s_clk_usrclk_250_bufg,
          QPLLREFCLKLOST           => s_gth_common_status_arr(i).QPLLREFCLKLOST,
          CPLLREFCLKLOST           => '0',
          QPLLLOCK                 => s_gth_common_status_arr(i).QPLLLOCK,
          CPLLLOCK                 => '1',
          RXRESETDONE              => s_gth_rx_status_arr(i*4+j).rxresetdone,
          MMCM_LOCK                => '1',
          RECCLK_STABLE            => '1',
          RECCLK_MONITOR_RESTART   => '0',
          DATA_VALID               => '1',
          TXUSERRDY                => s_gth_tx_init_arr(i*4+j).txuserrdy,
          GTRXRESET                => s_gth_rx_init_arr(i*4+j).gtrxreset,
          MMCM_RESET               => open,
          QPLL_RESET               => open,
          CPLL_RESET               => open,
          RX_FSM_RESET_DONE        => gth_gt_rxreset_done_o(i*4+j),
          RXUSERRDY                => s_gth_rx_init_arr(i*4+j).rxuserrdy,
          RUN_PHALIGNMENT          => open,
          RESET_PHALIGNMENT        => open,
          PHALIGNMENT_DONE         => '1',
          RXDFEAGCHOLD             => s_gth_rx_init_arr(i*4+j).RXDFEAGCHOLD,
          RXDFELFHOLD              => s_gth_rx_init_arr(i*4+j).RXDFELFHOLD,
          RXLPMLFHOLD              => s_gth_rx_init_arr(i*4+j).RXLPMLFHOLD,
          RXLPMHFHOLD              => s_gth_rx_init_arr(i*4+j).RXLPMHFHOLD,
          RETRY_COUNTER            => open
          );

      s_gth_rx_init_arr(i*4+j).rxdfeagcovrden  <= '0';
      s_gth_rx_init_arr(i*4+j).rxdfelpmreset   <= '0';
      s_gth_rx_init_arr(i*4+j).rxlpmlfklovrden <= '0';
      s_gth_rx_init_arr(i*4+j).RXDFELFOVRDEN   <= '0';
      s_gth_rx_init_arr(i*4+j).RXLPMHFOVRDEN   <= '0';


    end generate;
  end generate;

end gth_10gbps_buf_cc_gt_wrapper_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

