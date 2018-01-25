-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_v7_build_cfg                                          
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

--============================================================================
--                                                               Package Start
--============================================================================

package ctp7_v7_build_cfg is

  constant BCFG_FW_VERSION_MAJOR : std_logic_vector(7 downto 0) := X"01";
  constant BCFG_FW_VERSION_MINOR : std_logic_vector(7 downto 0) := X"01";
  constant BCFG_FW_VERSION_PATCH : std_logic_vector(7 downto 0) := X"00";

end package ctp7_v7_build_cfg;
--============================================================================
--                                                            Package Body End
--============================================================================
