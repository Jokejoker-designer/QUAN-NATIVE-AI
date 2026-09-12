$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
if (-not (Test-Path -LiteralPath $vivado)) { throw "C6F_VIVADO_NOT_FOUND" }

$pendLog = Join-Path (Split-Path $bag) "35_C3_PEND_PHI_PIPE\xsim.log"
if (-not (Test-Path -LiteralPath $pendLog)) { throw "C6F_PEND_PHI_GOLDEN_MISSING" }
$pendOk = (Select-String -Path $pendLog -Pattern "ASTRA_C3_PEND_PHI_PIPE_XSIM_PASS" -Quiet) -and
          (-not (Select-String -Path $pendLog -Pattern "FIRST_DIVERGENCE" -Quiet))
if (-not $pendOk) { throw "C6F_PEND_PHI_GOLDEN_NOT_PASS" }

$errLog = Join-Path (Split-Path $bag) "36_C3_SGD_ERR_PIPE\xsim.log"
if (-not (Test-Path -LiteralPath $errLog)) { throw "C6F_SGD_ERR_GOLDEN_MISSING" }
$errOk = (Select-String -Path $errLog -Pattern "ASTRA_C3_SGD_ERR_PIPE_XSIM_PASS" -Quiet) -and
         (-not (Select-String -Path $errLog -Pattern "FIRST_DIVERGENCE" -Quiet))
if (-not $errOk) { throw "C6F_SGD_ERR_GOLDEN_NOT_PASS" }

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
    $names = ($holders | ForEach-Object { $_.Name }) -join ","
    Write-Host ("C6F_WAIT n=" + $holders.Count + " names=" + $names + " PROGRAM=NO")
  }
  Start-Sleep -Seconds 10
}

$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_d32_fr_v2.sv"
$c6 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c6_wholechip_final_v1.sv"
$c5 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top_final_v1.sv"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE vivado $stamp",
  "# PROGRAM=NO BOARD_PASS=OPEN C6_MASTER=OPEN C6_POST_ROUTE_FINAL_V1"
)
$pre += "$(Sha256 $dut)  rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2.sv"
$pre += "$(Sha256 $c5)  rtl/native_graph/integrate/a7ng_astra_c5_prod_top_final_v1.sv"
$pre += "$(Sha256 $c6)  rtl/native_graph/integrate/a7ng_astra_c6_wholechip_final_v1.sv"
$pre += "$(Sha256 (Join-Path $root 'rtl\native_graph\integrate\a7ng_astra_c3_held_out_pendld.sv'))  rtl/native_graph/integrate/a7ng_astra_c3_held_out_pendld.sv"
$pre += "$(Sha256 (Join-Path $root 'rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv'))  rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv"
$pre += "$(Sha256 (Join-Path $bag 'run_impl.tcl'))  run_impl.tcl"
$pre += "$(Sha256 (Join-Path $bag 'c6_wholechip.xdc'))  c6_wholechip.xdc"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C6F_SHA_FROZEN PROGRAM=NO"

$log = Join-Path $bag "vivado.log"
if (Test-Path -LiteralPath $log) {
  $stamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
  Copy-Item -LiteralPath $log -Destination (Join-Path $bag "vivado.log.stall_$stamp") -Force
  Write-Host "C6F_LOG_ARCHIVED PROGRAM=NO"
}
Set-Location $bag
Write-Host "C6F_PS1_START PROGRAM=NO BIT=CONDITIONAL"
& $vivado -mode batch -source (Join-Path $bag "run_impl.tcl") -log $log -journal (Join-Path $bag "vivado.jou")
$xc = $LASTEXITCODE
python (Join-Path $bag "finish_c6_impl.py")
if ($LASTEXITCODE -ne 0) { throw "C6F_FINISH_FAIL exit=$LASTEXITCODE" }
if ($xc -ne 0) { throw "C6F_IMPL_FAIL exit=$xc" }
Write-Host "C6F_PS1_OK PROGRAM=NO"
