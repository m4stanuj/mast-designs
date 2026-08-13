# health-check.ps1
# Checks every site in sites.json returns 200 and has a self-canonical tag.
# Flags any site that is broken or serving duplicate content.
# Usage: powershell -File health-check.ps1
param(
  [string]$SitesJson = "sites.json"
)

$data = Get-Content $SitesJson -Raw | ConvertFrom-Json
$fail = 0

Write-Host "=== M4ST Network Health Check ==="
foreach ($s in $data.sites) {
  try {
    $r = Invoke-WebRequest -Uri $s.url -UseBasicParsing -TimeoutSec 20
    $c = $r.Content
    $canon = [regex]::Match($c, '<link rel="canonical" href="([^"]*)"').Groups[1].Value
    # For mirror sites, canonical should point to the mirror target; for live sites, to self
    $expected = if ($s.status -eq "mirror" -and $s.canonical) { $s.canonical } else { $s.url }
    $canonOK = $canon -eq ($expected + "/") -or $canon -eq $expected
    $status = if ($r.StatusCode -eq 200 -and $canonOK) { "OK" } else { "ISSUE" }
    if ($status -eq "ISSUE") { $fail++ }
    Write-Host ("{0,-28} {1}  canon:{2}" -f $s.name, $status, $canonOK)
  } catch {
    $fail++
    Write-Host ("{0,-28} DOWN  {1}" -f $s.name, $_.Exception.Message.Substring(0, [Math]::Min(30, $_.Exception.Message.Length)))
  }
}

Write-Host ""
if ($fail -eq 0) { Write-Host "ALL SITES HEALTHY" } else { Write-Host "$fail SITE(S) NEED ATTENTION" }
exit $fail