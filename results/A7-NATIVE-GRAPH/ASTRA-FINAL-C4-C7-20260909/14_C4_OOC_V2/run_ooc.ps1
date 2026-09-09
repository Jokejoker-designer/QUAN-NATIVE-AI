$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "C4OOC_V2_VIVADO_NOT_FOUND" }
$log = Join-Path $bag "vivado_ooc.log"
Set-Location $bag
& $vivado -mode batch -source (Join-Path $bag "run_ooc.tcl") -log $log -journal (Join-Path $bag "vivado_ooc.jou")
if ($LASTEXITCODE -ne 0) { throw "C4OOC_V2_FAIL exit=$LASTEXITCODE" }
if (-not (Select-String -Path $log -Pattern "ASTRA_C4_D32_FR_V2_OOC_DONE" -Quiet)) {
  throw "C4OOC_V2_MARKER_MISSING"
}
Write-Host "ASTRA_C4_D32_FR_V2_OOC_RUN_OK"
