# ASTRA-11 SOC_WRAP + IMPL_ROUTE. PROGRAM=NO. BIT=UNPROGRAMMED. COM12=UNTOUCHED.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  arty_a7_astra09_soc_top
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]
set first_div ""

set files [list \
  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_struct_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_route_valid_gate.sv] \
  [file join $root rtl/native_graph/memory/a7ng_sparse_dir_axi.sv] \
  [file join $root rtl/native_graph/memory/a7ng_axi_bram128.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_query_axi_sparse.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_rel_engine_2hop.sv] \
  [file join $root rtl/native_graph/learn/a7ng_shared_rank_sgd_q8.sv] \
  [file join $root rtl/native_graph/lm/a7ng_evidence_compose.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra09_pipe.sv] \
  [file join $root rtl/board/uart_rx.sv] \
  [file join $root rtl/board/uart_tx.sv] \
  [file join $root rtl/board/arty_a7_astra09_soc_top.sv] \
]
set xdc [file join $root constraints/arty_a7_100.xdc]

proc astra_fail {cut msg} {
  global bag first_div
  if {$first_div eq ""} {
    set first_div $cut
  }
  set fh [open [file join $bag FIRST_DIVERGENCE.txt] w]
  puts $fh "FIRST_DIVERGENCE $cut"
  puts $fh $msg
  close $fh
  puts "FIRST_DIVERGENCE $cut $msg"
}

set_param general.maxThreads 8
create_project -in_memory -part $part
set_property include_dirs [list $incq $incc] [current_fileset]
foreach f $files {
  if {![file exists $f]} {
    astra_fail FILE_MISSING $f
    puts ASTRA11_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
read_xdc $xdc

if {[catch {synth_design -top $top -part $part} err]} {
  astra_fail SYNTH $err
  if {[catch {report_utilization -file [file join $bag util.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing.rpt]}]} {}
  puts ASTRA11_SYNTH_FAIL
  exit 1
}
file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
puts ASTRA11_SYNTH_DONE

if {[catch {opt_design} err]} {
  astra_fail OPT $err
}
if {[catch {place_design} err]} {
  astra_fail PLACE $err
  if {[catch {report_utilization -file [file join $bag util.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  puts ASTRA11_PLACE_FAIL
  exit 1
}
if {[catch {phys_opt_design} err]} {
  puts "PHYS_OPT_WARN $err"
}
if {[catch {route_design} err]} {
  astra_fail ROUTE $err
  if {[catch {report_utilization -file [file join $bag util.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing.rpt]}]} {}
  if {[catch {report_route_status -file [file join $bag route_status.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  puts ASTRA11_ROUTE_FAIL
  exit 1
}

if {[catch {write_checkpoint -force [file join $bag ckpt route.dcp]}]} {}
report_utilization -file [file join $bag util.rpt]
report_timing_summary -file [file join $bag timing.rpt]
report_route_status -file [file join $bag route_status.rpt]
report_drc -file [file join $bag drc.rpt]
report_io -file [file join $bag io.rpt]

set wns "NA"
set tns "NA"
set whs "NA"
set ths "NA"
if {[catch {
  set tp [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
  if {[llength $tp]} { set wns [get_property SLACK $tp] }
  set th [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
  if {[llength $th]} { set whs [get_property SLACK $th] }
}]} {}

set sfh [open [file join $bag TIMING_EXTRACT.txt] w]
puts $sfh "WNS=$wns"
puts $sfh "WHS=$whs"
puts $sfh "ROUTE=COMPLETE"
puts $sfh "PROGRAM=NO"
puts $sfh "COM12=UNTOUCHED"
close $sfh

set bitfile [file join $bag arty_a7_astra09_soc_top.bit]
set bit_status "NOT_WRITTEN"
if {$first_div eq ""} {
  if {[catch {write_bitstream -force $bitfile} berr]} {
    puts "BITSTREAM_SKIP $berr"
    set bit_status "SKIP"
    set bfh [open [file join $bag BITSTREAM.txt] w]
    puts $bfh "STATUS=SKIP"
    puts $bfh $berr
    puts $bfh "PROGRAM=NO"
    puts $bfh "COM12=UNTOUCHED"
    close $bfh
  } else {
    set bit_status "UNPROGRAMMED"
    set bfh [open [file join $bag BITSTREAM.txt] w]
    puts $bfh "STATUS=UNPROGRAMMED"
    puts $bfh "FILE=$bitfile"
    puts $bfh "PROGRAM=NO"
    puts $bfh "COM12=UNTOUCHED"
    puts $bfh "JTAG=210319BE776EA UNTOUCHED"
    close $bfh
    puts "BITSTREAM_UNPROGRAMMED $bitfile"
  }
}

puts "ASTRA11_IMPL_ROUTE_DONE WNS=$wns WHS=$whs BIT=$bit_status PROGRAM=NO"
exit 0
