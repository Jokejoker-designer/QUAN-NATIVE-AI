$ErrorActionPreference = "Stop"
# iverilog only. Refuses if parent E3a OOC (PID from run_e3a_topn) is live.
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$dut = "D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\rtl\native_graph\integrate\a7ng_astra_c4_smres_div_mcycle.sv"
$tb = Join-Path $bag "tb_smres_div_mcycle.sv"
$out = Join-Path $bag "smres_div_iverilog.out"
$log = Join-Path $bag "smres_div_iverilog.log"
$iverilog = "C:\Users\phant\iverilog\bin\iverilog.exe"
$vvp = "C:\Users\phant\iverilog\bin\vvp.exe"
$ooc = Get-CimInstance Win32_Process -Filter "Name='vivado.exe'" | Where-Object { $_.CommandLine -like "*run_e3a_topn.tcl*" }
if ($ooc) {
  Write-Host "E3A OOC live; iverilog does not use Vivado license. Continuing."
}
if (-not (Test-Path -LiteralPath $iverilog)) { throw "IVERILOG_NOT_FOUND" }
& $iverilog -g2012 -o $out $dut $tb
if ($LASTEXITCODE -ne 0) { throw "IVERILOG_COMPILE_FAIL" }
& $vvp $out | Tee-Object -FilePath $log
if (-not (Select-String -Path $log -Pattern "ASTRA_SMRES_DIV_MCYCLE_IVERILOG_PASS" -Quiet)) {
  throw "IVERILOG_PASS_MARKER_MISSING"
}
Write-Host "SMRES_DIV_IVERILOG_OK PROGRAM=NO NOT_INSTANTIATED"
