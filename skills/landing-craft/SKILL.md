---
name: landing-craft
description: "Trigger: build/create/make a landing page, marketing site, product page, hero section, sales page, waitlist, 'armame una landing', 'landing que venda', 'una web que no parezca hecha con IA'. An end-to-end, phased workflow that ASKS the questions it needs (intake), then autonomously runs strategy, copy, visual design, build, motion (configurable depth — subtle/medium/rich, with smooth scroll, card hovers, magnetic/tilt via Motion+GSAP+Lenis), polish, SEO and review, and DEPLOYS the result (GitHub + Vercel) — shipping a modern, elegant, intuitive, high-converting landing that does NOT look AI-generated, ready to view live. Next.js + Tailwind by default (no hardcoded tokens); remembers your style preferences."
license: Apache-2.0
metadata:
  author: propiter
  version: "1.4.0"
---

# Landing Craft

A landing page is not a template you fill in. It's an argument that earns a click. This skill is
the **orchestrator**: when someone asks for a landing, you don't write it all yourself — you run
a phased pipeline and delegate each phase to a specialist sub-agent, exactly like SDD does for
features. Your job is to hold one thin thread, launch the right agent at the right time, pass
artifacts between them, and guard the quality bar.

## The Prime Directive

Every landing this workflow ships must clear FIVE bars. If any fails, it is not done:

1. **It does NOT look AI-generated.** No centered-everything, no untouched component library, no
   purple gradient, no generic hero→3-cards→CTA with lorem spacing. Distinct, intentional, modern.
2. **It sells.** A stranger understands *what it is, who it's for, why it's better, and what to do
   next* within 5 seconds of the hero.
3. **It's intuitive.** One obvious primary action per screen. Nothing makes the user think about
   the interface instead of the offer.
4. **It's crafted.** 60fps motion with restraint, real type/spacing/contrast, accessible, fast.
5. **It's ALIVE — it has a vibe.** Real imagery (NOT a generic UI mock on a dark gradient), a
   signature visual idea that's THIS brand, colour with warmth/contrast (not one cold hue), and
   **scroll-reactive motion** — things enter and move as you scroll. "Pretty but generic/dead"
   fails this bar. Run the vibe test in `references/alive-not-generic.md` before sign-off.

## The Pipeline (the DAG)

```
  intake ─► strategy ─┬─► copy ───┐
   (ASK)              └─► design ──┴─► build ─► motion ─► polish ─┐
                                            build ─► seo ─────────┴─► review ⭯ ─► deploy
```

- **Intake** (Phase 0): ASK the user the few questions that change the output, THEN run. Never start blind.
- **Planning**: `strategy → {copy, design}`
- **Production**: `build → motion → polish`, with `seo` in parallel off `build`
- **Gate**: `review` renders and critiques; it LOOPS back to polish/build until it passes.
- **Deploy** (Phase 9): publish to GitHub (gh) + ship to Vercel — hand the user a live URL. In auto mode, SEO and deploy are NOT optional.

## Phase → Sub-agent map

Delegate each phase to its agent via the Task/Agent mechanism. Each agent loads the deep skill it
needs (we already own them) and returns a structured artifact. Pass the prior artifacts forward.

| Phase | Sub-agent | Loads / leans on | Produces |
|-------|-----------|------------------|----------|
| 0. Intake | *orchestrator* | `AskUserQuestion` | the brief — product, audience, the one action, tone, framework, proof, deploy target |
| 1. Strategy | `landing-strategy` | `marketing-strategy` | positioning, ICP/JTBD, core promise, offer, proof inventory |
| 2. Copy | `landing-copy` | `brand-voice` | section-by-section message + conversion copy (anti-slop) |
| 3. Design | `landing-design` | Impeccable, `web-assets` | visual direction (DESIGN.md): type/colour/space scale, component style, references |
| 4. Build | `landing-build` | the target framework | the actual landing code (Next.js default) |
| 5. Motion | `landing-motion` | `motion-craft` | reveals, micro-interactions, one hero moment — all reduced-motion safe |
| 6. Polish | `landing-polish` | Impeccable, a11y | aesthetic pass, responsive, contrast, focus states |
| 7. SEO | `landing-seo` | `seo-geo` | meta/OG/schema/perf, Core Web Vitals, llms.txt |
| 8. Review | `landing-review` | `design-review-loop` | render at 390/768/1440 + conversion heuristics → pass/fail + fixes |
| 9. Deploy | `landing-deploy` | `gh`, Vercel CLI | repo pushed + a live URL; installs the CLI if missing & guides first-time auth |

## How to run it

Detect the mode from the request; if unclear, ask once.

- **`/landing <prompt>`** → the flagship. INTAKE first (ask the few questions that matter via
  `AskUserQuestion`), then run EVERY phase autonomously through review, then DEPLOY. Hands you a
  live URL. This is the "one prompt → ask what's needed → build → deployed" flow.
- **`/landing-new <brief>`** → run Planning only (strategy → copy + design), then STOP and show the
  plan + visual direction for approval before building.
- **`/landing-build`** → run Production (build → motion → polish, + seo) on the approved plan.
- **`/landing-review`** → run the review loop and apply fixes (max 3 passes).
- **`/landing-ship <brief>`** → full auto: every phase end-to-end, stopping only if a gate fails.

**Interactive vs Auto:** default to Interactive — pause after each phase, show the artifact, ask
"¿seguimos o ajustamos?". Switch to Auto only when the user asks for speed.

## Phase 0 — Intake (ASK before you build)

First, **load the user's saved style profile** from engram (`mem_search` topic
`landing-craft/style-profile`): animation intensity (default `medium`), framework = Next.js +
Tailwind ALWAYS, no hardcoded tokens. Use these as defaults — don't re-ask what's already known.

When the request is just "quiero una landing de X", ask the few questions that actually change the
output — `AskUserQuestion` (one round, 3–5). If the user gives a URL/existing site, SCRAPE it first
(Firecrawl/WebFetch) and only ask what you couldn't infer. Ask for:

1. **Producto** — qué hace y qué problema resuelve.
2. **Audiencia** — quién compra / a quién le hablás.
3. **La acción** — qué querés que haga (agendar, comprar, registrarse…).
4. **Tono/marca** — colores, logo, referencias, o "inferilo del producto".
5. **Nivel de animación** — `menos` / `medio` (default) / `más`. Pre-fill from the saved profile.
6. **Prueba/assets** — logos, números, testimonios, links.
7. **Deploy** — ¿publico a Vercel al terminar? (preview por defecto).

**Do NOT ask about framework** — it's Next.js + Tailwind always (switch only if the user explicitly
says so). If the user states a lasting preference ("siempre con muchas animaciones"), **update the
style profile** (`mem_save` same topic key) so it sticks across future landings. If they can't
answer the marketing questions, draft them in strategy and confirm — never skip strategy.

## Phase 9 — Deploy (hands-off; the user only opens a URL)

After review PASSES, delegate to `landing-deploy`. Goal: the user does nothing but open a live URL.

1. **GitHub** — if `gh` is authenticated, create + push the repo (`gh repo create … --source … --push`).
2. **Vercel — no terminal for the user.** If the `vercel` CLI is missing, **install it**
   (`npm i -g vercel`). Then `vercel whoami`; if not authed, run **`vercel login` in the BACKGROUND**
   — it **auto-opens the user's browser** to the device-approval page (code pre-filled; they just
   click Approve). Tell them to approve the tab that opened; the printed `Visit https://…/oauth/device`
   link is only a fallback if the browser didn't open (don't have them paste it by hand). Poll
   `vercel whoami` until it returns a user; the session then **persists forever** (every future
   deploy is fully automatic). Create + name the project first (`vercel project add <name>` — needed
   because `--project` requires an existing project), then deploy from the build dir:
   `vercel deploy --yes --cwd <build-dir> --project <name>`. `vercel --prod` to promote on approval.
3. **The public URL is the project's production `*.vercel.app` alias** — NOT the deployment-specific
   URL, which sits behind Vercel's default auth protection (401). Verify with a curl (expect 200 +
   your `<title>`) before handing it over. **Redeploy on updates:** `vercel deploy` again in the
   linked dir updates the same project. Hand back the **public URL** + the repo URL.

Never auto-promote a first draft straight to production. Preview first, prod on approval.

## Artifacts & continuity

Write each phase's output to `landing/` in the project (`strategy.md`, `copy.md`, `design.md`,
`review.md`) so phases compose and the work survives a restart. If engram is available, also save
under topic keys `landing/<name>/<phase>`. Later phases READ the earlier artifacts — pass paths,
not full content, to keep the thread thin.

## Anti-slop guardrails (enforced at every phase)

- **No section without a job.** Every block earns its place (attention, desire, proof, objection,
  action). If you can't name its job, cut it.
- **One primary CTA**, repeated; everything else is secondary/ghost.
- **Specifics over adjectives.** "Factura ante la DIAN en 60s" beats "la mejor solución innovadora".
- **Real visual decisions** — a deliberate type scale, a real colour system, generous spacing,
  asymmetry where it helps. Never the framework defaults untouched.
- **Tailwind + Next.js, no hardcoded tokens** — design tokens live in `tailwind.config`; components
  use utility classes that reference them. Next.js is the default stack (switch only if told).
- **Motion with configurable DEPTH, not flat** — apply the user's chosen intensity
  (`subtle`/`medium`/`rich`, default medium) per `references/animation-levels.md` (Motion · GSAP ·
  Lenis · Aceternity/Magic UI: card hovers, smooth scroll, counters, magnetic/tilt at the top end).
  Never flat, never chaotic — one signal per viewport; always `prefers-reduced-motion`.
- **Accessible & fast** — AA contrast **MEASURED, not eyeballed** (run the scorer in
  `references/contrast-check.md`; it's a hard gate before deploy), focus states, semantic HTML,
  Core Web Vitals green.

See `references/playbook.md` for the conversion architecture (section sequence, hero formula,
proof patterns, CTA rules) — load it before phase 2.

## Output Contract

When the workflow finishes, report: the live preview URL (dev server), the phases run, the
positioning one-liner, the primary CTA, the review verdict (what passed / what was fixed), and the
remaining follow-ups. Never declare "done" until `landing-review` returns a pass.
