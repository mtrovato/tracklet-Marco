-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: local_timing_ref_gen                                           
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
use work.timing_ref_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity local_timing_ref_gen_old is
  port (
    clk_240_i    : in  std_logic;
    timing_ref_o : out t_timing_ref
    );
end local_timing_ref_gen_old;


--============================================================================
--                                                        Architecture section
--============================================================================
architecture local_timing_ref_gen_old_arch of local_timing_ref_gen_old is

--============================================================================
--                                                       Constant declarations
--============================================================================  

  constant C_BCID_MAX    : integer := 3564;
  constant C_REF_CNT_MAX : integer := C_BCID_MAX *6 - 1;


--============================================================================
--                                                         Signal declarations
--============================================================================  
  signal s_ref_cnt : integer range 0 to C_BCID_MAX *6 := 0;

  signal s_bc0_240_internal : std_logic;

  signal s_bcid     : unsigned(11 downto 0);
  signal s_sub_bcid : unsigned(2 downto 0);
  signal s_bc0      : std_logic;
  signal s_cyc      : std_logic;


--============================================================================
--                                                          Architecture begin
--============================================================================  
begin

  process(clk_240_i) is
  begin
    if rising_edge(clk_240_i) then
      s_bc0_240_internal <= '0';
      s_ref_cnt          <= s_ref_cnt + 1;

      if (s_ref_cnt = C_REF_CNT_MAX) then
        s_ref_cnt          <= 0;
        s_bc0_240_internal <= '1';
      end if;
    end if;
  end process;

  process(clk_240_i) is
  begin
    if rising_edge(clk_240_i) then
      if (s_bc0_240_internal = '1') then
        s_bcid     <= x"000";
        s_sub_bcid <= "000";
        s_cyc      <= '1';
        s_bc0      <= '1';

      else

        s_sub_bcid <= s_sub_bcid + 1;

        if (s_sub_bcid = "101") then
          s_sub_bcid <= "000";
          s_cyc      <= '1';
          s_bcid     <= s_bcid + 1;

          if (s_bcid = x"DEB") then
            s_bcid <= x"000";
            s_bc0  <= '1';
          end if;
        else
          s_bc0 <= '0';
          s_cyc <= '0';
        end if;

      end if;

    end if;
  end process;

  timing_ref_o.bcid     <= std_logic_vector(s_bcid);
  timing_ref_o.sub_bcid <= std_logic_vector(s_sub_bcid);
  timing_ref_o.bc0      <= s_bc0;
  timing_ref_o.cyc      <= s_cyc;

end local_timing_ref_gen_old_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

