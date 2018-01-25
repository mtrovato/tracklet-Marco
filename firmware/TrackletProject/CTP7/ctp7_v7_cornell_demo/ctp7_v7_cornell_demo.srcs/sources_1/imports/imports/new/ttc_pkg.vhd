
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ttc_pkg is

  type t_timing_ref is record
    bcid     : std_logic_vector(11 downto 0);
    sub_bcid : std_logic_vector(2 downto 0);
    bc0      : std_logic;
    cyc      : std_logic;
  end record;

  type t_bc0_stat is record
  unlocked_cnt : std_logic_vector(15 downto 0);
    udf_cnt      : std_logic_vector(15 downto 0);
    ovf_cnt      : std_logic_vector(15 downto 0);
    locked       : std_logic;
    err          : std_logic;
  end record;

  constant C_TTC_BGO_BC0    : std_logic_vector(3 downto 0) := X"1";
  
  constant C_TTC_BGO_EC0_a    : std_logic_vector(3 downto 0) := X"2";
  constant C_TTC_BGO_EC0_b    : std_logic_vector(3 downto 0) := X"3";

  constant C_TTC_BGO_RESYNC : std_logic_vector(3 downto 0) := X"4";
  constant C_TTC_BGO_OC0    : std_logic_vector(3 downto 0) := X"8";

end ttc_pkg;
