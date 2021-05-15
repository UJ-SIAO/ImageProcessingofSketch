// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.1 (win64) Build 1538259 Fri Apr  8 15:45:27 MDT 2016
// Date        : Mon Mar 29 16:23:29 2021
// Host        : DESKTOP-AC8B3K3 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Verilog/LennaTest/ImageProcessing/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer_stub.v
// Design      : outputBuffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_0,Vivado 2016.1" *)
module outputBuffer(s_aclk, s_aresetn, s_axis_tvalid, s_axis_tready, s_axis_tdata, m_axis_tvalid, m_axis_tready, m_axis_tdata, axis_prog_full)
/* synthesis syn_black_box black_box_pad_pin="s_aclk,s_aresetn,s_axis_tvalid,s_axis_tready,s_axis_tdata[7:0],m_axis_tvalid,m_axis_tready,m_axis_tdata[7:0],axis_prog_full" */;
  input s_aclk;
  input s_aresetn;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output axis_prog_full;
endmodule
