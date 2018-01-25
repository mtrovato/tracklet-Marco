-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gth_pkg                                           
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

package gth_pkg is

  type t_gth_common_drp_in is record
    DRPADDR : std_logic_vector(7 downto 0);
    DRPCLK  : std_logic;
    DRPDI   : std_logic_vector(15 downto 0);
    DRPEN   : std_logic;
    DRPWE   : std_logic;
  end record;

  type t_gth_common_drp_out is record
    DRPDO  : std_logic_vector(15 downto 0);
    DRPRDY : std_logic;
  end record;

  type t_gth_common_clk_in is record
    GTREFCLK0 : std_logic;
  end record;

  type t_gth_common_clk_out is record
    QPLLOUTCLK    : std_logic;
    QPLLOUTREFCLK : std_logic;
  end record;

  type t_gth_common_ctrl is record
    QPLLRESET : std_logic;
  end record;

  type t_gth_common_status is record
    QPLLLOCK       : std_logic;
    QPLLREFCLKLOST : std_logic;
  end record;


  -------------------------- Channel - Clocking Ports ------------------------

  type t_gth_gt_clk_in is record
    GTREFCLK0  : std_logic;
    qpllclk    : std_logic;
    qpllrefclk : std_logic;
    rxusrclk   : std_logic;
    rxusrclk2  : std_logic;
    txusrclk   : std_logic;
    txusrclk2  : std_logic;
  end record;

  type t_gth_gt_clk_out is record
    rxoutclk : std_logic;
    txoutclk : std_logic;
  end record;

  ---------------------------- Channel - DRP Ports  --------------------------

  type t_gth_gt_drp_in is record
    DRPADDR : std_logic_vector(8 downto 0);
    DRPCLK  : std_logic;
    DRPDI   : std_logic_vector(15 downto 0);
    DRPEN   : std_logic;
    DRPWE   : std_logic;
  end record;

  type t_gth_gt_drp_out is record
    DRPDO  : std_logic_vector(15 downto 0);
    DRPRDY : std_logic;
  end record;


  type t_gth_tx_ctrl is record
    txsysclksel  : std_logic_vector(1 downto 0);
    ------------------------ TX Configurable Driver Ports ----------------------
    txpostcursor : std_logic_vector(4 downto 0);
    txprecursor  : std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Configurable Driver Ports --------------
    txdiffctrl   : std_logic_vector(3 downto 0);
    txinhibit    : std_logic;
    txmaincursor : std_logic_vector(6 downto 0);
    --------------------- TX Initialization and Reset Ports --------------------

    txpolarity     : std_logic;
    txprbssel      : std_logic_vector(2 downto 0);
    txprbsforceerr : std_logic;

    txpd : std_logic_vector(1 downto 0);

  end record;

  type t_gth_tx_init is record
    gttxreset : std_logic;
    txuserrdy : std_logic;
  end record;


  type t_gth_tx_status is record
    txresetdone    : std_logic;
    txbufstatus    : std_logic_vector(1 downto 0);
    TXPMARESETDONE : std_logic;
  end record;


  type t_gth_rx_ctrl is record
    rxsysclksel : std_logic_vector(1 downto 0);

    rxpolarity : std_logic;
    rxlpmen    : std_logic;
    rxbufreset : std_logic;

    rxprbssel      : std_logic_vector(2 downto 0);
    rxprbscntreset : std_logic;

    rxpd : std_logic_vector(1 downto 0);

  end record;

  type t_gth_rx_init is record
    gtrxreset       : std_logic;
    rxuserrdy       : std_logic;
    --------------------- Receive Ports - RX Equalizer Ports -------------------
    rxdfeagchold    : std_logic;
    rxdfeagcovrden  : std_logic;
    rxdfelfhold     : std_logic;
    rxdfelpmreset   : std_logic;
    rxlpmlfklovrden : std_logic;
    RXDFELFOVRDEN   : std_logic;
    RXLPMHFHOLD     : std_logic;
    RXLPMHFOVRDEN   : std_logic;
    RXLPMLFHOLD     : std_logic;
  end record;

  type t_gth_rx_status is record

    rxprbserr      : std_logic;
    rxbufstatus    : std_logic_vector(2 downto 0);
    rxclkcorcnt    : std_logic_vector(1 downto 0);
    rxresetdone    : std_logic;
    RXPMARESETDONE : std_logic;
  end record;

  type t_gth_misc_ctrl is record
    loopback       : std_logic_vector(2 downto 0);
    eyescanreset   : std_logic;
    eyescantrigger : std_logic;
  end record;

  type t_gth_misc_status is record
    eyescandataerror : std_logic;

  end record;

  type t_gth_tx_data is record
    txdata    : std_logic_vector(31 downto 0);
    txcharisk : std_logic_vector(3 downto 0);
  end record;

  type t_gth_rx_data is record
    rxdata          : std_logic_vector(31 downto 0);
    rxbyteisaligned : std_logic;
    rxbyterealign   : std_logic;
    rxcommadet      : std_logic;
    rxchariscomma   : std_logic_vector(3 downto 0);
    rxcharisk       : std_logic_vector(3 downto 0);
    rxnotintable    : std_logic_vector(3 downto 0);
    rxdisperr       : std_logic_vector(3 downto 0);
  end record;

  type t_gth_common_clk_in_arr is array(integer range <>) of t_gth_common_clk_in;
  type t_gth_common_clk_out_arr is array(integer range <>) of t_gth_common_clk_out;
  type t_gth_common_ctrl_arr is array(integer range <>) of t_gth_common_ctrl;
  type t_gth_common_status_arr is array(integer range <>) of t_gth_common_status;
  type t_gth_common_drp_in_arr is array(integer range <>) of t_gth_common_drp_in;
  type t_gth_common_drp_out_arr is array(integer range <>) of t_gth_common_drp_out;


  type t_gth_gt_clk_in_arr is array(integer range <>) of t_gth_gt_clk_in;
  type t_gth_gt_clk_out_arr is array(integer range <>) of t_gth_gt_clk_out;
  type t_gth_gt_drp_in_arr is array(integer range <>) of t_gth_gt_drp_in;
  type t_gth_gt_drp_out_arr is array(integer range <>) of t_gth_gt_drp_out;
  type t_gth_tx_ctrl_arr is array(integer range <>) of t_gth_tx_ctrl;
  type t_gth_tx_status_arr is array(integer range <>) of t_gth_tx_status;
  type t_gth_rx_ctrl_arr is array(integer range <>) of t_gth_rx_ctrl;
  type t_gth_rx_status_arr is array(integer range <>) of t_gth_rx_status;
  type t_gth_misc_ctrl_arr is array(integer range <>) of t_gth_misc_ctrl;
  type t_gth_misc_status_arr is array(integer range <>) of t_gth_misc_status;
  type t_gth_tx_data_arr is array(integer range <>) of t_gth_tx_data;
  type t_gth_rx_data_arr is array(integer range <>) of t_gth_rx_data;
  type t_gth_tx_init_arr is array(integer range <>) of t_gth_tx_init;
  type t_gth_rx_init_arr is array(integer range <>) of t_gth_rx_init;

end package;

