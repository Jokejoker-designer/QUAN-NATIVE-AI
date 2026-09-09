# ASTRA-03 qse-role-v1-00 parse XSim. PROGRAM=NO. COM12=UNTOUCHED.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set xvlog_bin [file normalize {C:/2026.1/Vivado/bin/xvlog.bat}]
set xelab_bin [file normalize {C:/2026.1/Vivado/bin/xelab.bat}]
set xsim_bin  [file normalize {C:/2026.1/Vivado/bin/xsim.bat}]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}

set work [file join $bag xsim_parse_work]
file mkdir $work
cd $work

set pkg  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv]
set role [file join $root rtl/native_graph/query/a7ng_query_role_parse.sv]
set qse  [file join $root rtl/native_graph/query/a7ng_query_struct_extract.sv]
set tb   [file join $bag tb_astra03_role_parse.sv]
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]

set xvlog_log [file join $bag xvlog_parse.log]
if {[catch {exec $xvlog_bin -sv $pkg $role $qse $tb -i $incq -i $incc -i $bag > $xvlog_log 2>@1}]} {
  puts [read [open $xvlog_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA03_XVLOG_FAIL
  exit 2
}
set xelab_log [file join $bag xelab_parse.log]
if {[catch {exec $xelab_bin tb_astra03_role_parse -s astra03p -timescale 1ns/1ps > $xelab_log 2>@1}]} {
  puts [read [open $xelab_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA03_XELAB_FAIL
  exit 3
}
set xsim_log [file join $bag xsim_parse.log]
catch {exec $xsim_bin astra03p -R -log $xsim_log}
set body [read [open $xsim_log r]]
puts $body
if {[string match *FIRST_DIVERGENCE* $body]} {
  puts ASTRA03_FIRST_DIVERGENCE
  exit 6
}
if {![string match *ASTRA03_ROLE_PARSE_PASS* $body]} {
  puts ASTRA03_NOT_PASS
  exit 5
}
puts ASTRA03_XSIM_OK
exit 0
