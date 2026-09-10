$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "E3H_OOC_VIVADO_NOT_FOUND" }
$xsim = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
  $_.Name -match 'xsim|xelab|xvlog|vivado' -and $_.CommandLine -notmatch 'run_e3h_ooc'
}
if ($xsim) {
  throw "E3H_OOC_BLOCKED_LICENSE sibling Vivado/XSim live; wait GOLDEN. PROGRAM=NO"
}
$log = Join-Path $bag "vivado_e3h_ooc.log"
Set-Location $bag
Write-Host "E3H_OOC_PS1_START PROGRAM=NO BIT=NO S_H_ONLY"
& $vivado -mode batch -source (Join-Path $bag "run_e3h_ooc.tcl") -log $log -journal (Join-Path $bag "vivado_e3h_ooc.jou")
if ($LASTEXITCODE -ne 0) { throw "E3H_OOC_FAIL exit=$LASTEXITCODE" }
if (-not (Select-String -Path $log -Pattern "E3H_OOC_DONE PROGRAM=NO" -Quiet)) {
  throw "E3H_OOC_MARKER_MISSING"
}
Write-Host "E3H_OOC_PS1_OK PROGRAM=NO"
