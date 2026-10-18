# Portfolio handoff — October 18, 2026

## Start here on the new PC

- Repository: https://github.com/CyberVargr/clark-gurden-portfolio
- Handoff/working branch: `handoff/pc-migration-20261018`.
- Published branch: `main`; GitHub Pages publishes its root directory. Pushing the handoff branch does not deploy it under the settings checked on October 18.
- Live site: https://cybervargr.github.io/clark-gurden-portfolio/
- Published baseline: `99ff705a111f111ff22707ab477ccf2bd9a4c3ac`. GitHub's latest Pages build was `built` for that commit when checked October 18.

```powershell
git clone --branch handoff/pc-migration-20261018 https://github.com/CyberVargr/clark-gurden-portfolio.git
cd clark-gurden-portfolio
git status --short --branch
```

Read this file, [AGENTS.md](AGENTS.md), and [CONTENT_DECISION_LEDGER.md](CONTENT_DECISION_LEDGER.md) before editing. [README.md](README.md) is the maintenance guide. This is a documentation-only migration, not approval to change or publish the website.

Do not copy the old release checkout's `.git` pointer to the new machine. It was a linked worktree dependent on another folder. A fresh clone is self-contained.

## Git state and preservation

Before this handoff, the release worktree was clean, with no untracked files or stashes, and exactly matched freshly fetched `origin/main` at `99ff705`. There were no pending website edits to rescue.

The older local checkout had a different local `main`: `016f76853d9ce17f8d29e4e592a88409cbd08bff`, one commit ahead and nine behind public `main`. This is the explicitly rejected governance commit. It is NOT part of the published release. Do not merge, cherry-pick, or push it. The new PC should use the remote branches above, not that old local `main`.

A separate private migration package preserves Git history, including the rejected local commit, through a Git bundle. It also preserves selected private working files and QA evidence through an allowlisted ZIP. Neither archive belongs in this public repository. See the migration package's `TRANSFER.md` for offline restoration and limitations. No files in the old checkout were deleted, reset, or overwritten.

The old checkout also has six ignored legacy files. They are deliberately not treated as pending website edits or blindly included in the private ZIP. Their originals remain untouched on the old PC; inspect them privately before retiring that PC. Ignored files, unrelated application résumés, credentials, and employer-owned source documents are not provided by a fresh clone or Git bundle.

## Current implementation

This is a small static site, not a framework application. No npm build or server-side service is needed.

- `index.html`: content, metadata, JSON-LD, evidence links, downloads, Google ownership tag, Cloudflare beacon.
- `styles.css`: responsive visual system; `script.js`: mobile menu, year, audience-focused filtering.
- `assets/`: optimized approved public-evidence images, favicon, audience-neutral social preview.
- `downloads/`: public portfolio PDF (8 pages) and résumé PDF (2 pages), last rendered and reviewed October 12.
- `tools/validate-site.ps1`: content/asset/claim checks, with optional `-PublicationReady` and `-PythonExecutable`.

There is no editable résumé master or reproducible document-authoring toolchain inside the repository. A private Word draft and prior review scripts are migration aids, not an automatically approved publishing source. Some older scripts contain old-PC runtime paths and must be adapted and reviewed before use.

### Approved design and navigation

- Keep the lead identity **Senior Product Marketing & Global Brand Strategy**, spanning consumer, gaming, and commercial hardware. Do not turn the universal portfolio into a copywriter-first site or duplicate it by country.
- Current public location is the Greater Lansing area, Michigan, United States. Taipei is historical Acer employment, not current residence. Use the already approved contact details; never publish a street address or infer work authorization.
- Retain the restrained editorial system: navy `#172b4d`, blue-gray `#58718b`, light `#f2f5f8`, accent `#1a96b1`, and existing accessible stronger/light accent variants. Preserve typography, CTA hierarchy, spacing, contrast, focus treatments, skip link, and mobile controls.
- The full view starts with Predator Atlas 8, then the flagship Predator Gaming Technology Hub, then the unnumbered four-excerpt Selected Writing Voice module. Existing cases, coverage matrix, display proof, furniture, worldbuilding, B2B case, Systems & Scale, and About retain their approved order. B2B remains case 06; moving it earlier was discussed, not approved in this handoff.
- “Choose your focus” is implemented as real filtered views, NOT merely three anchors into the same long page. `script.js` uses `?focus=strategy`, `?focus=creative`, or `?focus=technical` to hide unrelated evidence sections. Hero, route choices, scope note, and About/contact remain available. The status banner lets visitors return to the complete portfolio. Without JavaScript, the complete page is the fallback.
- Share the corresponding `?focus=...#focus-view` URL for an application. `#writing-proof`, `#product-sheet-enablement`, `#systems`, and `#contact` are stable direct anchors in the appropriate/full view. Do not link a creative-only section inside a technical-only filtered view.
- Header Contact points to the visible on-page email (`#contact`), with a focusable target. Only “Email Clark” is a `mailto:` action; an email-app chooser there is expected.
- Page title, description, and social-preview asset are audience-neutral rather than exclusively gaming branded. Keep canonical/Open Graph URLs absolute and consistent with the live host.

### Image decisions: do not regress the crop fix

- Primary evidence uses complete images at natural aspect ratios, explicit width/height attributes, and no forced equal-height/cover crops: Predator Atlas 8, Acer Nitro Blaze Link, both principal laptops, furniture, and the Hub overview.
- Predator Atlas 8 is full-width above restrained-width copy. The case grid collapses at 1100px. Predator Helios 18 AI and Predator Triton 14 AI stack at 680px and below.
- Furniture retains the desktop gallery hierarchy and natural mobile proportions. Do not restore the old mobile aspect-ratio crop.
- The Hub overview remains dominant and complete. Supporting modules intentionally remain equal, top-anchored editorial thumbnails. Graphene TIM alone has its approved individual `contain` treatment; do not remove it, blanket-contain the other thumbnails, or stack three long screenshots into a mobile image dump.
- Use the two approved wallpaper derivatives, not social-post screenshots or full-resolution originals. No new carousels, animations, decorative filler, lightboxes, or dependencies are approved by this handoff.

## Council feedback and decisions already resolved

The “council” is AI-assisted specialist review, not an external human advisory board, employer endorsement, or legal clearance. Responsibilities have been grouped across a few read-only agents; one root agent implements.

- **Skim/positioning/editorial:** surface distinct entry points for strategy, creative voice, and technical enablement without changing the senior identity. Short route descriptions and matching link labels were approved. Route filtering resolves the competing audiences better than repeatedly reordering the whole page.
- **Hiring-side/B2B:** show technical interpretation, specification reconciliation, governance, and audience adaptation, not merely document formatting. Preserve broader hardware and creative evidence rather than recasting Clark as primarily B2B.
- **Evidence/confidentiality:** official links verify published product context, not individual authorship. Preserve local designer/agency/partner boundaries, consolidate generic caveats without deleting specific limitations, and remove disputed product-sheet counts.
- **Visual/UX/accessibility:** complete, legible evidence beats equal-height imagery. Fresh QA caught and corrected a pale note style on white. Keep current scoped contrast fixes, 44px mobile targets, route visibility, and keyboard/menu behavior.
- **Scope/process:** the elaborate governance change in `016f768` was rejected and excluded from the release. Do not resurrect it or add new process as a substitute for requested fixes. Existing `AGENTS.md` still defines the current review disciplines; changing those instructions requires Clark's direction, not an assumption during migration.

Required review disciplines in the current `AGENTS.md`: decision lead/orchestrator; prompt/context engineer; portfolio/editorial architect; visual design director; responsive UX/accessibility; hiring-side Product Marketing; gaming-hardware market/evidence; B2B enablement; evidence/attribution/confidentiality; frontend implementation; independent QA/links/deployment verification.

Historical release evidence: October 12 factual/download changes (`edbd08b`), on-page Contact (`a02d09c`), and search/analytics setup (`99ff705`) passed scoped editorial/evidence and independent technical/visual review. Public browser tests covered 1440, 1024, 768, and 390px and the three focused views. The final analytics release passed seven public configurations, with beacon GET 200, RUM POST 204, and no console errors, overflow, or Contact/menu regression. These are dated results, not a fresh October 18 browser audit.

## Content, authorship, and confidentiality constraints

The exact case-specific boundaries in `AGENTS.md` and the decision ledger remain authoritative; this summary does not broaden them.

- Acer tenure: April 2016–July 2026; 10+ years at headquarters. Approved scale is 20–30 assigned global launches annually. Product-sheet breadth is quantity-free. Do not restore any unconfirmed product-sheet count or annualized rate.
- Regional terms: EMEA, Pan America, Pan Asia Pacific. North and Latin America are within Pan America. No inferred channel/distributor ownership, direct sales, demand-generation, CRM, pipeline, revenue, tender pricing/negotiation, or enterprise data-center experience.
- Preserve full official product names and existing partner/trademark wording. No speculative family ladders, blanket ownership of every monitor, product-design award inventory, or unsupported outcomes/traffic/conversion metrics.
- Predator Atlas 8 and Acer Nitro Blaze Link have confirmed product-summary scope. Only Predator Atlas 8 has the reviewer guide. Predator Atlas 7 is supporting text for pre-launch product-summary preparation before departure: no final approval, later revisions, announcement/circulation, launch execution, or transferred copymaster/reviewer-guide claim.
- Principal laptop visuals remain Predator Helios 18 AI and Predator Triton 14 AI. Display proof is exactly Predator XB273K 3D and Predator X34 F1, with distinct audience priorities and the approved shared contribution boundary. Product Marketing owned display summaries; a designer executed final visual design and page implementation. If a verified display example becomes unsupported, omit the complete module rather than publishing placeholders.
- Keep the four writing excerpts exact, ordered, image-free, and linked to official sources: Predator X35, Predator Thronos Air, Predator Helios Neo 14, Predator Cestus 535. Claim the selected passages, not all partner language or every part of those pages.
- Predator Orion X page copy, message hierarchy, structure/layout direction, and the 2023 presentation have specific boundaries. Specialist teams executed final visuals and implementation. Other desktop writing and product/pillar-link planning do not imply launch ownership, coding, sole SEO/GEO ownership, flagship status, or measurable results.
- Predatorverse and Summon Your Strength source narrative/direction are distinct from agency, writer, artist, and final-production roles. No personal ownership of campaign awards. The two wallpaper works demonstrate creative vision/input/selection, not illustration, direct artist/agency management, or social publication ownership.
- Enterprise DAM/CMS remains generic until the exact platform is verified. Hands-on publishing/version cleanup is not platform administration/implementation or management of all assets. Do not turn internal product-summary updates into regional DAM/CMS notification ownership or invented stakeholder counts.
- Global handoffs do not prove remote employment, rare timezone overlap, unsupervised regional delivery, or outcomes. Preserve the bounded collaboration language.
- Employer-owned source documents remain read-only outside the project. Never copy, move, edit, commit, publish, reproduce, or extensively quote them, their template, filenames, codenames, or metadata. Public B2B evidence is an original public-specification reconstruction with its existing confidentiality label and model/market caveats.
- Do not reintroduce a nonexistent second learning app or represent Mandarin Forge as a shipped product. No new personal-project or AI-native route is approved.
- Show the exact résumé wording diff to Clark BEFORE replacing the public download. Tailored application résumés are separate from the general public PDF; do not silently substitute one. Synchronize approved factual changes across relevant site copy, guardrails, metadata, résumé, portfolio PDF, and maintenance guidance without forcing website layout into a PDF.

## Search, analytics, and account continuity

The live homepage contains Google's public `google-site-verification` tag and Cloudflare's public beacon configuration. Keep both intact. They are not account-login secrets, and no account passwords, session cookies, API keys, or browser profiles are part of this handoff.

Last verified **October 12, 2026**:

- Google Search Console URL-prefix property is the exact canonical portfolio URL. HTML-tag ownership verification succeeded. The earlier HTML-file failure was resolved by using the tag, not by uploading that file.
- URL Inspection reported the homepage unknown/not indexed; Request indexing succeeded and placed it in the priority crawl queue. This did not establish indexing or ranking. No subsequent indexing status has been checked in this handoff.
- Free Cloudflare Web Analytics was configured for `cybervargr.github.io` without changing DNS, proxy, or hosting. Its script and ingestion endpoint worked; the initial dashboard showed one setup-test visit/page view, not evidence of a recruiter visit. Historical views before setup cannot be reconstructed from it.
- On the new PC, sign in separately to the existing owning Google and Cloudflare accounts. Search Console reports Google search performance, not all visits; Cloudflare reports site traffic/performance, not recruiter identity. No custom download-click/contact events or session replay were configured.
- No custom domain has been purchased or connected. Do not change host, canonical URLs, verification, DNS, or billing without a separately approved migration plan.

## Outstanding work, prioritized

1. **New-PC readiness:** clone this branch, sign in to GitHub only when needed, install preview/validation prerequisites, and run the checks below. Confirm the private migration ZIP/bundle copied successfully before retiring the old PC.
2. **Read-only measurement check:** revisit Search Console indexing and Cloudflare after signing in. Record actual dates/ranges, separate test traffic from external visits, and do not repeatedly request indexing or claim organic results without data.
3. **Document source continuity:** establish a reviewed editable résumé source and rendering workflow if document edits are needed. The private DOCX draft is unrendered; the public PDF is the last visually verified version. Both current public PDFs are untagged; do not claim PDF accessibility conformance. No additional document edit is approved here.
4. **Maintenance-document drift:** `CHATGPT_REVIEW.md` still has older gaming-only audience framing and obsolete regional wording. Early ledger language also predates the broader October hero framing. Treat current approved site/guardrails and later dated decisions as the current state; flag these maintenance-only inconsistencies for a later scoped correction, not a website rollback.
5. **Evidence durability:** an existing private archive preserves 15 approved image assets plus four accessible official-newsroom captures. Some product-page captures were blocked; complete public-source archiving only where accessible and lawful. Never fabricate captures, infer authorship from an archive, or transfer confidential employer sources.
6. **Optional, not blockers:** personal domain, further excerpt formats, naming proof, alternative ordering, geographic variants, and a future personal-project route require their own evidence/approval. Do not let these displace applications or turn this migration into a redesign.

## Preview and validate locally

Install Git and Python 3; **PowerShell 7 (`pwsh`)** is required for the existing validator. Windows PowerShell 5.1 was tested during migration and fails this script; do not use its `powershell.exe` invocation from the older README. Browser preview needs only Python, not Node/npm. Use a maintained Python release; the last checks used a Python environment with `pypdf`.

From the repository root, run:

```powershell
python -m http.server 8000 --bind 127.0.0.1
```

Open http://127.0.0.1:8000/ and stop with Ctrl+C. If Windows exposes Python as `py`, substitute `py -3` for `python` in both the preview and environment-creation commands.

Test the complete page and these routes, not just the hero:

- http://127.0.0.1:8000/?focus=strategy#focus-view
- http://127.0.0.1:8000/?focus=creative#focus-view
- http://127.0.0.1:8000/?focus=technical#focus-view
- http://127.0.0.1:8000/#product-sheet-enablement
- http://127.0.0.1:8000/#contact

For isolated validation dependencies outside the clone, run the following in **PowerShell 7 on Windows** (`pwsh`). Choose a different sibling environment name if `portfolio-tools` already belongs to another project.

```powershell
python -m venv ../portfolio-tools
& ../portfolio-tools/Scripts/python.exe -m pip install pypdf
& ./tools/validate-site.ps1 -PythonExecutable ../portfolio-tools/Scripts/python.exe
& ./tools/validate-site.ps1 -PublicationReady -PythonExecutable ../portfolio-tools/Scripts/python.exe
```

If script execution is blocked, use an appropriate trusted per-process invocation rather than changing machine-wide policy:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File ./tools/validate-site.ps1 -PublicationReady -PythonExecutable ../portfolio-tools/Scripts/python.exe
```

On macOS/Linux, preview with `python3`; the validator additionally needs PowerShell (`pwsh`) and a valid `-PythonExecutable` path. Do not transplant the old PC's bundled runtime paths.

Inspect the entire page at **1440, 1024, 768, 390px**, and all three focused views. Check primary image completeness/ratio, the individual Graphene TIM frame, readable evidence at 1024px, keyboard/focus/contrast, mobile menu/Escape, Contact, no overflow/console errors, official links, and both PDF downloads. Local validators do not replace visual inspection or certify live external links. Test in a real phone browser before a subsequent publication. A localhost analytics hostname mismatch is not a reason to alter the production beacon.

## GitHub Pages deployment — instructions only, not authorized now

Current settings checked October 18: public repository; default branch `main`; Pages `build_type: legacy`; source `main` / `/`; HTTPS enforced; no custom domain. No checked-in Actions workflow. Verify these settings again before any future push intended to deploy.

After Clark approves the exact proposed changes and applicable screenshots/download diffs:

1. Fetch and inspect: `git fetch origin`, `git status --short --branch`, `git diff`, `git log --oneline origin/main..HEAD`. Resolve unexpected changes without resetting user work. Never use the old rejected local branch.
2. Stage only named, approved files; inspect the staged diff and run validation/visual QA. Commit them with a descriptive message. Never use blanket staging for private transfer artifacts.
3. Confirm `origin/main` is an ancestor of the reviewed `HEAD` using `git merge-base --is-ancestor origin/main HEAD` (exit 0). Stop if it is not; do not force-push or merge an unknown/rejected history.
4. Only with publication authorization, push that approved head to the deployment branch: `git push origin HEAD:main`. Pushing only the handoff branch does not deploy the site under the current settings.
5. Confirm Pages builds the exact approved SHA, not merely that a workflow is green. With GitHub CLI authenticated:

   ```powershell
   gh api repos/CyberVargr/clark-gurden-portfolio/pages/builds/latest --jq '{status: .status, commit: .commit, error: .error.message}'
   ```

6. Test the public URL at desktop/mobile widths, all routes, images, Contact/menu, external links, PDF downloads, canonical/Open Graph/social preview, Google verification tag, beacon/no console errors. A stale open tab may need a reload; distinguish cached DOM from the actual deployed source.
7. Return the public URL, exact deployed SHA, QA result, and any genuine remaining blocker. Do not call an indexing request a successful search listing or count test visits as hiring interest.

## Migration review record

Root owns scope, contextual continuity, preservation, and the no-deployment decision. Read-only review disciplines are grouped as follows: content architect (editorial/portfolio architecture, hiring-side PMM, B2B enablement); evidence reviewer (hardware market/evidence, attribution/confidentiality); fresh QA (design, responsive UX/accessibility, frontend, independent Git/commands/deployment verification). These are AI-assisted review perspectives, not new roles or governance architecture.

This round changes documentation only. Website source, assets, PDFs, existing guardrails, and validators remain identical to `99ff705`. The rejected commit is preserved privately, not promoted. Review outcomes and verified transfer checks are recorded in the private migration receipt; remaining account/reporting and private-file transfer tasks are listed above.
