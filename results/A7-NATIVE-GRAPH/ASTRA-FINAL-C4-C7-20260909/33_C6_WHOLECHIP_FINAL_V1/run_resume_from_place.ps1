$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$env:C6F_RESUME_PLACE_DCP = "1"
$env:C6F_RESUME_SYNTH_DCP = "0"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "C6F_VIVADO_NOT_FOUND" }

$placePub = Join-Path $bag "c6_place.dcp"
$placeCkpt = Join-Path $bag "ckpt\place.dcp"
$place = $null
if (Test-Path -LiteralPath $placePub) { $place = $placePub }
elseif (Test-Path -LiteralPath $placeCkpt) { $place = $placeCkpt }
else { throw "C6F_PLACE_DCP_MISSING" }

$overlayFile = Join-Path $bag "C6_OVERLAY_SHA.txt"
if (-not (Test-Path -LiteralPath $overlayFile)) { throw "C6F_OVERLAY_SHA_MISSING publish overlay first" }
$overlaySha = (Get-Content -LiteralPath $overlayFile -Raw).Trim()
if ($overlaySha -notmatch '^[0-9a-f]{40}$') { throw "C6F_OVERLAY_SHA_BAD $overlaySha" }
$env:C6F_OVERLAY_SHA = $overlaySha

function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C6F_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}

function Get-LicenseHolders {
  @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
    ($_.Name -match 'xsim|xelab|xvlog|vivado|hw_server|cs_server') -and
    ($_.CommandLine -notmatch '33_C6_WHOLECHIP_FINAL_V1')
  })
}

$zeroStreak = 0
while ($zeroStreak -lt 3) {
  $holders = Get-LicenseHolders
  if ($holders.Count -eq 0) {
    $zeroStreak++
    Write-Host ("C6F_SETTLE $zeroStreak/3 PROGRAM=NO")
  } else {
    $zeroStreak = 0
    Write-Host ("C6F_WAIT n=" + $holders.Count + " PROGRAM=NO")
  }
  Start-Sleep -Seconds 10
}

$sgd = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE route-from-place $stamp",
  "# PROGRAM=NO C6F_RESUME_PLACE_DCP=1",
  "# OVERLAY_SHA $overlaySha",
  "# C6_SYNTH=PASS C6_PLACE=PASS_CANDIDATE_DCP C6_ROUTE=NOT_THIS_PROCESS_YET C6_POSTROUTE=NOT_EVIDENCED",
  "# NO BOARD PASS C6_MASTER=OPEN"
)
$pre += "$(Sha256 $place)  $(Resolve-Path $place)"
$pre += "$(Sha256 $sgd)  rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv"
$pre += "$(Sha256 (Join-Path $bag 'run_impl.tcl'))  run_impl.tcl"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_ROUTE_FROM_PLACE.txt"), $pre)
Write-Host "C6F_ROUTE_FROM_PLACE_SHA $overlaySha PROGRAM=NO"

$log = Join-Path $bag "vivado.log"
if (Test-Path -LiteralPath $log) {
  $stamp2 = (Get-Date).ToString("yyyyMMdd_HHmmss")
  Copy-Item -LiteralPath $log -Destination (Join-Path $bag "vivado.log.pre_place_route_$stamp2") -Force
  Write-Host "C6F_LOG_ARCHIVED PROGRAM=NO"
}
Set-Location $bag
Write-Host "C6F_PS1_ROUTE_FROM_PLACE PROGRAM=NO BIT=CONDITIONAL OVERLAY=$overlaySha"
& $vivado -mode batch -source (Join-Path $bag "run_impl.tcl") -log $log -journal (Join-Path $bag "vivado.jou")
$xc = $LASTEXITCODE
python (Join-Path $bag "finish_c6_impl.py")
if ($LASTEXITCODE -ne 0) { throw "C6F_FINISH_FAIL exit=$LASTEXITCODE" }
if ($xc -ne 0) { throw "C6F_IMPL_FAIL exit=$xc" }
Write-Host "C6F_PS1_OK PROGRAM=NO"
