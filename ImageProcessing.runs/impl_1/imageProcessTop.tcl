proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir D:/Verilog/ImageProcessingofSketch/ImageProcessing.cache/wt [current_project]
  set_property parent.project_path D:/Verilog/ImageProcessingofSketch/ImageProcessing.xpr [current_project]
  set_property ip_repo_paths {
  d:/Verilog/ImageProcessingofSketch/ImageProcessing.cache/ip
  D:/Verilog/ImageProcessingofSketch
  D:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1
  D:/Verilog/ImageProcessingofSketch/ImageProcessing.sim/sim_1/behav/Xilinx/vivado-library-master
} [current_project]
  set_property ip_output_repo d:/Verilog/ImageProcessingofSketch/ImageProcessing.cache/ip [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet D:/Verilog/ImageProcessingofSketch/ImageProcessing.runs/synth_1/imageProcessTop.dcp
  add_files -quiet d:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer.dcp
  set_property netlist_only true [get_files d:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer.dcp]
  read_xdc -mode out_of_context -ref outputBuffer -cells U0 d:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer_ooc.xdc
  set_property processing_order EARLY [get_files d:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer_ooc.xdc]
  read_xdc -ref outputBuffer -cells U0 d:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer/outputBuffer.xdc
  set_property processing_order EARLY [get_files d:/Verilog/ImageProcessingofSketch/ImageProcessing.srcs/sources_1/ip/outputBuffer/outputBuffer/outputBuffer.xdc]
  link_design -top imageProcessTop -part xc7z020clg484-1
  write_hwdef -file imageProcessTop.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force imageProcessTop_opt.dcp
  report_drc -file imageProcessTop_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force imageProcessTop_placed.dcp
  report_io -file imageProcessTop_io_placed.rpt
  report_utilization -file imageProcessTop_utilization_placed.rpt -pb imageProcessTop_utilization_placed.pb
  report_control_sets -verbose -file imageProcessTop_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force imageProcessTop_routed.dcp
  report_drc -file imageProcessTop_drc_routed.rpt -pb imageProcessTop_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file imageProcessTop_timing_summary_routed.rpt -rpx imageProcessTop_timing_summary_routed.rpx
  report_power -file imageProcessTop_power_routed.rpt -pb imageProcessTop_power_summary_routed.pb -rpx imageProcessTop_power_routed.rpx
  report_route_status -file imageProcessTop_route_status.rpt -pb imageProcessTop_route_status.pb
  report_clock_utilization -file imageProcessTop_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

