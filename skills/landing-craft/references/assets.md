# Assets — every image is real or crafted, never a broken placeholder (load in design + build)

A landing dies on missing/ugly images (the #1 "alive" lever — see `alive-not-generic.md`). So the
workflow PRODUCES real assets and leaves the user a clean slot for the few it can't invent. Lean on
the bundled **`web-assets`** skill (rasterise HTML/SVG → PNG via Playwright + icotool — no
ImageMagick needed) and the `design.md` imagery spec.

## 1. Make the assets folder
Create the project's static dir: **Next.js → `public/`** (`public/images/`, `public/og/`,
favicons at `public/`). All `<img src>`/`background` paths point here. Never reference an asset that
doesn't exist.

## 2. Split: what we GENERATE vs what the user PROVIDES
From `design.md`'s imagery spec:

**Generate (do it — don't leave stubs):**
- **Signature hero visual** — the brand's one distinctive graphic. Author it as a crafted **SVG**
  (gradients, the brand motif, geometric/illustrative) OR an HTML scene rendered to PNG via
  `web-assets` (à la the network-nodes seal we built — tools, not stock). This is the page's soul.
- **Decorative SVGs** — backgrounds, dividers, motif accents, icon set (inline SVG / lucide-style).
- **OG / social card** — 1200×630, on-brand, via `web-assets` (HTML → Playwright screenshot).
- **Favicons** — `favicon.ico` (16/32/48 via icotool) + `favicon.svg` + `apple-touch-icon.png` +
  `manifest` icons, from the logo/mark.

**Ask the user (can't be invented):**
- **Real logo** and **real product/team photos**. First, try to reuse what RESEARCH scraped (if a
  logo URL was found, fetch it to `public/`). Otherwise: drop a clearly-named **placeholder** that's
  on-brand (a tasteful SVG, not a grey box) AND tell the user in the final report exactly where to
  put theirs, e.g. *"replace `public/logo.svg` and `public/images/product-1.jpg` with your real
  files (same names) — everything else is generated."* Generate good defaults so it never looks
  broken before they swap.

## 3. Tooling (install if missing — don't fail)
- **Playwright** for rendering HTML/SVG scenes and the OG card. If browsers aren't present:
  `npx playwright install chromium` (or use the Playwright MCP if available). Serve a temp HTML over
  `python3 -m http.server` and screenshot at the exact size (file:// is blocked) — the `web-assets`
  pattern.
- **icotool** (from `icoutils`) for `.ico`. If absent, ship PNG favicons + the `.svg` and note it.

## 4. Quality bar for generated images
On-brand colours/tokens, crisp (2× for raster where it matters), `alt` text on every `<img>`,
correct dimensions (no CLS), lazy-load below the fold, modern formats (SVG/WebP) where possible.
Generated images must pass the same "not generic / alive" test — no stock-looking filler.

## Output
`public/` populated: signature hero visual + OG card + favicons + decorative SVGs generated; real
logo/photos either fetched or left as named on-brand placeholders with clear swap instructions in
the final report. No `<img>` points at a missing file.
