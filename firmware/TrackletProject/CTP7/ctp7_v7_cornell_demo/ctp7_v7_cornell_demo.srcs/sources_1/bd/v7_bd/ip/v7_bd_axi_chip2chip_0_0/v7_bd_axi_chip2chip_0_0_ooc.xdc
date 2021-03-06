# This XDC is used only for OOC mode of synthesis, implementation
# User should update the correct clock period before proceeding further
create_clock -name m_aclk -period 10 -waveform {0 5} [get_ports m_aclk]
set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports m_aclk]
create_clock -name m_axi_lite_aclk -period 20 -waveform {0 10} [get_ports m_axi_lite_aclk]
set_property HD.CLK_SRC BUFGCTRL_X0Y2 [get_ports m_axi_lite_aclk]
create_clock -name axi_c2c_selio_rx_clk_in -period 5.000 -waveform {0  2.500} [get_ports axi_c2c_selio_rx_clk_in]
create_clock -name idelay_ref_clk -period 5 [get_ports idelay_ref_clk]
set_property HD.CLK_SRC BUFGCTRL_X0Y3 [get_ports idelay_ref_clk]
