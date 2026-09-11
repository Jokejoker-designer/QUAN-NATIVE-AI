$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "E3Z_OOC_VIVADO_NOT_FOUND" }

function Get-LicenseHolders {
  @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
    ($_.Name -match 'xsim|xelab|xvlog|vivado|hw_server|cs_server') -and
    ($_.CommandLine -notmatch 'run_e3z_ooc')
  })
}

$zeroStreak = 0
while ($zeroStreak -lt 3) {
  $holders = Get-LicenseHolders
  if ($holders.Count -eq 0) {
    $zeroStreak++
    Write-Host ("E3Z_OOC_SETTLE $zeroStreak/3 PROGRAM=NO")
  } else {
    $zeroStreak = 0
    $names = ($holders | ForEach-Object { $_.Name }) -join ","
    Write-Host ("E3Z_OOC_WAIT n=" + $holders.Count + " names=" + $names + " PROGRAM=NO")
  }
  Start-Sleep -Seconds 10
}

$log = Join-Path $bag "vivado_e3z_ooc.log"
Set-Location $bag
Write-Host "E3Z_OOC_PS1_START PROGRAM=NO BIT=NO F2_OP_PIPE"
& $vivado -mode batch -source (Join-Path $bag "run_e3z_ooc.tcl") -log $log -journal (Join-Path $bag "vivado_e3z_ooc.jou")
if ($LASTEXITCODE -ne 0) { throw "E3Z_OOC_FAIL exit=$LASTEXITCODE" }
if (-not (Select-String -Path $log -Pattern "E3Z_OOC_DONE PROGRAM=NO" -Quiet)) {
  throw "E3Z_OOC_MARKER_MISSING"
}
Write-Host "E3Z_OOC_PS1_OK PROGRAM=NO"
