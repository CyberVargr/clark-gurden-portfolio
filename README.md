# Clark Gurden Product Marketing Portfolio

A dependency-free, single-page static portfolio. Open `index.html` through a local web server; `styles.css` contains the visual system and responsive layouts, and `script.js` handles the mobile menu and current year.

The canonical positioning is “Clark Gurden | Senior Product Marketing & Global Brand Strategy.” The hero must frame the work through Gaming Hardware, Portfolio Architecture, and Global GTM & Enablement, with supporting copy that demonstrates positioning, claims governance, launch systems, technical sales enablement, and brand worldbuilding rather than reducing the role to copywriting.

## Structure

- `index.html` - all page content, metadata, structured data, links, and section anchors
- `styles.css` - visual system and desktop/tablet/mobile/print layouts
- `script.js` - small progressive enhancement for mobile navigation
- `assets/` - optimized case-study evidence images
- `downloads/` - public portfolio PDF and resume
- `AGENTS.md` - factual and visual guardrails for future updates
- `CONTENT_DECISION_LEDGER.md` - evidence boundaries, unresolved claims, and publication decisions
- `CHATGPT_REVIEW.md` - upload-ready brief for an independent ChatGPT review
- `tools/validate-site.ps1` - repeatable local guardrail and asset check

## Updating files

Replace the files in `downloads/` while keeping the current filenames to avoid changing links. If a filename changes, update the corresponding link in `index.html`.

To update a case study, edit its `<article>` in `index.html`, place any new optimized image in `assets/`, and preserve the claims in `AGENTS.md`. Use descriptive alt text and `loading="lazy"` for images below the first case.

Use natural content height. Reflow or stack a case, adjust its grid, constrain copy width, or rebalance spacing instead of creating empty evidence slots, stretching cards, or adding unrelated products as filler.

## Evidence and synchronization

Before approving a factual or positioning change, check the same subject in:

- `index.html`
- `AGENTS.md`
- the portfolio PDF
- the résumé
- page metadata and structured data, when relevant
- this maintenance guide

Synchronize the claim and positioning boundary rather than forcing website-only layout material into the PDF.

Canonical product naming is a publication requirement across visible site copy, link labels, accessibility text, maintenance sources, the portfolio PDF, and the résumé. Use the complete official public name every time a specific model or product is identified: for example, Acer Nitro Blaze Link, Acer Nitro V 15, Predator Helios 18 AI, Predator Triton 14 AI, Predator Helios Neo, Predator Triton Neo, Predator Thronos Air, Predator Rift 371, Predator Gaming Desk, Predator XB273K 3D, and Predator X34 F1. Do not shorten a name after first mention or alter URLs, asset filenames, CSS identifiers, or anchors to enforce this rule.

The verified display-proof module uses Predator XB273K 3D for an immersive priority and Predator X34 F1 for a competitive priority; both were announced May 29, 2026. Preserve the exact product names, the two local newsroom images, the family-page links, and the [official announcement](https://news.acer.com/acers-new-predator-and-nitro-monitors-bring-gaming-experiences-to-life).

Across both assigned launches, Clark owned global English product-page writing and KSP/message hierarchy; handled claims, disclaimers, and specification validation; defined page structure and overall layout direction; and co-owned image approval. Product Marketing owned the product summaries, and a designer completed the final visual design and page implementation.

If future maintenance removes either verified display example or makes its contribution evidence unavailable, remove the complete module and allow the remaining approved portfolio to publish. Never use placeholder cards, speculative models, unsupported ownership claims, unrelated substitute products, or empty image spaces.

The unnumbered Brand Worldbuilding & Creative Direction module spans three verified phases without becoming another case or navigation item. For 2018, Clark originated and wrote the early Predatorverse source narrative and system inside Acer; external writers, artists, and agencies adapted and produced the final novels, campaign, and visual assets. [Vanquish Media Group](https://vanquishmediagroup.com/projects/acer-predator/) documents its final campaign production, while the [Shorty campaign entry](https://shortyawards.com/12th/acer-predator-universe-2) documents the five-character universe and credits Vanquish Media Group with Acer. For 2019 Summon Your Strength, Clark originated the tribe-led strategic direction and contributed substantial on-video text and story-continuity language; the finished Acer and We Are Social campaign received an [iF Design Award in 2020](https://ifdesign.com/en/winner-ranking/project/predatorverse-2019-summon-your-strength/279455).

The 2023 wallpaper proof uses exactly two 1600x900 review derivatives: Night City Merc and The New Evolution. Keep the supplied full-resolution originals read-only and outside the repository, preserve the complete 16:9 compositions, and link only to Acer’s [official Predator Gaming Wallpapers page](https://www.acer.com/us-en/predator/gaming-wallpaper).

For Night City Merc and The New Evolution, Clark selected the commissioned artists, set the creative vision, and guided each work through briefs, iterative input, and final creative selection. A colleague managed agency and direct-artist coordination; the commissioned artists created the finished artwork. The social media team handled announcement and publication. Do not extend this into artwork creation, artist or agency management, page design/production, sole program ownership, social announcement/publication ownership, outcomes, artist names, or social-media screenshots.

Do not extend the 2018/2019 proof into sole final-campaign ownership, final character/visual design, graphic-novel authorship, production, agency management, campaign results, personal award ownership, voice acting, unverified names, or a Shorty win. Keep those subsections text-only.

Systems & Scale may state: “Across verified appearances in 2019, 2020, 2021, and 2023, Clark presented Predator product stories at Acer global press and launch events, translating complex gaming hardware into clear, audience-ready messaging.” Preserve the [public 2019-2021 event entries](https://tw.linkedin.com/in/clark-gurden) and [independent 2023 event coverage](https://newsbytes.ph/2023/04/22/acer-trains-eyes-on-ai-sustainable-computers-gaming/), without implying consecutive years, an official spokesperson title, sole event ownership, equal CEO billing, audience metrics, or voice acting.

Never add internal product sheets, codenames, metadata, employer-owned working files, or reproductions of internal documents to this repository.

## Preview locally

From this folder, run:

```powershell
python -m http.server 8000
```

Then open `http://localhost:8000/`. Stop the server with Ctrl+C.

Run the non-browser content and asset checks with:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\validate-site.ps1
```

## Approval and GitHub Pages publication

Keep work local until Clark approves the wording, reconstruction, layout, display selections, and screenshots. After approval:

1. Commit only the approved files.
2. Push the approved commit to the configured GitHub remote.
3. Confirm GitHub Pages deploys that commit successfully.
4. Test the public URL at desktop and mobile widths.
5. Verify images, links, downloads, canonical metadata, social-preview metadata, navigation, and console behavior.
6. Record the public URL, deployed commit hash, and public-site QA result.
