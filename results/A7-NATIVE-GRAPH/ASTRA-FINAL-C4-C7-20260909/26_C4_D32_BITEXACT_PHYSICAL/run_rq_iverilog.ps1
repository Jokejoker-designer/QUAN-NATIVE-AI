$ErrorActionPreference = "Stop"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$dut = "D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\rtl\native_graph\integrate\a7ng_astra_c4_rq_mcycle.sv"
$tb = Join-Path $bag "tb_c4_rq_mcycle.sv"
$out = Join-Path $bag "c4_rq_iverilog.out"
$log = Join-Path $bag "c4_rq_iverilog.log"
$iverilog = "C:\Users\phant\iverilog\bin\iverilog.exe"
$vvp = "C:\Users\phant\iverilog\bin\vvp.exe"
if (-not (Test-Path -LiteralPath $iverilog)) { throw "IVERILOG_NOT_FOUND" }
& $iverilog -g2012 -o $out $dut $tb
if ($LASTEXITCODE -ne 0) { throw "IVERILOG_COMPILE_FAIL" }
& $vvp $out | Tee-Object -FilePath $log
if (-not (Select-String -Path $log -Pattern "ASTRA_C4_RQ_MCYCLE_IVERILOG_PASS" -Quiet)) {
  throw "IVERILOG_PASS_MARKER_MISSING"
}
Write-Host "C4_RQ_MCYCLE_IVERILOG_OK PROGRAM=NO"
