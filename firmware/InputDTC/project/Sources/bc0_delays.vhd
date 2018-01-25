library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.ctp7_utils_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity bc0_delays is
  port (
    clk_proc : in std_logic;
    bc0_i : in std_logic;
    bcid_i : in std_logic_vector(11 downto 0);
    bc0_delay_ctrl_1 : in std_logic_vector(15 downto 0);
    bc0_delay_ctrl_2 : in std_logic_vector(15 downto 0);
    bc0_delay_ctrl_3 : in std_logic_vector(15 downto 0);
    bc0_delay_ctrl_4 : in std_logic_vector(15 downto 0);
    bc0_out1 : out std_logic;
    bc0_out2 : out std_logic;
    bc0_out3 : out std_logic;
    bc0_out4 : out std_logic;
    bcid_out1 : out std_logic_vector(11 downto 0);
    bcid_out2 : out std_logic_vector(11 downto 0);
    bcid_out3 : out std_logic_vector(11 downto 0);
    bcid_out4 : out std_logic_vector(11 downto 0)
    );
end bc0_delays;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture bc0_delays_arch of bc0_delays is

    signal count1 : unsigned(15 downto 0);
    signal count2 : unsigned(15 downto 0);
    signal count3 : unsigned(15 downto 0);
    signal count4 : unsigned(15 downto 0);

begin

    process(clk_proc) is
    begin
        if rising_edge(clk_proc) then
            if (bc0_i = '1') then
                count1 <= x"0000";
                count2 <= x"0000";
                count3 <= x"0000";
                count4 <= x"0000";
            else
                if (count1 > unsigned(bc0_delay_ctrl_1)) then
                    count1 <= count1;
                else
                    count1 <= count1 + 1;
                end if;
                
                if (count2 > unsigned(bc0_delay_ctrl_2)) then
                    count2 <= count2;
                else
                    count2 <= count2 + 1;
                end if;

                if (count3 > unsigned(bc0_delay_ctrl_3)) then
                    count3 <= count3;
                else
                    count3 <= count3 + 1;
                end if;
                
                if (count4 > unsigned(bc0_delay_ctrl_4)) then
                    count4 <= count4;
                else
                    count4 <= count4 + 1;
                end if;
                
            end if;
        end if;
    end process;

    bc0_out1 <= '1' when (count1 = unsigned(bc0_delay_ctrl_1)) else '0';
    bc0_out2 <= '1' when (count2 = unsigned(bc0_delay_ctrl_2)) else '0';
    bc0_out3 <= '1' when (count3 = unsigned(bc0_delay_ctrl_3)) else '0';
    bc0_out4 <= '1' when (count4 = unsigned(bc0_delay_ctrl_4)) else '0';
    
    -- pass bcid through without delay for now
    bcid_out1 <= bcid_i;
    bcid_out2 <= bcid_i;
    bcid_out3 <= bcid_i;
    bcid_out4 <= bcid_i;
    

--  i_bc0_1_delay_line : delay_line
--    generic map (
--      G_DELAY      => G_DELAY_1,
--      G_DATA_WIDTH => G_DATA_WIDTH_1,
--      G_SRL_STYLE  => "register"
--      )
--    port map (
--      clk      => clk_proc,
--      data_in(0)  => bc0_i,
--      data_out(0) => bc0_out1
--      );

end bc0_delays_arch;

--============================================================================
--                                                            Architecture end
--============================================================================