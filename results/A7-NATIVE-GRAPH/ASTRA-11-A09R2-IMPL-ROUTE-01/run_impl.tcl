# ASTRA-11-A09R2-IMPL-ROUTE-01. PROGRAM=NO. BIT=NO. write_bitstream forbidden.
# Instantiates a7ng_astra_09_r2_cand_ovf as u_a09r2. No copy-paste graph.
# Frozen a7ng_astra_09_integ_path.sv is not compiled. synth + opt + place + route. No bitstream.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  a7ng_astra_11_a09r2_impl_wrap
set first_div ""
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]
set inci [file join $root rtl/native_graph/integrate]

set files [list \
  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_struct_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_route_valid_gate.sv] \
  [file join $root rtl/native_graph/memory/a7ng_sparse_dir_axi.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_query_axi_sparse.sv] \
  [file join $root rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv] \
  [file join $bag a7ng_astra_11_a09r2_impl_wrap.sv] \
]
set xdc [file join $bag clk50_impl.xdc]

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

proc astra_forbid_bit {args} {
  astra_fail WRITE_BITSTREAM "PROGRAM=NO write_bitstream/hw forbidden"
  puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
  exit 1
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

proc astra_timing_extract {rpt out state} {
  set wns "NA"
  set tns "NA"
  set whs "NA"
  set ths "NA"
  set period "NA"
  set clkname "NA"
  if {[llength [info commands get_clocks]]} {
    set clks [get_clocks -quiet]
    foreach c $clks {
      set per [get_property PERIOD $c]
      if {$per ne "" && ![catch {expr {abs($per - 20.0) < 0.01}} cmp] && $cmp} {
        set clkname [get_property NAME $c]
        set period $per
        break
      }
    }
    if {$clkname eq "NA" && [llength $clks]} {
      set c [lindex $clks 0]
      set clkname [get_property NAME $c]
      set period [get_property PERIOD $c]
    }
  }
  if {[llength [info commands get_timing_paths]]} {
    set tp [get_timing_paths -quiet -setup -max_paths 1 -nworst 1]
    if {[llength $tp]} {
      set wns [get_property SLACK [lindex $tp 0]]
    }
    set tph [get_timing_paths -quiet -hold -max_paths 1 -nworst 1]
    if {[llength $tph]} {
      set whs [get_property SLACK [lindex $tph 0]]
    }
  }
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    if {[regexp {WNS\(ns\)[^\n]*\n[^\n]*\n\s+(-?[0-9.]+)\s+(-?[0-9.]+)\s+[0-9]+\s+[0-9]+\s+(-?[0-9.]+)\s+(-?[0-9.]+)} $txt -> w t h th]} {
      if {$wns eq "NA"} { set wns $w }
      set tns $t
      if {$whs eq "NA"} { set whs $h }
      set ths $th
    }
  }
  set of [open $out w]
  puts $of "WNS=$wns"
  puts $of "TNS=$tns"
  puts $of "WHS=$whs"
  puts $of "THS=$ths"
  puts $of "CLOCK=$clkname"
  puts $of "PERIOD_NS=$period"
  puts $of "DESIGN_STATE=$state"
  puts $of "PROGRAM=NO"
  puts $of "BIT=NOT_BUILT"
  close $of
  return [list $wns $tns $whs $ths $clkname $period]
}

proc astra_copy_fail_r0 {} {
  global bag
  set dst [file join $bag fail_r0]
  file mkdir $dst
  foreach f {timing_route.rpt util_route.rpt route_status.rpt drc.rpt clocks_route.rpt \
             TIMING_EXTRACT.txt UTIL_EXTRACT.txt util_hier_route.rpt ram_route.rpt \
             clock_util_route.rpt io.rpt} {
    set src [file join $bag $f]
    if {[file exists $src]} {
      file copy -force $src [file join $dst $f]
    }
  }
  puts "ASTRA_11_A09R2_FAIL_R0_PRESERVED $dst"
}

foreach f $files {
  set bn [file tail $f]
  if {$bn eq "a7ng_astra09_pipe.sv" || $bn eq "arty_a7_astra09_soc_top.sv" ||
      $bn eq "arty_a7_astra_rtp_soc_top.sv" || $bn eq "uart_rx.sv" || $bn eq "uart_tx.sv" ||
      $bn eq "a7ng_astra_09_integ_path.sv" ||
      [string match *pipe_r1* $bn] || [string match *plant128* $bn] ||
      [string match *axi_bram128* $bn]} {
    astra_fail FORBIDDEN_DUT $f
    puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
    exit 1
  }
}

set_param general.maxThreads 8
create_project -in_memory -part $part
if {[llength [info commands write_bitstream]]} {
  rename write_bitstream _hidden_write_bitstream
  proc write_bitstream {args} { astra_forbid_bit }
}
set_property include_dirs [list $incq $incc $inci] [current_fileset]
foreach f $files {
  if {![file exists $f]} {
    astra_fail FILE_MISSING $f
    puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
if {![file exists $xdc]} {
  astra_fail FILE_MISSING $xdc
  puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
  exit 1
}
read_xdc $xdc
puts "DUT_TOP=$top"
puts "DUT_MODULE=a7ng_astra_09_r2_cand_ovf"
puts "DUT_INSTANCE=u_a09r2"
puts "PIN_CLK=CLK100MHZ E3 period=10.000ns"
puts "PIPE_CLK=MMCM_100_to_50 period=20.000ns"
puts "MODE=in_context_impl_route"
puts "PROGRAM=NO"
puts "BIT=NOT_BUILT"
puts "PRODUCTION_TOP=UNKNOWN"

if {[catch {synth_design -top $top -part $part} err]} {
  astra_fail SYNTH $err
  if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
  astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
  astra_timing_extract [file join $bag timing_synth.rpt] [file join $bag TIMING_EXTRACT_SYNTH.txt] Synthesized
  puts ASTRA_11_A09R2_IMPL_ROUTE_SYNTH_FAIL
  exit 1
}

file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
astra_timing_extract [file join $bag timing_synth.rpt] [file join $bag TIMING_EXTRACT_SYNTH.txt] Synthesized
puts ASTRA_11_A09R2_IMPL_ROUTE_SYNTH_DONE

set cells [get_cells -quiet -hierarchical -filter {NAME =~ *u_a09r2*}]
puts "U_A09R2_CELLS=[llength $cells]"
if {[llength $cells] == 0} {
  astra_fail DUT_MISSING "no hierarchical cells matching *u_a09r2*"
  puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
  exit 1
}
set bad09 [get_cells -quiet -hierarchical -filter {REF_NAME =~ *astra09_pipe* || ORIG_REF_NAME =~ *astra09_pipe*}]
if {[llength $bad09]} {
  astra_fail FORBIDDEN_DUT "astra09_pipe cell in netlist: $bad09"
  puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
  exit 1
}
set badbram [get_cells -quiet -hierarchical -filter {REF_NAME =~ *axi_bram128* || ORIG_REF_NAME =~ *axi_bram128*}]
if {[llength $badbram]} {
  astra_fail FORBIDDEN_DUT "axi_bram128 cell in netlist: $badbram"
  puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
  exit 1
}
set bada09 [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_09_integ_path || ORIG_REF_NAME == a7ng_astra_09_integ_path}]
if {[llength $bada09]} {
  astra_fail FORBIDDEN_DUT "frozen a7ng_astra_09_integ_path cell in netlist: $bada09"
  puts ASTRA_11_A09R2_IMPL_ROUTE_ABORTED
  exit 1
}

if {[catch {opt_design} err]} {
  astra_fail OPT $err
  puts ASTRA_11_A09R2_IMPL_ROUTE_OPT_FAIL
  exit 1
}
puts ASTRA_11_A09R2_IMPL_ROUTE_OPT_DONE

if {[catch {place_design} err]} {
  astra_fail PLACE $err
  if {[catch {report_utilization -file [file join $bag util_place.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_place.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  astra_util_extract [file join $bag util_place.rpt] [file join $bag UTIL_EXTRACT.txt] Placed
  astra_timing_extract [file join $bag timing_place.rpt] [file join $bag TIMING_EXTRACT.txt] Placed
  puts ASTRA_11_A09R2_IMPL_ROUTE_PLACE_FAIL
  exit 1
}
if {[catch {phys_opt_design} err]} {
  puts "PHYS_OPT_WARN $err"
}
puts ASTRA_11_A09R2_IMPL_ROUTE_PLACE_DONE

if {[catch {route_design} err]} {
  astra_fail ROUTE $err
  if {[catch {report_utilization -file [file join $bag util_route.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_route.rpt]}]} {}
  if {[catch {report_route_status -file [file join $bag route_status.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  astra_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Partial
  astra_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Partial
  puts ASTRA_11_A09R2_IMPL_ROUTE_ROUTE_FAIL
  exit 1
}

if {[catch {write_checkpoint -force [file join $bag ckpt route.dcp]}]} {}
report_utilization -file [file join $bag util_route.rpt]
report_utilization -hierarchical -file [file join $bag util_hier_route.rpt]
report_timing_summary -file [file join $bag timing_route.rpt]
report_route_status -file [file join $bag route_status.rpt]
report_drc -file [file join $bag drc.rpt]
report_io -file [file join $bag io.rpt]
if {[catch {report_clocks -file [file join $bag clocks_route.rpt]}]} {}
if {[catch {report_clock_utilization -file [file join $bag clock_util_route.rpt]}]} {}
if {[catch {report_ram_utilization -file [file join $bag ram_route.rpt]}]} {}
astra_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Routed
set tex [astra_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Routed]
set wns [lindex $tex 0]
set tns [lindex $tex 1]
set whs [lindex $tex 2]
set ths [lindex $tex 3]
puts "ASTRA_11_A09R2_IMPL_ROUTE_ROUTE_DONE WNS=$wns TNS=$tns WHS=$whs THS=$ths PROGRAM=NO BIT=NOT_BUILT"

set wns_num ""
if {[catch {set wns_num [expr {double($wns)}]}]} {
  set wns_num ""
}

if {$wns_num ne "" && $wns_num < 0.0} {
  astra_fail WNS_NEG "routed WNS=$wns < 0 at declared 50 MHz; bag FAIL; keep report; one bounded experiment"
  astra_copy_fail_r0
  # Bounded clock/constraint experiment: post-route phys_opt only. Still 50 MHz. Still no bitstream.
  if {[catch {phys_opt_design} e2]} {
    puts "ASTRA_11_A09R2_EXP_PHYS_OPT_WARN $e2"
  } else {
    puts ASTRA_11_A09R2_EXP_PHYS_OPT_DONE
  }
  if {[catch {report_timing_summary -file [file join $bag timing_route_exp.rpt]}]} {}
  if {[catch {report_utilization -file [file join $bag util_route_exp.rpt]}]} {}
  astra_timing_extract [file join $bag timing_route_exp.rpt] [file join $bag TIMING_EXTRACT_EXP.txt] RoutedExp
  astra_util_extract [file join $bag util_route_exp.rpt] [file join $bag UTIL_EXTRACT_EXP.txt] RoutedExp
  puts ASTRA_11_A09R2_EXP_DONE
  puts "ASTRA_11_A09R2_IMPL_ROUTE_DONE WNS=$wns WHS=$whs BIT=NOT_BUILT PROGRAM=NO RESULT=FAIL_WNS PRODUCTION_TOP=UNKNOWN"
  exit 0
}

puts "ASTRA_11_A09R2_IMPL_ROUTE_DONE WNS=$wns TNS=$tns WHS=$whs BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN"
exit 0
