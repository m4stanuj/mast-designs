# build-footer.ps1
# Generates the M4ST NETWORK footer HTML from sites.json (single source of truth).
# Usage: powershell -File build-footer.ps1 -OutputPath footer.html
# Then inject footer.html into each site's index.html before </body>.
param(
  [string]$SitesJson = "sites.json",
  [string]$OutputPath = "footer.html"
)

$data = Get-Content $SitesJson -Raw | ConvertFrom-Json
$copy = [char]0x00A9
$em = [char]0x2014

$links = ""
foreach ($s in $data.sites) {
  $isPrimary = $s.url -eq $data.primary
  if ($isPrimary) {
    $links += "      <a href=`"$($s.url)`" style=`"color:#0D0B14;background:#CFFF3D;text-decoration:none;border:1.5px solid #CFFF3D;padding:6px 14px;border-radius:100px;font-size:11px;font-weight:700;transition:all .15s`">$($s.name)</a>`n"
  } else {
    $links += "      <a href=`"$($s.url)`" style=`"color:#FFFCF7;text-decoration:none;border:1.5px solid #FFFCF7;padding:6px 14px;border-radius:100px;font-size:11px;font-weight:600;transition:all .15s`">$($s.name)</a>`n"
  }
}

$footer = @"
<!-- M4ST Network Footer -->
<footer style="background:#0D0B14;color:#FFFCF7;padding:44px 24px 36px;text-align:center;font-family:'JetBrains Mono',monospace;border-top:3px solid #0D0B14;margin-top:60px">
  <div style="max-width:1240px;margin:0 auto">
    <p style="font-family:'Space Grotesk',sans-serif;font-weight:700;font-size:15px;letter-spacing:0.04em;margin-bottom:6px">M4ST <span style="color:#CFFF3D">NETWORK</span></p>
    <p style="font-size:11px;color:#8B2FF2;letter-spacing:0.08em;text-transform:uppercase;margin-bottom:22px">$($data.sites.Count) autonomous agent interfaces</p>
    <nav aria-label="M4ST variants" style="display:flex;flex-wrap:wrap;justify-content:center;gap:8px;max-width:860px;margin:0 auto 24px">
$links    </nav>
    <p style="margin:0;font-size:11px;opacity:0.6">$copy 2026 M4ST $em Built by Anuj, Bareilly, India. Zero-cost, always.</p>
  </div>
</footer>
"@

[System.IO.File]::WriteAllText($OutputPath, $footer, [System.Text.UTF8Encoding]::new($false))
Write-Host "Footer generated -> $OutputPath ($($data.sites.Count) sites)"