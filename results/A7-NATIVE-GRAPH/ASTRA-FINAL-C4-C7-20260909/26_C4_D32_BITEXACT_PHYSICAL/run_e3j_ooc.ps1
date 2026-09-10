$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "E3J_OOC_VIVADO_NOT_FOUND" }
$xsim = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
  $_.Name -match 'xsim|xelab|xvlog|vivado' -and $_.CommandLine -notmatch 'run_e3j_ooc'
}
if ($xsim) {
  throw "E3J_OOC_BLOCKED_LICENSE sibling Vivado/XSim live. PROGRAM=NO"
}
$log = Join-Path $bag "vivado_e3j_ooc.log"
Set-Location $bag
Write-Host "E3J_OOC_PS1_START PROGRAM=NO BIT=NO S_DOT_ONLY"
& $vivado -mode batch -source (Join-Path $bag "run_e3j_ooc.tcl") -log $log -journal (Join-Path $bag "vivado_e3j_ooc.jou")
if ($LASTEXITCODE -ne 0) { throw "E3J_OOC_FAIL exit=$LASTEXITCODE" }
if (-not (Select-String -Path $log -Pattern "E3J_OOC_DONE PROGRAM=NO" -Quiet)) {
  throw "E3J_OOC_MARKER_MISSING"
}
Write-Host "E3J_OOC_PS1_OK PROGRAM=NO"
