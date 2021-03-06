#
# Vivado (TM) v2016.1 (64-bit)
#
# InputDTC.tcl: Tcl script for re-creating project 'project'
#
# Generated by Vivado on Tue Oct 18 11:43:44 EDT 2016
# IP Build 1537824 on Fri Apr  8 04:28:57 MDT 2016
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# NOTE: In order to use this script for source control purposes, please make sure that the
#       following files are added to the source control system:-
#
# 1. This project restoration tcl script (InputDTC.tcl) that was generated.
#
# 2. The following source(s) files that were local or imported into the original project.
#    (Please see the '$orig_proj_dir' and '$origin_dir' variable setting below at the start of the script)
#
#    <none>
#
# 3. The following remote source files that were added to the original project:-
#
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_10g_rx_startup_fsm.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/rx_capture_buffer_ctrl.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/edge_detect.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ttc_pkg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_10g_single.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ctp7_v1_dtc.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/rx_depad_cdc_align.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/project.srcs/sources_1/imports/Sources/ctp7_demo/delay_line.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/synchronizer.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ttc_cmd.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_10g_tx_startup_fsm.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ttc_decoder.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/rx_capture_pkg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/tx_link_driver.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ctp7_v7_build_cfg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/link_align_pkg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ctp7_utils_pkg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/drp_controller.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/tx_protocol_wrapper.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_register_file.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/register_file.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/tx_pattern_generator.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/rx_capture_buffer.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/local_BX_timing_ref.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_10g_common.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/delay_line_adj.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/link_align_ctrl.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ttc_counters_pkg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_pkg.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/ctp7_ttc_clocks.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_demo/gth_10g_wrapper.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/StubInput.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/Memory.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/ctp7_ttc.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/Track_Sink.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/clock_freq_measure.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/timing_pulse_gen.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/test.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/DTC_input.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/Track_Timer.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/statem.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/Sources/clk_counter.v"
#    "/home/ztao/Documents/firmware/InputDTC/BD/v7_bd.bd"
#    "/home/ztao/Documents/firmware/TrackletProject/CTP7/project/crc_calculator.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/project.srcs/sources_1/imports/Sources/bc0_delays.vhd"
#    "/home/ztao/Documents/firmware/InputDTC/project/project.srcs/sources_1/imports/Sources/pipe_delay.v"
#    "/home/ztao/Documents/firmware/InputDTC/project/IP/rx_cdc_alignment_fifo/rx_cdc_alignment_fifo.xci"
#    "/home/ztao/Documents/firmware/InputDTC/project/IP/capture_ram/capture_ram.xci"
#    "/home/ztao/Documents/firmware/InputDTC/project/IP/ila_tx_pattern_generator/ila_tx_pattern_generator.xci"
#    "/home/ztao/Documents/firmware/InputDTC/project/IP/upclock_link_fifo/upclock_link_fifo.xci"
#    "/home/ztao/Documents/firmware/InputDTC/project/Constraints/constraints.xdc"
#    "/home/ztao/Documents/firmware/InputDTC/project/Constraints/debug.xdc"
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "InputDTC.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/project"]"

# Create project
create_project project ./project -part xc7vx690tffg1927-2 -force

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [get_projects project]
set_property "default_lib" "xil_defaultlib" $obj
set_property "part" "xc7vx690tffg1927-2" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "source_mgmt_mode" "DisplayOnly" $obj
set_property "target_language" "VHDL" $obj
set_property "xpm_libraries" "XPM_CDC XPM_MEMORY" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_10g_rx_startup_fsm.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/rx_capture_buffer_ctrl.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/edge_detect.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ttc_pkg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_10g_single.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ctp7_v1_dtc.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/rx_depad_cdc_align.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/delay_line.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/synchronizer.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ttc_cmd.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_10g_tx_startup_fsm.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ttc_decoder.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/rx_capture_pkg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/tx_link_driver.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ctp7_v7_build_cfg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/link_align_pkg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ctp7_utils_pkg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/drp_controller.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/tx_protocol_wrapper.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_register_file.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/register_file.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/tx_pattern_generator.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/rx_capture_buffer.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/local_BX_timing_ref.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_10g_common.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/delay_line_adj.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/link_align_ctrl.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ttc_counters_pkg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_pkg.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/ctp7_ttc_clocks.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_demo/gth_10g_wrapper.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/StubInput.v"]"\
 "[file normalize "$origin_dir/project/Sources/Memory.v"]"\
 "[file normalize "$origin_dir/project/Sources/ctp7_ttc.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/Track_Sink.v"]"\
 "[file normalize "$origin_dir/project/Sources/clock_freq_measure.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/timing_pulse_gen.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/test.v"]"\
 "[file normalize "$origin_dir/project/Sources/DTC_input.v"]"\
 "[file normalize "$origin_dir/project/Sources/Track_Timer.v"]"\
 "[file normalize "$origin_dir/project/Sources/statem.v"]"\
 "[file normalize "$origin_dir/project/Sources/clk_counter.v"]"\
 "[file normalize "$origin_dir/BD/v7_bd.bd"]"\
 "[file normalize "$origin_dir/../TrackletProject/CTP7/project/crc_calculator.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/bc0_delays.vhd"]"\
 "[file normalize "$origin_dir/project/Sources/pipe_delay.v"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/project/Sources/ctp7_demo/gth_10g_rx_startup_fsm.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/rx_capture_buffer_ctrl.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/edge_detect.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ttc_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/gth_10g_single.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ctp7_v1_dtc.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/rx_depad_cdc_align.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/delay_line.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/synchronizer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ttc_cmd.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/gth_10g_tx_startup_fsm.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ttc_decoder.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/rx_capture_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/tx_link_driver.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ctp7_v7_build_cfg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/link_align_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ctp7_utils_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/drp_controller.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/tx_protocol_wrapper.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/gth_register_file.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/register_file.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/tx_pattern_generator.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/rx_capture_buffer.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/local_BX_timing_ref.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/gth_10g_common.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/delay_line_adj.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/link_align_ctrl.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ttc_counters_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/gth_pkg.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/ctp7_ttc_clocks.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_demo/gth_10g_wrapper.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/ctp7_ttc.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/clock_freq_measure.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/timing_pulse_gen.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/BD/v7_bd.bd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "0" $file_obj
}

set file "$origin_dir/../TrackletProject/CTP7/project/crc_calculator.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

set file "$origin_dir/project/Sources/bc0_delays.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "ctp7_v1_dtc" $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/project/IP/rx_cdc_alignment_fifo/rx_cdc_alignment_fifo.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/project/IP/capture_ram/capture_ram.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/project/IP/ila_tx_pattern_generator/ila_tx_pattern_generator.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/project/IP/upclock_link_fifo/upclock_link_fifo.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
# None

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project/Constraints/constraints.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/project/Constraints/constraints.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project/Constraints/debug.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/project/Constraints/debug.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "transport_int_delay" "0" $obj
set_property "transport_path_delay" "0" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.unifast" "" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7vx690tffg1927-2 -flow {Vivado Synthesis 2016} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2016" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property "part" "xc7vx690tffg1927-2" $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7vx690tffg1927-2 -flow {Vivado Implementation 2016} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2016" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "part" "xc7vx690tffg1927-2" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:project"
