$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$dut = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"

function Get-LicenseHolders {
  @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
    ($_.Name -match 'xsim|xelab|xvlog|vivado') -and
    ($_.CommandLine -notmatch 'run_xsim.ps1') -and
    ($_.CommandLine -notmatch 'GEMINI_INDEPENTDENT') -and
    ($_.CommandLine -notmatch '33_C6_WHOLECHIP_FINAL_V1')
  })
}

$zeroStreak = 0
while ($zeroStreak -lt 3) {
  $holders = Get-LicenseHolders
  if ($holders.Count -eq 0) {
    $zeroStreak++
    Write-Host ("C3SGDERR_SETTLE $zeroStreak/3 PROGRAM=NO")
  } else {
    $zeroStreak = 0
    Write-Host ("C3SGDERR_WAIT n=" + $holders.Count + " PROGRAM=NO")
  }
  Start-Sleep -Seconds 5
}

python (Join-Path $bag "gen_vectors.py")
if ($LASTEXITCODE -ne 0) { throw "C3SGDERR_TWIN_FAIL" }

$work = Join-Path $bag ("xsim_work_" + $PID)
if (Test-Path $work) { Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$files = @($dut, (Join-Path $bag "tb_astra_c3_sgd_err_pipe.sv"))
& "$bin\xvlog.bat" --sv -i $bag @files
if ($LASTEXITCODE -ne 0) { throw "C3SGDERR_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c3_sgd_err_pipe -s c3sgderr -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "C3SGDERR_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c3sgderr -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "C3SGDERR_XSIM_FAIL" }
$ok = (Select-String -Path $xsimLog -Pattern "ASTRA_C3_SGD_ERR_PIPE_XSIM_PASS" -Quiet) -and
      (-not (Select-String -Path $xsimLog -Pattern "FIRST_DIVERGENCE" -Quiet))
if (-not $ok) { throw "C3SGDERR_MARKER_MISSING" }
Write-Host "ASTRA_C3_SGD_ERR_PIPE_RUN_OK"
Write-Host "C4_MASTER=OPEN C5_MASTER=OPEN C6_MASTER=OPEN PROGRAM=NO E3AB=DO_NOT_START"
