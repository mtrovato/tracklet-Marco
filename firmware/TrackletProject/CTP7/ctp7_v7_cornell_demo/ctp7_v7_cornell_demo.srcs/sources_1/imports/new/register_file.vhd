-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: register_file                                           
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.ctp7_v7_build_cfg.all;

use work.gth_pkg.all;
use work.link_align_pkg.all;
use work.rx_capture_pkg.all;
use work.ctp7_utils_pkg.all;
use work.ttc_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity register_file is
  generic (
    C_DATE_CODE      : std_logic_vector (31 downto 0) := x"00000000";
    C_GITHASH_CODE   : std_logic_vector (31 downto 0) := x"00000000";
    C_GIT_REPO_DIRTY : std_logic                      := '0'
    );
  port (

    clk240_i : in std_logic;

    BRAM_CTRL_REG_FILE_en   : in  std_logic;
    BRAM_CTRL_REG_FILE_dout : out std_logic_vector (31 downto 0);
    BRAM_CTRL_REG_FILE_din  : in  std_logic_vector (31 downto 0);
    BRAM_CTRL_REG_FILE_we   : in  std_logic_vector (3 downto 0);
    BRAM_CTRL_REG_FILE_addr : in  std_logic_vector (16 downto 0);
    BRAM_CTRL_REG_FILE_clk  : in  std_logic;
    BRAM_CTRL_REG_FILE_rst  : in  std_logic;

    LED_FP_o : out std_logic_vector(31 downto 0);
    
    ------------------------------
    
       ttc_mmcm_ps_clk_en_o  : out std_logic;

    mmcm_rst_o    : out std_logic;
    mmcm_locked_i : in  std_logic;
    
    tcc_err_cnt_rst_o : out std_logic;  -- Err ctr reset        
    tcc_sinerr_ctr_i  : in  std_logic_vector(15 downto 0);
    tcc_dberr_ctr_i   : in  std_logic_vector(15 downto 0);
    
    bc0_stat_rst_o : out  std_logic;
    bc0_stat_i     : in t_bc0_stat;
  
    ttc_cmd_cnt_rst_o : out  std_logic;
    ttc_cmd_cnt_i     : in t_slv_32_arr(15 downto 0);    

    ttc_cnt_rst_o : out std_logic;

    link_latency_ctrl_o          : out std_logic_vector(15 downto 0);
    link_mask_ctrl_o             : out std_logic_vector(63 downto 0);
    link_aligned_diagnostics_arr : in  t_link_aligned_diagnostics_arr(63 downto 0);
    link_aligned_status_arr_i    : in  t_link_aligned_status_arr(63 downto 0);

    link_align_req_o   : out std_logic;
    link_latency_err_i : in  std_logic;

    gth_gt_txreset_done_i : in std_logic_vector(63 downto 0);
    gth_gt_rxreset_done_i : in std_logic_vector(63 downto 0);

    pat_gen_rst_o : out std_logic;
    capture_rst_o : out std_logic;
    link_8b10b_err_rst_o : out std_logic;


    rx_capture_ctrl_arr_o   : out t_rx_capture_ctrl_arr(63 downto 0);
    rx_capture_status_arr_i : in  t_rx_capture_status_arr(63 downto 0);

    tx_user_word_o : out t_slv_32_arr(63 downto 0)

    );
end register_file;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture register_file_arch of register_file is

--============================================================================
--                                                         Signal declarations
--============================================================================

  signal s_reg_pat_gen_rst     : std_logic;
  signal s_reg_capture_eng_rst : std_logic;


  signal s_reg_capture_arm : std_logic;


  signal s_bx_id_at_marker : t_slv_16_arr(63 downto 0);
  signal s_rx_link_status  : t_slv_16_arr(63 downto 0);


  signal s_reg_link_err_cnt : std_logic_vector(15 downto 0);

  signal s_capture_start_bx_id : std_logic_vector(11 downto 0);
  signal s_capture_mode        : std_logic_vector(1 downto 0);
  signal s_capture_tcds_cmd    : std_logic_vector(3 downto 0);

  constant C_LINK_STAT_CH0_ADDR        : integer := 0;
  constant C_BXID_LINK_OFFSET_CH0_ADDR : integer := 4;
  constant C_LINK_MASK_CH0_ADDR        : integer := 8;
  constant C_TX_USER_WORD_CH0_ADDR     : integer := 12;
  constant C_8B10_ERR_CNT_CH0_ADDR     : integer := 16;


  constant C_CH_to_CH_ADDR_OFFSET : integer := 4 * 64;

  signal s_link_mask : std_logic_vector(63 downto 0);

  signal s_link_align_req    : std_logic;
  signal s_link_latency_ctrl : std_logic_vector(15 downto 0);

  signal s_tx_user_word : t_slv_32_arr(63 downto 0);


  signal s_link_8b10b_err_cnt :  t_slv_32_arr(63 downto 0);
  signal s_link_8b10b_err_rst : std_logic;
  
  signal s_reg_mmcm_rst    : std_logic;
  signal s_reg_mmcm_locked : std_logic;
  
  signal s_reg_tcc_err_cnt_rst : std_logic;  -- Err ctr reset        
  signal s_reg_tcc_sinerr_ctr  : std_logic_vector(15 downto 0);
  signal s_reg_tcc_dberr_ctr   : std_logic_vector(15 downto 0);
  
    signal s_reg_ttc_cnt_rst : std_logic;
    signal s_ttc_cmd_cnt_rst : std_logic;

  
--============================================================================
--                                                          Architecture begin
--============================================================================

begin

  link_align_req_o    <= s_link_align_req;
  link_latency_ctrl_o <= s_link_latency_ctrl;
  link_mask_ctrl_o    <= s_link_mask;

  pat_gen_rst_o <= s_reg_pat_gen_rst;
  capture_rst_o <= s_reg_capture_eng_rst;
  link_8b10b_err_rst_o <= s_link_8b10b_err_rst;
  
  mmcm_rst_o <= s_reg_mmcm_rst;
  s_reg_mmcm_locked <= mmcm_locked_i;
  
  tcc_err_cnt_rst_o    <= s_reg_tcc_err_cnt_rst;
  s_reg_tcc_sinerr_ctr <= tcc_sinerr_ctr_i;
  s_reg_tcc_dberr_ctr  <= tcc_dberr_ctr_i;

  tx_user_word_o <= s_tx_user_word;
  
  bc0_stat_rst_o <= s_reg_ttc_cnt_rst;
  
  
   ttc_cnt_rst_o        <= s_reg_ttc_cnt_rst;
   tcc_err_cnt_rst_o    <= s_reg_tcc_err_cnt_rst;
  
  
  

  gen_cap_logic : for i in 0 to 63 generate

    rx_capture_ctrl_arr_o(i).arm        <= s_reg_capture_arm;
    rx_capture_ctrl_arr_o(i).start_bcid <= s_capture_start_bx_id;
    rx_capture_ctrl_arr_o(i).mode       <= s_capture_mode;
    rx_capture_ctrl_arr_o(i).tcds_cmd   <= s_capture_tcds_cmd;


    s_bx_id_at_marker(i) <= link_aligned_diagnostics_arr(i).bx_id_at_marker;

    s_rx_link_status(i)(0) <= link_aligned_status_arr_i(i).link_OK_extended;
    s_rx_link_status(i)(1) <= link_aligned_status_arr_i(i).alignment_marker_found;
    s_rx_link_status(i)(2) <= gth_gt_txreset_done_i(i);
    s_rx_link_status(i)(3) <= gth_gt_rxreset_done_i(i);
    s_rx_link_status(i)(4) <= '0';
    s_rx_link_status(i)(5) <= '0';
    s_rx_link_status(i)(6) <= '0';
    s_rx_link_status(i)(7) <= '0';

    s_rx_link_status(i)(8) <= link_aligned_status_arr_i(i).link_ERR_latched;

    s_rx_link_status(i)(11) <= link_aligned_status_arr_i(i).fifo_empty;
    s_rx_link_status(i)(12) <= link_aligned_status_arr_i(i).fifo_full;
    s_rx_link_status(i)(13) <= link_aligned_status_arr_i(i).fifo_undrf;
    s_rx_link_status(i)(14) <= link_aligned_status_arr_i(i).fifo_ovrf;

    s_rx_link_status(i)(15) <= s_link_mask(i);


    s_link_8b10b_err_cnt(i) <= link_aligned_status_arr_i(i).link_8b10b_err_cnt;
    
  end generate;


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--                                                                                                         BRAM Controller Write Section
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

  process (BRAM_CTRL_REG_FILE_clk)
  begin
    if(rising_edge(BRAM_CTRL_REG_FILE_clk)) then

      s_link_align_req  <= '0';
      s_reg_capture_arm <= '0';

      s_reg_capture_eng_rst <= '0';
      s_reg_pat_gen_rst     <= '0';
      s_link_8b10b_err_rst       <= '0';
      s_reg_mmcm_rst  <= '0';
      s_reg_tcc_err_cnt_rst  <= '0';
      ttc_mmcm_ps_clk_en_o <= '0';
     
      s_reg_ttc_cnt_rst  <= '0';
      s_reg_tcc_err_cnt_rst  <= '0';
      
      if(BRAM_CTRL_REG_FILE_en = '1' and BRAM_CTRL_REG_FILE_we = "1111") then

        case (BRAM_CTRL_REG_FILE_addr) is

          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => s_link_mask(C_CH0)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => s_link_mask(C_CH1)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => s_link_mask(C_CH2)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => s_link_mask(C_CH3)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => s_link_mask(C_CH4)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => s_link_mask(C_CH5)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => s_link_mask(C_CH6)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => s_link_mask(C_CH7)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => s_link_mask(C_CH8)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => s_link_mask(C_CH9)  <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => s_link_mask(C_CH10) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => s_link_mask(C_CH11) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => s_link_mask(C_CH12) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => s_link_mask(C_CH13) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => s_link_mask(C_CH14) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => s_link_mask(C_CH15) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => s_link_mask(C_CH16) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => s_link_mask(C_CH17) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => s_link_mask(C_CH18) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => s_link_mask(C_CH19) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => s_link_mask(C_CH20) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => s_link_mask(C_CH21) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => s_link_mask(C_CH22) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => s_link_mask(C_CH23) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => s_link_mask(C_CH24) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => s_link_mask(C_CH25) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => s_link_mask(C_CH26) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => s_link_mask(C_CH27) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => s_link_mask(C_CH28) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => s_link_mask(C_CH29) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => s_link_mask(C_CH30) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => s_link_mask(C_CH31) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => s_link_mask(C_CH32) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => s_link_mask(C_CH33) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => s_link_mask(C_CH34) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => s_link_mask(C_CH35) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => s_link_mask(C_CH36) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => s_link_mask(C_CH37) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => s_link_mask(C_CH38) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => s_link_mask(C_CH39) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => s_link_mask(C_CH40) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => s_link_mask(C_CH41) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => s_link_mask(C_CH42) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => s_link_mask(C_CH43) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => s_link_mask(C_CH44) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => s_link_mask(C_CH45) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => s_link_mask(C_CH46) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => s_link_mask(C_CH47) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => s_link_mask(C_CH48) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => s_link_mask(C_CH49) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => s_link_mask(C_CH50) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => s_link_mask(C_CH51) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => s_link_mask(C_CH52) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => s_link_mask(C_CH53) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => s_link_mask(C_CH54) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => s_link_mask(C_CH55) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => s_link_mask(C_CH56) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => s_link_mask(C_CH57) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => s_link_mask(C_CH58) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => s_link_mask(C_CH59) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => s_link_mask(C_CH60) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => s_link_mask(C_CH61) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => s_link_mask(C_CH62) <= BRAM_CTRL_REG_FILE_din(0);
          when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => s_link_mask(C_CH63) <= BRAM_CTRL_REG_FILE_din(0);

          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => s_tx_user_word(C_CH0)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => s_tx_user_word(C_CH1)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => s_tx_user_word(C_CH2)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => s_tx_user_word(C_CH3)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => s_tx_user_word(C_CH4)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => s_tx_user_word(C_CH5)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => s_tx_user_word(C_CH6)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => s_tx_user_word(C_CH7)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => s_tx_user_word(C_CH8)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => s_tx_user_word(C_CH9)  <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => s_tx_user_word(C_CH10) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => s_tx_user_word(C_CH11) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => s_tx_user_word(C_CH12) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => s_tx_user_word(C_CH13) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => s_tx_user_word(C_CH14) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => s_tx_user_word(C_CH15) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => s_tx_user_word(C_CH16) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => s_tx_user_word(C_CH17) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => s_tx_user_word(C_CH18) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => s_tx_user_word(C_CH19) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => s_tx_user_word(C_CH20) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => s_tx_user_word(C_CH21) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => s_tx_user_word(C_CH22) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => s_tx_user_word(C_CH23) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => s_tx_user_word(C_CH24) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => s_tx_user_word(C_CH25) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => s_tx_user_word(C_CH26) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => s_tx_user_word(C_CH27) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => s_tx_user_word(C_CH28) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => s_tx_user_word(C_CH29) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => s_tx_user_word(C_CH30) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => s_tx_user_word(C_CH31) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => s_tx_user_word(C_CH32) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => s_tx_user_word(C_CH33) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => s_tx_user_word(C_CH34) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => s_tx_user_word(C_CH35) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => s_tx_user_word(C_CH36) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => s_tx_user_word(C_CH37) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => s_tx_user_word(C_CH38) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => s_tx_user_word(C_CH39) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => s_tx_user_word(C_CH40) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => s_tx_user_word(C_CH41) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => s_tx_user_word(C_CH42) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => s_tx_user_word(C_CH43) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => s_tx_user_word(C_CH44) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => s_tx_user_word(C_CH45) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => s_tx_user_word(C_CH46) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => s_tx_user_word(C_CH47) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => s_tx_user_word(C_CH48) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => s_tx_user_word(C_CH49) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => s_tx_user_word(C_CH50) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => s_tx_user_word(C_CH51) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => s_tx_user_word(C_CH52) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => s_tx_user_word(C_CH53) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => s_tx_user_word(C_CH54) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => s_tx_user_word(C_CH55) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => s_tx_user_word(C_CH56) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => s_tx_user_word(C_CH57) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => s_tx_user_word(C_CH58) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => s_tx_user_word(C_CH59) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => s_tx_user_word(C_CH60) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => s_tx_user_word(C_CH61) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => s_tx_user_word(C_CH62) <= BRAM_CTRL_REG_FILE_din;
          when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => s_tx_user_word(C_CH63) <= BRAM_CTRL_REG_FILE_din;


--------------------------------------------------------------------------------
          when '1' & X"0000" => s_link_align_req    <= BRAM_CTRL_REG_FILE_din(0);
          when '1' & X"0004" => s_link_latency_ctrl <= BRAM_CTRL_REG_FILE_din(15 downto 0);

          when '1' & X"0040" => s_reg_capture_arm     <= BRAM_CTRL_REG_FILE_din(0);
          when '1' & X"0044" => s_capture_mode        <= BRAM_CTRL_REG_FILE_din(1 downto 0);
          when '1' & X"0048" => s_capture_start_bx_id <= BRAM_CTRL_REG_FILE_din(11 downto 0);
          when '1' & X"004C" => s_capture_tcds_cmd    <= BRAM_CTRL_REG_FILE_din(3 downto 0);

          when '1' & X"0810" => s_reg_capture_eng_rst <= BRAM_CTRL_REG_FILE_din(0);
          when '1' & X"0814" => s_reg_pat_gen_rst     <= BRAM_CTRL_REG_FILE_din(0);

          when '1' & X"0900" => s_link_8b10b_err_rst <= BRAM_CTRL_REG_FILE_din(0);
          
          when '1' & X"1000" => s_reg_mmcm_rst <= BRAM_CTRL_REG_FILE_din(0);
         
          when '1' & X"1008" => ttc_mmcm_ps_clk_en_o  <= BRAM_CTRL_REG_FILE_din(0);
      
          when '1' & X"1010" => s_reg_ttc_cnt_rst     <= BRAM_CTRL_REG_FILE_din(0);

          when '1' & X"1030" => s_reg_tcc_err_cnt_rst <= BRAM_CTRL_REG_FILE_din(0);
         
          when '1' & X"1080" => s_ttc_cmd_cnt_rst     <= BRAM_CTRL_REG_FILE_din(0);


          when '1' & X"C000" => LED_FP_o <= BRAM_CTRL_REG_FILE_din;

          when others => null;

        end case;
      end if;


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--                                                                                                          BRAM Controller Read Section
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

      BRAM_CTRL_REG_FILE_dout <= (others => '0');  --default BRAM dout assignment

      case (BRAM_CTRL_REG_FILE_addr) is

        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH0);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH1);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH2);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH3);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH4);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH5);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH6);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH7);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH8);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH9);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH10);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH11);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH12);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH13);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH14);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH15);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH16);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH17);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH18);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH19);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH20);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH21);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH22);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH23);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH24);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH25);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH26);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH27);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH28);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH29);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH30);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH31);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH32);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH33);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH34);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH35);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH36);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH37);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH38);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH39);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH40);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH41);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH42);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH43);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH44);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH45);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH46);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH47);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH48);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH49);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH50);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH51);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH52);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH53);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH54);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH55);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH56);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH57);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH58);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH59);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH60);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH61);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH62);
        when addr_encode(C_LINK_STAT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_rx_link_status(C_CH63);

        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH0);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH1);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH2);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH3);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH4);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH5);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH6);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH7);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH8);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH9);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH10);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH11);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH12);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH13);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH14);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH15);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH16);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH17);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH18);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH19);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH20);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH21);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH22);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH23);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH24);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH25);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH26);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH27);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH28);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH29);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH30);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH31);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH32);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH33);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH34);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH35);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH36);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH37);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH38);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH39);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH40);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH41);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH42);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH43);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH44);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH45);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH46);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH47);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH48);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH49);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH50);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH51);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH52);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH53);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH54);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH55);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH56);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH57);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH58);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH59);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH60);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH61);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH62);
        when addr_encode(C_BXID_LINK_OFFSET_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_bx_id_at_marker(C_CH63);

        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH0);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH1);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH2);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH3);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH4);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH5);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH6);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH7);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH8);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH9);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH10);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH11);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH12);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH13);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH14);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH15);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH16);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH17);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH18);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH19);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH20);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH21);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH22);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH23);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH24);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH25);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH26);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH27);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH28);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH29);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH30);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH31);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH32);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH33);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH34);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH35);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH36);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH37);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH38);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH39);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH40);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH41);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH42);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH43);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH44);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH45);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH46);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH47);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH48);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH49);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH50);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH51);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH52);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH53);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH54);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH55);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH56);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH57);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH58);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH59);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH60);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH61);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH62);
        when addr_encode(C_LINK_MASK_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => BRAM_CTRL_REG_FILE_dout(0) <= s_link_mask(C_CH63);


        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH0);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH1);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH2);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH3);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH4);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH5);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH6);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH7);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH8);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH9);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH10);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH11);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH12);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH13);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH14);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH15);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH16);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH17);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH18);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH19);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH20);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH21);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH22);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH23);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH24);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH25);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH26);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH27);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH28);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH29);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH30);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH31);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH32);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH33);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH34);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH35);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH36);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH37);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH38);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH39);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH40);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH41);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH42);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH43);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH44);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH45);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH46);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH47);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH48);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH49);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH50);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH51);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH52);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH53);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH54);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH55);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH56);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH57);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH58);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH59);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH60);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH61);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH62);
        when addr_encode(C_TX_USER_WORD_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => BRAM_CTRL_REG_FILE_dout <= s_tx_user_word(C_CH63);


        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH0, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH0);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH1, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH1);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH2, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH2);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH3, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH3);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH4, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH4);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH5, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH5);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH6, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH6);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH7, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH7);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH8, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH8);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH9, 17)  => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH9);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH10, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH10);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH11, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH11);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH12, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH12);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH13, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH13);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH14, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH14);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH15, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH15);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH16, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH16);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH17, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH17);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH18, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH18);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH19, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH19);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH20, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH20);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH21, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH21);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH22, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH22);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH23, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH23);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH24, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH24);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH25, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH25);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH26, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH26);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH27, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH27);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH28, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH28);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH29, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH29);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH30, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH30);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH31, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH31);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH32, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH32);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH33, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH33);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH34, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH34);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH35, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH35);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH36, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH36);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH37, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH37);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH38, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH38);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH39, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH39);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH40, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH40);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH41, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH41);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH42, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH42);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH43, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH43);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH44, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH44);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH45, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH45);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH46, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH46);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH47, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH47);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH48, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH48);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH49, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH49);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH50, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH50);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH51, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH51);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH52, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH52);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH53, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH53);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH54, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH54);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH55, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH55);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH56, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH56);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH57, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH57);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH58, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH58);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH59, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH59);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH60, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH60);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH61, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH61);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH62, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH62);
        when addr_encode(C_8B10_ERR_CNT_CH0_ADDR, C_CH_to_CH_ADDR_OFFSET, C_CH63, 17) => BRAM_CTRL_REG_FILE_dout <= s_link_8b10b_err_cnt(C_CH63);

--------------------------------------------------------------------------------

        when '1' & X"0000" => BRAM_CTRL_REG_FILE_dout(0)           <= s_link_align_req;
        when '1' & X"0004" => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_link_latency_ctrl;
        when '1' & X"0008" => BRAM_CTRL_REG_FILE_dout(0)           <= link_latency_err_i;

        when '1' & X"0040" => BRAM_CTRL_REG_FILE_dout(0)           <= s_reg_capture_arm;
        when '1' & X"0044" => BRAM_CTRL_REG_FILE_dout(1 downto 0)  <= s_capture_mode;
        when '1' & X"0048" => BRAM_CTRL_REG_FILE_dout(11 downto 0) <= s_capture_start_bx_id;
        when '1' & X"004C" => BRAM_CTRL_REG_FILE_dout(3 downto 0)  <= s_capture_tcds_cmd;

--------------------------------------------------------------------------------

        when '1' & X"0810" => BRAM_CTRL_REG_FILE_dout(0) <= s_reg_capture_eng_rst;
        when '1' & X"0814" => BRAM_CTRL_REG_FILE_dout(0) <= s_reg_pat_gen_rst;

--------------------------------------------------------------------------------
        when '1' & X"1000" => BRAM_CTRL_REG_FILE_dout(0) <= s_reg_mmcm_rst;
        when '1' & X"1004" => BRAM_CTRL_REG_FILE_dout(0) <= s_reg_mmcm_locked;

       when '1' & X"1014" => BRAM_CTRL_REG_FILE_dout(0) <= bc0_stat_i.locked;
       when '1' & X"1018" => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= bc0_stat_i.unlocked_cnt;
       when '1' & X"101C" => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= bc0_stat_i.udf_cnt; 
       when '1' & X"1020" => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= bc0_stat_i.ovf_cnt;

        when '1' & X"1030" => BRAM_CTRL_REG_FILE_dout(0)           <= s_reg_tcc_err_cnt_rst;
        when '1' & X"1034" => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_reg_tcc_sinerr_ctr;
        when '1' & X"1038" => BRAM_CTRL_REG_FILE_dout(15 downto 0) <= s_reg_tcc_dberr_ctr;

        when '1' & X"FF0C" => BRAM_CTRL_REG_FILE_dout(23 downto 0) <= BCFG_FW_VERSION_MAJOR &
                                                                      BCFG_FW_VERSION_MINOR &
                                                                      BCFG_FW_VERSION_PATCH;
--------------------------------------------------------------------------------

        when others => BRAM_CTRL_REG_FILE_dout <= (others => '0');

      end case;

    end if;
  end process;

---



end register_file_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

