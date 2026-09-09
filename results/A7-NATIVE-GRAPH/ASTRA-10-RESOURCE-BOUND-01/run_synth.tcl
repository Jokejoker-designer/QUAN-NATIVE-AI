# ASTRA-10-RESOURCE-BOUND-01. PROGRAM=NO. BIT=NO. write_bitstream forbidden.
# Instantiates a7ng_astra_09_integ_path as u_a09. No copy-paste graph.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  a7ng_astra_10_resource_wrap
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
  [file join $root rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv] \
  [file join $bag a7ng_astra_10_resource_wrap.sv] \
]
set xdc [file join $bag clk50_ooc.xdc]

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

proc astra_forbid_bit {} {
  astra_fail WRITE_BITSTREAM "PROGRAM=NO write_bitstream/hw forbidden"
  puts ASTRA_10_RESOURCE_BOUND_ABORTED
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
    if {[llength $clks]} {
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
  close $of
}

foreach f $files {
  set bn [file tail $f]
  if {$bn eq "a7ng_astra09_pipe.sv" || $bn eq "arty_a7_astra09_soc_top.sv" ||
      [string match *pipe_r1* $bn] || [string match *plant128* $bn] ||
      [string match *axi_bram128* $bn]} {
    astra_fail FORBIDDEN_DUT $f
    puts ASTRA_10_RESOURCE_BOUND_ABORTED
    exit 1
  }
}

set_param general.maxThreads 8
create_project -in_memory -part $part
set_property include_dirs [list $incq $incc $inci] [current_fileset]
foreach f $files {
  if {![file exists $f]} {
    astra_fail FILE_MISSING $f
    puts ASTRA_10_RESOURCE_BOUND_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
if {![file exists $xdc]} {
  astra_fail FILE_MISSING $xdc
  puts ASTRA_10_RESOURCE_BOUND_ABORTED
  exit 1
}
read_xdc $xdc
puts "DUT_TOP=$top"
puts "DUT_MODULE=a7ng_astra_09_integ_path"
puts "DUT_INSTANCE=u_a09"
puts "CLOCK=clk50 period=20.000ns"
puts "MODE=out_of_context"
puts "PROGRAM=NO"
puts "BIT=NOT_BUILT"

if {[catch {synth_design -mode out_of_context -top $top -part $part} err]} {
  astra_fail SYNTH $err
  if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
  astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT.txt] Synthesized
  astra_timing_extract [file join $bag timing_synth.rpt] [file join $bag TIMING_EXTRACT.txt] Synthesized
  puts ASTRA_10_RESOURCE_BOUND_SYNTH_FAIL
  exit 1
}

file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
if {[catch {report_utilization -hierarchical -file [file join $bag util_hier_synth.rpt]}]} {}
if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
if {[catch {report_clocks -file [file join $bag clocks_synth.rpt]}]} {}
if {[catch {report_ram_utilization -file [file join $bag ram_synth.rpt]}]} {}
astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT.txt] Synthesized
astra_timing_extract [file join $bag timing_synth.rpt] [file join $bag TIMING_EXTRACT.txt] Synthesized
puts ASTRA_10_RESOURCE_BOUND_SYNTH_DONE

set cells [get_cells -quiet -hierarchical -filter {NAME =~ *u_a09*}]
puts "U_A09_CELLS=[llength $cells]"
set bad09 [get_cells -quiet -hierarchical -filter {REF_NAME =~ *astra09_pipe* || ORIG_REF_NAME =~ *astra09_pipe*}]
if {[llength $bad09]} {
  astra_fail FORBIDDEN_DUT "astra09_pipe cell in netlist: $bad09"
  puts ASTRA_10_RESOURCE_BOUND_ABORTED
  exit 1
}

# Optional opt only (still PROGRAM=NO). No place/route required. No bitstream.
if {[catch {opt_design} err]} {
  astra_fail OPT $err
} else {
  if {[catch {report_utilization -file [file join $bag util_opt.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_opt.rpt]}]} {}
  astra_util_extract [file join $bag util_opt.rpt] [file join $bag UTIL_EXTRACT_OPT.txt] Opted
  astra_timing_extract [file join $bag timing_opt.rpt] [file join $bag TIMING_EXTRACT_OPT.txt] Opted
  puts ASTRA_10_RESOURCE_BOUND_OPT_DONE
}

puts "ASTRA_10_RESOURCE_BOUND_DONE PROGRAM=NO BIT=NOT_BUILT"
exit 0
