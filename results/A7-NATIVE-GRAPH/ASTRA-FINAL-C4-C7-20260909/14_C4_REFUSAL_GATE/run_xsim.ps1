$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"
$hexsrc = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1_mem"
$dut = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1.sv"
$gate = Join-Path $inci "a7ng_astra_c4_answer_gate_v1.sv"
$tb = Join-Path $bag "tb_astra_c4_answer_gate_v1.sv"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Set-Location $work
& "$bin\xvlog.bat" --sv -i $inci -i $bag $gate $dut $tb
if ($LASTEXITCODE -ne 0) { throw "G05_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c4_answer_gate_v1 -s c4g05 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "G05_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4g05 -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "G05_XSIM_FAIL" }
if (-not (Select-String -Path $xsimLog -Pattern "ASTRA_C4_G05_GATE_XSIM_PASS" -Quiet)) {
  throw "G05_MARKER_MISSING"
}
Write-Host "ASTRA_C4_G05_GATE_RUN_OK"
