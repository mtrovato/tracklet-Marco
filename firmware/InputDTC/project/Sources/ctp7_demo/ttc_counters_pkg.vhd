-- Defines the array subtypes for distributed counters
--
-- orbit counter is only 12 bits rather than the CMS standard 24, since
-- it's only used for debugging in this part of the design.
--
-- Dave Newbold, September 2013

  library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ttc_counters_pkg is
  
  type bctr_array is array(natural range <>) of std_logic_vector(11 downto 0);
  type pctr_array is array(natural range <>) of std_logic_vector(2 downto 0);
  type octr_array is array(natural range <>) of std_logic_vector(11 downto 0);
  type ttc_cmd_array is array(natural range <>) of std_logic_vector(3 downto 0);

  constant TTC_DEL         : integer                      := 0;
  constant TTC_BCMD_BC0    : std_logic_vector(3 downto 0) := X"1";
  constant TTC_BCMD_RESYNC : std_logic_vector(3 downto 0) := X"4";
  constant TTC_BCMD_EC0    : std_logic_vector(3 downto 0) := X"7";
  constant TTC_BCMD_OC0    : std_logic_vector(3 downto 0) := X"8";
  constant TTC_BCMD_SYNC   : std_logic_vector(3 downto 0) := X"C";

end ttc_counters_pkg;
