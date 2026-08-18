[CmdletBinding()]
param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$indexPath = Join-Path $ProjectRoot 'index.html'
$failures = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path -LiteralPath $indexPath)) {
    throw "index.html was not found under $ProjectRoot"
}

$html = Get-Content -Raw -LiteralPath $indexPath

function Assert-Check {
    param(
        [bool]$Condition,
        [string]$Success,
        [string]$Failure
    )

    if ($Condition) {
        Write-Host "PASS  $Success" -ForegroundColor Green
    }
    else {
        Write-Host "FAIL  $Failure" -ForegroundColor Red
        $failures.Add($Failure)
    }
}

Write-Host "Clark Gurden portfolio validation`n"

$localReferences = [regex]::Matches($html, '(?:src|href)="((?!https?:|mailto:|#)[^"]+)"') |
    ForEach-Object { $_.Groups[1].Value } |
    Sort-Object -Unique

foreach ($reference in $localReferences) {
    $decodedReference = [System.Uri]::UnescapeDataString($reference)
    $target = Join-Path $ProjectRoot ($decodedReference -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    Assert-Check (Test-Path -LiteralPath $target) "Local reference exists: $reference" "Missing local reference: $reference"
}

$images = [regex]::Matches($html, '<img\b[^>]*>', 'IgnoreCase')
$imagesWithoutAlt = @($images | Where-Object { $_.Value -notmatch '\balt="[^"]+"' })
Assert-Check ($imagesWithoutAlt.Count -eq 0) 'Every image has non-empty alt text' "$($imagesWithoutAlt.Count) image(s) are missing alt text"

$externalTargets = [regex]::Matches($html, '<a\b[^>]*target="_blank"[^>]*>', 'IgnoreCase')
$unsafeTargets = @($externalTargets | Where-Object { $_.Value -notmatch 'rel="noopener noreferrer"' })
Assert-Check ($unsafeTargets.Count -eq 0) 'Every new-tab link uses noopener noreferrer' "$($unsafeTargets.Count) new-tab link(s) are missing safe rel attributes"

Assert-Check ($html -match 'Gaming furniture & lifestyle hardware') 'Gaming Furniture is listed in Selected Work' 'Gaming Furniture is not listed in Selected Work'

$furnitureMatch = [regex]::Match($html, '(?s)<article class="case furniture".*?</article>')
Assert-Check ($furnitureMatch.Success) 'Furniture case article exists' 'Furniture case article was not found'
if ($furnitureMatch.Success) {
    Assert-Check ($furnitureMatch.Value -notmatch 'Blaze Link') 'Blaze Link is outside the furniture case' 'Blaze Link appears inside the furniture case'
}

Assert-Check ($html -notmatch '(?i)reviewer guides') 'Reviewer guide remains singular' 'Found prohibited plural “reviewer guides”'
Assert-Check ($html -match 'Reviewer guide: Predator Atlas 8 only') 'Atlas-only reviewer-guide scope is explicit' 'Atlas-only reviewer-guide scope is missing'

$resumePath = Join-Path $ProjectRoot 'downloads\Clark_Gurden_Resume_2026.docx'
if (Test-Path -LiteralPath $resumePath) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $resumeArchive = [System.IO.Compression.ZipFile]::OpenRead($resumePath)
    try {
        $documentEntry = $resumeArchive.GetEntry('word/document.xml')
        $reader = [System.IO.StreamReader]::new($documentEntry.Open())
        try {
            $resumeXml = $reader.ReadToEnd()
        }
        finally {
            $reader.Dispose()
        }
    }
    finally {
        $resumeArchive.Dispose()
    }

    $resumeText = [System.Net.WebUtility]::HtmlDecode(([regex]::Replace($resumeXml, '<[^>]+>', '')))
    Assert-Check ($resumeText -notmatch '(?i)reviewer guides') 'Resume keeps reviewer guide singular' 'Resume contains prohibited plural “reviewer guides”'
    Assert-Check ($resumeText -match 'Created product summaries for Predator Atlas 8 and Acer Nitro Blaze Link') 'Resume limits product summaries to Atlas 8 and Blaze Link' 'Resume does not state the approved product-summary scope'
    Assert-Check ($resumeText -match 'Predator Atlas 8 reviewer guide') 'Resume limits the reviewer guide to Atlas 8' 'Resume does not state the approved reviewer-guide scope'
    Assert-Check ($resumeText -notmatch 'owning global positioning and go-to-market') 'Resume avoids overly broad sole-ownership language' 'Resume contains overly broad positioning/GTM ownership language'
}
else {
    Assert-Check $false '' 'Downloadable resume is missing'
}

$thronosLinks = [regex]::Matches($html, 'href="([^"]*thronos[^"]*)"', 'IgnoreCase') |
    ForEach-Object { $_.Groups[1].Value }
$invalidThronosLinks = @($thronosLinks | Where-Object { $_ -notmatch 'thronos-air' })
Assert-Check ($invalidThronosLinks.Count -eq 0) 'No original-Thronos live-page link exists' 'An original-Thronos link may point to a dead page'

$requiredAnchors = @('top', 'work', 'systems', 'about', 'main')
foreach ($anchor in $requiredAnchors) {
    $anchorPattern = 'id="{0}"' -f [regex]::Escape($anchor)
    Assert-Check ($html -match $anchorPattern) "Internal anchor exists: #$anchor" "Missing internal anchor: #$anchor"
}

if ($failures.Count -gt 0) {
    Write-Host "`nValidation failed with $($failures.Count) issue(s)." -ForegroundColor Red
    exit 1
}

Write-Host "`nAll portfolio checks passed." -ForegroundColor Green
