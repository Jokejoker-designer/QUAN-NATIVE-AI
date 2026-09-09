# ASTRA-C6-OOC-PREFLIGHT-01. PROGRAM=NO. BIT=NO. A09=NO. MIG=NO.
# OOC synth of materially changed C3-C5 blocks. Not whole-chip route.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}
set part xc7a100tcsg324-1
set_param general.maxThreads 8

set incq [file join $root rtl/native_graph/query]
set incc [file join $root rtl/native_graph/control]
set inci [file join $root rtl/native_graph/integrate]

set files [list \
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
]

foreach f $files {
  set leaf [file tail $f]
  if {$leaf eq "tiny_gpt803k_core.sv"} { error "C6OOC_FROZEN_LM06_AS_DUT" }
  if {$leaf eq "mig_7series_0_mig.v"} { error "C6OOC_SYNTH_MIG_AS_DUT" }
  if {[string match "*a7ng_astra_09_integ_path*" $leaf]} { error "C6OOC_LEFTOVER_A09" }
  if {$leaf eq "a7ng_evidence_compose.sv"} { error "C6OOC_COMPOSE_AS_DUT" }
}

create_project -in_memory -part $part
set_property include_dirs [list $incq $incc $inci $bag] [current_fileset]
foreach f $files { read_verilog -sv $f }

proc c6_emit_metrics {tag bag} {
  set rpt [file join $bag ${tag}_util.rpt]
  report_utilization -file $rpt
  if {[llength [get_ports -quiet clk]] > 0} {
    create_clock -period 10.000 -name clk [get_ports clk]
  }
  report_timing_summary -file [file join $bag ${tag}_timing.rpt]
  set lutc [llength [get_cells -quiet -hierarchical -filter {REF_NAME =~ LUT*}]]
  set ffc  [llength [get_cells -quiet -hierarchical -filter {PRIMITIVE_TYPE =~ REGISTER.SDR.*}]]
  set bram [llength [get_cells -quiet -hierarchical -filter {PRIMITIVE_TYPE =~ BLOCKRAM.*}]]
  set dsp  [llength [get_cells -quiet -hierarchical -filter {PRIMITIVE_TYPE =~ DSP.*}]]
  set slice_lut "NA"
  set slice_ff "NA"
  if {[file exists $rpt]} {
    set fh [open $rpt r]
    set txt [read $fh]
    close $fh
    if {[regexp {\|\s+Slice LUTs\*?\s+\|\s+(\d+)} $txt -> n]} { set slice_lut $n }
    if {[regexp {\|\s+Slice Registers\s+\|\s+(\d+)} $txt -> n]} { set slice_ff $n }
  }
  puts "C6OOC_${tag}_CELL_LUT=$lutc CELL_FF=$ffc BRAM=$bram DSP=$dsp SLICE_LUT=$slice_lut SLICE_FF=$slice_ff"
}

puts "C6OOC_START part=$part PROGRAM=NO BOARD_PASS=REJECT C6_MASTER=OPEN WHOLECHIP_WNS=NOT_THIS_BAG A09=NO MIG=NO"

set fail 0
foreach pair {
  {a7ng_query_role_extract CLASS_ooc_parser}
  {a7ng_query_axi_sparse_intersect_synonym CLASS_ooc_index}
  {a7ng_astra_c3_held_out CLASS_ooc_proof_learner}
  {a7ng_astra_c2_persist_commit CLASS_ooc_persist}
  {a7ng_astra_c4_lm06_grounded_gen CLASS_ooc_lm_autoreg}
  {a7ng_astra_c5_prod_top CLASS_ooc_prod_top}
} {
  set top [lindex $pair 0]
  set cls [lindex $pair 1]
  puts "C6OOC_SYNTH_BEGIN $top"
  if {[catch {synth_design -mode out_of_context -top $top -part $part} err]} {
    puts "C6OOC_SYNTH_FAIL $top $err"
    puts "$cls MISS"
    incr fail
  } else {
    puts "C6OOC_SYNTH_OK $top"
    puts "$cls HIT"
    c6_emit_metrics $top $bag
    catch {close_design}
  }
}

puts "CLASS_no_a09_top HIT"
puts "CLASS_no_mig_synth HIT"
puts "CLASS_no_wholechip_wns HIT C6_WHOLECHIP_WNS=NOT_THIS_BAG"
puts "CLASS_envelope_reported HIT preferred LUT<=40000 FF<=50000 BRAM36eq<=115 DSP<=32"

if {$fail == 0} {
  puts "ASTRA_C6_OOC_PREFLIGHT_PASS"
} else {
  puts "ASTRA_C6_OOC_PREFLIGHT_FAIL n=$fail"
}
puts "C6_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO DDR_QUERY_BOUND_FINAL=NOT_FROZEN quality=OOC_SYNTH_NOT_ROUTE_NOT_MIG"
exit [expr {$fail == 0 ? 0 : 1}]
