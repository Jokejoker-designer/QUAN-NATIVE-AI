# ASTRA-11-A09R7-BTN-IDELAY-01. PROGRAM=NO. BIT=NO. write_bitstream forbidden.
# Instantiates a7ng_astra_09_r2_cand_ovf as u_a09r2. UART D10/A9 kept. LED LD4-LD7
# H5/J5/T9/T10 kept. BTN0-BTN3 D9/C9/B9/B8 (cited constraints/arty_a7_100.xdc).
# BTN input delays 2.000/0.500 vs clk50u frozen in PREREG; applied post-synth via
# btn_iodelay.xdc. IDELAYE2 tap 31 / REFCLK 200 MHz / IDELAYCTRL frozen in PREREG
# before impl. LED delays kept. UART envelope kept. Do not false-path btn.
# Frozen a7ng_astra_09_integ_path.sv is not compiled. synth + opt + place + route. No bitstream.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  a7ng_astra_11_a09r7_btn_idelay_wrap
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
  [file join $bag a7ng_astra_11_a09r7_btn_idelay_plant.sv] \
  [file join $bag a7ng_astra_11_a09r7_btn_idelay_wrap.sv] \
]
set xdc [file join $bag clk50_btn_idelay.xdc]
set ledxdc [file join $bag led_iodelay.xdc]
set btnxdc [file join $bag btn_iodelay.xdc]

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
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}

proc astra_util_extract {rpt out state} {
  set lut "NA"
  set ff "NA"
  set bram "NA"
  set dsp "NA"
  set iobff "NA"
  set ilogic "NA"
  set ologic "NA"
  set idelayctrl "NA"
  set idelaye2 "NA"
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    foreach line [split $txt "\n"] {
      if {[regexp {^\|\s*Slice LUTs\*?\s+\|\s+([0-9]+)} $line -> v]} { set lut $v }
      if {[regexp {^\|\s*Slice Registers\s+\|\s+([0-9]+)} $line -> v]} { set ff $v }
      if {[regexp {^\|\s*Block RAM Tile\s+\|\s+([0-9.]+)} $line -> v]} { set bram $v }
      if {[regexp {^\|\s*DSPs\s+\|\s+([0-9]+)} $line -> v]} { set dsp $v }
      if {[regexp {^\|\s*IOB Flip Flops\s+\|\s+([0-9]+)} $line -> v]} { set iobff $v }
      if {[regexp {^\|\s*ILOGIC\s+\|\s+([0-9]+)} $line -> v]} { set ilogic $v }
      if {[regexp {^\|\s*OLOGIC\s+\|\s+([0-9]+)} $line -> v]} { set ologic $v }
      if {[regexp {^\|\s*IDELAYCTRL\s+\|\s+([0-9]+)} $line -> v]} { set idelayctrl $v }
      if {[regexp {^\|\s*IDELAYE2} $line]} {
        if {[regexp {\|\s+([0-9]+)\s+\|} $line -> v]} { set idelaye2 $v }
      }
    }
  }
  set of [open $out w]
  puts $of "LUT=$lut"
  puts $of "FF=$ff"
  puts $of "BRAM_TILE=$bram"
  puts $of "DSP=$dsp"
  puts $of "IOB_FLIP_FLOPS=$iobff"
  puts $of "ILOGIC=$ilogic"
  puts $of "OLOGIC=$ologic"
  puts $of "IDELAYCTRL=$idelayctrl"
  puts $of "IDELAYE2=$idelaye2"
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
        set n [get_property NAME $c]
        if {$n eq "clk50u"} {
          set clkname $n
          set period $per
          break
        }
        if {$clkname eq "NA"} {
          set clkname $n
          set period $per
        }
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
             clock_util_route.rpt io.rpt UART_IOB.txt UART_IODELAY.txt UART_IOBFF.txt \
             timing_uart_in.rpt timing_uart_out.rpt timing_led_out.rpt check_timing.rpt exceptions_route.rpt \
             LED_IOB.txt LED_IODELAY.txt LED_IOBFF.txt \
             BTN_IOB.txt BTN_IODELAY.txt BTN_IOBFF.txt BTN_IDELAYE2.txt timing_btn_in.rpt} {
    set src [file join $bag $f]
    if {[file exists $src]} {
      file copy -force $src [file join $dst $f]
    }
  }
  puts "ASTRA_11_A09R7_BTN_IDELAY_FAIL_R0_PRESERVED $dst"
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
  puts $of "HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART"
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

proc astra_iob_site_packed {bel loc} {
  set belu [string toupper $bel]
  set locu [string toupper $loc]
  if {[regexp {(^|[.])(INFF|OUTFF|IFF|OFF)$} $belu]} { return 1 }
  if {[string match IOB_* $locu]} { return 1 }
  if {[string match ILOGIC_* $locu]} { return 1 }
  if {[string match OLOGIC_* $locu]} { return 1 }
  return 0
}

proc astra_pick_cell {pattern} {
  set cells [get_cells -quiet -hierarchical -filter "NAME =~ $pattern"]
  if {[llength $cells]} { return [lindex $cells 0] }
  return ""
}

proc astra_apply_hold_policy {} {
  set n 0
  set v [get_clocks -quiet uart_io_vclk]
  set c [get_clocks -quiet clk50u]
  if {[llength $v] && [llength $c]} {
    if {[catch {set_false_path -hold -from $v -to $c} err]} {
      puts "HOLD_POLICY_CLK_WARN vclk->clk50u $err"
    } else {
      incr n
    }
    if {[catch {set_false_path -hold -from $c -to $v} err2]} {
      puts "HOLD_POLICY_CLK_WARN clk50u->vclk $err2"
    } else {
      incr n
    }
    puts "HOLD_POLICY_CLK_FALSE_PATH_HOLD_APPLIED=$n"
  } else {
    puts "HOLD_POLICY_CLK_FALSE_PATH_HOLD_SKIP vclk=[llength $v] clk50u=[llength $c]"
  }
  return $n
}

proc astra_force_iob_true {} {
  set n 0
  set cells [get_cells -quiet -hierarchical -filter {NAME =~ *uart_rx_iob_reg* || NAME =~ *uart_tx_iob_reg* || NAME =~ *led_q_reg* || NAME =~ *btn_q_reg*}]
  foreach c $cells {
    if {[catch {set_property IOB TRUE $c} err]} {
      puts "IOB_TRUE_WARN $c $err"
    } else {
      incr n
      puts "IOB_TRUE_CELL=[get_property NAME $c] IOB=[get_property IOB $c]"
    }
  }
  if {[llength [info commands all_fanout]]} {
    set rx_end [all_fanout -quiet -flat -endpoints_only -only_cells [get_ports -quiet uart_txd_in]]
    foreach c $rx_end {
      if {[catch {set_property IOB TRUE $c} err]} {
        puts "IOB_TRUE_RX_FANOUT_WARN $c $err"
      } else {
        incr n
        puts "IOB_TRUE_RX_FANOUT=[get_property NAME $c]"
      }
    }
  }
  if {[llength [info commands all_fanin]]} {
    set tx_st [all_fanin -quiet -flat -startpoints_only -only_cells [get_ports -quiet uart_rxd_out]]
    foreach c $tx_st {
      if {[catch {set_property IOB TRUE $c} err]} {
        puts "IOB_TRUE_TX_FANIN_WARN $c $err"
      } else {
        incr n
        puts "IOB_TRUE_TX_FANIN=[get_property NAME $c]"
      }
    }
  }
  if {[llength [info commands all_fanout]]} {
    set btn_end [all_fanout -quiet -flat -endpoints_only -only_cells [get_ports -quiet {btn[*]}]]
    foreach c $btn_end {
      set rn ""
      catch {set rn [get_property REF_NAME $c]}
      if {$rn eq "IDELAYE2" || $rn eq "IDELAYCTRL"} {
        puts "IOB_TRUE_BTN_FANOUT_SKIP_IDELAY=[get_property NAME $c] REF=$rn"
        continue
      }
      if {[catch {set_property IOB TRUE $c} err]} {
        puts "IOB_TRUE_BTN_FANOUT_WARN $c $err"
      } else {
        incr n
        puts "IOB_TRUE_BTN_FANOUT=[get_property NAME $c]"
      }
    }
  }
  puts "IOB_TRUE_APPLIED=$n"
  return $n
}

proc astra_uart_iobff_extract {out} {
  set rx_name ""
  set tx_name ""
  set rx_bel ""
  set tx_bel ""
  set rx_loc ""
  set tx_loc ""
  set rx_iobp ""
  set tx_iobp ""
  set rx_pack "NO"
  set tx_pack "NO"
  set util_iobff "NA"
  set util_ilogic "NA"
  set util_ologic "NA"

  set rc [astra_pick_cell *uart_rx_iob_reg*]
  if {$rc eq ""} {
    set fan [all_fanout -quiet -flat -endpoints_only -only_cells [get_ports -quiet uart_txd_in]]
    if {[llength $fan]} { set rc [lindex $fan 0] }
  }
  set tc [astra_pick_cell *uart_tx_iob_reg*]
  if {$tc eq ""} {
    set fan [all_fanin -quiet -flat -startpoints_only -only_cells [get_ports -quiet uart_rxd_out]]
    if {[llength $fan]} { set tc [lindex $fan 0] }
  }
  if {$rc ne ""} {
    set rx_name [get_property NAME $rc]
    set rx_bel  [get_property BEL $rc]
    set rx_loc  [get_property LOC $rc]
    catch {set rx_iobp [get_property IOB $rc]}
    if {[astra_iob_site_packed $rx_bel $rx_loc]} { set rx_pack "YES" }
  }
  if {$tc ne ""} {
    set tx_name [get_property NAME $tc]
    set tx_bel  [get_property BEL $tc]
    set tx_loc  [get_property LOC $tc]
    catch {set tx_iobp [get_property IOB $tc]}
    if {[astra_iob_site_packed $tx_bel $tx_loc]} { set tx_pack "YES" }
  }

  global bag
  set urpt [file join $bag util_route.rpt]
  if {![file exists $urpt]} { set urpt [file join $bag util_place.rpt] }
  if {[file exists $urpt]} {
    set fh [open $urpt r]
    set txt [read $fh]
    close $fh
    foreach line [split $txt "\n"] {
      if {[regexp {^\|\s*IOB Flip Flops\s+\|\s+([0-9]+)} $line -> v]} { set util_iobff $v }
      if {[regexp {^\|\s*ILOGIC\s+\|\s+([0-9]+)} $line -> v]} { set util_ilogic $v }
      if {[regexp {^\|\s*OLOGIC\s+\|\s+([0-9]+)} $line -> v]} { set util_ologic $v }
    }
  }

  set packed "NO"
  if {$rx_pack eq "YES" && $tx_pack eq "YES"} { set packed "YES" }

  set of [open $out w]
  puts $of "UART_RX_IOB_CELL=$rx_name"
  puts $of "UART_RX_IOB_BEL=$rx_bel"
  puts $of "UART_RX_IOB_LOC=$rx_loc"
  puts $of "UART_RX_IOB_PROP=$rx_iobp"
  puts $of "UART_RX_IOB_PACKED=$rx_pack"
  puts $of "UART_TX_IOB_CELL=$tx_name"
  puts $of "UART_TX_IOB_BEL=$tx_bel"
  puts $of "UART_TX_IOB_LOC=$tx_loc"
  puts $of "UART_TX_IOB_PROP=$tx_iobp"
  puts $of "UART_TX_IOB_PACKED=$tx_pack"
  puts $of "UTIL_IOB_FLIP_FLOPS=$util_iobff"
  puts $of "UTIL_ILOGIC=$util_ilogic"
  puts $of "UTIL_OLOGIC=$util_ologic"
  puts $of "UART_IOBFF=$packed"
  puts $of "PROGRAM=NO"
  close $of
  return [list $packed $rx_pack $tx_pack $rx_name $rx_bel $rx_loc $tx_name $tx_bel $tx_loc]
}

proc astra_apply_led_iodelay {} {
  global ledxdc bag
  if {![file exists $ledxdc]} {
    astra_fail FILE_MISSING $ledxdc
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  if {![llength [get_clocks -quiet clk50u]]} {
    astra_fail LED_IODELAY_CLK "clk50u missing; LED delays cannot bind"
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  if {[catch {read_xdc $ledxdc} err]} {
    astra_fail LED_IODELAY_XDC $err
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  puts "LED_IODELAY_APPLIED clk50u PERIOD=[get_property PERIOD [get_clocks clk50u]] MAX=2.000 MIN=0.500"
  return 1
}

proc astra_led_iob_extract {rpt out} {
  set h5 "NO"
  set j5 "NO"
  set t9 "NO"
  set t10 "NO"
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    if {[regexp {\|\s*H5\s+\|\s+led\[0\]\s+\|} $txt]} { set h5 "YES" }
    if {[regexp {\|\s*J5\s+\|\s+led\[1\]\s+\|} $txt]} { set j5 "YES" }
    if {[regexp {\|\s*T9\s+\|\s+led\[2\]\s+\|} $txt]} { set t9 "YES" }
    if {[regexp {\|\s*T10\s+\|\s+led\[3\]\s+\|} $txt]} { set t10 "YES" }
  }
  set of [open $out w]
  puts $of "LED0_H5_LD4=$h5"
  puts $of "LED1_J5_LD5=$j5"
  puts $of "LED2_T9_LD6=$t9"
  puts $of "LED3_T10_LD7=$t10"
  if {$h5 eq "YES" && $j5 eq "YES" && $t9 eq "YES" && $t10 eq "YES"} {
    puts $of "LED_IOB=YES"
  } else {
    puts $of "LED_IOB=NO"
  }
  puts $of "CITE=constraints/arty_a7_100.xdc"
  puts $of "PROGRAM=NO"
  close $of
  return [list $h5 $j5 $t9 $t10]
}

proc astra_led_iodelay_extract {out} {
  global bag
  set out_su [astra_path_slack -to [get_ports -quiet {led[*]}] -setup]
  set out_ho [astra_path_slack -to [get_ports -quiet {led[*]}] -hold]
  set clk50 "NO"
  set per "NA"
  if {[llength [get_clocks -quiet clk50u]]} {
    set clk50 "YES"
    set per [get_property PERIOD [get_clocks clk50u]]
  }
  set of [open $out w]
  puts $of "LED_OUT_MAX_NS=2.000"
  puts $of "LED_OUT_MIN_NS=0.500"
  puts $of "LED_CLK_REF=clk50u"
  puts $of "LED_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD"
  puts $of "PIPE_CLK50U=$clk50"
  puts $of "PIPE_PERIOD_NS=$per"
  puts $of "LED_OUT_SETUP_SLACK=$out_su"
  puts $of "LED_OUT_HOLD_SLACK=$out_ho"
  puts $of "PROGRAM=NO"
  close $of
  return [list $out_su $out_ho $clk50]
}

proc astra_led_iobff_extract {out} {
  set n 0
  set packed_n 0
  set lines {}
  set cells [get_cells -quiet -hierarchical -filter {NAME =~ *led_q_reg*}]
  foreach c $cells {
    incr n
    set nm  [get_property NAME $c]
    set bel [get_property BEL $c]
    set loc [get_property LOC $c]
    set iobp ""
    catch {set iobp [get_property IOB $c]}
    set pack "NO"
    if {[astra_iob_site_packed $bel $loc]} {
      set pack "YES"
      incr packed_n
    }
    lappend lines "LED_CELL=$nm BEL=$bel LOC=$loc IOB=$iobp PACKED=$pack"
  }
  set packed "NO"
  if {$n >= 4 && $packed_n >= 4} { set packed "YES" }
  set of [open $out w]
  puts $of "LED_IOBFF_CELLS=$n"
  puts $of "LED_IOBFF_PACKED_CELLS=$packed_n"
  puts $of "LED_IOBFF=$packed"
  foreach ln $lines { puts $of $ln }
  puts $of "PROGRAM=NO"
  close $of
  return [list $packed $n $packed_n]
}

proc astra_apply_btn_iodelay {} {
  global btnxdc bag
  if {![file exists $btnxdc]} {
    astra_fail FILE_MISSING $btnxdc
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  if {![llength [get_clocks -quiet clk50u]]} {
    astra_fail BTN_IODELAY_CLK "clk50u missing; BTN delays cannot bind"
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  if {[catch {read_xdc $btnxdc} err]} {
    astra_fail BTN_IODELAY_XDC $err
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  puts "BTN_IODELAY_APPLIED clk50u PERIOD=[get_property PERIOD [get_clocks clk50u]] MAX=2.000 MIN=0.500"
  return 1
}

proc astra_btn_iob_extract {rpt out} {
  set d9 "NO"
  set c9 "NO"
  set b9 "NO"
  set b8 "NO"
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    if {[regexp {\|\s*D9\s+\|\s+btn\[0\]\s+\|} $txt]} { set d9 "YES" }
    if {[regexp {\|\s*C9\s+\|\s+btn\[1\]\s+\|} $txt]} { set c9 "YES" }
    if {[regexp {\|\s*B9\s+\|\s+btn\[2\]\s+\|} $txt]} { set b9 "YES" }
    if {[regexp {\|\s*B8\s+\|\s+btn\[3\]\s+\|} $txt]} { set b8 "YES" }
  }
  set of [open $out w]
  puts $of "BTN0_D9=$d9"
  puts $of "BTN1_C9=$c9"
  puts $of "BTN2_B9=$b9"
  puts $of "BTN3_B8=$b8"
  if {$d9 eq "YES" && $c9 eq "YES" && $b9 eq "YES" && $b8 eq "YES"} {
    puts $of "BTN_IOB=YES"
  } else {
    puts $of "BTN_IOB=NO"
  }
  puts $of "CITE=constraints/arty_a7_100.xdc"
  puts $of "PROGRAM=NO"
  close $of
  return [list $d9 $c9 $b9 $b8]
}

proc astra_btn_iodelay_extract {out} {
  global bag
  set in_su [astra_path_slack -from [get_ports -quiet {btn[*]}] -setup]
  set in_ho [astra_path_slack -from [get_ports -quiet {btn[*]}] -hold]
  set clk50 "NO"
  set per "NA"
  if {[llength [get_clocks -quiet clk50u]]} {
    set clk50 "YES"
    set per [get_property PERIOD [get_clocks clk50u]]
  }
  set of [open $out w]
  puts $of "BTN_IN_MAX_NS=2.000"
  puts $of "BTN_IN_MIN_NS=0.500"
  puts $of "BTN_CLK_REF=clk50u"
  puts $of "BTN_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD"
  puts $of "PIPE_CLK50U=$clk50"
  puts $of "PIPE_PERIOD_NS=$per"
  puts $of "BTN_IN_SETUP_SLACK=$in_su"
  puts $of "BTN_IN_HOLD_SLACK=$in_ho"
  puts $of "PROGRAM=NO"
  close $of
  return [list $in_su $in_ho $clk50]
}

proc astra_btn_iobff_extract {out} {
  set n 0
  set packed_n 0
  set lines {}
  set cells [get_cells -quiet -hierarchical -filter {NAME =~ *btn_q_reg*}]
  foreach c $cells {
    incr n
    set nm  [get_property NAME $c]
    set bel [get_property BEL $c]
    set loc [get_property LOC $c]
    set iobp ""
    catch {set iobp [get_property IOB $c]}
    set pack "NO"
    if {[astra_iob_site_packed $bel $loc]} {
      set pack "YES"
      incr packed_n
    }
    lappend lines "BTN_CELL=$nm BEL=$bel LOC=$loc IOB=$iobp PACKED=$pack"
  }
  set packed "NO"
  if {$n >= 4 && $packed_n >= 4} { set packed "YES" }
  set of [open $out w]
  puts $of "BTN_IOBFF_CELLS=$n"
  puts $of "BTN_IOBFF_PACKED_CELLS=$packed_n"
  puts $of "BTN_IOBFF=$packed"
  foreach ln $lines { puts $of $ln }
  puts $of "PROGRAM=NO"
  close $of
  return [list $packed $n $packed_n]
}

proc astra_btn_idelaye2_extract {out} {
  set n 0
  set tap_ok 0
  set taps {}
  set lines {}
  set cells [get_cells -quiet -hierarchical -filter {REF_NAME == IDELAYE2 || ORIG_REF_NAME == IDELAYE2}]
  foreach c $cells {
    incr n
    set nm [get_property NAME $c]
    set tv ""
    set ty ""
    set rf ""
    catch {set tv [get_property IDELAY_VALUE $c]}
    catch {set ty [get_property IDELAY_TYPE $c]}
    catch {set rf [get_property REFCLK_FREQUENCY $c]}
    if {![catch {expr {int($tv) == 31}} cmp] && $cmp} { incr tap_ok }
    lappend taps $tv
    lappend lines "IDELAYE2_CELL=$nm IDELAY_VALUE=$tv IDELAY_TYPE=$ty REFCLK_FREQUENCY=$rf"
  }
  set nc 0
  set clines {}
  set ctrls [get_cells -quiet -hierarchical -filter {REF_NAME == IDELAYCTRL || ORIG_REF_NAME == IDELAYCTRL}]
  foreach c $ctrls {
    incr nc
    set nm [get_property NAME $c]
    lappend clines "IDELAYCTRL_CELL=$nm"
  }
  set ok "NO"
  if {$n >= 4 && $tap_ok >= 4 && $nc >= 1} { set ok "YES" }
  set of [open $out w]
  puts $of "BTN_IDELAY_VALUE_PREREG=31"
  puts $of "BTN_IDELAY_TYPE=FIXED"
  puts $of "BTN_IDELAY_REFCLK_MHZ=200.0"
  puts $of "BTN_IODELAY_GROUP=ASTRA_BTN_IDELAY"
  puts $of "IDELAYE2_CELLS=$n"
  puts $of "IDELAYE2_TAP31_CELLS=$tap_ok"
  puts $of "IDELAYCTRL_CELLS=$nc"
  puts $of "BTN_IDELAYE2=$ok"
  foreach ln $lines { puts $of $ln }
  foreach ln $clines { puts $of $ln }
  puts $of "PROGRAM=NO"
  close $of
  return [list $ok $n $tap_ok $nc]
}

foreach f $files {
  set bn [file tail $f]
  if {$bn eq "a7ng_astra09_pipe.sv" || $bn eq "arty_a7_astra09_soc_top.sv" ||
      $bn eq "arty_a7_astra_rtp_soc_top.sv" ||
      $bn eq "a7ng_astra_09_integ_path.sv" ||
      $bn eq "a7ng_astra_09_r3_uart_wrap.sv" ||
      $bn eq "a7ng_astra_09_r7_uart_query_rew_wrap.sv" ||
      $bn eq "a7ng_astra_09_r7_axi_plant.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_impl_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_iodelay_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_iobff_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_iobff_hold_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_iobff_plant.sv" ||
      $bn eq "a7ng_astra_11_a09r3_uart_iobff_hold_plant.sv" ||
      $bn eq "a7ng_astra_11_a09r7_uart_impl_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r7_uart_impl_plant.sv" ||
      $bn eq "a7ng_astra_11_a09r7_led_io_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r7_led_io_plant.sv" ||
      $bn eq "a7ng_astra_11_a09r7_btn_io_wrap.sv" ||
      $bn eq "a7ng_astra_11_a09r7_btn_io_plant.sv" ||
      [string match *pipe_r1* $bn] || [string match *plant128* $bn] ||
      [string match *axi_bram128* $bn]} {
    astra_fail FORBIDDEN_DUT $f
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
}

set_param general.maxThreads 8
create_project -in_memory -part $part
if {[llength [info commands write_bitstream]]} {
  rename write_bitstream _hidden_write_bitstream
  proc write_bitstream {args} { astra_forbid_bit }
}
set_property include_dirs [list $incq $incc $inci $bag] [current_fileset]
foreach f $files {
  if {![file exists $f]} {
    astra_fail FILE_MISSING $f
    puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
    exit 1
  }
  read_verilog -sv $f
}
if {![file exists $xdc]} {
  astra_fail FILE_MISSING $xdc
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {![file exists $ledxdc]} {
  astra_fail FILE_MISSING $ledxdc
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {![file exists $btnxdc]} {
  astra_fail FILE_MISSING $btnxdc
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
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
puts "LED0=H5 LD4"
puts "LED1=J5 LD5"
puts "LED2=T9 LD6"
puts "LED3=T10 LD7"
puts "BTN0=D9 BTN0"
puts "BTN1=C9 BTN1"
puts "BTN2=B9 BTN2"
puts "BTN3=B8 BTN3"
puts "BTN_CITE=constraints/arty_a7_100.xdc"
puts "LED_CITE=constraints/arty_a7_100.xdc"
puts "PIPE_CLK=MMCM_100_to_50 period=20.000ns"
puts "UART_IO_VCLK=uart_io_vclk period=20.000ns"
puts "UART_IN_MAX_NS=2.000 UART_IN_MIN_NS=0.500"
puts "UART_OUT_MAX_NS=2.000 UART_OUT_MIN_NS=0.500"
puts "LED_OUT_MAX_NS=2.000 LED_OUT_MIN_NS=0.500 LED_CLK_REF=clk50u"
puts "BTN_IN_MAX_NS=2.000 BTN_IN_MIN_NS=0.500 BTN_CLK_REF=clk50u"
puts "BTN_IDELAY_VALUE=31"
puts "BTN_IDELAY_TYPE=FIXED"
puts "BTN_IDELAY_REFCLK_MHZ=200.0"
puts "BTN_IDELAYCTRL=YES"
puts "BTN_IODELAY_GROUP=ASTRA_BTN_IDELAY"
puts "HOLD_POLICY=FALSE_PATH_HOLD_ASYNC_UART"
puts "LED_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD"
puts "BTN_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD"
puts "UART_IOBFF_POLICY=IOB=TRUE wrap uart_rx_iob/uart_tx_iob"
puts "LED_IOBFF_POLICY=IOB=TRUE wrap led_q"
puts "BTN_IOBFF_POLICY=IOB=TRUE wrap btn_q after IDELAYE2"
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
  puts ASTRA_11_A09R7_BTN_IDELAY_SYNTH_FAIL
  exit 1
}

file mkdir [file join $bag ckpt]
if {[catch {write_checkpoint -force [file join $bag ckpt synth.dcp]}]} {}
if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
astra_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
astra_timing_extract [file join $bag timing_synth.rpt] [file join $bag TIMING_EXTRACT_SYNTH.txt] Synthesized
puts ASTRA_11_A09R7_BTN_IDELAY_SYNTH_DONE
if {![llength [get_clocks -quiet uart_io_vclk]]} {
  astra_fail UART_IODELAY_CLK "uart_io_vclk missing after synth; I/O delays not bound"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
puts "UART_IO_VCLK_AFTER_SYNTH=YES PERIOD=[get_property PERIOD [get_clocks uart_io_vclk]]"
if {![llength [get_clocks -quiet clk50u]]} {
  astra_fail LED_IODELAY_CLK "clk50u missing after synth; LED delays not bound"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
puts "CLK50U_AFTER_SYNTH=YES PERIOD=[get_property PERIOD [get_clocks clk50u]]"
astra_apply_led_iodelay
astra_apply_btn_iodelay
astra_apply_hold_policy
astra_force_iob_true
if {[catch {
  set _idg [get_cells -quiet -hierarchical -filter {REF_NAME == IDELAYE2 || REF_NAME == IDELAYCTRL || ORIG_REF_NAME == IDELAYE2 || ORIG_REF_NAME == IDELAYCTRL}]
  if {[llength $_idg]} {
    set_property IODELAY_GROUP ASTRA_BTN_IDELAY $_idg
    puts "IODELAY_GROUP_APPLIED=[llength $_idg]"
  }
} idgerr]} {
  puts "IODELAY_GROUP_WARN $idgerr"
}

set cells [get_cells -quiet -hierarchical -filter {NAME =~ *u_a09r2*}]
puts "U_A09R2_CELLS=[llength $cells]"
if {[llength $cells] == 0} {
  astra_fail DUT_MISSING "no hierarchical cells matching *u_a09r2*"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
set urx [get_cells -quiet -hierarchical -filter {NAME =~ *u_rx*}]
set utx [get_cells -quiet -hierarchical -filter {NAME =~ *u_tx*}]
puts "U_RX_CELLS=[llength $urx]"
puts "U_TX_CELLS=[llength $utx]"
if {[llength $urx] == 0 || [llength $utx] == 0} {
  astra_fail UART_MISSING "uart_rx/uart_tx cells missing urx=[llength $urx] utx=[llength $utx]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
set iobff_cells [get_cells -quiet -hierarchical -filter {NAME =~ *uart_rx_iob_reg* || NAME =~ *uart_tx_iob_reg*}]
puts "UART_IOBFF_CELLS=[llength $iobff_cells]"
if {[llength $iobff_cells] < 2} {
  puts "UART_IOBFF_CELLS_WARN count=[llength $iobff_cells] (IOB FF if it still packs; not a hard abort)"
}
set ledff_cells [get_cells -quiet -hierarchical -filter {NAME =~ *led_q_reg*}]
puts "LED_IOBFF_CELLS=[llength $ledff_cells]"
if {[llength $ledff_cells] < 4} {
  puts "LED_IOBFF_CELLS_WARN count=[llength $ledff_cells] (LED IOB FF if it still packs; not a hard abort)"
}
set btnff_cells [get_cells -quiet -hierarchical -filter {NAME =~ *btn_q_reg*}]
puts "BTN_IOBFF_CELLS=[llength $btnff_cells]"
if {[llength $btnff_cells] < 4} {
  puts "BTN_IOBFF_CELLS_WARN count=[llength $btnff_cells] (BTN IOB FF if it still packs; not a hard abort)"
}
set idel_cells [get_cells -quiet -hierarchical -filter {REF_NAME == IDELAYE2 || ORIG_REF_NAME == IDELAYE2}]
set idc_cells [get_cells -quiet -hierarchical -filter {REF_NAME == IDELAYCTRL || ORIG_REF_NAME == IDELAYCTRL}]
puts "BTN_IDELAYE2_CELLS=[llength $idel_cells]"
puts "BTN_IDELAYCTRL_CELLS=[llength $idc_cells]"
if {[llength $idel_cells] < 4 || [llength $idc_cells] < 1} {
  astra_fail BTN_IDELAYE2_MISSING "IDELAYE2=[llength $idel_cells] IDELAYCTRL=[llength $idc_cells] (need >=4 and >=1)"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
set bad09 [get_cells -quiet -hierarchical -filter {REF_NAME =~ *astra09_pipe* || ORIG_REF_NAME =~ *astra09_pipe*}]
if {[llength $bad09]} {
  astra_fail FORBIDDEN_DUT "astra09_pipe cell in netlist: $bad09"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
set badbram [get_cells -quiet -hierarchical -filter {REF_NAME =~ *axi_bram128* || ORIG_REF_NAME =~ *axi_bram128*}]
if {[llength $badbram]} {
  astra_fail FORBIDDEN_DUT "axi_bram128 cell in netlist: $badbram"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
set bada09 [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_09_integ_path || ORIG_REF_NAME == a7ng_astra_09_integ_path}]
if {[llength $bada09]} {
  astra_fail FORBIDDEN_DUT "frozen a7ng_astra_09_integ_path cell in netlist: $bada09"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}

if {[catch {opt_design} err]} {
  astra_fail OPT $err
  puts ASTRA_11_A09R7_BTN_IDELAY_OPT_FAIL
  exit 1
}
astra_force_iob_true
astra_apply_hold_policy
puts ASTRA_11_A09R7_BTN_IDELAY_OPT_DONE

if {[catch {place_design} err]} {
  astra_fail PLACE $err
  if {[catch {report_utilization -file [file join $bag util_place.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_place.rpt]}]} {}
  if {[catch {report_drc -file [file join $bag drc.rpt]}]} {}
  astra_util_extract [file join $bag util_place.rpt] [file join $bag UTIL_EXTRACT.txt] Placed
  astra_timing_extract [file join $bag timing_place.rpt] [file join $bag TIMING_EXTRACT.txt] Placed
  puts ASTRA_11_A09R7_BTN_IDELAY_PLACE_FAIL
  exit 1
}
if {[catch {phys_opt_design} err]} {
  puts "PHYS_OPT_WARN $err"
}
astra_apply_hold_policy
puts ASTRA_11_A09R7_BTN_IDELAY_PLACE_DONE

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
  astra_uart_iobff_extract [file join $bag UART_IOBFF.txt]
  astra_led_iob_extract [file join $bag io.rpt] [file join $bag LED_IOB.txt]
  astra_led_iodelay_extract [file join $bag LED_IODELAY.txt]
  astra_led_iobff_extract [file join $bag LED_IOBFF.txt]
  astra_btn_iob_extract [file join $bag io.rpt] [file join $bag BTN_IOB.txt]
  astra_btn_iodelay_extract [file join $bag BTN_IODELAY.txt]
  astra_btn_iobff_extract [file join $bag BTN_IOBFF.txt]
  astra_btn_idelaye2_extract [file join $bag BTN_IDELAYE2.txt]
  puts ASTRA_11_A09R7_BTN_IDELAY_ROUTE_FAIL
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
if {[catch {report_exceptions -file [file join $bag exceptions_route.rpt]}]} {}
if {[catch {report_timing -from [get_ports uart_txd_in] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_in.rpt]}]} {}
if {[catch {report_timing -to [get_ports uart_rxd_out] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_out.rpt]}]} {}
if {[catch {report_timing -to [get_ports {led[*]}] -delay_type min_max -max_paths 8 -file [file join $bag timing_led_out.rpt]}]} {}
if {[catch {report_timing -from [get_ports {btn[*]}] -delay_type min_max -max_paths 8 -file [file join $bag timing_btn_in.rpt]}]} {}
astra_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Routed
set tex [astra_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Routed]
set iob [astra_uart_iob_extract [file join $bag io.rpt] [file join $bag UART_IOB.txt]]
set iod [astra_uart_iodelay_extract [file join $bag UART_IODELAY.txt]]
set iff [astra_uart_iobff_extract [file join $bag UART_IOBFF.txt]]
set liob [astra_led_iob_extract [file join $bag io.rpt] [file join $bag LED_IOB.txt]]
set liod [astra_led_iodelay_extract [file join $bag LED_IODELAY.txt]]
set liff [astra_led_iobff_extract [file join $bag LED_IOBFF.txt]]
set biob [astra_btn_iob_extract [file join $bag io.rpt] [file join $bag BTN_IOB.txt]]
set biod [astra_btn_iodelay_extract [file join $bag BTN_IODELAY.txt]]
set biff [astra_btn_iobff_extract [file join $bag BTN_IOBFF.txt]]
set bidel [astra_btn_idelaye2_extract [file join $bag BTN_IDELAYE2.txt]]
set a9  [lindex $iob 0]
set d10 [lindex $iob 1]
set packed [lindex $iff 0]
set led_iob "NO"
if {[lindex $liob 0] eq "YES" && [lindex $liob 1] eq "YES" && [lindex $liob 2] eq "YES" && [lindex $liob 3] eq "YES"} {
  set led_iob "YES"
}
set led_packed [lindex $liff 0]
set btn_iob "NO"
if {[lindex $biob 0] eq "YES" && [lindex $biob 1] eq "YES" && [lindex $biob 2] eq "YES" && [lindex $biob 3] eq "YES"} {
  set btn_iob "YES"
}
set btn_packed [lindex $biff 0]
puts "UART_IOB A9=$a9 D10=$d10"
puts "UART_IODELAY IN_SU=[lindex $iod 0] IN_HO=[lindex $iod 1] OUT_SU=[lindex $iod 2] OUT_HO=[lindex $iod 3] VCLK=[lindex $iod 4] CLK50=[lindex $iod 5]"
puts "UART_IOBFF=$packed RX=[lindex $iff 1] TX=[lindex $iff 2] RX_BEL=[lindex $iff 4] RX_LOC=[lindex $iff 5] TX_BEL=[lindex $iff 7] TX_LOC=[lindex $iff 8]"
puts "LED_IOB H5=[lindex $liob 0] J5=[lindex $liob 1] T9=[lindex $liob 2] T10=[lindex $liob 3] LED_IOB=$led_iob"
puts "LED_IODELAY OUT_SU=[lindex $liod 0] OUT_HO=[lindex $liod 1] CLK50=[lindex $liod 2]"
puts "LED_IOBFF=$led_packed CELLS=[lindex $liff 1] PACKED_CELLS=[lindex $liff 2]"
puts "BTN_IOB D9=[lindex $biob 0] C9=[lindex $biob 1] B9=[lindex $biob 2] B8=[lindex $biob 3] BTN_IOB=$btn_iob"
puts "BTN_IODELAY IN_SU=[lindex $biod 0] IN_HO=[lindex $biod 1] CLK50=[lindex $biod 2]"
puts "BTN_IOBFF=$btn_packed CELLS=[lindex $biff 1] PACKED_CELLS=[lindex $biff 2]"
puts "BTN_IDELAYE2=[lindex $bidel 0] CELLS=[lindex $bidel 1] TAP31=[lindex $bidel 2] IDELAYCTRL=[lindex $bidel 3]"
if {$a9 ne "YES" || $d10 ne "YES"} {
  astra_fail UART_IOB "io.rpt missing UART IOB A9=$a9 D10=$d10"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {$led_iob ne "YES"} {
  astra_fail LED_IOB "io.rpt missing LED IOB H5/J5/T9/T10 H5=[lindex $liob 0] J5=[lindex $liob 1] T9=[lindex $liob 2] T10=[lindex $liob 3]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {$btn_iob ne "YES"} {
  astra_fail BTN_IOB "io.rpt missing BTN IOB D9/C9/B9/B8 D9=[lindex $biob 0] C9=[lindex $biob 1] B9=[lindex $biob 2] B8=[lindex $biob 3]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {[lindex $iod 4] ne "YES"} {
  astra_fail UART_IODELAY_CLK "uart_io_vclk missing after route"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {[lindex $iod 0] eq "NA" || [lindex $iod 2] eq "NA"} {
  astra_fail UART_IODELAY_PATH "UART I/O timing paths missing IN_SU=[lindex $iod 0] OUT_SU=[lindex $iod 2]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {[lindex $liod 0] eq "NA"} {
  astra_fail LED_IODELAY_PATH "LED I/O timing paths missing OUT_SU=[lindex $liod 0]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {[lindex $biod 0] eq "NA"} {
  astra_fail BTN_IODELAY_PATH "BTN I/O timing paths missing IN_SU=[lindex $biod 0]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {[lindex $bidel 0] ne "YES"} {
  astra_fail BTN_IDELAYE2 "IDELAYE2 tap31 freeze missing CELLS=[lindex $bidel 1] TAP31=[lindex $bidel 2] IDELAYCTRL=[lindex $bidel 3]"
  puts ASTRA_11_A09R7_BTN_IDELAY_ABORTED
  exit 1
}
if {$packed ne "YES"} {
  puts "UART_IOBFF_UNPACKED RX=[lindex $iff 1] TX=[lindex $iff 2] RX_LOC=[lindex $iff 5] TX_LOC=[lindex $iff 8] (IOB FF if it still packs; not a hard abort)"
}
if {$led_packed ne "YES"} {
  puts "LED_IOBFF_UNPACKED CELLS=[lindex $liff 1] PACKED=[lindex $liff 2] (LED IOB FF if it still packs; not a hard abort)"
}
if {$btn_packed ne "YES"} {
  puts "BTN_IOBFF_UNPACKED CELLS=[lindex $biff 1] PACKED=[lindex $biff 2] (BTN IOB FF if it still packs; not a hard abort)"
}
set wns [lindex $tex 0]
set tns [lindex $tex 1]
set whs [lindex $tex 2]
set ths [lindex $tex 3]
puts "ASTRA_11_A09R7_BTN_IDELAY_ROUTE_DONE WNS=$wns TNS=$tns WHS=$whs THS=$ths BTN_IOB=YES LED_IOB=YES UART_IOB=YES UART_IOBFF=$packed LED_IOBFF=$led_packed BTN_IOBFF=$btn_packed BTN_IDELAYE2=[lindex $bidel 0] TAP=31 REFCLK=200 PROGRAM=NO BIT=NOT_BUILT"

set wns_num ""
set whs_num ""
if {[catch {set wns_num [expr {double($wns)}]}]} {
  set wns_num ""
}
if {[catch {set whs_num [expr {double($whs)}]}]} {
  set whs_num ""
}

set fail_whs 0
set fail_wns 0
if {$whs_num ne "" && $whs_num < 0.0} { set fail_whs 1 }
if {$wns_num ne "" && $wns_num < 0.0} { set fail_wns 1 }

if {$fail_whs || $fail_wns} {
  if {$fail_whs} {
    astra_fail WHS_NEG "routed WHS=$whs < 0; bag FAIL; keep report; one bounded experiment"
  } elseif {$fail_wns} {
    astra_fail WNS_NEG "routed WNS=$wns < 0 at declared 50 MHz; bag FAIL; keep report; one bounded experiment"
  }
  astra_copy_fail_r0
  # phys_opt is exhausted on the FAIL bag (WNS>=0, IOB hold). Do not silently retune
  # IDELAY_VALUE here. The bounded TAP experiment is a new PREREG tap after this run.
  # Still 50 MHz. Still no bitstream. Do not invent delay numbers. Do not patch uart_rx.
  astra_apply_hold_policy
  if {[catch {phys_opt_design} e2]} {
    puts "ASTRA_11_A09R7_BTN_IDELAY_EXP_PHYS_OPT_WARN $e2"
  } else {
    puts ASTRA_11_A09R7_BTN_IDELAY_EXP_PHYS_OPT_DONE
  }
  if {[catch {report_timing_summary -file [file join $bag timing_route_exp.rpt]}]} {}
  if {[catch {report_utilization -file [file join $bag util_route_exp.rpt]}]} {}
  if {[catch {report_io -file [file join $bag io_exp.rpt]}]} {}
  if {[catch {report_exceptions -file [file join $bag exceptions_exp.rpt]}]} {}
  if {[catch {report_timing -from [get_ports uart_txd_in] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_in_exp.rpt]}]} {}
  if {[catch {report_timing -to [get_ports uart_rxd_out] -delay_type min_max -max_paths 4 -file [file join $bag timing_uart_out_exp.rpt]}]} {}
  if {[catch {report_timing -to [get_ports {led[*]}] -delay_type min_max -max_paths 8 -file [file join $bag timing_led_out_exp.rpt]}]} {}
  if {[catch {report_timing -from [get_ports {btn[*]}] -delay_type min_max -max_paths 8 -file [file join $bag timing_btn_in_exp.rpt]}]} {}
  astra_timing_extract [file join $bag timing_route_exp.rpt] [file join $bag TIMING_EXTRACT_EXP.txt] RoutedExp
  astra_util_extract [file join $bag util_route_exp.rpt] [file join $bag UTIL_EXTRACT_EXP.txt] RoutedExp
  astra_uart_iob_extract [file join $bag io_exp.rpt] [file join $bag UART_IOB_EXP.txt]
  astra_uart_iodelay_extract [file join $bag UART_IODELAY_EXP.txt]
  astra_uart_iobff_extract [file join $bag UART_IOBFF_EXP.txt]
  astra_led_iob_extract [file join $bag io_exp.rpt] [file join $bag LED_IOB_EXP.txt]
  astra_led_iodelay_extract [file join $bag LED_IODELAY_EXP.txt]
  astra_led_iobff_extract [file join $bag LED_IOBFF_EXP.txt]
  astra_btn_iob_extract [file join $bag io_exp.rpt] [file join $bag BTN_IOB_EXP.txt]
  astra_btn_iodelay_extract [file join $bag BTN_IODELAY_EXP.txt]
  astra_btn_iobff_extract [file join $bag BTN_IOBFF_EXP.txt]
  astra_btn_idelaye2_extract [file join $bag BTN_IDELAYE2_EXP.txt]
  puts ASTRA_11_A09R7_BTN_IDELAY_EXP_DONE
  set result_tag FAIL_WHS
  if {$fail_whs && $fail_wns} {
    set result_tag FAIL_WHS_WNS
  } elseif {$fail_wns} {
    set result_tag FAIL_WNS
  }
  puts "ASTRA_11_A09R7_BTN_IDELAY_DONE WNS=$wns WHS=$whs BTN_IOB=$btn_iob LED_IOB=$led_iob UART_IOB=YES UART_IOBFF=$packed LED_IOBFF=$led_packed BTN_IOBFF=$btn_packed BTN_IDELAYE2=[lindex $bidel 0] TAP=31 REFCLK=200 BIT=NOT_BUILT PROGRAM=NO RESULT=$result_tag PRODUCTION_TOP=UNKNOWN"
  exit 0
}

puts "ASTRA_11_A09R7_BTN_IDELAY_DONE WNS=$wns TNS=$tns WHS=$whs BTN_IOB=YES LED_IOB=YES UART_IOB=YES UART_IOBFF=$packed LED_IOBFF=$led_packed BTN_IOBFF=$btn_packed BTN_IDELAYE2=[lindex $bidel 0] TAP=31 REFCLK=200 BIT=NOT_BUILT PROGRAM=NO PRODUCTION_TOP=UNKNOWN"
exit 0
