# WRAP-XSIM synth-only of arty_a7_astra_rtp_soc_top. PROGRAM=NO. No bitstream.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  arty_a7_astra_rtp_soc_top
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]

set files [list \
  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_struct_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_route_valid_gate.sv] \
  [file join $root rtl/native_graph/memory/a7ng_sparse_dir_axi.sv] \
  [file join $root rtl/native_graph/memory/a7ng_axi_bram128.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_query_axi_sparse.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_rel_engine_2hop.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_rtp_pipe_r2.sv] \
  [file join $root rtl/board/uart_rx.sv] \
  [file join $root rtl/board/uart_tx.sv] \
  [file join $root rtl/board/arty_a7_astra_rtp_soc_top.sv] \
]
set xdc [file join $root constraints/arty_a7_100.xdc]

proc astra_fail {cut msg} {
  global bag
  set fh [open [file join $bag FIRST_DIVERGENCE.txt] w]
  puts $fh "FIRST_DIVERGENCE $cut"
  puts $fh $msg
  close $fh
  puts "FIRST_DIVERGENCE $cut $msg"
}

proc astra_util_extract {rpt out} {
  set lut "NA"
  set ff "NA"
  set bram "NA"
  set dsp "NA"
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    foreach line [split $txt "\n"] {
      if {[regexp {^\|\s*Slice LUTs\*?\s+\|\s+([0-9]+)} $line -> v]} { set lut $v }
      if {[regexp {^\|\s*Slice Registers\s+\|\s+([0-9]+)} $line -> v]} { set ff $v }
      if {[regexp {^\|\s*Block RAM Tile\s+\|\s+([0-9.]+)} $line -> v]} { set bram $v }
      if {[regexp {^\|\s*DSPs\s+\|\s+([0-9]+)} $line -> v]} { set dsp $v }
    }
  }
  set of [open $out w]
  puts $of "LUT=$lut"
  puts $of "FF=$ff"
  puts $of "BRAM_TILE=$bram"
  puts $of "DSP=$dsp"
  puts $of "DESIGN_STATE=Synthesized"
  puts $of "PROGRAM=NO"
  close $of
}

set_param general.maxThreads 8
create_project -in_memory -part $part
set_property include_dirs [list $incq $incc] [current_fileset]
foreach f $files {
  if {![file exists $f]} {
    astra_fail FILE_MISSING $f
    puts WRAP_XSIM_SYNTH_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
read_xdc $xdc

if {[catch {synth_design -top $top -part $part} err]} {
  astra_fail SYNTH $err
  if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
  astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt]
  puts WRAP_XSIM_SYNTH_FAIL
  exit 1
}
file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt]
puts WRAP_XSIM_SYNTH_DONE
exit 0
