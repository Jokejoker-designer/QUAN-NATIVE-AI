# D32 FR V2 OOC synth. PROGRAM=NO. BIT=NO. Not C4_MASTER.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set_param general.maxThreads 8

set inci [file join $root rtl/native_graph/integrate]
set mem  [file join $inci a7ng_astra_c4_lm06_d32_fr_v2_mem]
set dut  [file join $inci a7ng_astra_c4_lm06_d32_fr_v2.sv]
set svh  [file join $inci a7ng_astra_c4_lm06_d32_fr_v2.svh]

cd $bag
file mkdir [file join $bag mem]
foreach f [glob -directory $mem *.hex] {
  file copy -force $f [file join $bag mem [file tail $f]]
  file copy -force $f [file join $bag [file tail $f]]
}

create_project -in_memory -part $part
set_property include_dirs [list $inci $bag [file join $bag mem]] [current_fileset]
read_verilog -sv $dut

puts "C4OOC_V2_START part=$part PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN"
if {[catch {synth_design -mode out_of_context -top a7ng_astra_c4_lm06_d32_fr_v2 -part $part} err]} {
  puts "C4OOC_V2_SYNTH_FAIL $err"
  puts "ASTRA_C4_D32_FR_V2_OOC_FAIL"
  exit 1
}
report_utilization -file [file join $bag util_ooc.rpt]
if {[llength [get_ports -quiet clk]] > 0} {
  create_clock -period 10.000 -name clk [get_ports clk]
}
report_timing_summary -file [file join $bag timing_ooc.rpt]
report_ram_utilization -file [file join $bag ram_ooc.rpt]
puts "C4OOC_V2_SYNTH_OK"
puts "ASTRA_C4_D32_FR_V2_OOC_DONE"
puts "C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO"
exit 0
