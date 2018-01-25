-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_v1_dtc                                         
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
entity ctp7_v1_dtc is
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
end ctp7_v1_dtc;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ctp7_v1_dtc_arch of ctp7_v1_dtc is

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


      ---------------------------------------------------------------------
      -- Louise: component "=" member of the class
      -- Louise: this is a BRAM for the input stubs 
      BRAM_INPUT1_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT1_clk  : out std_logic;                      --clock
      BRAM_INPUT1_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT1_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT1_en   : out std_logic;                      --enable signal
      BRAM_INPUT1_rst  : out std_logic;                      --reset 
      BRAM_INPUT1_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT2_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT2_clk  : out std_logic;                      --clock
      BRAM_INPUT2_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT2_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT2_en   : out std_logic;                      --enable signal
      BRAM_INPUT2_rst  : out std_logic;                      --reset 
      BRAM_INPUT2_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT3_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT3_clk  : out std_logic;                      --clock
      BRAM_INPUT3_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT3_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT3_en   : out std_logic;                      --enable signal
      BRAM_INPUT3_rst  : out std_logic;                      --reset 
      BRAM_INPUT3_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT4_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT4_clk  : out std_logic;                      --clock
      BRAM_INPUT4_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT4_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT4_en   : out std_logic;                      --enable signal
      BRAM_INPUT4_rst  : out std_logic;                      --reset 
      BRAM_INPUT4_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT5_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT5_clk  : out std_logic;                      --clock
      BRAM_INPUT5_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT5_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT5_en   : out std_logic;                      --enable signal
      BRAM_INPUT5_rst  : out std_logic;                      --reset 
      BRAM_INPUT5_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT6_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT6_clk  : out std_logic;                      --clock
      BRAM_INPUT6_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT6_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT6_en   : out std_logic;                      --enable signal
      BRAM_INPUT6_rst  : out std_logic;                      --reset 
      BRAM_INPUT6_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT7_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT7_clk  : out std_logic;                      --clock
      BRAM_INPUT7_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT7_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT7_en   : out std_logic;                      --enable signal
      BRAM_INPUT7_rst  : out std_logic;                      --reset 
      BRAM_INPUT7_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT8_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT8_clk  : out std_logic;                      --clock
      BRAM_INPUT8_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT8_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT8_en   : out std_logic;                      --enable signal
      BRAM_INPUT8_rst  : out std_logic;                      --reset 
      BRAM_INPUT8_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT9_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT9_clk  : out std_logic;                      --clock
      BRAM_INPUT9_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT9_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT9_en   : out std_logic;                      --enable signal
      BRAM_INPUT9_rst  : out std_logic;                      --reset 
      BRAM_INPUT9_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT10_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT10_clk  : out std_logic;                      --clock
      BRAM_INPUT10_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT10_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT10_en   : out std_logic;                      --enable signal
      BRAM_INPUT10_rst  : out std_logic;                      --reset 
      BRAM_INPUT10_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT11_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT11_clk  : out std_logic;                      --clock
      BRAM_INPUT11_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT11_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT11_en   : out std_logic;                      --enable signal
      BRAM_INPUT11_rst  : out std_logic;                      --reset 
      BRAM_INPUT11_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT12_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT12_clk  : out std_logic;                      --clock
      BRAM_INPUT12_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT12_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT12_en   : out std_logic;                      --enable signal
      BRAM_INPUT12_rst  : out std_logic;                      --reset 
      BRAM_INPUT12_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT13_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT13_clk  : out std_logic;                      --clock
      BRAM_INPUT13_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT13_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT13_en   : out std_logic;                      --enable signal
      BRAM_INPUT13_rst  : out std_logic;                      --reset 
      BRAM_INPUT13_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT14_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT14_clk  : out std_logic;                      --clock
      BRAM_INPUT14_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT14_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT14_en   : out std_logic;                      --enable signal
      BRAM_INPUT14_rst  : out std_logic;                      --reset 
      BRAM_INPUT14_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT15_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT15_clk  : out std_logic;                      --clock
      BRAM_INPUT15_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT15_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT15_en   : out std_logic;                      --enable signal
      BRAM_INPUT15_rst  : out std_logic;                      --reset 
      BRAM_INPUT15_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT16_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT16_clk  : out std_logic;                      --clock
      BRAM_INPUT16_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT16_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT16_en   : out std_logic;                      --enable signal
      BRAM_INPUT16_rst  : out std_logic;                      --reset 
      BRAM_INPUT16_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT17_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT17_clk  : out std_logic;                      --clock
      BRAM_INPUT17_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT17_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT17_en   : out std_logic;                      --enable signal
      BRAM_INPUT17_rst  : out std_logic;                      --reset 
      BRAM_INPUT17_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT18_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT18_clk  : out std_logic;                      --clock
      BRAM_INPUT18_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT18_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT18_en   : out std_logic;                      --enable signal
      BRAM_INPUT18_rst  : out std_logic;                      --reset 
      BRAM_INPUT18_we   : out std_logic_vector (3 downto 0);  --write enable

      BRAM_INPUT19_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT19_clk  : out std_logic;                      --clock
      BRAM_INPUT19_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT19_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT19_en   : out std_logic;                      --enable signal
      BRAM_INPUT19_rst  : out std_logic;                      --reset 
      BRAM_INPUT19_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT20_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT20_clk  : out std_logic;                      --clock
      BRAM_INPUT20_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT20_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT20_en   : out std_logic;                      --enable signal
      BRAM_INPUT20_rst  : out std_logic;                      --reset 
      BRAM_INPUT20_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT21_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT21_clk  : out std_logic;                      --clock
      BRAM_INPUT21_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT21_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT21_en   : out std_logic;                      --enable signal
      BRAM_INPUT21_rst  : out std_logic;                      --reset 
      BRAM_INPUT21_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT22_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT22_clk  : out std_logic;                      --clock
      BRAM_INPUT22_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT22_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT22_en   : out std_logic;                      --enable signal
      BRAM_INPUT22_rst  : out std_logic;                      --reset 
      BRAM_INPUT22_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT23_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT23_clk  : out std_logic;                      --clock
      BRAM_INPUT23_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT23_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT23_en   : out std_logic;                      --enable signal
      BRAM_INPUT23_rst  : out std_logic;                      --reset 
      BRAM_INPUT23_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT24_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT24_clk  : out std_logic;                      --clock
      BRAM_INPUT24_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT24_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT24_en   : out std_logic;                      --enable signal
      BRAM_INPUT24_rst  : out std_logic;                      --reset 
      BRAM_INPUT24_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT25_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT25_clk  : out std_logic;                      --clock
      BRAM_INPUT25_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT25_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT25_en   : out std_logic;                      --enable signal
      BRAM_INPUT25_rst  : out std_logic;                      --reset 
      BRAM_INPUT25_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT26_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT26_clk  : out std_logic;                      --clock
      BRAM_INPUT26_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT26_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT26_en   : out std_logic;                      --enable signal
      BRAM_INPUT26_rst  : out std_logic;                      --reset 
      BRAM_INPUT26_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT27_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT27_clk  : out std_logic;                      --clock
      BRAM_INPUT27_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT27_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT27_en   : out std_logic;                      --enable signal
      BRAM_INPUT27_rst  : out std_logic;                      --reset 
      BRAM_INPUT27_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT28_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT28_clk  : out std_logic;                      --clock
      BRAM_INPUT28_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT28_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT28_en   : out std_logic;                      --enable signal
      BRAM_INPUT28_rst  : out std_logic;                      --reset 
      BRAM_INPUT28_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT29_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT29_clk  : out std_logic;                      --clock
      BRAM_INPUT29_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT29_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT29_en   : out std_logic;                      --enable signal
      BRAM_INPUT29_rst  : out std_logic;                      --reset 
      BRAM_INPUT29_we   : out std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT30_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT30_clk  : out std_logic;                      --clock
      BRAM_INPUT30_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT30_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT30_en   : out std_logic;                      --enable signal
      BRAM_INPUT30_rst  : out std_logic;                      --reset 
      BRAM_INPUT30_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT31_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT31_clk  : out std_logic;                      --clock
      BRAM_INPUT31_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT31_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT31_en   : out std_logic;                      --enable signal
      BRAM_INPUT31_rst  : out std_logic;                      --reset 
      BRAM_INPUT31_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT32_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT32_clk  : out std_logic;                      --clock
      BRAM_INPUT32_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT32_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT32_en   : out std_logic;                      --enable signal
      BRAM_INPUT32_rst  : out std_logic;                      --reset 
      BRAM_INPUT32_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT33_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT33_clk  : out std_logic;                      --clock
      BRAM_INPUT33_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT33_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT33_en   : out std_logic;                      --enable signal
      BRAM_INPUT33_rst  : out std_logic;                      --reset 
      BRAM_INPUT33_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT34_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT34_clk  : out std_logic;                      --clock
      BRAM_INPUT34_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT34_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT34_en   : out std_logic;                      --enable signal
      BRAM_INPUT34_rst  : out std_logic;                      --reset 
      BRAM_INPUT34_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT35_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT35_clk  : out std_logic;                      --clock
      BRAM_INPUT35_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT35_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT35_en   : out std_logic;                      --enable signal
      BRAM_INPUT35_rst  : out std_logic;                      --reset 
      BRAM_INPUT35_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT36_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT36_clk  : out std_logic;                      --clock
      BRAM_INPUT36_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT36_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT36_en   : out std_logic;                      --enable signal
      BRAM_INPUT36_rst  : out std_logic;                      --reset 
      BRAM_INPUT36_we   : out std_logic_vector (3 downto 0);  --write enable

      BRAM_INPUT37_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT37_clk  : out std_logic;                      --clock
      BRAM_INPUT37_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT37_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT37_en   : out std_logic;                      --enable signal
      BRAM_INPUT37_rst  : out std_logic;                      --reset 
      BRAM_INPUT37_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT38_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT38_clk  : out std_logic;                      --clock
      BRAM_INPUT38_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT38_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT38_en   : out std_logic;                      --enable signal
      BRAM_INPUT38_rst  : out std_logic;                      --reset 
      BRAM_INPUT38_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT39_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT39_clk  : out std_logic;                      --clock
      BRAM_INPUT39_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT39_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT39_en   : out std_logic;                      --enable signal
      BRAM_INPUT39_rst  : out std_logic;                      --reset 
      BRAM_INPUT39_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT40_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT40_clk  : out std_logic;                      --clock
      BRAM_INPUT40_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT40_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT40_en   : out std_logic;                      --enable signal
      BRAM_INPUT40_rst  : out std_logic;                      --reset 
      BRAM_INPUT40_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT41_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT41_clk  : out std_logic;                      --clock
      BRAM_INPUT41_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT41_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT41_en   : out std_logic;                      --enable signal
      BRAM_INPUT41_rst  : out std_logic;                      --reset 
      BRAM_INPUT41_we   : out std_logic_vector (3 downto 0);  --write enable
        
      BRAM_INPUT42_addr : out std_logic_vector (15 downto 0); --address
      BRAM_INPUT42_clk  : out std_logic;                      --clock
      BRAM_INPUT42_din  : out std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT42_dout : in  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT42_en   : out std_logic;                      --enable signal
      BRAM_INPUT42_rst  : out std_logic;                      --reset 
      BRAM_INPUT42_we   : out std_logic_vector (3 downto 0);  --write enable
            
            -- Jorge: Track output memories
      BRAM_OUTPUT1_clk  : out std_logic;
      BRAM_OUTPUT1_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT1_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT2_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT2_dout : in  std_logic_vector (31 downto 0); 
      BRAM_OUTPUT3_clk  : out std_logic;
      BRAM_OUTPUT3_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT3_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT4_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT4_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT5_clk  : out std_logic;
      BRAM_OUTPUT5_addr : out std_logic_vector (15 downto 0);
      BRAM_OUTPUT5_dout : in  std_logic_vector (31 downto 0); 
      BRAM_OUTPUT6_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT6_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT7_clk  : out std_logic; 
      BRAM_OUTPUT7_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT7_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT8_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT8_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT9_clk  : out std_logic; 
      BRAM_OUTPUT9_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT9_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT10_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT10_dout : in  std_logic_vector (31 downto 0); 
      BRAM_OUTPUT11_clk  : out std_logic; 
      BRAM_OUTPUT11_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT11_dout : in  std_logic_vector (31 downto 0);
      BRAM_OUTPUT12_addr : out std_logic_vector (15 downto 0); 
      BRAM_OUTPUT12_dout : in  std_logic_vector (31 downto 0); 
      
            -- Tao: Latency measurement
      BRAM_TIMER_clk  : out std_logic;
      BRAM_TIMER_addr : out std_logic_vector (15 downto 0);
      BRAM_TIMER_dout : in  std_logic_vector (31 downto 0);         
      ---------------------------------------------------------------------
    

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

  component tx_link_driver 
    port (
      clk240_i       : in  std_logic;
      clk250_i       : in  std_logic;
      rst_i          : in  std_logic;
      bc0_i          : in  std_logic;
      tx_user_word_i : in  std_logic_vector (31 downto 0);
      bcid_i         : in  std_logic_vector (11 downto 0);
      txdata_o       : out std_logic_vector(31 downto 0);
      txcharisk_o    : out std_logic_vector(3 downto 0)
  );
end component;

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
    
 
    ------------------------------------------------------------   
    -- Louise:  this is the main declaration of DTC_input module
    component DTC_input
    port (
      clk : in std_logic;
      io_clk : in std_logic;
      reset : in std_logic;
      BC0 : in std_logic;
      track_en : out std_logic;
      
      BRAM_INPUT1_addr : in std_logic_vector (15 downto 0); --address
      BRAM_INPUT1_din  : in std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT1_dout : out  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT1_en   : in std_logic;                      --enable signal
      BRAM_INPUT1_rst  : in std_logic;                      --reset 
      BRAM_INPUT1_clk  : in std_logic;                      --clock 
      BRAM_INPUT1_we   : in std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT2_addr : in std_logic_vector (15 downto 0); --address
      BRAM_INPUT2_din  : in std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT2_dout : out  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT2_en   : in std_logic;                      --enable signal
      BRAM_INPUT2_rst  : in std_logic;                      --reset 
      BRAM_INPUT2_clk  : in std_logic;                      --clock 
      BRAM_INPUT2_we   : in std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT3_addr : in std_logic_vector (15 downto 0); --address
      BRAM_INPUT3_din  : in std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT3_dout : out  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT3_en   : in std_logic;                      --enable signal
      BRAM_INPUT3_rst  : in std_logic;                      --reset 
      BRAM_INPUT3_clk  : in std_logic;                      --clock 
      BRAM_INPUT3_we   : in std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT4_addr : in std_logic_vector (15 downto 0); --address
      BRAM_INPUT4_din  : in std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT4_dout : out  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT4_en   : in std_logic;                      --enable signal
      BRAM_INPUT4_rst  : in std_logic;                      --reset 
      BRAM_INPUT4_clk  : in std_logic;                      --clock 
      BRAM_INPUT4_we   : in std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT5_addr : in std_logic_vector (15 downto 0); --address
      BRAM_INPUT5_din  : in std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT5_dout : out  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT5_en   : in std_logic;                      --enable signal
      BRAM_INPUT5_rst  : in std_logic;                      --reset 
      BRAM_INPUT5_clk  : in std_logic;                      --clock 
      BRAM_INPUT5_we   : in std_logic_vector (3 downto 0);  --write enable
      
      BRAM_INPUT6_addr : in std_logic_vector (15 downto 0); --address
      BRAM_INPUT6_din  : in std_logic_vector (31 downto 0); --data IN
      BRAM_INPUT6_dout : out  std_logic_vector (31 downto 0); --data OUT
      BRAM_INPUT6_en   : in std_logic;                      --enable signal
      BRAM_INPUT6_rst  : in std_logic;                      --reset 
      BRAM_INPUT6_clk  : in std_logic;                      --clock 
      BRAM_INPUT6_we   : in std_logic_vector (3 downto 0);  --write enable
      
      input_link1_reg1: in  std_logic_vector(31 downto 0);
--      input_link1_reg2: in  std_logic_vector(31 downto 0);
--      input_link2_reg1: in  std_logic_vector(31 downto 0);
--      input_link2_reg2: in  std_logic_vector(31 downto 0);
--      input_link3_reg1: in  std_logic_vector(31 downto 0);
--      input_link3_reg2: in  std_logic_vector(31 downto 0);
      
      input_link1: out  std_logic_vector(35 downto 0);
      input_link2: out  std_logic_vector(35 downto 0);
      input_link3: out  std_logic_vector(35 downto 0)      
       
      
      );
    end component DTC_input;
    ------------------------------------------------------------   
    
    ------------------------------------------------------------   
    -- Jorge:  this is the main declaration of Track_Sink module
    component Track_Sink
    port (
      clk : in std_logic;
      io_clk : in std_logic;
      reset : in std_logic;
      BC0 : in std_logic;
      track_en : in std_logic;
      
      BRAM_OUTPUT1_addr : in std_logic_vector (15 downto 0); 
      BRAM_OUTPUT1_dout : out  std_logic_vector (31 downto 0); 
      BRAM_OUTPUT2_addr : in std_logic_vector (15 downto 0); 
      BRAM_OUTPUT2_dout : out  std_logic_vector (31 downto 0); 
      
      track_output: in  std_logic_vector(63 downto 0);
      
      valid_track: out std_logic;
      track_BX: out std_logic_vector(4 downto 0);
      
      --track_reg1: out  std_logic_vector(31 downto 0);
      --track_reg2: out  std_logic_vector(31 downto 0);
      
      ecounter: out std_logic_vector(31 downto 0)
      
      );
    end component Track_Sink;
    ------------------------------------------------------------ 
    ------------------------------------------------------------
    -- Tao: declaration of timer module for latency measurement
    component Track_Timer
    port (
      clk : in std_logic;
      io_clk : in std_logic;
      reset : in std_logic;
      start : in std_logic;
      valid_track : in std_logic;
      track_BX : in std_logic_vector(4 downto 0);
      
      BRAM_TIMER_addr : in std_logic_vector (15 downto 0); 
      BRAM_TIMER_dout : out  std_logic_vector (31 downto 0)
      );
    end component Track_Timer;
    
    -- declaratuib of bc0_delay
    component bc0_delays
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
    
    ------------------------------------------------------------
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


  ----------------------------------------------------------------
  -- Louise: signal "=" wire, "declaring variables"
  signal BRAM_INPUT1_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT1_clk  : std_logic;
  signal BRAM_INPUT1_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT1_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT1_en   : std_logic;
  signal BRAM_INPUT1_rst  : std_logic;
  signal BRAM_INPUT1_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT2_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT2_clk  : std_logic;
  signal BRAM_INPUT2_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT2_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT2_en   : std_logic;
  signal BRAM_INPUT2_rst  : std_logic;
  signal BRAM_INPUT2_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT3_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT3_clk  : std_logic;
  signal BRAM_INPUT3_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT3_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT3_en   : std_logic;
  signal BRAM_INPUT3_rst  : std_logic;
  signal BRAM_INPUT3_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT4_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT4_clk  : std_logic;
  signal BRAM_INPUT4_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT4_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT4_en   : std_logic;
  signal BRAM_INPUT4_rst  : std_logic;
  signal BRAM_INPUT4_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT5_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT5_clk  : std_logic;
  signal BRAM_INPUT5_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT5_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT5_en   : std_logic;
  signal BRAM_INPUT5_rst  : std_logic;
  signal BRAM_INPUT5_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT6_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT6_clk  : std_logic;
  signal BRAM_INPUT6_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT6_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT6_en   : std_logic;
  signal BRAM_INPUT6_rst  : std_logic;
  signal BRAM_INPUT6_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT7_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT7_clk  : std_logic;
  signal BRAM_INPUT7_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT7_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT7_en   : std_logic;
  signal BRAM_INPUT7_rst  : std_logic;
  signal BRAM_INPUT7_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT8_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT8_clk  : std_logic;
  signal BRAM_INPUT8_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT8_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT8_en   : std_logic;
  signal BRAM_INPUT8_rst  : std_logic;
  signal BRAM_INPUT8_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT9_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT9_clk  : std_logic;
  signal BRAM_INPUT9_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT9_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT9_en   : std_logic;
  signal BRAM_INPUT9_rst  : std_logic;
  signal BRAM_INPUT9_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT10_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT10_clk  : std_logic;
  signal BRAM_INPUT10_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT10_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT10_en   : std_logic;
  signal BRAM_INPUT10_rst  : std_logic;
  signal BRAM_INPUT10_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT11_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT11_clk  : std_logic;
  signal BRAM_INPUT11_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT11_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT11_en   : std_logic;
  signal BRAM_INPUT11_rst  : std_logic;
  signal BRAM_INPUT11_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT12_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT12_clk  : std_logic;
  signal BRAM_INPUT12_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT12_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT12_en   : std_logic;
  signal BRAM_INPUT12_rst  : std_logic;
  signal BRAM_INPUT12_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT13_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT13_clk  : std_logic;
  signal BRAM_INPUT13_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT13_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT13_en   : std_logic;
  signal BRAM_INPUT13_rst  : std_logic;
  signal BRAM_INPUT13_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT14_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT14_clk  : std_logic;
  signal BRAM_INPUT14_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT14_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT14_en   : std_logic;
  signal BRAM_INPUT14_rst  : std_logic;
  signal BRAM_INPUT14_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT15_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT15_clk  : std_logic;
  signal BRAM_INPUT15_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT15_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT15_en   : std_logic;
  signal BRAM_INPUT15_rst  : std_logic;
  signal BRAM_INPUT15_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT16_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT16_clk  : std_logic;
  signal BRAM_INPUT16_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT16_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT16_en   : std_logic;
  signal BRAM_INPUT16_rst  : std_logic;
  signal BRAM_INPUT16_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT17_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT17_clk  : std_logic;
  signal BRAM_INPUT17_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT17_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT17_en   : std_logic;
  signal BRAM_INPUT17_rst  : std_logic;
  signal BRAM_INPUT17_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT18_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT18_clk  : std_logic;
  signal BRAM_INPUT18_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT18_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT18_en   : std_logic;
  signal BRAM_INPUT18_rst  : std_logic;
  signal BRAM_INPUT18_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT19_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT19_clk  : std_logic;
  signal BRAM_INPUT19_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT19_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT19_en   : std_logic;
  signal BRAM_INPUT19_rst  : std_logic;
  signal BRAM_INPUT19_we   : std_logic_vector (3 downto 0);

  signal BRAM_INPUT20_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT20_clk  : std_logic;
  signal BRAM_INPUT20_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT20_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT20_en   : std_logic;
  signal BRAM_INPUT20_rst  : std_logic;
  signal BRAM_INPUT20_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT21_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT21_clk  : std_logic;
  signal BRAM_INPUT21_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT21_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT21_en   : std_logic;
  signal BRAM_INPUT21_rst  : std_logic;
  signal BRAM_INPUT21_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT22_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT22_clk  : std_logic;
  signal BRAM_INPUT22_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT22_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT22_en   : std_logic;
  signal BRAM_INPUT22_rst  : std_logic;
  signal BRAM_INPUT22_we   : std_logic_vector (3 downto 0);    

  signal BRAM_INPUT23_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT23_clk  : std_logic;
  signal BRAM_INPUT23_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT23_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT23_en   : std_logic;
  signal BRAM_INPUT23_rst  : std_logic;
  signal BRAM_INPUT23_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT24_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT24_clk  : std_logic;
  signal BRAM_INPUT24_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT24_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT24_en   : std_logic;
  signal BRAM_INPUT24_rst  : std_logic;
  signal BRAM_INPUT24_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT25_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT25_clk  : std_logic;
  signal BRAM_INPUT25_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT25_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT25_en   : std_logic;
  signal BRAM_INPUT25_rst  : std_logic;
  signal BRAM_INPUT25_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT26_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT26_clk  : std_logic;
  signal BRAM_INPUT26_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT26_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT26_en   : std_logic;
  signal BRAM_INPUT26_rst  : std_logic;
  signal BRAM_INPUT26_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT27_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT27_clk  : std_logic;
  signal BRAM_INPUT27_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT27_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT27_en   : std_logic;
  signal BRAM_INPUT27_rst  : std_logic;
  signal BRAM_INPUT27_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT28_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT28_clk  : std_logic;
  signal BRAM_INPUT28_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT28_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT28_en   : std_logic;
  signal BRAM_INPUT28_rst  : std_logic;
  signal BRAM_INPUT28_we   : std_logic_vector (3 downto 0);  

  signal BRAM_INPUT29_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT29_clk  : std_logic;
  signal BRAM_INPUT29_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT29_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT29_en   : std_logic;
  signal BRAM_INPUT29_rst  : std_logic;
  signal BRAM_INPUT29_we   : std_logic_vector (3 downto 0); 

  signal BRAM_INPUT30_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT30_clk  : std_logic;
  signal BRAM_INPUT30_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT30_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT30_en   : std_logic;
  signal BRAM_INPUT30_rst  : std_logic;
  signal BRAM_INPUT30_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT31_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT31_clk  : std_logic;
  signal BRAM_INPUT31_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT31_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT31_en   : std_logic;
  signal BRAM_INPUT31_rst  : std_logic;
  signal BRAM_INPUT31_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT32_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT32_clk  : std_logic;
  signal BRAM_INPUT32_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT32_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT32_en   : std_logic;
  signal BRAM_INPUT32_rst  : std_logic;
  signal BRAM_INPUT32_we   : std_logic_vector (3 downto 0);    

  signal BRAM_INPUT33_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT33_clk  : std_logic;
  signal BRAM_INPUT33_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT33_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT33_en   : std_logic;
  signal BRAM_INPUT33_rst  : std_logic;
  signal BRAM_INPUT33_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT34_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT34_clk  : std_logic;
  signal BRAM_INPUT34_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT34_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT34_en   : std_logic;
  signal BRAM_INPUT34_rst  : std_logic;
  signal BRAM_INPUT34_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT35_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT35_clk  : std_logic;
  signal BRAM_INPUT35_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT35_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT35_en   : std_logic;
  signal BRAM_INPUT35_rst  : std_logic;
  signal BRAM_INPUT35_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT36_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT36_clk  : std_logic;
  signal BRAM_INPUT36_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT36_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT36_en   : std_logic;
  signal BRAM_INPUT36_rst  : std_logic;
  signal BRAM_INPUT36_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT37_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT37_clk  : std_logic;
  signal BRAM_INPUT37_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT37_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT37_en   : std_logic;
  signal BRAM_INPUT37_rst  : std_logic;
  signal BRAM_INPUT37_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT38_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT38_clk  : std_logic;
  signal BRAM_INPUT38_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT38_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT38_en   : std_logic;
  signal BRAM_INPUT38_rst  : std_logic;
  signal BRAM_INPUT38_we   : std_logic_vector (3 downto 0);  

  signal BRAM_INPUT39_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT39_clk  : std_logic;
  signal BRAM_INPUT39_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT39_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT39_en   : std_logic;
  signal BRAM_INPUT39_rst  : std_logic;
  signal BRAM_INPUT39_we   : std_logic_vector (3 downto 0); 
  
  signal BRAM_INPUT40_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT40_clk  : std_logic;
  signal BRAM_INPUT40_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT40_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT40_en   : std_logic;
  signal BRAM_INPUT40_rst  : std_logic;
  signal BRAM_INPUT40_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT41_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT41_clk  : std_logic;
  signal BRAM_INPUT41_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT41_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT41_en   : std_logic;
  signal BRAM_INPUT41_rst  : std_logic;
  signal BRAM_INPUT41_we   : std_logic_vector (3 downto 0);
  
  signal BRAM_INPUT42_addr : std_logic_vector (15 downto 0);
  signal BRAM_INPUT42_clk  : std_logic;
  signal BRAM_INPUT42_din  : std_logic_vector (31 downto 0);
  signal BRAM_INPUT42_dout : std_logic_vector (31 downto 0);
  signal BRAM_INPUT42_en   : std_logic;
  signal BRAM_INPUT42_rst  : std_logic;
  signal BRAM_INPUT42_we   : std_logic_vector (3 downto 0);    

  signal BRAM_OUTPUT1_clk  : std_logic;
  signal BRAM_OUTPUT1_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT1_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT2_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT2_dout : std_logic_vector (31 downto 0);
  
  signal BRAM_OUTPUT3_clk  : std_logic;
  signal BRAM_OUTPUT3_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT3_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT4_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT4_dout : std_logic_vector (31 downto 0);
  
  signal BRAM_OUTPUT5_clk  : std_logic;
  signal BRAM_OUTPUT5_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT5_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT6_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT6_dout : std_logic_vector (31 downto 0);

  signal BRAM_OUTPUT7_clk  : std_logic;
  signal BRAM_OUTPUT7_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT7_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT8_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT8_dout : std_logic_vector (31 downto 0);
  
  signal BRAM_OUTPUT9_clk  : std_logic;
  signal BRAM_OUTPUT9_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT9_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT10_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT10_dout : std_logic_vector (31 downto 0);

  signal BRAM_OUTPUT11_clk  : std_logic;
  signal BRAM_OUTPUT11_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT11_dout : std_logic_vector (31 downto 0);
  signal BRAM_OUTPUT12_addr : std_logic_vector (15 downto 0);
  signal BRAM_OUTPUT12_dout : std_logic_vector (31 downto 0);

  -- Louise:  these are the 36 bit stubs
  signal input_link1_1_minus: std_logic_vector(35 downto 0);
  signal input_link1_2_minus: std_logic_vector(35 downto 0);
  signal input_link1_3_minus: std_logic_vector(35 downto 0);
  signal input_link2_1_minus: std_logic_vector(35 downto 0);
  signal input_link2_2_minus: std_logic_vector(35 downto 0);
  signal input_link2_3_minus: std_logic_vector(35 downto 0);      
  signal input_link1_1_central: std_logic_vector(35 downto 0);
  signal input_link1_2_central: std_logic_vector(35 downto 0);
  signal input_link1_3_central: std_logic_vector(35 downto 0);
  signal input_link2_1_central: std_logic_vector(35 downto 0);
  signal input_link2_2_central: std_logic_vector(35 downto 0);
  signal input_link2_3_central: std_logic_vector(35 downto 0);
  signal input_link3_1_central: std_logic_vector(35 downto 0);
  signal input_link3_2_central: std_logic_vector(35 downto 0);
  signal input_link3_3_central: std_logic_vector(35 downto 0);
  signal input_link4_1_central: std_logic_vector(35 downto 0);
  signal input_link4_2_central: std_logic_vector(35 downto 0);
  signal input_link4_3_central: std_logic_vector(35 downto 0);      
  signal input_link1_1_plus: std_logic_vector(35 downto 0);
  signal input_link1_2_plus: std_logic_vector(35 downto 0);
  signal input_link1_3_plus: std_logic_vector(35 downto 0); 
  signal input_link2_1_plus: std_logic_vector(35 downto 0);
  signal input_link2_2_plus: std_logic_vector(35 downto 0);
  signal input_link2_3_plus: std_logic_vector(35 downto 0); 
  -- Louise:  these are the input stubs split into 2 32 bit words (36 split to 20 + 16 currently)  
  signal input_link1_reg1 : std_logic_vector(31 downto 0);
  signal input_link1_reg2 : std_logic_vector(31 downto 0);
  signal input_link2_reg1 : std_logic_vector(31 downto 0);
  signal input_link2_reg2 : std_logic_vector(31 downto 0);
  signal input_link3_reg1 : std_logic_vector(31 downto 0);
  signal input_link3_reg2 : std_logic_vector(31 downto 0);
  ----------------------------------------------------------------

  -- Jorge: Track output
  signal track_output_minus : std_logic_vector(63 downto 0);
  signal track_output_central : std_logic_vector(63 downto 0);
  signal track_output_plus : std_logic_vector(63 downto 0);
  
  signal track_reg1 : std_logic_vector(31 downto 0);
  signal track_reg2 : std_logic_vector(31 downto 0);
 
 -- delayed bc0
  signal bc0_stub   : std_logic;
  signal bc0_track    : std_logic;
  signal bcid_stub  : std_logic_vector(11 downto 0);
  signal bcid_track   : std_logic_vector(11 downto 0); 
  
  signal ecounter : std_logic_vector(31 downto 0);
      
  signal track_en : std_logic;
  -- Tao: Latency measurement
  --signal valid_track_minus : std_logic;
  --signal valid_track_plus : std_logic;
  signal valid_track_central : std_logic;
  signal valid_track_central_l1l2 : std_logic;
  signal valid_track_central_l3l4 : std_logic;
  signal valid_track_central_l5l6 : std_logic;
  signal valid_track_central_f1f2 : std_logic;
  signal valid_track_central_f3f4 : std_logic;
  signal valid_track_central_f1l1 : std_logic;
  signal track_BX_central : std_logic_vector (4 downto 0);
  signal track_BX_central_l1l2: std_logic_vector (4 downto 0);
  signal track_BX_central_l3l4: std_logic_vector (4 downto 0);
  signal track_BX_central_l5l6: std_logic_vector (4 downto 0);
  signal track_BX_central_f1f2: std_logic_vector (4 downto 0);
  signal track_BX_central_f3f4: std_logic_vector (4 downto 0);
  signal track_BX_central_f1l1: std_logic_vector (4 downto 0);
  signal s_timer_reset : std_logic;
  signal count_reg : std_logic_vector (31 downto 0);
  signal BRAM_TIMER_clk  : std_logic;
  signal BRAM_TIMER_addr : std_logic_vector (15 downto 0);
  signal BRAM_TIMER_dout : std_logic_vector (31 downto 0);

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
  -------------------------------------------------------------------------------

  signal s_pat_gen_rst        : std_logic;
  signal s_capture_rst        : std_logic;
  signal s_link_8b10b_err_rst : std_logic;

  signal s_capture_arm      : std_logic;
  signal s_capture_done_arr : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_tx_user_word : t_slv_32_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  ------------------------------------------------------------------------------
  signal s_capture_start_bx_id          : std_logic_vector(11 downto 0);
  signal s_link_latency_ctrl            : std_logic_vector(15 downto 0);
  signal s_link_mask_ctrl               : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_link_aligned_diagnostics_arr : t_link_aligned_diagnostics_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_link_align_req   : std_logic;
  signal s_link_latency_err : std_logic;

  signal s_link_align_track        : std_logic;
  signal s_link_align_dummy        : std_logic;
  signal s_link_fifo_read_track    : std_logic;
  signal s_link_fifo_read_dummy    : std_logic;
  signal s_link_aligned_data_arr   : t_link_aligned_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_link_aligned_status_arr : t_link_aligned_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_bc0_delay_ctrl_stub  : std_logic_vector(15 downto 0);
  signal s_bc0_delay_ctrl_track : std_logic_vector(15 downto 0);

  signal s_txdata    : t_slv_32_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_txcharisk : t_slv_4_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  ------------------------------------------------------------------------------

  signal s_rx_capture_ctrl_arr   : t_rx_capture_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_rx_capture_status_arr : t_rx_capture_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  ------------------------------------------------------------------------------

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
  --attribute mark_debug of s_gth_rx_data_arr, s_local_timing_ref : signal is true;

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
        
        -----------------------------------------------------------------------
        -- Louise: essentially specify the parameters of the v7_bd function
        BRAM_INPUT1_en   => BRAM_INPUT1_en,
        BRAM_INPUT1_dout => BRAM_INPUT1_dout,
        BRAM_INPUT1_din  => BRAM_INPUT1_din,
        BRAM_INPUT1_we   => BRAM_INPUT1_we,
        BRAM_INPUT1_addr => BRAM_INPUT1_addr,
        BRAM_INPUT1_clk  => BRAM_INPUT1_clk,
        BRAM_INPUT1_rst  => BRAM_INPUT1_rst,
        
        BRAM_INPUT2_en   => BRAM_INPUT2_en,
        BRAM_INPUT2_dout => BRAM_INPUT2_dout,
        BRAM_INPUT2_din  => BRAM_INPUT2_din,
        BRAM_INPUT2_we   => BRAM_INPUT2_we,
        BRAM_INPUT2_addr => BRAM_INPUT2_addr,
        BRAM_INPUT2_clk  => BRAM_INPUT2_clk,
        BRAM_INPUT2_rst  => BRAM_INPUT2_rst,
        
        BRAM_INPUT3_en   => BRAM_INPUT3_en,
        BRAM_INPUT3_dout => BRAM_INPUT3_dout,
        BRAM_INPUT3_din  => BRAM_INPUT3_din,
        BRAM_INPUT3_we   => BRAM_INPUT3_we,
        BRAM_INPUT3_addr => BRAM_INPUT3_addr,
        BRAM_INPUT3_clk  => BRAM_INPUT3_clk,
        BRAM_INPUT3_rst  => BRAM_INPUT3_rst,
        
        BRAM_INPUT4_en   => BRAM_INPUT4_en,
        BRAM_INPUT4_dout => BRAM_INPUT4_dout,
        BRAM_INPUT4_din  => BRAM_INPUT4_din,
        BRAM_INPUT4_we   => BRAM_INPUT4_we,
        BRAM_INPUT4_addr => BRAM_INPUT4_addr,
        BRAM_INPUT4_clk  => BRAM_INPUT4_clk,
        BRAM_INPUT4_rst  => BRAM_INPUT4_rst,
        
        BRAM_INPUT5_en   => BRAM_INPUT5_en,
        BRAM_INPUT5_dout => BRAM_INPUT5_dout,
        BRAM_INPUT5_din  => BRAM_INPUT5_din,
        BRAM_INPUT5_we   => BRAM_INPUT5_we,
        BRAM_INPUT5_addr => BRAM_INPUT5_addr,
        BRAM_INPUT5_clk  => BRAM_INPUT5_clk,
        BRAM_INPUT5_rst  => BRAM_INPUT5_rst,
        
        BRAM_INPUT6_en   => BRAM_INPUT6_en,
        BRAM_INPUT6_dout => BRAM_INPUT6_dout,
        BRAM_INPUT6_din  => BRAM_INPUT6_din,
        BRAM_INPUT6_we   => BRAM_INPUT6_we,
        BRAM_INPUT6_addr => BRAM_INPUT6_addr,
        BRAM_INPUT6_clk  => BRAM_INPUT6_clk,
        BRAM_INPUT6_rst  => BRAM_INPUT6_rst,
        
        BRAM_INPUT7_en   => BRAM_INPUT7_en,
        BRAM_INPUT7_dout => BRAM_INPUT7_dout,
        BRAM_INPUT7_din  => BRAM_INPUT7_din,
        BRAM_INPUT7_we   => BRAM_INPUT7_we,
        BRAM_INPUT7_addr => BRAM_INPUT7_addr,
        BRAM_INPUT7_clk  => BRAM_INPUT7_clk,
        BRAM_INPUT7_rst  => BRAM_INPUT7_rst,
        
        BRAM_INPUT8_en   => BRAM_INPUT8_en,
        BRAM_INPUT8_dout => BRAM_INPUT8_dout,
        BRAM_INPUT8_din  => BRAM_INPUT8_din,
        BRAM_INPUT8_we   => BRAM_INPUT8_we,
        BRAM_INPUT8_addr => BRAM_INPUT8_addr,
        BRAM_INPUT8_clk  => BRAM_INPUT8_clk,
        BRAM_INPUT8_rst  => BRAM_INPUT8_rst,
        
        BRAM_INPUT9_en   => BRAM_INPUT9_en,
        BRAM_INPUT9_dout => BRAM_INPUT9_dout,
        BRAM_INPUT9_din  => BRAM_INPUT9_din,
        BRAM_INPUT9_we   => BRAM_INPUT9_we,
        BRAM_INPUT9_addr => BRAM_INPUT9_addr,
        BRAM_INPUT9_clk  => BRAM_INPUT9_clk,
        BRAM_INPUT9_rst  => BRAM_INPUT9_rst,
        
        BRAM_INPUT10_en   => BRAM_INPUT10_en,
        BRAM_INPUT10_dout => BRAM_INPUT10_dout,
        BRAM_INPUT10_din  => BRAM_INPUT10_din,
        BRAM_INPUT10_we   => BRAM_INPUT10_we,
        BRAM_INPUT10_addr => BRAM_INPUT10_addr,
        BRAM_INPUT10_clk  => BRAM_INPUT10_clk,
        BRAM_INPUT10_rst  => BRAM_INPUT10_rst,
        
        BRAM_INPUT11_en   => BRAM_INPUT11_en,
        BRAM_INPUT11_dout => BRAM_INPUT11_dout,
        BRAM_INPUT11_din  => BRAM_INPUT11_din,
        BRAM_INPUT11_we   => BRAM_INPUT11_we,
        BRAM_INPUT11_addr => BRAM_INPUT11_addr,
        BRAM_INPUT11_clk  => BRAM_INPUT11_clk,
        BRAM_INPUT11_rst  => BRAM_INPUT11_rst,
        
        BRAM_INPUT12_en   => BRAM_INPUT12_en,
        BRAM_INPUT12_dout => BRAM_INPUT12_dout,
        BRAM_INPUT12_din  => BRAM_INPUT12_din,
        BRAM_INPUT12_we   => BRAM_INPUT12_we,
        BRAM_INPUT12_addr => BRAM_INPUT12_addr,
        BRAM_INPUT12_clk  => BRAM_INPUT12_clk,
        BRAM_INPUT12_rst  => BRAM_INPUT12_rst,
        
        BRAM_INPUT13_en   => BRAM_INPUT13_en,
        BRAM_INPUT13_dout => BRAM_INPUT13_dout,
        BRAM_INPUT13_din  => BRAM_INPUT13_din,
        BRAM_INPUT13_we   => BRAM_INPUT13_we,
        BRAM_INPUT13_addr => BRAM_INPUT13_addr,
        BRAM_INPUT13_clk  => BRAM_INPUT13_clk,
        BRAM_INPUT13_rst  => BRAM_INPUT13_rst,
        
        BRAM_INPUT14_en   => BRAM_INPUT14_en,
        BRAM_INPUT14_dout => BRAM_INPUT14_dout,
        BRAM_INPUT14_din  => BRAM_INPUT14_din,
        BRAM_INPUT14_we   => BRAM_INPUT14_we,
        BRAM_INPUT14_addr => BRAM_INPUT14_addr,
        BRAM_INPUT14_clk  => BRAM_INPUT14_clk,
        BRAM_INPUT14_rst  => BRAM_INPUT14_rst,
        
        BRAM_INPUT15_en   => BRAM_INPUT15_en,
        BRAM_INPUT15_dout => BRAM_INPUT15_dout,
        BRAM_INPUT15_din  => BRAM_INPUT15_din,
        BRAM_INPUT15_we   => BRAM_INPUT15_we,
        BRAM_INPUT15_addr => BRAM_INPUT15_addr,
        BRAM_INPUT15_clk  => BRAM_INPUT15_clk,
        BRAM_INPUT15_rst  => BRAM_INPUT15_rst,
        
        BRAM_INPUT16_en   => BRAM_INPUT16_en,
        BRAM_INPUT16_dout => BRAM_INPUT16_dout,
        BRAM_INPUT16_din  => BRAM_INPUT16_din,
        BRAM_INPUT16_we   => BRAM_INPUT16_we,
        BRAM_INPUT16_addr => BRAM_INPUT16_addr,
        BRAM_INPUT16_clk  => BRAM_INPUT16_clk,
        BRAM_INPUT16_rst  => BRAM_INPUT16_rst,
        
        BRAM_INPUT17_en   => BRAM_INPUT17_en,
        BRAM_INPUT17_dout => BRAM_INPUT17_dout,
        BRAM_INPUT17_din  => BRAM_INPUT17_din,
        BRAM_INPUT17_we   => BRAM_INPUT17_we,
        BRAM_INPUT17_addr => BRAM_INPUT17_addr,
        BRAM_INPUT17_clk  => BRAM_INPUT17_clk,
        BRAM_INPUT17_rst  => BRAM_INPUT17_rst,
        
        BRAM_INPUT18_en   => BRAM_INPUT18_en,
        BRAM_INPUT18_dout => BRAM_INPUT18_dout,
        BRAM_INPUT18_din  => BRAM_INPUT18_din,
        BRAM_INPUT18_we   => BRAM_INPUT18_we,
        BRAM_INPUT18_addr => BRAM_INPUT18_addr,
        BRAM_INPUT18_clk  => BRAM_INPUT18_clk,
        BRAM_INPUT18_rst  => BRAM_INPUT18_rst,

        BRAM_INPUT19_en   => BRAM_INPUT19_en,
        BRAM_INPUT19_dout => BRAM_INPUT19_dout,
        BRAM_INPUT19_din  => BRAM_INPUT19_din,
        BRAM_INPUT19_we   => BRAM_INPUT19_we,
        BRAM_INPUT19_addr => BRAM_INPUT19_addr,
        BRAM_INPUT19_clk  => BRAM_INPUT19_clk,
        BRAM_INPUT19_rst  => BRAM_INPUT19_rst,

        BRAM_INPUT20_en   => BRAM_INPUT20_en,
        BRAM_INPUT20_dout => BRAM_INPUT20_dout,
        BRAM_INPUT20_din  => BRAM_INPUT20_din,
        BRAM_INPUT20_we   => BRAM_INPUT20_we,
        BRAM_INPUT20_addr => BRAM_INPUT20_addr,
        BRAM_INPUT20_clk  => BRAM_INPUT20_clk,
        BRAM_INPUT20_rst  => BRAM_INPUT20_rst,
        
        BRAM_INPUT21_en   => BRAM_INPUT21_en,
        BRAM_INPUT21_dout => BRAM_INPUT21_dout,
        BRAM_INPUT21_din  => BRAM_INPUT21_din,
        BRAM_INPUT21_we   => BRAM_INPUT21_we,
        BRAM_INPUT21_addr => BRAM_INPUT21_addr,
        BRAM_INPUT21_clk  => BRAM_INPUT21_clk,
        BRAM_INPUT21_rst  => BRAM_INPUT21_rst,
        
        BRAM_INPUT22_en   => BRAM_INPUT22_en,
        BRAM_INPUT22_dout => BRAM_INPUT22_dout,
        BRAM_INPUT22_din  => BRAM_INPUT22_din,
        BRAM_INPUT22_we   => BRAM_INPUT22_we,
        BRAM_INPUT22_addr => BRAM_INPUT22_addr,
        BRAM_INPUT22_clk  => BRAM_INPUT22_clk,
        BRAM_INPUT22_rst  => BRAM_INPUT22_rst,
        
        BRAM_INPUT23_en   => BRAM_INPUT23_en,
        BRAM_INPUT23_dout => BRAM_INPUT23_dout,
        BRAM_INPUT23_din  => BRAM_INPUT23_din,
        BRAM_INPUT23_we   => BRAM_INPUT23_we,
        BRAM_INPUT23_addr => BRAM_INPUT23_addr,
        BRAM_INPUT23_clk  => BRAM_INPUT23_clk,
        BRAM_INPUT23_rst  => BRAM_INPUT23_rst,
        
        BRAM_INPUT24_en   => BRAM_INPUT24_en,
        BRAM_INPUT24_dout => BRAM_INPUT24_dout,
        BRAM_INPUT24_din  => BRAM_INPUT24_din,
        BRAM_INPUT24_we   => BRAM_INPUT24_we,
        BRAM_INPUT24_addr => BRAM_INPUT24_addr,
        BRAM_INPUT24_clk  => BRAM_INPUT24_clk,
        BRAM_INPUT24_rst  => BRAM_INPUT24_rst,
        
        BRAM_INPUT25_en   => BRAM_INPUT25_en,
        BRAM_INPUT25_dout => BRAM_INPUT25_dout,
        BRAM_INPUT25_din  => BRAM_INPUT25_din,
        BRAM_INPUT25_we   => BRAM_INPUT25_we,
        BRAM_INPUT25_addr => BRAM_INPUT25_addr,
        BRAM_INPUT25_clk  => BRAM_INPUT25_clk,
        BRAM_INPUT25_rst  => BRAM_INPUT25_rst,
        
        BRAM_INPUT26_en   => BRAM_INPUT26_en,
        BRAM_INPUT26_dout => BRAM_INPUT26_dout,
        BRAM_INPUT26_din  => BRAM_INPUT26_din,
        BRAM_INPUT26_we   => BRAM_INPUT26_we,
        BRAM_INPUT26_addr => BRAM_INPUT26_addr,
        BRAM_INPUT26_clk  => BRAM_INPUT26_clk,
        BRAM_INPUT26_rst  => BRAM_INPUT26_rst,
        
        BRAM_INPUT27_en   => BRAM_INPUT27_en,
        BRAM_INPUT27_dout => BRAM_INPUT27_dout,
        BRAM_INPUT27_din  => BRAM_INPUT27_din,
        BRAM_INPUT27_we   => BRAM_INPUT27_we,
        BRAM_INPUT27_addr => BRAM_INPUT27_addr,
        BRAM_INPUT27_clk  => BRAM_INPUT27_clk,
        BRAM_INPUT27_rst  => BRAM_INPUT27_rst,
        
        BRAM_INPUT28_en   => BRAM_INPUT28_en,
        BRAM_INPUT28_dout => BRAM_INPUT28_dout,
        BRAM_INPUT28_din  => BRAM_INPUT28_din,
        BRAM_INPUT28_we   => BRAM_INPUT28_we,
        BRAM_INPUT28_addr => BRAM_INPUT28_addr,
        BRAM_INPUT28_clk  => BRAM_INPUT28_clk,
        BRAM_INPUT28_rst  => BRAM_INPUT28_rst,

        BRAM_INPUT29_en   => BRAM_INPUT29_en,
        BRAM_INPUT29_dout => BRAM_INPUT29_dout,
        BRAM_INPUT29_din  => BRAM_INPUT29_din,
        BRAM_INPUT29_we   => BRAM_INPUT29_we,
        BRAM_INPUT29_addr => BRAM_INPUT29_addr,
        BRAM_INPUT29_clk  => BRAM_INPUT29_clk,
        BRAM_INPUT29_rst  => BRAM_INPUT29_rst,

        BRAM_INPUT30_en   => BRAM_INPUT30_en,
        BRAM_INPUT30_dout => BRAM_INPUT30_dout,
        BRAM_INPUT30_din  => BRAM_INPUT30_din,
        BRAM_INPUT30_we   => BRAM_INPUT30_we,
        BRAM_INPUT30_addr => BRAM_INPUT30_addr,
        BRAM_INPUT30_clk  => BRAM_INPUT30_clk,
        BRAM_INPUT30_rst  => BRAM_INPUT30_rst,
        
        BRAM_INPUT31_en   => BRAM_INPUT31_en,
        BRAM_INPUT31_dout => BRAM_INPUT31_dout,
        BRAM_INPUT31_din  => BRAM_INPUT31_din,
        BRAM_INPUT31_we   => BRAM_INPUT31_we,
        BRAM_INPUT31_addr => BRAM_INPUT31_addr,
        BRAM_INPUT31_clk  => BRAM_INPUT31_clk,
        BRAM_INPUT31_rst  => BRAM_INPUT31_rst,
        
        BRAM_INPUT32_en   => BRAM_INPUT32_en,
        BRAM_INPUT32_dout => BRAM_INPUT32_dout,
        BRAM_INPUT32_din  => BRAM_INPUT32_din,
        BRAM_INPUT32_we   => BRAM_INPUT32_we,
        BRAM_INPUT32_addr => BRAM_INPUT32_addr,
        BRAM_INPUT32_clk  => BRAM_INPUT32_clk,
        BRAM_INPUT32_rst  => BRAM_INPUT32_rst,
        
        BRAM_INPUT33_en   => BRAM_INPUT33_en,
        BRAM_INPUT33_dout => BRAM_INPUT33_dout,
        BRAM_INPUT33_din  => BRAM_INPUT33_din,
        BRAM_INPUT33_we   => BRAM_INPUT33_we,
        BRAM_INPUT33_addr => BRAM_INPUT33_addr,
        BRAM_INPUT33_clk  => BRAM_INPUT33_clk,
        BRAM_INPUT33_rst  => BRAM_INPUT33_rst,
        
        BRAM_INPUT34_en   => BRAM_INPUT34_en,
        BRAM_INPUT34_dout => BRAM_INPUT34_dout,
        BRAM_INPUT34_din  => BRAM_INPUT34_din,
        BRAM_INPUT34_we   => BRAM_INPUT34_we,
        BRAM_INPUT34_addr => BRAM_INPUT34_addr,
        BRAM_INPUT34_clk  => BRAM_INPUT34_clk,
        BRAM_INPUT34_rst  => BRAM_INPUT34_rst,
        
        BRAM_INPUT35_en   => BRAM_INPUT35_en,
        BRAM_INPUT35_dout => BRAM_INPUT35_dout,
        BRAM_INPUT35_din  => BRAM_INPUT35_din,
        BRAM_INPUT35_we   => BRAM_INPUT35_we,
        BRAM_INPUT35_addr => BRAM_INPUT35_addr,
        BRAM_INPUT35_clk  => BRAM_INPUT35_clk,
        BRAM_INPUT35_rst  => BRAM_INPUT35_rst,
        
        BRAM_INPUT36_en   => BRAM_INPUT36_en,
        BRAM_INPUT36_dout => BRAM_INPUT36_dout,
        BRAM_INPUT36_din  => BRAM_INPUT36_din,
        BRAM_INPUT36_we   => BRAM_INPUT36_we,
        BRAM_INPUT36_addr => BRAM_INPUT36_addr,
        BRAM_INPUT36_clk  => BRAM_INPUT36_clk,
        BRAM_INPUT36_rst  => BRAM_INPUT36_rst,
        
        BRAM_INPUT37_en   => BRAM_INPUT37_en,
        BRAM_INPUT37_dout => BRAM_INPUT37_dout,
        BRAM_INPUT37_din  => BRAM_INPUT37_din,
        BRAM_INPUT37_we   => BRAM_INPUT37_we,
        BRAM_INPUT37_addr => BRAM_INPUT37_addr,
        BRAM_INPUT37_clk  => BRAM_INPUT37_clk,
        BRAM_INPUT37_rst  => BRAM_INPUT37_rst,
        
        BRAM_INPUT38_en   => BRAM_INPUT38_en,
        BRAM_INPUT38_dout => BRAM_INPUT38_dout,
        BRAM_INPUT38_din  => BRAM_INPUT38_din,
        BRAM_INPUT38_we   => BRAM_INPUT38_we,
        BRAM_INPUT38_addr => BRAM_INPUT38_addr,
        BRAM_INPUT38_clk  => BRAM_INPUT38_clk,
        BRAM_INPUT38_rst  => BRAM_INPUT38_rst,

        BRAM_INPUT39_en   => BRAM_INPUT39_en,
        BRAM_INPUT39_dout => BRAM_INPUT39_dout,
        BRAM_INPUT39_din  => BRAM_INPUT39_din,
        BRAM_INPUT39_we   => BRAM_INPUT39_we,
        BRAM_INPUT39_addr => BRAM_INPUT39_addr,
        BRAM_INPUT39_clk  => BRAM_INPUT39_clk,
        BRAM_INPUT39_rst  => BRAM_INPUT39_rst,

        BRAM_INPUT40_en   => BRAM_INPUT40_en,
        BRAM_INPUT40_dout => BRAM_INPUT40_dout,
        BRAM_INPUT40_din  => BRAM_INPUT40_din,
        BRAM_INPUT40_we   => BRAM_INPUT40_we,
        BRAM_INPUT40_addr => BRAM_INPUT40_addr,
        BRAM_INPUT40_clk  => BRAM_INPUT40_clk,
        BRAM_INPUT40_rst  => BRAM_INPUT40_rst,
      
        BRAM_INPUT41_en   => BRAM_INPUT41_en,
        BRAM_INPUT41_dout => BRAM_INPUT41_dout,
        BRAM_INPUT41_din  => BRAM_INPUT41_din,
        BRAM_INPUT41_we   => BRAM_INPUT41_we,
        BRAM_INPUT41_addr => BRAM_INPUT41_addr,
        BRAM_INPUT41_clk  => BRAM_INPUT41_clk,
        BRAM_INPUT41_rst  => BRAM_INPUT41_rst,
       
        BRAM_INPUT42_en   => BRAM_INPUT42_en,
        BRAM_INPUT42_dout => BRAM_INPUT42_dout,
        BRAM_INPUT42_din  => BRAM_INPUT42_din,
        BRAM_INPUT42_we   => BRAM_INPUT42_we,
        BRAM_INPUT42_addr => BRAM_INPUT42_addr,
        BRAM_INPUT42_clk  => BRAM_INPUT42_clk,
        BRAM_INPUT42_rst  => BRAM_INPUT42_rst,
        
        BRAM_OUTPUT1_clk  => BRAM_OUTPUT1_clk,
        BRAM_OUTPUT1_dout => BRAM_OUTPUT1_dout,
        BRAM_OUTPUT1_addr => BRAM_OUTPUT1_addr,
        BRAM_OUTPUT2_dout => BRAM_OUTPUT2_dout,
        BRAM_OUTPUT2_addr => BRAM_OUTPUT2_addr,
        
        BRAM_OUTPUT3_clk  => BRAM_OUTPUT3_clk,
        BRAM_OUTPUT3_dout => BRAM_OUTPUT3_dout,
        BRAM_OUTPUT3_addr => BRAM_OUTPUT3_addr,
        BRAM_OUTPUT4_dout => BRAM_OUTPUT4_dout,
        BRAM_OUTPUT4_addr => BRAM_OUTPUT4_addr,
        
        BRAM_OUTPUT5_clk  => BRAM_OUTPUT5_clk,
        BRAM_OUTPUT5_dout => BRAM_OUTPUT5_dout,
        BRAM_OUTPUT5_addr => BRAM_OUTPUT5_addr,
        BRAM_OUTPUT6_dout => BRAM_OUTPUT6_dout,
        BRAM_OUTPUT6_addr => BRAM_OUTPUT6_addr,
        
        BRAM_OUTPUT7_clk  => BRAM_OUTPUT7_clk,
        BRAM_OUTPUT7_dout => BRAM_OUTPUT7_dout,
        BRAM_OUTPUT7_addr => BRAM_OUTPUT7_addr,
        BRAM_OUTPUT8_dout => BRAM_OUTPUT8_dout,
        BRAM_OUTPUT8_addr => BRAM_OUTPUT8_addr,
        
        BRAM_OUTPUT9_clk  => BRAM_OUTPUT9_clk,
        BRAM_OUTPUT9_dout => BRAM_OUTPUT9_dout,
        BRAM_OUTPUT9_addr => BRAM_OUTPUT9_addr,
        BRAM_OUTPUT10_dout => BRAM_OUTPUT10_dout,
        BRAM_OUTPUT10_addr => BRAM_OUTPUT10_addr,

        BRAM_OUTPUT11_clk  => BRAM_OUTPUT11_clk,
        BRAM_OUTPUT11_dout => BRAM_OUTPUT11_dout,
        BRAM_OUTPUT11_addr => BRAM_OUTPUT11_addr,
        BRAM_OUTPUT12_dout => BRAM_OUTPUT12_dout,
        BRAM_OUTPUT12_addr => BRAM_OUTPUT12_addr,

        BRAM_TIMER_clk  => BRAM_TIMER_clk,
        BRAM_TIMER_dout => BRAM_TIMER_dout,
        BRAM_TIMER_addr => BRAM_TIMER_addr,
      
        -----------------------------------------------------------------------
        
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
      rx_capture_status_arr_i => s_rx_capture_status_arr,

      -----------------------------------------------------
      -- Louise: Connect output to something (?)
      input_link1_reg1 => input_link1_reg1,
      input_link1_reg2 => input_link1_reg2,
      input_link2_reg1 => input_link2_reg1,
      input_link2_reg2 => input_link2_reg2,
      input_link3_reg1 => input_link3_reg1,
      input_link3_reg2 => input_link3_reg2,     
      -----------------------------------------------------
     
     -----------------------------------------------------
      -- Jorge: Connect track to registers
      track_reg1 => track_reg1,
      track_reg2 => track_reg2,
      
      ecounter => ecounter,
      -----------------------------------------------------
      -- bc0 delay registers
      bc0_delay_ctrl_stub_o  => s_bc0_delay_ctrl_stub,
      bc0_delay_ctrl_track_o => s_bc0_delay_ctrl_track,
      
      --Tao : Latency Measurement
      count_reg => count_reg,
      timer_reset_o => s_timer_reset
     
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


  -------------------------------------------------------------------------
  -- Louise:  this is the link stuff !!!
  -------------------------------------------------------------------------
  
  -- TX channels for sending stubs
  -------------------------------------------------------------------------------------
  -- SENDING TO EAGLE30/35
  -------------------------------------------------------------------------------------
  -- CXP0
  -- Ch0
  i_tx_link_driver_ch0 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_1_minus(17 downto 0) & b"11" & x"AAA",  --half of stub sent over ch0 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(0).txdata,
      txcharisk_o    => s_gth_tx_data_arr(0).txcharisk
      );  
  -- Ch1
  i_tx_link_driver_ch1 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_1_minus(35 downto 18) & b"11" & x"AAB", --other half of stub sent over ch1 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(1).txdata,
      txcharisk_o    => s_gth_tx_data_arr(1).txcharisk
      );   
  -- Ch2
  i_tx_link_driver_ch2 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_2_minus(17 downto 0) & b"11" & x"AAA",  --half of stub (LINK2) sent over ch2 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(2).txdata,
      txcharisk_o    => s_gth_tx_data_arr(2).txcharisk
      ); 
  -- Ch3
  i_tx_link_driver_ch3 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_2_minus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK2) sent over ch3 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(3).txdata,
      txcharisk_o    => s_gth_tx_data_arr(3).txcharisk
      );  
  -- Ch4
  i_tx_link_driver_ch4 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_3_minus(17 downto 0) & b"11" & x"AAA",  --half of stub (LINK3) sent over ch4 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(4).txdata,
      txcharisk_o    => s_gth_tx_data_arr(4).txcharisk
      );    
  -- Ch5
  i_tx_link_driver_ch5 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_3_minus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK3) sent over ch5 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(5).txdata,
      txcharisk_o    => s_gth_tx_data_arr(5).txcharisk
      );  
  -- Ch6
  i_tx_link_driver_ch6 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_1_minus(17 downto 0) & b"11" & x"AAA",  --half of stub sent over ch0 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(6).txdata,
      txcharisk_o    => s_gth_tx_data_arr(6).txcharisk
      );  
  -- Ch7
  i_tx_link_driver_ch7 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_1_minus(35 downto 18) & b"11" & x"AAB", --other half of stub sent over ch1 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(7).txdata,
      txcharisk_o    => s_gth_tx_data_arr(7).txcharisk
      );   
  -- Ch8
  i_tx_link_driver_ch8 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_2_minus(17 downto 0) & b"11" & x"AAA",  --half of stub (LINK2) sent over ch2 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(8).txdata,
      txcharisk_o    => s_gth_tx_data_arr(8).txcharisk
      ); 
  -- Ch9
  i_tx_link_driver_ch9 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_2_minus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK2) sent over ch3 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(9).txdata,
      txcharisk_o    => s_gth_tx_data_arr(9).txcharisk
      );  
  -- Ch10
  i_tx_link_driver_ch10 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_3_minus(17 downto 0) & b"11" & x"AAA",  --half of stub (LINK3) sent over ch4 to eagle30
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(10).txdata,
      txcharisk_o    => s_gth_tx_data_arr(10).txcharisk
      );    
  -- Ch11
  i_tx_link_driver_ch11 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_3_minus(35 downto 18) & b"11" & x"AAB", 
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(11).txdata,
      txcharisk_o    => s_gth_tx_data_arr(11).txcharisk
      );   
  
  -------------------------------------------------------------------------------------
  -- SENDING TO EAGLE31/36
  -------------------------------------------------------------------------------------
  -- CXP2
  -- Ch24
  i_tx_link_driver_ch24 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_1_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(24).txdata,
      txcharisk_o    => s_gth_tx_data_arr(24).txcharisk
      );
  -- Ch25
  i_tx_link_driver_ch25 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_1_central(35 downto 18) & b"11" & x"AAB",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(25).txdata,
      txcharisk_o    => s_gth_tx_data_arr(25).txcharisk
      );
  -- Ch26
  i_tx_link_driver_ch26 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_2_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(26).txdata,
      txcharisk_o    => s_gth_tx_data_arr(26).txcharisk
      );
  -- Ch27
  i_tx_link_driver_ch27 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_2_central(35 downto 18) & b"11" & x"AAB",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(27).txdata,
      txcharisk_o    => s_gth_tx_data_arr(27).txcharisk
      );
  -- Ch28
  i_tx_link_driver_ch28 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_3_central(17 downto 0) & b"11" & x"AAA", 
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(28).txdata,
      txcharisk_o    => s_gth_tx_data_arr(28).txcharisk
      );
  -- Ch29
  i_tx_link_driver_ch29 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_3_central(35 downto 18) & b"11" & x"AAB", 
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(29).txdata,
      txcharisk_o    => s_gth_tx_data_arr(29).txcharisk
      );
  -- Ch30
  i_tx_link_driver_ch30 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_1_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(30).txdata,
      txcharisk_o    => s_gth_tx_data_arr(30).txcharisk
      );
  -- Ch31
  i_tx_link_driver_ch31 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_1_central(35 downto 18) & b"11" & x"AAB",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(31).txdata,
      txcharisk_o    => s_gth_tx_data_arr(31).txcharisk
      );
  -- Ch32
  i_tx_link_driver_ch32 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_2_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(32).txdata,
      txcharisk_o    => s_gth_tx_data_arr(32).txcharisk
      );
  -- Ch33
  i_tx_link_driver_ch33 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_2_central(35 downto 18) & b"11" & x"AAB",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(33).txdata,
      txcharisk_o    => s_gth_tx_data_arr(33).txcharisk
      );
  -- Ch34
  i_tx_link_driver_ch34 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_3_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(34).txdata,
      txcharisk_o    => s_gth_tx_data_arr(34).txcharisk
      );
  -- Ch35
  i_tx_link_driver_ch35 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_3_central(35 downto 18) & b"11" & x"AAB", 
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(35).txdata,
      txcharisk_o    => s_gth_tx_data_arr(35).txcharisk
      );
  -- CXP1
  -- Ch12
  i_tx_link_driver_ch12 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link3_1_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(12).txdata,
      txcharisk_o    => s_gth_tx_data_arr(12).txcharisk
      );
  -- Ch13
  i_tx_link_driver_ch13 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link3_1_central(35 downto 18) & b"11" & x"AAB",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(13).txdata,
      txcharisk_o    => s_gth_tx_data_arr(13).txcharisk
      );
  -- Ch14
  i_tx_link_driver_ch14 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link3_2_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(14).txdata,
      txcharisk_o    => s_gth_tx_data_arr(14).txcharisk
      );
  -- Ch15
  i_tx_link_driver_ch15 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link3_2_central(35 downto 18) & b"11" & x"AAB",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(15).txdata,
      txcharisk_o    => s_gth_tx_data_arr(15).txcharisk
      );
  -- Ch16
  i_tx_link_driver_ch16 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link3_3_central(17 downto 0) & b"11" & x"AAA",
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(16).txdata,
      txcharisk_o    => s_gth_tx_data_arr(16).txcharisk
      );
  -- Ch17
  i_tx_link_driver_ch17 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link3_3_central(35 downto 18) & b"11" & x"AAB", 
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(17).txdata,
      txcharisk_o    => s_gth_tx_data_arr(17).txcharisk
      );           
      
  -- rest of CXP1 channels are currently not used for sending stubs
  -- dummy tx_link_driver generated below
  gen_tx_dummy_cxp1 : for i in 18 to 23 generate    
    i_tx_link_driver : entity work.tx_link_driver
      port map (
        clk240_i       => s_clk_240,
        clk250_i       => s_clk_usrclk_250,
        rst_i          => s_pat_gen_rst,
        tx_user_word_i => s_tx_user_word(i)(31 downto 0),
        bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
        bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
        txdata_o       => s_gth_tx_data_arr(i).txdata,
        txcharisk_o    => s_gth_tx_data_arr(i).txcharisk
        );       
  end generate; 
   

  -------------------------------------------------------------------------------------
  -- SENDING TO EAGLE32/37
  -------------------------------------------------------------------------------------
  -- MPTX
  -- Ch52
  i_tx_link_driver_ch52 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_1_plus(17 downto 0) & b"11" & x"AAA", --half of stub (LINK1) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(52).txdata,
      txcharisk_o    => s_gth_tx_data_arr(52).txcharisk
      );
  -- Ch59
  i_tx_link_driver_ch59 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_1_plus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK1) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(59).txdata,
      txcharisk_o    => s_gth_tx_data_arr(59).txcharisk
      );
  -- Ch56 of MPTX
  i_tx_link_driver_ch56 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_2_plus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(56).txdata,
      txcharisk_o    => s_gth_tx_data_arr(56).txcharisk
      );      
  -- Ch62 of MPTX
  i_tx_link_driver_ch62 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_2_plus(17 downto 0) & b"11" & x"AAA", --half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(62).txdata,
      txcharisk_o    => s_gth_tx_data_arr(62).txcharisk
      );
  -- Ch53 of MPTX
  i_tx_link_driver_ch53 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_3_plus(17 downto 0) & b"11" & x"AAA", --half of stub (LINK3) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(53).txdata,
      txcharisk_o    => s_gth_tx_data_arr(53).txcharisk
      );          
  -- Ch63 of MPTX
  i_tx_link_driver_ch63 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link1_3_plus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK3) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(63).txdata,
      txcharisk_o    => s_gth_tx_data_arr(63).txcharisk
      );
  -- Ch57 of MPTX
  i_tx_link_driver_ch57 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_1_plus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(57).txdata,
      txcharisk_o    => s_gth_tx_data_arr(57).txcharisk
      );      
  -- Ch60 of MPTX
  i_tx_link_driver_ch60 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_1_plus(17 downto 0) & b"11" & x"AAA", --half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(60).txdata,
      txcharisk_o    => s_gth_tx_data_arr(60).txcharisk
      );
  -- Ch58 of MPTX
  i_tx_link_driver_ch58 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_2_plus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(58).txdata,
      txcharisk_o    => s_gth_tx_data_arr(58).txcharisk
      );      
  -- Ch54 of MPTX
  i_tx_link_driver_ch54 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_2_plus(17 downto 0) & b"11" & x"AAA", --half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(54).txdata,
      txcharisk_o    => s_gth_tx_data_arr(54).txcharisk
      );
  -- Ch55 of MPTX
  i_tx_link_driver_ch55 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_3_plus(35 downto 18) & b"11" & x"AAB", --other half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(55).txdata,
      txcharisk_o    => s_gth_tx_data_arr(55).txcharisk
      );      
  -- Ch61 of MPTX
  i_tx_link_driver_ch61 : entity work.tx_link_driver
    port map (
      clk240_i       => s_clk_240,
      clk250_i       => s_clk_usrclk_250,
      rst_i          => s_pat_gen_rst,
      tx_user_word_i => input_link2_3_plus(17 downto 0) & b"11" & x"AAA", --half of stub (LINK2) sent to eagle32
      bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
      bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
      txdata_o       => s_gth_tx_data_arr(61).txdata,
      txcharisk_o    => s_gth_tx_data_arr(61).txcharisk
      );

  -- channel 36-51 is not used for tx
  gen_tx_dummy_notx : for i in 36 to 51 generate    
    i_tx_link_driver : entity work.tx_link_driver
      port map (
        clk240_i       => s_clk_240,
        clk250_i       => s_clk_usrclk_250,
        rst_i          => s_pat_gen_rst,
        tx_user_word_i => s_tx_user_word(i)(31 downto 0),
        bc0_i          => bc0_stub, --s_local_timing_ref.bc0,
        bcid_i         => bcid_stub, --s_local_timing_ref.bcid,
        txdata_o       => s_gth_tx_data_arr(i).txdata,
        txcharisk_o    => s_gth_tx_data_arr(i).txcharisk
        );       
  end generate;
      

  -------------------------------------------------------------------------------------
  -- RECEIVING TRACKS FROM CXP0, CXP1 AND CXP2
  -------------------------------------------------------------------------------------  
  gen_rx_track : for i in 0 to 35 generate
    i_rx_depad_cdc_align : rx_depad_cdc_align
    port map(
      clk_250_i             => s_clk_usrclk_250,
      clk_240_i             => s_clk_240,
      gth_rx_data_i         => s_gth_rx_data_arr(i),
      link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
      realign_i             => s_link_align_track,
      start_fifo_read_i     => s_link_fifo_read_track,
      link_aligned_data_o   => s_link_aligned_data_arr(i),
      link_aligned_status_o => s_link_aligned_status_arr(i)
      );  
  end generate;
  
  -- channel 36-63 are not currently used for rx
  gen_rx_dummy : for i in 36 to 63 generate 
    i_rx_depad_cdc_align : rx_depad_cdc_align
    port map(
      clk_250_i             => s_clk_usrclk_250,
      clk_240_i             => s_clk_240,
      gth_rx_data_i         => s_gth_rx_data_arr(i),
      link_8b10b_err_rst_i  => s_link_8b10b_err_rst,
      realign_i             => s_link_align_dummy,
      start_fifo_read_i     => s_link_fifo_read_dummy,
      link_aligned_data_o   => s_link_aligned_data_arr(i),
      link_aligned_status_o => s_link_aligned_status_arr(i)
      );  
  end generate;

  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  -- alignment
  i_link_align_ctrl_track : link_align_ctrl
    generic map (
      G_NUM_OF_LINKs => 36
      )
    port map(
      clk_240_i                      => s_clk_240,
      link_align_req_i               => s_link_align_req,
      bx0_at_240_i                   => bc0_track, --s_local_timing_ref.bc0,
      link_align_o                   => s_link_align_track,
      link_fifo_read_o               => s_link_fifo_read_track,
      link_latency_ctrl_i            => s_link_latency_ctrl,
      link_latency_err_o             => s_link_latency_err,
      link_mask_ctrl_i               => s_link_mask_ctrl(35 downto 0),
      link_aligned_status_arr_i      => s_link_aligned_status_arr(35 downto 0),
      link_aligned_diagnostics_arr_o => s_link_aligned_diagnostics_arr(35 downto 0)
      );

  i_link_align_ctrl_dummy : link_align_ctrl
    generic map (
      G_NUM_OF_LINKs => 28
      )
    port map(
      clk_240_i                      => s_clk_240,
      link_align_req_i               => s_link_align_req,
      bx0_at_240_i                   => s_local_timing_ref.bc0,
      link_align_o                   => s_link_align_dummy,
      link_fifo_read_o               => s_link_fifo_read_dummy,
      link_latency_ctrl_i            => s_link_latency_ctrl,
      link_latency_err_o             => open, --s_link_latency_err,
      link_mask_ctrl_i               => s_link_mask_ctrl(63 downto 36),
      link_aligned_status_arr_i      => s_link_aligned_status_arr(63 downto 36),
      link_aligned_diagnostics_arr_o => s_link_aligned_diagnostics_arr(63 downto 36)
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
--
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
    
    
    ----------------------------------------------------------------
    -- Louise:  connecting inputs
    i_DTC_input_minus_1: DTC_input
      port map(
        clk => s_clk_240,                 --this is the 240 clock
        io_clk => BRAM_CTRL_REG_FILE_clk, --link clock?
        reset => s_pat_gen_rst,           --reset
        BC0 => s_local_timing_ref.bc0,    --global BC0 
        --track_en => track_en,             --enable writing tracks
        
        BRAM_INPUT1_en   => BRAM_INPUT1_en,
        BRAM_INPUT1_dout => BRAM_INPUT1_dout,
        BRAM_INPUT1_din  => BRAM_INPUT1_din,
        BRAM_INPUT1_we   => BRAM_INPUT1_we,
        BRAM_INPUT1_addr => BRAM_INPUT1_addr,
        BRAM_INPUT1_clk  => BRAM_INPUT1_clk,
        BRAM_INPUT1_rst  => BRAM_INPUT1_rst,
        
        BRAM_INPUT2_en   => BRAM_INPUT2_en,
        BRAM_INPUT2_dout => BRAM_INPUT2_dout,
        BRAM_INPUT2_din  => BRAM_INPUT2_din,
        BRAM_INPUT2_we   => BRAM_INPUT2_we,
        BRAM_INPUT2_addr => BRAM_INPUT2_addr,
        BRAM_INPUT2_clk  => BRAM_INPUT2_clk,
        BRAM_INPUT2_rst  => BRAM_INPUT2_rst,
        
        BRAM_INPUT3_en   => BRAM_INPUT3_en,
        BRAM_INPUT3_dout => BRAM_INPUT3_dout,
        BRAM_INPUT3_din  => BRAM_INPUT3_din,
        BRAM_INPUT3_we   => BRAM_INPUT3_we,
        BRAM_INPUT3_addr => BRAM_INPUT3_addr,
        BRAM_INPUT3_clk  => BRAM_INPUT3_clk,
        BRAM_INPUT3_rst  => BRAM_INPUT3_rst,
        
        BRAM_INPUT4_en   => BRAM_INPUT4_en,
        BRAM_INPUT4_dout => BRAM_INPUT4_dout,
        BRAM_INPUT4_din  => BRAM_INPUT4_din,
        BRAM_INPUT4_we   => BRAM_INPUT4_we,
        BRAM_INPUT4_addr => BRAM_INPUT4_addr,
        BRAM_INPUT4_clk  => BRAM_INPUT4_clk,
        BRAM_INPUT4_rst  => BRAM_INPUT4_rst,
        
        BRAM_INPUT5_en   => BRAM_INPUT5_en,
        BRAM_INPUT5_dout => BRAM_INPUT5_dout,
        BRAM_INPUT5_din  => BRAM_INPUT5_din,
        BRAM_INPUT5_we   => BRAM_INPUT5_we,
        BRAM_INPUT5_addr => BRAM_INPUT5_addr,
        BRAM_INPUT5_clk  => BRAM_INPUT5_clk,
        BRAM_INPUT5_rst  => BRAM_INPUT5_rst,
        
        BRAM_INPUT6_en   => BRAM_INPUT6_en,
        BRAM_INPUT6_dout => BRAM_INPUT6_dout,
        BRAM_INPUT6_din  => BRAM_INPUT6_din,
        BRAM_INPUT6_we   => BRAM_INPUT6_we,
        BRAM_INPUT6_addr => BRAM_INPUT6_addr,
        BRAM_INPUT6_clk  => BRAM_INPUT6_clk,
        BRAM_INPUT6_rst  => BRAM_INPUT6_rst,
        
        -- these are the 32 bit words
        input_link1_reg1 => input_link1_reg1,
--        input_link1_reg2 => input_link1_reg2,
--        input_link2_reg1 => input_link2_reg1,
--        input_link2_reg2 => input_link2_reg2,
--        input_link3_reg1 => input_link3_reg1,
--        input_link3_reg2 => input_link3_reg2,
       
        -- these are the 36 bit words
        input_link1 => input_link1_1_minus,
        input_link2 => input_link1_2_minus,
        input_link3 => input_link1_3_minus        
        ); 
        
    i_DTC_input_minus_2: DTC_input
      port map(
        clk => s_clk_240,                 
        io_clk => BRAM_CTRL_REG_FILE_clk, 
        reset => s_pat_gen_rst,           --reset
        BC0 => s_local_timing_ref.bc0,    --global BC0 
        --track_en => track_en,             --enable writing tracks
            
        BRAM_INPUT1_en   => BRAM_INPUT19_en,
        BRAM_INPUT1_dout => BRAM_INPUT19_dout,
        BRAM_INPUT1_din  => BRAM_INPUT19_din,
        BRAM_INPUT1_we   => BRAM_INPUT19_we,
        BRAM_INPUT1_addr => BRAM_INPUT19_addr,
        BRAM_INPUT1_clk  => BRAM_INPUT19_clk,
        BRAM_INPUT1_rst  => BRAM_INPUT19_rst,
            
        BRAM_INPUT2_en   => BRAM_INPUT20_en,
        BRAM_INPUT2_dout => BRAM_INPUT20_dout,
        BRAM_INPUT2_din  => BRAM_INPUT20_din,
        BRAM_INPUT2_we   => BRAM_INPUT20_we,
        BRAM_INPUT2_addr => BRAM_INPUT20_addr,
        BRAM_INPUT2_clk  => BRAM_INPUT20_clk,
        BRAM_INPUT2_rst  => BRAM_INPUT20_rst,
            
        BRAM_INPUT3_en   => BRAM_INPUT21_en,
        BRAM_INPUT3_dout => BRAM_INPUT21_dout,
        BRAM_INPUT3_din  => BRAM_INPUT21_din,
        BRAM_INPUT3_we   => BRAM_INPUT21_we,
        BRAM_INPUT3_addr => BRAM_INPUT21_addr,
        BRAM_INPUT3_clk  => BRAM_INPUT21_clk,
        BRAM_INPUT3_rst  => BRAM_INPUT21_rst,
            
        BRAM_INPUT4_en   => BRAM_INPUT22_en,
        BRAM_INPUT4_dout => BRAM_INPUT22_dout,
        BRAM_INPUT4_din  => BRAM_INPUT22_din,
        BRAM_INPUT4_we   => BRAM_INPUT22_we,
        BRAM_INPUT4_addr => BRAM_INPUT22_addr,
        BRAM_INPUT4_clk  => BRAM_INPUT22_clk,
        BRAM_INPUT4_rst  => BRAM_INPUT22_rst,
            
        BRAM_INPUT5_en   => BRAM_INPUT23_en,
        BRAM_INPUT5_dout => BRAM_INPUT23_dout,
        BRAM_INPUT5_din  => BRAM_INPUT23_din,
        BRAM_INPUT5_we   => BRAM_INPUT23_we,
        BRAM_INPUT5_addr => BRAM_INPUT23_addr,
        BRAM_INPUT5_clk  => BRAM_INPUT23_clk,
        BRAM_INPUT5_rst  => BRAM_INPUT23_rst,
            
        BRAM_INPUT6_en   => BRAM_INPUT24_en,
        BRAM_INPUT6_dout => BRAM_INPUT24_dout,
        BRAM_INPUT6_din  => BRAM_INPUT24_din,
        BRAM_INPUT6_we   => BRAM_INPUT24_we,
        BRAM_INPUT6_addr => BRAM_INPUT24_addr,
        BRAM_INPUT6_clk  => BRAM_INPUT24_clk,
        BRAM_INPUT6_rst  => BRAM_INPUT24_rst,
                      
        input_link1_reg1 => input_link1_reg1,  -- for enable
            
        -- these are the 36 bit words
        input_link1 => input_link2_1_minus,
        input_link2 => input_link2_2_minus,
        input_link3 => input_link2_3_minus        
        );         
        
     ----------------------------------------------------------------
     ----------------------------------------------------------------
    i_DTC_input_central_1: DTC_input
      port map(
        clk => s_clk_240,                 --this is the 240 clock
        io_clk => BRAM_CTRL_REG_FILE_clk, --link clock?
        reset => s_pat_gen_rst,           --reset
        BC0 => s_local_timing_ref.bc0,    --global BC0 
        track_en => track_en,             --enable writing tracks
        
        BRAM_INPUT1_en   => BRAM_INPUT7_en,
        BRAM_INPUT1_dout => BRAM_INPUT7_dout,
        BRAM_INPUT1_din  => BRAM_INPUT7_din,
        BRAM_INPUT1_we   => BRAM_INPUT7_we,
        BRAM_INPUT1_addr => BRAM_INPUT7_addr,
        BRAM_INPUT1_clk  => BRAM_INPUT7_clk,
        BRAM_INPUT1_rst  => BRAM_INPUT7_rst,
        
        BRAM_INPUT2_en   => BRAM_INPUT8_en,
        BRAM_INPUT2_dout => BRAM_INPUT8_dout,
        BRAM_INPUT2_din  => BRAM_INPUT8_din,
        BRAM_INPUT2_we   => BRAM_INPUT8_we,
        BRAM_INPUT2_addr => BRAM_INPUT8_addr,
        BRAM_INPUT2_clk  => BRAM_INPUT8_clk,
        BRAM_INPUT2_rst  => BRAM_INPUT8_rst,
        
        BRAM_INPUT3_en   => BRAM_INPUT9_en,
        BRAM_INPUT3_dout => BRAM_INPUT9_dout,
        BRAM_INPUT3_din  => BRAM_INPUT9_din,
        BRAM_INPUT3_we   => BRAM_INPUT9_we,
        BRAM_INPUT3_addr => BRAM_INPUT9_addr,
        BRAM_INPUT3_clk  => BRAM_INPUT9_clk,
        BRAM_INPUT3_rst  => BRAM_INPUT9_rst,
        
        BRAM_INPUT4_en   => BRAM_INPUT10_en,
        BRAM_INPUT4_dout => BRAM_INPUT10_dout,
        BRAM_INPUT4_din  => BRAM_INPUT10_din,
        BRAM_INPUT4_we   => BRAM_INPUT10_we,
        BRAM_INPUT4_addr => BRAM_INPUT10_addr,
        BRAM_INPUT4_clk  => BRAM_INPUT10_clk,
        BRAM_INPUT4_rst  => BRAM_INPUT10_rst,
        
        BRAM_INPUT5_en   => BRAM_INPUT11_en,
        BRAM_INPUT5_dout => BRAM_INPUT11_dout,
        BRAM_INPUT5_din  => BRAM_INPUT11_din,
        BRAM_INPUT5_we   => BRAM_INPUT11_we,
        BRAM_INPUT5_addr => BRAM_INPUT11_addr,
        BRAM_INPUT5_clk  => BRAM_INPUT11_clk,
        BRAM_INPUT5_rst  => BRAM_INPUT11_rst,
        
        BRAM_INPUT6_en   => BRAM_INPUT12_en,
        BRAM_INPUT6_dout => BRAM_INPUT12_dout,
        BRAM_INPUT6_din  => BRAM_INPUT12_din,
        BRAM_INPUT6_we   => BRAM_INPUT12_we,
        BRAM_INPUT6_addr => BRAM_INPUT12_addr,
        BRAM_INPUT6_clk  => BRAM_INPUT12_clk,
        BRAM_INPUT6_rst  => BRAM_INPUT12_rst,
        
        -- these are the 32 bit words
        input_link1_reg1 => input_link1_reg1,
--        input_link1_reg2 => input_link1_reg2,
--        input_link2_reg1 => input_link2_reg1,
--        input_link2_reg2 => input_link2_reg2,
--        input_link3_reg1 => input_link3_reg1,
--        input_link3_reg2 => input_link3_reg2,
       
        -- these are the 36 bit words
        input_link1 => input_link1_1_central,
        input_link2 => input_link1_2_central,
        input_link3 => input_link1_3_central
        
        ); 
        
    i_DTC_input_central_2: DTC_input
          port map(
            clk => s_clk_240,                 --this is the 240 clock
            io_clk => BRAM_CTRL_REG_FILE_clk, --link clock?
            reset => s_pat_gen_rst,           --reset
            BC0 => s_local_timing_ref.bc0,    --global BC0 
    --        track_en => track_en,             --enable writing tracks
            
            BRAM_INPUT1_en   => BRAM_INPUT25_en,
            BRAM_INPUT1_dout => BRAM_INPUT25_dout,
            BRAM_INPUT1_din  => BRAM_INPUT25_din,
            BRAM_INPUT1_we   => BRAM_INPUT25_we,
            BRAM_INPUT1_addr => BRAM_INPUT25_addr,
            BRAM_INPUT1_clk  => BRAM_INPUT25_clk,
            BRAM_INPUT1_rst  => BRAM_INPUT25_rst,
            
            BRAM_INPUT2_en   => BRAM_INPUT26_en,
            BRAM_INPUT2_dout => BRAM_INPUT26_dout,
            BRAM_INPUT2_din  => BRAM_INPUT26_din,
            BRAM_INPUT2_we   => BRAM_INPUT26_we,
            BRAM_INPUT2_addr => BRAM_INPUT26_addr,
            BRAM_INPUT2_clk  => BRAM_INPUT26_clk,
            BRAM_INPUT2_rst  => BRAM_INPUT26_rst,
            
            BRAM_INPUT3_en   => BRAM_INPUT27_en,
            BRAM_INPUT3_dout => BRAM_INPUT27_dout,
            BRAM_INPUT3_din  => BRAM_INPUT27_din,
            BRAM_INPUT3_we   => BRAM_INPUT27_we,
            BRAM_INPUT3_addr => BRAM_INPUT27_addr,
            BRAM_INPUT3_clk  => BRAM_INPUT27_clk,
            BRAM_INPUT3_rst  => BRAM_INPUT27_rst,
            
            BRAM_INPUT4_en   => BRAM_INPUT28_en,
            BRAM_INPUT4_dout => BRAM_INPUT28_dout,
            BRAM_INPUT4_din  => BRAM_INPUT28_din,
            BRAM_INPUT4_we   => BRAM_INPUT28_we,
            BRAM_INPUT4_addr => BRAM_INPUT28_addr,
            BRAM_INPUT4_clk  => BRAM_INPUT28_clk,
            BRAM_INPUT4_rst  => BRAM_INPUT28_rst,
            
            BRAM_INPUT5_en   => BRAM_INPUT29_en,
            BRAM_INPUT5_dout => BRAM_INPUT29_dout,
            BRAM_INPUT5_din  => BRAM_INPUT29_din,
            BRAM_INPUT5_we   => BRAM_INPUT29_we,
            BRAM_INPUT5_addr => BRAM_INPUT29_addr,
            BRAM_INPUT5_clk  => BRAM_INPUT29_clk,
            BRAM_INPUT5_rst  => BRAM_INPUT29_rst,
            
            BRAM_INPUT6_en   => BRAM_INPUT30_en,
            BRAM_INPUT6_dout => BRAM_INPUT30_dout,
            BRAM_INPUT6_din  => BRAM_INPUT30_din,
            BRAM_INPUT6_we   => BRAM_INPUT30_we,
            BRAM_INPUT6_addr => BRAM_INPUT30_addr,
            BRAM_INPUT6_clk  => BRAM_INPUT30_clk,
            BRAM_INPUT6_rst  => BRAM_INPUT30_rst,
            
            -- these are the 32 bit words
            input_link1_reg1 => input_link1_reg1,
    --        input_link1_reg2 => input_link1_reg2,
    --        input_link2_reg1 => input_link2_reg1,
    --        input_link2_reg2 => input_link2_reg2,
    --        input_link3_reg1 => input_link3_reg1,
    --        input_link3_reg2 => input_link3_reg2,
           
            -- these are the 36 bit words
            input_link1 => input_link2_1_central,
            input_link2 => input_link2_2_central,
            input_link3 => input_link2_3_central
            
            );         

    i_DTC_input_central_3: DTC_input
          port map(
            clk => s_clk_240,                 --this is the 240 clock
            io_clk => BRAM_CTRL_REG_FILE_clk, --link clock?
            reset => s_pat_gen_rst,           --reset
            BC0 => s_local_timing_ref.bc0,    --global BC0 
    --        track_en => track_en,             --enable writing tracks
            
            BRAM_INPUT1_en   => BRAM_INPUT37_en,
            BRAM_INPUT1_dout => BRAM_INPUT37_dout,
            BRAM_INPUT1_din  => BRAM_INPUT37_din,
            BRAM_INPUT1_we   => BRAM_INPUT37_we,
            BRAM_INPUT1_addr => BRAM_INPUT37_addr,
            BRAM_INPUT1_clk  => BRAM_INPUT37_clk,
            BRAM_INPUT1_rst  => BRAM_INPUT37_rst,
            
            BRAM_INPUT2_en   => BRAM_INPUT38_en,
            BRAM_INPUT2_dout => BRAM_INPUT38_dout,
            BRAM_INPUT2_din  => BRAM_INPUT38_din,
            BRAM_INPUT2_we   => BRAM_INPUT38_we,
            BRAM_INPUT2_addr => BRAM_INPUT38_addr,
            BRAM_INPUT2_clk  => BRAM_INPUT38_clk,
            BRAM_INPUT2_rst  => BRAM_INPUT38_rst,
            
            BRAM_INPUT3_en   => BRAM_INPUT39_en,
            BRAM_INPUT3_dout => BRAM_INPUT39_dout,
            BRAM_INPUT3_din  => BRAM_INPUT39_din,
            BRAM_INPUT3_we   => BRAM_INPUT39_we,
            BRAM_INPUT3_addr => BRAM_INPUT39_addr,
            BRAM_INPUT3_clk  => BRAM_INPUT39_clk,
            BRAM_INPUT3_rst  => BRAM_INPUT39_rst,
            
            BRAM_INPUT4_en   => BRAM_INPUT40_en,
            BRAM_INPUT4_dout => BRAM_INPUT40_dout,
            BRAM_INPUT4_din  => BRAM_INPUT40_din,
            BRAM_INPUT4_we   => BRAM_INPUT40_we,
            BRAM_INPUT4_addr => BRAM_INPUT40_addr,
            BRAM_INPUT4_clk  => BRAM_INPUT40_clk,
            BRAM_INPUT4_rst  => BRAM_INPUT40_rst,
            
            BRAM_INPUT5_en   => BRAM_INPUT41_en,
            BRAM_INPUT5_dout => BRAM_INPUT41_dout,
            BRAM_INPUT5_din  => BRAM_INPUT41_din,
            BRAM_INPUT5_we   => BRAM_INPUT41_we,
            BRAM_INPUT5_addr => BRAM_INPUT41_addr,
            BRAM_INPUT5_clk  => BRAM_INPUT41_clk,
            BRAM_INPUT5_rst  => BRAM_INPUT41_rst,
            
            BRAM_INPUT6_en   => BRAM_INPUT42_en,
            BRAM_INPUT6_dout => BRAM_INPUT42_dout,
            BRAM_INPUT6_din  => BRAM_INPUT42_din,
            BRAM_INPUT6_we   => BRAM_INPUT42_we,
            BRAM_INPUT6_addr => BRAM_INPUT42_addr,
            BRAM_INPUT6_clk  => BRAM_INPUT42_clk,
            BRAM_INPUT6_rst  => BRAM_INPUT42_rst,
            
            -- these are the 32 bit words
            input_link1_reg1 => input_link1_reg1,
    --        input_link1_reg2 => input_link1_reg2,
    --        input_link2_reg1 => input_link2_reg1,
    --        input_link2_reg2 => input_link2_reg2,
    --        input_link3_reg1 => input_link3_reg1,
    --        input_link3_reg2 => input_link3_reg2,
           
            -- these are the 36 bit words
            input_link1 => input_link3_1_central,
            input_link2 => input_link3_2_central,
            input_link3 => input_link3_3_central
            
            );  
        
     ----------------------------------------------------------------
     ----------------------------------------------------------------
    i_DTC_input_plus_1: DTC_input
      port map(
        clk => s_clk_240,                 --this is the 240 clock
        io_clk => BRAM_CTRL_REG_FILE_clk, --link clock?
        reset => s_pat_gen_rst,           --reset
        BC0 => s_local_timing_ref.bc0,    --global BC0 
--        track_en => track_en,             --enable writing tracks
        
        BRAM_INPUT1_en   => BRAM_INPUT13_en,
        BRAM_INPUT1_dout => BRAM_INPUT13_dout,
        BRAM_INPUT1_din  => BRAM_INPUT13_din,
        BRAM_INPUT1_we   => BRAM_INPUT13_we,
        BRAM_INPUT1_addr => BRAM_INPUT13_addr,
        BRAM_INPUT1_clk  => BRAM_INPUT13_clk,
        BRAM_INPUT1_rst  => BRAM_INPUT13_rst,
        
        BRAM_INPUT2_en   => BRAM_INPUT14_en,
        BRAM_INPUT2_dout => BRAM_INPUT14_dout,
        BRAM_INPUT2_din  => BRAM_INPUT14_din,
        BRAM_INPUT2_we   => BRAM_INPUT14_we,
        BRAM_INPUT2_addr => BRAM_INPUT14_addr,
        BRAM_INPUT2_clk  => BRAM_INPUT14_clk,
        BRAM_INPUT2_rst  => BRAM_INPUT14_rst,
        
        BRAM_INPUT3_en   => BRAM_INPUT15_en,
        BRAM_INPUT3_dout => BRAM_INPUT15_dout,
        BRAM_INPUT3_din  => BRAM_INPUT15_din,
        BRAM_INPUT3_we   => BRAM_INPUT15_we,
        BRAM_INPUT3_addr => BRAM_INPUT15_addr,
        BRAM_INPUT3_clk  => BRAM_INPUT15_clk,
        BRAM_INPUT3_rst  => BRAM_INPUT15_rst,
        
        BRAM_INPUT4_en   => BRAM_INPUT16_en,
        BRAM_INPUT4_dout => BRAM_INPUT16_dout,
        BRAM_INPUT4_din  => BRAM_INPUT16_din,
        BRAM_INPUT4_we   => BRAM_INPUT16_we,
        BRAM_INPUT4_addr => BRAM_INPUT16_addr,
        BRAM_INPUT4_clk  => BRAM_INPUT16_clk,
        BRAM_INPUT4_rst  => BRAM_INPUT16_rst,
        
        BRAM_INPUT5_en   => BRAM_INPUT17_en,
        BRAM_INPUT5_dout => BRAM_INPUT17_dout,
        BRAM_INPUT5_din  => BRAM_INPUT17_din,
        BRAM_INPUT5_we   => BRAM_INPUT17_we,
        BRAM_INPUT5_addr => BRAM_INPUT17_addr,
        BRAM_INPUT5_clk  => BRAM_INPUT17_clk,
        BRAM_INPUT5_rst  => BRAM_INPUT17_rst,
        
        BRAM_INPUT6_en   => BRAM_INPUT18_en,
        BRAM_INPUT6_dout => BRAM_INPUT18_dout,
        BRAM_INPUT6_din  => BRAM_INPUT18_din,
        BRAM_INPUT6_we   => BRAM_INPUT18_we,
        BRAM_INPUT6_addr => BRAM_INPUT18_addr,
        BRAM_INPUT6_clk  => BRAM_INPUT18_clk,
        BRAM_INPUT6_rst  => BRAM_INPUT18_rst,
        
        -- these are the 32 bit words
        input_link1_reg1 => input_link1_reg1,
--        input_link1_reg2 => input_link1_reg2,
--        input_link2_reg1 => input_link2_reg1,
--        input_link2_reg2 => input_link2_reg2,
--        input_link3_reg1 => input_link3_reg1,
--        input_link3_reg2 => input_link3_reg2,
       
        -- these are the 36 bit words
        input_link1 => input_link1_1_plus,
        input_link2 => input_link1_2_plus,
        input_link3 => input_link1_3_plus
        
        ); 
        
    i_DTC_input_plus_2: DTC_input
          port map(
            clk => s_clk_240,                 --this is the 240 clock
            io_clk => BRAM_CTRL_REG_FILE_clk, --link clock?
            reset => s_pat_gen_rst,           --reset
            BC0 => s_local_timing_ref.bc0,    --global BC0 
    --        track_en => track_en,             --enable writing tracks
            
            BRAM_INPUT1_en   => BRAM_INPUT31_en,
            BRAM_INPUT1_dout => BRAM_INPUT31_dout,
            BRAM_INPUT1_din  => BRAM_INPUT31_din,
            BRAM_INPUT1_we   => BRAM_INPUT31_we,
            BRAM_INPUT1_addr => BRAM_INPUT31_addr,
            BRAM_INPUT1_clk  => BRAM_INPUT31_clk,
            BRAM_INPUT1_rst  => BRAM_INPUT31_rst,
            
            BRAM_INPUT2_en   => BRAM_INPUT32_en,
            BRAM_INPUT2_dout => BRAM_INPUT32_dout,
            BRAM_INPUT2_din  => BRAM_INPUT32_din,
            BRAM_INPUT2_we   => BRAM_INPUT32_we,
            BRAM_INPUT2_addr => BRAM_INPUT32_addr,
            BRAM_INPUT2_clk  => BRAM_INPUT32_clk,
            BRAM_INPUT2_rst  => BRAM_INPUT32_rst,
            
            BRAM_INPUT3_en   => BRAM_INPUT33_en,
            BRAM_INPUT3_dout => BRAM_INPUT33_dout,
            BRAM_INPUT3_din  => BRAM_INPUT33_din,
            BRAM_INPUT3_we   => BRAM_INPUT33_we,
            BRAM_INPUT3_addr => BRAM_INPUT33_addr,
            BRAM_INPUT3_clk  => BRAM_INPUT33_clk,
            BRAM_INPUT3_rst  => BRAM_INPUT33_rst,
            
            BRAM_INPUT4_en   => BRAM_INPUT34_en,
            BRAM_INPUT4_dout => BRAM_INPUT34_dout,
            BRAM_INPUT4_din  => BRAM_INPUT34_din,
            BRAM_INPUT4_we   => BRAM_INPUT34_we,
            BRAM_INPUT4_addr => BRAM_INPUT34_addr,
            BRAM_INPUT4_clk  => BRAM_INPUT34_clk,
            BRAM_INPUT4_rst  => BRAM_INPUT34_rst,
            
            BRAM_INPUT5_en   => BRAM_INPUT35_en,
            BRAM_INPUT5_dout => BRAM_INPUT35_dout,
            BRAM_INPUT5_din  => BRAM_INPUT35_din,
            BRAM_INPUT5_we   => BRAM_INPUT35_we,
            BRAM_INPUT5_addr => BRAM_INPUT35_addr,
            BRAM_INPUT5_clk  => BRAM_INPUT35_clk,
            BRAM_INPUT5_rst  => BRAM_INPUT35_rst,
            
            BRAM_INPUT6_en   => BRAM_INPUT36_en,
            BRAM_INPUT6_dout => BRAM_INPUT36_dout,
            BRAM_INPUT6_din  => BRAM_INPUT36_din,
            BRAM_INPUT6_we   => BRAM_INPUT36_we,
            BRAM_INPUT6_addr => BRAM_INPUT36_addr,
            BRAM_INPUT6_clk  => BRAM_INPUT36_clk,
            BRAM_INPUT6_rst  => BRAM_INPUT36_rst,
            
            -- these are the 32 bit words
            input_link1_reg1 => input_link1_reg1,
    --        input_link1_reg2 => input_link1_reg2,
    --        input_link2_reg1 => input_link2_reg1,
    --        input_link2_reg2 => input_link2_reg2,
    --        input_link3_reg1 => input_link3_reg1,
    --        input_link3_reg2 => input_link3_reg2,
           
            -- these are the 36 bit words
            input_link1 => input_link2_1_plus,
            input_link2 => input_link2_2_plus,
            input_link3 => input_link2_3_plus
            
            );         
        
     ----------------------------------------------------------------
     
     ----------------------------------------------------------------
     -- Jorge:  connecting outputs
     -- Implement other seeding layers
     -- TODO: Implement neighbor boards
     
     i_Track_Sink_central_L1L2: Track_Sink
       port map(
         clk => s_clk_240,                  --this is the 240 clock
         io_clk => BRAM_OUTPUT1_clk,        --link clock?
         reset => s_pat_gen_rst,            --reset
         BC0 => s_local_timing_ref.bc0,     --global BC0 
         track_en => track_en,              --enable writing tracks
         
         BRAM_OUTPUT1_dout => BRAM_OUTPUT1_dout,
         BRAM_OUTPUT1_addr => BRAM_OUTPUT1_addr,
         BRAM_OUTPUT2_dout => BRAM_OUTPUT2_dout,
         BRAM_OUTPUT2_addr => BRAM_OUTPUT2_addr,
         
         -- track coming from link
         track_output => s_link_aligned_data_arr(20).data(31 downto 0) & s_link_aligned_data_arr(19).data(31 downto 0),
                            
         track_BX => track_BX_central_l1l2,
         valid_track => valid_track_central_l1l2,
         
         ecounter => ecounter
         
         
         ); 
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    i_Track_Sink_central_L3L4: Track_Sink
       port map(
         clk => s_clk_240,                  --this is the 240 clock
         io_clk => BRAM_OUTPUT3_clk,        --link clock?
         reset => s_pat_gen_rst,            --reset
         BC0 => s_local_timing_ref.bc0,     --global BC0 
         track_en => track_en,              --enable writing tracks
         
         BRAM_OUTPUT1_dout => BRAM_OUTPUT3_dout,
         BRAM_OUTPUT1_addr => BRAM_OUTPUT3_addr,
         BRAM_OUTPUT2_dout => BRAM_OUTPUT4_dout,
         BRAM_OUTPUT2_addr => BRAM_OUTPUT4_addr,
         
         -- track coming from link
         track_output => s_link_aligned_data_arr(12).data(31 downto 0) & s_link_aligned_data_arr(22).data(31 downto 0),
         
         track_BX => track_BX_central_l3l4,
         valid_track => valid_track_central_l3l4
         
         ); 
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    i_Track_Sink_central_L5L6: Track_Sink
       port map(
         clk => s_clk_240,                  --this is the 240 clock
         io_clk => BRAM_OUTPUT5_clk,        --link clock?
         reset => s_pat_gen_rst,            --reset
         BC0 => s_local_timing_ref.bc0,     --global BC0 
         track_en => track_en,              --enable writing tracks
         
         BRAM_OUTPUT1_dout => BRAM_OUTPUT5_dout,
         BRAM_OUTPUT1_addr => BRAM_OUTPUT5_addr,
         BRAM_OUTPUT2_dout => BRAM_OUTPUT6_dout,
         BRAM_OUTPUT2_addr => BRAM_OUTPUT6_addr,
         
         -- track coming from link
         track_output => s_link_aligned_data_arr(14).data(31 downto 0) & s_link_aligned_data_arr(13).data(31 downto 0),
         
         track_BX => track_BX_central_l5l6,
         valid_track => valid_track_central_l5l6
         
         ); 
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    i_Track_Sink_central_F1F2: Track_Sink
       port map(
         clk => s_clk_240,                  --this is the 240 clock
         io_clk => BRAM_OUTPUT7_clk,        --link clock?
         reset => s_pat_gen_rst,            --reset
         BC0 => s_local_timing_ref.bc0,     --global BC0 
         track_en => track_en,              --enable writing tracks
         
         BRAM_OUTPUT1_dout => BRAM_OUTPUT7_dout,
         BRAM_OUTPUT1_addr => BRAM_OUTPUT7_addr,
         BRAM_OUTPUT2_dout => BRAM_OUTPUT8_dout,
         BRAM_OUTPUT2_addr => BRAM_OUTPUT8_addr,
         
         -- track coming from link
         track_output => s_link_aligned_data_arr(18).data(31 downto 0) & s_link_aligned_data_arr(16).data(31 downto 0),
         
         track_BX => track_BX_central_f1f2,
         valid_track => valid_track_central_f1f2
         
         ); 
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    i_Track_Sink_central_F3F4: Track_Sink
       port map(
         clk => s_clk_240,                  --this is the 240 clock
         io_clk => BRAM_OUTPUT9_clk,        --link clock?
         reset => s_pat_gen_rst,            --reset
         BC0 => s_local_timing_ref.bc0,     --global BC0 
         track_en => track_en,              --enable writing tracks
         
         BRAM_OUTPUT1_dout => BRAM_OUTPUT9_dout,
         BRAM_OUTPUT1_addr => BRAM_OUTPUT9_addr,
         BRAM_OUTPUT2_dout => BRAM_OUTPUT10_dout,
         BRAM_OUTPUT2_addr => BRAM_OUTPUT10_addr,
         
         -- track coming from link
         track_output => s_link_aligned_data_arr(21).data(31 downto 0) & s_link_aligned_data_arr(15).data(31 downto 0),
         
         track_BX => track_BX_central_f3f4,
         valid_track => valid_track_central_f3f4
         
         ); 
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    i_Track_Sink_central_F1L1: Track_Sink
       port map(
         clk => s_clk_240,                  --this is the 240 clock
         io_clk => BRAM_OUTPUT11_clk,        --link clock?
         reset => s_pat_gen_rst,            --reset
         BC0 => s_local_timing_ref.bc0,     --global BC0 
         track_en => track_en,              --enable writing tracks
         
         BRAM_OUTPUT1_dout => BRAM_OUTPUT11_dout,
         BRAM_OUTPUT1_addr => BRAM_OUTPUT11_addr,
         BRAM_OUTPUT2_dout => BRAM_OUTPUT12_dout,
         BRAM_OUTPUT2_addr => BRAM_OUTPUT12_addr,
         
         -- track coming from link
         track_output => s_link_aligned_data_arr(23).data(31 downto 0) & s_link_aligned_data_arr(17).data(31 downto 0),
         
         track_BX => track_BX_central_f1l1,
         valid_track => valid_track_central_f1l1
         
         ); 
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    -- Tao: latency measurement
    valid_track_central <= valid_track_central_l1l2 or valid_track_central_l3l4 or valid_track_central_l5l6 or
                           valid_track_central_f1f2 or valid_track_central_f3f4 or valid_track_central_f1l1;
    
    track_BX_central <= track_BX_central_l1l2 when valid_track_central_l1l2 = '1' else
                        track_BX_central_l3l4 when valid_track_central_l3l4 = '1' else
                        track_BX_central_l5l6 when valid_track_central_l5l6 = '1' else
                        track_BX_central_f1f2 when valid_track_central_f1f2 = '1' else
                        track_BX_central_f3f4 when valid_track_central_f3f4 = '1' else
                        track_BX_central_f1l1 when valid_track_central_f1l1 = '1' else
                        "00000";
    
    i_timer: Track_Timer
        port map(
            clk => s_clk_240,
            io_clk => BRAM_TIMER_clk,
            reset => s_timer_reset,
            start => track_en,
            valid_track => valid_track_central,
            track_BX => track_BX_central,
            BRAM_TIMER_addr => BRAM_TIMER_addr,
            BRAM_TIMER_dout => BRAM_TIMER_dout
        );
  
    -- bc0 delay    
    i_bc0_delays : bc0_delays
      port map (
        clk_proc  => s_clk_240,
        bc0_i     => s_local_timing_ref.bc0,
        bcid_i    => s_local_timing_ref.bcid,
        bc0_delay_ctrl_1 => s_bc0_delay_ctrl_stub,
        bc0_delay_ctrl_2 => s_bc0_delay_ctrl_track,
        bc0_delay_ctrl_3 => x"ffff",
        bc0_delay_ctrl_4 => x"ffff",
        bc0_out1  => bc0_stub,  
        bc0_out2  => bc0_track,  
        bc0_out3  => open,  
        bc0_out4  => open,
        bcid_out1 => bcid_stub,  
        bcid_out2 => bcid_track,  
        bcid_out3 => open,
        bcid_out4 => open
    );

end ctp7_v1_dtc_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

