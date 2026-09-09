# ASTRA-07 host golden + XSim. BIT=NO PROGRAM=NO COM12=UNTOUCHED
$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $bag
python "$bag\host_astra07.py" --golden-only
if ($LASTEXITCODE -ne 0) { throw "ASTRA07_HOST_GOLDEN_FAIL" }
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
New-Item -ItemType Directory -Force -Path $work | Out-Null
$mem = Join-Path $bag "mem"
foreach ($f in @(
  "train_x.mem","train_r.mem","shuf_x.mem","shuf_r.mem",
  "hold_x.mem","hold_gold.mem",
  "exp_hold_v_en.mem","exp_hold_v_sh.mem","exp_hold_v_fr.mem",
  "miss_x.mem"
)) {
  Copy-Item (Join-Path $mem $f) (Join-Path $work $f) -Force
}
Set-Location $work
$rtl = Join-Path $bag "..\..\..\rtl\native_graph\learn\a7ng_shared_rank_sgd_q8.sv"
$tb  = Join-Path $bag "tb_astra07_hold.sv"
& "$bin\xvlog.bat" --sv -i $bag $rtl $tb
if ($LASTEXITCODE -ne 0) { throw "ASTRA07_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -ErrorAction SilentlyContinue
& "$bin\xelab.bat" tb_astra07_hold -s astra07 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "ASTRA07_XELAB_FAIL" }
Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -ErrorAction SilentlyContinue
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra07 -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "ASTRA07_XSIM_FAIL" }
Set-Location $bag
python "$bag\host_astra07.py" --compare
if ($LASTEXITCODE -ne 0) { throw "ASTRA07_COMPARE_FAIL" }
Write-Host "ASTRA07_RUN_OK"
