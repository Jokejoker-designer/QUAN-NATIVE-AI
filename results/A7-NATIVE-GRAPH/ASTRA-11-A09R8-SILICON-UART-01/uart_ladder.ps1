$ErrorActionPreference = "Stop"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$out = Join-Path $bag LADDER.txt
$fail = 0
$first = ""

function HexArr([byte[]]$b) {
  if (-not $b -or $b.Length -eq 0) { return "EMPTY" }
  return (($b | ForEach-Object { $_.ToString("x2") }) -join " ")
}
function I16le([byte]$lo, [byte]$hi) {
  $u = [int]$lo + ([int]$hi * 256)
  if ($u -ge 32768) { return $u - 65536 }
  return $u
}
function S8([byte]$b) {
  $u = [int]$b
  if ($u -ge 128) { return $u - 256 }
  return $u
}
function Log([string]$m) {
  Add-Content -LiteralPath $out -Value $m
  Write-Host $m
}
function ReadAvail($p, $ms) {
  $t0 = Get-Date
  $acc = New-Object System.Collections.Generic.List[byte]
  while (((Get-Date) - $t0).TotalMilliseconds -lt $ms) {
    $n = $p.BytesToRead
    if ($n -gt 0) {
      $tmp = New-Object byte[] $n
      [void]$p.Read($tmp, 0, $n)
      foreach ($x in $tmp) { [void]$acc.Add($x) }
    } else { Start-Sleep -Milliseconds 15 }
  }
  if ($acc.Count -eq 0) { return [byte[]]@() }
  return [byte[]]$acc.ToArray()
}
function FindFrame([byte[]]$rx) {
  if (-not $rx -or $rx.Length -lt 16) { return $null }
  for ($i = 0; $i -le $rx.Length - 16; $i++) {
    if ($rx[$i] -eq 0xA2 -and $rx[$i+15] -eq 0x0A) {
      return [byte[]]$rx[$i..($i+15)]
    }
  }
  return $null
}
function Send($p, [byte[]]$b, [string]$tag) {
  $p.Write($b, 0, $b.Length)
  Log "TX $tag $(HexArr $b)"
}
function Fail([string]$tag, [string]$detail) {
  $script:fail++
  if ($script:first -eq "") { $script:first = $tag }
  Log "FAIL $tag $detail"
}
function Pass([string]$tag) { Log "PASS $tag" }

"# LADDER $(Get-Date -Format o) PROGRAM=YES SW0=ON" | Set-Content $out
$ports = [System.IO.Ports.SerialPort]::GetPortNames()
Log "PORTS=$($ports -join ',')"
if ($ports -notcontains "COM12") { throw "COM12_MISSING" }

Start-Sleep -Seconds 2
$p = New-Object System.IO.Ports.SerialPort "COM12", 115200, "None", 8, "One"
$p.ReadTimeout = 400
$p.WriteTimeout = 2000
$p.Handshake = [System.IO.Ports.Handshake]::None
$p.DtrEnable = $false
$p.RtsEnable = $false
$p.Open()
Start-Sleep -Milliseconds 300
$junk = ReadAvail $p 250
Log "PRE_JUNK=$(HexArr $junk)"

# --- 1 SMOKE ---
$qSmoke = [Text.Encoding]::ASCII.GetBytes("pump requires indirect`n")
Send $p $qSmoke "SMOKE_QUERY"
$rx = ReadAvail $p 8000
Log "RX_SMOKE n=$($rx.Length) $(HexArr $rx)"
$fr = FindFrame $rx
if (-not $fr) {
  Fail "SMOKE_NO_FRAME" "$(HexArr $rx)"
} else {
  $ans = [int]$fr[2] + ([int]$fr[3] -shl 8) + (([int]($fr[4] -band 15)) -shl 16)
  $p0  = [int]$fr[5] + ([int]$fr[6] -shl 8) + (([int]($fr[7] -band 15)) -shl 16)
  $p1  = [int]$fr[8] + ([int]$fr[9] -shl 8) + (([int]($fr[10] -band 15)) -shl 16)
  $st  = $fr[1] -band 15
  $acc = ($fr[1] -shr 4) -band 1
  $npath = $fr[11] -band 31
  Log "FRAME_SMOKE $(HexArr $fr)"
  Log "DECODE_SMOKE st=$st acc=$acc ans=$ans p0=$p0 p1=$p1 npath=$npath"
  if ($ans -eq 4 -and $p0 -eq 17 -and $st -eq 0 -and $acc -eq 1) { Pass "SMOKE ans=4 p0=17" }
  else { Fail "SMOKE_ORACLE" "ans=$ans p0=$p0 st=$st acc=$acc want 4/17" }
}

# --- 2 REWARD -3 txn=1 gen=1 ep=7 (XSim first-POR smoke) ---
$rew = [byte[]](0xA6, 0xFD, 0x01, 0x01, 0x07, 0x00, 0x0A)
Send $p $rew "REW_M3"
$rx2 = ReadAvail $p 8000
Log "RX_REW n=$($rx2.Length) $(HexArr $rx2)"
$fr2 = FindFrame $rx2
if (-not $fr2) {
  Fail "REW_NO_FRAME" "$(HexArr $rx2)"
} else {
  $w0 = I16le $fr2[2] $fr2[3]
  $phi0 = S8 $fr2[4]
  $nupd = [int]$fr2[5]
  $nbad = [int]$fr2[6]
  $tag = $fr2[14]
  Log "FRAME_REW $(HexArr $fr2)"
  Log "DECODE_REW w0=$w0 phi0=$phi0 nupd=$nupd nbad=$nbad tag=0x$($tag.ToString('x2')) txn=$($fr2[8]) gen=$($fr2[9])"
  if ($fr2[0] -eq 0xA2 -and $tag -eq 0x57 -and $w0 -eq -5 -and $phi0 -eq 50 -and $nupd -eq 1) {
    Pass "REW_M3 w0=-5 phi0=50 nupd=1"
  } else {
    Fail "REW_ORACLE" "w0=$w0 phi0=$phi0 nupd=$nupd tag=0x$($tag.ToString('x2')) want w0=-5 phi0=50 tag=57"
  }
}

# --- 3 RETIRE ---
Send $p ([byte[]](0xA7, 0x0A)) "RETIRE"
$rx3 = ReadAvail $p 400
Log "RX_RETIRE $(HexArr $rx3)"
Pass "RETIRE_SENT"

# --- 4 UNREL (SW0 still smoke plant) ---
$qUn = [Text.Encoding]::ASCII.GetBytes("payroll tax form`n")
Send $p $qUn "UNREL_QUERY"
$rx4 = ReadAvail $p 8000
Log "RX_UNREL n=$($rx4.Length) $(HexArr $rx4)"
$fr4 = FindFrame $rx4
if (-not $fr4) {
  Fail "UNREL_NO_FRAME" "$(HexArr $rx4)"
} else {
  $ans4 = [int]$fr4[2] + ([int]$fr4[3] -shl 8) + (([int]($fr4[4] -band 15)) -shl 16)
  $p04  = [int]$fr4[5] + ([int]$fr4[6] -shl 8) + (([int]($fr4[7] -band 15)) -shl 16)
  $st4  = $fr4[1] -band 15
  $np4  = $fr4[11] -band 31
  Log "FRAME_UNREL $(HexArr $fr4)"
  Log "DECODE_UNREL st=$st4 ans=$ans4 p0=$p04 npath=$np4"
  if ($st4 -eq 1 -and $ans4 -eq 0 -and $p04 -eq 0 -and $np4 -eq 0) { Pass "UNREL UNKNOWN ans=0" }
  else { Fail "UNREL_ORACLE" "st=$st4 ans=$ans4 p0=$p04 npath=$np4 want UNKNOWN 0/0" }
}

$p.Close()
if ($fail -eq 0) {
  Log "ASTRA_11_A09R8_SILICON_LADDER_PASS"
  Log "OVF_SW1=NOT_RUN (physical SW1 not this ladder)"
  Log "BOARD_PASS=NOT_CLAIMED ASTRA-13=NOT_CLOSED DDR=NOT_OPENED"
  exit 0
}
Log "ASTRA_11_A09R8_SILICON_LADDER_FAIL n=$fail first=$first"
"FIRST_DIVERGENCE $first" | Set-Content (Join-Path $bag FIRST_DIVERGENCE_LADDER.txt)
exit 2
