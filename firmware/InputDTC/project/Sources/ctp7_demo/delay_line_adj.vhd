-------------------------------------------------------------------------------
--                                                                            
--         Company: CERN, ATLAS                                                       
--         Project: Beam Condition Monitor ROD      
--                                                             
-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: delay_line                                      
--                                                                            
--          Author: Ales Svetek                                                                                                                        
--
--            Date: 2011-04-15                                   
--                                                                            
--         Version: 1.0                                                
--                                                                            
--     Description: Delay Line Circuit. The depth and width of the delay line
--                  can be specified by the generic parameters. The circuit is
--                  coded specifically without the reset signal so that the
--                  synthesiser tool can infer SRL16 macros. These macros can
--                  map up to 16 flip-flops in 1 slice. This reset-less circuit
--                  is used in situations where the power-on or reset sequence
--                  is not critical. The delay line can be "reset" by simply
--                  shifting out 1 full cycle. This limitation is compensated by
--                  the required slice reduction of 1:16.
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
use IEEE.NUMERIC_STD.all;

library work;
use work.ctp7_utils_pkg.all;

--============================================================================
-- Entity declaration
--============================================================================
entity delay_line_adj is
  generic (
    REG_LENGTH : integer := 16;
    DATA_WIDTH : integer := 1
    );
  port (
    clk      : in  std_logic;
    delay    : in  std_logic_vector (log2ceil(REG_LENGTH) - 1 downto 0);
    data_in  : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
    data_out : out std_logic_vector (DATA_WIDTH - 1 downto 0)
    );
end delay_line_adj;

--============================================================================
-- Architecture section
--============================================================================
architecture delay_line_adj_arch of delay_line_adj is

--============================================================================
-- Custom Type declarations
--============================================================================   
  subtype elements is std_logic_vector(DATA_WIDTH-1 downto 0);
  type reg_array is array (REG_LENGTH-1 downto 0) of elements;

--============================================================================
-- Signal declarations
--============================================================================  
  signal delay_tap : integer range 0 to REG_LENGTH-1;

  signal tmp_reg : reg_array;
  
begin
--============================================================================
-- Architecture begin
--============================================================================

  delay_tap <= to_integer(unsigned(delay));

  data_out <= tmp_reg(delay_tap);

  process (clk)
  begin
    if rising_edge(clk) then
      for i in REG_LENGTH-1 downto 1 loop
        tmp_reg(i) <= tmp_reg(i-1);
      end loop;
      tmp_reg(0) <= data_in;
    end if;
  end process;
end delay_line_adj_arch;
--============================================================================
-- Architecture end
--============================================================================

