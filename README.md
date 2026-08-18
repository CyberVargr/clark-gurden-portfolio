# Clark Gurden Product Marketing Portfolio

A dependency-free, single-page static portfolio. Open `index.html` through a local web server; `styles.css` contains the visual system and responsive layouts, and `script.js` handles the mobile menu and current year.

## Structure

- `index.html` - all page content, metadata, structured data, links, and section anchors
- `styles.css` - visual system and desktop/tablet/mobile/print layouts
- `script.js` - small progressive enhancement for mobile navigation
- `assets/` - optimized case-study evidence images
- `downloads/` - public portfolio PDF and resume
- `AGENTS.md` - factual and visual guardrails for future updates

## Updating files

Replace the files in `downloads/` while keeping the current filenames to avoid changing links. If a filename changes, update the corresponding link in `index.html`.

To update a case study, edit its `<article>` in `index.html`, place any new optimized image in `assets/`, and preserve the claims in `AGENTS.md`. Use descriptive alt text and `loading="lazy"` for images below the first case.

## Preview locally

From this folder, run:

```powershell
python -m http.server 8000
```

Then open `http://localhost:8000/`. Stop the server with Ctrl+C.

## Publish later with GitHub Pages

Create a GitHub repository, push the local branch, then enable Pages in repository Settings → Pages and deploy from the root of the chosen branch. Before publishing, choose the final public domain, add a canonical URL, replace relative Open Graph image metadata with an absolute URL, and recheck every external link.
