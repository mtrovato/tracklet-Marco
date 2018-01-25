--Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2014.4 (lin64) Build 1071353 Tue Nov 18 16:47:07 MST 2014
--Date        : Tue Jul 14 15:10:57 2015
--Host        : moonraker.cern.ch running 64-bit Scientific Linux CERN SLC release 6.6 (Carbon)
--Command     : generate_target v7_bd_wrapper.bd
--Design      : v7_bd_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity v7_bd_wrapper is
  port (
    BRAM_CTRL_CAP_RAM_0_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_CAP_RAM_0_clk : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_0_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_0_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_0_en : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_0_rst : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_0_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_CAP_RAM_1_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_CAP_RAM_1_clk : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_1_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_1_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_1_en : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_1_rst : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_1_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_DRP_addr : out STD_LOGIC_VECTOR ( 15 downto 0 );
    BRAM_CTRL_DRP_clk : out STD_LOGIC;
    BRAM_CTRL_DRP_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_DRP_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_DRP_en : out STD_LOGIC;
    BRAM_CTRL_DRP_rst : out STD_LOGIC;
    BRAM_CTRL_DRP_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_clk : out STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_en : out STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_rst : out STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_REG_FILE_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_REG_FILE_clk : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_REG_FILE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_REG_FILE_en : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_rst : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_c2c_v7_to_zynq_clk : out STD_LOGIC;
    axi_c2c_v7_to_zynq_data : out STD_LOGIC_VECTOR ( 14 downto 0 );
    axi_c2c_v7_to_zynq_link_status : out STD_LOGIC;
    axi_c2c_zynq_to_v7_clk : in STD_LOGIC;
    axi_c2c_zynq_to_v7_data : in STD_LOGIC_VECTOR ( 14 downto 0 );
    axi_c2c_zynq_to_v7_reset : in STD_LOGIC;
    clk_200_diff_in_clk_n : in STD_LOGIC;
    clk_200_diff_in_clk_p : in STD_LOGIC;
    clk_out1_200mhz : out STD_LOGIC;
    clk_out2_100mhz : out STD_LOGIC;
    clk_out3_50mhz : out STD_LOGIC
  );
end v7_bd_wrapper;

architecture STRUCTURE of v7_bd_wrapper is
  component v7_bd is
  port (
    BRAM_CTRL_CAP_RAM_0_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_CAP_RAM_0_clk : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_0_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_0_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_0_en : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_0_rst : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_0_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_CAP_RAM_1_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_CAP_RAM_1_clk : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_1_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_1_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_CAP_RAM_1_en : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_1_rst : out STD_LOGIC;
    BRAM_CTRL_CAP_RAM_1_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_DRP_addr : out STD_LOGIC_VECTOR ( 15 downto 0 );
    BRAM_CTRL_DRP_clk : out STD_LOGIC;
    BRAM_CTRL_DRP_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_DRP_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_DRP_en : out STD_LOGIC;
    BRAM_CTRL_DRP_rst : out STD_LOGIC;
    BRAM_CTRL_DRP_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BRAM_CTRL_REG_FILE_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_REG_FILE_clk : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_REG_FILE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_REG_FILE_en : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_rst : out STD_LOGIC;
    BRAM_CTRL_REG_FILE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clk_200_diff_in_clk_n : in STD_LOGIC;
    clk_200_diff_in_clk_p : in STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_addr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_clk : out STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_din : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_dout : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_CTRL_GTH_REG_FILE_en : out STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_rst : out STD_LOGIC;
    BRAM_CTRL_GTH_REG_FILE_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_c2c_zynq_to_v7_clk : in STD_LOGIC;
    axi_c2c_zynq_to_v7_data : in STD_LOGIC_VECTOR ( 14 downto 0 );
    axi_c2c_v7_to_zynq_link_status : out STD_LOGIC;
    axi_c2c_v7_to_zynq_clk : out STD_LOGIC;
    axi_c2c_v7_to_zynq_data : out STD_LOGIC_VECTOR ( 14 downto 0 );
    clk_out1_200mhz : out STD_LOGIC;
    clk_out2_100mhz : out STD_LOGIC;
    clk_out3_50mhz : out STD_LOGIC;
    axi_c2c_zynq_to_v7_reset : in STD_LOGIC
  );
  end component v7_bd;
begin
v7_bd_i: component v7_bd
    port map (
      BRAM_CTRL_CAP_RAM_0_addr(16 downto 0) => BRAM_CTRL_CAP_RAM_0_addr(16 downto 0),
      BRAM_CTRL_CAP_RAM_0_clk => BRAM_CTRL_CAP_RAM_0_clk,
      BRAM_CTRL_CAP_RAM_0_din(31 downto 0) => BRAM_CTRL_CAP_RAM_0_din(31 downto 0),
      BRAM_CTRL_CAP_RAM_0_dout(31 downto 0) => BRAM_CTRL_CAP_RAM_0_dout(31 downto 0),
      BRAM_CTRL_CAP_RAM_0_en => BRAM_CTRL_CAP_RAM_0_en,
      BRAM_CTRL_CAP_RAM_0_rst => BRAM_CTRL_CAP_RAM_0_rst,
      BRAM_CTRL_CAP_RAM_0_we(3 downto 0) => BRAM_CTRL_CAP_RAM_0_we(3 downto 0),
      BRAM_CTRL_CAP_RAM_1_addr(16 downto 0) => BRAM_CTRL_CAP_RAM_1_addr(16 downto 0),
      BRAM_CTRL_CAP_RAM_1_clk => BRAM_CTRL_CAP_RAM_1_clk,
      BRAM_CTRL_CAP_RAM_1_din(31 downto 0) => BRAM_CTRL_CAP_RAM_1_din(31 downto 0),
      BRAM_CTRL_CAP_RAM_1_dout(31 downto 0) => BRAM_CTRL_CAP_RAM_1_dout(31 downto 0),
      BRAM_CTRL_CAP_RAM_1_en => BRAM_CTRL_CAP_RAM_1_en,
      BRAM_CTRL_CAP_RAM_1_rst => BRAM_CTRL_CAP_RAM_1_rst,
      BRAM_CTRL_CAP_RAM_1_we(3 downto 0) => BRAM_CTRL_CAP_RAM_1_we(3 downto 0),
      BRAM_CTRL_DRP_addr(15 downto 0) => BRAM_CTRL_DRP_addr(15 downto 0),
      BRAM_CTRL_DRP_clk => BRAM_CTRL_DRP_clk,
      BRAM_CTRL_DRP_din(31 downto 0) => BRAM_CTRL_DRP_din(31 downto 0),
      BRAM_CTRL_DRP_dout(31 downto 0) => BRAM_CTRL_DRP_dout(31 downto 0),
      BRAM_CTRL_DRP_en => BRAM_CTRL_DRP_en,
      BRAM_CTRL_DRP_rst => BRAM_CTRL_DRP_rst,
      BRAM_CTRL_DRP_we(3 downto 0) => BRAM_CTRL_DRP_we(3 downto 0),
      BRAM_CTRL_GTH_REG_FILE_addr(16 downto 0) => BRAM_CTRL_GTH_REG_FILE_addr(16 downto 0),
      BRAM_CTRL_GTH_REG_FILE_clk => BRAM_CTRL_GTH_REG_FILE_clk,
      BRAM_CTRL_GTH_REG_FILE_din(31 downto 0) => BRAM_CTRL_GTH_REG_FILE_din(31 downto 0),
      BRAM_CTRL_GTH_REG_FILE_dout(31 downto 0) => BRAM_CTRL_GTH_REG_FILE_dout(31 downto 0),
      BRAM_CTRL_GTH_REG_FILE_en => BRAM_CTRL_GTH_REG_FILE_en,
      BRAM_CTRL_GTH_REG_FILE_rst => BRAM_CTRL_GTH_REG_FILE_rst,
      BRAM_CTRL_GTH_REG_FILE_we(3 downto 0) => BRAM_CTRL_GTH_REG_FILE_we(3 downto 0),
      BRAM_CTRL_REG_FILE_addr(16 downto 0) => BRAM_CTRL_REG_FILE_addr(16 downto 0),
      BRAM_CTRL_REG_FILE_clk => BRAM_CTRL_REG_FILE_clk,
      BRAM_CTRL_REG_FILE_din(31 downto 0) => BRAM_CTRL_REG_FILE_din(31 downto 0),
      BRAM_CTRL_REG_FILE_dout(31 downto 0) => BRAM_CTRL_REG_FILE_dout(31 downto 0),
      BRAM_CTRL_REG_FILE_en => BRAM_CTRL_REG_FILE_en,
      BRAM_CTRL_REG_FILE_rst => BRAM_CTRL_REG_FILE_rst,
      BRAM_CTRL_REG_FILE_we(3 downto 0) => BRAM_CTRL_REG_FILE_we(3 downto 0),
      axi_c2c_v7_to_zynq_clk => axi_c2c_v7_to_zynq_clk,
      axi_c2c_v7_to_zynq_data(14 downto 0) => axi_c2c_v7_to_zynq_data(14 downto 0),
      axi_c2c_v7_to_zynq_link_status => axi_c2c_v7_to_zynq_link_status,
      axi_c2c_zynq_to_v7_clk => axi_c2c_zynq_to_v7_clk,
      axi_c2c_zynq_to_v7_data(14 downto 0) => axi_c2c_zynq_to_v7_data(14 downto 0),
      axi_c2c_zynq_to_v7_reset => axi_c2c_zynq_to_v7_reset,
      clk_200_diff_in_clk_n => clk_200_diff_in_clk_n,
      clk_200_diff_in_clk_p => clk_200_diff_in_clk_p,
      clk_out1_200mhz => clk_out1_200mhz,
      clk_out2_100mhz => clk_out2_100mhz,
      clk_out3_50mhz => clk_out3_50mhz
    );
end STRUCTURE;
