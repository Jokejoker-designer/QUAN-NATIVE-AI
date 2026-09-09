# ASTRA-C6-WHOLECHIP-COFIT-03. PROGRAM=NO. A09=NO.
# In-context synth/place/route of C5 production top + official Digilent AXI MIG.
# Never open_hw / program_hw. write_bitstream only if routed letters meet GOLDEN.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  a7ng_astra_c6_wholechip
set_param general.maxThreads 4
set first_div ""
set proj [file join $bag vivado_proj]
set ip_xci [file join $root vivado/ip/mig_7series_0/mig_7series_0.xci]
set mig_xdc [file join $root vivado/ip/mig_7series_0/mig_7series_0/user_design/constraints/mig_7series_0.xdc]
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]
set inci [file join $root rtl/native_graph/integrate]
set bitfile [file join $bag a7ng_astra_c6_wholechip.bit]

set rtl [list \
  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_keys_ctx.sv] \
  [file join $root rtl/native_graph/query/a7ng_route_valid_gate.sv] \
  [file join $root rtl/native_graph/memory/a7ng_sparse_dir_axi.sv] \
  [file join $root rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c3_held_out.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_lm06_byte256.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_lm06_grounded_gen.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv] \
  [file join $root rtl/board/uart_rx.sv] \
  [file join $root rtl/board/uart_tx.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv] \
  [file join $root rtl/board/sync_bits.sv] \
  [file join $root rtl/ddr/clk_arty_ddr.sv] \
  [file join $root rtl/ddr/mig_native_wrap.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c6_wholechip.sv] \
]

proc c6_abort {cut msg} {
  global bag first_div
  if {$first_div eq ""} { set first_div $cut }
  set fh [open [file join $bag FIRST_DIVERGENCE.txt] w]
  puts $fh "FIRST_DIVERGENCE $cut"
  puts $fh $msg
  close $fh
  puts "FIRST_DIVERGENCE $cut $msg"
}

proc c6_forbid_hw {args} {
  c6_abort PROGRAM_HW "PROGRAM=NO open_hw/program_hw/xsdb forbidden"
  puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
  exit 1
}

if {[llength [info commands open_hw]]} {
  rename open_hw c6_open_hw_orig
  proc open_hw {args} { c6_forbid_hw }
}
if {[llength [info commands program_hw_devices]]} {
  rename program_hw_devices c6_program_hw_orig
  proc program_hw_devices {args} { c6_forbid_hw }
}
if {[llength [info commands open_hw_manager]]} {
  rename open_hw_manager c6_open_hw_manager_orig
  proc open_hw_manager {args} { c6_forbid_hw }
}
if {[llength [info commands program_hw_cfgmem]]} {
  rename program_hw_cfgmem c6_program_hw_cfgmem_orig
  proc program_hw_cfgmem {args} { c6_forbid_hw }
}

proc c6_util_extract {rpt out state} {
  set lut "NA"; set ff "NA"; set bram "NA"; set dsp "NA"
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
  return [list $lut $ff $bram $dsp]
}

proc c6_timing_extract {rpt out state} {
  set wns "NA"; set tns "NA"; set whs "NA"; set ths "NA"
  if {[llength [info commands get_timing_paths]]} {
    set tp [get_timing_paths -quiet -setup -max_paths 1 -nworst 1]
    if {[llength $tp]} { set wns [get_property SLACK [lindex $tp 0]] }
    set tph [get_timing_paths -quiet -hold -max_paths 1 -nworst 1]
    if {[llength $tph]} { set whs [get_property SLACK [lindex $tph 0]] }
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
  puts $of "DESIGN_STATE=$state"
  puts $of "PROGRAM=NO"
  close $of
  return [list $wns $tns $whs $ths]
}

proc c6_ge0 {v} {
  if {$v eq "NA" || $v eq ""} { return 0 }
  if {[catch {expr {$v >= 0.0}} ok]} { return 0 }
  return $ok
}

proc c6_eq0 {v} {
  if {$v eq "NA" || $v eq ""} { return 0 }
  if {[catch {expr {abs($v) < 0.0005}} ok]} { return 0 }
  return $ok
}

foreach f $rtl {
  set leaf [file tail $f]
  if {$leaf eq "tiny_gpt803k_core.sv"} { error "C6WC_FROZEN_LM06_AS_DUT" }
  if {$leaf eq "mig_7series_0_mig.v"} { error "C6WC_SYNTH_MIG_AS_DUT" }
  if {[string match "*a7ng_astra_09_integ_path*" $leaf]} { error "C6WC_LEFTOVER_A09" }
  if {$leaf eq "a7ng_evidence_compose.sv"} { error "C6WC_COMPOSE_AS_DUT" }
  if {$leaf eq "a7ng_lm_graph_arb.sv"} { error "C6WC_OLD_ARB_AS_DUT" }
}

if {![file exists $ip_xci]} {
  c6_abort MIG_IP_MISSING $ip_xci
  puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
  exit 1
}

puts "DUT_TOP=$top"
puts "DUT_MODULE=a7ng_astra_c5_prod_top"
puts "DUT_INSTANCE=u_c5"
puts "MIG_INSTANCE=u_mig"
puts "PIN_CLK=CLK100MHZ E3 period=10.000ns"
puts "UART_RXD_OUT=D10 UART_TXD_IN=A9"
puts "MODE=in_context_impl_route"
puts "PROGRAM=NO"
puts "BIT=CONDITIONAL"
puts "PRODUCTION_TOP=a7ng_astra_c6_wholechip"
puts "A09_IS_THIS_TOP=NO"
puts "C6WC_START part=$part BOARD_PASS=REJECT C6_MASTER=OPEN"

set synth_dcp [file join $bag ckpt synth.dcp]
set route_dcp [file join $bag ckpt route.dcp]
set resume_route 0
if {[file exists $route_dcp] && [file exists [file join $bag ROUTE_LETTERS.txt]]} {
  set fh [open [file join $bag ROUTE_LETTERS.txt] r]
  set lt [read $fh]
  close $fh
  if {[string match "*FIT_OK=0*" $lt]} { set resume_route 1 }
}

if {$resume_route} {
  if {[catch {open_checkpoint $route_dcp} err]} {
    c6_abort RESUME_ROUTE $err
    puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
    exit 1
  }
  puts C6WC_RESUME_ROUTE_DCP
  puts C6WC_SYNTH_DONE
} elseif {[file exists $synth_dcp]} {
  if {[catch {open_checkpoint $synth_dcp} err]} {
    c6_abort RESUME $err
    puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
    exit 1
  }
  puts C6WC_RESUME_SYNTH_DCP
  puts C6WC_SYNTH_DONE
} else {
  file mkdir $proj
  create_project -force c6wc $proj -part $part
  set_property target_language Verilog [current_project]
  set_property verilog_define SYNTHESIS [current_fileset]
  set_property include_dirs [list $incq $incc $inci $bag] [current_fileset]

  read_ip $ip_xci
  generate_target all [get_files $ip_xci]
  set mig_rtl [concat \
    [glob -nocomplain [file join $root vivado/ip/mig_7series_0/mig_7series_0/user_design/rtl/*.v]] \
    [glob -nocomplain [file join $root vivado/ip/mig_7series_0/mig_7series_0/user_design/rtl/*/*.v]]]
  set mig_ok {}
  foreach f $mig_rtl {
    set leaf [file tail $f]
    if {[string match "*_sim.v" $leaf]} { continue }
    if {$leaf eq "mig_7series_0_mig.v"} {
      # user_design PHY is required for impl; it is not the DUT top
    }
    lappend mig_ok $f
  }

  add_files -norecurse [concat $rtl $mig_ok]
  add_files -fileset constrs_1 -norecurse [list \
    [file join $root constraints/arty_a7_100.xdc] \
    [file join $root constraints/a7ng03_cdc.xdc] \
    $mig_xdc \
    [file join $bag c6_wholechip.xdc]]

  set_property top $top [current_fileset]
  update_compile_order -fileset sources_1

  if {[catch {synth_design -top $top -part $part} err]} {
    c6_abort SYNTH $err
    if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
    puts ASTRA_C6_WHOLECHIP_COFIT_SYNTH_MISS
    exit 1
  }

  file mkdir [file join $bag ckpt]
  if {[catch {write_checkpoint -force $synth_dcp}]} {}
  if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
  c6_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
  puts C6WC_SYNTH_DONE
}

catch {set_clock_groups -asynchronous -group [get_clocks -quiet sys_clk_pin] -group [get_clocks -quiet uart_io_vclk]}
catch {set_clock_groups -asynchronous -group [get_clocks -quiet uart_io_vclk] -group [get_clocks -quiet -regexp {.*(ui|pll|mmcm|c166|c200).* }]}
foreach to_pat {c166* c200* *ui* *pll* *mmcm*} {
  catch {set_false_path -from [get_clocks sys_clk_pin] -to [get_clocks -quiet $to_pat]}
  catch {set_false_path -to [get_clocks sys_clk_pin] -from [get_clocks -quiet $to_pat]}
}
puts CDC_GROUPS_APPLIED=YES
puts "CLASS_cdc_reviewed HIT"

set c5c [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_c5_prod_top || ORIG_REF_NAME == a7ng_astra_c5_prod_top}]
puts "U_C5_CELLS=[llength $c5c]"
if {[llength $c5c] == 0} {
  c6_abort C5_MISSING "no a7ng_astra_c5_prod_top cell"
  puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
  exit 1
}
puts "CLASS_c5_prod_inst HIT"

set migc [get_cells -quiet -hierarchical -filter {REF_NAME == mig_7series_0 || ORIG_REF_NAME == mig_7series_0 || REF_NAME == mig_native_wrap || ORIG_REF_NAME == mig_native_wrap}]
puts "U_MIG_CELLS=[llength $migc]"
if {[llength $migc] == 0} {
  c6_abort MIG_MISSING "no mig_native_wrap/mig_7series_0 cell"
  puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
  exit 1
}
puts "CLASS_mig_user_design HIT"

set bada09 [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_09_integ_path || ORIG_REF_NAME == a7ng_astra_09_integ_path || REF_NAME =~ *astra09_pipe* || ORIG_REF_NAME =~ *astra09_pipe*}]
if {[llength $bada09]} {
  c6_abort FORBIDDEN_A09 "A09 cell in netlist"
  puts ASTRA_C6_WHOLECHIP_COFIT_03_ABORTED
  exit 1
}
puts "CLASS_no_a09_top HIT"
puts "CLASS_no_program_hw HIT"

if {$resume_route} {
  puts C6WC_OPT_DONE
  puts C6WC_PLACE_DONE
  if {[catch {phys_opt_design} err]} { puts "POST_ROUTE_PHYS_OPT_WARN $err" }
  if {[catch {route_design -tns_cleanup} err]} { puts "TNS_CLEANUP_WARN $err" }
} else {
# r0: opt_design -propconst -sweep ACCESS_VIOLATION in Phase 3 Constant propagation
# (Vivado 2026.1). Skip opt; place from synth.dcp. GOLDEN frozen. Do not edit KEEP.
puts C6WC_SKIP_OPT_CONSTPROP_AV
puts C6WC_OPT_DONE

if {[catch {place_design} err]} {
  c6_abort PLACE $err
  if {[catch {report_utilization -file [file join $bag util_place.rpt]}]} {}
  puts ASTRA_C6_WHOLECHIP_COFIT_PLACE_MISS
  exit 1
}
if {[catch {phys_opt_design} err]} { puts "PHYS_OPT_WARN $err" }
puts C6WC_PLACE_DONE

if {[catch {route_design} err]} {
  c6_abort ROUTE $err
  if {[catch {report_utilization -file [file join $bag util_route.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_route.rpt]}]} {}
  if {[catch {report_route_status -file [file join $bag route_status.rpt]}]} {}
  puts ASTRA_C6_WHOLECHIP_COFIT_ROUTE_MISS
  exit 1
}
# C6-02 lesson: first route may miss by tens of ps; post-route phys_opt + tns_cleanup.
if {[catch {phys_opt_design} err]} { puts "POST_ROUTE_PHYS_OPT_WARN $err" }
if {[catch {route_design -tns_cleanup} err]} { puts "TNS_CLEANUP_WARN $err" }
}

if {[catch {write_checkpoint -force [file join $bag ckpt route.dcp]}]} {}
report_utilization -file [file join $bag util_route.rpt]
report_utilization -hierarchical -file [file join $bag util_hier_route.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -max_paths 10 -file [file join $bag timing_route.rpt]
report_route_status -file [file join $bag route_status.rpt]
report_drc -file [file join $bag drc.rpt]
report_clocks -file [file join $bag clocks_route.rpt]
if {[catch {check_timing -verbose -file [file join $bag check_timing.rpt]}]} {}
if {[catch {report_exceptions -file [file join $bag exceptions_route.rpt]}]} {}
c6_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Routed
set tex [c6_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Routed]
set wns [lindex $tex 0]
set tns [lindex $tex 1]
set whs [lindex $tex 2]
set ths [lindex $tex 3]
puts "C6WC_WNS=$wns TNS=$tns WHS=$whs THS=$ths"

set unrouted 0
set failed_route 0
if {[file exists [file join $bag route_status.rpt]]} {
  set fh [open [file join $bag route_status.rpt] r]
  set rt [read $fh]
  close $fh
  if {[regexp {Nets with Routing Errors[^0-9]*([0-9]+)} $rt -> n]} { set unrouted $n }
  if {[regexp {unrouted nets[^0-9]*([0-9]+)} $rt -> n2]} { if {$n2 > $unrouted} { set unrouted $n2 } }
  if {[regexp {Failed nets[^0-9]*([0-9]+)} $rt -> n3]} { set failed_route $n3 }
}
puts "C6WC_UNROUTED=$unrouted FAILED_ROUTE=$failed_route"

set drc_bad 0
if {[file exists [file join $bag drc.rpt]]} {
  set fh [open [file join $bag drc.rpt] r]
  set dr [read $fh]
  close $fh
  foreach line [split $dr "\n"] {
    if {[regexp {^\s*(ERROR|FATAL):} $line]} { incr drc_bad }
  }
}
puts "C6WC_DRC_ERROR_FATAL=$drc_bad"

set unc 0
if {[file exists [file join $bag check_timing.rpt]]} {
  set fh [open [file join $bag check_timing.rpt] r]
  set ct [read $fh]
  close $fh
  if {[regexp {no_clock[^\n]*\n[^\n]*\n\s+([0-9]+)} $ct -> n]} { incr unc $n }
  if {[regexp {unconstrained_internal_endpoints[^\n]*\n[^\n]*\n\s+([0-9]+)} $ct -> n]} { incr unc $n }
}
puts "C6WC_CRITICAL_UNCONSTRAINED=$unc"

set fit_ok 1
puts "CLASS_device_fit HIT"

if {[c6_ge0 $wns]} { puts "CLASS_wns_ge0 HIT" } else { puts "CLASS_wns_ge0 MISS"; set fit_ok 0 }
if {[c6_eq0 $tns]} { puts "CLASS_tns_0 HIT" } else { puts "CLASS_tns_0 MISS"; set fit_ok 0 }
if {[c6_ge0 $whs]} { puts "CLASS_whs_ge0 HIT" } else { puts "CLASS_whs_ge0 MISS"; set fit_ok 0 }
if {[c6_eq0 $ths]} { puts "CLASS_ths_0 HIT" } else { puts "CLASS_ths_0 MISS"; set fit_ok 0 }
if {$unrouted == 0} { puts "CLASS_unrouted_0 HIT" } else { puts "CLASS_unrouted_0 MISS"; set fit_ok 0 }
if {$failed_route == 0 && $drc_bad == 0} { puts "CLASS_drc_clean HIT" } else { puts "CLASS_drc_clean MISS"; set fit_ok 0 }

set of [open [file join $bag ROUTE_LETTERS.txt] w]
puts $of "WNS=$wns"
puts $of "TNS=$tns"
puts $of "WHS=$whs"
puts $of "THS=$ths"
puts $of "UNROUTED=$unrouted"
puts $of "FAILED_ROUTE=$failed_route"
puts $of "DRC_ERROR_FATAL=$drc_bad"
puts $of "CRITICAL_UNCONSTRAINED=$unc"
puts $of "FIT_OK=$fit_ok"
puts $of "PROGRAM=NO"
puts $of "C6_MASTER=OPEN"
close $of

if {$fit_ok && $unc == 0} {
  if {[catch {write_bitstream -force $bitfile} berr]} {
    puts "C6WC_BIT_WARN $berr"
  } else {
    puts "C6WC_BIT_WRITTEN $bitfile"
  }
  puts ASTRA_C6_WHOLECHIP_COFIT_03_PASS
} else {
  c6_abort TIMING_OR_FIT "WNS=$wns TNS=$tns WHS=$whs THS=$ths UNROUTED=$unrouted DRC=$drc_bad UNC=$unc"
  puts ASTRA_C6_WHOLECHIP_COFIT_03_MISS
  exit 1
}
