[CmdletBinding()]
param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [switch]$PublicationReady
)

$ErrorActionPreference = 'Stop'
$indexPath = Join-Path $ProjectRoot 'index.html'
$stylesPath = Join-Path $ProjectRoot 'styles.css'
$ledgerPath = Join-Path $ProjectRoot 'CONTENT_DECISION_LEDGER.md'
$chatgptReviewPath = Join-Path $ProjectRoot 'CHATGPT_REVIEW.md'
$failures = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path -LiteralPath $indexPath)) {
    throw "index.html was not found under $ProjectRoot"
}

$html = Get-Content -Raw -LiteralPath $indexPath
$styles = if (Test-Path -LiteralPath $stylesPath) { Get-Content -Raw -LiteralPath $stylesPath } else { '' }
$ledger = if (Test-Path -LiteralPath $ledgerPath) { Get-Content -Raw -LiteralPath $ledgerPath } else { '' }
$chatgptReview = if (Test-Path -LiteralPath $chatgptReviewPath) { Get-Content -Raw -LiteralPath $chatgptReviewPath } else { '' }

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

$canonicalPortfolioUrl = 'https://cybervargr.github.io/clark-gurden-portfolio/'
$expectedTitle = 'Clark Gurden | Senior Product Marketing & Global Brand Strategy'
$expectedDescription = 'Clark Gurden is a senior product marketing and global brand strategy leader with 10+ years at Acer HQ spanning gaming hardware, portfolio architecture, global GTM, and technical sales enablement.'
$expectedOgDescription = 'Senior product marketing work across gaming hardware, portfolio architecture, global launch systems, brand worldbuilding, and technical enablement.'
$expectedHeroIntro = 'I turn complex hardware into clear buyer choices—setting portfolio positioning and message hierarchy, governing technical claims, and building launch and enablement systems across categories, channels, and regions.'
$expectedWorkSupport = 'Across category entry, portfolio architecture, launch messaging, technical governance, B2B enablement, and brand worldbuilding, each example shows the problem, decision, ownership boundary, and public evidence.'
$expectedAboutHeading = 'Senior product marketing across gaming, consumer, and commercial hardware.'
$expectedAboutFirst = 'Clark Gurden spent 10+ years at Acer HQ, from April 2016 to July 2026, shaping global product marketing across Predator, Acer Nitro, AI PCs, and commercial hardware.'
$expectedAboutSecond = 'His work spans portfolio differentiation, launch messaging systems, information architecture, claims and specification governance, brand worldbuilding, and sales enablement across laptops, desktops, handhelds, monitors, peripherals, audio, connected devices, AI PCs, and gaming furniture.'

Assert-Check ($html.Contains("<title>$expectedTitle</title>") -and $html.Contains("<meta property=`"og:title`" content=`"$expectedTitle`">")) 'Page and Open Graph titles use the approved senior positioning' 'Page or Open Graph title is missing the approved senior positioning'
Assert-Check ($html.Contains("<meta name=`"description`" content=`"$expectedDescription`">")) 'Meta description uses the approved senior positioning' 'Meta description is missing or altered'
Assert-Check ($html.Contains("<meta property=`"og:description`" content=`"$expectedOgDescription`">")) 'Open Graph description uses the approved senior positioning' 'Open Graph description is missing or altered'
Assert-Check ($html -match '<meta property="og:image:alt" content="Predator Atlas 8[^\"]+">') 'Open Graph image has descriptive Predator Atlas 8 alt text' 'Open Graph image alt text is missing or does not describe Predator Atlas 8'
Assert-Check ($html.Contains('<p class="hero-role">Senior Product Marketing &<br>Global Brand Strategy</p>')) 'Hero role uses the approved senior positioning' 'Hero role is missing or altered'
Assert-Check ($html.Contains('<p class="hero-domain"><span>Gaming Hardware</span><span>Portfolio Architecture</span><span>Global GTM &amp; Enablement</span></p>')) 'Hero domains use the approved three-part scope' 'Hero domains are missing or altered'
Assert-Check ($html.Contains($expectedHeroIntro)) 'Hero introduction uses the approved senior scope' 'Hero introduction is missing or altered'
Assert-Check ($html.Contains($expectedWorkSupport)) 'Selected Work support line uses the approved scope' 'Selected Work support line is missing or altered'
Assert-Check ($html.Contains("<h2>$expectedAboutHeading</h2>") -and $html.Contains($expectedAboutFirst) -and $html.Contains($expectedAboutSecond)) 'About positioning is complete and exact' 'About heading or approved positioning paragraphs are missing or altered'
Assert-Check ($html.Contains('<link rel="stylesheet" href="styles.css?v=anchor-20260824">')) 'Stylesheet uses the approved Anchor cache key' 'Stylesheet cache key is missing or altered'
$furnitureImageRule = [regex]::Match($styles, '\.furniture-gallery\s+img\s*\{(?<declarations>[^}]*)\}', 'IgnoreCase')
$wallpaperImageRule = [regex]::Match($styles, '\.wallpaper-proof-gallery\s+img\s*\{(?<declarations>[^}]*)\}', 'IgnoreCase')
$furnitureImageRuleSafe = $furnitureImageRule.Success -and
    $furnitureImageRule.Groups['declarations'].Value -match 'width\s*:\s*100%' -and
    $furnitureImageRule.Groups['declarations'].Value -match 'height\s*:\s*auto' -and
    $furnitureImageRule.Groups['declarations'].Value -match 'object-fit\s*:\s*contain' -and
    $furnitureImageRule.Groups['declarations'].Value -notmatch 'aspect-ratio\s*:\s*auto'
$wallpaperImageRuleSafe = $wallpaperImageRule.Success -and
    $wallpaperImageRule.Groups['declarations'].Value -match 'width\s*:\s*100%' -and
    $wallpaperImageRule.Groups['declarations'].Value -match 'height\s*:\s*auto' -and
    $wallpaperImageRule.Groups['declarations'].Value -match 'object-fit\s*:\s*contain' -and
    $wallpaperImageRule.Groups['declarations'].Value -notmatch 'aspect-ratio\s*:\s*auto'
Assert-Check $furnitureImageRuleSafe 'Furniture images retain natural sizing without an aspect-ratio override' 'Furniture image sizing rule is missing, altered, or still forces aspect-ratio:auto'
Assert-Check $wallpaperImageRuleSafe 'Wallpaper images retain natural sizing without an aspect-ratio override' 'Wallpaper image sizing rule is missing, altered, or still forces aspect-ratio:auto'
$max680Count = [regex]::Matches($styles, '@media\s*\(\s*max-width\s*:\s*680px\s*\)', 'IgnoreCase').Count
$mobileTargetsPresent = $styles.Contains('.wordmark{width:44px;height:44px}') -and
    $styles.Contains('.nav-toggle{display:inline-flex;align-items:center;min-height:44px}') -and
    $styles.Contains('.site-nav a{display:inline-flex;align-items:center;min-height:44px}') -and
    $styles.Contains('.actions .text-link{display:inline-flex;align-items:center;justify-content:center;min-height:44px;text-align:center;padding:.6rem}')
Assert-Check ($max680Count -eq 1) 'Responsive CSS retains one consolidated max-width 680px block' 'Responsive CSS must contain exactly one max-width 680px block'
Assert-Check $mobileTargetsPresent 'Mobile header, navigation, and action links enforce 44px targets' 'Mobile wordmark, menu, navigation, or action-link target rules are missing or altered'
$orionLinkTargetsPresent = $styles.Contains('.architecture-row .text-link,.coverage-note .text-link{display:inline-flex;align-items:center;min-height:44px;max-width:100%}')
Assert-Check $orionLinkTargetsPresent 'Predator Orion matrix and award links enforce 44px targets' 'Predator Orion matrix or award-context link target rules are missing or altered'

$jsonLdMatch = [regex]::Match($html, '(?s)<script type="application/ld\+json">\s*(.*?)\s*</script>', 'IgnoreCase')
$jsonLdValid = $false
if ($jsonLdMatch.Success) {
    try {
        $jsonLd = $jsonLdMatch.Groups[1].Value | ConvertFrom-Json
        $requiredKnowledge = @('Portfolio Architecture', 'Information Architecture', 'Claims Governance')
        $jsonLdValid = $jsonLd.jobTitle -eq 'Product Marketing & Global Brand Strategy' -and
            $jsonLd.url -eq $canonicalPortfolioUrl -and
            @($jsonLd.sameAs).Count -eq 1 -and
            $jsonLd.sameAs[0] -eq 'https://www.linkedin.com/in/clark-gurden' -and
            @($requiredKnowledge | Where-Object { $_ -notin @($jsonLd.knowsAbout) }).Count -eq 0
    }
    catch {
        $jsonLdValid = $false
    }
}
Assert-Check $jsonLdValid 'JSON-LD has the canonical URL, approved role, LinkedIn identity, and senior knowledge areas' 'JSON-LD is invalid or missing an approved identity field'

$visibleHtml = [regex]::Replace($html, '(?is)<(?:script|style)\b.*?</(?:script|style)>', ' ')
$visibleText = [System.Net.WebUtility]::HtmlDecode([regex]::Replace($visibleHtml, '<[^>]+>', ' '))
$bareCanonicalPattern = '(?i)(?<!Acer )\bNitro Blaze Link\b|\bNitro V laptop line\b|(?<!Predator )\b(?:Helios 18 AI|Triton 14 AI|Helios Neo|Triton Neo|Thronos Air|Rift 371|Gaming Desk)\b'
Assert-Check ($visibleText -notmatch $bareCanonicalPattern) 'Visible product and model references use complete canonical names' 'Visible copy contains a shortened product or model name'
$bareAcerNitroBrandPattern = '(?i)(?<!Acer )\bNitro\b'
Assert-Check ($visibleText -notmatch $bareAcerNitroBrandPattern) 'Visible brand references use Acer Nitro in full' 'Visible copy contains a bare Nitro brand reference'
$maintenanceCanonicalPattern = '(?i)(?<!Acer )\b(?:Nitro Blaze Link|Nitro 17|Nitro V 15)\b|(?<!Predator )\b(?:Helios 18 AI|Triton 14 AI|Helios Neo|Triton Neo|Thronos Air|Rift 371|Gaming Desk)\b'
Assert-Check (
    $ledger.Contains('Acer Nitro 17 and Acer Nitro V 15') -and
    $chatgptReview.Contains('Predator Thronos, Predator Thronos Air, Predator Rift 371, and Predator Gaming Desk') -and
    $ledger -notmatch $maintenanceCanonicalPattern -and
    $chatgptReview -notmatch $maintenanceCanonicalPattern
) 'Maintenance surfaces use complete canonical product names' 'CONTENT_DECISION_LEDGER.md or CHATGPT_REVIEW.md contains a shortened audited product name'
$canonicalLinkLabels = @(
    'View Live Page: Predator Atlas 8',
    'View Live Page: Predator Gaming Technology Hub',
    'View Live Page: Acer Nitro Blaze Link',
    'View Live Page: Predator Helios 18 AI',
    'View Live Page: Predator Triton 14 AI',
    'Predator Orion X — official April 2023 announcement',
    'View the Predator XB273K 3D family page',
    'View the Predator X34 F1 family page',
    'View Live Page: Predator Thronos Air',
    'View Live Page: Predator Rift 371',
    'View Live Page: Predator Gaming Desk'
)
foreach ($canonicalLinkLabel in $canonicalLinkLabels) {
    Assert-Check ($visibleText.Contains($canonicalLinkLabel)) "Canonical link label exists: $canonicalLinkLabel" "Canonical link label is missing: $canonicalLinkLabel"
}

$localReferences = [regex]::Matches($html, '(?:src|href)="((?!https?:|mailto:|#)[^"]+)"') |
    ForEach-Object { $_.Groups[1].Value } |
    Sort-Object -Unique

foreach ($reference in $localReferences) {
    $decodedReference = [System.Uri]::UnescapeDataString(($reference -split '[?#]', 2)[0])
    $target = Join-Path $ProjectRoot ($decodedReference -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    Assert-Check (Test-Path -LiteralPath $target) "Local reference exists: $reference" "Missing local reference: $reference"
}

$images = [regex]::Matches($html, '<img\b[^>]*>', 'IgnoreCase')
$imagesWithoutAlt = @($images | Where-Object { $_.Value -notmatch '\balt="[^"]+"' })
Assert-Check ($imagesWithoutAlt.Count -eq 0) 'Every image has non-empty alt text' "$($imagesWithoutAlt.Count) image(s) are missing alt text"

$grapheneImage = '<img class="graphene-module" src="assets/graphene-tim.jpg" alt="Graphene TIM technology module" width="510" height="447" loading="lazy">'
$grapheneClassCount = [regex]::Matches($html, 'class="graphene-module"', 'IgnoreCase').Count
$supportingModulesKeepCover = $styles.Contains('.tech-visuals>div img{width:100%;aspect-ratio:1/1.05;object-fit:cover;object-position:top}')
$grapheneGetsIndividualContain = $styles.Contains('.tech-visuals>div img.graphene-module{object-fit:contain;background:#000}')
Assert-Check ($html.Contains($grapheneImage) -and $grapheneClassCount -eq 1) 'Graphene TIM keeps its source asset, dimensions, loading, alt text, and unique individual class' 'Graphene TIM evidence markup is missing, altered, or its individual class is not unique'
Assert-Check ($supportingModulesKeepCover -and $grapheneGetsIndividualContain) 'Only Graphene TIM is contained; the other supporting modules retain editorial cover frames' 'Technology Hub supporting-image crop rules are missing, blanket-altered, or no longer protect Graphene TIM'

$externalTargets = [regex]::Matches($html, '<a\b[^>]*target="_blank"[^>]*>', 'IgnoreCase')
$unsafeTargets = @($externalTargets | Where-Object { $_.Value -notmatch 'rel="noopener noreferrer"' })
Assert-Check ($unsafeTargets.Count -eq 0) 'Every new-tab link uses noopener noreferrer' "$($unsafeTargets.Count) new-tab link(s) are missing safe rel attributes"

Assert-Check ($html -match 'Gaming furniture & lifestyle hardware') 'Gaming Furniture is listed in Selected Work' 'Gaming Furniture is not listed in Selected Work'

$furnitureMatch = [regex]::Match($html, '(?s)<article class="case furniture".*?</article>')
Assert-Check ($furnitureMatch.Success) 'Furniture case article exists' 'Furniture case article was not found'
if ($furnitureMatch.Success) {
    Assert-Check ($furnitureMatch.Value -notmatch 'Blaze Link') 'Blaze Link is outside the furniture case' 'Blaze Link appears inside the furniture case'
    $furnitureImages = [regex]::Matches($furnitureMatch.Value, '<img\b[^>]*>', 'IgnoreCase')
    $dimensionedFurnitureImages = @($furnitureImages | Where-Object {
        $_.Value -match '\bwidth="\d+"' -and $_.Value -match '\bheight="\d+"'
    })
    Assert-Check ($furnitureImages.Count -eq 3 -and $dimensionedFurnitureImages.Count -eq 3) 'Furniture images preserve explicit width and height attributes' 'Furniture images must remain exactly three images with explicit width and height attributes'
}

$worldbuildingSectionMatch = [regex]::Match($html, '(?s)<section\b[^>]*id="brand-worldbuilding"[^>]*>.*?</section>', 'IgnoreCase')
Assert-Check ($worldbuildingSectionMatch.Success) 'Brand Worldbuilding & Creative Direction module exists' 'Brand Worldbuilding & Creative Direction module is missing'
if ($worldbuildingSectionMatch.Success) {
    $worldbuildingHtml = $worldbuildingSectionMatch.Value
    $wallpaperFigures = [regex]::Matches($worldbuildingHtml, '<figure\b[^>]*>.*?</figure>', 'IgnoreCase, Singleline')
    $wallpaperImages = [regex]::Matches($worldbuildingHtml, '<img\b[^>]*>', 'IgnoreCase')
    $wallpaperCaptions = @([regex]::Matches($worldbuildingHtml, '<figcaption>([^<]+)</figcaption>', 'IgnoreCase') | ForEach-Object { $_.Groups[1].Value })
    $wallpaperScope = "For Night City Merc and The New Evolution, Clark selected the commissioned artists, set the creative vision, and guided each work through briefs, iterative input, and final creative selection. A colleague managed agency and direct-artist coordination; the commissioned artists created the finished artwork. The social media team handled announcement and publication."
    $wallpaperPageUrl = 'https://www.acer.com/us-en/predator/gaming-wallpaper'
    $wallpaperImageSources = @($wallpaperImages | ForEach-Object {
        $sourceMatch = [regex]::Match($_.Value, '\bsrc="([^"]+)"', 'IgnoreCase')
        if ($sourceMatch.Success) { $sourceMatch.Groups[1].Value }
    })

    Assert-Check ($worldbuildingHtml -match 'aria-labelledby="brand-worldbuilding-title"' -and $worldbuildingHtml.Contains('<h3 id="brand-worldbuilding-title">Building Predator beyond product specifications.</h3>')) 'Worldbuilding heading and accessible label are complete' 'Worldbuilding heading or accessible label is missing'
    Assert-Check ($worldbuildingHtml.Contains('Brand worldbuilding &amp; creative direction · 2018–2023')) 'Worldbuilding eyebrow is exact' 'Worldbuilding eyebrow is missing or altered'
    Assert-Check ($worldbuildingHtml.Contains("Across Predatorverse, Summon Your Strength, and Predator’s gaming-wallpaper program, Clark translated hardware technologies into coherent brand worlds and guided upstream narrative and creative direction before specialist production.")) 'Worldbuilding lead is exact' 'Worldbuilding lead is missing or altered'
    Assert-Check ($worldbuildingHtml.Contains('<h4>Predatorverse narrative system</h4>')) '2018 Predatorverse subsection exists' '2018 Predatorverse subsection is missing'
    Assert-Check ($worldbuildingHtml.Contains('Within Acer, Clark originated and wrote the early Predatorverse source narrative: the campaign backstory; product- and character-inspired hero-card content; character and world names; weapons and abilities; and the technology connections that made the system coherent. External writers, artists, and agencies adapted those materials into the final graphic novels, campaign films, and visual assets.')) '2018 Predatorverse role boundary is exact' '2018 Predatorverse role boundary is missing or altered'
    Assert-Check ($worldbuildingHtml.Contains('Vanquish Media Group produced the documented 2018 public campaign assets.')) '2018 Vanquish production boundary is explicit' '2018 Vanquish production boundary is missing'
    Assert-Check ($worldbuildingHtml.Contains('<h4>Summon Your Strength</h4>')) '2019 Summon Your Strength subsection exists' '2019 Summon Your Strength subsection is missing'
    Assert-Check ($worldbuildingHtml.Contains('For the 2019 evolution, Clark originated the tribe-led strategic direction and contributed substantial on-video text and story-continuity language. The finished Acer and We Are Social campaign received an iF DESIGN AWARD in 2020.')) '2019 role and campaign-award boundary are exact' '2019 role or campaign-award boundary is missing or altered'

    $worldbuildingUrls = @(
        'https://vanquishmediagroup.com/projects/acer-predator/',
        'https://www.behance.net/gallery/83405077/Summon-Your-Strenght-ACER-PREDATOR',
        'https://ifdesign.com/en/winner-ranking/project/predatorverse-2019-summon-your-strength/279455'
    )
    $worldbuildingSourcesMatch = [regex]::Match($worldbuildingHtml, '(?s)<div class="worldbuilding-sources"[^>]*>(.*?)</div>', 'IgnoreCase')
    $worldbuildingSourceHtml = if ($worldbuildingSourcesMatch.Success) { $worldbuildingSourcesMatch.Groups[1].Value } else { '' }
    $worldbuildingSourceAnchors = [regex]::Matches($worldbuildingSourceHtml, '<a\b[^>]*href="([^"]+)"[^>]*>.*?</a>', 'IgnoreCase, Singleline')
    $worldbuildingSourceHrefs = @($worldbuildingSourceAnchors | ForEach-Object { $_.Groups[1].Value })
    $worldbuildingSourceOrderExact = $worldbuildingSourceHrefs.Count -eq 3 -and (($worldbuildingSourceHrefs -join "`n") -eq ($worldbuildingUrls -join "`n"))
    Assert-Check $worldbuildingSourceOrderExact 'Worldbuilding sources are exactly Vanquish, Behance, and iF in chronological order' 'Worldbuilding source links are missing, extra, or out of chronological order'
    Assert-Check ($worldbuildingSourceHtml.Contains('>Behance 2019 production archive <span aria-hidden="true">↗</span></a>')) 'Behance source uses the approved visible label' 'Behance source label is missing or altered'
    Assert-Check ($worldbuildingSourceHtml.Contains('>iF DESIGN AWARD 2020 entry <span aria-hidden="true">↗</span></a>')) 'iF source uses the canonical visible label' 'iF source label is missing or noncanonical'
    Assert-Check ($worldbuildingSourceHtml -notmatch [regex]::Escape('https://shortyawards.com/12th/acer-predator-universe-2')) 'Shorty is absent from the public worldbuilding source block' 'Shorty must remain secondary ledger evidence, not a public worldbuilding source'
    $wallpaperProofIndex = $worldbuildingHtml.IndexOf('<div class="wallpaper-proof-header wallpaper-proof-2023">')
    $earlyWorldbuildingHtml = if ($wallpaperProofIndex -gt 0) { $worldbuildingHtml.Substring(0, $wallpaperProofIndex) } else { $worldbuildingHtml }
    Assert-Check ($earlyWorldbuildingHtml -notmatch '(?i)<(?:img|picture|video|iframe|embed|object)\b') '2018 and 2019 worldbuilding proof remains text-only' '2018 or 2019 worldbuilding proof contains prohibited embedded media'

    Assert-Check ($worldbuildingHtml.Contains('<h4>Predator Gaming Wallpapers</h4>')) '2023 wallpaper subsection exists' '2023 wallpaper subsection is missing'
    Assert-Check ($worldbuildingHtml.Contains("In 2023, Clark helped launch Predator’s first dedicated gaming-wallpaper destination with internal design, brand, web, and social media teams.")) 'Wallpaper proof lead is exact' 'Wallpaper proof lead is missing or altered'
    Assert-Check ($worldbuildingHtml.Contains($wallpaperScope)) 'Wallpaper proof scope is exact' 'Wallpaper proof scope is missing or altered'
    Assert-Check ($wallpaperFigures.Count -eq 2 -and $wallpaperImages.Count -eq 2) 'Wallpaper proof contains exactly two figures and images' 'Wallpaper proof must contain exactly two figures and two images'
    Assert-Check ($wallpaperCaptions.Count -eq 2 -and $wallpaperCaptions[0] -eq 'Night City Merc' -and $wallpaperCaptions[1] -eq 'The New Evolution') 'Wallpaper proof captions use the exact two work titles' 'Wallpaper proof captions must be exactly Night City Merc and The New Evolution'
    Assert-Check ($wallpaperImageSources.Count -eq 2 -and $wallpaperImageSources[0] -eq 'assets/predator-wallpaper-night-city-merc.jpg' -and $wallpaperImageSources[1] -eq 'assets/predator-wallpaper-the-new-evolution.jpg') 'Wallpaper proof uses the exact review-scale assets' 'Wallpaper proof image sources are missing, reordered, or substituted'

    $completeWallpaperImages = @($wallpaperImages | Where-Object {
        $_.Value -match '\bwidth="1600"' -and
        $_.Value -match '\bheight="900"' -and
        $_.Value -match '\bloading="lazy"' -and
        $_.Value -match '\balt="[^"]+"'
    })
    Assert-Check ($completeWallpaperImages.Count -eq 2) 'Wallpaper images preserve dimensions, lazy loading, and descriptive alt text' 'Wallpaper images must use 1600x900 dimensions, lazy loading, and non-empty alt text'
    Assert-Check ($worldbuildingHtml.Contains("href=`"$wallpaperPageUrl`"") -and $worldbuildingHtml.Contains("View both works on Acer’s official Predator Gaming Wallpapers page")) 'Wallpaper proof uses the exact official page link and CTA' 'Wallpaper proof official page link or CTA is missing or altered'

    $furnitureIndex = $html.IndexOf('id="furniture"')
    $worldbuildingIndex = $html.IndexOf('id="brand-worldbuilding"')
    $enablementIndex = $html.IndexOf('id="product-sheet-enablement"')
    Assert-Check ($furnitureIndex -ge 0 -and $furnitureIndex -lt $worldbuildingIndex -and $worldbuildingIndex -lt $enablementIndex) 'Worldbuilding module sits after Furniture and before Product-Sheet Governance' 'Worldbuilding module is outside the approved case-order position'

    $wallpaperPlaceholderPattern = '(?i)\b(?:tbd|placeholder|coming soon|to be confirmed|pending confirmation|artist name)\b'
    $worldbuildingForbiddenClaimPattern = '(?is)Clark.{0,100}\b(?:created|designed|illustrated)\b.{0,60}\b(?:art|artwork|wallpaper|character|visual)|Clark.{0,100}\bmanaged\b.{0,60}\b(?:agency|artist)|Clark.{0,100}\b(?:built|designed|coded)\b.{0,60}\b(?:page|site|destination)|Clark.{0,100}\b(?:announced|published|produced)\b|Clark.{0,100}\b(?:handled|owned|led)\b.{0,60}\b(?:announcement|publication|final campaign)|Clark.{0,100}\b(?:authored|wrote)\b.{0,40}\bgraphic novel|Clark.{0,100}\b(?:won|winner|award)\b|\b(?:sole|solely)\b.{0,40}\b(?:owned|ownership|program|campaign)\b|\bShorty\s+(?:win|winner)\b|\b(?:Horizon Zero Dawn|workplace grievance|voice acting|GPC)\b|\bAI\b|\b(?:sales|revenue|audience metrics)\b'
    Assert-Check ($worldbuildingHtml -notmatch $wallpaperPlaceholderPattern) 'Worldbuilding module contains no placeholder text' 'Worldbuilding module contains placeholder text'
    Assert-Check ($worldbuildingHtml -notmatch $worldbuildingForbiddenClaimPattern) 'Worldbuilding module contains no forbidden ownership, production, award, or outcome claim' 'Worldbuilding module contains a forbidden ownership, production, authorship, award, outcome, or excluded-context claim'
}

$systemsSectionMatch = [regex]::Match($html, '(?s)<section\b[^>]*id="systems"[^>]*>.*?</section>', 'IgnoreCase')
Assert-Check ($systemsSectionMatch.Success) 'Systems & Scale section exists' 'Systems & Scale section is missing'
if ($systemsSectionMatch.Success) {
    $systemsHtml = $systemsSectionMatch.Value
    $launchCommunicationBody = 'Across verified appearances in 2018, 2019, 2020, 2021, 2022, 2023, and 2024, Clark presented Predator and Acer gaming product stories at global launch events and in official Predator Gaming videos, translating complex hardware into clear, audience-ready messaging.'
    Assert-Check ($systemsHtml.Contains('Global launch communication') -and $systemsHtml.Contains('<strong>Representing Predator on the Global Stage</strong>')) 'Global launch communication proof is present in Systems & Scale' 'Global launch communication label or heading is missing'
    Assert-Check ($systemsHtml.Contains($launchCommunicationBody)) 'Global launch communication boundary is exact' 'Global launch communication boundary is missing or altered'
    $launchCommunicationMatch = [regex]::Match($systemsHtml, '(?s)<div class="launch-communication">.*?</div>\s*</div>')
    $launchCommunicationHtml = $launchCommunicationMatch.Value
    $launchLinksMatch = [regex]::Match($launchCommunicationHtml, '(?s)<div class="launch-communication-links">(.*?)</div>', 'IgnoreCase')
    $launchLinksHtml = if ($launchLinksMatch.Success) { $launchLinksMatch.Groups[1].Value } else { '' }
    $launchAnchors = [regex]::Matches($launchLinksHtml, '<a\b[^>]*href="([^"]+)"[^>]*>(.*?)</a>', 'IgnoreCase, Singleline')
    $launchHrefs = @($launchAnchors | ForEach-Object { $_.Groups[1].Value })
    $expectedLaunchHrefs = @(
        'https://www.youtube.com/watch?v=2JW5_TxHyeY&amp;t=1985s',
        'https://www.youtube.com/watch?v=_InEZv5HRA8&amp;t=2150s',
        'https://www.youtube.com/watch?v=g76MVVTQyrc&amp;t=32s'
    )
    $launchLinkOrderExact = $launchHrefs.Count -eq 3 -and (($launchHrefs -join "`n") -eq ($expectedLaunchHrefs -join "`n"))
    Assert-Check $launchLinkOrderExact 'Global launch evidence is exactly the approved 2022, 2023, and 2024 official videos in order' 'Global launch evidence links are missing, extra, or out of order'
    $expectedLaunchLabels = @(
        '2022 next@acer — Clark introduced at approximately 33:10',
        '2023 next@acer — Clark presenting Predator Orion X at approximately 35:50',
        'Official Predator Gaming 2024 — Clark Gurden name slate at 00:35'
    )
    $launchLabels = @($launchAnchors | ForEach-Object {
        $labelWithoutArrow = [regex]::Replace($_.Groups[2].Value, '<span\b[^>]*aria-hidden="true"[^>]*>.*?</span>', '', 'IgnoreCase, Singleline')
        [System.Net.WebUtility]::HtmlDecode(([regex]::Replace($labelWithoutArrow, '<[^>]+>', ' '))).Trim()
    })
    $launchLabelsExact = $launchLabels.Count -eq 3 -and (($launchLabels -join "`n") -eq ($expectedLaunchLabels -join "`n"))
    Assert-Check $launchLabelsExact 'Global launch evidence uses the exact three visible labels' 'A global launch evidence label is missing, altered, or out of order'
    Assert-Check ($launchLinksHtml -notmatch [regex]::Escape('https://www.tech-critter.com/acer-energy-drink-predator-shot/')) 'Tech-Critter is absent from the visible launch links' 'Tech-Critter must remain internal corroboration and not appear in the public launch links'
    Assert-Check ($ledger.Contains('https://www.tech-critter.com/acer-energy-drink-predator-shot/')) 'Tech-Critter remains recorded as internal corroboration' 'The decision ledger no longer records the Tech-Critter corroboration'
    Assert-Check (@($launchAnchors | Where-Object { $_.Value -notmatch 'rel="noopener noreferrer"' }).Count -eq 0) 'All global launch evidence links use noopener noreferrer' 'A global launch evidence link is missing noopener noreferrer'
    Assert-Check ($launchCommunicationHtml -notmatch '(?i)<(?:img|figure|picture|video|iframe|embed|object)\b') 'Global launch communication remains link-only' 'Global launch communication contains prohibited media'
    $privateScreenshotPattern = '(?i)\bscreenshot\b|\.codex[\\/]|OneDrive[\\/](?:Pictures|Documents)|[A-Za-z]:\\Users\\'
    Assert-Check ($launchCommunicationHtml -notmatch $privateScreenshotPattern) 'Private screenshot filename and path are absent from public launch proof' 'Public launch proof exposes a private screenshot reference or local path'
    $launchForbiddenPattern = '(?i)\b(?:annual|annually|every[- ]year|consecutive|official spokesperson|sole keynote|sole event|equal CEO|audience metrics|voice acting|all gaming sections|FaZe partnership)\b|\b(?:launched|created|owned)\s+(?:the\s+)?Predator Shot\b|\bco[- ]?(?:hosted|keynoted)\b|\b(?:equal|shared)\s+(?:CEO\s+)?billing\b|\b(?:event|keynote|script|video|product|page)\s+(?:production\s+)?ownership\b|\b(?:script|video)\s+production\b|\b(?:wrote|authored|owned|prepared)\b[^.]{0,48}\b(?:event\s+scripts?|scripts?|CEO\s+dialogue)\b'
    Assert-Check ($launchCommunicationMatch.Success -and $launchCommunicationHtml -notmatch $launchForbiddenPattern) 'Global launch communication avoids unsupported title, year, ownership, billing, metric, and voice claims' 'Global launch communication contains an unsupported title, year, ownership, billing, metric, or voice claim'
}

Assert-Check ($html -match 'Gaming Portfolio Architecture') 'Gaming Portfolio Architecture section exists' 'Gaming Portfolio Architecture section is missing'
Assert-Check ($html -match [regex]::Escape('Representative work; contribution varied by launch.')) 'Representative coverage scope is explicit' 'Exact representative coverage scope phrase is missing'

Assert-Check ($html -match 'id="product-sheet-enablement"') 'Technical Product-Sheet Governance case exists' 'Technical Product-Sheet Governance case is missing'
Assert-Check ($html -match [regex]::Escape("Representative reconstruction illustrating Clark’s technical product-sheet workflow. Created from public specifications; confidential Acer source material is not reproduced.")) 'Public reconstruction carries the approved confidentiality label' 'The approved reconstruction label is missing or altered'

$enablementSectionMatch = [regex]::Match($html, '(?s)<article\b[^>]*id="product-sheet-enablement"[^>]*>.*?</article>', 'IgnoreCase')
Assert-Check ($enablementSectionMatch.Success) 'Technical Product-Sheet Governance section is structurally complete' 'Technical Product-Sheet Governance section could not be parsed'
if ($enablementSectionMatch.Success) {
    $enablementHtml = $enablementSectionMatch.Value
    $officialProductUrl = 'https://www.acer.com/us-en/desktops-and-all-in-ones/veriton-all-in-ones/veriton-vero-6000-all-in-one'
    $officialSpecificationUrl = 'https://news.acer.com/acer-introduces-the-veriton-ra100-ai-mini-workstation-a-windows-11-copilot-pc-powered-by-amd-ryzen-ai-max-395-processors-for-advanced-ai-performance'
    $requiredPartnerRows = @(
        'Acer Veriton Vero 6000 All-in-One example',
        'VVZ6734G / VVZ6734GT business all-in-one; options vary by model and region.',
        'Up to Intel<sup>®</sup> Core<sup>™</sup> Ultra 9 processor 285; up to 64 GB dual-channel DDR5 memory.',
        'Intel vPro<sup>®</sup> platform, TPM 2.0, and Kensington Security Slot<sup>™</sup> support.',
        'Wi-Fi<sup>®</sup> 7, Bluetooth<sup>®</sup> 5.4 wireless technology, RJ-45, USB Type-C<sup>®</sup>, USB Type-A, HDMI, and DisplayPort<sup>™</sup>.',
        'Integrated 5 MP + IR webcam, adjustable display options, and VESA<sup>®</sup> mount support.',
        'Meets MIL-STD 810H standards.',
        "Acer’s January 2026 announcement lists EPEAT<sup>®</sup> Gold registration, TCO Certified, and ENERGY STAR<sup>®</sup> 9.0 certification; exact model-and-market eligibility requires registry validation."
    )
    foreach ($requiredPartnerRow in $requiredPartnerRows) {
        Assert-Check ($enablementHtml.Contains($requiredPartnerRow)) "Partner-governed reconstruction text exists: $requiredPartnerRow" "Partner-governed reconstruction text is missing or altered: $requiredPartnerRow"
    }
    $officialProductAnchor = "href=`"$officialProductUrl`" target=`"_blank`" rel=`"noopener noreferrer`""
    $officialSpecificationAnchor = "href=`"$officialSpecificationUrl`" target=`"_blank`" rel=`"noopener noreferrer`""
    Assert-Check ($enablementHtml.Contains($officialProductAnchor) -and $enablementHtml.Contains($officialSpecificationAnchor)) 'Both official Acer reconstruction sources are linked with safe external-link attributes' 'An official Acer reconstruction link, target, or rel attribute is missing'

    $requiredAttributions = @(
        'Intel, Intel Core, and Intel vPro are trademarks of Intel Corporation or its subsidiaries.',
        'Kensington Security Slot<sup>™</sup> is a trademark of ACCO Brands.',
        'The Bluetooth<sup>®</sup> word mark is a registered trademark owned by Bluetooth SIG, Inc.',
        'Wi-Fi<sup>®</sup> is a registered trademark of Wi-Fi Alliance.',
        'USB Type-C<sup>®</sup> is a registered trademark of USB Implementers Forum.',
        'VESA<sup>®</sup> is a registered trademark and DisplayPort<sup>™</sup> is a trademark of VESA.',
        'EPEAT<sup>®</sup> is a registered trademark of Global Electronics Council.',
        'ENERGY STAR<sup>®</sup> is a registered trademark of the U.S. Environmental Protection Agency.',
        'LinkedIn<sup>®</sup> is a registered trademark of LinkedIn Corporation and its affiliates.'
    )
    foreach ($requiredAttribution in $requiredAttributions) {
        Assert-Check ($enablementHtml.Contains($requiredAttribution)) "Partner attribution exists: $requiredAttribution" "Partner attribution is missing: $requiredAttribution"
    }

    $obsoletePartnerTerms = '(?i)\bIntel Core Ultra 9;|\bIntel vPro,|\bBluetooth 5\.4\b|\bRJ45\b|\bUSB-C\b|\bUSB-A\b|\bTCO,\b|\bENERGY STAR 9\.0 certifications\b|\bMIL-STD 810H testing\b'
    Assert-Check ($enablementHtml -notmatch $obsoletePartnerTerms) 'Obsolete partner naming is absent from the reconstruction' 'The reconstruction contains obsolete or noncanonical partner naming'
}

$footerNonAffiliation = 'Independent portfolio; not affiliated with or endorsed by Acer or any referenced company, platform, standards body, or certification program. All trademarks, service marks, certification marks, and trade names are the property of their respective owners.'
Assert-Check ($html.Contains($footerNonAffiliation)) 'Footer carries the approved trademark and non-affiliation notice' 'Footer trademark or non-affiliation notice is missing or altered'

$linkedInServiceAnchors = [regex]::Matches($html, 'href="https://www\.linkedin\.com/in/clark-gurden"[^>]*>LinkedIn<sup>®</sup>', 'IgnoreCase')
Assert-Check ($linkedInServiceAnchors.Count -eq 2) 'Both visible LinkedIn service links use the owner-preferred first-use mark' 'A visible LinkedIn service link is missing its owner-preferred mark'

$enablementStages = @(
    'Technical &amp; configuration inputs',
    'Reconciliation &amp; validation',
    'Structured product sheet',
    'Tender · partner · regional-sales · web · retail outputs'
)
foreach ($stage in $enablementStages) {
    Assert-Check ($html.Contains($stage)) "Enablement workflow stage exists: $stage" "Enablement workflow stage is missing: $stage"
}

$specificationFields = @(
    'Configuration',
    'Operating system',
    'Processor and memory',
    'Security',
    'Connectivity',
    'Commercial features',
    'Reliability',
    'Compliance',
    'Regional variation',
    'Claims and disclaimers'
)
foreach ($field in $specificationFields) {
    Assert-Check ($html -match ('<dt>{0}</dt>' -f [regex]::Escape($field))) "Reconstruction field exists: $field" "Reconstruction field is missing: $field"
}

$prohibitedB2BClaims = '(?i)enterprise data[- ]center marketing|account-based marketing|pipeline ownership|direct sales ownership|tender pricing|contract negotiation'
Assert-Check ($html -notmatch $prohibitedB2BClaims) 'No unsupported B2B ownership claim exists' 'Found a prohibited B2B ownership claim'

$laptopCase = [regex]::Match($html, '(?s)<article class="case-card" id="laptops">.*?</article>')
Assert-Check ($laptopCase.Success) 'Laptop evidence case exists' 'Laptop evidence case is missing'
if ($laptopCase.Success) {
    $laptopImages = [regex]::Matches($laptopCase.Value, '<img\b[^>]*src="([^"]+)"', 'IgnoreCase')
    $laptopSources = @($laptopImages | ForEach-Object { $_.Groups[1].Value })
    $principalLaptopEvidence = $laptopSources.Count -eq 2 -and
        $laptopSources -contains 'assets/predator-helios-18-ai.jpg' -and
        $laptopSources -contains 'assets/predator-triton-14-ai.jpg'
    Assert-Check $principalLaptopEvidence 'Laptop evidence remains limited to Predator Helios 18 AI and Predator Triton 14 AI' 'Laptop evidence must contain exactly Predator Helios 18 AI and Predator Triton 14 AI'
}

$displayCards = [regex]::Matches($html, '<article\b[^>]*class="[^"]*display-proof-card[^"]*"[^>]*>', 'IgnoreCase')
Assert-Check ($displayCards.Count -le 2) 'Display proof uses no more than two products' 'Display proof contains more than two product cards'

if ($PublicationReady) {
    $displaySectionMatch = [regex]::Match($html, '(?s)<section\b[^>]*id="display-proof"[^>]*>.*?</section>', 'IgnoreCase')
    $displaySectionPresent = $displaySectionMatch.Success
    Assert-Check $displaySectionPresent 'Publication gate: verified display proof is a complete section' 'Publication gate: verified display proof section is missing'
    Assert-Check ($displayCards.Count -eq 2) 'Publication gate: display proof contains exactly two verified products' 'Publication gate: display proof must contain exactly two product cards'
    Assert-Check ($displayCards.Count -eq 2 -and @($displayCards | Where-Object { $_.Value -match 'data-display-verified="true"' }).Count -eq 2) 'Publication gate: both display products are marked verified' 'Publication gate: every display product must be marked verified'

    if ($displaySectionPresent) {
        $displayModuleHtml = $displaySectionMatch.Value
        $scopeSentence = "Across both assigned launches, Clark owned global English product-page writing and KSP/message hierarchy; handled claims, disclaimers, and specification validation; defined page structure and overall layout direction; and co-owned image approval. Product Marketing owned the product summaries, and a designer completed the final visual design and page implementation."
        $xbUrl = 'https://www.acer.com/us-en/predator/monitors/xb3-3d'
        $x34Url = 'https://www.acer.com/us-en/predator/monitors/x34-qd-oled'
        $announcementUrl = 'https://news.acer.com/acers-new-predator-and-nitro-monitors-bring-gaming-experiences-to-life'
        $immersiveCard = [regex]::Match($displayModuleHtml, '(?s)<article class="display-proof-card" data-display-verified="true" data-display-priority="immersive">.*?</article>', 'IgnoreCase')
        $competitiveCard = [regex]::Match($displayModuleHtml, '(?s)<article class="display-proof-card" data-display-verified="true" data-display-priority="competitive">.*?</article>', 'IgnoreCase')

        Assert-Check ($displaySectionMatch.Value -match 'aria-labelledby="display-proof-title"' -and $displayModuleHtml.Contains('<h3 id="display-proof-title">Two displays. Two buyer priorities.</h3>')) 'Publication gate: display proof heading and accessible label are complete' 'Publication gate: display proof heading or accessible label is missing'
        Assert-Check ($displayModuleHtml.Contains('Display messaging proof · Announced May 29, 2026')) 'Publication gate: display announcement date is explicit' 'Publication gate: exact display announcement date is missing'
        Assert-Check ($immersiveCard.Success -and $competitiveCard.Success) 'Publication gate: immersive and competitive priorities are each represented once' 'Publication gate: exact immersive and competitive card priorities are required'
        Assert-Check ($immersiveCard.Value.Contains('<h4>Predator XB273K 3D</h4>') -and $competitiveCard.Value.Contains('<h4>Predator X34 F1</h4>')) 'Publication gate: exact canonical display names are present' 'Publication gate: exact canonical display names are missing or mapped to the wrong priority'
        Assert-Check ($immersiveCard.Value.Contains('src="assets/predator-xb273k-3d.jpg"') -and $competitiveCard.Value.Contains('src="assets/predator-x34-f1.jpg"')) 'Publication gate: exact approved display image sources are used' 'Publication gate: approved display image sources are missing or mapped to the wrong product'

        $displayImages = [regex]::Matches($displayModuleHtml, '<img\b[^>]*>', 'IgnoreCase')
        $validDisplayImages = @($displayImages | Where-Object {
            $_.Value -match '\bsrc="[^"]+"' -and
            $_.Value -match '\balt="[^"]+"' -and
            $_.Value -match '\bwidth="\d+"' -and
            $_.Value -match '\bheight="\d+"' -and
            $_.Value -match '\bloading="lazy"'
        })
        Assert-Check ($displayImages.Count -eq 2 -and $validDisplayImages.Count -eq 2) 'Publication gate: both display products have complete lazy-loaded evidence images' 'Publication gate: display proof must contain exactly two images with source, alt text, dimensions, and lazy loading'
        Assert-Check ($displayModuleHtml.Contains("href=`"$xbUrl`"") -and $displayModuleHtml.Contains("href=`"$x34Url`"") -and ([regex]::Matches($displayModuleHtml, '(?i)family page').Count -eq 2)) 'Publication gate: both official family-page links are exact and clearly labeled' 'Publication gate: exact official family-page links or labels are missing'
        Assert-Check ($displayModuleHtml.Contains("href=`"$announcementUrl`"")) 'Publication gate: official display announcement link is exact' 'Publication gate: official display announcement link is missing'
        Assert-Check ($displayModuleHtml.Contains($scopeSentence)) 'Publication gate: exact shared display scope is present' 'Publication gate: exact shared display scope sentence is missing or altered'

        $placeholderPattern = '(?i)\b(?:tbd|placeholder|coming soon|to be confirmed|pending confirmation|model name)\b'
        $unsupportedDisplayOwnershipPattern = '(?is)Clark.{0,120}\b(?:owned|created|led|completed|executed|produced)\b.{0,80}\b(?:product summar(?:y|ies)|reviewer guide|photograph(?:y|ic)?|final visual design|page (?:production|implementation))\b|\bsole (?:visual|image) approval\b'
        Assert-Check ($displayModuleHtml -notmatch $placeholderPattern) 'Publication gate: display proof contains no placeholder or speculative text' 'Publication gate: display proof contains placeholder or speculative text'
        Assert-Check ($displayModuleHtml -notmatch $unsupportedDisplayOwnershipPattern) 'Publication gate: display proof contains no unsupported ownership phrase' 'Publication gate: display proof contains unsupported photography, design, production, summary, guide, or sole-approval ownership'
    }

    Assert-Check ($html -notmatch [regex]::Escape('Global English copymaster plus review and approval of global product-page visual content where supported.')) 'Publication gate: obsolete generic display boundary is absent' 'Publication gate: obsolete generic display boundary remains'
}

$architectureRows = @(
    @{ Label = 'Predator Helios'; Model = 'Predator Helios 18 AI' },
    @{ Label = 'Predator Triton'; Model = 'Predator Triton 14 AI' },
    @{ Label = 'Neo variants (Predator Helios Neo / Predator Triton Neo)'; Model = 'Assigned Predator Helios Neo / Predator Triton Neo launches' },
    @{ Label = 'Predator Orion'; Model = 'Predator Orion X' },
    @{ Label = 'Acer Nitro'; Model = 'Acer Nitro 17' },
    @{ Label = 'Acer Nitro V'; Model = 'Acer Nitro V 15' }
)
foreach ($row in $architectureRows) {
    $rowPresent = $html.Contains($row.Label) -and $html.Contains($row.Model)
    Assert-Check $rowPresent "Architecture row exists: $($row.Label) / $($row.Model)" "Architecture row is missing: $($row.Label) / $($row.Model)"
}

$orionAudience = 'Desktop messaging varied by performance, chassis, cooling, and upgrade story; no fixed ladder is asserted'
$orionContribution = "Clark wrote the global English product-page copy and messaging/KSP hierarchy; defined the page structure, content hierarchy, and overall layout direction; and presented Predator Orion X during the 2023 next@acer Global Press Conference. Specialist teams handled final visual production and page implementation."
$orionAnnouncement = 'https://news.acer.com/acer-unleashes-the-predator-orion-x-desktop-and-curved-monitors-for-gaming-enthusiasts'
$orionAwardContext = "The product received 2024 Red Dot Product Design, iF Design Award, Golden Pin Design Award, and Taiwan Excellence recognition. These are product/team awards, not page-performance proof or Clark's individual awards."
$orionSourcesPresent = $html.Contains("href=`"$orionAnnouncement`"") -and
    $html.Contains('href="https://www.acer.com/gb-en/awards/2024"') -and
    $html.Contains('href="https://www.taiwanexcellence.org/en/award/product/1130588"')
Assert-Check ($html.Contains($orionAudience)) 'Predator Orion family and audience wording is preserved' 'Predator Orion family or audience wording is missing or altered'
Assert-Check ($html.Contains($orionContribution)) 'Predator Orion X contribution and specialist-production boundary are exact' 'Predator Orion X contribution or specialist-production boundary is missing or altered'
Assert-Check ($html.Contains($orionAwardContext)) 'Predator Orion X award context preserves the product/team boundary' 'Predator Orion X award context is missing or implies personal or page-performance proof'
Assert-Check $orionSourcesPresent 'Predator Orion X uses the approved official announcement and award sources' 'A required Predator Orion X official source is missing or altered'
Assert-Check ($html.Contains('<strong>Gaming desktops</strong><span>Predator Orion X; Acer Nitro gaming desktops</span>')) 'Gaming-desktop coverage names Predator Orion X' 'Gaming-desktop coverage does not use the verified Predator Orion X representative product'
$orionUnsupportedPattern = '(?is)Clark.{0,100}\b(?:designed|created)\b.{0,60}\b(?:Predator Orion X|industrial design)\b|Clark.{0,100}\b(?:owned|led)\b.{0,60}\b(?:event|keynote|page implementation|visual production)\b'
Assert-Check ($html -notmatch $orionUnsupportedPattern) 'Predator Orion X avoids unsupported design, event, keynote, implementation, and award ownership' 'Predator Orion X contains an unsupported design, event, keynote, implementation, or individual-award claim'

Assert-Check ($html -notmatch '(?i)performed well') 'No unsupported “performed well” claim exists' 'Found prohibited “performed well” outcome claim'
$neoSafetyText = $html.Replace('no single standalone Neo tier is asserted', '')
$unqualifiedNeoPattern = '(?i)\bNeo\s+(?:(?:is|as)\s+(?:an?\s+)?)?(?:standalone|entry|value|mainstream|mid|premium|upper|performance)?\s*tier\b'
Assert-Check ($neoSafetyText -notmatch $unqualifiedNeoPattern) 'No unqualified Neo tier is asserted' 'Found prohibited unqualified Neo tier language'
$orionLadderPattern = '(?is)\bOrion\b.{0,100}\b(?:Neo|X|3000|5000|7000)\b.{0,80}\b(?:tier|ladder)\b|\b(?:Neo|X|3000|5000|7000)\b.{0,80}\bOrion\b.{0,80}\b(?:tier|ladder)\b'
Assert-Check ($html -notmatch $orionLadderPattern) 'No inferred Orion ladder is published' 'Found prohibited inferred Orion ladder language'

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
    Assert-Check ($resumeText -match 'Through July 2026') 'Resume states the gaming-PC messaging period' 'Resume is missing the through-July-2026 scope'
    Assert-Check ($resumeText -match 'assigned hardware releases annually') 'Resume states assigned-launch scope' 'Resume is missing assigned-launch scope'
    Assert-Check ($resumeText -notmatch '(?i)performed well') 'Resume contains no unsupported “performed well” claim' 'Resume contains prohibited “performed well” outcome language'
    $resumeNeoSafetyText = $resumeText.Replace('no standalone Neo tier', '')
    Assert-Check ($resumeNeoSafetyText -notmatch $unqualifiedNeoPattern) 'Resume asserts no unqualified Neo tier' 'Resume contains prohibited unqualified Neo tier language'
    Assert-Check ($resumeText -notmatch $orionLadderPattern) 'Resume publishes no inferred Orion ladder' 'Resume contains prohibited inferred Orion ladder language'
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
