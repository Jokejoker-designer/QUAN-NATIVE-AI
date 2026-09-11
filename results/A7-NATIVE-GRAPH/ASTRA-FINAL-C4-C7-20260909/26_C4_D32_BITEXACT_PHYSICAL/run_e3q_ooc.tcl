# E3q OOC of S_H hacc product pipeline D32.
# Do not overwrite E3a..E3p n20/dcp.
# PROGRAM=NO. BIT=NO.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set_param general.maxThreads 4

set inci [file join $root rtl/native_graph/integrate]
set mem  [file join $inci a7ng_astra_c4_lm06_d32_fr_v2_mem]
set dut  [file join $inci a7ng_astra_c4_lm06_d32_fr_v2.sv]
set div  [file join $inci a7ng_astra_c4_smres_div_mcycle.sv]
set rq   [file join $inci a7ng_astra_c4_rq_mcycle.sv]

cd $bag
file mkdir [file join $bag mem]
foreach f [glob -directory $mem *.hex] {
  file copy -force $f [file join $bag mem [file tail $f]]
  file copy -force $f [file join $bag [file tail $f]]
}

create_project -in_memory -part $part
set_property include_dirs [list $inci $bag [file join $bag mem]] [current_fileset]
read_verilog -sv $div
read_verilog -sv $rq
read_verilog -sv $dut
puts "E3Q_OOC_START part=$part PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN HACC_PROD_PIPE"
if {[catch {synth_design -mode out_of_context -top a7ng_astra_c4_lm06_d32_fr_v2 -part $part} err]} {
  puts "E3Q_OOC_SYNTH_FAIL $err"
  exit 1
}
if {[llength [get_ports -quiet clk]] > 0} {
  create_clock -period 10.000 -name clk [get_ports clk]
}
write_checkpoint -force [file join $bag d32_ooc_e3q.dcp]
report_timing -delay_type max -max_paths 20 -nworst 1 -sort_by slack \
  -file [file join $bag timing_n20_e3q.rpt]
report_timing_summary -file [file join $bag timing_summary_e3q.rpt]
report_utilization -file [file join $bag util_e3q.rpt]
report_ram_utilization -file [file join $bag ram_e3q.rpt]
puts "E3Q_OOC_DONE PROGRAM=NO C4_MASTER=OPEN"
exit 0
