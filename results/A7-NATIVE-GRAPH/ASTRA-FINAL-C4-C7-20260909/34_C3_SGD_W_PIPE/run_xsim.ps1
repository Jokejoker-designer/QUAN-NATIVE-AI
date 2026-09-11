$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$dut = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"

function Get-LicenseHolders {
  @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -match 'xsim|xelab|xvlog|vivado|hw_server|cs_server'
  })
}

$zeroStreak = 0
while ($zeroStreak -lt 3) {
  $holders = Get-LicenseHolders
  if ($holders.Count -eq 0) {
    $zeroStreak++
    Write-Host ("C3SGD_SETTLE $zeroStreak/3 PROGRAM=NO")
  } else {
    $zeroStreak = 0
    Write-Host ("C3SGD_WAIT n=" + $holders.Count + " PROGRAM=NO")
  }
  Start-Sleep -Seconds 5
}

python (Join-Path $bag "gen_vectors.py")
if ($LASTEXITCODE -ne 0) { throw "C3SGD_TWIN_FAIL" }

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$files = @($dut, (Join-Path $bag "tb_astra_c3_sgd_w_pipe.sv"))
& "$bin\xvlog.bat" --sv -i $bag @files
if ($LASTEXITCODE -ne 0) { throw "C3SGD_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c3_sgd_w_pipe -s c3sgdw -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "C3SGD_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c3sgdw -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "C3SGD_XSIM_FAIL" }
$ok = (Select-String -Path $xsimLog -Pattern "ASTRA_C3_SGD_W_PIPE_XSIM_PASS" -Quiet) -and
      (-not (Select-String -Path $xsimLog -Pattern "FIRST_DIVERGENCE" -Quiet))
if (-not $ok) { throw "C3SGD_MARKER_MISSING" }
Write-Host "ASTRA_C3_SGD_W_PIPE_RUN_OK"
Write-Host "C4_MASTER=OPEN C5_MASTER=OPEN C6_MASTER=OPEN PROGRAM=NO E3AB=DO_NOT_START"
