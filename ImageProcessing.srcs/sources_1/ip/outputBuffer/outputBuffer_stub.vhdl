-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.1 (win64) Build 1538259 Fri Apr  8 15:45:27 MDT 2016
-- Date        : Mon Mar 29 16:23:29 2021
-- Host        : DESKTOP-AC8B3K3 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/Verilog/LennaTest/ImageProcessing/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer_stub.vhdl
-- Design      : outputBuffer
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity outputBuffer is
  Port ( 
    s_aclk : in STD_LOGIC;
    s_aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    axis_prog_full : out STD_LOGIC
  );

end outputBuffer;

architecture stub of outputBuffer is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "s_aclk,s_aresetn,s_axis_tvalid,s_axis_tready,s_axis_tdata[7:0],m_axis_tvalid,m_axis_tready,m_axis_tdata[7:0],axis_prog_full";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_1_0,Vivado 2016.1";
begin
end;
