#---------------
set_property PACKAGE_PIN H29 [get_ports clk_200_diff_in_clk_n]

set_property IOSTANDARD LVDS [get_ports clk_200_diff_in_clk_p]
set_property IOSTANDARD LVDS [get_ports clk_200_diff_in_clk_n]

create_clock -period 5.000 -name clk_200_diff_in_clk_p [get_ports clk_200_diff_in_clk_p]

#---------------
#green LED (PCB)
set_property PACKAGE_PIN A20 [get_ports {LEDs[0]}]
#orange
set_property PACKAGE_PIN B20 [get_ports {LEDs[1]}]

set_property IOSTANDARD LVCMOS18 [get_ports {LEDs[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LEDs[1]}]


set_property PACKAGE_PIN H19 [get_ports LED_GREEN_o]
set_property IOSTANDARD LVCMOS18 [get_ports LED_GREEN_o]

set_property PACKAGE_PIN D20 [get_ports LED_RED_o]
set_property IOSTANDARD LVCMOS18 [get_ports LED_RED_o]

set_property PACKAGE_PIN C20 [get_ports LED_BLUE_o]
set_property IOSTANDARD LVCMOS18 [get_ports LED_BLUE_o]


# ==========================================================================

## TTC Backplane Signals: Clock and Command

create_clock -period 25.000 -name clk_40_ttc_p_i -waveform {0.000 12.500} [get_ports clk_40_ttc_p_i]



set_property PACKAGE_PIN AV30 [get_ports clk_40_ttc_n_i]

set_property IOSTANDARD LVDS [get_ports clk_40_ttc_p_i]
set_property IOSTANDARD LVDS [get_ports clk_40_ttc_n_i]

#create_clock -period 24.950 -name clk_40_ttc_p_i [get_ports clk_40_ttc_p_i]

set_property PACKAGE_PIN J26 [get_ports ttc_data_n_i]

set_property IOSTANDARD LVDS [get_ports ttc_data_p_i]




# ==========================================================================
# AXI Chip2Chip

set_property INTERNAL_VREF 0.9 [get_iobanks 16]


# AXI Chip2Chip - RX section
set_property PACKAGE_PIN BD31 [get_ports axi_c2c_v7_to_zynq_clk]
set_property PACKAGE_PIN AY32 [get_ports {axi_c2c_v7_to_zynq_data[0]}]
set_property PACKAGE_PIN BA33 [get_ports {axi_c2c_v7_to_zynq_data[1]}]
set_property PACKAGE_PIN AR31 [get_ports {axi_c2c_v7_to_zynq_data[2]}]
set_property PACKAGE_PIN AR32 [get_ports {axi_c2c_v7_to_zynq_data[3]}]
set_property PACKAGE_PIN AV32 [get_ports {axi_c2c_v7_to_zynq_data[4]}]
set_property PACKAGE_PIN AW32 [get_ports {axi_c2c_v7_to_zynq_data[5]}]
set_property PACKAGE_PIN AJ30 [get_ports {axi_c2c_v7_to_zynq_data[6]}]
set_property PACKAGE_PIN AJ31 [get_ports {axi_c2c_v7_to_zynq_data[7]}]
set_property PACKAGE_PIN AM32 [get_ports {axi_c2c_v7_to_zynq_data[8]}]
set_property PACKAGE_PIN AM33 [get_ports {axi_c2c_v7_to_zynq_data[9]}]
set_property PACKAGE_PIN BB33 [get_ports {axi_c2c_v7_to_zynq_data[10]}]
set_property PACKAGE_PIN AV33 [get_ports {axi_c2c_v7_to_zynq_data[11]}]
set_property PACKAGE_PIN AP32 [get_ports {axi_c2c_v7_to_zynq_data[12]}]
set_property PACKAGE_PIN AN32 [get_ports {axi_c2c_v7_to_zynq_data[13]}]
set_property PACKAGE_PIN BC34 [get_ports {axi_c2c_v7_to_zynq_data[14]}]

set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_v7_to_zynq_clk]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[0]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[1]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[2]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[3]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[4]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[5]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[6]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[7]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[8]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[9]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[10]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[11]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[12]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[13]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[14]}]

# AXI Chip2Chip - TX section
set_property PACKAGE_PIN AU33 [get_ports axi_c2c_zynq_to_v7_clk]
set_property PACKAGE_PIN AV34 [get_ports {axi_c2c_zynq_to_v7_data[0]}]
set_property PACKAGE_PIN AV35 [get_ports {axi_c2c_zynq_to_v7_data[1]}]
set_property PACKAGE_PIN AW34 [get_ports {axi_c2c_zynq_to_v7_data[2]}]
set_property PACKAGE_PIN AW35 [get_ports {axi_c2c_zynq_to_v7_data[3]}]
set_property PACKAGE_PIN AY33 [get_ports {axi_c2c_zynq_to_v7_data[4]}]
set_property PACKAGE_PIN AY34 [get_ports {axi_c2c_zynq_to_v7_data[5]}]
set_property PACKAGE_PIN BA34 [get_ports {axi_c2c_zynq_to_v7_data[6]}]
set_property PACKAGE_PIN BA35 [get_ports {axi_c2c_zynq_to_v7_data[7]}]
set_property PACKAGE_PIN BD34 [get_ports {axi_c2c_zynq_to_v7_data[8]}]
set_property PACKAGE_PIN BD35 [get_ports {axi_c2c_zynq_to_v7_data[9]}]
set_property PACKAGE_PIN BB35 [get_ports {axi_c2c_zynq_to_v7_data[10]}]
set_property PACKAGE_PIN BC35 [get_ports {axi_c2c_zynq_to_v7_data[11]}]
set_property PACKAGE_PIN BC32 [get_ports {axi_c2c_zynq_to_v7_data[12]}]
set_property PACKAGE_PIN BC33 [get_ports {axi_c2c_zynq_to_v7_data[13]}]
set_property PACKAGE_PIN BD32 [get_ports {axi_c2c_zynq_to_v7_data[14]}]

set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_zynq_to_v7_clk]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[0]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[1]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[2]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[3]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[4]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[5]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[6]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[7]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[8]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[9]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[10]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[11]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[12]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[13]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[14]}]


# AXI Chip2Chip - Status/Control section
set_property PACKAGE_PIN BB31 [get_ports axi_c2c_zynq_to_v7_reset]
set_property PACKAGE_PIN BB32 [get_ports axi_c2c_v7_to_zynq_link_status]

set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_zynq_to_v7_reset]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_v7_to_zynq_link_status]
# ==========================================================================


create_clock -period 5.000 -name axi_c2c_zynq_to_v7_clk [get_ports axi_c2c_zynq_to_v7_clk]
create_generated_clock -name axi_c2c_v7_to_zynq_clk -source [get_pins i_v7_bd/axi_chip2chip_0/inst/slave_fpga_gen.axi_chip2chip_slave_phy_inst/slave_sio_phy.axi_chip2chip_sio_output_inst/gen_oddr.oddr_clk_out_inst/C] -divide_by 1 [get_ports axi_c2c_v7_to_zynq_clk]



####################### GT reference clock constraints #########################

create_clock -period 6.250 [get_ports {refclk_F_0_p_i[0]}]
create_clock -period 6.250 [get_ports {refclk_F_0_p_i[1]}]
create_clock -period 6.250 [get_ports {refclk_F_0_p_i[2]}]
create_clock -period 6.250 [get_ports {refclk_F_0_p_i[3]}]

create_clock -period 4.000 [get_ports {refclk_F_1_p_i[0]}]
create_clock -period 4.000 [get_ports {refclk_F_1_p_i[1]}]
create_clock -period 4.000 [get_ports {refclk_F_1_p_i[2]}]
create_clock -period 4.000 [get_ports {refclk_F_1_p_i[3]}]

create_clock -period 6.250 [get_ports {refclk_B_0_p_i[0]}]
create_clock -period 6.250 [get_ports {refclk_B_0_p_i[1]}]
create_clock -period 6.250 [get_ports {refclk_B_0_p_i[2]}]
create_clock -period 6.250 [get_ports {refclk_B_0_p_i[3]}]

create_clock -period 4.000 [get_ports {refclk_B_1_p_i[0]}]
create_clock -period 4.000 [get_ports {refclk_B_1_p_i[1]}]
create_clock -period 4.000 [get_ports {refclk_B_1_p_i[2]}]
create_clock -period 4.000 [get_ports {refclk_B_1_p_i[3]}]

################################ RefClk Location constraints #####################

set_property PACKAGE_PIN E10 [get_ports {refclk_F_0_p_i[0]}]
set_property PACKAGE_PIN N10 [get_ports {refclk_F_0_p_i[1]}]
set_property PACKAGE_PIN AF8 [get_ports {refclk_F_0_p_i[2]}]
set_property PACKAGE_PIN AR10 [get_ports {refclk_F_0_p_i[3]}]

set_property PACKAGE_PIN G10 [get_ports {refclk_F_1_p_i[0]}]
set_property PACKAGE_PIN R10 [get_ports {refclk_F_1_p_i[1]}]
set_property PACKAGE_PIN AH8 [get_ports {refclk_F_1_p_i[2]}]
set_property PACKAGE_PIN AT8 [get_ports {refclk_F_1_p_i[3]}]

set_property PACKAGE_PIN AR35 [get_ports {refclk_B_0_p_i[0]}]
set_property PACKAGE_PIN AF37 [get_ports {refclk_B_0_p_i[1]}]
set_property PACKAGE_PIN N35 [get_ports {refclk_B_0_p_i[2]}]
set_property PACKAGE_PIN E35 [get_ports {refclk_B_0_p_i[3]}]

set_property PACKAGE_PIN AT37 [get_ports {refclk_B_1_p_i[0]}]
set_property PACKAGE_PIN AH37 [get_ports {refclk_B_1_p_i[1]}]
set_property PACKAGE_PIN R35 [get_ports {refclk_B_1_p_i[2]}]
set_property PACKAGE_PIN G35 [get_ports {refclk_B_1_p_i[3]}]

set_property LOC GTHE2_CHANNEL_X1Y0 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y1 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[1].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y2 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[2].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y3 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[3].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y4 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[4].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y5 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[5].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y6 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[6].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y7 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[7].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y8 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[8].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y9 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[9].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y10 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[10].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y11 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[11].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y12 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[12].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y13 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[13].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y14 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[14].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y15 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[15].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y16 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[16].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y17 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[17].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y18 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[18].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y19 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[19].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y20 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[20].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y21 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[21].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y22 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[22].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y23 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[23].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y24 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[24].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y25 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[25].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y26 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[26].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y27 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[27].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y28 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[28].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y29 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[29].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y30 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[30].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y31 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[31].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y32 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[32].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y33 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[33].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y34 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[34].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y35 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[35].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y36 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[36].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y37 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[37].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y38 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[38].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y39 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[39].i_gth_10gbps_buf_cc_gt/i_gthe2}]

set_property LOC GTHE2_CHANNEL_X0Y39 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[40].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y38 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[41].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y37 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[42].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y36 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[43].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y35 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[44].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y34 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[45].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y33 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[46].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y32 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[47].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y31 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[48].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y30 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[49].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y29 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[50].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y28 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[51].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y27 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[52].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y26 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[53].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y25 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[54].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y24 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[55].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y23 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[56].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y22 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[57].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y21 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[58].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y20 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[59].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y19 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[60].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y18 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[61].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y17 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[62].i_gth_10gbps_buf_cc_gt/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X0Y16 [get_cells {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[63].i_gth_10gbps_buf_cc_gt/i_gthe2}]


create_clock -period 4.000 -name {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I} -waveform {0.000 2.000} [get_pins {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/i_gthe2/TXOUTCLK}]


set_property LOC XADC_X0Y0 [get_cells i_v7_bd/xadc_wiz_0/U0/AXI_XADC_CORE_I/XADC_INST]



set_property LOC MMCME2_ADV_X0Y6 [get_cells i_v7_bd/axi_chip2chip_0/inst/slave_fpga_gen.axi_chip2chip_slave_phy_inst/slave_sio_phy.axi_chip2chip_sio_input_inst/axi_chip2chip_clk_gen_inst/mmcm_adv_inst]
set_switching_activity -static_probability 0.667 [get_cells i_v7_bd/axi_chip2chip_0/inst/slave_fpga_gen.axi_chip2chip_slave_phy_inst/slave_sio_phy.axi_chip2chip_sio_input_inst/axi_chip2chip_clk_gen_inst/mmcm_adv_inst]


set_false_path -from [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}] -to [get_clocks clk_out3_v7_bd_clk_wiz_0_0]
set_false_path -from [get_clocks clk_out3_v7_bd_clk_wiz_0_0] -to [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}]


set_false_path -from [get_clocks s_clk_240] -to [get_clocks clk_out3_v7_bd_clk_wiz_0_0]
set_false_path -from [get_clocks s_clk_40] -to [get_clocks clk_out3_v7_bd_clk_wiz_0_0]
set_false_path -from [get_clocks clk_out3_v7_bd_clk_wiz_0_0] -to [get_clocks s_clk_240]
set_false_path -from [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}] -to [get_clocks s_clk_240]
set_false_path -from [get_clocks clk_out3_v7_bd_clk_wiz_0_0] -to [get_clocks s_clk_40]
set_false_path -from [get_clocks s_clk_240] -to [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}]

#MT trying to have s_clk_new appear in the timing analysis
set_false_path -from [get_clocks s_clk_240] -to [get_clocks s_clk_new]
set_false_path -from [get_clocks s_clk_new] -to [get_clocks s_clk_40]

#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_250_i]



#set_false_path -from [get_clocks clk_out4_v7_bd_clk_wiz_0_0] -to [get_clocks clk_out3_v7_bd_clk_wiz_0_0]
#set_false_path -from [get_clocks clk_out3_v7_bd_clk_wiz_0_0] -to [get_clocks clk_out4_v7_bd_clk_wiz_0_0]

#set_false_path -from [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}] -to [get_clocks clk_out3_v7_bd_clk_wiz_0_0]
#set_false_path -from [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}] -to [get_clocks clk_out4_v7_bd_clk_wiz_0_0]

#set_false_path -from [get_clocks clk_out3_v7_bd_clk_wiz_0_0] -to [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}]
#set_false_path -from [get_clocks clk_out4_v7_bd_clk_wiz_0_0] -to [get_clocks {i_gth_wrapper/gen_gth_10gbps_buf_cc_gt[0].i_gth_10gbps_buf_cc_gt/I}]
