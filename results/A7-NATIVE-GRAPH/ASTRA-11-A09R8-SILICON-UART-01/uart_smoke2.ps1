$ErrorActionPreference = "Stop"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$out = Join-Path $bag UART_SMOKE2.txt
function HexArr([byte[]]$b) {
  if (-not $b -or $b.Length -eq 0) { return "EMPTY" }
  return (($b | ForEach-Object { $_.ToString("x2") }) -join " ")
}
function ReadAvail($p, $ms) {
  $t0 = Get-Date
  $acc = New-Object System.Collections.Generic.List[byte]
  while (((Get-Date) - $t0).TotalMilliseconds -lt $ms) {
    $n = $p.BytesToRead
    if ($n -gt 0) {
      $tmp = New-Object byte[] $n
      [void]$p.Read($tmp, 0, $n)
      foreach ($x in $tmp) { $acc.Add($x) }
    } else {
      Start-Sleep -Milliseconds 20
    }
  }
  if ($acc.Count -eq 0) { return [byte[]]@() }
  return [byte[]]$acc.ToArray()
}

$ports = [System.IO.Ports.SerialPort]::GetPortNames()
"PORTS=$($ports -join ',')" | Set-Content $out
if ($ports -notcontains "COM12") { throw "COM12_MISSING" }

$p = New-Object System.IO.Ports.SerialPort "COM12", 115200, "None", 8, "One"
$p.ReadTimeout = 500
$p.WriteTimeout = 2000
$p.Handshake = [System.IO.Ports.Handshake]::None
$p.DtrEnable = $false
$p.RtsEnable = $false
$p.Open()
Start-Sleep -Milliseconds 200
$junk = ReadAvail $p 200
"PRE_JUNK=$(HexArr $junk)" | Add-Content $out

# Retire if stuck in C_HOLD from previous UNKNOWN frame.
$ret = [byte[]](0xA7, 0x0A)
$p.Write($ret, 0, 2)
"RETIRE_SENT A7 0A" | Add-Content $out
$afterRet = ReadAvail $p 400
"AFTER_RETIRE=$(HexArr $afterRet)" | Add-Content $out

$q = [Text.Encoding]::ASCII.GetBytes("pump requires indirect`n")
$p.Write($q, 0, $q.Length)
"QUERY_SENT n=$($q.Length)" | Add-Content $out
$rx = ReadAvail $p 8000
$p.Close()
"RX_N=$($rx.Length) dump=$(HexArr $rx)" | Add-Content $out

$fr = $null
if ($rx.Length -ge 16) {
  for ($i = 0; $i -le $rx.Length - 16; $i++) {
    if ($rx[$i] -eq 0xA2 -and $rx[$i+15] -eq 0x0A) {
      $fr = $rx[$i..($i+15)]
      break
    }
  }
}
if (-not $fr) {
  "SMOKE=NO_FRAME" | Add-Content $out
  "ASTRA_11_A09R8_SILICON_UART_SMOKE2_NO_FRAME" | Add-Content $out
  Get-Content $out
  exit 3
}
$ans = [int]$fr[2] -bor ([int]$fr[3] -shl 8) -bor (([int]($fr[4] -band 0x0F)) -shl 16)
$p0  = [int]$fr[5] -bor ([int]$fr[6] -shl 8) -bor (([int]($fr[7] -band 0x0F)) -shl 16)
$p1  = [int]$fr[8] -bor ([int]$fr[9] -shl 8) -bor (([int]($fr[10] -band 0x0F)) -shl 16)
$st  = $fr[1] -band 0x0F
$acc = ($fr[1] -shr 4) -band 1
$rov = ($fr[1] -shr 6) -band 1
$wov = ($fr[1] -shr 5) -band 1
$npath = $fr[11] -band 0x1F
$ntrunc = [int]$fr[12] -bor ([int]$fr[13] -shl 8)
"FRAME $(HexArr $fr)" | Add-Content $out
"DECODE magic=0x$($fr[0].ToString('x2')) st=$st acc=$acc rov=$rov wov=$wov ans=$ans p0=$p0 p1=$p1 npath=$npath ntrunc=$ntrunc eol=0x$($fr[15].ToString('x2'))" | Add-Content $out
if ($fr[0] -eq 0xA2 -and $ans -eq 4 -and $p0 -eq 17) {
  "SMOKE=PASS ans=4 p0=17 p1=$p1" | Add-Content $out
  "ASTRA_11_A09R8_SILICON_UART_SMOKE2_PASS" | Add-Content $out
  Get-Content $out
  exit 0
}
$why = "SMOKE=FAIL ans=$ans p0=$p0 p1=$p1 st=$st (want ans=4 p0=17)"
if ($ans -eq 0 -and $p0 -eq 0) { $why += " STILL_NEED_SW0_OR_EMPTY_PLANT" }
$why | Add-Content $out
Get-Content $out
exit 2
