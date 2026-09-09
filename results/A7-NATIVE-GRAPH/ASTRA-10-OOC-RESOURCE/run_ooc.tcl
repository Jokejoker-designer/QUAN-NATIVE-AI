# ASTRA-10 OOC synth of unified pipe. PROGRAM=NO. BIT=NO.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]
set files [list \
  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_extract.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_rel_engine_2hop.sv] \
  [file join $root rtl/native_graph/learn/a7ng_shared_rank_sgd_q8.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_unified_pipe.sv] \
]
set_param general.maxThreads 8
create_project -in_memory -part $part
set_property include_dirs [list $incq $incc] [current_fileset]
foreach f $files { read_verilog -sv $f }
synth_design -mode out_of_context -top a7ng_unified_pipe -part $part
report_utilization -file [file join $bag util_ooc.rpt]
report_timing_summary -file [file join $bag timing_ooc.rpt]
puts ASTRA10_OOC_SYNTH_DONE
exit 0
