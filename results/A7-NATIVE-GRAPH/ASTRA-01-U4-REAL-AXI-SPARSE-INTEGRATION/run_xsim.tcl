# ASTRA-01 raw query → 4x4096 AXI directory. PROGRAM=NO. COM12=UNTOUCHED.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set u3q  [file normalize [file join $bag ../GROK-ORCH-00/U3Q-R3-STRUCTURED-QUERY-FEATURE-00]]
set xvlog_bin [file normalize {C:/2026.1/Vivado/bin/xvlog.bat}]
set xelab_bin [file normalize {C:/2026.1/Vivado/bin/xelab.bat}]
set xsim_bin  [file normalize {C:/2026.1/Vivado/bin/xsim.bat}]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}

set work [file join $bag xsim_work]
file mkdir $work
cd $work

set pkg  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv]
set qse  [file join $root rtl/native_graph/query/a7ng_query_struct_extract.sv]
set vg   [file join $root rtl/native_graph/query/a7ng_route_valid_gate.sv]
set mem  [file join $root rtl/native_graph/memory/a7ng_axi_mem_model.sv]
set walk [file join $root rtl/native_graph/memory/a7ng_sparse_dir_axi.sv]
set dut  [file join $root rtl/native_graph/integrate/a7ng_query_axi_sparse.sv]
set tb   [file join $bag tb_astra01_query_axi_sparse.sv]
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]

set xvlog_log [file join $bag xvlog.log]
if {[catch {exec $xvlog_bin -sv $pkg $qse $vg $mem $walk $dut $tb -i $incq -i $incc -i $u3q -i $bag > $xvlog_log 2>@1}]} {
  puts [read [open $xvlog_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA01_XVLOG_FAIL
  exit 2
}
set xelab_log [file join $bag xelab.log]
if {[catch {exec $xelab_bin tb_astra01_query_axi_sparse -s astra01 -timescale 1ns/1ps > $xelab_log 2>@1}]} {
  puts [read [open $xelab_log r]]
  puts FIRST_DIVERGENCE
  puts ASTRA01_XELAB_FAIL
  exit 3
}
set xsim_log [file join $bag xsim.log]
catch {exec $xsim_bin astra01 -R -log $xsim_log}
set body [read [open $xsim_log r]]
puts $body
if {[string match *FIRST_DIVERGENCE* $body]} {
  puts ASTRA01_FIRST_DIVERGENCE
  exit 6
}
if {![string match *ASTRA01_AXI_SPARSE_PASS* $body]} {
  puts ASTRA01_NOT_PASS
  exit 5
}
puts ASTRA01_XSIM_OK
exit 0
