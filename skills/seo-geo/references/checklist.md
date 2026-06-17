# SEO + GEO/AEO checklist & schema templates (load on demand)

Dense reference for `seo-geo`. Apply per page before shipping.

## 1. Technical SEO — ship checklist
- One `<h1>`; logical `<h2>`/`<h3>` outline. Semantic landmarks (`header/nav/main/article/footer`).
- `<title>` ≤60 chars, primary term first. `<meta name="description">` ≤155 chars, benefit + term.
- `<link rel="canonical">` on every page. Clean readable URLs (`/producto/nombre`, not `?id=92`).
- `robots.txt` (allow crawl, link the sitemap). XML `sitemap.xml` listing canonical URLs.
- Open Graph + Twitter card tags (generate the image via `web-assets`).
- `alt` on every meaningful image; descriptive `<a>` text (never "click here").
- `lang` attribute; `hreflang` if multi-language.
- Core Web Vitals: LCP <2.5s, INP <200ms, CLS <0.1. Lazy-load below-the-fold, set image dimensions to avoid CLS, preload the LCP image.

## 2. On-page — intent match
- Map each page to ONE keyword cluster + intent (informational / commercial / transactional) from the `marketing-strategy` ICP.
- First 100 words answer the query directly, in the user's vocabulary.
- Headings phrased as the questions users actually type.
- Internal links with descriptive anchors to related pages (build topical depth).
- No thin content: every page earns its place or gets merged/removed.

## 3. GEO / AEO — get cited by AI engines
- Add JSON-LD for the page's real entities (templates below).
- Self-contained answer chunks: claim + supporting fact + number/date in one place.
- Definitive, sourced statements beat hedged prose. AI engines quote specifics.
- FAQPage blocks mirroring real questions → double duty (AI answers + rich results).

## JSON-LD templates (validate before shipping)
```html
<!-- Organization (site-wide, in <head> of home) -->
<script type="application/ld+json">
{ "@context":"https://schema.org","@type":"Organization",
  "name":"<Brand>","url":"https://<domain>","logo":"https://<domain>/logo.png",
  "sameAs":["https://x.com/<handle>","https://linkedin.com/company/<slug>"] }
</script>

<!-- SoftwareApplication / Product -->
<script type="application/ld+json">
{ "@context":"https://schema.org","@type":"SoftwareApplication",
  "name":"<Product>","applicationCategory":"<category>","operatingSystem":"Web",
  "offers":{"@type":"Offer","price":"0","priceCurrency":"USD"} }
</script>

<!-- FAQPage -->
<script type="application/ld+json">
{ "@context":"https://schema.org","@type":"FAQPage","mainEntity":[
  {"@type":"Question","name":"<question>",
   "acceptedAnswer":{"@type":"Answer","text":"<concise factual answer>"}} ]}
</script>

<!-- BreadcrumbList -->
<script type="application/ld+json">
{ "@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
  {"@type":"ListItem","position":1,"name":"Home","item":"https://<domain>"},
  {"@type":"ListItem","position":2,"name":"<section>","item":"https://<domain>/<section>"} ]}
</script>
```

## Validate
- JSON parses; `@type` is a real schema.org type; `@context` is `https://schema.org`.
- Test rich results (Google Rich Results Test) and run Lighthouse SEO + Performance before calling it done.
