# ASTRA-C6-WHOLECHIP-FINAL-V1 in-context impl. PROGRAM=NO.
# Top = a7ng_astra_c6_wholechip_final_v1. Not COFIT live wholechip.
# Never open_hw / program_hw. write_bitstream only if WO §19 letters hold.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set top  a7ng_astra_c6_wholechip_final_v1
set_param general.maxThreads 4
set first_div ""
# Short path: bag vivado_proj tripped ProjectBase 1-489 (260-char host limit).
set proj {D:/FPGA/_c6f_proj}
set ip_xci [file join $root vivado/ip/mig_7series_0/mig_7series_0.xci]
set mig_xdc [file join $root vivado/ip/mig_7series_0/mig_7series_0/user_design/constraints/mig_7series_0.xdc]
set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]
set inci [file join $root rtl/native_graph/integrate]
set incl [file join $root rtl/native_graph/learn]
set incm [file join $root rtl/native_graph/memory]
set incb [file join $root rtl/board]
set hexsrc [file join $inci a7ng_astra_c4_lm06_d32_fr_v2_mem]
set bitfile [file join $bag a7ng_astra_c6_wholechip_final_v1.bit]
set synth_dcp [file join $bag c6_synth.dcp]
set place_dcp [file join $bag ckpt place.dcp]
set place_dcp_pub [file join $bag c6_place.dcp]
set route_dcp [file join $bag ckpt route.dcp]
set route_dcp_pub [file join $bag c6_route.dcp]
set resume_place 0
set resume_synth 0

proc c6_phase {name} {
  global bag
  set fh [open [file join $bag C6_PHASE.txt] w]
  puts $fh $name
  close $fh
  puts "C6F_PHASE=$name"
  flush stdout
}

file mkdir [file join $bag mem]
foreach f [glob -directory $hexsrc *.hex] {
  file copy -force $f [file join $bag mem [file tail $f]]
  file copy -force $f [file join $bag [file tail $f]]
}

set rtl [list \
  [file join $root rtl/native_graph/pkg/a7ng_pkg.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_extract.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv] \
  [file join $root rtl/native_graph/query/a7ng_query_role_keys_ctx.sv] \
  [file join $root rtl/native_graph/query/a7ng_route_valid_gate.sv] \
  [file join $root rtl/native_graph/memory/a7ng_sparse_dir_axi.sv] \
  [file join $root rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c3_held_out_pendld.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c5_axi1b_v1.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c5_sgd32_ckpt_pend.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_answer_gate_v1.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_entity_alias_v1.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c6_alias_boot_v1.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_materializer_v2.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_smres_div_mcycle.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_rq_mcycle.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c4_prod_wrap_v2.sv] \
  [file join $root rtl/board/uart_rx.sv] \
  [file join $root rtl/board/uart_tx.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c5_prod_top_final_v1.sv] \
  [file join $root rtl/board/sync_bits.sv] \
  [file join $root rtl/ddr/clk_arty_ddr.sv] \
  [file join $root rtl/ddr/mig_native_wrap.sv] \
  [file join $root rtl/native_graph/integrate/a7ng_astra_c6_wholechip_final_v1.sv] \
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
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
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
  if {$leaf eq "tiny_gpt803k_core.sv"} { error "C6F_FROZEN_LM06_AS_DUT" }
  if {$leaf eq "mig_7series_0_mig.v"} { error "C6F_SYNTH_MIG_AS_DUT" }
  if {[string match "*a7ng_astra_09_integ_path*" $leaf]} { error "C6F_LEFTOVER_A09" }
  if {$leaf eq "a7ng_astra_c4_lm06_grounded_gen.sv"} { error "C6F_GROUNDED_GEN" }
  if {$leaf eq "a7ng_astra_c5_prod_top.sv"} { error "C6F_LIVE_PROD_TOP" }
  if {$leaf eq "a7ng_astra_c6_wholechip.sv"} { error "C6F_LIVE_OLD_C6" }
}

if {![file exists $ip_xci]} {
  c6_abort MIG_IP_MISSING $ip_xci
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}

puts "DUT_TOP=$top"
puts "DUT_MODULE=a7ng_astra_c5_prod_top_final_v1"
puts "DUT_INSTANCE=u_c5"
puts "MIG_INSTANCE=u_mig"
puts "PIN_CLK=CLK100MHZ E3 period=10.000ns ui_clk=12.000ns"
puts "UART_RXD_OUT=D10 UART_TXD_IN=A9"
puts "MODE=in_context_impl_route"
puts "PROGRAM=NO"
puts "BIT=CONDITIONAL"
puts "PRODUCTION_TOP=a7ng_astra_c6_wholechip_final_v1"
puts "A09_IS_THIS_TOP=NO"
puts "C6F_START part=$part BOARD_PASS=REJECT C6_MASTER=OPEN"

file mkdir [file join $bag ckpt]
if {[info exists ::env(C6F_RESUME_PLACE_DCP)] && $::env(C6F_RESUME_PLACE_DCP) eq "1"} {
  set resume_place 1
} elseif {[info exists ::env(C6F_RESUME_SYNTH_DCP)] && $::env(C6F_RESUME_SYNTH_DCP) eq "1"} {
  set resume_synth 1
}
if {$resume_place} {
  puts "MODE=resume_from_place_dcp"
  set src $place_dcp_pub
  if {![file exists $src]} { set src $place_dcp }
  if {![file exists $src]} {
    c6_abort PLACE_DCP_MISSING $src
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
    exit 1
  }
  c6_phase OPEN_PLACE_DCP
  if {[catch {open_checkpoint $src} err]} {
    c6_abort OPEN_PLACE_DCP $err
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
    exit 1
  }
  puts "C6F_OPEN_PLACE_DCP $src"
  if {[info exists ::env(C6F_OVERLAY_SHA)] && $::env(C6F_OVERLAY_SHA) ne ""} {
    puts "C6F_OVERLAY_SHA $::env(C6F_OVERLAY_SHA)"
  }
  puts C6F_SYNTH_DONE
  puts C6F_PLACE_SKIP_ALREADY_PLACED
} elseif {$resume_synth} {
  puts "MODE=resume_from_synth_dcp"
  if {![file exists $synth_dcp]} {
    c6_abort SYNTH_DCP_MISSING $synth_dcp
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
    exit 1
  }
  c6_phase OPEN_SYNTH_DCP
  if {[catch {open_checkpoint $synth_dcp} err]} {
    c6_abort OPEN_SYNTH_DCP $err
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
    exit 1
  }
  puts "C6F_OPEN_SYNTH_DCP $synth_dcp"
  puts C6F_SYNTH_DONE
} else {
  file mkdir $proj
  create_project -force c6final $proj -part $part
  set_property target_language Verilog [current_project]
  set_property verilog_define SYNTHESIS [current_fileset]
  set_property include_dirs [list $incq $incc $inci $incl $incm $incb $bag [file join $bag mem]] [current_fileset]

  read_ip $ip_xci
  generate_target all [get_files $ip_xci]
  # In-context: do not treat MIG as OOC black box (that yields Synth 8-439
  # mig_7series_0 not found). Do not glob-add the same RTL (filemgmt 20-1440).
  # Do not add MIG XDC a second time; IP already owns it.
  set_property generate_synth_checkpoint false [get_files $ip_xci]

  add_files -norecurse $rtl
  add_files -fileset constrs_1 -norecurse [list \
    [file join $root constraints/arty_a7_100.xdc] \
    [file join $root constraints/a7ng03_cdc.xdc] \
    [file join $bag c6_wholechip.xdc]]

  set_property top $top [current_fileset]
  update_compile_order -fileset sources_1

  c6_phase PRE_SYNTH
  foreach x [get_files -quiet *.xdc] {
    set tn [file tail $x]
    if {$tn eq "c6_wholechip.xdc"} { continue }
    if {[catch {set_property used_in_synthesis false $x}]} {}
    puts "C6F_XDC_SYNTH_OFF $tn"
  }
  flush stdout
  puts C6F_PRE_SYNTH
  flush stdout
  if {[catch {synth_design -top $top -part $part} err]} {
    c6_phase SYNTH_FAIL
    c6_abort SYNTH $err
    if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_SYNTH_MISS
    exit 1
  }
  c6_phase SYNTH_RETURNED
  if {[catch {write_checkpoint -force $synth_dcp} werr]} {
    puts "C6F_SYNTH_DCP_WARN $werr"
    c6_phase SYNTH_DCP_FAIL
  } else {
    puts "C6F_SYNTH_DCP $synth_dcp"
    c6_phase SYNTH_DCP
  }
  if {[catch {file copy -force $synth_dcp [file join $bag ckpt synth.dcp]}]} {}
  flush stdout
  if {[info exists ::env(C6F_STOP_AFTER_SYNTH)] && $::env(C6F_STOP_AFTER_SYNTH) eq "1"} {
    puts C6F_STOP_AFTER_SYNTH
    puts "C6F_DONE PROGRAM=NO"
    exit 0
  }

  if {[catch {report_utilization -file [file join $bag util_synth.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_synth.rpt]}]} {}
  c6_util_extract [file join $bag util_synth.rpt] [file join $bag UTIL_EXTRACT_SYNTH.txt] Synthesized
  puts C6F_SYNTH_DONE
}

catch {set_clock_groups -asynchronous -group [get_clocks -quiet sys_clk_pin] -group [get_clocks -quiet uart_io_vclk]}
catch {set_clock_groups -asynchronous -group [get_clocks -quiet uart_io_vclk] -group [get_clocks -quiet -regexp {.*(ui|pll|mmcm|c166|c200).* }]}
foreach to_pat {c166* c200* *ui* *pll* *mmcm*} {
  catch {set_false_path -from [get_clocks sys_clk_pin] -to [get_clocks -quiet $to_pat]}
  catch {set_false_path -to [get_clocks sys_clk_pin] -from [get_clocks -quiet $to_pat]}
}
puts CDC_GROUPS_APPLIED=YES
puts "CLASS_cdc_reviewed HIT"

set c5c [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_c5_prod_top_final_v1 || ORIG_REF_NAME == a7ng_astra_c5_prod_top_final_v1}]
puts "U_C5_CELLS=[llength $c5c]"
if {[llength $c5c] == 0} {
  c6_abort C5_MISSING "no a7ng_astra_c5_prod_top_final_v1 cell"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}
puts "CLASS_c5_final_inst HIT"

set d32c [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_c4_lm06_d32_fr_v2 || ORIG_REF_NAME == a7ng_astra_c4_lm06_d32_fr_v2}]
puts "U_D32_CELLS=[llength $d32c]"
if {[llength $d32c] == 0} {
  c6_abort D32_MISSING "no a7ng_astra_c4_lm06_d32_fr_v2 cell"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}
puts "CLASS_d32_inst HIT"

set bootc [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_c6_alias_boot_v1 || ORIG_REF_NAME == a7ng_astra_c6_alias_boot_v1}]
puts "U_ALIAS_BOOT_CELLS=[llength $bootc]"
if {[llength $bootc] == 0} {
  c6_abort ALIAS_BOOT_PRUNE "no a7ng_astra_c6_alias_boot_v1 cell"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}
puts "CLASS_alias_boot_inst HIT"

set livec5 [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_c5_prod_top || ORIG_REF_NAME == a7ng_astra_c5_prod_top}]
if {[llength $livec5]} {
  c6_abort LIVE_C5 "old prod_top in netlist"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}

set migc [get_cells -quiet -hierarchical -filter {REF_NAME == mig_7series_0 || ORIG_REF_NAME == mig_7series_0 || REF_NAME == mig_native_wrap || ORIG_REF_NAME == mig_native_wrap}]
puts "U_MIG_CELLS=[llength $migc]"
if {[llength $migc] == 0} {
  c6_abort MIG_MISSING "no mig_native_wrap/mig_7series_0 cell"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}
puts "CLASS_mig_user_design HIT"

set bada09 [get_cells -quiet -hierarchical -filter {REF_NAME == a7ng_astra_09_integ_path || ORIG_REF_NAME == a7ng_astra_09_integ_path || REF_NAME =~ *astra09_pipe* || ORIG_REF_NAME =~ *astra09_pipe*}]
if {[llength $bada09]} {
  c6_abort FORBIDDEN_A09 "A09 cell in netlist"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ABORTED
  exit 1
}
puts "CLASS_no_a09_top HIT"
puts "CLASS_no_program_hw HIT"

c6_phase LINK
# COFIT-03: opt_design -propconst -sweep ACCESS_VIOLATION in Vivado 2026.1.
puts C6F_SKIP_OPT_CONSTPROP_AV
c6_phase OPT
puts C6F_OPT_DONE

if {!$resume_place} {
  c6_phase PLACE
  if {[catch {place_design} err]} {
    c6_abort PLACE $err
    if {[catch {report_utilization -file [file join $bag util_place.rpt]}]} {}
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_PLACE_MISS
    exit 1
  }
  if {[catch {phys_opt_design} err]} { puts "PHYS_OPT_WARN $err" }
  if {[catch {write_checkpoint -force $place_dcp} wperr]} {
    puts "C6F_PLACE_DCP_WARN $wperr"
  } else {
    puts "C6F_PLACE_DCP $place_dcp"
    if {[catch {file copy -force $place_dcp $place_dcp_pub}]} {}
  }
  puts C6F_PLACE_DONE
  if {[info exists ::env(C6F_STOP_AFTER_PLACE)] && $::env(C6F_STOP_AFTER_PLACE) eq "1"} {
    puts C6F_STOP_AFTER_PLACE
    puts "C6F_DONE PROGRAM=NO"
    exit 0
  }
} else {
  puts C6F_SKIP_PLACE_ALREADY_PLACED
}

c6_phase ROUTE
if {[catch {route_design} err]} {
  c6_abort ROUTE $err
  if {[catch {report_utilization -file [file join $bag util_route.rpt]}]} {}
  if {[catch {report_timing_summary -file [file join $bag timing_route.rpt]}]} {}
  if {[catch {report_route_status -file [file join $bag route_status.rpt]}]} {}
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ROUTE_MISS
  exit 1
}
if {[catch {phys_opt_design} err]} { puts "POST_ROUTE_PHYS_OPT_WARN $err" }
if {[catch {route_design -tns_cleanup} err]} { puts "TNS_CLEANUP_WARN $err" }

if {[catch {write_checkpoint -force $route_dcp}]} {}
if {[catch {file copy -force $route_dcp $route_dcp_pub}]} {}
report_utilization -file [file join $bag util_route.rpt]
report_utilization -hierarchical -file [file join $bag util_hier_route.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -max_paths 10 -file [file join $bag timing_route.rpt]
report_timing -delay_type max -max_paths 20 -nworst 1 -sort_by slack -file [file join $bag timing_n20_route.rpt]
report_route_status -file [file join $bag route_status.rpt]
report_drc -file [file join $bag drc.rpt]
report_clocks -file [file join $bag clocks_route.rpt]
if {[catch {check_timing -verbose -file [file join $bag check_timing.rpt]}]} {}
if {[catch {report_cdc -file [file join $bag cdc.rpt]}]} {}
c6_util_extract [file join $bag util_route.rpt] [file join $bag UTIL_EXTRACT.txt] Routed
set tex [c6_timing_extract [file join $bag timing_route.rpt] [file join $bag TIMING_EXTRACT.txt] Routed]
set wns [lindex $tex 0]
set tns [lindex $tex 1]
set whs [lindex $tex 2]
set ths [lindex $tex 3]
puts "C6F_WNS=$wns TNS=$tns WHS=$whs THS=$ths"

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
puts "C6F_UNROUTED=$unrouted FAILED_ROUTE=$failed_route"

set drc_bad 0
if {[file exists [file join $bag drc.rpt]]} {
  set fh [open [file join $bag drc.rpt] r]
  set dr [read $fh]
  close $fh
  foreach line [split $dr "\n"] {
    if {[regexp {^\s*(ERROR|FATAL):} $line]} { incr drc_bad }
  }
}
puts "C6F_DRC_ERROR_FATAL=$drc_bad"

set unc 0
if {[file exists [file join $bag check_timing.rpt]]} {
  set fh [open [file join $bag check_timing.rpt] r]
  set ct [read $fh]
  close $fh
  if {[regexp {no_clock[^\n]*\n[^\n]*\n\s+([0-9]+)} $ct -> n]} { incr unc $n }
  if {[regexp {unconstrained_internal_endpoints[^\n]*\n[^\n]*\n\s+([0-9]+)} $ct -> n]} { incr unc $n }
}
puts "C6F_CRITICAL_UNCONSTRAINED=$unc"

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
puts $of "TOP=$top"
close $of

if {$fit_ok && $unc == 0} {
  if {[catch {write_bitstream -force $bitfile} berr]} {
    puts "C6F_BIT_WARN $berr"
    c6_abort BITSTREAM $berr
    puts ASTRA_C6_WHOLECHIP_FINAL_V1_MISS
    exit 1
  } else {
    puts "C6F_BIT_WRITTEN $bitfile"
  }
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_ROUTE_PASS
  puts "C6_MASTER=OPEN PROGRAM=NO FREEZE=NO"
} else {
  c6_abort TIMING_OR_FIT "WNS=$wns TNS=$tns WHS=$whs THS=$ths UNROUTED=$unrouted DRC=$drc_bad UNC=$unc"
  puts ASTRA_C6_WHOLECHIP_FINAL_V1_MISS
  exit 1
}
puts "C6F_DONE PROGRAM=NO"
exit 0
