# SEO Audit for M4ST Network
$sites = @(
  @{n="m4stanuj";u="https://m4stanuj.vercel.app"},
  @{n="m4st";u="https://m4st.vercel.app"},
  @{n="mast-anuj";u="https://mast-anuj.vercel.app"},
  @{n="mast-brutal";u="https://mast-brutal.vercel.app"},
  @{n="mast-glass";u="https://mast-glass.vercel.app"},
  @{n="mast-luxury";u="https://mast-luxury.vercel.app"},
  @{n="m4st-premium";u="https://m4st-premium.vercel.app"},
  @{n="mast-arcade";u="https://mast-arcade.vercel.app"},
  @{n="mast-manga";u="https://mast-manga.vercel.app"},
  @{n="mast-casefile";u="https://mast-casefile.vercel.app"},
  @{n="mast-agent";u="https://mast-agent.vercel.app"},
  @{n="mast-vhs";u="https://mast-vhs.vercel.app"},
  @{n="m4st-v1";u="https://m4st-v1.vercel.app"},
  @{n="smart-github";u="https://smart-github-vercel-app.vercel.app"}
)

Write-Host "=== M4ST SEO AUDIT ==="
foreach ($s in $sites) {
  try {
    $r = Invoke-WebRequest -Uri $s.u -UseBasicParsing -TimeoutSec 20
    $c = $r.Content
    $title = [regex]::Match($c, '<title>([^<]*)</title>').Groups[1].Value.Trim()
    $desc = [regex]::Match($c, '<meta name="description" content="([^"]*)"').Groups[1].Value
    $robots = [regex]::Match($c, '<meta name="robots" content="([^"]*)"').Groups[1].Value
    $canon = [regex]::Match($c, '<link rel="canonical" href="([^"]*)"').Groups[1].Value
    $ogTitle = [regex]::Match($c, '<meta property="og:title" content="([^"]*)"').Groups[1].Value
    $ogDesc = [regex]::Match($c, '<meta property="og:description" content="([^"]*)"').Groups[1].Value
    $ogUrl = [regex]::Match($c, '<meta property="og:url" content="([^"]*)"').Groups[1].Value
    $twCard = [regex]::Match($c, '<meta name="twitter:card" content="([^"]*)"').Groups[1].Value
    $jsonld = $c -match 'application/ld\+json'
    $relMe = ([regex]::Matches($c, 'rel="me"')).Count
    $sameAs = $c -match '"sameAs"'
    $sitemap = $c -match 'sitemap'
    $robotsTxt = "?"
    try { $rr = Invoke-WebRequest -Uri "$($s.u)/robots.txt" -UseBasicParsing -TimeoutSec 10; $robotsTxt = if ($rr.StatusCode -eq 200) { "OK" } else { "MISSING" } } catch { $robotsTxt = "MISSING" }
    $sitemapXml = "?"
    try { $rs = Invoke-WebRequest -Uri "$($s.u)/sitemap.xml" -UseBasicParsing -TimeoutSec 10; $sitemapXml = if ($rs.StatusCode -eq 200) { "OK" } else { "MISSING" } } catch { $sitemapXml = "MISSING" }

    Write-Host ""
    Write-Host "--- $($s.n) ---"
    Write-Host "  title:    $title"
    Write-Host "  desc:     $($desc.Substring(0, [Math]::Min(60, $desc.Length)))"
    Write-Host "  robots:   $robots"
    Write-Host "  canonical:$canon"
    Write-Host "  og:title: $ogTitle"
    Write-Host "  og:url:   $ogUrl"
    Write-Host "  tw:card:  $twCard"
    Write-Host "  jsonld:$jsonld sameAs:$sameAs relMe:$relMe"
    Write-Host "  robots.txt:$robotsTxt sitemap.xml:$sitemapXml"
  } catch {
    Write-Host "--- $($s.n) --- ERROR: $($_.Exception.Message)"
  }
}