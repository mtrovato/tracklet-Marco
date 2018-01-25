-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: link_align_pkg                                           
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
--    Date Created: October 2014
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

package link_align_pkg is

  type t_link_aligned_data is record
    data         : std_logic_vector(31 downto 0);
    kchar0       : std_logic;
    data_valid   : std_logic;
    rxnotintable : std_logic;
    rxdisperr    : std_logic;
    BX_id        : std_logic_vector(11 downto 0);
    sub_BX_id    : std_logic_vector(2 downto 0);
  end record;

  type t_link_aligned_status is record
    fifo_ovrf              : std_logic;
    fifo_undrf             : std_logic;
    fifo_full              : std_logic;
    fifo_empty             : std_logic;
    alignment_marker_found : std_logic;
    link_bc0_marker        : std_logic;
    link_OK_extended       : std_logic;
    link_ERR_latched       : std_logic;
    link_8b10b_err_cnt     : std_logic_vector(31 downto 0);
  end record;

  type t_link_aligned_diagnostics is record
    alignment_marker_found : std_logic;
    bx_id_at_marker        : std_logic_vector(15 downto 0);
    fifo_error             : std_logic;
    fifo_not_empty         : std_logic;
  end record;

  type t_link_aligned_data_arr is array(integer range <>) of t_link_aligned_data;
  type t_link_aligned_status_arr is array(integer range <>) of t_link_aligned_status;
  type t_link_aligned_diagnostics_arr is array(integer range <>) of t_link_aligned_diagnostics;

end package link_align_pkg;

