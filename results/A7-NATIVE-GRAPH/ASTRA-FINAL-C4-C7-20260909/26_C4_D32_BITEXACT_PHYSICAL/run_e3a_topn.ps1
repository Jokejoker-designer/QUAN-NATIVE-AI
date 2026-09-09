$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "E3A_TOPN_VIVADO_NOT_FOUND" }
$log = Join-Path $bag "vivado_e3a_topn.log"
Set-Location $bag
Write-Host "E3A_TOPN_PS1_START PROGRAM=NO E3B=NO BIT=NO"
& $vivado -mode batch -source (Join-Path $bag "run_e3a_topn.tcl") -log $log -journal (Join-Path $bag "vivado_e3a_topn.jou")
if ($LASTEXITCODE -ne 0) { throw "E3A_TOPN_FAIL exit=$LASTEXITCODE" }
if (-not (Select-String -Path $log -Pattern "E3A_TOPN_DONE" -Quiet)) {
  throw "E3A_TOPN_MARKER_MISSING"
}
Write-Host "E3A_TOPN_PS1_OK PROGRAM=NO"
