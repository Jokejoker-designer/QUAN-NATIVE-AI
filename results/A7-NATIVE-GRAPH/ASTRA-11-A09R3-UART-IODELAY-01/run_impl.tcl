# ASTRA-11-A09R3-UART-IODELAY-01. PROGRAM=NO. BIT=NO. write_bitstream forbidden.
# Instantiates a7ng_astra_09_r2_cand_ovf as u_a09r2. UART D10/A9 + frozen I/O delays.
# Frozen a7ng_astra_09_integ_path.sv is not compiled. synth + opt + place + route. No bitstream.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  a7ng_astra_11_a09r3_uart_iodelay_wrap
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
  [file join $root rtl/board/uart_rx.sv] \
  [file join $root rtl/board/uart_tx.sv] \
  [file join $bag a7ng_astra_11_a09r3_uart_iodelay_plant.sv] \
  [file join $bag a7ng_astra_11_a09r3_uart_iodelay_wrap.sv] \
]
set xdc [file join $bag clk50_uart_iodelay.xdc]

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
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
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
             clock_util_route.rpt io.rpt UART_IOB.txt UART_IODELAY.txt \
             timing_uart_in.rpt timing_uart_out.rpt check_timing.rpt} {
    set src [file join $bag $f]
    if {[file exists $src]} {
      file copy -force $src [file join $dst $f]
    }
  }
  puts "ASTRA_11_A09R3_UART_IODELAY_FAIL_R0_PRESERVED $dst"
}

proc astra_uart_iob_extract {rpt out} {
  set a9 "NO"
  set d10 "NO"
  set a9_sig ""
  set d10_sig ""
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    if {[regexp {\|\s*A9\s+\|\s+uart_txd_in\s+\|} $txt]} {
      set a9 "YES"
      set a9_sig "uart_txd_in"
    }
    if {[regexp {\|\s*D10\s+\|\s+uart_rxd_out\s+\|} $txt]} {
      set d10 "YES"
      set d10_sig "uart_rxd_out"
    }
  }
  set of [open $out w]
  puts $of "UART_TXD_IN_A9=$a9 $a9_sig"
  puts $of "UART_RXD_OUT_D10=$d10 $d10_sig"
  if {$a9 eq "YES" && $d10 eq "YES"} {
    puts $of "UART_IOB=YES"
  } else {
    puts $of "UART_IOB=NO"
  }
  puts $of "PROGRAM=NO"
  close $of
  return [list $a9 $d10]
}

proc astra_path_slack {args} {
  set slack "NA"
  if {![llength [info commands get_timing_paths]]} { return $slack }
  set tp [eval get_timing_paths -quiet -max_paths 1 -nworst 1 $args]
  if {[llength $tp]} {
    set slack [get_property SLACK [lindex $tp 0]]
  }
  return $slack
}

proc astra_uart_iodelay_extract {out} {
  global bag
  set in_su  [astra_path_slack -from [get_ports -quiet uart_txd_in] -setup]
  set in_ho  [astra_path_slack -from [get_ports -quiet uart_txd_in] -hold]
  set out_su [astra_path_slack -to   [get_ports -quiet uart_rxd_out] -setup]
  set out_ho [astra_path_slack -to   [get_ports -quiet uart_rxd_out] -hold]
  set vclk "NO"
  if {[llength [get_clocks -quiet uart_io_vclk]]} { set vclk "YES" }
  set clk50 "NO"
  if {[llength [get_clocks -quiet clk50u]]} { set clk50 "YES" }
  set of [open $out w]
  puts $of "UART_IN_MAX_NS=2.000"
  puts $of "UART_IN_MIN_NS=0.500"
  puts $of "UART_OUT_MAX_NS=2.000"
  puts $of "UART_OUT_MIN_NS=0.500"
  puts $of "UART_IO_VCLK=$vclk"
  puts $of "PIPE_CLK50U=$clk50"
  puts $of "UART_IN_SETUP_SLACK=$in_su"
  puts $of "UART_IN_HOLD_SLACK=$in_ho"
  puts $of "UART_OUT_SETUP_SLACK=$out_su"
  puts $of "UART_OUT_HOLD_SLACK=$out_ho"
  puts $of "PROGRAM=NO"
  close $of
  return [list $in_su $in_ho $out_su $out_ho $vclk $clk50]
}

foreach f $files {
  set bn [file tail $f]
  if {$bn eq "a7ng_astra09_pipe.sv" || $bn eq "arty_a7_astra09_soc_top.sv" ||
      $bn eq "arty_a7_astra_rtp_soc_top.sv" ||
      $bn eq "a7ng_astra_09_integ_path.sv" ||
      $bn eq "a7ng_astra_09_r3_uart_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_impl_wrap.sv" ||
      [string match *pipe_r1* $bn] || [string match *plant128* $bn] ||
      [string match *axi_bram128* $bn]} {
    astra_fail FORBIDDEN_DUT $f
    puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
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
    puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
if {![file exists $xdc]} {
  astra_fail FILE_MISSING $xdc
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
read_xdc $xdc
puts "DUT_TOP=$top"
puts "DUT_MODULE=a7ng_astra_09_r2_cand_ovf"
puts "DUT_INSTANCE=u_a09r2"
puts "UART_RX=u_rx"
puts "UART_TX=u_tx"
puts "PIN_CLK=CLK100MHZ E3 period=10.000ns"
puts "UART_RXD_OUT=D10"
puts "UART_TXD_IN=A9"
puts "PIPE_CLK=MMCM_100_to_50 period=20.000ns"
puts "UART_IO_VCLK=uart_io_vclk period=20.000ns"
puts "UART_IN_MAX_NS=2.000 UART_IN_MIN_NS=0.500"
puts "UART_OUT_MAX_NS=2.000 UART_OUT_MIN_NS=0.500"
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
  puts ASTRA_11_A09R3_UART_IODELAY_SYNTH_FAIL
  exit 1
}

file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
astra_timing_extract [file join $bag timing_synth.rpt] [file join $bag TIMING_EXTRACT_SYNTH.txt] Synthesized
puts ASTRA_11_A09R3_UART_IODELAY_SYNTH_DONE
if {![llength [get_clocks -quiet uart_io_vclk]]} {
  astra_fail UART_IODELAY_CLK "uart_io_vclk missing after synth; I/O delays not bound"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
puts "UART_IO_VCLK_AFTER_SYNTH=YES PERIOD=[get_property PERIOD [get_clocks uart_io_vclk]]"

set cells [get_cells -quiet -hierarchical -filter {NAME =~ *u_a09r2*}]
puts "U_A09R2_CELLS=[llength $cells]"
if {[llength $cells] == 0} {
  astra_fail DUT_MISSING "no hierarchical cells matching *u_a09r2*"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
set urx [get_cells -quiet -hierarchical -filter {NAME =~ *u_rx*}]
set utx [get_cells -quiet -hierarchical -filter {NAME =~ *u_tx*}]
puts "U_RX_CELLS=[llength $urx]"
puts "U_TX_CELLS=[llength $utx]"
if {[llength $urx] == 0 || [llength $utx] == 0} {
  astra_fail UART_MISSING "uart_rx/uart_tx cells missing urx=[llength $urx] utx=[llength $utx]"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
set bad09 [get_cells -quiet -hierarchical -filter {REF_NAME =~ *astra09_pipe* || ORIG_REF_NAME =~ *astra09_pipe*}]
if {[llength $bad09]} {
  astra_fail FORBIDDEN_DUT "astra09_pipe cell in netlist: $bad09"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
set badbram [get_cells -quiet -hierarchical -filter {REF_NAME =~ *axi_bram128* || ORIG_REF_NAME =~ *axi_bram128*}]
if {[llength $badbram]} {
  astra_fail FORBIDDEN_DUT "axi_bram128 cell in netlist: $badbram"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
set bada09 [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_09_integ_path || ORIG_REF_NAME == a7ng_astra_09_integ_path}]
if {[llength $bada09]} {
  astra_fail FORBIDDEN_DUT "frozen a7ng_astra_09_integ_path cell in netlist: $bada09"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}

if {[catch {opt_design} err]} {
  astra_fail OPT $err
  puts ASTRA_11_A09R3_UART_IODELAY_OPT_FAIL
  exit 1
}
puts ASTRA_11_A09R3_UART_IODELAY_OPT_DONE

if {[catch {place_design} err]} {
  astra_fail PLACE $err
  if {[catch {report_utilization -file [file join $bag util_place.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_place.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  astra_util_extract [file join $bag util_place.rpt] [file join $bag UTIL_EXTRACT.txt] Placed
  astra_timing_extract [file join $bag timing_place.rpt] [file join $bag TIMING_EXTRACT.txt] Placed
  puts ASTRA_11_A09R3_UART_IODELAY_PLACE_FAIL
  exit 1
}
if {[catch {phys_opt_design} err]} {
  puts "PHYS_OPT_WARN $err"
}
puts ASTRA_11_A09R3_UART_IODELAY_PLACE_DONE

if {[catch {route_design} err]} {
  astra_fail ROUTE $err
  if {[catch {report_utilization -file [file join $bag util_route.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_route.rpt]}]} {}
  if {[catch {report_route_status -file [file join $bag route_status.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  if {[catch {report_io -file [file join $bag io.rpt]}]} {}
  astra_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Partial
  astra_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Partial
  astra_uart_iob_extract [file join $bag io.rpt] [file join $bag UART_IOB.txt]
  puts ASTRA_11_A09R3_UART_IODELAY_ROUTE_FAIL
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
if {[catch {check_timing -verbose -file [file join $bag check_timing.rpt]}]} {}
if {[catch {report_timing -from [get_ports uart_txd_in] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_in.rpt]}]} {}
if {[catch {report_timing -to [get_ports uart_rxd_out] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_out.rpt]}]} {}
astra_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Routed
set tex [astra_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Routed]
set iob [astra_uart_iob_extract [file join $bag io.rpt] [file join $bag UART_IOB.txt]]
set iod [astra_uart_iodelay_extract [file join $bag UART_IODELAY.txt]]
set a9  [lindex $iob 0]
set d10 [lindex $iob 1]
puts "UART_IOB A9=$a9 D10=$d10"
puts "UART_IODELAY IN_SU=[lindex $iod 0] IN_HO=[lindex $iod 1] OUT_SU=[lindex $iod 2] OUT_HO=[lindex $iod 3] VCLK=[lindex $iod 4] CLK50=[lindex $iod 5]"
if {$a9 ne "YES" || $d10 ne "YES"} {
  astra_fail UART_IOB "io.rpt missing UART IOB A9=$a9 D10=$d10"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
if {[lindex $iod 4] ne "YES"} {
  astra_fail UART_IODELAY_CLK "uart_io_vclk missing after route"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
if {[lindex $iod 0] eq "NA" || [lindex $iod 2] eq "NA"} {
  astra_fail UART_IODELAY_PATH "UART I/O timing paths missing IN_SU=[lindex $iod 0] OUT_SU=[lindex $iod 2]"
  puts ASTRA_11_A09R3_UART_IODELAY_ABORTED
  exit 1
}
set wns [lindex $tex 0]
set tns [lindex $tex 1]
set whs [lindex $tex 2]
set ths [lindex $tex 3]
puts "ASTRA_11_A09R3_UART_IODELAY_ROUTE_DONE WNS=$wns TNS=$tns WHS=$whs THS=$ths UART_IOB=YES UART_IODELAY=2.000/0.500 PROGRAM=NO BIT=NOT_BUILT"

set wns_num ""
if {[catch {set wns_num [expr {double($wns)}]}]} {
  set wns_num ""
}

if {$wns_num ne "" && $wns_num < 0.0} {
  astra_fail WNS_NEG "routed WNS=$wns < 0 at declared 50 MHz; bag FAIL; keep report; one bounded experiment"
  astra_copy_fail_r0
  # Bounded clock/constraint experiment: post-route phys_opt only. Still 50 MHz. Still no bitstream.
  if {[catch {phys_opt_design} e2]} {
    puts "ASTRA_11_A09R3_UART_IODELAY_EXP_PHYS_OPT_WARN $e2"
  } else {
    puts ASTRA_11_A09R3_UART_IODELAY_EXP_PHYS_OPT_DONE
  }
  if {[catch {report_timing_summary -file [file join $bag timing_route_exp.rpt]}]} {}
  if {[catch {report_utilization -file [file join $bag util_route_exp.rpt]}]} {}
  if {[catch {report_io -file [file join $bag io_exp.rpt]}]} {}
  if {[catch {report_timing -from [get_ports uart_txd_in] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_in_exp.rpt]}]} {}
  if {[catch {report_timing -to [get_ports uart_rxd_out] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_out_exp.rpt]}]} {}
  astra_timing_extract [file join $bag timing_route_exp.rpt] [file join $bag TIMING_EXTRACT_EXP.txt] RoutedExp
  astra_util_extract [file join $bag util_route_exp.rpt] [file join $bag UTIL_EXTRACT_EXP.txt] RoutedExp
  astra_uart_iob_extract [file join $bag io_exp.rpt] [file join $bag UART_IOB_EXP.txt]
  astra_uart_iodelay_extract [file join $bag UART_IODELAY_EXP.txt]
  puts ASTRA_11_A09R3_UART_IODELAY_EXP_DONE
  puts "ASTRA_11_A09R3_UART_IODELAY_DONE WNS=$wns WHS=$whs UART_IOB=YES UART_IODELAY=2.000/0.500 BIT=NOT_BUILT PROGRAM=NO RESULT=FAIL_WNS PRODUCTION_TOP=UNKNOWN"
  exit 0
}

puts "ASTRA_11_A09R3_UART_IODELAY_DONE WNS=$wns TNS=$tns WHS=$whs UART_IOB=YES UART_IODELAY=2.000/0.500 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN"
exit 0
