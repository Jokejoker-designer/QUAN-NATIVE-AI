# ASTRA-11-A09R8-SILICON-UART-01. Owner-approved program of ONE SHA-pinned bit.
# Refuse PYNQ / wrong serial / wrong file. Does not open DDR/LM.
set bag  [file normalize [file dirname [info script]]]
set root [file normalize [file join $bag ../../..]]
set bitfile [file join $root results/A7-NATIVE-GRAPH/ASTRA-11-A09R8-UART-FREEZE-BIT-01/a7ng_astra_11_a09r8_uart_freeze_wrap.bit]
set want_sha "e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb"
set want_jtag "210319BE776EA"
set env(XILINXD_LICENSE_FILE) {D:\Xilinx\licenses\vivado_basic.lic}

proc astra_fail {cut msg} {
  global bag
  set fh [open [file join $bag FIRST_DIVERGENCE.txt] w]
  puts $fh "FIRST_DIVERGENCE $cut"
  puts $fh $msg
  close $fh
  puts "FIRST_DIVERGENCE $cut $msg"
  puts ASTRA_11_A09R8_SILICON_ABORTED
  exit 1
}

if {![file exists $bitfile]} {
  astra_fail BIT_MISSING $bitfile
}
set bn [file tail $bitfile]
foreach forbidden {arty_a7_lm arty_a7_eam01r arty_a7_eam02m arty_a7_astra09_soc_top c7442d16} {
  if {[string match *$forbidden* $bn]} {
    astra_fail REFUSE_BIT $bn
  }
}

set hash_out [exec powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath '$bitfile').Hash.ToLowerInvariant()"]
set hash_out [string trim $hash_out]
if {$hash_out ne $want_sha} {
  astra_fail BIT_SHA_MISMATCH "got=$hash_out want=$want_sha"
}
puts "BIT_SHA_OK $hash_out"

open_hw_manager
connect_hw_server
set found 0
set tgt ""
set all_tgts [get_hw_targets]
puts "HW_TARGETS=$all_tgts"
foreach t $all_tgts {
  if {[string match *1234-TUL* $t] || [string match *xc7z020* $t]} {
    astra_fail REFUSE_PYNQ $t
  }
  if {[string match *$want_jtag* $t]} {
    set found 1
    set tgt $t
  }
}
if {!$found} {
  astra_fail JTAG_SERIAL "want $want_jtag not in $all_tgts"
}
open_hw_target $tgt
set devs [get_hw_devices]
puts "HW_DEVICES=$devs"
set a7 [get_hw_devices -quiet xc7a100t_0]
if {![llength $a7]} {
  astra_fail DEVICE "no xc7a100t_0 on $tgt devices=$devs"
}
foreach d $devs {
  set nm [get_property NAME $d]
  if {[string match *xc7z020* $nm] || [string match *arm* $nm]} {
    astra_fail REFUSE_ZYNQ $nm
  }
}
current_hw_device [lindex $a7 0]
set_property PROGRAM.FILE $bitfile [current_hw_device]
puts "PROGRAM_BEGIN file=$bitfile target=$tgt device=[current_hw_device]"
program_hw_devices [current_hw_device]
refresh_hw_device [current_hw_device]
set pfh [open [file join $bag PROGRAM.txt] w]
puts $pfh "STATUS=PROGRAMMED"
puts $pfh "FILE=$bitfile"
puts $pfh "SHA256=$want_sha"
puts $pfh "TARGET=$tgt"
puts $pfh "DEVICE=[current_hw_device]"
puts $pfh "JTAG=$want_jtag"
puts $pfh "COM12=NOT_IN_THIS_TCL"
close $pfh
puts "ASTRA_11_A09R8_SILICON_PROGRAM_PASS file=$bitfile target=$tgt sha=$want_sha"
exit 0
