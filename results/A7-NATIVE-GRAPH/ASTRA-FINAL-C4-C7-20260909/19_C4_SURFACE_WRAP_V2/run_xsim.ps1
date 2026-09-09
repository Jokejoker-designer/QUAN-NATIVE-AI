$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"
$hexsrc = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v2_mem"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Set-Location $work
$files = @(
  (Join-Path $inci "a7ng_astra_c4_answer_gate_v1.sv"),
  (Join-Path $inci "a7ng_astra_c4_entity_alias_v1.sv"),
  (Join-Path $inci "a7ng_astra_c4_materializer_v2.sv"),
  (Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v2.sv"),
  (Join-Path $inci "a7ng_astra_c4_prod_wrap_v2.sv"),
  (Join-Path $bag "tb_astra_c4_prod_wrap_v2.sv")
)
& "$bin\xvlog.bat" --sv -i $inci -i $bag @files
if ($LASTEXITCODE -ne 0) { throw "WRAP_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c4_prod_wrap_v2 -s c4wrapv2 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "WRAP_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4wrapv2 -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "WRAP_XSIM_FAIL" }
$ok = (Select-String -Path $xsimLog -Pattern "ASTRA_C4_PROD_WRAP_V2_XSIM_PASS" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "CLASS_ref_match HIT" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "CLASS_host_tok0 HIT" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "PASS ALIAS_KEEP20" -Quiet)
if (-not $ok) { throw "WRAP_MARKER_MISSING" }
Write-Host "ASTRA_C4_PROD_WRAP_V2_RUN_OK"
