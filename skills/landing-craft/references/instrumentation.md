# Instrumentation — leave it production-ready (analytics, consent, forms, sitemap/robots)

A landing that can't measure or convert is half-built. Wire all of this so the user only has to drop
in their IDs. Use env vars for IDs (placeholders the user fills) — never hardcode account IDs.

## 1. Analytics — GA4 and/or Google Tag Manager
On **Next.js**, use `@next/third-parties/google` (official, performance-safe — loads after hydration):

```tsx
// app/layout.tsx
import { GoogleAnalytics, GoogleTagManager } from '@next/third-parties/google'
// ...inside <body>, after children:
{process.env.NEXT_PUBLIC_GTM_ID && <GoogleTagManager gtmId={process.env.NEXT_PUBLIC_GTM_ID} />}
{process.env.NEXT_PUBLIC_GA_ID  && <GoogleAnalytics  gaId={process.env.NEXT_PUBLIC_GA_ID} />}
```

- Prefer **GTM** when the user will manage many tags (ads pixels, etc.); **GA4 directly** for just
  analytics. Wire BOTH behind env so the user picks.
- Env: `NEXT_PUBLIC_GA_ID` (`G-XXXX`), `NEXT_PUBLIC_GTM_ID` (`GTM-XXXX`). Put placeholders in
  `.env.example` and document them in the README.

## 2. Conversion tracking — the CTA is the whole point
Fire an event on the primary CTA so the user can see conversions:
```tsx
onClick={() => window.gtag?.('event', 'generate_lead', { cta: 'hero_agendar' })}
```
Track the form submit and any signup/booking too. Name events consistently.

## 3. Consent (GDPR/cookies) — required with analytics/ads
Ship a small **cookie-consent banner** and gate non-essential tags behind it (Google **Consent
Mode v2**: default denied → granted on accept). Keep essential cookies working without consent. Don't
load ad/analytics scripts before consent in EU traffic.

## 4. Forms that actually work — not decorative
A contact/lead form must submit somewhere real. Pick per the user's setup:
- a **Next.js route handler** (`app/api/contact/route.ts`) → email (Resend) / their **n8n webhook** /
  a sheet; OR
- a no-backend option (**Formspree**, **Web3Forms**) via env-configured endpoint.
Validate, show success/error states, honeypot for spam. Never leave a `<form>` that goes nowhere.

## 5. SEO infrastructure (Next App Router)
- `app/sitemap.ts` → generate `sitemap.xml` for ALL pages (incl. blog posts).
- `app/robots.ts` → `robots.txt` (allow + point to the sitemap).
- Per-page `metadata` (title/description) + canonical; OG/Twitter image (generate via `web-assets`).
- JSON-LD per page (Organization / Product / FAQPage / BreadcrumbList / Article for posts).
- `llms.txt` for AI-search discoverability (per `seo-geo`).

## 6. Performance & misc to leave ready
- Analytics/scripts load after interactive (`@next/third-parties` handles this) — don't block LCP.
- `favicon` + PWA icons + `apple-touch-icon` (via `web-assets`), `theme-color`, `manifest.json`.
- A `404`/`not-found` page on brand.
- `.env.example` listing every var; README documents what the user must fill (GA/GTM IDs, form
  endpoint, production URL for canonical).

## Output
The SEO + analytics + consent + forms are all wired behind env placeholders, and `.env.example` +
the README tell the user exactly what to fill. Nothing is left as a dead stub.
