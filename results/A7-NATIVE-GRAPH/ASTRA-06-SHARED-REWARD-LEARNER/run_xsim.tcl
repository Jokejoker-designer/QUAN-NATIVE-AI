# ASTRA-06 shared SGD XSim. PROGRAM=NO.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set xvlog_bin [file normalize {C:/2026.1/Vivado/bin/xvlog.bat}]
set xelab_bin [file normalize {C:/2026.1/Vivado/bin/xelab.bat}]
set xsim_bin  [file normalize {C:/2026.1/Vivado/bin/xsim.bat}]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set work [file join $bag xsim_work]
file mkdir $work
cd $work
set rtl [file join $root rtl/native_graph/learn/a7ng_shared_rank_sgd_q8.sv]
set tb  [file join $bag tb_astra06_sgd.sv]
set xvlog_log [file join $bag xvlog.log]
if {[catch {exec $xvlog_bin -sv $rtl $tb > $xvlog_log 2>@1}]} {
  puts [read [open $xvlog_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA06_XVLOG_FAIL
  exit 2
}
set xelab_log [file join $bag xelab.log]
if {[catch {exec $xelab_bin tb_astra06_sgd -s astra06 -timescale 1ns/1ps > $xelab_log 2>@1}]} {
  puts [read [open $xelab_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA06_XELAB_FAIL
  exit 3
}
set xsim_log [file join $bag xsim.log]
catch {exec $xsim_bin astra06 -R -log $xsim_log}
set body [read [open $xsim_log r]]
puts $body
if {[string match *FIRST_DIVERGENCE* $body]} { puts ASTRA06_FIRST_DIVERGENCE; exit 6 }
if {![string match *ASTRA06_SGD_XSIM_PASS* $body]} { puts ASTRA06_NOT_PASS; exit 5 }
puts ASTRA06_XSIM_OK
exit 0
