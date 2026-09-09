# ASTRA-SOC-RTP-WRAP-ROUTE. Copied from ASTRA-11-TIMING-FIX/run_impl.tcl.
# Top changed to arty_a7_astra_rtp_soc_top. DUT = r2 + a7ng_axi_bram128 + uart + wrap.
# Do NOT read_verilog a7ng_astra09_pipe / arty_a7_astra09_soc_top (not this exam DUT).
# PROGRAM=NO. BIT=UNPROGRAMMED. COM12=UNTOUCHED. JTAG=210319BE776EA UNTOUCHED.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  arty_a7_astra_rtp_soc_top
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
  [file join $root rtl/native_graph/integrate/a7ng_astra_rtp_pipe_r2.sv] \
  [file join $root rtl/board/uart_rx.sv] \
  [file join $root rtl/board/uart_tx.sv] \
  [file join $root rtl/board/arty_a7_astra_rtp_soc_top.sv] \
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

proc astra_util_extract {rpt out state} {
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
  puts $of "DESIGN_STATE=$state"
  puts $of "PROGRAM=NO"
  close $of
}

foreach f $files {
  set bn [file tail $f]
  if {[string match *astra09* $bn] || [string match *pipe_r1* $bn] || [string match *plant128* $bn]} {
    astra_fail FORBIDDEN_DUT $f
    puts ASTRA_SOC_RTP_WRAP_ROUTE_ABORTED
    exit 1
  }
}

set_param general.maxThreads 8
create_project -in_memory -part $part
set_property include_dirs [list $incq $incc] [current_fileset]
foreach f $files {
  if {![file exists $f]} {
    astra_fail FILE_MISSING $f
    puts ASTRA_SOC_RTP_WRAP_ROUTE_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
read_xdc $xdc
puts "DUT_TOP=$top"
puts "DUT_PIPE=a7ng_astra_rtp_pipe_r2"
puts "DUT_MEM=a7ng_axi_bram128"
puts "NOT_DUT=a7ng_astra09_pipe arty_a7_astra09_soc_top a7ng_astra_rtp_pipe_r1 a7ng_axi_rtp_plant128"

if {[catch {synth_design -top $top -part $part} err]} {
  astra_fail SYNTH $err
  if {[catch {report_utilization -file [file join $bag util.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing.rpt]}]} {}
  astra_util_extract [file join $bag util.rpt] [file join $bag UTIL_EXTRACT.txt] Synthesized
  puts ASTRA_SOC_RTP_WRAP_ROUTE_SYNTH_FAIL
  exit 1
}
file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
puts ASTRA_SOC_RTP_WRAP_ROUTE_SYNTH_DONE

set bad09 [get_cells -quiet -hierarchical -filter {REF_NAME =~ *astra09* || ORIG_REF_NAME =~ *astra09*}]
if {[llength $bad09]} {
  astra_fail FORBIDDEN_DUT "astra09 cell in netlist: $bad09"
  puts ASTRA_SOC_RTP_WRAP_ROUTE_ABORTED
  exit 1
}

if {[catch {opt_design} err]} {
  astra_fail OPT $err
}
if {[catch {place_design} err]} {
  astra_fail PLACE $err
  if {[catch {report_utilization -file [file join $bag util.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  astra_util_extract [file join $bag util.rpt] [file join $bag UTIL_EXTRACT.txt] Placed
  puts ASTRA_SOC_RTP_WRAP_ROUTE_PLACE_FAIL
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
  astra_util_extract [file join $bag util.rpt] [file join $bag UTIL_EXTRACT.txt] Partial
  puts ASTRA_SOC_RTP_WRAP_ROUTE_ROUTE_FAIL
  exit 1
}

if {[catch {write_checkpoint -force [file join $bag ckpt route.dcp]}]} {}
report_utilization -file [file join $bag util.rpt]
report_timing_summary -file [file join $bag timing.rpt]
report_route_status -file [file join $bag route_status.rpt]
report_drc -file [file join $bag drc.rpt]
report_io -file [file join $bag io.rpt]
if {[catch {report_clocks -file [file join $bag clocks.rpt]}]} {}
astra_util_extract [file join $bag util.rpt] [file join $bag UTIL_EXTRACT.txt] Routed

set wns "NA"
set whs "NA"
set wns50 "NA"
set whs50 "NA"
if {[catch {
  set tp [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
  if {[llength $tp]} { set wns [get_property SLACK $tp] }
  set th [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
  if {[llength $th]} { set whs [get_property SLACK $th] }
  set c50 [get_clocks -quiet clk50u]
  if {[llength $c50]} {
    set tp50 [get_timing_paths -delay_type max -max_paths 1 -nworst 1 -to $c50]
    if {[llength $tp50]} { set wns50 [get_property SLACK $tp50] }
    set th50 [get_timing_paths -delay_type min -max_paths 1 -nworst 1 -to $c50]
    if {[llength $th50]} { set whs50 [get_property SLACK $th50] }
  }
}]} {}

set cfh [open [file join $bag CLOCK_EXTRACT.txt] w]
puts $cfh "PIN_CLK=sys_clk_pin"
puts $cfh "PIN_PERIOD_NS=10.000"
puts $cfh "PIN=E3"
if {[catch {
  foreach c [get_clocks] {
    set nm [get_property NAME $c]
    set per [get_property PERIOD $c]
    puts $cfh "CLOCK $nm PERIOD_NS=$per"
  }
}]} {}
close $cfh

set bram "NA"
if {[file exists [file join $bag UTIL_EXTRACT.txt]]} {
  set ufh [open [file join $bag UTIL_EXTRACT.txt] r]
  while {[gets $ufh line] >= 0} {
    if {[regexp {BRAM_TILE=(.*)} $line -> v]} { set bram $v }
  }
  close $ufh
}

set sfh [open [file join $bag TIMING_EXTRACT.txt] w]
puts $sfh "WNS=$wns"
puts $sfh "WHS=$whs"
puts $sfh "WNS_CLK50U=$wns50"
puts $sfh "WHS_CLK50U=$whs50"
puts $sfh "ROUTE=COMPLETE"
puts $sfh "PIPE_CLK=50MHz"
puts $sfh "PIN_CLK=100MHz_E3_10ns"
puts $sfh "BRAM_TILE=$bram"
puts $sfh "TOP=$top"
puts $sfh "PIPE=a7ng_astra_rtp_pipe_r2"
puts $sfh "MEM=a7ng_axi_bram128"
puts $sfh "PROGRAM=NO"
puts $sfh "COM12=UNTOUCHED"
puts $sfh "JTAG=210319BE776EA UNTOUCHED"
close $sfh

set bitfile [file join $bag arty_a7_astra_rtp_soc_top.bit]
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

puts "ASTRA_SOC_RTP_WRAP_ROUTE_DONE WNS=$wns WHS=$whs WNS50=$wns50 BRAM=$bram BIT=$bit_status PROGRAM=NO"
exit 0
