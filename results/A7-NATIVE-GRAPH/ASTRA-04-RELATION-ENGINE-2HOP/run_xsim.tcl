# ASTRA-04 2-hop unit XSim. PROGRAM=NO.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set xvlog_bin [file normalize {C:/2026.1/Vivado/bin/xvlog.bat}]
set xelab_bin [file normalize {C:/2026.1/Vivado/bin/xelab.bat}]
set xsim_bin  [file normalize {C:/2026.1/Vivado/bin/xsim.bat}]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set work [file join $bag xsim_work]
file mkdir $work
cd $work
set rtl [file join $root rtl/native_graph/integrate/a7ng_rel_engine_2hop.sv]
set tb  [file join $bag tb_astra04_2hop.sv]
set xvlog_log [file join $bag xvlog.log]
if {[catch {exec $xvlog_bin -sv $rtl $tb > $xvlog_log 2>@1}]} {
  puts [read [open $xvlog_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA04_XVLOG_FAIL
  exit 2
}
set xelab_log [file join $bag xelab.log]
if {[catch {exec $xelab_bin tb_astra04_2hop -s astra04 -timescale 1ns/1ps > $xelab_log 2>@1}]} {
  puts [read [open $xelab_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA04_XELAB_FAIL
  exit 3
}
set xsim_log [file join $bag xsim.log]
catch {exec $xsim_bin astra04 -R -log $xsim_log}
set body [read [open $xsim_log r]]
puts $body
if {[string match *FIRST_DIVERGENCE* $body]} { puts ASTRA04_FIRST_DIVERGENCE; exit 6 }
if {![string match *ASTRA04_2HOP_XSIM_PASS* $body]} { puts ASTRA04_NOT_PASS; exit 5 }
puts ASTRA04_XSIM_OK
exit 0
