-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gth_10gbps_buf_cc_gt                                          
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

library work;
use work.gth_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity gth_10gbps_buf_cc_gt is
  generic
    (
      -- Simulation attributes
      g_GT_SIM_GTRESET_SPEEDUP : string := "FALSE"  -- Set to "TRUE" to speed up sim reset
      );
  port
    (
      gth_gt_clk_i : in  t_gth_gt_clk_in;
      gth_gt_clk_o : out t_gth_gt_clk_out;
      gth_gt_drp_i : in  t_gth_gt_drp_in;
      gth_gt_drp_o : out t_gth_gt_drp_out;

      gth_tx_ctrl_i   : in  t_gth_tx_ctrl;
      gth_tx_init_i   : in  t_gth_tx_init;
      gth_tx_status_o : out t_gth_tx_status;

      gth_rx_ctrl_i : in t_gth_rx_ctrl;
      gth_rx_init_i : in t_gth_rx_init;

      gth_rx_status_o : out t_gth_rx_status;

      gth_misc_ctrl_i   : in  t_gth_misc_ctrl;
      gth_misc_status_o : out t_gth_misc_status;

      gth_tx_data_i : in  t_gth_tx_data;
      gth_rx_data_o : out t_gth_rx_data

      );


end gth_10gbps_buf_cc_gt;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture gth_10gbps_buf_cc_gt_arch of gth_10gbps_buf_cc_gt is


--============================================================================
--                                                         Signal declarations
--============================================================================
  -- dummy signals to surpress synth. warnings
  signal s_rxdata_float        : std_logic_vector(31 downto 0);
  signal s_rxchariscomma_float : std_logic_vector(3 downto 0);
  signal s_rxcharisk_float     : std_logic_vector(3 downto 0);
  signal s_rxdisperr_float     : std_logic_vector(3 downto 0);
  signal s_rxnotintable_float  : std_logic_vector(3 downto 0);

--============================================================================
--                                                          Architecture begin
--============================================================================
begin

  ----------------------------- GTHE2 Instance  --------------------------   

  i_gthe2 : GTHE2_CHANNEL
    generic map
    (

      --_______________________ Simulation-Only Attributes ___________________

      SIM_RECEIVER_DETECT_PASS => ("TRUE"),
      SIM_RESET_SPEEDUP        => (g_GT_SIM_GTRESET_SPEEDUP),
      SIM_TX_EIDLE_DRIVE_LEVEL => ("X"),
      SIM_CPLLREFCLK_SEL       => ("001"),
      SIM_VERSION              => ("2.0"),


      ------------------RX Byte and Word Alignment Attributes---------------
      ALIGN_COMMA_DOUBLE => ("FALSE"),
      ALIGN_COMMA_ENABLE => ("1111111111"),
      ALIGN_COMMA_WORD   => (4),
      ALIGN_MCOMMA_DET   => ("TRUE"),
      ALIGN_MCOMMA_VALUE => ("1010000011"),
      ALIGN_PCOMMA_DET   => ("TRUE"),
      ALIGN_PCOMMA_VALUE => ("0101111100"),
      SHOW_REALIGN_COMMA => ("TRUE"),
      RXSLIDE_AUTO_WAIT  => (7),
      RXSLIDE_MODE       => ("OFF"),
      RX_SIG_VALID_DLY   => (10),

      ------------------RX 8B/10B Decoder Attributes---------------
      RX_DISPERR_SEQ_MATCH => ("TRUE"),
      DEC_MCOMMA_DETECT    => ("TRUE"),
      DEC_PCOMMA_DETECT    => ("TRUE"),
      DEC_VALID_COMMA_ONLY => ("FALSE"),

      ------------------------RX Clock Correction Attributes----------------------
      CBCC_DATA_SOURCE_SEL => ("DECODED"),
      CLK_COR_SEQ_2_USE    => ("FALSE"),
      CLK_COR_KEEP_IDLE    => ("FALSE"),
      CLK_COR_MAX_LAT      => (31),
      CLK_COR_MIN_LAT      => (24),
      CLK_COR_PRECEDENCE   => ("TRUE"),
      CLK_COR_REPEAT_WAIT  => (0),
      CLK_COR_SEQ_LEN      => (4),
      CLK_COR_SEQ_1_ENABLE => ("1111"),
      CLK_COR_SEQ_1_1      => ("0111110111"),
      CLK_COR_SEQ_1_2      => ("0111110111"),
      CLK_COR_SEQ_1_3      => ("0111110111"),
      CLK_COR_SEQ_1_4      => ("0111110111"),
      CLK_CORRECT_USE      => ("TRUE"),
      CLK_COR_SEQ_2_ENABLE => ("1111"),
      CLK_COR_SEQ_2_1      => ("0000000000"),
      CLK_COR_SEQ_2_2      => ("0000000000"),
      CLK_COR_SEQ_2_3      => ("0000000000"),
      CLK_COR_SEQ_2_4      => ("0000000000"),

      ------------------------RX Channel Bonding Attributes----------------------
      CHAN_BOND_KEEP_ALIGN   => ("FALSE"),
      CHAN_BOND_MAX_SKEW     => (1),
      CHAN_BOND_SEQ_LEN      => (1),
      CHAN_BOND_SEQ_1_1      => ("0000000000"),
      CHAN_BOND_SEQ_1_2      => ("0000000000"),
      CHAN_BOND_SEQ_1_3      => ("0000000000"),
      CHAN_BOND_SEQ_1_4      => ("0000000000"),
      CHAN_BOND_SEQ_1_ENABLE => ("1111"),
      CHAN_BOND_SEQ_2_1      => ("0000000000"),
      CHAN_BOND_SEQ_2_2      => ("0000000000"),
      CHAN_BOND_SEQ_2_3      => ("0000000000"),
      CHAN_BOND_SEQ_2_4      => ("0000000000"),
      CHAN_BOND_SEQ_2_ENABLE => ("1111"),
      CHAN_BOND_SEQ_2_USE    => ("FALSE"),
      FTS_DESKEW_SEQ_ENABLE  => ("1111"),
      FTS_LANE_DESKEW_CFG    => ("1111"),
      FTS_LANE_DESKEW_EN     => ("FALSE"),

      ---------------------------RX Margin Analysis Attributes----------------------------
      ES_CONTROL     => ("000000"),
      ES_ERRDET_EN   => ("FALSE"),
      ES_EYE_SCAN_EN => ("TRUE"),
      ES_HORZ_OFFSET => (x"000"),
      ES_PMA_CFG     => ("0000000000"),
      ES_PRESCALE    => ("00000"),
      ES_QUALIFIER   => (x"00000000000000000000"),
      ES_QUAL_MASK   => (x"00000000000000000000"),
      ES_SDATA_MASK  => (x"00000000000000000000"),
      ES_VERT_OFFSET => ("000000000"),

      -------------------------FPGA RX Interface Attributes-------------------------
      RX_DATA_WIDTH => (40),

      ---------------------------PMA Attributes----------------------------
      OUTREFCLK_SEL_INV => ("11"),
      PMA_RSV           => (x"001E7080"),
      PMA_RSV2          => (x"1C00000A"),
      PMA_RSV3          => ("00"),
      PMA_RSV4          => (x"0008"),
      RX_BIAS_CFG       => ("000011000000000000010000"),
      DMONITOR_CFG      => (x"000A00"),
      RX_CM_SEL         => ("00"),
      RX_CM_TRIM        => ("0000"),
      RX_DEBUG_CFG      => ("00000000000000"),
      RX_OS_CFG         => ("0000010000000"),
      TERM_RCAL_CFG     => ("100001000010000"),
      TERM_RCAL_OVRD    => ("000"),
      TST_RSV           => (x"00000000"),
      RX_CLK25_DIV      => (10),
      TX_CLK25_DIV      => (10),
      UCODEER_CLR       => ('0'),

      ---------------------------PCI Express Attributes----------------------------
      PCS_PCIE_EN => ("FALSE"),

      ---------------------------PCS Attributes----------------------------
      PCS_RSVD_ATTR => (x"000000000000"),

      -------------RX Buffer Attributes------------
      RXBUF_ADDR_MODE            => ("FULL"),
      RXBUF_EIDLE_HI_CNT         => ("1000"),
      RXBUF_EIDLE_LO_CNT         => ("0000"),
      RXBUF_EN                   => ("TRUE"),
      RX_BUFFER_CFG              => ("000000"),
      RXBUF_RESET_ON_CB_CHANGE   => ("TRUE"),
      RXBUF_RESET_ON_COMMAALIGN  => ("FALSE"),
      RXBUF_RESET_ON_EIDLE       => ("FALSE"),
      RXBUF_RESET_ON_RATE_CHANGE => ("TRUE"),
      RXBUFRESET_TIME            => ("00001"),
      RXBUF_THRESH_OVFLW         => (61),
      RXBUF_THRESH_OVRD          => ("FALSE"),
      RXBUF_THRESH_UNDFLW        => (4),
      RXDLY_CFG                  => (x"001F"),
      RXDLY_LCFG                 => (x"030"),
      RXDLY_TAP_CFG              => (x"0000"),
      RXPH_CFG                   => (x"C00002"),
      RXPHDLY_CFG                => (x"084020"),
      RXPH_MONITOR_SEL           => ("00000"),
      RX_XCLK_SEL                => ("RXREC"),
      RX_DDI_SEL                 => ("000000"),
      RX_DEFER_RESET_BUF_EN      => ("TRUE"),

      -----------------------CDR Attributes-------------------------

      --For Display Port, HBR/RBR- set RXCDR_CFG=72'h0380008bff40200008

      --For Display Port, HBR2 -   set RXCDR_CFG=72'h038c008bff20200010
      RXCDR_CFG               => (x"0002007FE2000C208001A"),
      RXCDR_FR_RESET_ON_EIDLE => ('0'),
      RXCDR_HOLD_DURING_EIDLE => ('0'),
      RXCDR_PH_RESET_ON_EIDLE => ('0'),
      RXCDR_LOCK_CFG          => ("010101"),

      -------------------RX Initialization and Reset Attributes-------------------
      RXCDRFREQRESET_TIME => ("00001"),
      RXCDRPHRESET_TIME   => ("00001"),
      RXISCANRESET_TIME   => ("00001"),
      RXPCSRESET_TIME     => ("00001"),
      RXPMARESET_TIME     => ("00011"),

      -------------------RX OOB Signaling Attributes-------------------
      RXOOB_CFG => ("0000110"),

      -------------------------RX Gearbox Attributes---------------------------
      RXGEARBOX_EN => ("FALSE"),
      GEARBOX_MODE => ("000"),

      -------------------------PRBS Detection Attribute-----------------------
      RXPRBS_ERR_LOOPBACK => ('1'),

      -------------Power-Down Attributes----------
      PD_TRANS_TIME_FROM_P2 => (x"03c"),
      PD_TRANS_TIME_NONE_P2 => (x"3c"),
      PD_TRANS_TIME_TO_P2   => (x"64"),

      -------------RX OOB Signaling Attributes----------
      SAS_MAX_COM        => (64),
      SAS_MIN_COM        => (36),
      SATA_BURST_SEQ_LEN => ("1111"),
      SATA_BURST_VAL     => ("100"),
      SATA_EIDLE_VAL     => ("100"),
      SATA_MAX_BURST     => (8),
      SATA_MAX_INIT      => (21),
      SATA_MAX_WAKE      => (7),
      SATA_MIN_BURST     => (4),
      SATA_MIN_INIT      => (12),
      SATA_MIN_WAKE      => (4),

      -------------RX Fabric Clock Output Control Attributes----------
      TRANS_TIME_RATE => (x"0E"),

      --------------TX Buffer Attributes----------------
      TXBUF_EN                   => ("TRUE"),
      TXBUF_RESET_ON_RATE_CHANGE => ("TRUE"),
      TXDLY_CFG                  => (x"001F"),
      TXDLY_LCFG                 => (x"030"),
      TXDLY_TAP_CFG              => (x"0000"),
      TXPH_CFG                   => (x"0780"),
      TXPHDLY_CFG                => (x"084020"),
      TXPH_MONITOR_SEL           => ("00000"),
      TX_XCLK_SEL                => ("TXOUT"),

      -------------------------FPGA TX Interface Attributes-------------------------
      TX_DATA_WIDTH => (40),

      -------------------------TX Configurable Driver Attributes-------------------------
      TX_DEEMPH0              => ("000000"),
      TX_DEEMPH1              => ("000000"),
      TX_EIDLE_ASSERT_DELAY   => ("110"),
      TX_EIDLE_DEASSERT_DELAY => ("100"),
      TX_LOOPBACK_DRIVE_HIZ   => ("FALSE"),
      TX_MAINCURSOR_SEL       => ('0'),
      TX_DRIVE_MODE           => ("DIRECT"),
      TX_MARGIN_FULL_0        => ("1001110"),
      TX_MARGIN_FULL_1        => ("1001001"),
      TX_MARGIN_FULL_2        => ("1000101"),
      TX_MARGIN_FULL_3        => ("1000010"),
      TX_MARGIN_FULL_4        => ("1000000"),
      TX_MARGIN_LOW_0         => ("1000110"),
      TX_MARGIN_LOW_1         => ("1000100"),
      TX_MARGIN_LOW_2         => ("1000010"),
      TX_MARGIN_LOW_3         => ("1000000"),
      TX_MARGIN_LOW_4         => ("1000000"),

      -------------------------TX Gearbox Attributes--------------------------
      TXGEARBOX_EN => ("FALSE"),

      -------------------------TX Initialization and Reset Attributes--------------------------
      TXPCSRESET_TIME => ("00001"),
      TXPMARESET_TIME => ("00001"),

      -------------------------TX Receiver Detection Attributes--------------------------
      TX_RXDETECT_CFG => (x"1832"),
      TX_RXDETECT_REF => ("100"),

      ----------------------------CPLL Attributes----------------------------
      CPLL_CFG        => (x"00BC07DC"),
      CPLL_FBDIV      => (5),
      CPLL_FBDIV_45   => (5),
      CPLL_INIT_CFG   => (x"00001E"),
      CPLL_LOCK_CFG   => (x"01E8"),
      CPLL_REFCLK_DIV => (1),
      RXOUT_DIV       => (1),
      TXOUT_DIV       => (1),
      SATA_CPLL_CFG   => ("VCO_3000MHZ"),

      --------------RX Initialization and Reset Attributes-------------
      RXDFELPMRESET_TIME => ("0001111"),

      --------------RX Equalizer Attributes-------------
      RXLPM_HF_CFG                 => ("00001000000000"),
      RXLPM_LF_CFG                 => ("001001000000000000"),
      RX_DFE_GAIN_CFG              => (x"0020C0"),
      RX_DFE_H2_CFG                => ("000000000000"),
      RX_DFE_H3_CFG                => ("000001000000"),
      RX_DFE_H4_CFG                => ("00011100000"),
      RX_DFE_H5_CFG                => ("00011100000"),
      RX_DFE_KL_CFG                => ("001000001000000000000001100010000"),
      RX_DFE_LPM_CFG               => (x"0080"),
      RX_DFE_LPM_HOLD_DURING_EIDLE => ('0'),
      RX_DFE_UT_CFG                => ("00011100000000000"),
      RX_DFE_VP_CFG                => ("00011101010100011"),

      -------------------------Power-Down Attributes-------------------------
      RX_CLKMUX_PD => ('1'),
      TX_CLKMUX_PD => ('1'),

      -------------------------FPGA RX Interface Attribute-------------------------
      RX_INT_DATAWIDTH => (1),

      -------------------------FPGA TX Interface Attribute-------------------------
      TX_INT_DATAWIDTH => (1),

      ------------------TX Configurable Driver Attributes---------------
      TX_QPI_STATUS_EN => ('0'),

      ------------------ JTAG Attributes ---------------
      ACJTAG_DEBUG_MODE       => ('0'),
      ACJTAG_MODE             => ('0'),
      ACJTAG_RESET            => ('0'),
      ADAPT_CFG0              => (x"00C10"),
      CFOK_CFG                => (x"24800040E80"),
      CFOK_CFG2               => (x"20"),
      CFOK_CFG3               => (x"20"),
      ES_CLK_PHASE_SEL        => ('0'),
      PMA_RSV5                => (x"0"),
      RESET_POWERSAVE_DISABLE => ('0'),
      USE_PCS_CLK_PHASE_SEL   => ('0'),
      A_RXOSCALRESET          => ('0'),

      ------------------ RX Phase Interpolator Attributes---------------
      RXPI_CFG0 => ("00"),
      RXPI_CFG1 => ("11"),
      RXPI_CFG2 => ("11"),
      RXPI_CFG3 => ("11"),
      RXPI_CFG4 => ('0'),
      RXPI_CFG5 => ('0'),
      RXPI_CFG6 => ("100"),

      --------------RX Decision Feedback Equalizer(DFE)-------------
      RX_DFELPM_CFG0             => ("0110"),
      RX_DFELPM_CFG1             => ('0'),
      RX_DFELPM_KLKH_AGC_STUP_EN => ('1'),
      RX_DFE_AGC_CFG0            => ("00"),
      RX_DFE_AGC_CFG1            => ("100"),
      RX_DFE_AGC_CFG2            => ("0000"),
      RX_DFE_AGC_OVRDEN          => ('1'),
      RX_DFE_H6_CFG              => (x"020"),
      RX_DFE_H7_CFG              => (x"020"),
      RX_DFE_KL_LPM_KH_CFG0      => ("01"),
      RX_DFE_KL_LPM_KH_CFG1      => ("010"),
      RX_DFE_KL_LPM_KH_CFG2      => ("0010"),
      RX_DFE_KL_LPM_KH_OVRDEN    => ('1'),
      RX_DFE_KL_LPM_KL_CFG0      => ("10"),
      RX_DFE_KL_LPM_KL_CFG1      => ("010"),
      RX_DFE_KL_LPM_KL_CFG2      => ("0010"),
      RX_DFE_KL_LPM_KL_OVRDEN    => ('1'),
      RX_DFE_ST_CFG              => (x"00E100000C003F"),

      ------------------ TX Phase Interpolator Attributes---------------
      TXPI_CFG0                  => ("00"),
      TXPI_CFG1                  => ("00"),
      TXPI_CFG2                  => ("00"),
      TXPI_CFG3                  => ('0'),
      TXPI_CFG4                  => ('0'),
      TXPI_CFG5                  => ("100"),
      TXPI_GREY_SEL              => ('0'),
      TXPI_INVSTROBE_SEL         => ('0'),
      TXPI_PPMCLK_SEL            => ("TXUSRCLK2"),
      TXPI_PPM_CFG               => (x"00"),
      TXPI_SYNFREQ_PPM           => ("000"),
      TX_RXDETECT_PRECHARGE_TIME => (x"155CC"),

      ------------------ LOOPBACK Attributes---------------
      LOOPBACK_CFG => ('0'),

      ------------------RX OOB Signalling Attributes---------------
      RXOOB_CLK_CFG => ("PMA"),

      ------------------ CDR Attributes ---------------
      RXOSCALRESET_TIME    => ("00011"),
      RXOSCALRESET_TIMEOUT => ("00000"),

      ------------------TX OOB Signalling Attributes---------------
      TXOOB_CFG => ('0'),

      ------------------RX Buffer Attributes---------------
      RXSYNC_MULTILANE => ('1'),
      RXSYNC_OVRD      => ('0'),
      RXSYNC_SKIP_DA   => ('0'),

      ------------------TX Buffer Attributes---------------
      TXSYNC_MULTILANE => ('0'),
      TXSYNC_OVRD      => ('0'),
      TXSYNC_SKIP_DA   => ('0')
      )
    port map
    (
      --------------------------------- CPLL Ports -------------------------------
      CPLLFBCLKLOST              => open,
      CPLLLOCK                   => open,
      CPLLLOCKDETCLK             => '0',
      CPLLLOCKEN                 => '1',
      CPLLPD                     => '1',
      CPLLREFCLKLOST             => open,
      CPLLREFCLKSEL              => "001",
      CPLLRESET                  => '0',
      GTRSVD                     => "0000000000000000",
      PCSRSVDIN                  => "0000000000000000",
      PCSRSVDIN2                 => "00000",
      PMARSVDIN                  => "00000",
      TSTIN                      => "11111111111111111111",
      -------------------------- Channel - Clocking Ports ------------------------
      GTGREFCLK                  => '0',
      GTNORTHREFCLK0             => '0',
      GTNORTHREFCLK1             => '0',
      GTREFCLK0                  => gth_gt_clk_i.gtrefclk0,
      GTREFCLK1                  => '0',
      GTSOUTHREFCLK0             => '0',
      GTSOUTHREFCLK1             => '0',
      ---------------------------- Channel - DRP Ports  --------------------------
      DRPADDR                    => gth_gt_drp_i.DRPADDR,
      DRPCLK                     => gth_gt_drp_i.DRPCLK,
      DRPDI                      => gth_gt_drp_i.DRPDI,
      DRPDO                      => gth_gt_drp_o.DRPDO,
      DRPEN                      => gth_gt_drp_i.DRPEN,
      DRPRDY                     => gth_gt_drp_o.DRPRDY,
      DRPWE                      => gth_gt_drp_i.DRPWE,
      ------------------------------- Clocking Ports -----------------------------
      GTREFCLKMONITOR            => open,
      QPLLCLK                    => gth_gt_clk_i.qpllclk,
      QPLLREFCLK                 => gth_gt_clk_i.qpllrefclk,
      RXSYSCLKSEL                => gth_rx_ctrl_i.rxsysclksel,
      TXSYSCLKSEL                => gth_tx_ctrl_i.txsysclksel,
      ----------------- FPGA TX Interface Datapath Configuration  ----------------
      TX8B10BEN                  => '1',
      ------------------------------- Loopback Ports -----------------------------
      LOOPBACK                   => gth_misc_ctrl_i.loopback,
      ----------------------------- PCI Express Ports ----------------------------
      PHYSTATUS                  => open,
      RXRATE                     => "000",
      RXVALID                    => open,
      ------------------------------ Power-Down Ports ----------------------------
      RXPD                       => gth_rx_ctrl_i.rxpd,
      TXPD                       => gth_tx_ctrl_i.txpd,
      -------------------------- RX 8B/10B Decoder Ports -------------------------
      SETERRSTATUS               => '0',
      --------------------- RX Initialization and Reset Ports --------------------
      EYESCANRESET               => gth_misc_ctrl_i.eyescanreset,
      RXUSERRDY                  => gth_rx_init_i.rxuserrdy,
      -------------------------- RX Margin Analysis Ports ------------------------
      EYESCANDATAERROR           => gth_misc_status_o.eyescandataerror,
      EYESCANMODE                => '0',  -- reserved
      EYESCANTRIGGER             => gth_misc_ctrl_i.eyescantrigger,
      ------------------------------- Receive Ports ------------------------------
      CLKRSVD0                   => '0',
      CLKRSVD1                   => '0',
      DMONFIFORESET              => '0',
      DMONITORCLK                => '0',
      RXPMARESETDONE             => gth_rx_status_o.RXPMARESETDONE,
      RXRATEMODE                 => '0',
      SIGVALIDCLK                => '0',
      TXPMARESETDONE             => gth_tx_status_o.TXPMARESETDONE,
      -------------- Receive Ports - 64b66b and 64b67b Gearbox Ports -------------
      RXSTARTOFSEQ               => open,
      ------------------------- Receive Ports - CDR Ports ------------------------
      RXCDRFREQRESET             => '0',
      RXCDRHOLD                  => '0',
      RXCDRLOCK                  => open,
      RXCDROVRDEN                => '0',
      RXCDRRESET                 => '0',
      RXCDRRESETRSV              => '0',
      ------------------- Receive Ports - Clock Correction Ports -----------------
      RXCLKCORCNT                => gth_rx_status_o.rxclkcorcnt,
      --------------- Receive Ports - Comma Detection and Alignment --------------
      RXSLIDE                    => '0',
      ------------------- Receive Ports - Digital Monitor Ports ------------------
      DMONITOROUT                => open,
      ---------- Receive Ports - FPGA RX Interface Datapath Configuration --------
      RX8B10BEN                  => '1',
      ------------------ Receive Ports - FPGA RX Interface Ports -----------------
      RXUSRCLK                   => gth_gt_clk_i.rxusrclk,
      RXUSRCLK2                  => gth_gt_clk_i.rxusrclk2,
      ------------------ Receive Ports - FPGA RX interface Ports -----------------
      RXDATA(63 downto 32)       => s_rxdata_float,
      RXDATA(31 downto 0)        => gth_rx_data_o.rxdata,
      ------------------- Receive Ports - Pattern Checker Ports ------------------
      RXPRBSERR                  => gth_rx_status_o.rxprbserr,
      RXPRBSSEL                  => gth_rx_ctrl_i.rxprbssel,
      ------------------- Receive Ports - Pattern Checker ports ------------------
      RXPRBSCNTRESET             => gth_rx_ctrl_i.rxprbscntreset,
      ------------------ Receive Ports - RX 8B/10B Decoder Ports -----------------
      RXDISPERR(7 downto 4)      => s_rxdisperr_float,
      RXDISPERR(3 downto 0)      => gth_rx_data_o.rxdisperr,

      RXNOTINTABLE(7 downto 4)   => s_rxnotintable_float,
      RXNOTINTABLE(3 downto 0)   => gth_rx_data_o.rxnotintable,
      ------------------------ Receive Ports - RX AFE Ports ----------------------
      GTHRXN                     => '0',
      ------------------- Receive Ports - RX Buffer Bypass Ports -----------------
      RXBUFRESET                 => gth_rx_ctrl_i.rxbufreset,
      RXBUFSTATUS                => gth_rx_status_o.rxbufstatus,
      RXDDIEN                    => '0',
      RXDLYBYPASS                => '1',
      RXDLYEN                    => '0',
      RXDLYOVRDEN                => '0',
      RXDLYSRESET                => '0',
      RXDLYSRESETDONE            => open,
      RXPHALIGN                  => '0',
      RXPHALIGNDONE              => open,
      RXPHALIGNEN                => '0',
      RXPHDLYPD                  => '0',
      RXPHDLYRESET               => '0',
      RXPHMONITOR                => open,
      RXPHOVRDEN                 => '0',
      RXPHSLIPMONITOR            => open,
      RXSTATUS                   => open,
      RXSYNCALLIN                => '0',
      RXSYNCDONE                 => open,
      RXSYNCIN                   => '0',
      RXSYNCMODE                 => '0',
      RXSYNCOUT                  => open,
      -------------- Receive Ports - RX Byte and Word Alignment Ports ------------
      RXBYTEISALIGNED            => gth_rx_data_o.rxbyteisaligned,
      RXBYTEREALIGN              => gth_rx_data_o.rxbyterealign,
      RXCOMMADET                 => gth_rx_data_o.rxcommadet,
      RXCOMMADETEN               => '1',
      RXMCOMMAALIGNEN            => '1',
      RXPCOMMAALIGNEN            => '1',
      ------------------ Receive Ports - RX Channel Bonding Ports ----------------
      RXCHANBONDSEQ              => open,
      RXCHBONDEN                 => '0',
      RXCHBONDLEVEL              => "000",
      RXCHBONDMASTER             => '0',
      RXCHBONDO                  => open,
      RXCHBONDSLAVE              => '0',
      ----------------- Receive Ports - RX Channel Bonding Ports  ----------------
      RXCHANISALIGNED            => open,
      RXCHANREALIGN              => open,
      ------------ Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
      RSOSINTDONE                => open,
      RXDFESLIDETAPOVRDEN        => '0',
      RXOSCALRESET               => '0',
      -------------------- Receive Ports - RX Equailizer Ports -------------------
      RXLPMHFHOLD                => gth_rx_init_i.RXLPMHFHOLD,
      RXLPMHFOVRDEN              => gth_rx_init_i.RXLPMHFOVRDEN,
      RXLPMLFHOLD                => gth_rx_init_i.RXLPMLFHOLD,
      --------------------- Receive Ports - RX Equalizar Ports -------------------
      RXDFESLIDETAPSTARTED       => open,
      RXDFESLIDETAPSTROBEDONE    => open,
      RXDFESLIDETAPSTROBESTARTED => open,
      --------------------- Receive Ports - RX Equalizer Ports -------------------
      RXADAPTSELTEST             => "00000000000000",
      RXDFEAGCHOLD               => gth_rx_init_i.rxdfeagchold,
      RXDFEAGCOVRDEN             => gth_rx_init_i.rxdfeagcovrden,
      RXDFEAGCTRL                => "10000",
      RXDFECM1EN                 => '0',
      RXDFELFHOLD                => gth_rx_init_i.rxdfelfhold,
      RXDFELFOVRDEN              => gth_rx_init_i.RXDFELFOVRDEN,
      RXDFELPMRESET              => gth_rx_init_i.rxdfelpmreset,
      RXDFESLIDETAP              => "00000",
      RXDFESLIDETAPADAPTEN       => '0',
      RXDFESLIDETAPHOLD          => '0',
      RXDFESLIDETAPID            => "000000",
      RXDFESLIDETAPINITOVRDEN    => '0',
      RXDFESLIDETAPONLYADAPTEN   => '0',
      RXDFESLIDETAPSTROBE        => '0',
      RXDFESTADAPTDONE           => open,
      RXDFETAP2HOLD              => '0',
      RXDFETAP2OVRDEN            => '0',
      RXDFETAP3HOLD              => '0',
      RXDFETAP3OVRDEN            => '0',
      RXDFETAP4HOLD              => '0',
      RXDFETAP4OVRDEN            => '0',
      RXDFETAP5HOLD              => '0',
      RXDFETAP5OVRDEN            => '0',
      RXDFETAP6HOLD              => '0',
      RXDFETAP6OVRDEN            => '0',
      RXDFETAP7HOLD              => '0',
      RXDFETAP7OVRDEN            => '0',
      RXDFEUTHOLD                => '0',
      RXDFEUTOVRDEN              => '0',
      RXDFEVPHOLD                => '0',
      RXDFEVPOVRDEN              => '0',
      RXDFEVSEN                  => '0',
      RXDFEXYDEN                 => '1',
      RXLPMLFKLOVRDEN            => gth_rx_init_i.rxlpmlfklovrden,
      RXMONITOROUT               => open,
      RXMONITORSEL               => "11",
      RXOSHOLD                   => '0',
      RXOSINTCFG                 => "0110",
      RXOSINTEN                  => '1',
      RXOSINTHOLD                => '0',
      RXOSINTID0                 => "0000",
      RXOSINTNTRLEN              => '0',
      RXOSINTOVRDEN              => '0',
      RXOSINTSTARTED             => open,
      RXOSINTSTROBE              => '0',
      RXOSINTSTROBEDONE          => open,
      RXOSINTSTROBESTARTED       => open,
      RXOSINTTESTOVRDEN          => '0',
      RXOSOVRDEN                 => '0',
      ------------ Receive Ports - RX Fabric ClocK Output Control Ports ----------
      RXRATEDONE                 => open,
      --------------- Receive Ports - RX Fabric Output Control Ports -------------
      RXOUTCLK                   => gth_gt_clk_o.rxoutclk,
      RXOUTCLKFABRIC             => open,
      RXOUTCLKPCS                => open,
      RXOUTCLKSEL                => "010",
      ---------------------- Receive Ports - RX Gearbox Ports --------------------
      RXDATAVALID                => open,
      RXHEADER                   => open,
      RXHEADERVALID              => open,
      --------------------- Receive Ports - RX Gearbox Ports  --------------------
      RXGEARBOXSLIP              => '0',
      ------------- Receive Ports - RX Initialization and Reset Ports ------------
      GTRXRESET                  => gth_rx_init_i.gtrxreset,
      RXOOBRESET                 => '0',
      RXPCSRESET                 => '0',
      RXPMARESET                 => '0',
      ------------------ Receive Ports - RX Margin Analysis ports ----------------
      RXLPMEN                    => gth_rx_ctrl_i.rxlpmen,
      ------------------- Receive Ports - RX OOB Signaling ports -----------------
      RXCOMSASDET                => open,
      RXCOMWAKEDET               => open,
      ------------------ Receive Ports - RX OOB Signaling ports  -----------------
      RXCOMINITDET               => open,
      ------------------ Receive Ports - RX OOB signalling Ports -----------------
      RXELECIDLE                 => open,
      RXELECIDLEMODE             => "11",
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      RXPOLARITY                 => gth_rx_ctrl_i.rxpolarity,
      ------------------- Receive Ports - RX8B/10B Decoder Ports -----------------
      RXCHARISCOMMA(7 downto 4)  => s_rxchariscomma_float,
      RXCHARISCOMMA(3 downto 0)  => gth_rx_data_o.rxchariscomma,
      RXCHARISK(7 downto 4)      => s_rxcharisk_float,
      RXCHARISK(3 downto 0)      => gth_rx_data_o.rxcharisk,
      ------------------ Receive Ports - Rx Channel Bonding Ports ----------------
      RXCHBONDI                  => "00000",
      ------------------------ Receive Ports -RX AFE Ports -----------------------
      GTHRXP                     => '1',
      -------------- Receive Ports -RX Initialization and Reset Ports ------------
      RXRESETDONE                => gth_rx_status_o.rxresetdone,
      -------------------------------- Rx AFE Ports ------------------------------
      RXQPIEN                    => '0',
      RXQPISENN                  => open,
      RXQPISENP                  => open,
      --------------------------- TX Buffer Bypass Ports -------------------------
      TXPHDLYTSTCLK              => '0',
      ------------------------ TX Configurable Driver Ports ----------------------
      TXPOSTCURSOR               => gth_tx_ctrl_i.txpostcursor,
      TXPOSTCURSORINV            => '0',
      TXPRECURSOR                => gth_tx_ctrl_i.txprecursor,
      TXPRECURSORINV             => '0',
      TXQPIBIASEN                => '0',
      TXQPISTRONGPDOWN           => '0',
      TXQPIWEAKPUP               => '0',
      --------------------- TX Initialization and Reset Ports --------------------
      CFGRESET                   => '0',
      GTTXRESET                  => gth_tx_init_i.gttxreset,
      PCSRSVDOUT                 => open,
      TXUSERRDY                  => gth_tx_init_i.txuserrdy,
      ----------------- TX Phase Interpolator PPM Controller Ports ---------------
      TXPIPPMEN                  => '0',
      TXPIPPMOVRDEN              => '0',
      TXPIPPMPD                  => '0',
      TXPIPPMSEL                 => '0',
      TXPIPPMSTEPSIZE            => "00000",
      ---------------------- Transceiver Reset Mode Operation --------------------
      GTRESETSEL                 => '0',
      RESETOVRD                  => '0',
      ------------------------------- Transmit Ports -----------------------------
      TXRATEMODE                 => '0',
      -------------- Transmit Ports - 64b66b and 64b67b Gearbox Ports ------------
      TXHEADER                   => "000",
      ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
      TXCHARDISPMODE             => "00000000",
      TXCHARDISPVAL              => "00000000",
      ------------------ Transmit Ports - FPGA TX Interface Ports ----------------
      TXUSRCLK                   => gth_gt_clk_i.txusrclk,
      TXUSRCLK2                  => gth_gt_clk_i.txusrclk2,
      --------------------- Transmit Ports - PCI Express Ports -------------------
      TXELECIDLE                 => '0',
      TXMARGIN                   => "000",
      TXRATE                     => "000",
      TXSWING                    => '0',
      ------------------ Transmit Ports - Pattern Generator Ports ----------------
      TXPRBSFORCEERR             => gth_tx_ctrl_i.txprbsforceerr,
      ------------------ Transmit Ports - TX Buffer Bypass Ports -----------------
      TXDLYBYPASS                => '1',
      TXDLYEN                    => '0',
      TXDLYHOLD                  => '0',
      TXDLYOVRDEN                => '0',
      TXDLYSRESET                => '0',
      TXDLYSRESETDONE            => open,
      TXDLYUPDOWN                => '0',
      TXPHALIGN                  => '0',
      TXPHALIGNDONE              => open,
      TXPHALIGNEN                => '0',
      TXPHDLYPD                  => '0',
      TXPHDLYRESET               => '0',
      TXPHINIT                   => '0',
      TXPHINITDONE               => open,
      TXPHOVRDEN                 => '0',
      TXSYNCALLIN                => '0',
      TXSYNCDONE                 => open,
      TXSYNCIN                   => '0',
      TXSYNCMODE                 => '0',
      TXSYNCOUT                  => open,
      ---------------------- Transmit Ports - TX Buffer Ports --------------------
      TXBUFSTATUS                => gth_tx_status_o.txbufstatus,
      --------------- Transmit Ports - TX Configurable Driver Ports --------------
      TXBUFDIFFCTRL              => "100",
      TXDEEMPH                   => '0',
      TXDIFFCTRL                 => gth_tx_ctrl_i.txdiffctrl,
      TXDIFFPD                   => '0',
      TXINHIBIT                  => gth_tx_ctrl_i.txinhibit,
      TXMAINCURSOR               => gth_tx_ctrl_i.txmaincursor,
      TXPISOPD                   => '0',
      ------------------ Transmit Ports - TX Data Path interface -----------------
      TXDATA(63 downto 32)       => x"00000000",
      TXDATA(31 downto 0)        => gth_tx_data_i.txdata,
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      GTHTXN                     => open,
      GTHTXP                     => open,
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      TXOUTCLK                   => gth_gt_clk_o.txoutclk,
      TXOUTCLKFABRIC             => open,
      TXOUTCLKPCS                => open,
      TXOUTCLKSEL                => "010",
      TXRATEDONE                 => open,
      --------------------- Transmit Ports - TX Gearbox Ports --------------------
      TXGEARBOXREADY             => open,
      TXSEQUENCE                 => "0000000",
      TXSTARTSEQ                 => '0',
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      TXPCSRESET                 => '0',
      TXPMARESET                 => '0',
      TXRESETDONE                => gth_tx_status_o.txresetdone,
      ------------------ Transmit Ports - TX OOB signalling Ports ----------------
      TXCOMFINISH                => open,
      TXCOMINIT                  => '0',
      TXCOMSAS                   => '0',
      TXCOMWAKE                  => '0',
      TXPDELECIDLEMODE           => '0',
      ----------------- Transmit Ports - TX Polarity Control Ports ---------------
      TXPOLARITY                 => gth_tx_ctrl_i.txpolarity,
      --------------- Transmit Ports - TX Receiver Detection Ports  --------------
      TXDETECTRX                 => '0',
      ------------------ Transmit Ports - TX8b/10b Encoder Ports -----------------
      TX8B10BBYPASS              => "00000000",
      ------------------ Transmit Ports - pattern Generator Ports ----------------
      TXPRBSSEL                  => gth_tx_ctrl_i.txprbssel,
      ----------- Transmit Transmit Ports - 8b10b Encoder Control Ports ----------
      TXCHARISK(7 downto 4)      => "0000",
      TXCHARISK(3 downto 0)      => gth_tx_data_i.txcharisk,
      ----------------------- Tx Configurable Driver  Ports ----------------------
      TXQPISENN                  => open,
      TXQPISENP                  => open

      );

end gth_10gbps_buf_cc_gt_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
