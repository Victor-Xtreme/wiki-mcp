param(
    [string]$ConfigPath = "config.json"
)

$ErrorActionPreference = "Stop"
$ErrCount = 0

function Pass  { Write-Host "  [PASS] $args" -ForegroundColor Green }
function Warn  { Write-Host "  [WARN] $args" -ForegroundColor Yellow }
function Fail  { Write-Host "  [FAIL] $args" -ForegroundColor Red; $script:ErrCount++ }

Write-Host "==> Validating config: $ConfigPath"
Write-Host ""

# ------------------------------------------------------------------
# 1. File exists and is valid JSON
# ------------------------------------------------------------------
Write-Host "--- Step 1: File check ---"

if (-not (Test-Path $ConfigPath)) {
    Fail "File not found: $ConfigPath"
    Write-Host ""
    Write-Host "Config check failed with $ErrCount error(s)." -ForegroundColor Red
    exit 1
}
Pass "File exists: $ConfigPath"

try {
    $config = Get-Content $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Fail "Invalid JSON in $ConfigPath - $($_.Exception.Message)"
    Write-Host ""
    Write-Host "Config check failed with $ErrCount error(s)." -ForegroundColor Red
    exit 1
}
Pass "Valid JSON"

# ------------------------------------------------------------------
# 2. Required top-level fields
# ------------------------------------------------------------------
Write-Host ""
Write-Host "--- Step 2: Top-level fields ---"

if ([string]::IsNullOrEmpty($config.defaultWiki)) {
    Fail "Missing 'defaultWiki' field"
} else {
    Pass "defaultWiki: $($config.defaultWiki)"
}

$wikiCount = @($config.wikis.PSObject.Properties).Count
if ($wikiCount -eq 0) {
    Fail "No wikis configured under 'wikis' key"
} else {
    Pass "Found $wikiCount wiki(s) configured"
}

# ------------------------------------------------------------------
# 3. Per-wiki validation
# ------------------------------------------------------------------
Write-Host ""
Write-Host "--- Step 3: Per-wiki fields ---"

foreach ($wikiProp in $config.wikis.PSObject.Properties) {
    $wikiKey = $wikiProp.Name
    $wiki = $wikiProp.Value

    Write-Host "  Wiki: $wikiKey"

    if ([string]::IsNullOrEmpty($wiki.sitename)) {
        Fail "Missing sitename"
    } else {
        Pass "sitename: $($wiki.sitename)"
    }

    if ([string]::IsNullOrEmpty($wiki.server)) {
        Fail "Missing server"
    } else {
        Pass "server: $($wiki.server)"
    }

    $hasArticlePath = [bool]($wiki.PSObject.Properties.Name -contains "articlepath")
    $hasScriptPath  = [bool]($wiki.PSObject.Properties.Name -contains "scriptpath")

    if ($hasArticlePath) {
        $ap = if ([string]::IsNullOrEmpty($wiki.articlepath)) { "(empty = pages served at site root)" } else { "'$($wiki.articlepath)'" }
        Pass "articlepath: $ap"
    } else {
        Fail "Missing articlepath key"
    }

    if ($hasScriptPath) {
        $sp = if ([string]::IsNullOrEmpty($wiki.scriptpath)) { "(empty = api.php at site root)" } else { "'$($wiki.scriptpath)'" }
        Pass "scriptpath: $sp"
    } else {
        Fail "Missing scriptpath key"
    }

    $isPrivate = if ($wiki.private -eq $true) { $true } else { $false }
    $hasToken  = -not [string]::IsNullOrEmpty($wiki.token)
    $hasUser   = -not [string]::IsNullOrEmpty($wiki.username)
    $hasPass   = -not [string]::IsNullOrEmpty($wiki.password)

    if ($isPrivate) {
        if ($hasToken -or ($hasUser -and $hasPass)) {
            Pass "Auth configured for private wiki"
        } else {
            Warn "Private wiki but no auth configured (token or username+password)"
        }
    }

    # ------------------------------------------------------------------
    # 4. Connectivity check
    # ------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- Step 4: Connectivity check for $wikiKey ---"

    $server   = $wiki.server.TrimEnd('/')
    $sPath    = $wiki.scriptpath.TrimEnd('/')
    $apiUrl   = "$server$sPath/api.php"
    $queryUrl = "$apiUrl`?action=query`&meta=siteinfo`&format=json"

    try {
        $siteInfo = Invoke-RestMethod -Uri $queryUrl -TimeoutSec 5
        Pass "API reachable: $apiUrl"
        $remoteSitename = $siteInfo.query.general.sitename
        Write-Host "    [INFO] Remote sitename: $remoteSitename" -ForegroundColor Cyan
    } catch {
        Warn "API not reachable at $apiUrl (network or DNS issue)"
    }
}

# ------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------
Write-Host ""
Write-Host "==="

if ($ErrCount -eq 0) {
    Write-Host "Config validation passed." -ForegroundColor Green
} else {
    $plural = if ($ErrCount -eq 1) { "" } else { "s" }
    Write-Host "Config validation finished with $ErrCount error$plural." -ForegroundColor Red
    exit 1
}
