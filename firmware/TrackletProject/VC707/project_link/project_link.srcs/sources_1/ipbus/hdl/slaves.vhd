-- The ipbus slaves live in this entity - modify according to requirements
--
-- Ports can be added to give ipbus slaves access to the chip top level.
--
-- Dave Newbold, February 2011

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ipbus.ALL;

entity slaves is
	port(
        clk200: in std_logic;
		ipb_clk: in std_logic;
		ipb_rst: in std_logic;
		ipb_in: in ipb_wbus;
		ipb_out: out ipb_rbus;
		rst_out: out std_logic;
		eth_err_ctrl: out std_logic_vector(35 downto 0);
		eth_err_stat: in std_logic_vector(47 downto 0) := X"000000000000";
		pkt_rx: in std_logic := '0';
		pkt_tx: in std_logic := '0';
		en_proc_switch: in std_logic;
		lcd: out std_logic_vector(6 downto 0);
		--sfp
        txn_pphi: out std_logic_vector(1 downto 0);
        txp_pphi: out std_logic_vector(1 downto 0);
        rxn_pphi: in std_logic_vector(1 downto 0);
        rxp_pphi: in std_logic_vector(1 downto 0);
        txn_mphi: out std_logic_vector(1 downto 0);
        txp_mphi: out std_logic_vector(1 downto 0);
        rxn_mphi: in std_logic_vector(1 downto 0);
        rxp_mphi: in std_logic_vector(1 downto 0);
        --gt ref clk
        gt_refclk_p: in std_logic;
        gt_refclk_n: in std_logic;
        --init clk
        init_clk: in std_logic;
        --tvalid signal output for timing measurement
        tx_tvalid_out: out std_logic;
        rx_tvalid_out: out std_logic        
	);

end slaves;

architecture rtl of slaves is

	constant NSLV: positive := 7;
	signal ipbw: ipb_wbus_array(NSLV-1 downto 0);
	signal ipbr, ipbr_d: ipb_rbus_array(NSLV-1 downto 0);
	signal ctrl_reg: std_logic_vector(31 downto 0);
	signal inj_ctrl, inj_stat: std_logic_vector(63 downto 0);

begin

  fabric: entity work.ipbus_fabric
    generic map(NSLV => NSLV)
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      ipb_to_slaves => ipbw,
      ipb_from_slaves => ipbr
    );

-- Slave 0: id / rst reg
	slave0: entity work.ipbus_ctrlreg
		port map(
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(0),
			ipbus_out => ipbr(0),
			d => X"abcdfedc",
			q => ctrl_reg
		);
		
		rst_out <= ctrl_reg(0);

-- Slave 1: register
	slave1: entity work.ipbus_reg
		generic map(addr_width => 0)
		port map(
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(1),
			ipbus_out => ipbr(1),
			q => open
		);
			
-- Slave 2: ethernet error injection
	slave2: entity work.ipbus_ctrlreg
		generic map(
			ctrl_addr_width => 1,
			stat_addr_width => 1
		)
		port map(
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(2),
			ipbus_out => ipbr(2),
			d => inj_stat,
			q => inj_ctrl
		);
		
	eth_err_ctrl <= inj_ctrl(49 downto 32) & inj_ctrl(17 downto 0);
	inj_stat <= X"00" & eth_err_stat(47 downto 24) & X"00" & eth_err_stat(23 downto 0);
	
-- Slave 3: packet counters
	slave3: entity work.ipbus_pkt_ctr
		port map(
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(3),
			ipbus_out => ipbr(3),
			pkt_rx => pkt_rx,
			pkt_tx => pkt_tx
		);

-- Slave 4: 1kword RAM
	slave4: entity work.ipbus_ram
		generic map(addr_width => 10)
		port map(
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(4),
			ipbus_out => ipbr(4)
		);
	
-- Slave 5: peephole RAM
	slave5: entity work.ipbus_peephole_ram
		generic map(addr_width => 10)
		port map(
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(5),
			ipbus_out => ipbr(5)
		);

-- Slave 6: User space
-- The ports for slave #6 are just passed out of this module on their way to the
-- verilog code on the user side of the project.
	slave6: entity work.ipbus_trigger_top
		port map(
		    clk200 => clk200,
			clk => ipb_clk,
			reset => ipb_rst,
			ipbus_in => ipbw(6),
			ipbus_out => ipbr(6),
			en_proc_switch => en_proc_switch,
			lcd => lcd,
			--sfp
            txn_pphi => txn_pphi,
            txp_pphi => txp_pphi,
            rxn_pphi => rxn_pphi,
            rxp_pphi => rxp_pphi,
            txn_mphi => txn_mphi,
            txp_mphi => txp_mphi,
            rxn_mphi => rxn_mphi,
            rxp_mphi => rxp_mphi,
            --gt ref clk
            gt_refclk_p => gt_refclk_p,
            gt_refclk_n => gt_refclk_n,
            --init clk
            init_clk => init_clk,
            --tvalid output signals for timing measurement
            tx_tvalid_out => tx_tvalid_out,
            rx_tvalid_out => rx_tvalid_out
		);

end rtl;
