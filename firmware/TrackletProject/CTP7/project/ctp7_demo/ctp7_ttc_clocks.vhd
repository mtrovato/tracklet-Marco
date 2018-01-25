-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_ttc_clocks                                           
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

--============================================================================
--                                                          Entity declaration
--============================================================================
entity ctp7_ttc_clocks is
  port(
    clk_40_ttc_p_i : in std_logic;      -- TTC backplane clock signals
    clk_40_ttc_n_i : in std_logic;

    mmcm_rst_i : in std_logic;
    mmcm_locked_o : out std_logic;

    ttc_mmcm_ps_clk_i : in std_logic;
    ttc_mmcm_ps_clk_en_i : in std_logic;

    clk_40_bufg_o  : out std_logic;
    clk_240_bufg_o : out std_logic;
    --MT
    clk_new_bufg_o : out std_logic    
    );

end ctp7_ttc_clocks;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ctp7_ttc_clocks_arch of ctp7_ttc_clocks is

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_clk_40_ttc_ibufds : std_logic;

  signal s_clk_40  : std_logic;
  signal s_clk_240 : std_logic;
  signal s_clk_new : std_logic;         --MT

  signal s_clkfbout      : std_logic;
  signal s_clkfbout_bufg : std_logic;

--============================================================================
--                                                          Architecture begin
--============================================================================
begin

  -- Input buffering
  --------------------------------------
  i_ibufgds_clk_40_ttc : IBUFDS
    port map
    (
      O  => s_clk_40_ttc_ibufds,
      I  => clk_40_ttc_p_i,
      IB => clk_40_ttc_n_i
      );

  -- Clocking PRIMITIVE
  --------------------------------------
  -- Instantiation of the MMCM PRIMITIVE
  --    * Unused inputs are tied off
  --    * Unused outputs are left open
  mmcm_adv_inst : MMCME2_ADV
    generic map
    (BANDWIDTH            => "OPTIMIZED",
     CLKOUT4_CASCADE      => false,
     COMPENSATION         => "ZHOLD",
     STARTUP_WAIT         => false,
     DIVCLK_DIVIDE        => 1,
     CLKFBOUT_MULT_F      => 24.000,
     CLKFBOUT_PHASE       => 45.000,
     CLKFBOUT_USE_FINE_PS => true,
     CLKOUT0_DIVIDE_F     => 24.000,
     CLKOUT0_PHASE        => 0.000,
     CLKOUT0_DUTY_CYCLE   => 0.500,
     CLKOUT0_USE_FINE_PS  => false,
     CLKOUT1_DIVIDE       => 4,
     CLKOUT1_PHASE        => 0.000,
     CLKOUT1_DUTY_CYCLE   => 0.500,
     CLKOUT1_USE_FINE_PS  => false,
     CLKIN1_PERIOD        => 25.0,
     REF_JITTER1          => 0.010,
--MT
     CLKOUT2_DIVIDE       => 1,
     CLKOUT2_DUTY_CYCLE   => 0.500,
     CLKOUT2_PHASE        => 0.000,
     CLKOUT2_USE_FINE_PS  => false
     )
    port map
    -- Output clocks
    (
      CLKFBOUT     => s_clkfbout,
      CLKFBOUTB    => open,
      CLKOUT0      => s_clk_40,
      CLKOUT0B     => open,
      CLKOUT1      => s_clk_240,
      CLKOUT1B     => open,
--      CLKOUT2      => open,
      CLKOUT2      => s_clk_new,        --MT
      CLKOUT2B     => open,
      CLKOUT3      => open,
      CLKOUT3B     => open,
      CLKOUT4      => open,
      CLKOUT5      => open,
      CLKOUT6      => open,
      -- Input clock control
      CLKFBIN      => s_clkfbout_bufg,
      CLKIN1       => s_clk_40_ttc_ibufds,
      CLKIN2       => '0',
      -- Tied to always select the primary input clock
      CLKINSEL     => '1',
      
      -- Ports for dynamic reconfiguration
      DADDR        => (others => '0'),
      DCLK         => '0',
      DEN          => '0',
      DI           => (others => '0'),
      DO           => open,
      DRDY         => open,
      DWE          => '0',
      -- Ports for dynamic phase shift
      PSCLK        => ttc_mmcm_ps_clk_i,
      PSEN         => ttc_mmcm_ps_clk_en_i,
      PSINCDEC     => '1',
      PSDONE       => open,
      -- Other control and status signals
      LOCKED       => mmcm_locked_o,
      CLKINSTOPPED => open,
      CLKFBSTOPPED => open,
      PWRDWN       => '0',
      RST          => mmcm_rst_i
      );


  -- Output buffering
  -------------------------------------

  i_bufg_clk_fb : BUFG
    port map
    (
      O => s_clkfbout_bufg,
      I => s_clkfbout
      );

  i_bufg_clk_40 : BUFG
    port map
    (
      O => clk_40_bufg_o,
      I => s_clk_40
      );

  i_bufg_clk_240 : BUFG
    port map
    (
      O => clk_240_bufg_o,
      I => s_clk_240
      );

--MT
  i_bufg_clk_new : BUFG
    port map
    (
      O => clk_new_bufg_o,
      I => s_clk_new
      );
  
end ctp7_ttc_clocks_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
