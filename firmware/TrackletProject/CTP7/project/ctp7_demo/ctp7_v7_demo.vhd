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
--  component local_timing_ref_gen
--    port (
--      clk_240_i    : in  std_logic;
--      timing_ref_o : out t_timing_ref
--      );
--  end component local_timing_ref_gen;

  component v7_bd is
    port (
      clk_out1_200mhz : out std_logic;
      clk_out2_100mhz : out std_logic;
      clk_out3_50mhz  : out std_logic;
      --clk_out4_240mhz : out std_logic;

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

      BRAM_INPUT_addr : out STD_LOGIC_VECTOR ( 15 downto 0 );
      BRAM_INPUT_clk : out STD_LOGIC;
      BRAM_INPUT_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_INPUT_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_INPUT_en : out STD_LOGIC;
      BRAM_INPUT_rst : out STD_LOGIC;
      BRAM_INPUT_we : out STD_LOGIC_VECTOR ( 3 downto 0 );

      BRAM_OUTPUT_addr : out STD_LOGIC_VECTOR ( 15 downto 0 );
      BRAM_OUTPUT_clk : out STD_LOGIC;
      BRAM_OUTPUT_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_OUTPUT_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_OUTPUT_en : out STD_LOGIC;
      BRAM_OUTPUT_rst : out STD_LOGIC;
      BRAM_OUTPUT_we : out STD_LOGIC_VECTOR ( 3 downto 0 );

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

  component verilog_trigger_top
    port (
      proc_clk : in std_logic;
      proc_clk_new : in std_logic;          --MT
      io_clk : in std_logic;
      reset : in std_logic;

      input_link1_reg1: in  std_logic_vector(31 downto 0);
      input_link1_reg2: in  std_logic_vector(31 downto 0);
      input_link2_reg1: in  std_logic_vector(31 downto 0);
      input_link2_reg2: in  std_logic_vector(31 downto 0);
      input_link3_reg1: in  std_logic_vector(31 downto 0);
      input_link3_reg2: in  std_logic_vector(31 downto 0);
      input_link4_reg1: in  std_logic_vector(31 downto 0);
      input_link4_reg2: in  std_logic_vector(31 downto 0);
      input_link5_reg1: in  std_logic_vector(31 downto 0);
      input_link5_reg2: in  std_logic_vector(31 downto 0);
      input_link6_reg1: in  std_logic_vector(31 downto 0);
      input_link6_reg2: in  std_logic_vector(31 downto 0);
      input_link7_reg1: in  std_logic_vector(31 downto 0);
      input_link7_reg2: in  std_logic_vector(31 downto 0);
      input_link8_reg1: in  std_logic_vector(31 downto 0);
      input_link8_reg2: in  std_logic_vector(31 downto 0);
      input_link9_reg1: in  std_logic_vector(31 downto 0);
      input_link9_reg2: in  std_logic_vector(31 downto 0);
      
      BRAM_OUTPUT_addr: in  std_logic_vector(15 downto 0);
      BRAM_OUTPUT_clk: in  std_logic;
      BRAM_OUTPUT_din: in  std_logic_vector(31 downto 0);
      BRAM_OUTPUT_dout: out  std_logic_vector(31 downto 0);
      BRAM_OUTPUT_en: in  std_logic;
      BRAM_OUTPUT_rst: in  std_logic;
      BRAM_OUTPUT_we: in  std_logic_vector(3 downto 0);
      
      Proj_L3F3F5_ToPlus: out std_logic_vector(54 downto 0);
      Proj_L3F3F5_ToPlus_en: out std_logic;
      Proj_L3F3F5_ToMinus: out std_logic_vector(54 downto 0);
      Proj_L3F3F5_ToMinus_en: out std_logic;
      Proj_L3F3F5_FromPlus: in std_logic_vector(54 downto 0);
      Proj_L3F3F5_FromMinus: in std_logic_vector(54 downto 0);
      
      Proj_L2L4F2_ToPlus: out std_logic_vector(54 downto 0);
      Proj_L2L4F2_ToPlus_en: out std_logic;
      Proj_L2L4F2_ToMinus: out std_logic_vector(54 downto 0);
      Proj_L2L4F2_ToMinus_en: out std_logic;
      Proj_L2L4F2_FromPlus: in std_logic_vector(54 downto 0);
      Proj_L2L4F2_FromMinus: in std_logic_vector(54 downto 0);

      Proj_F1L5_ToPlus: out std_logic_vector(54 downto 0);
      Proj_F1L5_ToPlus_en: out std_logic;
      Proj_F1L5_ToMinus: out std_logic_vector(54 downto 0);
      Proj_F1L5_ToMinus_en: out std_logic;
      Proj_F1L5_FromPlus: in std_logic_vector(54 downto 0);
      Proj_F1L5_FromMinus: in std_logic_vector(54 downto 0);

      Proj_L1L6F4_ToPlus: out std_logic_vector(54 downto 0);
      Proj_L1L6F4_ToPlus_en: out std_logic;
      Proj_L1L6F4_ToMinus: out std_logic_vector(54 downto 0);
      Proj_L1L6F4_ToMinus_en: out std_logic;
      Proj_L1L6F4_FromPlus: in std_logic_vector(54 downto 0);
      Proj_L1L6F4_FromMinus: in std_logic_vector(54 downto 0);
      

      
      Match_Layer_ToPlus: out std_logic_vector(44 downto 0);
      Match_Layer_ToPlus_en: out std_logic;
      Match_Layer_ToMinus: out std_logic_vector(44 downto 0);
      Match_Layer_ToMinus_en: out std_logic;
      
      Match_Layer_FromPlus: in std_logic_vector(44 downto 0);
--      Match_Layer_FromPlus_en: in std_logic;
      Match_Layer_FromMinus: in std_logic_vector(44 downto 0);
--      Match_Layer_FromMinus_en: in std_logic;
      
      Match_FDSK_ToPlus: out std_logic_vector(44 downto 0);
--      Match_FDSK_ToPlus_en: out std_logic;
      Match_FDSK_ToMinus: out std_logic_vector(44 downto 0);
--      Match_FDSK_ToMinus_en: out std_logic;
      
      Match_FDSK_FromPlus: in std_logic_vector(44 downto 0);
--      Match_FDSK_FromPlus_en: in std_logic;
      Match_FDSK_FromMinus: in std_logic_vector(44 downto 0);
--      Match_FDSK_FromMinus_en: in std_logic;
           
      CT_L1L2 : out std_logic_vector(125 downto 0);
      CT_L3L4 : out std_logic_vector(125 downto 0);
      CT_L5L6 : out std_logic_vector(125 downto 0);
      CT_F1F2 : out std_logic_vector(125 downto 0);
      CT_F3F4 : out std_logic_vector(125 downto 0);
      CT_F1L1 : out std_logic_vector(125 downto 0)

      );
  end component verilog_trigger_top;
  
  component TProjMemory
    port (
        proc_clk : in std_logic; --clk for trigger_top (in)
        out_clk  : in std_logic; --clk for links (out)
        reset    : in std_logic;
        proj     : in std_logic_vector(54 downto 0);
        valid    : in std_logic;
        projout  : out std_logic_vector(54 downto 0)
    );
  end component TProjMemory;
  
  component MatchMemory
    port (
        proc_clk : in std_logic; --clk for trigger_top (in)
        out_clk  : in std_logic; --clk for links (out)
        reset    : in std_logic;
        match    : in std_logic_vector(44 downto 0);
        valid    : in std_logic;
        matchout : out std_logic_vector(44 downto 0)
    );
  end component MatchMemory;  
  
  component TProjRecMemory
    port (
        proc_clk : in std_logic; --clk for trigger_top (out)
        out_clk  : in std_logic; --clk for links (in)
        reset    : in std_logic;
        proj     : in std_logic_vector(54 downto 0);
        valid    : out std_logic;
        projout  : out std_logic_vector(54 downto 0)
    );
  end component TProjRecMemory;
 
  component MatchRecMemory
    port (
        proc_clk : in std_logic; --clk for trigger_top (out)
        out_clk  : in std_logic; --clk for links (in)
        reset    : in std_logic;
        match    : in std_logic_vector(44 downto 0);
        valid    : out std_logic;
        matchout : out std_logic_vector(44 downto 0)
    );
  end component MatchRecMemory; 
  
  component bc0_delays
--    generic (
--      G_DATA_WIDTH_1 : integer := 1;
--      G_DATA_WIDTH_2 : integer := 12
--      G_DELAY_1     : integer := 0;
--      G_DELAY_2   : integer := 0;
--      G_DELAY_3  : integer := 0;
--      G_DELAY_4  : integer := 0
--      );
    port (
      clk_proc  : in std_logic;
      bc0_i     : in std_logic;
      bcid_i    : in std_logic_vector(11 downto 0); 
      bc0_delay_ctrl_1 : in std_logic_vector(15 downto 0);  
      bc0_delay_ctrl_2 : in std_logic_vector(15 downto 0);  
      bc0_delay_ctrl_3 : in std_logic_vector(15 downto 0);  
      bc0_delay_ctrl_4 : in std_logic_vector(15 downto 0);   
      bc0_out1  : out std_logic;
      bc0_out2  : out std_logic;
      bc0_out3  : out std_logic;
      bc0_out4  : out std_logic;
      bcid_out1 : out std_logic_vector(11 downto 0);
      bcid_out2 : out std_logic_vector(11 downto 0);
      bcid_out3 : out std_logic_vector(11 downto 0);
      bcid_out4 : out std_logic_vector(11 downto 0)
      );
  end component bc0_delays;
  
  component tx_channel_wrapper is
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
  end component tx_channel_wrapper;

--============================================================================
--                                                         Signal declarations
--============================================================================

  signal s_clk_200 : std_logic;
  signal s_clk_100 : std_logic;
  signal s_clk_50  : std_logic;
  signal s_clk_proc  : std_logic;

  signal s_clk_240        : std_logic;
  signal s_clk_new        : std_logic;  --MT
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


  signal BRAM_INPUT_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT_clk  : std_logic;
  signal BRAM_INPUT_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT_en   : std_logic;
  signal BRAM_INPUT_rst  : std_logic;
  signal BRAM_INPUT_we   : std_logic_vector (3 downto 0);


  signal BRAM_OUTPUT_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT_clk  : std_logic;
  signal BRAM_OUTPUT_din  : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT_en   : std_logic;
  signal BRAM_OUTPUT_rst  : std_logic;
  signal BRAM_OUTPUT_we   : std_logic_vector (3 downto 0);

  signal TPROJ_ToPlus     : std_logic_vector (54 downto 0);
  signal TPROJ_ToPlus_en  : std_logic;
  signal TPROJ_ToMinus    : std_logic_vector (54 downto 0);
  signal TPROJ_ToMinus_en : std_logic;
  
  signal Proj_L3F3F5_ToPlus      : std_logic_vector (54 downto 0);
  signal Proj_L3F3F5_ToMinus     : std_logic_vector (54 downto 0);
  
  signal Proj_L2L4F2_ToPlus      : std_logic_vector (54 downto 0);
  signal Proj_L2L4F2_ToMinus     : std_logic_vector (54 downto 0);
  
  signal Proj_F1L5_ToPlus      : std_logic_vector (54 downto 0);
  signal Proj_F1L5_ToMinus     : std_logic_vector (54 downto 0);
  
  signal Proj_L1L6F4_ToPlus      : std_logic_vector (54 downto 0);
  signal Proj_L1L6F4_ToMinus     : std_logic_vector (54 downto 0);
  
  signal FMatch_Layer_ToMinus : std_logic_vector (44 downto 0);
  signal FMatch_Layer_ToPlus  : std_logic_vector (44 downto 0);
  signal FMatch_FDSK_ToMinus : std_logic_vector (44 downto 0);
  signal FMatch_FDSK_ToPlus  : std_logic_vector (44 downto 0);
  signal FMATCH_L5L6_ToMinus : std_logic_vector (44 downto 0); 
  signal FMATCH_L5L6_ToPlus  : std_logic_vector (44 downto 0);
      
  signal TPROJ_FromPlus     : std_logic_vector (54 downto 0);
  signal TPROJ_FromPlus_en  : std_logic;
  signal TPROJ_FromMinus    : std_logic_vector (54 downto 0);
  signal TPROJ_FromMinus_en : std_logic;
 
  signal HalfStub1_1_H : std_logic_vector (31 downto 0);
  signal HalfStub1_1_L : std_logic_vector (31 downto 0);
  signal HalfStub1_2_H : std_logic_vector (31 downto 0);
  signal HalfStub1_2_L : std_logic_vector (31 downto 0);
  signal HalfStub1_3_H : std_logic_vector (31 downto 0);
  signal HalfStub1_3_L : std_logic_vector (31 downto 0);
  signal HalfStub2_1_H : std_logic_vector (31 downto 0);
  signal HalfStub2_1_L : std_logic_vector (31 downto 0);
  signal HalfStub2_2_H : std_logic_vector (31 downto 0);
  signal HalfStub2_2_L : std_logic_vector (31 downto 0);
  signal HalfStub2_3_H : std_logic_vector (31 downto 0);
  signal HalfStub2_3_L : std_logic_vector (31 downto 0);
  signal HalfStub3_1_H : std_logic_vector (31 downto 0);
  signal HalfStub3_1_L : std_logic_vector (31 downto 0);
  signal HalfStub3_2_H : std_logic_vector (31 downto 0);
  signal HalfStub3_2_L : std_logic_vector (31 downto 0);
  signal HalfStub3_3_H : std_logic_vector (31 downto 0);
  signal HalfStub3_3_L : std_logic_vector (31 downto 0);
 
  signal HalfProj1_H_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj1_L_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj1_H_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj1_L_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj2_H_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj2_L_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj2_H_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj2_L_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj3_H_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj3_L_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj3_H_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj3_L_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj4_H_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj4_L_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfProj4_H_FromMinus : std_logic_vector (31 downto 0);
  signal HalfProj4_L_FromMinus : std_logic_vector (31 downto 0);
     
  signal HalfMatch_Layer_H_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfMatch_Layer_L_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfMatch_Layer_H_FromMinus : std_logic_vector (31 downto 0);
  signal HalfMatch_Layer_L_FromMinus : std_logic_vector (31 downto 0);
  signal HalfMatch_FDSK_H_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfMatch_FDSK_L_FromPlus  : std_logic_vector (31 downto 0);
  signal HalfMatch_FDSK_H_FromMinus : std_logic_vector (31 downto 0);
  signal HalfMatch_FDSK_L_FromMinus : std_logic_vector (31 downto 0);
  
  signal Proj_FromPlus      : std_logic_vector (50 downto 0);
  signal Proj_FromMinus     : std_logic_vector (50 downto 0);

  signal Match_Layer_ToPlus       : std_logic_vector (44 downto 0);
  signal Match_Layer_ToPlus_en    : std_logic;
  signal Match_Layer_ToMinus      : std_logic_vector (44 downto 0);
  signal Match_Layer_ToMinus_en   : std_logic;
  signal Match_Layer_FromPlus       : std_logic_vector (44 downto 0);
  signal Match_Layer_FromPlus_en    : std_logic;
  signal Match_Layer_FromMinus      : std_logic_vector (44 downto 0);
  signal Match_Layer_FromMinus_en   : std_logic;
  
  signal Match_FDSK_ToPlus       : std_logic_vector (44 downto 0);
  signal Match_FDSK_ToPlus_en    : std_logic;
  signal Match_FDSK_ToMinus      : std_logic_vector (44 downto 0);
  signal Match_FDSK_ToMinus_en   : std_logic;
  signal Match_FDSK_FromPlus       : std_logic_vector (44 downto 0);
  signal Match_FDSK_FromPlus_en    : std_logic;
  signal Match_FDSK_FromMinus      : std_logic_vector (44 downto 0);
  signal Match_FDSK_FromMinus_en   : std_logic;

  signal CT_L1L2          : std_logic_vector (125 downto 0);
  signal CT_L3L4          : std_logic_vector (125 downto 0);
  signal CT_L5L6          : std_logic_vector (125 downto 0);
  signal CT_F1F2          : std_logic_vector (125 downto 0);
  signal CT_F3F4          : std_logic_vector (125 downto 0);
  signal CT_F1L1          : std_logic_vector (125 downto 0);
  

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

  signal s_bc0_delay_ctrl_stub  : std_logic_vector(15 downto 0);
  signal s_bc0_delay_ctrl_proj  : std_logic_vector(15 downto 0);
  signal s_bc0_delay_ctrl_match : std_logic_vector(15 downto 0);
  signal s_bc0_delay_ctrl_track : std_logic_vector(15 downto 0);

  ---
  signal s_capture_start_bx_id          : std_logic_vector(11 downto 0);
  signal s_link_latency_ctrl_stub       : std_logic_vector(15 downto 0);
  signal s_link_latency_ctrl_proj       : std_logic_vector(15 downto 0);
  signal s_link_latency_ctrl_match      : std_logic_vector(15 downto 0);
  signal s_link_mask_ctrl               : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_link_aligned_diagnostics_arr : t_link_aligned_diagnostics_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_link_align_req         : std_logic;
  signal s_link_latency_err_stub  : std_logic;
  signal s_link_latency_err_proj  : std_logic;
  signal s_link_latency_err_match : std_logic;

  signal s_link_align_stub         : std_logic;
  signal s_link_align_proj         : std_logic;
  signal s_link_align_match        : std_logic;
  signal s_link_fifo_read_stub     : std_logic;
  signal s_link_fifo_read_proj     : std_logic;
  signal s_link_fifo_read_match    : std_logic;
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
--------
  signal input_link1_reg1            : std_logic_vector(31 downto 0);
  signal input_link1_reg2            : std_logic_vector(31 downto 0);
  signal input_link2_reg1            : std_logic_vector(31 downto 0);
  signal input_link2_reg2            : std_logic_vector(31 downto 0);
  signal input_link3_reg1            : std_logic_vector(31 downto 0);
  signal input_link3_reg2            : std_logic_vector(31 downto 0);
  
--------
  signal bc0_stub   : std_logic;
  signal bc0_proj   : std_logic;
  signal bc0_match  : std_logic;
  signal bc0_trk    : std_logic;
  signal bcid_stub  : std_logic_vector(11 downto 0);
  signal bcid_proj  : std_logic_vector(11 downto 0);
  signal bcid_match : std_logic_vector(11 downto 0);
  signal bcid_trk   : std_logic_vector(11 downto 0);

--------
  signal trigger_top_reset : std_logic;


  -- Debugging components
  attribute keep       : boolean;
  attribute mark_debug : boolean;

  attribute keep of s_gth_rx_data_arr, s_local_timing_ref       : signal is true;
  --attribute mark_debug of s_gth_rx_data_arr, s_local_timing_ref : signal is true;

--============================================================================
--                                                          Architecture begin
--============================================================================
begin
  -- assign stub input links
  gen_stub_3links : if true generate  -- use 3 stub input links per detector region
    HalfStub1_1_H <= s_link_aligned_data_arr(54).data;
    HalfStub1_1_L <= s_link_aligned_data_arr(53).data;
    HalfStub1_2_H <= s_link_aligned_data_arr(55).data;
    HalfStub1_2_L <= s_link_aligned_data_arr(50).data;
    HalfStub1_3_H <= s_link_aligned_data_arr(52).data;
    HalfStub1_3_L <= s_link_aligned_data_arr(51).data;
    HalfStub2_1_H <= s_link_aligned_data_arr(44).data;
    HalfStub2_1_L <= s_link_aligned_data_arr(47).data;
    HalfStub2_2_H <= s_link_aligned_data_arr(45).data;
    HalfStub2_2_L <= s_link_aligned_data_arr(48).data;
    HalfStub2_3_H <= s_link_aligned_data_arr(46).data;
    HalfStub2_3_L <= s_link_aligned_data_arr(49).data;
    HalfStub3_1_H <= s_link_aligned_data_arr(15).data;
    HalfStub3_1_L <= s_link_aligned_data_arr(14).data;
    HalfStub3_2_H <= s_link_aligned_data_arr(12).data;
    HalfStub3_2_L <= s_link_aligned_data_arr(18).data;
    HalfStub3_3_H <= s_link_aligned_data_arr(16).data;
    HalfStub3_3_L <= s_link_aligned_data_arr(13).data;
  end generate;
  
  gen_stub_2links : if false generate  -- or use 2 stub input links per detector region
    HalfStub1_1_H <= s_link_aligned_data_arr(54).data;
    HalfStub1_1_L <= s_link_aligned_data_arr(53).data;
    HalfStub1_2_H <= s_link_aligned_data_arr(55).data;
    HalfStub1_2_L <= s_link_aligned_data_arr(50).data;
    HalfStub2_1_H <= s_link_aligned_data_arr(52).data;
    HalfStub2_1_L <= s_link_aligned_data_arr(51).data;
    HalfStub2_2_H <= s_link_aligned_data_arr(44).data;
    HalfStub2_2_L <= s_link_aligned_data_arr(47).data;
    HalfStub3_1_H <= s_link_aligned_data_arr(45).data;
    HalfStub3_1_L <= s_link_aligned_data_arr(48).data;
    HalfStub3_2_H <= s_link_aligned_data_arr(46).data;
    HalfStub3_2_L <= s_link_aligned_data_arr(49).data;
  end generate;
  
  -- assign projection links
  HalfProj1_H_FromPlus <= s_link_aligned_data_arr(24).data;
  HalfProj1_L_FromPlus <= s_link_aligned_data_arr(25).data;
  HalfProj2_H_FromPlus <= s_link_aligned_data_arr(26).data;
  HalfProj2_L_FromPlus <= s_link_aligned_data_arr(27).data;
  HalfProj3_H_FromPlus <= s_link_aligned_data_arr(28).data;
  HalfProj3_L_FromPlus <= s_link_aligned_data_arr(29).data;
  HalfProj4_H_FromPlus <= s_link_aligned_data_arr(30).data;
  HalfProj4_L_FromPlus <= s_link_aligned_data_arr(31).data;
  
  HalfProj1_H_FromMinus  <= s_link_aligned_data_arr(0).data;
  HalfProj1_L_FromMinus  <= s_link_aligned_data_arr(1).data;
  HalfProj2_H_FromMinus  <= s_link_aligned_data_arr(2).data;
  HalfProj2_L_FromMinus  <= s_link_aligned_data_arr(3).data;
  HalfProj3_H_FromMinus  <= s_link_aligned_data_arr(4).data;
  HalfProj3_L_FromMinus  <= s_link_aligned_data_arr(5).data;
  HalfProj4_H_FromMinus  <= s_link_aligned_data_arr(6).data;
  HalfProj4_L_FromMinus  <= s_link_aligned_data_arr(7).data;

  -- assign match links
  HalfMatch_Layer_H_FromPlus  <= s_link_aligned_data_arr(32).data;
  HalfMatch_Layer_L_FromPlus  <= s_link_aligned_data_arr(33).data;
  HalfMatch_FDSK_H_FromPlus  <= s_link_aligned_data_arr(34).data;
  HalfMatch_FDSK_L_FromPlus  <= s_link_aligned_data_arr(35).data;
 
  HalfMatch_Layer_H_FromMinus <= s_link_aligned_data_arr(8).data;
  HalfMatch_Layer_L_FromMinus <= s_link_aligned_data_arr(9).data;
  HalfMatch_FDSK_H_FromMinus <= s_link_aligned_data_arr(10).data;
  HalfMatch_FDSK_L_FromMinus <= s_link_aligned_data_arr(11).data;
  

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
      clk_new_bufg_o => s_clk_new,      --MT

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

      BRAM_INPUT_en   => BRAM_INPUT_en,
      BRAM_INPUT_dout => BRAM_INPUT_dout,
      BRAM_INPUT_din  => BRAM_INPUT_din,
      BRAM_INPUT_we   => BRAM_INPUT_we,
      BRAM_INPUT_addr => BRAM_INPUT_addr,
      BRAM_INPUT_clk  => BRAM_INPUT_clk,
      BRAM_INPUT_rst  => BRAM_INPUT_rst,

      BRAM_OUTPUT_en   => BRAM_OUTPUT_en,
      BRAM_OUTPUT_dout => BRAM_OUTPUT_dout,
      BRAM_OUTPUT_din  => BRAM_OUTPUT_din,
      BRAM_OUTPUT_we   => BRAM_OUTPUT_we,
      BRAM_OUTPUT_addr => BRAM_OUTPUT_addr,
      BRAM_OUTPUT_clk  => BRAM_OUTPUT_clk,
      BRAM_OUTPUT_rst  => BRAM_OUTPUT_rst,

      axi_c2c_v7_to_zynq_clk               => axi_c2c_v7_to_zynq_clk,
      axi_c2c_v7_to_zynq_data(14 downto 0) => axi_c2c_v7_to_zynq_data(14 downto 0),
      axi_c2c_v7_to_zynq_link_status       => axi_c2c_v7_to_zynq_link_status,
      axi_c2c_zynq_to_v7_clk               => axi_c2c_zynq_to_v7_clk,
      axi_c2c_zynq_to_v7_data(14 downto 0) => axi_c2c_zynq_to_v7_data(14 downto 0),
      axi_c2c_zynq_to_v7_reset             => axi_c2c_zynq_to_v7_reset,

      clk_200_diff_in_clk_n => clk_200_diff_in_clk_n,
      clk_200_diff_in_clk_p => clk_200_diff_in_clk_p,

      clk_out1_200mhz => s_clk_200,
      clk_out2_100mhz => s_clk_proc,
      clk_out3_50mhz  => s_clk_50
      --clk_out4_240mhz => s_clk_240
      );

--  i_local_timing_ref_gen : local_timing_ref_gen
--    port map (
--      clk_240_i    => s_clk_240,
--      timing_ref_o => s_local_timing_ref
--      );
 

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

      bc0_delay_ctrl_stub_o  => s_bc0_delay_ctrl_stub,
      bc0_delay_ctrl_proj_o  => s_bc0_delay_ctrl_proj,
      bc0_delay_ctrl_match_o => s_bc0_delay_ctrl_match,
      bc0_delay_ctrl_track_o => s_bc0_delay_ctrl_track,

      link_latency_ctrl_stub_o     => s_link_latency_ctrl_stub,
      link_latency_ctrl_proj_o     => s_link_latency_ctrl_proj,
      link_latency_ctrl_match_o    => s_link_latency_ctrl_match,
      link_mask_ctrl_o             => s_link_mask_ctrl,
      link_aligned_diagnostics_arr => s_link_aligned_diagnostics_arr,
      link_aligned_status_arr_i    => s_link_aligned_status_arr,

      link_align_req_o         => s_link_align_req,
      link_latency_err_stub_i  => s_link_latency_err_stub,
      link_latency_err_proj_i  => s_link_latency_err_proj,
      link_latency_err_match_i => s_link_latency_err_match,

      gth_gt_txreset_done_i => s_gth_gt_txreset_done,
      gth_gt_rxreset_done_i => s_gth_gt_rxreset_done,

      pat_gen_rst_o        => s_pat_gen_rst,
      capture_rst_o        => s_capture_rst,
      link_8b10b_err_rst_o => s_link_8b10b_err_rst,

      rx_capture_ctrl_arr_o   => s_rx_capture_ctrl_arr,
      rx_capture_status_arr_i => s_rx_capture_status_arr,

      input_link1_reg1        => input_link1_reg1,
      input_link1_reg2        => input_link1_reg2,
      input_link2_reg1        => input_link2_reg1,
      input_link2_reg2        => input_link2_reg2,
      input_link3_reg1        => input_link3_reg1,
      input_link3_reg2        => input_link3_reg2

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
  
  -----------------------------------------------------------
  -- TX
  -----------------------------------------------------------
  -- sending projections to plus
  --   cxp2 tx: 27 28 25 24 29 26 35 34
  --   (received by cxp0 ch 0-7) 
  tx_wrapper_projplus1 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 1
      tx_datastream_i    => s_tx_user_word(28)(8 downto 0) & Proj_L3F3F5_ToPlus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(27).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(27).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(28).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(28).txcharisk
      );
  tx_wrapper_projplus2 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 2
      tx_datastream_i    => s_tx_user_word(24)(8 downto 0) & Proj_L2L4F2_ToPlus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(25).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(25).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(24).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(24).txcharisk
      );
   tx_wrapper_projplus3 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 3
      tx_datastream_i    => s_tx_user_word(26)(8 downto 0) & Proj_F1L5_ToPlus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(29).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(29).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(26).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(26).txcharisk
      );
  tx_wrapper_projplus4 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 4
      tx_datastream_i    => s_tx_user_word(34)(8 downto 0) & Proj_L1L6F4_ToPlus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(35).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(35).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(34).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(34).txcharisk
      );
      
  -- sending projections to minus
  --   cxp0 tx: ch 3 4 0 1 5 11 2 10 
  --   (received by cxp2 ch 24-31 of the neighbour)

  tx_wrapper_projminus1 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 1
      tx_datastream_i    => s_tx_user_word(4)(8 downto 0) & Proj_L3F3F5_ToMinus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(3).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(3).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(4).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(4).txcharisk
      );
  tx_wrapper_projminus2 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 2
      tx_datastream_i    => s_tx_user_word(1)(8 downto 0) & Proj_L2L4F2_ToMinus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(0).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(0).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(1).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(1).txcharisk
      );
  tx_wrapper_projminus3 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,
      -- projection 3
      tx_datastream_i    => s_tx_user_word(11)(8 downto 0) & Proj_F1L5_ToMinus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(5).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(5).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(11).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(11).txcharisk
      );
  tx_wrapper_projminus4 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_proj,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_proj, --s_local_timing_ref.bcid,      
      -- projection 4
      tx_datastream_i    => s_tx_user_word(10)(8 downto 0) & Proj_L1L6F4_ToMinus(54 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(2).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(2).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(10).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(10).txcharisk
      );  
      
  -- sending matches to plus
  --   cxp2 tx: ch 33 32 30 31
  --   (received by cxp0 ch 8-11 of the neighbour)
  tx_wrapper_match_layer_plus : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_match,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_match, --s_local_timing_ref.bcid,
      -- match 1
      tx_datastream_i    => s_tx_user_word(32)(18 downto 0) & Match_Layer_ToPlus(44 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(33).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(33).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(32).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(32).txcharisk
      );
  tx_wrapper_match_fdsk_plus : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_match,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_match, --s_local_timing_ref.bcid,
      -- match 2
      tx_datastream_i    => s_tx_user_word(31)(18 downto 0) & Match_FDSK_ToPlus(44 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(30).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(30).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(31).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(31).txcharisk    
      );
      
  -- sending matches to minus
  --   cxp0 tx: ch 6 9 7 8
  --   (received by cxp2 ch 32-35 of the neighbour)
  tx_wrapper_match_layer_minus : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_match,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_match, --s_local_timing_ref.bcid,
      -- match 1
      tx_datastream_i    => s_tx_user_word(9)(18 downto 0) & Match_Layer_ToMinus(44 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(6).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(6).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(9).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(9).txcharisk
      );
  tx_wrapper_match_fdsk_minus : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_match,  --s_local_timing_ref.bc0,
      bcid_i         => bcid_match, --s_local_timing_ref.bcid,
      -- match 2
      tx_datastream_i    => s_tx_user_word(8)(18 downto 0) & Match_FDSK_ToMinus(44 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(7).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(7).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(8).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(8).txcharisk   
      );

  -- sending tracks
  --   mptx: ch 52-63
  
  tx_wrapper_tracks_l1l2 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_trk, --s_local_timing_ref.bc0,
      bcid_i         => bcid_trk, --s_local_timing_ref.bcid,
      tx_datastream_i    => CT_L1L2(63 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(60).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(60).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(61).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(61).txcharisk
      );
      
  tx_wrapper_tracks_l3l4 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_trk, --s_local_timing_ref.bc0,
      bcid_i         => bcid_trk, --s_local_timing_ref.bcid,
      tx_datastream_i    => CT_L3L4(63 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(56).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(56).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(57).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(57).txcharisk
      );
      
  tx_wrapper_tracks_l5l6 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_trk, --s_local_timing_ref.bc0,
      bcid_i         => bcid_trk, --s_local_timing_ref.bcid,
      tx_datastream_i    => CT_L5L6(63 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(52).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(52).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(53).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(53).txcharisk
      );
      
  tx_wrapper_tracks_f1f2 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_trk, --s_local_timing_ref.bc0,
      bcid_i         => bcid_trk, --s_local_timing_ref.bcid,
      tx_datastream_i    => CT_F1F2(63 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(62).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(62).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(63).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(63).txcharisk
      );
      
  tx_wrapper_tracks_f3f4 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_trk, --s_local_timing_ref.bc0,
      bcid_i         => bcid_trk, --s_local_timing_ref.bcid,
      tx_datastream_i    => CT_F3F4(63 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(58).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(58).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(59).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(59).txcharisk
      );
      
  tx_wrapper_tracks_f1l1 : tx_channel_wrapper
    port map(
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      bc0_i          => bc0_trk, --s_local_timing_ref.bc0,
      bcid_i         => bcid_trk, --s_local_timing_ref.bcid,
      tx_datastream_i    => CT_F1L1(63 downto 0),
      txdata_H_o     => s_gth_tx_data_arr(54).txdata,
      txcharisk_H_o  => s_gth_tx_data_arr(54).txcharisk,
      txdata_L_o     => s_gth_tx_data_arr(55).txdata,
      txcharisk_L_o  => s_gth_tx_data_arr(55).txcharisk
      );
      
--   ch 12-23 and 36-51 is not used for tx; generate dummy together with unused mptx and cxp1
  -- unused tx channels    
  gen_tx_dummy_mptx : for i in 36 to 51 generate    
    i_tx_link_driver : entity work.tx_link_driver
--      generic map(
--        g_LINK_ID => i
--        )
      port map (
        clk240_i       => s_clk_240,
        clk250_i       => s_clk_usrclk_250,
        rst_i          => s_pat_gen_rst,
        tx_user_word_i => s_tx_user_word(i)(31 downto 0),
        bc0_i          => s_local_timing_ref.bc0,
        bcid_i         => s_local_timing_ref.bcid,
        txdata_o       => s_gth_tx_data_arr(i).txdata,
        txcharisk_o    => s_gth_tx_data_arr(i).txcharisk
        );       
  end generate;      

  gen_tx_dummy_cxp1 : for i in 12 to 23 generate    
    i_tx_link_driver : entity work.tx_link_driver
--      generic map(
--        g_LINK_ID => i
--        )
      port map (
        clk240_i       => s_clk_240,
        clk250_i       => s_clk_usrclk_250,
        rst_i          => s_pat_gen_rst,
        tx_user_word_i => s_tx_user_word(i)(31 downto 0),
        bc0_i          => s_local_timing_ref.bc0,
        bcid_i         => s_local_timing_ref.bcid,
        txdata_o       => s_gth_tx_data_arr(i).txdata,
        txcharisk_o    => s_gth_tx_data_arr(i).txcharisk
        );       
  end generate;  
        

  -----------------------------------------------------------
  -- RX
  -----------------------------------------------------------
  -- stubs
  --   cxp1 rx: ch 12-23 and mp1 rx: 44-55
  --   (ch 53 54)
  gen_rx_cxp1 : for i in 12 to 23 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align_stub,
        start_fifo_read_i     => s_link_fifo_read_stub,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );
  end generate;
  
  -- ch 36-43 56-63 not used
  gen_rx_mprx : for i in 36 to 63 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align_stub,
        start_fifo_read_i     => s_link_fifo_read_stub,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );
  end generate;
  
  -- projections from plus
  --   cxp2 rx: ch 24-31
  gen_rx_projplus : for i in 24 to 31 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align_proj,
        start_fifo_read_i     => s_link_fifo_read_proj,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );
  end generate;
  
  -- projections from minus
  --   cxp0 rx: ch 0-7
  gen_rx_projminus : for i in 0 to 7 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align_proj,
        start_fifo_read_i     => s_link_fifo_read_proj,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );

  end generate;
  
  -- matches from plus
  --   cxp2 rx: ch 32-35
  gen_rx_matchplus : for i in 32 to 35 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align_match,
        start_fifo_read_i     => s_link_fifo_read_match,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );
  end generate;
  
  -- matches from minus
  --   cxp0 rx: ch 8-11
  gen_rx_matchminus : for i in 8 to 11 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
      port map(
        clk_250_i             => s_clk_usrclk_250,
        clk_240_i             => s_clk_240,
        gth_rx_data_i         => s_gth_rx_data_arr(i),
        link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
        realign_i             => s_link_align_match,
        start_fifo_read_i     => s_link_fifo_read_match,
        link_aligned_data_o   => s_link_aligned_data_arr(i),
        link_aligned_status_o => s_link_aligned_status_arr(i)
        );
  end generate; 

----------------------------------------------------------------
-- Channel Alignment
----------------------------------------------------------------
     
  -- channel alignment for receiving stubs
  -- cxp1 and mprx
  i_link_align_ctrl_stub : link_align_ctrl   
    generic map (
      G_NUM_OF_LINKs => 40
      )
    port map(
      clk_240_i                      => s_clk_240,
      link_align_req_i               => s_link_align_req,
      bx0_at_240_i                   => bc0_stub, --s_local_timing_ref.bc0,
      link_align_o                   => s_link_align_stub,
      link_fifo_read_o               => s_link_fifo_read_stub,
      link_latency_ctrl_i            => s_link_latency_ctrl_stub,
      link_latency_err_o             => s_link_latency_err_stub,
      link_mask_ctrl_i               => s_link_mask_ctrl(63 downto 36) & s_link_mask_ctrl(23 downto 12),
      link_aligned_status_arr_i      => s_link_aligned_status_arr(63 downto 36) & s_link_aligned_status_arr(23 downto 12),
      --link_aligned_diagnostics_arr_o => s_link_aligned_diagnostics_arr(63 downto 36) & s_link_aligned_diagnostics_arr(23 downto 12)
      link_aligned_diagnostics_arr_o(39 downto 12) => s_link_aligned_diagnostics_arr(63 downto 36),
      link_aligned_diagnostics_arr_o(11 downto 0) => s_link_aligned_diagnostics_arr(23 downto 12)
      );

    -- note: only CH 12-23 and CH 44-55 are connected and receiving data. The others need to be always masked

-- channel alignment for projection
  i_link_align_ctrl_proj : link_align_ctrl  
    generic map (
      G_NUM_OF_LINKs => 16
      )
    port map(
      clk_240_i                      => s_clk_240,
      link_align_req_i               => s_link_align_req,
      bx0_at_240_i                   => bc0_proj, --s_local_timing_ref.bc0,
      link_align_o                   => s_link_align_proj,
      link_fifo_read_o               => s_link_fifo_read_proj,
      link_latency_ctrl_i            => s_link_latency_ctrl_proj,
      link_latency_err_o             => s_link_latency_err_proj,
      link_mask_ctrl_i               => s_link_mask_ctrl(31 downto 24) & s_link_mask_ctrl(7 downto 0),
      link_aligned_status_arr_i      => s_link_aligned_status_arr(31 downto 24) & s_link_aligned_status_arr(7 downto 0),
      --link_aligned_diagnostics_arr_o => s_link_aligned_diagnostics_arr(31 downto 24) & s_link_aligned_diagnostics_arr(7 downto 0)
      link_aligned_diagnostics_arr_o(15 downto 8) => s_link_aligned_diagnostics_arr(31 downto 24),
      link_aligned_diagnostics_arr_o(7 downto 0) => s_link_aligned_diagnostics_arr(7 downto 0)      
      );  
    
  -- channel alignment for matches
  i_link_align_ctrl_match_cxp2 : link_align_ctrl   
    generic map (
      G_NUM_OF_LINKs => 8
      )
    port map(
      clk_240_i                      => s_clk_240,
      link_align_req_i               => s_link_align_req,
      bx0_at_240_i                   => bc0_match, --s_local_timing_ref.bc0,
      link_align_o                   => s_link_align_match,
      link_fifo_read_o               => s_link_fifo_read_match,
      link_latency_ctrl_i            => s_link_latency_ctrl_match,
      link_latency_err_o             => s_link_latency_err_match,
      link_mask_ctrl_i               => s_link_mask_ctrl(35 downto 32) & s_link_mask_ctrl(11 downto 8),
      link_aligned_status_arr_i      => s_link_aligned_status_arr(35 downto 32) & s_link_aligned_status_arr(11 downto 8),
      --link_aligned_diagnostics_arr_o => s_link_aligned_diagnostics_arr(35 downto 32) & s_link_aligned_diagnostics_arr(11 downto 8)
      link_aligned_diagnostics_arr_o(7 downto 4) => s_link_aligned_diagnostics_arr(35 downto 32),
      link_aligned_diagnostics_arr_o(3 downto 0) => s_link_aligned_diagnostics_arr(11 downto 8)
      );  
      
----------------------------------------------------------------
----------------------------------------------------------------
      
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

--  i_ila_tx_pattern_generator_ch10 : ila_tx_pattern_generator
--    port map (
--      clk        => s_clk_usrclk_250,
--      probe0(0)  => s_local_timing_ref.bc0,
--      probe1     => s_local_timing_ref.bcid,
--      probe2     => s_gth_tx_data_arr(C_CH10).txdata,
--      probe3     => s_gth_tx_data_arr(C_CH10).txcharisk,
--      probe4     => s_gth_rx_data_arr(C_CH10).rxdata,
--      probe5     => s_gth_rx_data_arr(C_CH10).rxchariscomma,
--      probe6     => s_gth_rx_data_arr(C_CH10).rxcharisk,
--      probe7     => s_gth_rx_data_arr(C_CH10).rxnotintable,
--      probe8     => s_gth_rx_data_arr(C_CH10).rxdisperr,
--      probe9(0)  => s_gth_rx_data_arr(C_CH10).rxbyteisaligned,
--      probe10(0) => s_gth_rx_data_arr(C_CH10).rxbyterealign,
--      probe11(0) => s_gth_rx_data_arr(C_CH10).rxcommadet
--      );


--  i_ila_tx_pattern_generator_ch20 : ila_tx_pattern_generator
--    port map (
--      clk        => s_clk_usrclk_250,
--      probe0(0)  => s_local_timing_ref.bc0,
--      probe1     => s_local_timing_ref.bcid,
--      probe2     => s_gth_tx_data_arr(C_CH20).txdata,
--      probe3     => s_gth_tx_data_arr(C_CH20).txcharisk,
--      probe4     => s_gth_rx_data_arr(C_CH20).rxdata,
--      probe5     => s_gth_rx_data_arr(C_CH20).rxchariscomma,
--      probe6     => s_gth_rx_data_arr(C_CH20).rxcharisk,
--      probe7     => s_gth_rx_data_arr(C_CH20).rxnotintable,
--      probe8     => s_gth_rx_data_arr(C_CH20).rxdisperr,
--      probe9(0)  => s_gth_rx_data_arr(C_CH20).rxbyteisaligned,
--      probe10(0) => s_gth_rx_data_arr(C_CH20).rxbyterealign,
--      probe11(0) => s_gth_rx_data_arr(C_CH20).rxcommadet
--      );

  i_trigger_top : verilog_trigger_top
     port map (
       proc_clk => s_clk_240,
       proc_clk_new => s_clk_new,       --MT
       io_clk => s_clk_240,
       reset => trigger_top_reset,--s_local_timing_ref.bc0,
       
       input_link1_reg1 => HalfStub1_1_H, --s_link_aligned_data_arr(54).data,
       input_link1_reg2 => HalfStub1_1_L, --s_link_aligned_data_arr(53).data,
       input_link2_reg1 => HalfStub1_2_H, --s_link_aligned_data_arr(55).data,
       input_link2_reg2 => HalfStub1_2_L, --s_link_aligned_data_arr(50).data,
       input_link3_reg1 => HalfStub1_3_H, --s_link_aligned_data_arr(52).data,
       input_link3_reg2 => HalfStub1_3_L, --s_link_aligned_data_arr(51).data,
       input_link4_reg1 => HalfStub2_1_H,
       input_link4_reg2 => HalfStub2_1_L,
       input_link5_reg1 => HalfStub2_2_H,
       input_link5_reg2 => HalfStub2_2_L,
       input_link6_reg1 => HalfStub2_3_H,
       input_link6_reg2 => HalfStub2_3_L,
       -- for D4D5D6 project
       input_link7_reg1 => HalfStub3_1_H,
       input_link7_reg2 => HalfStub3_1_L,
       input_link8_reg1 => HalfStub3_2_H,
       input_link8_reg2 => HalfStub3_2_L,
       input_link9_reg1 => HalfStub3_3_H,
       input_link9_reg2 => HalfStub3_3_L,       
       
       BRAM_OUTPUT_addr => BRAM_OUTPUT_addr,
       BRAM_OUTPUT_clk  => BRAM_OUTPUT_clk,
       BRAM_OUTPUT_din  => BRAM_OUTPUT_din,
       BRAM_OUTPUT_dout => BRAM_OUTPUT_dout,
       BRAM_OUTPUT_en   => BRAM_OUTPUT_en,
       BRAM_OUTPUT_rst  => BRAM_OUTPUT_rst,
       BRAM_OUTPUT_we   => BRAM_OUTPUT_we,
       
       Proj_L3F3F5_ToPlus       => Proj_L3F3F5_ToPlus,
       Proj_L3F3F5_ToMinus      => Proj_L3F3F5_ToMinus,
       Proj_L3F3F5_FromPlus     => HalfProj1_H_FromPlus(22 downto 0) & HalfProj1_L_FromPlus(31 downto 0),
       Proj_L3F3F5_FromMinus    => HalfProj1_H_FromMinus(22 downto 0) & HalfProj1_L_FromMinus(31 downto 0),
       
       Proj_L2L4F2_ToPlus       => Proj_L2L4F2_ToPlus,
       Proj_L2L4F2_ToMinus      => Proj_L2L4F2_ToMinus,
       Proj_L2L4F2_FromPlus     => HalfProj2_H_FromPlus(22 downto 0) & HalfProj2_L_FromPlus(31 downto 0),
       Proj_L2L4F2_FromMinus    => HalfProj2_H_FromMinus(22 downto 0) & HalfProj2_L_FromMinus(31 downto 0),
       
       Proj_F1L5_ToPlus       => Proj_F1L5_ToPlus,
       Proj_F1L5_ToMinus      => Proj_F1L5_ToMinus,
       Proj_F1L5_FromPlus     => HalfProj3_H_FromPlus(22 downto 0) & HalfProj3_L_FromPlus(31 downto 0),
       Proj_F1L5_FromMinus    => HalfProj3_H_FromMinus(22 downto 0) & HalfProj3_L_FromMinus(31 downto 0),
       
       Proj_L1L6F4_ToPlus       => Proj_L1L6F4_ToPlus,
       Proj_L1L6F4_ToMinus      => Proj_L1L6F4_ToMinus,
       Proj_L1L6F4_FromPlus     => HalfProj4_H_FromPlus(22 downto 0) & HalfProj4_L_FromPlus(31 downto 0),
       Proj_L1L6F4_FromMinus    => HalfProj4_H_FromMinus(22 downto 0) & HalfProj4_L_FromMinus(31 downto 0),
       
       Match_Layer_ToPlus       => Match_Layer_ToPlus,
       Match_Layer_ToMinus      => Match_Layer_ToMinus,       
       Match_Layer_FromPlus     => HalfMatch_Layer_H_FromPlus(12 downto 0) & HalfMatch_Layer_L_FromPlus(31 downto 0),
       Match_Layer_FromMinus    => HalfMatch_Layer_H_FromMinus(12 downto 0) & HalfMatch_Layer_L_FromMinus(31 downto 0),       

       Match_FDSK_ToPlus       => Match_FDSK_ToPlus,
       Match_FDSK_ToMinus      => Match_FDSK_ToMinus,       
       Match_FDSK_FromPlus     => HalfMatch_FDSK_H_FromPlus(12 downto 0) & HalfMatch_FDSK_L_FromPlus(31 downto 0),
       Match_FDSK_FromMinus    => HalfMatch_FDSK_H_FromMinus(12 downto 0) & HalfMatch_FDSK_L_FromMinus(31 downto 0),       
             
       CT_L1L2          => CT_L1L2,
       CT_L3L4          => CT_L3L4,
       CT_L5L6          => CT_L5L6,
       CT_F1F2          => CT_F1F2,
       CT_F3F4          => CT_F3F4,
       CT_F1L1          => CT_F1L1
     
       );
       
    -- verilog_trigger_top reset
    sync_reset : synchronizer
    generic map (
      N_STAGES => 76
      )
    port map(
      async_i => s_local_timing_ref.bc0,
      clk_i   => s_clk_240,
      sync_o  => trigger_top_reset
      );  
     
 -----------
 -- bc0 delays and synchronaztion
  i_bc0_delays : bc0_delays
--    generic map (
--      G_DATA_WIDTH_1 => 1,
--      G_DATA_WIDTH_2 => 12
--      G_DELAY_1 => 1,
--      G_DELAY_2 => 5,
--      G_DELAY_3 => 3,
--      G_DELAY_4 => 1
--    )
    port map (
      clk_proc  => s_clk_240,
      bc0_i     => s_local_timing_ref.bc0,
      bcid_i    => s_local_timing_ref.bcid,
      bc0_delay_ctrl_1 => s_bc0_delay_ctrl_stub,
      bc0_delay_ctrl_2 => s_bc0_delay_ctrl_proj,
      bc0_delay_ctrl_3 => s_bc0_delay_ctrl_match,
      bc0_delay_ctrl_4 => s_bc0_delay_ctrl_track,
      bc0_out1  => bc0_stub,  
      bc0_out2  => bc0_proj,  
      bc0_out3  => bc0_match,  
      bc0_out4  => bc0_trk,
      bcid_out1 => bcid_stub,  
      bcid_out2 => bcid_proj,  
      bcid_out3 => bcid_match,
      bcid_out4 => bcid_trk
    );
  

end ctp7_v7_demo_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

