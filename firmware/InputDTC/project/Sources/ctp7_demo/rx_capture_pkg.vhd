-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: rx_capture_pkg                                          
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
package rx_capture_pkg is

  type t_rx_capture_ctrl is record

    arm        : std_logic;
    mode       : std_logic_vector(1 downto 0);
    tcds_cmd   : std_logic_vector(3 downto 0);
    start_bcid : std_logic_vector(11 downto 0);

  end record;

  type t_rx_capture_status is record

    done                           : std_logic;
    fsm_state                      : std_logic_vector(1 downto 0);
    capture_started_at_local_bx_id : std_logic_vector(11 downto 0);
    capture_started_at_link_bx_id  : std_logic_vector(11 downto 0);

  end record;

  type t_rx_capture_ctrl_arr is array(integer range <>) of t_rx_capture_ctrl;
  type t_rx_capture_status_arr is array(integer range <>) of t_rx_capture_status;

end package rx_capture_pkg;
--============================================================================
--                                                            Package Body End
--============================================================================

